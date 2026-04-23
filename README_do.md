# LAB 16 Fallback: CPU Only on DigitalOcean (Terraform)

This fallback deploys a **CPU-only** inference environment on DigitalOcean using Terraform.

## What this creates
- 1 Droplet (default: `s-4vcpu-8gb`, Ubuntu 22.04)
- Firewall opening ports `22`, `80`, `8000`
- Startup script that installs and runs a CPU ML API (FastAPI + LightGBM)

The API exposes:
- `GET /health`
- `POST /predict` with Iris features

## 1. Prepare token
Create a DigitalOcean personal access token, then export it:

```bash
export TF_VAR_do_token="<YOUR_DO_TOKEN>"
```

PowerShell:

```powershell
$env:TF_VAR_do_token = "<YOUR_DO_TOKEN>"
```

## 2. Deploy

```bash
cd terraform-do
terraform init
terraform apply
```

Type `yes` when prompted.

## 3. Get endpoint
After apply, Terraform outputs:
- `droplet_ip`
- `health_url`
- `predict_url`

Example health check:

```bash
curl http://<DROPLET_IP>:8000/health
```

Example predict call:

```bash
curl -X POST http://<DROPLET_IP>:8000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "sepal_length": 5.1,
    "sepal_width": 3.5,
    "petal_length": 1.4,
    "petal_width": 0.2
  }'
```

## 4. SSH login (existing server)
You provided this host:
- IP: `157.230.245.220`
- User: `root`

Login command:

```bash
ssh root@157.230.245.220
```

When prompted, enter password:

```text
qwertY7secureA
```

## 5. Cleanup

```bash
cd terraform-do
terraform destroy
```

Type `yes` to remove all resources.
