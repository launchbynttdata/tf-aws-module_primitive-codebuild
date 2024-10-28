package testimpl

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
	cfg := GetAWSConfig(t)            
	s3Client := s3.NewFromConfig(cfg) 

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

	require.Truef(t, found, "S3 bucket %s not found", bucketName)
}

func VerifyIAMRoleExists(t *testing.T, ctx types.TestContext, roleName string) {
	cfg := GetAWSConfig(t)         
	iamClient := iam.NewFromConfig(cfg) 

	_, err := iamClient.GetRole(context.TODO(), &iam.GetRoleInput{
		RoleName: &roleName,
	})
	require.NoErrorf(t, err, "IAM role %s not found: %v", roleName, err)

	// If no error, the role exists
	t.Logf("IAM role %s exists", roleName)
}

func TestS3BucketAndIAMRole(t *testing.T, ctx types.TestContext) {

	terraformOptions := ctx.TerratestTerraformOptions()

	_, err := terraform.InitAndApplyE(t, terraformOptions)
	require.NoErrorf(t, err, "Failed to init and apply Terraform: %v", err)

	defer func() {
		_, err := terraform.DestroyE(t, terraformOptions)
		require.NoErrorf(t, err, "Failed to destroy Terraform resources: %v", err)
	}()

	s3BucketName := terraform.Output(t, terraformOptions, "s3_bucket_arn")

	iamRoleName := terraform.Output(t, terraformOptions, "role_id")

	VerifyS3BucketExists(t, ctx, s3BucketName)

	VerifyIAMRoleExists(t, ctx, iamRoleName)
}
