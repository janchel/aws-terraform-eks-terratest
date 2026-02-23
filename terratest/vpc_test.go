package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
)

func TestVpc(t *testing.T) {
	t.Parallel()

	// Generate a unique name for the VPC to avoid conflicts
	uniqueId := random.UniqueId()
	vpcName := "terratest-vpc-" + uniqueId

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../vpc",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name": vpcName,
			"cidr": "10.0.0.0/16",
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	publicSubnets := terraform.OutputList(t, terraformOptions, "public_subnets")
	privateSubnets := terraform.OutputList(t, terraformOptions, "private_subnets")
	availabilityZones := terraform.OutputList(t, terraformOptions, "availability_zones")

	// Verify the VPC ID is not empty
	assert.NotEmpty(t, vpcId, "VPC ID should not be empty")

	// Verify that we have at least one public and one private subnet
	assert.Greater(t, len(publicSubnets), 0, "Should have at least one public subnet")
	assert.Greater(t, len(privateSubnets), 0, "Should have at least one private subnet")

	// Verify availability zones are set
	assert.Greater(t, len(availabilityZones), 0, "Should have availability zones")

	// You can add more assertions here, such as checking the actual AWS resources exist
	// using terratest's AWS modules, but for a beginner test, outputs are sufficient
}