# Resource block to create an S3 bucket named "Bucket_Carlos"
resource "aws_s3_bucket" "resources_bucket" {
  bucket = "bucket-carlos1234"

}
# Resource block to set as read only "Bucket_Carlos"
resource "aws_s3_bucket_ownership_controls" "resources_bucket" {
  bucket = aws_s3_bucket.resources_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "resources_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.resources_bucket, aws_s3_bucket_public_access_block.example]

  bucket = aws_s3_bucket.resources_bucket.id
  acl    = "public-read"
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.resources_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.resources_bucket.id
  policy = data.aws_iam_policy_document.iam-policy-1.json
}
data "aws_iam_policy_document" "iam-policy-1" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.resources_bucket.id}",
      "arn:aws:s3:::${aws_s3_bucket.resources_bucket.id}/*",
    ]
    actions = ["S3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  depends_on = [aws_s3_bucket_public_access_block.example]
}

resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.resources_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "404.png"
  }
  # IF you want to use the routing rule
  routing_rule {
    condition {
      key_prefix_equals = "/abc"
    }
    redirect {
      replace_key_prefix_with = "comming-soon.jpeg"
    }
  }
}

# Upload index.html file
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.resources_bucket.id
  key          = "index.html"
  source       = "C:/Users/carlo/Aws_terraform_ Project/s3_content/index.html"
  acl          = "public-read"
  content_type = "text/html"
}

# Upload Click_me.png file
resource "aws_s3_object" "click_me_png" {
  bucket       = aws_s3_bucket.resources_bucket.id
  key          = "click_me.png"
  source       = "C:/Users/carlo/Aws_terraform_ Project/s3_content/click_me.png"
  acl          = "public-read"
  content_type = "image/png"
}
# Upload 404.png file
resource "aws_s3_object" "error_png" {
  bucket       = aws_s3_bucket.resources_bucket.id
  key          = "404.png"
  source       = "C:/Users/carlo/Aws_terraform_ Project/s3_content/404.png"
  acl          = "public-read"
  content_type = "image/png"
}

