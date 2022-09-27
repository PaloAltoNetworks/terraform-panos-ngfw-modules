package main

import (
	"flag"
	"log"
	"strings"
	"time"

	"github.com/PaloAltoNetworks/pango"
	"github.com/PaloAltoNetworks/pango/commit"
)

func main() {
	var (
		err                                                                                           error
		configFile, hostname, username, password, apiKey, admins, devices, deviceGroup, templateStack string
		edan, eso, epao, force                                                                        bool
		jobId                                                                                         uint
		sleep                                                                                         int64
		timeout                                                                                       int
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
	flag.BoolVar(&edan, "exclude-device-and-network", false, "Exclude device and network")
	flag.BoolVar(&eso, "exclude-shared-objects", false, "Exclude shared objects")
	flag.BoolVar(&epao, "exclude-policy-and-objects", false, "Exclude policy and objects")
	flag.BoolVar(&force, "force", false, "Force a commit even if one isn't needed")
	flag.Int64Var(&sleep, "sleep", 0, "Seconds to sleep between checks for commit completion")
	flag.IntVar(&timeout, "timeout", 10, "The timeout for all PAN-OS API calls")
	flag.Parse()

	// Connect to the firewall.
	panorama := &pango.Panorama{Client: pango.Client{
		Hostname: hostname,
		Username: username,
		Password: password,
		ApiKey:   apiKey,
		Logging:  pango.LogOp | pango.LogAction | pango.LogSend | pango.LogReceive | pango.LogLog | pango.LogUid,
		Timeout:  timeout,
	}}
	if err = panorama.InitializeUsing(configFile, true); err != nil {
		log.Fatalf("Failed: %s", err)
	}

	// Build the commit to be performed.
	cmdTemplateStack := commit.PanoramaCommitAll{
		Type:                commit.TypeTemplateStack,
		Name:                templateStack,
		Description:         flag.Arg(0),
		ForceTemplateValues: true,
	}
	cmdDeviceGroup := commit.PanoramaCommitAll{
		Type:            commit.TypeDeviceGroup,
		Name:            deviceGroup,
		Description:     flag.Arg(0),
		IncludeTemplate: true,
	}
	log.Printf("Devices: %s\n", devices)
	devices = strings.TrimSpace(devices)
	if devices != "" {
		cmdDeviceGroup.Devices = strings.Split(devices, ",")
		cmdTemplateStack.Devices = strings.Split(devices, ",")
	}
	log.Printf("Devices list: %s\n", cmdDeviceGroup.Devices)

	sd := time.Duration(sleep) * time.Second

	// Perform the commit
	log.Printf("Commit all - template stack\n")
	jobId, _, err = panorama.Commit(cmdTemplateStack, "", nil)
	if err != nil {
		log.Fatalf("Error in commit: %s", err)
	} else if jobId == 0 {
		log.Printf("No commit needed")
	} else if err = panorama.WaitForJob(jobId, sd, nil, nil); err != nil {
		log.Printf("Error in commit: %s", err)
	} else {
		log.Printf("Committed config successfully")
	}

	log.Printf("Commit all - device group\n")
	jobId, _, err = panorama.Commit(cmdDeviceGroup, "", nil)
	if err != nil {
		log.Fatalf("Error in commit: %s", err)
	} else if jobId == 0 {
		log.Printf("No commit needed")
	} else if err = panorama.WaitForJob(jobId, sd, nil, nil); err != nil {
		log.Printf("Error in commit: %s", err)
	} else {
		log.Printf("Committed config successfully")
	}
}
