This repository provides the basic template for an AWS Codebuild Project, it creates an S3 bucket for artifacts and an IAM Role for Codebuild to write into the bucket.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0, <=1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | github.com/launchbynttdata/tf-aws-module_collection-s3_bucket.git | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [random_string.bucket_prefix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.codebuild_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | The canned ACL to apply. Defaults to private. | `string` | `null` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_analytics_configuration"></a> [analytics\_configuration](#input\_analytics\_configuration) | Map containing bucket analytics configuration. | `any` | `{}` | no |
| <a name="input_artifacts"></a> [artifacts](#input\_artifacts) | list of artifacts for the codebuild project | <pre>list(object({<br/>    artifact_identifier    = string<br/>    type                   = string<br/>    location               = string<br/>    name                   = string<br/>    path                   = string<br/>    namespace_type         = string<br/>    packaging              = string<br/>    encryption_disabled    = bool<br/>    override_artifact_name = bool<br/>  }))</pre> | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | (Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `string` | n/a | yes |
| <a name="input_badge_enabled"></a> [badge\_enabled](#input\_badge\_enabled) | Generates a publicly-accessible URL for the projects build badge. Available as badge\_url attribute when enabled | `bool` | `false` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Whether to enable bucket\_key for encryption. It reduces encryption costs. Default is false | `bool` | `false` | no |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | Instance type of the build instance | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html | `string` | `"aws/codebuild/standard:2.0"` | no |
| <a name="input_build_image_pull_credentials_type"></a> [build\_image\_pull\_credentials\_type](#input\_build\_image\_pull\_credentials\_type) | Type of credentials AWS CodeBuild uses to pull images in your build.Valid values: CODEBUILD, SERVICE\_ROLE. When you use a cross-account or private registry image, you must use SERVICE\_ROLE credentials. | `string` | `"CODEBUILD"` | no |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed | `number` | `60` | no |
| <a name="input_build_type"></a> [build\_type](#input\_build\_type) | The type of build environment, e.g. 'LINUX\_CONTAINER' or 'WINDOWS\_CONTAINER' | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_buildspec"></a> [buildspec](#input\_buildspec) | Optional buildspec declaration to use for building the project | `string` | `""` | no |
| <a name="input_cache_bucket_suffix_enabled"></a> [cache\_bucket\_suffix\_enabled](#input\_cache\_bucket\_suffix\_enabled) | The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value. It only works when cache\_type is 'S3 | `bool` | n/a | yes |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO\_CACHE, LOCAL, and S3.  Defaults to NO\_CACHE.  If cache\_type is S3, the name of the S3 bucket will need to be provided | `string` | `"NO_CACHE"` | no |
| <a name="input_caches_modes"></a> [caches\_modes](#input\_caches\_modes) | The type of data caching between builds. The inputs values are LOCAL\_SOURCE\_CACHE, LOCAL\_DOCKER\_LAYER\_CACHE, LOCAL\_CUSTOM\_CACHE | `string` | `"LOCAL_CUSTOM_CACHE"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_codebuild_enabled"></a> [codebuild\_enabled](#input\_codebuild\_enabled) | Flag to enable or disable the module | `bool` | n/a | yes |
| <a name="input_concurrent_build_limit"></a> [concurrent\_build\_limit](#input\_concurrent\_build\_limit) | Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit. | `number` | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_control_object_ownership"></a> [control\_object\_ownership](#input\_control\_object\_ownership) | Whether to manage S3 Bucket Ownership Controls on this bucket. | `bool` | `false` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Short description of the CodeBuild project | `string` | `"Managed by Terraform"` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Whether to enable versioning for this S3 bucket. Default is false | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project's build output artifacts. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER\_STORE', or 'SECRETS\_MANAGER' | <pre>list(object(<br/>    {<br/>      name  = string<br/>      value = string<br/>      type  = string<br/>    }<br/>  ))</pre> | `[]` | no |
| <a name="input_fetch_git_submodules"></a> [fetch\_git\_submodules](#input\_fetch\_git\_submodules) | If set to true, fetches Git submodules for the AWS CodeBuild build project. | `bool` | `false` | no |
| <a name="input_file_system_locations"></a> [file\_system\_locations](#input\_file\_system\_locations) | A set of file system locations to to mount inside the build. File system locations are documented below. | `any` | `{}` | no |
| <a name="input_git_clone_depth"></a> [git\_clone\_depth](#input\_git\_clone\_depth) | Truncate git history to this many commits. | `number` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_kms_key_deletion_window_in_days"></a> [kms\_key\_deletion\_window\_in\_days](#input\_kms\_key\_deletion\_window\_in\_days) | (Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately. | `number` | `30` | no |
| <a name="input_kms_key_description"></a> [kms\_key\_description](#input\_kms\_key\_description) | KMS key description. This KMS key is used for SSE-KMS encryption f source bucket. | `string` | `"KMS key used for source bucket encryption"` | no |
| <a name="input_kms_s3_key_sse_algorithm"></a> [kms\_s3\_key\_sse\_algorithm](#input\_kms\_s3\_key\_sse\_algorithm) | Server-side encryption algorithm to use. Valid values are AES256 and aws:kms | `string` | `"aws:kms"` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | List of maps containing configuration of object lifecycle management. | `any` | `[]` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br/>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br/>    For example, backend, frontend, middleware etc. | `string` | `"servicename"` | no |
| <a name="input_logs_config"></a> [logs\_config](#input\_logs\_config) | Configuration for the builds to store log data to CloudWatch or S3. | `any` | `{}` | no |
| <a name="input_metric_configuration"></a> [metric\_configuration](#input\_metric\_configuration) | Map containing bucket metric configuration. | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL. | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | (Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the codebuild project. | `string` | n/a | yes |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_report_build_status"></a> [report\_build\_status](#input\_report\_build\_status) | Set to true to report the status of a build's start and finish to your source provider. This option is only valid when the source\_type is BITBUCKET or GITHUB | `bool` | `false` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_s3_cache_bucket_name"></a> [s3\_cache\_bucket\_name](#input\_s3\_cache\_bucket\_name) | Use an existing s3 bucket name for cache. Relevant if `cache_type` is set to `S3`. | `string` | `null` | no |
| <a name="input_secondary_artifacts"></a> [secondary\_artifacts](#input\_secondary\_artifacts) | List of secondary artifacts for the codebuild project | <pre>list(object({<br/>    artifact_identifier    = string<br/>    type                   = string<br/>    location               = string<br/>    name                   = string<br/>    path                   = string<br/>    namespace_type         = string<br/>    packaging              = string<br/>    encryption_disabled    = bool<br/>    override_artifact_name = bool<br/>  }))</pre> | n/a | yes |
| <a name="input_secondary_sources"></a> [secondary\_sources](#input\_secondary\_sources) | (Optional) secondary source for the codebuild project in addition to the primary location | <pre>list(object(<br/>    {<br/>      git_clone_depth     = number<br/>      location            = string<br/>      source_identifier   = string<br/>      type                = string<br/>      fetch_submodules    = bool<br/>      insecure_ssl        = bool<br/>      report_build_status = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_service_role_arn"></a> [service\_role\_arn](#input\_service\_role\_arn) | The ARN of the IAM role for Codebuild | `string` | n/a | yes |
| <a name="input_source_location"></a> [source\_location](#input\_source\_location) | The location of the source code from git or s3 | `string` | `""` | no |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB\_ENTERPRISE, BITBUCKET or S3 | `string` | n/a | yes |
| <a name="input_source_version"></a> [source\_version](#input\_source\_version) | A version of the build input to be built for this project. If not specified, the latest version is used. | `string` | `""` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_use_default_server_side_encryption"></a> [use\_default\_server\_side\_encryption](#input\_use\_default\_server\_side\_encryption) | Flag to indiate if default server side encryption should be used. SSE-KMS encryption is used if the flag value is set to false(which is default). If flag value is set to true then default server side encryption(encryption set by AWS for all S3 objects) | `bool` | `false` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for the builds to run inside a VPC. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_badge_url"></a> [badge\_url](#output\_badge\_url) | The URL of the build badge when badge\_enabled is enabled |
| <a name="output_buildspec"></a> [buildspec](#output\_buildspec) | The buildspec used with the CodeBuild project |
| <a name="output_project_arn"></a> [project\_arn](#output\_project\_arn) | Project ARN |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Project ID |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The arn of s3 bucket created for artifact and or caching |
| <a name="output_service_role_arn"></a> [service\_role\_arn](#output\_service\_role\_arn) | The arn of the service role created for the codebuild project |
