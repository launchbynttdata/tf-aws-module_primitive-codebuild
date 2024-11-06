package test

import (
    "testing"

    "github.com/launchbynttdata/lcaf-component-terratest/lib"
    "github.com/launchbynttdata/lcaf-component-terratest/types"
    "github.com/launchbynttdata/tf-aws-module_primitive-codebuild/tests/testimpl"
)

const (
    testConfigsExamplesFolderDefault = "../../examples"
    infraTFVarFileNameDefault        = "test.tfvars"
)

// TestS3BucketAndIAMRoleModule is the post-deploy functional test for the S3 bucket and IAM role
func TestS3BucketAndIAMRoleModule(t *testing.T) {

    // Setup the Terratest context
    ctx := types.CreateTestContextBuilder().
        SetTestConfig(&testimpl.ThisTFModuleConfig{}).
        SetTestConfigFolderName(testConfigsExamplesFolderDefault).
        SetTestConfigFileName(infraTFVarFileNameDefault).
        Build()

    // Run setup, test, teardown steps using Terratest framework
    lib.RunSetupTestTeardown(t, *ctx, testimpl.TestS3BucketAndIAMRole)
}
