
resource "aws_iam_policy_attachment" "cw_bucket_policy" {
  name = "cloudwatch-policy-attachment"
  roles = [ aws_iam_role.test_role.name ]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

}

resource "aws_iam_policy_attachment" "bucket_policy_attachment" {
  name = "bucket_policy_attachment"
  roles = [ aws_iam_role.test_role.name]
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-cloud-watch-profile"
  role = aws_iam_role.test_role.name
}