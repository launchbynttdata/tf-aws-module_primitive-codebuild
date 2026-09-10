# complete

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_codebuild"></a> [codebuild](#module\_codebuild) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifacts"></a> [artifacts](#input\_artifacts) | list of artifacts for the codebuild project | <pre>list(object({<br/>    artifact_identifier    = string<br/>    type                   = string<br/>    location               = string<br/>    name                   = string<br/>    path                   = string<br/>    namespace_type         = string<br/>    packaging              = string<br/>    encryption_disabled    = bool<br/>    override_artifact_name = bool<br/>  }))</pre> | n/a | yes |
| <a name="input_badge_enabled"></a> [badge\_enabled](#input\_badge\_enabled) | Generates a publicly-accessible URL for the projects build badge. Available as badge\_url attribute when enabled | `bool` | n/a | yes |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | Instance type of the build instance | `string` | n/a | yes |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html | `string` | n/a | yes |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed | `number` | n/a | yes |
| <a name="input_build_type"></a> [build\_type](#input\_build\_type) | The type of build environment, e.g. 'LINUX\_CONTAINER' or 'WINDOWS\_CONTAINER' | `string` | n/a | yes |
| <a name="input_buildspec"></a> [buildspec](#input\_buildspec) | Path to the buildspec.yml file | `string` | `"buildspec.yml"` | no |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO\_CACHE, LOCAL, and S3.  Defaults to NO\_CACHE.  If cache\_type is S3, it will create an S3 bucket for storing codebuild cache inside | `string` | n/a | yes |
| <a name="input_caches_modes"></a> [caches\_modes](#input\_caches\_modes) | The type of data caching between builds. The inputs values are LOCAL\_SOURCE\_CACHE, LOCAL\_DOCKER\_LAYER\_CACHE, LOCAL\_CUSTOM\_CACHE | `string` | `"LOCAL_CUSTOM_CACHE"` | no |
| <a name="input_concurrent_build_limit"></a> [concurrent\_build\_limit](#input\_concurrent\_build\_limit) | Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit. | `number` | `null` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER\_STORE', or 'SECRETS\_MANAGER' | <pre>list(object(<br/>    {<br/>      name  = string<br/>      value = string<br/>      type  = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "NO_ADDITIONAL_BUILD_VARS",<br/>    "type": "PLAINTEXT",<br/>    "value": "TRUE"<br/>  }<br/>]</pre> | no |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | (Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `bool` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `string` | n/a | yes |
| <a name="input_secondary_artifacts"></a> [secondary\_artifacts](#input\_secondary\_artifacts) | List of secondary artifacts for the codebuild project | <pre>list(object({<br/>    artifact_identifier    = string<br/>    type                   = string<br/>    location               = string<br/>    name                   = string<br/>    path                   = string<br/>    namespace_type         = string<br/>    packaging              = string<br/>    encryption_disabled    = bool<br/>    override_artifact_name = bool<br/>  }))</pre> | n/a | yes |
| <a name="input_source_location"></a> [source\_location](#input\_source\_location) | Location of the source code (e.g., GitHub URL or S3 path) | `string` | `""` | no |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | The source type for CodeBuild (e.g., S3, GITHUB, CODECOMMIT) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_badge_url"></a> [badge\_url](#output\_badge\_url) | The URL of the build badge when badge\_enabled is enabled |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Project ID |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name |
| <a name="output_service_role_arn"></a> [service\_role\_arn](#output\_service\_role\_arn) | IAM Role ID |
<!-- END_TF_DOCS -->
