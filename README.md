This repo is a working starting point for using AWS. It implements:

- **ECS/Fargate**: A containerized Flask app behind an **ALB**, provisioned with Terraform.
- **CI/CD (GitHub Actions)**: Builds Docker image, pushes to **ECR**, runs Terraform checks/tests, and deploys to AWS.
- **Secure S3 bucket**: Created via Terraform with **encryption at rest** and **public access block**, with a `terraform test` validating configuration.
- **CloudWatch Logs Alarm Module**: Metric filter that counts a matching log line; a CloudWatch Alarm notifies an **SNS email** if >10 matches/min.
- **Best practices**: `terraform fmt`, `validate`, and `terraform test` are run in CI. Optionally add `tflint`/`tfsec`.

> ⚠️ You’ll need an AWS account + credentials in your repo settings (see **Secrets** below).

---

## Architecture (MVP)

- A new VPC with two public subnets and an Internet Gateway.
- An **Application Load Balancer** (ALB) publicly accessible on port 80.
- An **ECS Fargate** cluster + service running a single task (the Flask app).
- **CloudWatch Logs** for the ECS task; the alarm module attaches a **metric filter** to those logs and an alarm sends an email via **SNS**.
- A **secure S3 bucket** (encryption + public access block) with `terraform test` verifying correctness.

---

## What you can demo quickly

1. **Deploy**: Push to `main` (or run the GitHub Actions workflow manually) to build/push image and apply Terraform.
2. **Visit the ALB DNS**: The Flask app returns a small page with a cat GIF URL (and writes a specific log line).
3. **Trigger the Alarm**: The app logs the string configured in `alarm_match_string` (default `ALERT_TRIGGER`). Hit the page multiple times (or curl it in a loop) to exceed 10 matches in a minute and watch your Inbox for the SNS email.
4. **Show Tests**: Run `terraform test` in `terraform/modules/s3_secure_bucket` to see the S3 validation pass.

---

## Prereqs

- Terraform >= 1.8
- AWS credentials (access key and secret or OIDC) with permissions for: VPC, ECS/Fargate, ECR, ALB, IAM, CloudWatch, SNS, S3.
- Docker (for local builds; CI builds in GitHub Actions).

---

## Repo layout

```
app/                          # Flask app + Dockerfile
terraform/
  main.tf
  variables.tf
  outputs.tf
  versions.tf
  envs/dev/terraform.tfvars   # Example variable values
  modules/
    ecs_service/              # ECS Fargate + ALB + ECR (for image)
      main.tf
      variables.tf
      outputs.tf
    s3_secure_bucket/         # S3 bucket + tests
      main.tf
      variables.tf
      tests/s3_bucket.tftest.hcl
    log_alarm/                # Logs metric filter + alarm + SNS
      main.tf
      variables.tf
      outputs.tf
.github/workflows/ci.yml      # CI: build image, push to ECR, terraform test/plan/apply
README.md
```

---

## One‑time setup

1. Create a **public** (or private) GitHub repo and push this code.
2. In **AWS ECR**, you don’t need to pre-create the repo — Terraform does it.
3. In **GitHub → Settings → Secrets and variables → Actions**, add:
   - `AWS_REGION` (e.g., `us-east-1`)
   - Either **(a) long‑lived creds** (simple for exercise):
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
   - Or **(b) OIDC role** (preferred for prod; see `aws-actions/configure-aws-credentials@v4` docs).

---

## Local commands

```bash
# 1) Build the app locally (optional)
cd app
docker build -t catgif:local .

# 2) Terraform deploy (from terraform/)
cd ../terraform
terraform init
terraform fmt -check
terraform validate
terraform plan -var-file=envs/dev/terraform.tfvars
terraform apply -auto-approve -var-file=envs/dev/terraform.tfvars

# 3) Get the ALB DNS name after apply
terraform output alb_dns_name

# 4) Run S3 module tests
cd modules/s3_secure_bucket
terraform test
```

---

## Variables of interest

- `image_tag`: The image tag to deploy (CI sets it to the Git SHA).
- `alarm_email`: Where SNS sends alarm emails (must confirm subscription).
- `alarm_match_string`: The log substring to count (default `ALERT_TRIGGER`).

---

## Improvements you can discuss in review

- Use private subnets + NAT and an internal service + public ALB.
- Add WAFv2 on ALB.
- Add TLS (ACM cert + HTTPS listener).
- Use Service Discovery + ECS Exec.
- Autoscaling on CPU/Memory requests.
- Replace public subnets with private, add NAT/egress VPC endpoints.
- IaC lint/security scanning (tflint, tfsec) and OPA policy checks.
- Blue/Green deploys with CodeDeploy, canary, health checks.
- Replace Flask with your own app, add health endpoints and metrics.

---

Happy hacking!
