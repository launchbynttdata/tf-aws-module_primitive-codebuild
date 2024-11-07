package test

import (
    "testing"

    "github.com/launchbynttdata/lcaf-component-terratest/lib"
    "github.com/launchbynttdata/lcaf-component-terratest/types"
    "github.com/launchbynttdata/tf-aws-module_primitive-codebuild/tests/testimpl"
)

const (
    testConfigsExamplesFolderDefault = "../../examples/complete"
    infraTFVarFileNameDefault        = "test.tfvars"
)

func TestCodeBuildProjectModule(t *testing.T) {
    // Set up the Terratest context with the configuration folder and vars file
    ctx := types.CreateTestContextBuilder().
        SetTestConfigFolderName(testConfigsExamplesFolderDefault).
        SetTestConfigFileName(infraTFVarFileNameDefault).
        Build()

    // Run the CodeBuild project test
    lib.RunSetupTestTeardown(t, *ctx, testimpl.TestComposableComplete)
}
