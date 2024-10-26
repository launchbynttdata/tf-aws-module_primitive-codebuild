package common

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/iam"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/require"
)

// AWS Config Loader for SDK
func GetAWSConfig(t *testing.T) aws.Config {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load AWS SDK config: %v", err)
	return cfg
}

// Function to verify that an S3 bucket exists by checking for its presence in the list of S3 buckets
func VerifyS3BucketExists(t *testing.T, ctx types.TestContext, bucketName string) {
	cfg := GetAWSConfig(t)            // Load AWS SDK config
	s3Client := s3.NewFromConfig(cfg) // Create new S3 client

	// List S3 buckets and search for the bucket name
	output, err := s3Client.ListBuckets(context.TODO(), &s3.ListBucketsInput{})
	require.NoError(t, err, "Failed to list S3 buckets")

	// Check if the bucket exists in the list of buckets
	var found bool
	for _, bucket := range output.Buckets {
		if aws.ToString(bucket.Name) == bucketName {
			found = true
			break
		}
	}

	// Assert that the bucket was found
	require.Truef(t, found, "S3 bucket %s not found", bucketName)
}

// Function to verify that an IAM Role exists by describing the role
func VerifyIAMRoleExists(t *testing.T, ctx types.TestContext, roleName string) {
	cfg := GetAWSConfig(t)         // Load AWS SDK config
	iamClient := iam.NewFromConfig(cfg) // Create new IAM client

	// Describe the IAM role using the role name
	_, err := iamClient.GetRole(context.TODO(), &iam.GetRoleInput{
		RoleName: &roleName,
	})
	require.NoErrorf(t, err, "IAM role %s not found: %v", roleName, err)

	// If no error, the role exists
	t.Logf("IAM role %s exists", roleName)
}

// Test function that initializes Terraform, verifies the S3 bucket, and verifies the IAM role
func TestS3BucketAndIAMRole(t *testing.T, ctx types.TestContext) {
	// Define the Terraform options (ensure you point to your Terraform module and variables)
	terraformOptions := ctx.TerratestTerraformOptions()

	// Run `terraform init` and `terraform apply` to set up resources
	_, err := terraform.InitAndApplyE(t, terraformOptions)
	require.NoErrorf(t, err, "Failed to init and apply Terraform: %v", err)

	// Ensure resources are cleaned up after test execution
	defer func() {
		_, err := terraform.DestroyE(t, terraformOptions)
		require.NoErrorf(t, err, "Failed to destroy Terraform resources: %v", err)
	}()

	// Get the S3 bucket name from Terraform outputs
	s3BucketName := terraform.Output(t, terraformOptions, "s3_bucket_arn")

	// Get the IAM role name from Terraform outputs
	iamRoleName := terraform.Output(t, terraformOptions, "role_id")

	// Verify that the S3 bucket exists
	VerifyS3BucketExists(t, ctx, s3BucketName)

	// Verify that the IAM role exists
	VerifyIAMRoleExists(t, ctx, iamRoleName)
}

