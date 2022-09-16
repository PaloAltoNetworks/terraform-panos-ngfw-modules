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
	defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)
	actual_zones := terraform.OutputList(t, terraformOptions, "panos_zones")
	expected_zones := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/zones.csv", 2)

	// then
	assert.Equal(t, expected_zones, actual_zones)
}

func TestOutputsForCsvBasicExampleAndForPanorama(t *testing.T) {
	// given
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/csv_examples/csv_basic_example",
		Vars: map[string]interface{}{
			"pan_creds":     "../../../tests/creds/panorama.json",
			"panorama_mode": true,
		},
		Logger:  logger.Discard,
		Lock:    true,
		Upgrade: true,
	})
	defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)

	// then
}
