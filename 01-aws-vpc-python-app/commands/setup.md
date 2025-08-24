Copy the pem file to Bastion server:

```bash
scp -i <pem-file-to-connect-to-server.pem> <pem-file-you-want-to-copy.pem> ubuntu@<public-IP-of-Bastion-server>:/home/ubuntu


