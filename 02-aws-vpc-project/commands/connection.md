To connect to dbserver in the private subnet below are the commands used:

1. Start the SSH Agent:
On your local machine (Windows shell, Git Bash, or Linux/Mac terminal).
```bash
eval "$(ssh-agent -s)"
```

2. Add Your Private Key to the Agent
```bash
ssh-add ~/.ssh/<your-pem>
```

3. To check if the key is added:
```bash
ssh-add -l

```

4. Enable Agent Forwarding When Connecting to EC2 (webserver): When you SSH into your server:
```bash
ssh -A ubuntu@<public-ip-of-ec2>
```

5. Inside webserver connect to db server:
```bash
ssh -A ubuntu@<private-ip-of-ec2-dbserver>
```
