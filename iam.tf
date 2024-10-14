# resource "aws_iam_role" "default" {
#   count                 = var.create_resources ? 1 : 0
#   name                  = var.project_name
#   assume_role_policy    = data.aws_iam_policy_document.role.json
#   force_detach_policies = true
#   path                  = var.iam_role_path
#   permissions_boundary  = var.iam_permissions_boundary

#   dynamic "inline_policy" {
#     for_each = var.codebuild_iam != null ? [1] : []
#     content {
#       name   = var.project_name
#       policy = var.codebuild_iam
#     }
#   }

#   tags = var.tags
# }

# data "aws_iam_policy_document" "role" {
#   statement {
#     sid = ""

#     actions = [
#       "sts:AssumeRole",
#     ]

#     principals {
#       type        = "Service"
#       identifiers = ["codebuild.amazonaws.com"]
#     }

#     effect = "Allow"
#   }
# }

# resource "aws_iam_policy" "default" {
#   count  = var.create_resources ? 1 : 0
#   name   = var.project_name
#   path   = var.iam_policy_path
#   policy = data.aws_iam_policy_document.combined_permissions.json
#   tags   = var.tags
# }

# resource "aws_iam_policy" "default_cache_bucket" {
#   count = var.create_resources && local.s3_cache_enabled ? 1 : 0

#   name   = "${var.project_name}-cache-bucket"
#   path   = var.iam_policy_path
#   policy = join("", data.aws_iam_policy_document.permissions_cache_bucket.*.json)
#   tags   = var.tags
# }

# data "aws_s3_bucket" "secondary_artifact" {
#   count  = var.create_resources ? (var.secondary_artifact_location != null ? 1 : 0) : 0
#   bucket = var.secondary_artifact_location
# }

# data "aws_iam_policy_document" "permissions" {
#   count = var.create_resources ? 1 : 0

#   statement {
#     sid = ""

#     actions = compact(concat([
#       "iam:PassRole",
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#     ], var.extra_permissions))

#     effect = "Allow"

#     resources = [
#       "*",
#     ]
#   }

#   dynamic "statement" {
#     for_each = var.secondary_artifact_location != null ? [1] : []
#     content {
#       sid = ""

#       actions = [
#         "s3:PutObject",
#         "s3:GetBucketAcl",
#         "s3:GetBucketLocation"
#       ]

#       effect = "Allow"

#       resources = [
#         join("", data.aws_s3_bucket.secondary_artifact.*.arn),
#         "${join("", data.aws_s3_bucket.secondary_artifact.*.arn)}/*",
#       ]
#     }
#   }
# }

# data "aws_iam_policy_document" "vpc_permissions" {
#   count = var.create_resources && var.vpc_config != {} ? 1 : 0

#   statement {
#     sid = ""

#     actions = [
#       "ec2:CreateNetworkInterface",
#       "ec2:DescribeDhcpOptions",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DeleteNetworkInterface",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeVpcs"
#     ]

#     resources = [
#       "*",
#     ]
#   }

#   statement {
#     sid = ""

#     actions = [
#       "ec2:CreateNetworkInterfacePermission"
#     ]

#     resources = [
#       "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:network-interface/*"
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "ec2:Subnet"
#       values = formatlist(
#         "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:subnet/%s",
#         var.vpc_config.subnets
#       )
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "ec2:AuthorizedService"
#       values = [
#         "codebuild.amazonaws.com"
#       ]
#     }

#   }
# }

# data "aws_iam_policy_document" "combined_permissions" {
#   override_policy_documents = compact([
#     join("", data.aws_iam_policy_document.permissions.*.json),
#     var.vpc_config != {} ? join("", data.aws_iam_policy_document.vpc_permissions.*.json) : null
#   ])
# }

# data "aws_iam_policy_document" "permissions_cache_bucket" {
#   count = var.create_resources && local.s3_cache_enabled ? 1 : 0
#   statement {
#     sid = ""

#     actions = [
#       "s3:*",
#     ]

#     effect = "Allow"

#     resources = [
#       join("", aws_s3_bucket.cache_bucket.*.arn),
#       "${join("", aws_s3_bucket.cache_bucket.*.arn)}/*",
#     ]
#   }
# }

# resource "aws_iam_role_policy_attachment" "default" {
#   count      = var.create_resources ? 1 : 0
#   policy_arn = join("", aws_iam_policy.default.*.arn)
#   role       = join("", aws_iam_role.default.*.id)
# }

# resource "aws_iam_role_policy_attachment" "default_cache_bucket" {
#   count      = var.create_resources && local.s3_cache_enabled ? 1 : 0
#   policy_arn = join("", aws_iam_policy.default_cache_bucket.*.arn)
#   role       = join("", aws_iam_role.default.*.id)
# }
