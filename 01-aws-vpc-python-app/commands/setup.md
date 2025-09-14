Copy the pem file to Bastion server:

```bash
scp -i <pem-file-to-connect-to-server.pem> <pem-file-you-want-to-copy.pem> ubuntu@<public-IP-of-Bastion-server>:/home/ubuntu
```

After copying connect to Bastion server. Connect to Bastion server via SSH.

```bash
ssh -i <pem-file> ubuntu@<public-IP>
```

Then connect to private EC2 instance within Bastion:
```bash
ssh -i <pem-file> ubuntu@<private-IP>
```

Create a sample HTML file:
```bash
<!DOCTYPE html>
<html>
<head>
  <title>My Python App on AWS VPC</title>
</head>
<body>
  <h1>Hello from Private EC2 inside VPC 🚀</h1>
</body>
</html>

```

Start the server:
```bash
python3 -m http.server 8080
```
