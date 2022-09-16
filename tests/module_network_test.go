package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestOutputsForCsvBasicExampleAndForVmSeries(t *testing.T) {
	// given
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/csv_examples/csv_basic_example",
		Vars: map[string]interface{}{
			"pan_creds":     "../../../tests/creds/vmseries.json",
			"panorama_mode": false,
		},
		Logger:  logger.Discard,
		Lock:    true,
		Upgrade: true,
	})
	expected_zone := []string{"Trust-L3", "Untrust-L3", "external", "internal", "mgmt", "vpn"}
	expected_zone_entry := map[string]interface{}{
		"ethernet1/1": map[string]interface{}{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"ethernet1/2": map[string]interface{}{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"ethernet1/3": map[string]interface{}{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"ethernet1/4": map[string]interface{}{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"loopback.42": map[string]interface{}{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"tunnel.42": map[string]interface{}{
			"mode": "layer3",
			"vsys": "vsys1",
		},
	}
	expected_panos_ethernet_interface := map[string]interface{}{
		"ethernet1/1": map[string]interface{}{
			"comment":                   "mgmt",
			"create_dhcp_default_route": false,
			"enable_dhcp":               false,
			"mode":                      "layer3",
			"vsys":                      "vsys1",
		},
		"ethernet1/2": map[string]interface{}{
			"comment":                   "external",
			"create_dhcp_default_route": false,
			"enable_dhcp":               false,
			"mode":                      "layer3",
			"vsys":                      "vsys1",
		},
		"ethernet1/3": map[string]interface{}{
			"comment":                   "internal",
			"create_dhcp_default_route": false,
			"enable_dhcp":               false,
			"mode":                      "layer3",
			"vsys":                      "vsys1",
		},
		"ethernet1/4": map[string]interface{}{
			"comment":                   "internal",
			"create_dhcp_default_route": false,
			"enable_dhcp":               false,
			"mode":                      "layer3",
			"vsys":                      "vsys1",
		},
	}
	// defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)
	actual_zones := terraform.OutputList(t, terraformOptions, "panos_zones")
	actual_zone_entry := terraform.OutputMapOfObjects(t, terraformOptions, "panos_zone_entry")
	actual_panos_ethernet_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ethernet_interface")

	// then
	assert.Equal(t, expected_zone, actual_zones)
	assert.Equal(t, expected_zone_entry, actual_zone_entry)
	assert.Equal(t, expected_panos_ethernet_interface, actual_panos_ethernet_interface)
}

/*
	there is panos provider error while testing with enabled panorama_mode:

	Stack trace from the terraform-provider-panos_v1.10.3 plugin:
	panic: interface conversion: interface {} is *pango.Panorama, not *pango.Firewall
	goroutine 93 [running]:
	...
*/

// func TestOutputsForCsvBasicExampleAndForPanorama(t *testing.T) {
// 	// given
// 	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
// 		TerraformDir: "../examples/csv_examples/csv_basic_example",
// 		Vars: map[string]interface{}{
// 			"pan_creds":     "../../../tests/creds/panorama.json",
// 			"panorama_mode": true,
// 		},
// 		Logger:  logger.Discard,
// 		Lock:    true,
// 		Upgrade: true,
// 	})
// 	expected_zone := []string{"Trust-L3", "Untrust-L3", "external", "internal", "mgmt", "vpn"}
// 	defer terraform.Destroy(t, terraformOptions)

// 	// when
// 	terraform.InitAndApply(t, terraformOptions)
// 	actual_zones := terraform.OutputList(t, terraformOptions, "panos_zones")

// 	// then
// 	assert.Equal(t, expected_zone, actual_zones)
// }
