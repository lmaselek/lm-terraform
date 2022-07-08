# lm-terraform
Simple project with AWS, Terraform and XMPP

1. Run `./bundle-lambda.sh` in order to prepare dependencies and zip file for lambda.

2. Run `terraform init`.
3. Run `terraform apply --auto-approve` in order to create environment.

4. Run `terraform destroy` in order to destroy environment.
