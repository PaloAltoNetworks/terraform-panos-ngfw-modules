package test

import (
	"fmt"
	"strings"
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

	actual_panos_ethernet_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ethernet_interface")
	actual_panos_ike_gateway := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ike_gateway")
	actual_panos_ike_crypto_profile := terraform.Output(t, terraformOptions, "panos_ike_crypto_profile")
	actual_panos_ipsec_crypto_profile := terraform.Output(t, terraformOptions, "panos_ipsec_crypto_profile")
	actual_panos_ipsec_tunnel := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ipsec_tunnel")
	actual_panos_ipsec_tunnel_proxy_id_ipv4 := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ipsec_tunnel_proxy_id_ipv4")
	actual_panos_loopback_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_loopback_interface")
	actual_panos_management_profile := terraform.OutputJson(t, terraformOptions, "panos_management_profile")
	actual_panos_static_route_ipv4 := terraform.OutputMapOfObjects(t, terraformOptions, "panos_static_route_ipv4")
	actual_panos_tunnel_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_tunnel_interface")
	actual_panos_virtual_router := terraform.OutputJson(t, terraformOptions, "panos_virtual_router")
	actual_panos_virtual_router_entry := terraform.OutputMapOfObjects(t, terraformOptions, "panos_virtual_router_entry")
	actual_panos_zones := terraform.OutputList(t, terraformOptions, "panos_zones")
	actual_panos_zone_entry := terraform.OutputMapOfObjects(t, terraformOptions, "panos_zone_entry")
	actual_panos_panorama_ethernet_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_ethernet_interface")
	actual_panos_panorama_ike_gateway := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_ike_gateway")
	actual_panos_panorama_ipsec_crypto_profile := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_ipsec_crypto_profile")
	actual_panos_panorama_ipsec_tunnel := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_ipsec_tunnel")
	actual_panos_panorama_ipsec_tunnel_proxy_id_ipv4 := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_ipsec_tunnel_proxy_id_ipv4")
	actual_panos_panorama_loopback_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_loopback_interface")
	actual_panos_panorama_management_profile := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_management_profile")
	actual_panos_panorama_static_route_ipv4 := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_static_route_ipv4")
	actual_panos_panorama_tunnel_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_tunnel_interface")

	expected_ike_crypto_profiles := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/ike_crypto_profiles.csv", 1)
	expected_ike_gateways := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/ike_gateways.csv", 1)
	expected_interfaces := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/interfaces.csv", 3)
	expected_ipsec_crypto_profiles := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/ipsec_crypto_profiles.csv", 1)
	expected_ipsec_tunnels := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/ipsec_tunnels.csv", 1)
	expected_management_profiles := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/management_profiles.csv", 1)
	expected_virtual_routers := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/virtual_routers.csv", 2)
	expected_virtual_routers_routes := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/virtual_routers_routes.csv", 4)
	expected_zones := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/zones.csv", 2)

	// then
	assert.NotEmpty(t, actual_panos_ethernet_interface)
	for _, name := range expected_interfaces {
		if !strings.Contains(name, "loopback") && !strings.Contains(name, "tunnel") {
			assert.NotEmptyf(t, actual_panos_ethernet_interface[name], "There is no interface %s", name)
		}
	}
	assert.NotEmpty(t, actual_panos_ike_gateway)
	for _, name := range expected_ike_gateways {
		assert.NotEmptyf(t, actual_panos_ike_gateway[name], "There is no IKE gateway %s", name)
	}
	assert.NotEmpty(t, actual_panos_ike_crypto_profile)
	for _, name := range expected_ike_crypto_profiles {
		assert.Truef(t, strings.Contains(actual_panos_ike_crypto_profile, name), "There is no IKE crypto profile %s", name)
	}
	assert.NotEmpty(t, actual_panos_ipsec_crypto_profile)
	for _, name := range expected_ipsec_crypto_profiles {
		assert.Truef(t, strings.Contains(actual_panos_ipsec_crypto_profile, name), "There is no IPSec crypto profile %s", name)
	}
	assert.NotEmpty(t, actual_panos_ipsec_tunnel)
	for _, name := range expected_ipsec_tunnels {
		assert.NotEmptyf(t, actual_panos_ipsec_tunnel[name], "There is no IPSec tunnel %s", name)
	}
	assert.NotEmpty(t, actual_panos_ipsec_tunnel_proxy_id_ipv4)
	assert.NotEmpty(t, actual_panos_loopback_interface)
	for _, name := range expected_interfaces {
		if strings.Contains(name, "loopback") {
			assert.NotEmptyf(t, actual_panos_loopback_interface[name], "There is no interface %s", name)
		}
	}
	assert.NotEmpty(t, actual_panos_management_profile)
	for _, name := range expected_management_profiles {
		assert.Truef(t, strings.Contains(actual_panos_management_profile, name), "There is no profile %s", name)
	}
	assert.NotEmpty(t, actual_panos_static_route_ipv4)
	for _, destination := range expected_virtual_routers_routes {
		destination_is_in_static_routes := false
		for _, details := range actual_panos_static_route_ipv4 {
			destination_is_in_static_routes = destination_is_in_static_routes || strings.Contains(fmt.Sprintf("%s", details), destination)
		}
		assert.Truef(t, destination_is_in_static_routes, "There is no static route for destination %s", destination)
	}
	assert.NotEmpty(t, actual_panos_tunnel_interface)
	for _, name := range expected_interfaces {
		if strings.Contains(name, "tunnel") {
			assert.NotEmptyf(t, actual_panos_tunnel_interface[name], "There is no interface %s", name)
		}
	}
	assert.NotEmpty(t, actual_panos_virtual_router)
	for _, name := range expected_virtual_routers {
		assert.Truef(t, strings.Contains(actual_panos_virtual_router, name), "There is no virtual router %s", name)
	}
	assert.NotEmpty(t, actual_panos_virtual_router_entry)
	for _, name := range expected_interfaces {
		assert.NotEmptyf(t, actual_panos_virtual_router_entry[name], "There is no virtual router entry %s", name)
	}
	assert.NotEmpty(t, actual_panos_zones)
	assert.Equal(t, expected_zones, actual_panos_zones)
	assert.NotEmpty(t, actual_panos_zone_entry)
	for _, name := range expected_interfaces {
		assert.NotEmptyf(t, actual_panos_zone_entry[name], "There is no zone entry %s", name)
	}
	assert.Empty(t, actual_panos_panorama_ethernet_interface)
	assert.Empty(t, actual_panos_panorama_ike_gateway)
	assert.Empty(t, actual_panos_panorama_ipsec_crypto_profile)
	assert.Empty(t, actual_panos_panorama_ipsec_tunnel)
	assert.Empty(t, actual_panos_panorama_ipsec_tunnel_proxy_id_ipv4)
	assert.Empty(t, actual_panos_panorama_loopback_interface)
	assert.Empty(t, actual_panos_panorama_management_profile)
	assert.Empty(t, actual_panos_panorama_static_route_ipv4)
	assert.Empty(t, actual_panos_panorama_tunnel_interface)
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

	actual_panos_ethernet_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ethernet_interface")
	actual_panos_ike_gateway := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ike_gateway")
	actual_panos_ike_crypto_profile := terraform.Output(t, terraformOptions, "panos_ike_crypto_profile")
	actual_panos_ipsec_crypto_profile := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ipsec_crypto_profile")
	actual_panos_ipsec_tunnel := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ipsec_tunnel")
	actual_panos_ipsec_tunnel_proxy_id_ipv4 := terraform.OutputMapOfObjects(t, terraformOptions, "panos_ipsec_tunnel_proxy_id_ipv4")
	actual_panos_loopback_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_loopback_interface")
	actual_panos_management_profile := terraform.OutputMapOfObjects(t, terraformOptions, "panos_management_profile")
	actual_panos_static_route_ipv4 := terraform.OutputMapOfObjects(t, terraformOptions, "panos_static_route_ipv4")
	actual_panos_tunnel_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_tunnel_interface")
	actual_panos_virtual_router := terraform.OutputJson(t, terraformOptions, "panos_virtual_router")
	actual_panos_virtual_router_entry := terraform.OutputMapOfObjects(t, terraformOptions, "panos_virtual_router_entry")
	actual_panos_zones := terraform.OutputList(t, terraformOptions, "panos_zones")
	actual_panos_zone_entry := terraform.OutputMapOfObjects(t, terraformOptions, "panos_zone_entry")
	actual_panos_panorama_ethernet_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_ethernet_interface")
	actual_panos_panorama_ike_gateway := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_ike_gateway")
	actual_panos_panorama_ipsec_crypto_profile := terraform.Output(t, terraformOptions, "panos_panorama_ipsec_crypto_profile")
	actual_panos_panorama_ipsec_tunnel := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_ipsec_tunnel")
	actual_panos_panorama_ipsec_tunnel_proxy_id_ipv4 := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_ipsec_tunnel_proxy_id_ipv4")
	actual_panos_panorama_loopback_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_loopback_interface")
	actual_panos_panorama_management_profile := terraform.OutputJson(t, terraformOptions, "panos_panorama_management_profile")
	actual_panos_panorama_static_route_ipv4 := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_static_route_ipv4")
	actual_panos_panorama_tunnel_interface := terraform.OutputMapOfObjects(t, terraformOptions, "panos_panorama_tunnel_interface")

	expected_ike_crypto_profiles := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/ike_crypto_profiles.csv", 1)
	expected_ike_gateways := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/ike_gateways.csv", 1)
	expected_interfaces := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/interfaces.csv", 3)
	expected_ipsec_crypto_profiles := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/ipsec_crypto_profiles.csv", 1)
	expected_ipsec_tunnels := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/ipsec_tunnels.csv", 1)
	expected_management_profiles := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/management_profiles.csv", 1)
	expected_virtual_routers := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/virtual_routers.csv", 2)
	expected_virtual_routers_routes := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/virtual_routers_routes.csv", 4)
	expected_zones := ReadCsvFileAndReturnListOfValuesFromColumn("../examples/csv_examples/csv_basic_example/csv/zones.csv", 2)

	// then
	assert.Empty(t, actual_panos_ethernet_interface)
	assert.Empty(t, actual_panos_ike_gateway)
	assert.NotEmpty(t, actual_panos_ike_crypto_profile)
	for _, name := range expected_ike_crypto_profiles {
		assert.Truef(t, strings.Contains(actual_panos_ike_crypto_profile, name), "There is no IKE crypto profile %s", name)
	}
	assert.Empty(t, actual_panos_ipsec_crypto_profile)
	assert.Empty(t, actual_panos_ipsec_tunnel)
	assert.Empty(t, actual_panos_ipsec_tunnel_proxy_id_ipv4)
	assert.Empty(t, actual_panos_loopback_interface)
	assert.Empty(t, actual_panos_management_profile)
	assert.Empty(t, actual_panos_static_route_ipv4)
	assert.Empty(t, actual_panos_tunnel_interface)
	assert.NotEmpty(t, actual_panos_virtual_router)
	for _, name := range expected_virtual_routers {
		assert.Truef(t, strings.Contains(actual_panos_virtual_router, name), "There is no virtual router %s", name)
	}
	assert.NotEmpty(t, actual_panos_virtual_router_entry)
	for _, name := range expected_interfaces {
		assert.NotEmptyf(t, actual_panos_virtual_router_entry[name], "There is no virtual router entry %s", name)
	}
	assert.NotEmpty(t, actual_panos_zones)
	assert.Equal(t, expected_zones, actual_panos_zones)
	assert.NotEmpty(t, actual_panos_zone_entry)
	for _, name := range expected_interfaces {
		assert.NotEmptyf(t, actual_panos_zone_entry[name], "There is no zone entry %s", name)
	}
	assert.NotEmpty(t, actual_panos_panorama_ethernet_interface)
	for _, name := range expected_interfaces {
		if !strings.Contains(name, "loopback") && !strings.Contains(name, "tunnel") {
			assert.NotEmptyf(t, actual_panos_panorama_ethernet_interface[name], "There is no interface %s", name)
		}
	}
	assert.NotEmpty(t, actual_panos_panorama_ike_gateway)
	for _, name := range expected_ike_gateways {
		assert.NotEmptyf(t, actual_panos_panorama_ike_gateway[name], "There is no IKE gateway %s", name)
	}
	assert.NotEmpty(t, actual_panos_panorama_ipsec_crypto_profile)
	for _, name := range expected_ipsec_crypto_profiles {
		assert.Truef(t, strings.Contains(actual_panos_panorama_ipsec_crypto_profile, name), "There is no IPSec crypto profile %s", name)
	}
	assert.NotEmpty(t, actual_panos_panorama_ipsec_tunnel)
	for _, name := range expected_ipsec_tunnels {
		assert.NotEmptyf(t, actual_panos_panorama_ipsec_tunnel[name], "There is no IPSec tunnel %s", name)
	}
	assert.NotEmpty(t, actual_panos_panorama_ipsec_tunnel_proxy_id_ipv4)
	assert.NotEmpty(t, actual_panos_panorama_loopback_interface)
	for _, name := range expected_interfaces {
		if strings.Contains(name, "loopback") {
			assert.NotEmptyf(t, actual_panos_panorama_loopback_interface[name], "There is no interface %s", name)
		}
	}
	assert.NotEmpty(t, actual_panos_panorama_management_profile)
	for _, name := range expected_management_profiles {
		assert.Truef(t, strings.Contains(actual_panos_panorama_management_profile, name), "There is no profile %s", name)
	}
	assert.NotEmpty(t, actual_panos_panorama_static_route_ipv4)
	for _, destination := range expected_virtual_routers_routes {
		destination_is_in_static_routes := false
		for _, details := range actual_panos_panorama_static_route_ipv4 {
			destination_is_in_static_routes = destination_is_in_static_routes || strings.Contains(fmt.Sprintf("%s", details), destination)
		}
		assert.Truef(t, destination_is_in_static_routes, "There is no static route for destination %s", destination)
	}
	assert.NotEmpty(t, actual_panos_panorama_tunnel_interface)
	for _, name := range expected_interfaces {
		if strings.Contains(name, "tunnel") {
			assert.NotEmptyf(t, actual_panos_panorama_tunnel_interface[name], "There is no interface %s", name)
		}
	}
}
