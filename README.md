# SpireDB Helm Charts

This repository contains Helm charts for SpireDB.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up, add the repo to your local Helm:

```bash
helm repo add spiredb https://charts.spire.zone
helm repo update
```

## Charts

- [spiredb](charts/spiredb) - The Infrastructure of Truth for Enterprise AI.

## Installation

```bash
helm install my-cluster spiredb/spiredb
```
