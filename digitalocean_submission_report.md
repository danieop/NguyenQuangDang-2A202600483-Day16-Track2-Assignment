# CPU Fallback Report (DigitalOcean)

## Environment
- Provider: DigitalOcean
- Droplet name: ai-cpu-fallback
- Public IP: 143.198.88.115
- Verified instance resources: 2 vCPU, ~2 GB RAM, ~60 GB disk
- OS: Ubuntu 22.04.5 LTS

## Completed Steps
- Provisioned CPU fallback infrastructure with Terraform.
- Verified API endpoints were serving successfully.
- Installed Python ML stack on droplet (lightgbm, scikit-learn, pandas, numpy, kaggle).
- Downloaded Kaggle dataset mlg-ulb/creditcardfraud.
- Ran LightGBM benchmark and generated benchmark JSON.

## Benchmark Metrics
- Dataset rows: 284,807
- Dataset features: 30
- Load data time (s): 4.6448
- Training time (s): 8.1202
- Best iteration: 300
- AUC-ROC: 0.877275
- Accuracy: 0.89737
- F1-score: 0.027935
- Precision: 0.014199
- Recall: 0.857143
- Inference latency, 1 row (s): 0.003083
- Inference throughput, 1000 rows (rows/s): 99637.72

## Notes
- Multiple LightGBM warnings "No further splits with positive gain" were observed; training still completed and metrics were produced.
- Kaggle credential file permission was corrected to 600 before dataset download.

## Evidence Screenshots
- Terminal benchmark command: screenshot/command.png
- Terminal benchmark result JSON: screenshot/result.png
- DigitalOcean billing dashboard: screenshot/digitalocean_billing.png

## Submission Checklist Status
- Benchmark run screenshot: Completed
- benchmark_result.json generated: Completed
- Billing screenshot: Completed
- Infra/source report prepared: Completed
