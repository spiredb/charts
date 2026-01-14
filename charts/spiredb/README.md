# SpireDB Helm Chart

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Cluster Secret

Create the Erlang cookie secret once per cluster before deploying:

```bash
kubectl create secret generic spiredb-cluster \
  --from-literal=erlang-cookie=$(openssl rand -hex 32)
```

All pods will share this cookie for cluster communication.

## Installing

```bash
helm repo add spiredb https://charts.spiredb.com
helm install my-spiredb spiredb/spiredb
```

## Configuration

See [values.yaml](values.yaml) for full configuration options.

Key parameters:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of SpireDB replicas | `3` |
| `config.pd.startRaft` | Enable Raft on PD startup | `true` |
| `persistence.enabled` | Enable persistent storage | `true` |
| `resources.limits.memory` | Memory limit per pod | `8Gi` |
