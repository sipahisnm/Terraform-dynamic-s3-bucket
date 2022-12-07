

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "s3-bucket" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.read-only.json
}

data "aws_iam_policy_document" "read-only" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
}


resource "aws_iam_role" "s3_access_role" {
  name               = var.role_name
  assume_role_policy = "${file("iamrole.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = "My test policy"
  policy = data.aws_iam_policy_document.read-write-only.json 
}


data "aws_iam_policy_document" "read-write-only" {
  statement {
    sid = "1"

    actions = [
      "s3:GetObject",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:*Object"
    ]

    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
}  




resource "aws_iam_policy_attachment" "test-attach" {
  name       = var.attachment
  roles      = ["${aws_iam_role.s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
} 



resource "aws_s3_object" "examplebucket_object" {

  key    = "/sinem.txt"
  bucket = aws_s3_bucket.example.id
  source = "sinem.txt"
  content_type  = "text/html"

}

resource "aws_s3_object" "examplebucket" {

  key    = "/cat.png"
  bucket = aws_s3_bucket.example.id
  source = "cat.png"
  content_type  = "image/png"
  /*** content_type
    html        = "text/html",
    js          = "application/javascript",
    css         = "text/css",
    svg         = "image/svg+xml",
    jpg         = "image/jpeg",
    ico         = "image/x-icon",
    png         = "image/png",
    gif         = "image/gif",
    pdf         = "application/pdf"
  } **/

 
} 
