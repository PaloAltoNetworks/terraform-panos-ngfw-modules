package test

import (
	"fmt"
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
		"ethernet1/1": map[string]string{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"ethernet1/2": map[string]string{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"ethernet1/3": map[string]string{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"ethernet1/4": map[string]string{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"loopback.42": map[string]string{
			"mode": "layer3",
			"vsys": "vsys1",
		},
		"tunnel.42": map[string]string{
			"mode": "layer3",
			"vsys": "vsys1",
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)
	actual_zones := terraform.OutputList(t, terraformOptions, "panos_zones")
	actual_zone_entry := terraform.OutputMap(t, terraformOptions, "panos_zone_entry")

	// then
	assert.Equal(t, expected_zone, actual_zones)
	/*
		while trying to compare using below options:
		   assert.Equal(t, expected_zone_entry, actual_zone_entry)
		or
		   assert.True(t, reflect.DeepEqual(expected_zone_entry, actual_zone_entry))
		there were problems with types of embedded map, so that's why below code to compare
		strings created from maps for every key was used
	*/
	assert.Equal(t, len(expected_zone), len(actual_zone_entry))
	for key := range actual_zone_entry {
		assert.Equal(t, fmt.Sprint(expected_zone_entry[key]), fmt.Sprint(actual_zone_entry[key]))
	}
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
