#!/bin/bash
dnf update -y
dnf install -y httpd awscli
systemctl start httpd
systemctl enable httpd

# Copy files from S3 bucket
aws s3 sync s3://my-static-website-test-bucket-varshita-jyotsna /var/www/html
echo "<p>Served from $(hostname -f)</p>" >> /var/www/html/index.html

systemctl restart httpd

# CloudWatch Agent config
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/httpd/access_log",
            "log_group_name": "my-httpd-logs",
            "log_stream_name": "{instance_id}-access"
          },
          {
            "file_path": "/var/log/httpd/error_log",
            "log_group_name": "my-httpd-logs",
            "log_stream_name": "{instance_id}-error"
          }
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
