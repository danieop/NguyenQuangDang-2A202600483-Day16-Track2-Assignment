#!/bin/bash
set -euo pipefail

exec > >(tee -a /var/log/user-data.log) 2>&1

echo "[INFO] Installing CPU inference API dependencies"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y python3 python3-pip python3-venv

mkdir -p /opt/cpu-api
cd /opt/cpu-api

python3 -m venv .venv
source .venv/bin/activate

pip install --upgrade pip
pip install fastapi uvicorn[standard] lightgbm scikit-learn numpy

cat > /opt/cpu-api/app.py << 'PYEOF'
from fastapi import FastAPI
from pydantic import BaseModel
import numpy as np
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from lightgbm import LGBMClassifier

app = FastAPI(title="CPU Fallback Inference API")

# Train once at boot for a lightweight, reproducible CPU fallback.
iris = load_iris()
X_train, X_test, y_train, y_test = train_test_split(
    iris.data,
    iris.target,
    test_size=0.2,
    random_state=42,
    stratify=iris.target,
)
model = LGBMClassifier(
    n_estimators=120,
    learning_rate=0.05,
    num_leaves=31,
    random_state=42,
)
model.fit(X_train, y_train)

class IrisPayload(BaseModel):
    sepal_length: float
    sepal_width: float
    petal_length: float
    petal_width: float

@app.get("/health")
def health():
    return {"status": "ok", "service": "cpu-fallback-api"}

@app.post("/predict")
def predict(payload: IrisPayload):
    x = np.array([
        [
            payload.sepal_length,
            payload.sepal_width,
            payload.petal_length,
            payload.petal_width,
        ]
    ])
    pred = int(model.predict(x)[0])
    label = iris.target_names[pred]
    return {"class_id": pred, "class_name": label}
PYEOF

cat > /etc/systemd/system/cpu-api.service << 'SVCEOF'
[Unit]
Description=CPU Fallback Inference API
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/cpu-api
ExecStart=/opt/cpu-api/.venv/bin/uvicorn app:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=3
User=root

[Install]
WantedBy=multi-user.target
SVCEOF

systemctl daemon-reload
systemctl enable cpu-api
systemctl restart cpu-api

echo "[INFO] CPU fallback API is up on port 8000"
