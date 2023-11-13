package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"strings"
	"time"

	"github.com/PaloAltoNetworks/pango"
	"github.com/PaloAltoNetworks/pango/commit"
)

const RetryInterval = 5

type ConfigParameters struct {
	deviceGroup   string
	templateStack string
	mode          string
	admins        string
	devices       string
	validate      bool
	edan          bool
	eso           bool
	force         bool
}

func main() {
	var (
		err                                                                                                 error
		configFile, hostname, username, password, apiKey, admins, devices, deviceGroup, templateStack, mode string
		edan, eso, epao, force, debug, validate                                                             bool
		sleep                                                                                               int64
		timeout                                                                                             int
	)
	setFlag(&configFile, &hostname, &username, &password, &apiKey, &admins, &deviceGroup, &devices, &templateStack,
		&mode, &edan, &eso, &epao, &force, &debug, &validate, &sleep, &timeout)
	sd := time.Duration(sleep) * time.Second
	maxRetires := 30
	panorama := configureClient(hostname, username, password, apiKey, timeout, configFile, err, debug)

	clientConfig := ConfigParameters{
		deviceGroup:   deviceGroup,
		templateStack: templateStack,
		admins:        admins,
		devices:       devices,
		validate:      false,
		edan:          edan,
		eso:           eso,
		force:         force,
	}

	deviceLocking(panorama, deviceGroup, username, err, maxRetires, mode)
	if validate {
		clientConfig.mode = "validate"
		cmdValidate := configurePayloadSchema(clientConfig)
		performCommitOrValidateCommand(panorama, cmdValidate, sd, "validate", deviceGroup)
	}

	// Build the commit to be performed.
	var cmdCommit interface{}
	var cmdPushTemplateStack interface{}
	var cmdPushDeviceGroups interface{}
	admins = strings.TrimSpace(admins)
	if mode == "commit" {
		clientConfig.mode = "commit"
		cmdCommit = configurePayloadSchema(clientConfig)
	} else if mode == "push" {
		clientConfig.mode = "pushTemplate"
		cmdPushTemplateStack = configurePayloadSchema(clientConfig)
		clientConfig.mode = "pushDevice"
		cmdPushDeviceGroups = configurePayloadSchema(clientConfig)
	}

	// Perform the commit
	if mode == `commit` {
		performCommitOrValidateCommand(panorama, cmdCommit, sd, "commit", deviceGroup)
	} else if mode == `push` {
		if validate {
			cmdValidateConfig := clientConfig
			cmdValidateConfig.validate = true
			cmdPushValidateDeviceGroup := configurePayloadSchema(cmdValidateConfig)
			cmdPushValidateTemplateStack := configurePayloadSchema(cmdValidateConfig)

			performCommitOrValidateCommand(panorama, cmdPushValidateDeviceGroup, sd, "validate push", deviceGroup)
			performCommitOrValidateCommand(panorama, cmdPushValidateTemplateStack, sd, "validate push", deviceGroup)

		}
		performCommitOrValidateCommand(panorama, cmdPushDeviceGroups, sd, "push", deviceGroup)
		performCommitOrValidateCommand(panorama, cmdPushTemplateStack, sd, "push", deviceGroup)
	}
}

func performCommitOrValidateCommand(panorama *pango.Panorama, cmd interface{}, sd time.Duration, cmdType string, deviceGroup string) {
	log.Printf("Start performing %s", cmdType)
	var jobId uint
	var err error

	switch cmdType {
	case "validate":
		jobId, _, err = panorama.ValidateConfig(cmd)
	case "commit":
		jobId, _, err = panorama.Commit(cmd, "", nil)
	}

	if err != nil {
		log.Fatalf("Fatal error in %s: %s", cmdType, err)
	} else if jobId == 0 {
		log.Printf("No %s needed", cmdType)
	} else if err = panorama.WaitForJob(jobId, sd, nil, nil); err != nil {
		log.Printf("Error in %s: %s", cmdType, err)
		// sometimes there are problems with unmarshalling, but changes are committed
		if !strings.Contains(fmt.Sprintf("%s", err), "Error unmarshalling") {
			os.Exit(1)
		}
	} else {
		log.Printf("%s successfully", cmdType)
	}
}

