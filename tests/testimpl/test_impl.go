package testimpl

import (
    "context"
    "testing"

    "github.com/aws/aws-sdk-go-v2/aws"
    "github.com/aws/aws-sdk-go-v2/config"
    "github.com/aws/aws-sdk-go-v2/service/codebuild"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/launchbynttdata/lcaf-component-terratest/types"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)

// TestComposableComplete verifies the existence of the CodeBuild project using the `project_name` output from Terraform
func TestComposableComplete(t *testing.T, ctx types.TestContext) {
    // Initialize AWS CodeBuild client
    awsClient := GetAWSCodeBuildClient(t)

    // Subtest to check if the CodeBuild project exists
    t.Run("TestCodeBuildProjectExists", func(t *testing.T) {
        // Retrieve CodeBuild project name from Terraform output
        codeBuildProjectName := terraform.Output(t, ctx.TerratestTerraformOptions(), "project_name")
        require.NotEmpty(t, codeBuildProjectName, "Terraform output 'project_name' should not be empty")

        // Describe the CodeBuild project
        project, err := awsClient.BatchGetProjects(context.TODO(), &codebuild.BatchGetProjectsInput{
            Names: []string{codeBuildProjectName},
        })
        if err != nil {
            t.Errorf("Failure during BatchGetProjects: %v", err)
            return
        }

        // Ensure exactly one project was retrieved
        if len(project.Projects) != 1 {
            t.Errorf("Expected exactly one CodeBuild project, but found %d", len(project.Projects))
            return
        }

        // Assert that the project name matches the output
        assert.Equal(t, codeBuildProjectName, *project.Projects[0].Name, "Expected project name does not match actual name!")
    })
}

// GetAWSCodeBuildClient initializes and returns an AWS CodeBuild client
func GetAWSCodeBuildClient(t *testing.T) *codebuild.Client {
    return codebuild.NewFromConfig(GetAWSConfig(t))
}

// GetAWSConfig loads the default AWS SDK configuration
func GetAWSConfig(t *testing.T) aws.Config {
    cfg, err := config.LoadDefaultConfig(context.TODO())
    require.NoErrorf(t, err, "unable to load SDK config: %v", err)
    return cfg
}
