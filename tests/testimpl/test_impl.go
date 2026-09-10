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
	awsClient := GetAWSCodeBuildClient(t, t.Context())

	t.Run("TestCodeBuildProjectExists", func(t *testing.T) {
		codeBuildProjectName := terraform.OutputContext(t, t.Context(), ctx.TerratestTerraformOptions(), "project_name")
		require.NotEmpty(t, codeBuildProjectName, "Terraform output 'project_name' should not be empty")

		project, err := awsClient.BatchGetProjects(t.Context(), &codebuild.BatchGetProjectsInput{
			Names: []string{codeBuildProjectName},
		})
		require.NoError(t, err, "BatchGetProjects failed for %s", codeBuildProjectName)
		require.Len(t, project.Projects, 1, "expected exactly one CodeBuild project")

		assert.Equal(t, codeBuildProjectName, aws.ToString(project.Projects[0].Name))
	})
}

// GetAWSCodeBuildClient initializes and returns an AWS CodeBuild client
func GetAWSCodeBuildClient(t *testing.T, ctx context.Context) *codebuild.Client {
	t.Helper()

	return codebuild.NewFromConfig(GetAWSConfig(t, ctx))
}

// GetAWSConfig loads the default AWS SDK configuration
func GetAWSConfig(t *testing.T, ctx context.Context) aws.Config {
	t.Helper()

	cfg, err := config.LoadDefaultConfig(ctx)
	require.NoErrorf(t, err, "unable to load SDK config: %v", err)

	return cfg
}