func configurePayloadSchema(c ConfigParameters) interface{} {
	var confStruct interface{}

	switch c.mode {
	case "commit":
		cmdCommit := commit.PanoramaCommit{
			Description:             flag.Arg(0),
			ExcludeDeviceAndNetwork: c.edan,
			ExcludeSharedObjects:    c.eso,
			Force:                   c.force,
		}
		if deviceGroup := strings.TrimSpace(c.deviceGroup); deviceGroup != "" {
			cmdCommit.DeviceGroups = strings.Split(deviceGroup, ",")
		}
		if c.admins != "" {
			adminList := strings.Split(c.admins, ",")
			cmdCommit.Admins = adminList
		}
		confStruct = cmdCommit
	case "pushTemplate":
		cmdPushTemplate := commit.PanoramaCommitAll{
			Type:                commit.TypeTemplateStack,
			Name:                c.templateStack,
			Description:         flag.Arg(0),
			ForceTemplateValues: true,
			ValidateOnly:        c.validate,
		}
		if c.admins != "" {
			adminList := strings.Split(c.admins, ",")
			cmdPushTemplate.Admins = adminList
		}
		confStruct = cmdPushTemplate
	case "pushDevice":
		cmdPushDevice := commit.PanoramaCommitAll{
			Type:            commit.TypeDeviceGroup,
			Name:            c.deviceGroup,
			Description:     flag.Arg(0),
			IncludeTemplate: true,
			ValidateOnly:    c.validate,
		}
		devices := strings.TrimSpace(c.devices)
		if devices != "" {
			cmdPushDevice.Devices = strings.Split(devices, ",")
			cmdPushDevice.Devices = strings.Split(devices, ",")
		}
		if c.admins != "" {
			adminList := strings.Split(c.admins, ",")
			cmdPushDevice.Admins = adminList
		}
		confStruct = cmdPushDevice
	case "validate":
		cmdValidate := commit.PanoramaValidate{
			ExcludeSharedObjects:    c.eso,
			ExcludeDeviceAndNetwork: c.edan,
		}
		if c.admins != "" {
			adminList := strings.Split(c.admins, ",")
			cmdValidate.Admins = adminList
		}
		confStruct = cmdValidate
	}

	return confStruct
}

func configureClient(hostname string, username string, password string, apiKey string, timeout int, configFile string, err error, debug bool) *pango.Panorama {
	log.Printf("Configure PAN-OS Client.")
	panorama := &pango.Panorama{Client: pango.Client{
		Hostname: hostname,
		Username: username,
		Password: password,
		ApiKey:   apiKey,
		Logging:  pango.LogQuiet,
		Timeout:  timeout,
	}}
	if err = panorama.InitializeUsing(configFile, true); err != nil {
		log.Fatalf("Failed: %s", err)
	}
	if debug {
		panorama.Logging = pango.LogOp | pango.LogAction | pango.LogSend | pango.LogReceive | pango.LogLog | pango.LogUid | pango.LogQuery | pango.LogXpath
	}
	return panorama
}

func setFlag(configFile *string, hostname *string, username *string, password *string, apiKey *string, admins *string,
	deviceGroup *string, devices *string, templateStack *string, mode *string, edan *bool, eso *bool, epao *bool, force *bool,
	debug *bool, validate *bool, sleep *int64, timeout *int) {
	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds)

	flag.StringVar(configFile, "config", "", "JSON config file with panos connection info")
	flag.StringVar(hostname, "host", "", "PAN-OS hostname")
	flag.StringVar(username, "user", "", "PAN-OS username")
	flag.StringVar(password, "pass", "", "PAN-OS password")
	flag.StringVar(apiKey, "key", "", "PAN-OS API key")
	flag.StringVar(admins, "admins", "", "CSV of specific admins for partial config commit")
	flag.StringVar(deviceGroup, "deviceGroup", "", "Device group")
	flag.StringVar(devices, "devices", "", "Devices")
	flag.StringVar(templateStack, "templateStack", "", "Template stack")
	flag.StringVar(mode, "mode", "", "Mode: commit or push")
	flag.BoolVar(edan, "exclude-device-and-network", false, "Exclude device and network")
	flag.BoolVar(eso, "exclude-shared-objects", false, "Exclude shared objects")
	flag.BoolVar(epao, "exclude-policy-and-objects", false, "Exclude policy and objects")
	flag.BoolVar(force, "force", false, "Force a commit even if one isn't needed")
	flag.BoolVar(debug, "debug", false, "Detailed logging for debugging")
	flag.BoolVar(validate, "validate", false, "Enable commit validation first")
	flag.Int64Var(sleep, "sleep", 0, "Seconds to sleep between checks for commit completion")
	flag.IntVar(timeout, "timeout", 10, "The timeout for all PAN-OS API calls")
	flag.Parse()
}

