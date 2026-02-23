package test

import (
	"fmt"
	"strings"
	"testing"
	"time"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
)

func TestS3(t *testing.T) {
	t.Parallel()

	// Generate a unique name for the S3 bucket to avoid conflicts
	// S3 bucket names must be globally unique and lowercase only
	uniqueId := strings.ToLower(random.UniqueId())
	timestamp := time.Now().Unix()
	bucketName := fmt.Sprintf("terratest-s3-%s-%d", uniqueId, timestamp)

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../s3",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"bucket_name": bucketName,
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	bucketNameOutput := terraform.Output(t, terraformOptions, "bucket_name")
	bucketArn := terraform.Output(t, terraformOptions, "bucket_arn")
	bucketDomainName := terraform.Output(t, terraformOptions, "bucket_domain_name")

	// Verify the bucket name matches what we set
	assert.Equal(t, bucketName, bucketNameOutput, "Bucket name should match the input")

	// Verify the bucket ARN is not empty and contains the bucket name
	assert.NotEmpty(t, bucketArn, "Bucket ARN should not be empty")
	assert.Contains(t, bucketArn, bucketName, "Bucket ARN should contain the bucket name")

	// Verify the bucket domain name is not empty
	assert.NotEmpty(t, bucketDomainName, "Bucket domain name should not be empty")

	// You can add more assertions here, such as checking the actual AWS resources exist
	// using terratest's AWS modules, but for a beginner test, outputs are sufficient
}