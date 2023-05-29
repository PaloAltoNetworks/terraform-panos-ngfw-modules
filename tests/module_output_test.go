package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestOutputsForBasicExampleAndForVmSeries(t *testing.T) {
	// given
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic_configuration_example",
		Vars: map[string]interface{}{
			"pan_creds": "../../tests/creds/vmseries.json",
			"mode":      "ngfw",
		},
		Logger:  logger.Discard,
		Lock:    true,
		Upgrade: true,
	})
	defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)

	device_groups := terraform.OutputList(t, terraformOptions, "device_groups")
	tags := terraform.OutputList(t, terraformOptions, "tags")
	addresses := terraform.OutputList(t, terraformOptions, "addresses")
	address_groups := terraform.OutputList(t, terraformOptions, "address_groups")
	services := terraform.OutputList(t, terraformOptions, "services")
	service_groups := terraform.OutputList(t, terraformOptions, "service_groups")
	interfaces := terraform.OutputList(t, terraformOptions, "interfaces")
	management_profiles := terraform.OutputList(t, terraformOptions, "management_profiles")
	virtual_routers := terraform.OutputList(t, terraformOptions, "virtual_routers")
	static_routes := terraform.OutputList(t, terraformOptions, "static_routes")
	zones := terraform.OutputList(t, terraformOptions, "zones")
	ipsec := terraform.OutputList(t, terraformOptions, "ipsec")
	templates := terraform.OutputList(t, terraformOptions, "templates")
	template_stacks := terraform.OutputList(t, terraformOptions, "template_stacks")
	security_policies := terraform.OutputList(t, terraformOptions, "security_policies")

	// then
	assert.Empty(t, device_groups)
	assert.NotEmpty(t, tags)
	assert.NotEmpty(t, addresses)
	assert.NotEmpty(t, address_groups)
	assert.NotEmpty(t, services)
	assert.NotEmpty(t, service_groups)
	assert.NotEmpty(t, interfaces)
	assert.NotEmpty(t, management_profiles)
	assert.NotEmpty(t, virtual_routers)
	assert.NotEmpty(t, static_routes)
	assert.NotEmpty(t, zones)
	assert.NotEmpty(t, ipsec)
	assert.Empty(t, templates)
	assert.Empty(t, template_stacks)
	assert.NotEmpty(t, security_policies)
}

func TestOutputsForBasicExampleAndForPanorama(t *testing.T) {
	// given
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic_configuration_example",
		Vars: map[string]interface{}{
			"pan_creds": "../../tests/creds/panorama.json",
			"mode":      "panorama",
		},
		Logger:  logger.Discard,
		Lock:    true,
		Upgrade: true,
	})
	defer terraform.Destroy(t, terraformOptions)

	// when
	terraform.InitAndApply(t, terraformOptions)

	device_groups := terraform.OutputList(t, terraformOptions, "device_groups")
	tags := terraform.OutputList(t, terraformOptions, "tags")
	addresses := terraform.OutputList(t, terraformOptions, "addresses")
	address_groups := terraform.OutputList(t, terraformOptions, "address_groups")
	services := terraform.OutputList(t, terraformOptions, "services")
	service_groups := terraform.OutputList(t, terraformOptions, "service_groups")
	interfaces := terraform.OutputList(t, terraformOptions, "interfaces")
	management_profiles := terraform.OutputList(t, terraformOptions, "management_profiles")
	virtual_routers := terraform.OutputList(t, terraformOptions, "virtual_routers")
	static_routes := terraform.OutputList(t, terraformOptions, "static_routes")
	zones := terraform.OutputList(t, terraformOptions, "zones")
	ipsec := terraform.OutputList(t, terraformOptions, "ipsec")
	templates := terraform.OutputList(t, terraformOptions, "templates")
	template_stacks := terraform.OutputList(t, terraformOptions, "template_stacks")
	security_policies := terraform.OutputList(t, terraformOptions, "security_policies")

	// then
	assert.NotEmpty(t, device_groups)
	assert.NotEmpty(t, tags)
	assert.NotEmpty(t, addresses)
	assert.NotEmpty(t, address_groups)
	assert.NotEmpty(t, services)
	assert.NotEmpty(t, service_groups)
	assert.NotEmpty(t, interfaces)
	assert.NotEmpty(t, management_profiles)
	assert.NotEmpty(t, virtual_routers)
	assert.NotEmpty(t, static_routes)
	assert.NotEmpty(t, zones)
	assert.NotEmpty(t, ipsec)
	assert.NotEmpty(t, templates)
	assert.NotEmpty(t, template_stacks)
	assert.NotEmpty(t, security_policies)
}
