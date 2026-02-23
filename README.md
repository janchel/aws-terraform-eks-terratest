# Modular EKS + nginx example

This Terraform project creates an AWS EKS cluster (Kubernetes v1.33) and deploys a simple nginx `Hello World` app exposed via a Kubernetes `Service` of type `LoadBalancer`.

## Terraform Deployments

The project is organized into multiple Terraform configurations for different AWS resources:

- **VPC**: Creates a VPC with public and private subnets across multiple availability zones.
- **S3**: Provisions an S3 bucket for storage.
- **Cluster**: Sets up an EKS cluster using the VPC.
- **App**: Deploys the nginx application on the EKS cluster.

Each deployment has its own directory with `main.tf`, `variables.tf`, `outputs.tf`, and `versions.tf`. Modules are located in the `modules/` directory.

To deploy a specific component:

1. Navigate to the component directory (e.g., `cd vpc`).
2. Initialize Terraform: `terraform init`
3. Plan: `terraform plan -out plan.tfplan`
4. Apply: `terraform apply plan.tfplan`

For the full EKS + nginx setup, follow the usage steps below.

## Usage

1. Configure AWS credentials in your environment (e.g., `AWS_PROFILE` or `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`).
2. Initialize Terraform:

```bash
terraform init
```

3. Plan and apply:

```bash
terraform plan -out plan.tfplan
terraform apply plan.tfplan
```

4. After apply completes, get the kubeconfig file path and the LB hostname/IP from outputs:

```bash
terraform output kubeconfig_file
terraform output nginx_lb_hostname
terraform output nginx_lb_ip
```

## Terratest Tests

The project includes Terratest integration tests to validate the Terraform deployments.

- **S3 Test**: Tests the S3 bucket creation, verifying bucket name, ARN, and domain name.
- **VPC Test**: Tests the VPC setup, checking VPC ID, public and private subnets, and availability zones.

To run the tests:

1. Navigate to the `terratest` directory: `cd terratest`
2. Run all tests: `go test -v`
3. Run a specific test: `go test -v -run TestS3` or `go test -v -run TestVpc`

Tests will initialize, apply, and destroy the resources automatically.

## Notes

- The `modules/eks` module wraps `terraform-aws-modules/eks/aws` and creates a VPC and a managed node group by default.
- The nginx app is created in `modules/nginx` as a Deployment + Service. The Service is `LoadBalancer` type so AWS will provision a load balancer. To use ALB with Ingress you should install the AWS Load Balancer Controller and switch to an Ingress resource.
- The kubeconfig is written to `kubeconfig_<cluster_name>.yaml` in the root folder.
