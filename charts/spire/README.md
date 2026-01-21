# Spire - Complete Database Stack

Deploy SpireDB + SpireSQL + HAProxy in one command.

## Architecture

```
┌─────────────────────────────────────────────┐
│          HAProxy Load Balancer              │
│         (PostgreSQL Port 5432)              │
└────────────────┬────────────────────────────┘
                 │
      ┌──────────┴──────────┐
      │                     │
┌─────▼─────┐         ┌─────▼─────┐
│ SpireSQL  │         │ SpireSQL  │
│  Pod 1    │   ...   │  Pod N    │
└─────┬─────┘         └─────┬─────┘
      │                     │
      └───────────┬─────────┘
                  │
        ┌─────────▼──────────┐
        │     SpireDB        │
        │  (Raft Cluster)    │
        └────────────────────┘
```

## Quick Start

```bash
# Install complete stack
helm install spire ./spire_charts/charts/spire

# Connect via PostgreSQL
kubectl get svc spire-haproxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
psql -h <EXTERNAL_IP> -p 5432

# Or port-forward
kubectl port-forward svc/spire-haproxy 5432:5432
psql -h localhost -p 5432
```

## Install Options

### Production (with all components)
```bash
helm install spire ./spire_charts/charts/spire \
  --set spiresql.replicaCount=3 \
  --set spiresql.autoscaling.maxReplicas=20
```

### Development (without HAProxy)
```bash
helm install spire ./spire_charts/charts/spire \
  --set haproxy.enabled=false
```

### Only SpireDB
```bash
helm install spire ./spire_charts/charts/spire \
  --set spiresql.enabled=false \
  --set haproxy.enabled=false
```

## Configuration

### SpireDB Settings
```yaml
spiredb:
  enabled: true
  # See charts/spiredb/values.yaml for options
```

### SpireSQL Settings
```yaml
spiresql:
  enabled: true
  replicaCount: 2
  autoscaling:
    minReplicas: 2
    maxReplicas: 10
  config:
    queryCacheCapacity: 65536
    logLevel: "info"
```

### HAProxy Settings
```yaml
haproxy:
  enabled: true
  service:
    type: LoadBalancer  # Change to NodePort or ClusterIP
```

## Accessing Services

### PostgreSQL (via HAProxy)
```bash
# Get external IP
kubectl get svc spire-haproxy

# Connect
psql -h <EXTERNAL_IP> -p 5432
```

### Redis (SpireDB RESP)
```bash
kubectl port-forward svc/spire-spiredb 6379:6379
redis-cli -p 6379
```

## Uninstall

```bash
helm uninstall spire
```
