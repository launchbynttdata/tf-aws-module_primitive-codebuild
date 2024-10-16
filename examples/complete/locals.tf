locals {
  # Construct the S3 cache bucket name
  cache_bucket_name = "${var.project_name}${var.cache_bucket_suffix_enabled ? "-${join("", random_string.bucket_prefix.*.result)}" : ""}"

  # Normalize the cache bucket name, ensuring it's lowercase and using hyphens
  cache_bucket_name_normalised = substr(
    join("-", split("_", lower(local.cache_bucket_name))),
    0,
    min(length(local.cache_bucket_name), 63),
  )

  # Determine if the cache type is S3 and if the bucket should be created
  s3_cache_enabled       = var.cache_type == "S3"
  create_s3_cache_bucket = local.s3_cache_enabled && var.bucket_name == null

  # Set the bucket name based on whether it's dynamically created or provided
  s3_bucket_name = local.create_s3_cache_bucket ? aws_s3_bucket.cache_bucket[0].bucket : var.bucket_name

  # Cache options for the CodeBuild project
  cache_options = {
    "S3" = {
      type     = "S3"
      location = local.s3_cache_enabled ? local.s3_bucket_name : "none"
    },
    "LOCAL" = {
      type  = "LOCAL"
      modes = var.caches_modes
    },
    "NO_CACHE" = {
      type = "NO_CACHE"
    }
  }

  # Final cache settings based on the cache type
  cache = local.cache_options[var.cache_type]
}


