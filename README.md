# ec2 jumpbox quick setup

## Usage

1. Create IAM user with AmazonEC2FullAccess policy
2. Export AWS keys
```bash
export AWS_ACCESS_KEY_ID="keyID"
export AWS_SECRET_ACCESS_KEY="secretkey"
```
3. Generate SSH keypair `ssh-keygen -f jumpbox`
4. Run the script
```bash
terraform init && terraform apply
ssh -i jumpbox ubuntu@ipaddr
```
