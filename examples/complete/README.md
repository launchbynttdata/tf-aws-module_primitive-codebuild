# complete

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.69.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | github.com/launchbynttdata/tf-aws-module_collection-s3_bucket.git | 1.0.0 |
| <a name="module_codebuild"></a> [codebuild](#module\_codebuild) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [random_string.bucket_prefix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.codebuild_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_bucket.artifact_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"servicename"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_use_default_server_side_encryption"></a> [use\_default\_server\_side\_encryption](#input\_use\_default\_server\_side\_encryption) | Flag to indiate if default server side encryption should be used. SSE-KMS encryption is used if the flag value is set to false(which is default). If flag value is set to true then default server side encryption(encryption set by AWS for all S3 objects) | `bool` | `false` | no |
| <a name="input_kms_s3_key_sse_algorithm"></a> [kms\_s3\_key\_sse\_algorithm](#input\_kms\_s3\_key\_sse\_algorithm) | Server-side encryption algorithm to use. Valid values are AES256 and aws:kms | `string` | `"aws:kms"` | no |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Whether to enable bucket\_key for encryption. It reduces encryption costs. Default is false | `bool` | `false` | no |
| <a name="input_kms_key_description"></a> [kms\_key\_description](#input\_kms\_key\_description) | KMS key description. This KMS key is used for SSE-KMS encryption f source bucket. | `string` | `"KMS key used for source bucket encryption"` | no |
| <a name="input_kms_key_deletion_window_in_days"></a> [kms\_key\_deletion\_window\_in\_days](#input\_kms\_key\_deletion\_window\_in\_days) | (Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately. | `number` | `30` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Whether to enable versioning for this S3 bucket. Default is false | `bool` | `false` | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | List of maps containing configuration of object lifecycle management. | `any` | `[]` | no |
| <a name="input_metric_configuration"></a> [metric\_configuration](#input\_metric\_configuration) | Map containing bucket metric configuration. | `any` | `[]` | no |
| <a name="input_analytics_configuration"></a> [analytics\_configuration](#input\_analytics\_configuration) | Map containing bucket analytics configuration. | `any` | `{}` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL. | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_control_object_ownership"></a> [control\_object\_ownership](#input\_control\_object\_ownership) | Whether to manage S3 Bucket Ownership Controls on this bucket. | `bool` | `false` | no |
| <a name="input_acl"></a> [acl](#input\_acl) | The canned ACL to apply. Defaults to private. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_cache_bucket_suffix_enabled"></a> [cache\_bucket\_suffix\_enabled](#input\_cache\_bucket\_suffix\_enabled) | The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value. It only works when cache\_type is 'S3 | `bool` | `true` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER\_STORE', or 'SECRETS\_MANAGER' | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>      type  = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "NO_ADDITIONAL_BUILD_VARS",<br>    "type": "PLAINTEXT",<br>    "value": "TRUE"<br>  }<br>]</pre> | no |
| <a name="input_cache_expiration_days"></a> [cache\_expiration\_days](#input\_cache\_expiration\_days) | How many days should the build cache be kept. It only works when cache\_type is 'S3' | `number` | n/a | yes |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO\_CACHE, LOCAL, and S3.  Defaults to NO\_CACHE.  If cache\_type is S3, it will create an S3 bucket for storing codebuild cache inside | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `string` | n/a | yes |
| <a name="input_source_location"></a> [source\_location](#input\_source\_location) | Location of the source code (e.g., GitHub URL or S3 path) | `string` | `""` | no |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | The source type for CodeBuild (e.g., S3, GITHUB, CODECOMMIT) | `string` | n/a | yes |
| <a name="input_buildspec"></a> [buildspec](#input\_buildspec) | Path to the buildspec.yml file | `string` | `"buildspec.yml"` | no |
| <a name="input_codebuild_enabled"></a> [codebuild\_enabled](#input\_codebuild\_enabled) | Flag to enable or disable the module | `bool` | `true` | no |
| <a name="input_artifacts"></a> [artifacts](#input\_artifacts) | list of artifacts for the codebuild project | <pre>list(object({<br>    artifact_identifier    = string<br>    type                   = string<br>    location               = string<br>    name                   = string<br>    path                   = string<br>    namespace_type         = string<br>    packaging              = string<br>    encryption_disabled    = bool<br>    override_artifact_name = bool<br>  }))</pre> | n/a | yes |
| <a name="input_secondary_artifacts"></a> [secondary\_artifacts](#input\_secondary\_artifacts) | List of secondary artifacts for the codebuild project | <pre>list(object({<br>    artifact_identifier    = string<br>    type                   = string<br>    location               = string<br>    name                   = string<br>    path                   = string<br>    namespace_type         = string<br>    packaging              = string<br>    encryption_disabled    = bool<br>    override_artifact_name = bool<br>  }))</pre> | n/a | yes |
| <a name="input_source_credential_auth_type"></a> [source\_credential\_auth\_type](#input\_source\_credential\_auth\_type) | The type of authentication used to connect to a GitHub, GitHub Enterprise, or Bitbucket repository. | `string` | `"PERSONAL_ACCESS_TOKEN"` | no |
| <a name="input_source_credential_server_type"></a> [source\_credential\_server\_type](#input\_source\_credential\_server\_type) | The source provider used for this project. | `string` | `"GITHUB"` | no |
| <a name="input_source_credential_user_name"></a> [source\_credential\_user\_name](#input\_source\_credential\_user\_name) | The Bitbucket username when the authType is BASIC\_AUTH. This parameter is not valid for other types of source providers or connections. | `string` | `""` | no |
| <a name="input_cache_enabled"></a> [cache\_enabled](#input\_cache\_enabled) | Flag to enable or disable the module | `bool` | `true` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | Path to the role. | `string` | `null` | no |
| <a name="input_iam_permissions_boundary"></a> [iam\_permissions\_boundary](#input\_iam\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the role. | `string` | `null` | no |
| <a name="input_codebuild_iam"></a> [codebuild\_iam](#input\_codebuild\_iam) | Additional IAM policies to add to CodePipeline IAM role. | `string` | `null` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for the builds to run inside a VPC. | `any` | `{}` | no |
| <a name="input_iam_policy_path"></a> [iam\_policy\_path](#input\_iam\_policy\_path) | Path to the policy. | `string` | `"/service-role/"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Relevant if `cache_type` is set to `S3`. | `string` | `null` | no |
| <a name="input_caches_modes"></a> [caches\_modes](#input\_caches\_modes) | The type of data caching between builds. The inputs values are LOCAL\_SOURCE\_CACHE, LOCAL\_DOCKER\_LAYER\_CACHE, LOCAL\_CUSTOM\_CACHE | `string` | `"LOCAL_CUSTOM_CACHE"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | (Optional) AWS Account ID. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | `string` | `""` | no |
| <a name="input_create_ecr_access_policy"></a> [create\_ecr\_access\_policy](#input\_create\_ecr\_access\_policy) | Whether to create the ECR access policy | `bool` | `true` | no |
| <a name="input_secondary_artifact_location"></a> [secondary\_artifact\_location](#input\_secondary\_artifact\_location) | Location of secondary artifact. Must be an S3 reference | `string` | `null` | no |
| <a name="input_extra_permissions"></a> [extra\_permissions](#input\_extra\_permissions) | List of action strings which will be added to IAM service account permissions. | `list(any)` | `[]` | no |
| <a name="input_create_resources"></a> [create\_resources](#input\_create\_resources) | whether to create the IAM resources | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Project ID |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | IAM Role ID |
| <a name="output_badge_url"></a> [badge\_url](#output\_badge\_url) | The URL of the build badge when badge\_enabled is enabled |
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | the arn of the S3 bucket used for caching and or artifact |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
