# IAM Role for CodeBuild
resource "aws_iam_role" "default" {
  count                 = var.cache_enabled ? 1 : 0
  name                  = "${var.project_name}-default-role"
  assume_role_policy    = data.aws_iam_policy_document.role.json
  force_detach_policies = true
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_permissions_boundary

  dynamic "inline_policy" {
    for_each = var.codebuild_iam != null ? [1] : []
    content {
      name   = "${var.project_name}-codebuild-policy"
      policy = var.codebuild_iam
    }
  }

  tags = var.tags
}

# Combined IAM Policy Document (includes ECR and VPC permissions if needed)
data "aws_iam_policy_document" "combined_permissions" {
  override_policy_documents = compact([
    join("", data.aws_iam_policy_document.permissions.*.json),
    var.vpc_config != {} ? join("", data.aws_iam_policy_document.ecr_vpc_permissions.*.json) : null
  ])
}

# CodeBuild Policy
resource "aws_iam_policy" "default" {
  count  = var.cache_enabled ? 1 : 0
  name   = "${var.project_name}-default-policy"
  path   = var.iam_policy_path
  policy = data.aws_iam_policy_document.combined_permissions.json
  tags   = var.tags
}

# Permissions for S3 Cache Bucket
data "aws_iam_policy_document" "permissions_cache_bucket" {
  count = var.cache_enabled && local.s3_cache_enabled ? 1 : 0
  statement {
    sid = ""

    actions = [
      "s3:*",
    ]

    effect = "Allow"

    resources = [
      join("", aws_s3_bucket.cache_bucket.*.arn),
      "${join("", aws_s3_bucket.cache_bucket.*.arn)}/*",
    ]
  }
}

# Attach the CodeBuild role to default policy
resource "aws_iam_role_policy_attachment" "default" {
  count      = var.cache_enabled ? 1 : 0
  policy_arn = join("", aws_iam_policy.default.*.arn)
  role       = join("", aws_iam_role.default.*.id)
}

# Attach the Cache Bucket Policy to CodeBuild role
resource "aws_iam_role_policy_attachment" "default_cache_bucket" {
  count      = var.cache_enabled && local.s3_cache_enabled ? 1 : 0
  policy_arn = join("", aws_iam_policy.default_cache_bucket.*.arn)
  role       = join("", aws_iam_role.default.*.id)
}

# IAM Policy to Assume CodeBuild Role
data "aws_iam_policy_document" "role" {
  statement {
    sid     = ""
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    effect = "Allow"
  }
}

# ECR Access and VPC Permissions Policy Document
data "aws_iam_policy_document" "ecr_vpc_permissions" {
  count = var.cache_enabled && var.vpc_config != {} ? 1 : 0 

  # VPC Permissions
  statement {
    sid = ""

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]

    resources = [
      "*",
    ]
  }

  # Network Interface Permissions
  statement {
    sid = ""

    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:network-interface/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:Subnet"
      values = length(lookup(var.vpc_config, "subnets", [])) > 0 ? formatlist(
        "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:subnet/%s",
        var.vpc_config.subnets): []
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values = [
        "codebuild.amazonaws.com"
      ]
    }
  }

  # ECR Permissions
  statement {
    sid = "ECRPermissions"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:BatchGetImage",
      "ecr:PutImage"
    ]

    resources = ["*"]
  }
}

# ECR Access Policy Resource
resource "aws_iam_policy" "ecr_access_policy" {
  count  = var.cache_enabled ? 1 : 0
  name   = "${var.project_name}-ecr-access"
  policy = data.aws_iam_policy_document.ecr_vpc_permissions[count.index].json
}

# ECR Access Policy Attachment to CodeBuild Role
resource "aws_iam_role_policy_attachment" "codebuild_ecr_vpc_policy_attachment" {
  count      = var.cache_enabled ? 1 : 0
  policy_arn = aws_iam_policy.ecr_access_policy[count.index].arn
  role       = aws_iam_role.default[count.index].name
}

# Data source to get the secondary artifact bucket
data "aws_s3_bucket" "secondary_artifact" {
  count  = var.cache_enabled ? (var.secondary_artifact_location != null ? 1 : 0) : 0
  bucket = var.secondary_artifact_location
}

# Cache bucket policy for secondary artifacts (if applicable)
resource "aws_iam_policy" "default_cache_bucket" {
  count = var.cache_enabled && local.s3_cache_enabled ? 1 : 0

  name   = "${var.project_name}-cache-bucket"
  path   = var.iam_policy_path
  policy = join("", data.aws_iam_policy_document.permissions_cache_bucket.*.json)
  tags   = var.tags
}

# Permissions for CodeBuild to interact with S3, CloudWatch, and IAM
data "aws_iam_policy_document" "permissions" {
  count = var.cache_enabled ? 1 : 0

  statement {
    sid = ""

    actions = compact(concat([
      "iam:PassRole",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ], var.extra_permissions))

    effect = "Allow"

    resources = [
      "*",
    ]
  }

  # Add S3 permissions for secondary artifact location
  dynamic "statement" {
    for_each = var.secondary_artifact_location != null ? [1] : []
    content {
      sid = ""

      actions = [
        "s3:PutObject",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ]

      effect = "Allow"

      resources = [
        join("", data.aws_s3_bucket.secondary_artifact.*.arn),
        "${join("", data.aws_s3_bucket.secondary_artifact.*.arn)}/*",
      ]
    }
  }
}
