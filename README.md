# terraform-aws-codebuild

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0, <=1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.68.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.github_authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_webhook.webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook) | resource |
| [random_string.bucket_prefix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_secretsmanager_secret.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.current_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER\_STORE', or 'SECRETS\_MANAGER' | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>      type  = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-aws-wrapper\_module-codepipeline module to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "codebuild": {<br>    "max_length": 63,<br>    "name": "cb"<br>  },<br>  "function": {<br>    "max_length": 63,<br>    "name": "fn"<br>  }<br>}</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | Short description of the CodeBuild project | `string` | `"Managed by Terraform"` | no |
| <a name="input_concurrent_build_limit"></a> [concurrent\_build\_limit](#input\_concurrent\_build\_limit) | Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit. | `number` | `null` | no |
| <a name="input_cache_expiration_days"></a> [cache\_expiration\_days](#input\_cache\_expiration\_days) | How many days should the build cache be kept. It only works when cache\_type is 'S3' | `number` | `7` | no |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO\_CACHE, LOCAL, and S3.  Defaults to NO\_CACHE.  If cache\_type is S3, the name of the S3 bucket will need to be provided | `string` | `"NO_CACHE"` | no |
| <a name="input_caches_modes"></a> [caches\_modes](#input\_caches\_modes) | The type of data caching between builds. The inputs values are LOCAL\_SOURCE\_CACHE, LOCAL\_DOCKER\_LAYER\_CACHE, LOCAL\_CUSTOM\_CACHE | `string` | `"LOCAL_CUSTOM_CACHE"` | no |
| <a name="input_codebuild_enabled"></a> [codebuild\_enabled](#input\_codebuild\_enabled) | Flag to enable or disable the module | `bool` | `true` | no |
| <a name="input_badge_enabled"></a> [badge\_enabled](#input\_badge\_enabled) | Generates a publicly-accessible URL for the projects build badge. Available as badge\_url attribute when enabled | `bool` | `false` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html | `string` | `"aws/codebuild/standard:2.0"` | no |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | Instance type of the build instance | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed | `number` | `60` | no |
| <a name="input_build_type"></a> [build\_type](#input\_build\_type) | The type of build environment, e.g. 'LINUX\_CONTAINER' or 'WINDOWS\_CONTAINER' | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_buildspec"></a> [buildspec](#input\_buildspec) | Optional buildspec declaration to use for building the project | `string` | `""` | no |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | (Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `bool` | `false` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | (Optional) GitHub auth token environment variable (`GITHUB_TOKEN`) | `string` | `""` | no |
| <a name="input_github_token_type"></a> [github\_token\_type](#input\_github\_token\_type) | Storage type of GITHUB\_TOKEN environment variable (`PARAMETER_STORE`, `PLAINTEXT`, `SECRETS_MANAGER`) | `string` | `"PARAMETER_STORE"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | (Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `any` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | (Optional) AWS Account ID. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | `string` | `""` | no |
| <a name="input_image_repo_name"></a> [image\_repo\_name](#input\_image\_repo\_name) | (Optional) ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | `string` | `"UNSET"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | (Optional) Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | `string` | `"latest"` | no |
| <a name="input_service_role_arn"></a> [service\_role\_arn](#input\_service\_role\_arn) | The ARN of the IAM role for Codebuild | `string` | n/a | yes |
| <a name="input_secondary_sources"></a> [secondary\_sources](#input\_secondary\_sources) | (Optional) secondary source for the codebuild project in addition to the primary location | <pre>list(object(<br>    {<br>      git_clone_depth     = number<br>      location            = string<br>      source_identifier   = string<br>      type                = string<br>      fetch_submodules    = bool<br>      insecure_ssl        = bool<br>      report_build_status = bool<br>  }))</pre> | `[]` | no |
| <a name="input_source_location"></a> [source\_location](#input\_source\_location) | The location of the source code from git or s3 | `string` | `""` | no |
| <a name="input_artifact_type"></a> [artifact\_type](#input\_artifact\_type) | The build output artifact's type. Valid values for this parameter are: CODEPIPELINE, NO\_ARTIFACTS or S3 | `string` | `"CODEPIPELINE"` | no |
| <a name="input_artifact_location"></a> [artifact\_location](#input\_artifact\_location) | Location of artifact. Applies only for artifact of type S3 | `string` | `""` | no |
| <a name="input_secondary_artifact_location"></a> [secondary\_artifact\_location](#input\_secondary\_artifact\_location) | Location of secondary artifact. Must be an S3 reference | `string` | `null` | no |
| <a name="input_secondary_artifact_identifier"></a> [secondary\_artifact\_identifier](#input\_secondary\_artifact\_identifier) | Secondary artifact identifier. Must match the identifier in the build spec | `string` | `null` | no |
| <a name="input_secondary_artifact_encryption_enabled"></a> [secondary\_artifact\_encryption\_enabled](#input\_secondary\_artifact\_encryption\_enabled) | Set to true to enable encryption on the secondary artifact bucket | `bool` | `false` | no |
| <a name="input_report_build_status"></a> [report\_build\_status](#input\_report\_build\_status) | Set to true to report the status of a build's start and finish to your source provider. This option is only valid when the source\_type is BITBUCKET or GITHUB | `bool` | `false` | no |
| <a name="input_git_clone_depth"></a> [git\_clone\_depth](#input\_git\_clone\_depth) | Truncate git history to this many commits. | `number` | `null` | no |
| <a name="input_private_repository"></a> [private\_repository](#input\_private\_repository) | Set to true to login into private repository with credentials supplied in source\_credential variable. | `bool` | `false` | no |
| <a name="input_source_credential_auth_type"></a> [source\_credential\_auth\_type](#input\_source\_credential\_auth\_type) | The type of authentication used to connect to a GitHub, GitHub Enterprise, or Bitbucket repository. | `string` | n/a | yes |
| <a name="input_source_credential_server_type"></a> [source\_credential\_server\_type](#input\_source\_credential\_server\_type) | The source provider used for this project. | `string` | n/a | yes |
| <a name="input_source_credential_token"></a> [source\_credential\_token](#input\_source\_credential\_token) | For GitHub or GitHub Enterprise, this is the personal access token. For Bitbucket, this is the app password. | `string` | `""` | no |
| <a name="input_source_credential_user_name"></a> [source\_credential\_user\_name](#input\_source\_credential\_user\_name) | The Bitbucket username when the authType is BASIC\_AUTH. This parameter is not valid for other types of source providers or connections. | `string` | `""` | no |
| <a name="input_source_version"></a> [source\_version](#input\_source\_version) | A version of the build input to be built for this project. If not specified, the latest version is used. | `string` | `""` | no |
| <a name="input_fetch_git_submodules"></a> [fetch\_git\_submodules](#input\_fetch\_git\_submodules) | If set to true, fetches Git submodules for the AWS CodeBuild build project. | `bool` | `false` | no |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB\_ENTERPRISE, BITBUCKET or S3 | `string` | n/a | yes |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for the builds to run inside a VPC. | `any` | `{}` | no |
| <a name="input_logs_config"></a> [logs\_config](#input\_logs\_config) | Configuration for the builds to store log data to CloudWatch or S3. | `any` | `{}` | no |
| <a name="input_extra_permissions"></a> [extra\_permissions](#input\_extra\_permissions) | List of action strings which will be added to IAM service account permissions. | `list(any)` | `[]` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | Path to the role. | `string` | `null` | no |
| <a name="input_iam_policy_path"></a> [iam\_policy\_path](#input\_iam\_policy\_path) | Path to the policy. | `string` | `"/service-role/"` | no |
| <a name="input_iam_permissions_boundary"></a> [iam\_permissions\_boundary](#input\_iam\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the role. | `string` | `null` | no |
| <a name="input_encryption_enabled"></a> [encryption\_enabled](#input\_encryption\_enabled) | When set to 'true' the resource will have AES256 encryption enabled by default | `bool` | `false` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Whether to enable versioning for the S3 bucket | `bool` | `true` | no |
| <a name="input_access_log_bucket_name"></a> [access\_log\_bucket\_name](#input\_access\_log\_bucket\_name) | Name of the S3 bucket where s3 access log will be sent to | `string` | `""` | no |
| <a name="input_file_system_locations"></a> [file\_system\_locations](#input\_file\_system\_locations) | A set of file system locations to to mount inside the build. File system locations are documented below. | `any` | `{}` | no |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project's build output artifacts. | `string` | `null` | no |
| <a name="input_build_image_pull_credentials_type"></a> [build\_image\_pull\_credentials\_type](#input\_build\_image\_pull\_credentials\_type) | Type of credentials AWS CodeBuild uses to pull images in your build.Valid values: CODEBUILD, SERVICE\_ROLE. When you use a cross-account or private registry image, you must use SERVICE\_ROLE credentials. | `string` | `"CODEBUILD"` | no |
| <a name="input_s3_cache_bucket_name"></a> [s3\_cache\_bucket\_name](#input\_s3\_cache\_bucket\_name) | Use an existing s3 bucket name for cache. Relevant if `cache_type` is set to `S3`. | `string` | `null` | no |
| <a name="input_codebuild_iam"></a> [codebuild\_iam](#input\_codebuild\_iam) | Additional IAM policies to add to CodePipeline IAM role. | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the codebuild project. | `string` | `"codebuild"` | no |
| <a name="input_enable_github_authentication"></a> [enable\_github\_authentication](#input\_enable\_github\_authentication) | Whether to enable Github authentication using Personal Access token.<br>    If true, it uses the github\_token  and github\_token\_type must be of type SECRETS\_MANAGER to authenticate | `bool` | `false` | no |
| <a name="input_create_ecr_access_policy"></a> [create\_ecr\_access\_policy](#input\_create\_ecr\_access\_policy) | Whether to create the ECR access policy | `bool` | `true` | no |
| <a name="input_create_webhooks"></a> [create\_webhooks](#input\_create\_webhooks) | Whether to create webhooks for Github, GitHub Enterprise or Bitbucket | `bool` | `false` | no |
| <a name="input_webhook_build_type"></a> [webhook\_build\_type](#input\_webhook\_build\_type) | Webhook build type. Choose between BUILD or BUILD\_BATCH | `string` | `"BUILD"` | no |
| <a name="input_webhook_filters"></a> [webhook\_filters](#input\_webhook\_filters) | Filters supported by webhook. EVENT, BASE\_REF, HEAD\_REF, ACTOR\_ACCOUNT\_ID, FILE\_PATH, COMMIT\_MESSAGE | `map(string)` | `{}` | no |
| <a name="input_lifecycle_rule_enabled"></a> [lifecycle\_rule\_enabled](#input\_lifecycle\_rule\_enabled) | Whether to enable a suffix for the S3 cache bucket name | `bool` | `true` | no |
| <a name="input_create_resources"></a> [create\_resources](#input\_create\_resources) | whether to create the IAM resources | `bool` | n/a | yes |
| <a name="input_artifacts"></a> [artifacts](#input\_artifacts) | list of artifacts for the codebuild project | <pre>list(object({<br>    artifact_identifier    = string<br>    type                   = string<br>    location               = string<br>    name                   = string<br>    path                   = string<br>    namespace_type         = string<br>    packaging              = string<br>    encryption_disabled    = bool<br>    override_artifact_name = bool<br>  }))</pre> | n/a | yes |
| <a name="input_secondary_artifacts"></a> [secondary\_artifacts](#input\_secondary\_artifacts) | List of secondary artifacts for the codebuild project | <pre>list(object({<br>    artifact_identifier    = string<br>    type                   = string<br>    location               = string<br>    name                   = string<br>    path                   = string<br>    namespace_type         = string<br>    packaging              = string<br>    encryption_disabled    = bool<br>    override_artifact_name = bool<br>  }))</pre> | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"servicename"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Project ID |
| <a name="output_badge_url"></a> [badge\_url](#output\_badge\_url) | The URL of the build badge when badge\_enabled is enabled |
| <a name="output_project_arn"></a> [project\_arn](#output\_project\_arn) | Project ARN |
| <a name="output_buildspec"></a> [buildspec](#output\_buildspec) | The buildspec used with the CodeBuild project |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
