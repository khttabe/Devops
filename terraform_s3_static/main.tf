

resource "aws_s3_bucket" "my_bucket" {
  bucket = "ahmedabdelaziz32" 
}
////////////////////////////////////

resource "aws_s3_bucket_ownership_controls" "my_bucket_oner" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket_public_acc"{
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my_bucket_oner,
    aws_s3_bucket_public_access_block.my_bucket_public_acc,
  ]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
  }
  resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "ahmed.jpg"
  source = "Ahmed.jpg"
  acl = "public-read"
  }
  //////////////////////////////////////
  resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }
  depends_on = [aws_s3_bucket_acl.my_bucket_acl]
}