func deviceLocking(panorama *pango.Panorama, deviceGroup string, username string, err error, maxRetries int, mode string) {
	configLocked := false
	commitLocked := false
	lockConfig := func(configLock *bool) {
		*configLock = true
		log.Printf("Config for dg:%s for user:%s is locked!", deviceGroup, username)
		if err = panorama.Client.LockConfig(deviceGroup, "Automated candidate config locking"); err != nil {
			log.Print(err)
		}
	}

	log.Printf("Check for Commit lock for dg: %s", deviceGroup)
	for maxRetries > 0 {
		maxRetries--
		// Commit locking check
		if commitLocks, err := panorama.Client.ShowCommitLocks(deviceGroup); err != nil {
			log.Fatalf("Failed: %s", err.Error())
		} else {
			commitLocked = false
			for _, commitLocks := range commitLocks {
				if username != commitLocks.Owner {
					commitLocked = true
					log.Printf("Warning: admin '%s' already has commit lock of type '%s'", commitLocks.Owner, commitLocks.Type)
				} else {
					commitLocked = true
				}
				log.Printf("Waiting: Lock is acquire, contact with Admin %s for release it.", commitLocks.Owner)
			}
		}
		if !commitLocked {
			break
		}
		time.Sleep(RetryInterval * time.Second)
	}

	if commitLocked {
		log.Fatal("Error: another admin is holding commit lock or error requesting commit lock state.")
	}

	if mode == "lock" {
		log.Printf("Set mode to lock for dg: %s \n", deviceGroup)
		for maxRetries > 0 {
			maxRetries--
			dgLocks, _ := panorama.Client.ShowConfigLocks(deviceGroup)
			// Check if there is any lock
			if len(dgLocks) > 0 {
				for _, dgLocks := range dgLocks {
					// Check if there is any lock related to the provided Device Group
					if dgLocks.Name == deviceGroup {
						// If there is a lock related to the Device group but locked by someone else
						if dgLocks.Owner != username {
							log.Printf("Warning: admin %s has config lock on device group %s", dgLocks.Owner, dgLocks.Name)
						}
						log.Print("Waiting: Lock is acquire, waiting for release...")
					} else {
						lockConfig(&configLocked)
						break
					}
				}
			} else {
				lockConfig(&configLocked)
				break
			}
			time.Sleep(RetryInterval * time.Second)
		}
		if !configLocked {
			log.Fatalf("Error: Config lock was not acquired after %d retries", maxRetries)
		}
	}

	if mode == "unlock" {
		dgLocks, _ := panorama.Client.ShowConfigLocks(deviceGroup)
		// Check if there is any lock
		if len(dgLocks) > 0 {
			for _, dgLocks := range dgLocks {
				// Check if there is any lock related to the provided Device Group
				if dgLocks.Name == deviceGroup {
					if dgLocks.Owner == username {
						if err = panorama.Client.UnlockConfig(deviceGroup); err != nil {
							log.Fatalf("There was an error trying to unlock dg: %s, error: %s", deviceGroup, err)
						} else {
							log.Printf("Config for dg:%s for user:%s was unlocked succesfully!", deviceGroup, username)
						}
					}
				}
			}
		}
	}

}
