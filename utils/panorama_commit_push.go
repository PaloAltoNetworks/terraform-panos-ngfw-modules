package main

import (
	"flag"
	"log"
	"os"
	"strings"
	"time"

	"github.com/PaloAltoNetworks/pango"
	"github.com/PaloAltoNetworks/pango/commit"
)

const COMMIT_ERROR = 1
const PUSH_TEMPLATE_ERROR = 2
const PUSH_DEVICE_GROUP_ERROR = 3

func main() {
	var (
		err                                                                                                 error
		configFile, hostname, username, password, apiKey, admins, devices, deviceGroup, templateStack, mode string
		edan, eso, epao, force, debug                                                                       bool
		jobId                                                                                               uint
		sleep                                                                                               int64
		timeout                                                                                             int
	)

	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds)

	flag.StringVar(&configFile, "config", "", "JSON config file with panos connection info")
	flag.StringVar(&hostname, "host", "", "PAN-OS hostname")
	flag.StringVar(&username, "user", "", "PAN-OS username")
	flag.StringVar(&password, "pass", "", "PAN-OS password")
	flag.StringVar(&apiKey, "key", "", "PAN-OS API key")
	flag.StringVar(&admins, "admins", "", "CSV of specific admins for partial config commit")
	flag.StringVar(&deviceGroup, "deviceGroup", "", "Device group")
	flag.StringVar(&devices, "devices", "", "Devices")
	flag.StringVar(&templateStack, "templateStack", "", "Template stack")
	flag.StringVar(&mode, "mode", "commit", "Mode: commit or push")
	flag.BoolVar(&edan, "exclude-device-and-network", false, "Exclude device and network")
	flag.BoolVar(&eso, "exclude-shared-objects", false, "Exclude shared objects")
	flag.BoolVar(&epao, "exclude-policy-and-objects", false, "Exclude policy and objects")
	flag.BoolVar(&force, "force", false, "Force a commit even if one isn't needed")
	flag.BoolVar(&debug, "debug", false, "Detailed logging for debugging")
	flag.Int64Var(&sleep, "sleep", 0, "Seconds to sleep between checks for commit completion")
	flag.IntVar(&timeout, "timeout", 10, "The timeout for all PAN-OS API calls")
	flag.Parse()

	// Connect to the firewall.
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
		panorama.Logging = pango.LogOp | pango.LogAction | pango.LogSend | pango.LogReceive | pango.LogLog | pango.LogUid
	}

	// Build the commit to be performed.
	cmdCommit := commit.PanoramaCommit{}
	cmdPushTemplateStack := commit.PanoramaCommitAll{}
	cmdPushDeviceGroups := commit.PanoramaCommitAll{}

	if mode == "commit" {
		cmdCommit := commit.PanoramaCommit{
			Description:             flag.Arg(0),
			ExcludeDeviceAndNetwork: edan,
			ExcludeSharedObjects:    eso,
			Force:                   force,
		}
		admins = strings.TrimSpace(admins)
		if admins != "" {
			cmdCommit.Admins = strings.Split(admins, ",")
		}
		deviceGroup = strings.TrimSpace(deviceGroup)
		if deviceGroup != "" {
			cmdCommit.DeviceGroups = strings.Split(deviceGroup, ",")
		}
	} else {
		cmdPushTemplateStack = commit.PanoramaCommitAll{
			Type:                commit.TypeTemplateStack,
			Name:                templateStack,
			Description:         flag.Arg(0),
			ForceTemplateValues: true,
		}
		cmdPushDeviceGroups = commit.PanoramaCommitAll{
			Type:            commit.TypeDeviceGroup,
			Name:            deviceGroup,
			Description:     flag.Arg(0),
			IncludeTemplate: true,
		}
		devices = strings.TrimSpace(devices)
		if devices != "" {
			cmdPushDeviceGroups.Devices = strings.Split(devices, ",")
			cmdPushTemplateStack.Devices = strings.Split(devices, ",")
		}
	}
	sd := time.Duration(sleep) * time.Second

	// Perform the commit
	if mode == "commit" {
		log.Printf("Commit: %s\n", deviceGroup)
		jobId, _, err = panorama.Commit(cmdCommit, "", nil)
		if err != nil {
			log.Fatalf("Fatal error in commit: %s", err)
			os.Exit(COMMIT_ERROR)
		} else if jobId == 0 {
			log.Printf("No commit needed")
		} else if err = panorama.WaitForJob(jobId, sd, nil, nil); err != nil {
			log.Printf("Error in commit: %s", err)
			os.Exit(COMMIT_ERROR)
		} else {
			log.Printf("Committed config successfully")
		}
	} else {
		log.Printf("Commit all - device group: %s\n", deviceGroup)
		jobId, _, err = panorama.Commit(cmdPushDeviceGroups, "", nil)
		if err != nil {
			log.Fatalf("Fatal error in push: %s", err)
			os.Exit(PUSH_DEVICE_GROUP_ERROR)
		} else if jobId == 0 {
			log.Printf("No push needed")
		} else if err = panorama.WaitForJob(jobId, sd, nil, nil); err != nil {
			log.Printf("Error in push: %s", err)
			os.Exit(PUSH_DEVICE_GROUP_ERROR)
		} else {
			log.Printf("Pushed config successfully")
		}

		log.Printf("Commit all - template stack: %s\n", templateStack)
		jobId, _, err = panorama.Commit(cmdPushTemplateStack, "", nil)
		if err != nil {
			log.Fatalf("Fatal error in push: %s", err)
			os.Exit(PUSH_TEMPLATE_ERROR)
		} else if jobId == 0 {
			log.Printf("No push needed")
		} else if err = panorama.WaitForJob(jobId, sd, nil, nil); err != nil {
			log.Printf("Error in push: %s", err)
			os.Exit(PUSH_TEMPLATE_ERROR)
		} else {
			log.Printf("Pushed config successfully")
		}
	}
}
