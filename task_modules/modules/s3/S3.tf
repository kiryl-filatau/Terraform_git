variable "bucket"     {default = "kf_S3_logging"}
variable "bucket_id"  {}

#creating S3 BUCKET
resource "aws_s3_bucket" "kf_S3_logging" {
    bucket        = "${var.bucket}"
    force_destroy = true
}


#creating S3 BUCKET POLICY
resource "aws_s3_bucket_policy" "kf_S3_logging" {
    bucket        = "${var.bucket_id}"
    policy        =<<POLICY
{
  "Id": "Policy1510836277408",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1510836271067",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::kf_S3_logging/*",
      "Principal": {
        "AWS": [
          "127311923021"
        ]
      }
    }
  ]
}
POLICY
}

output "bucket_id" {value = "${aws_s3_bucket.kf_S3_logging.id}"}