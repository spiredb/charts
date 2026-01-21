# Spire Charts Makefile
# Helm chart operations for SpireDB, SpireSQL, and complete Spire stack

.PHONY: deps install install-prod upgrade uninstall lint template status \
	install-spiredb install-spiresql uninstall-spiredb \
	pf-sql pf-db help

# ============================================================================
# Umbrella Chart Operations (Complete Stack)
# ============================================================================

# Update Helm dependencies for umbrella chart
deps:
	cd charts/spire && helm dependency update

# Install complete Spire stack (SpireDB + SpireSQL + HAProxy)
install: deps
	helm install spire ./charts/spire \
		--create-namespace \
		--namespace spire

# Install with production configuration
install-prod: deps
	helm install spire ./charts/spire \
		--create-namespace \
		--namespace spire \
		--set spiresql.replicaCount=3 \
		--set spiresql.autoscaling.maxReplicas=20

# Upgrade existing installation
upgrade: deps
	helm upgrade spire ./charts/spire \
		--namespace spire

# Uninstall complete stack
uninstall:
	helm uninstall spire --namespace spire

# ============================================================================
# Individual Chart Installations
# ============================================================================

# Install only SpireDB
install-spiredb:
	helm install spiredb ./charts/spiredb \
		--create-namespace \
		--namespace spire

# Install only SpireSQL (requires existing SpireDB)
install-spiresql:
	helm install spiresql ./charts/spiresql \
		--create-namespace \
		--namespace spire \
		--set spiredb.service=spiredb

# Uninstall SpireDB (legacy target)
uninstall-spiredb:
	helm uninstall spiredb --namespace spire
	kubectl delete pvc -l app.kubernetes.io/instance=spiredb -n spire

# ============================================================================
# Utilities
# ============================================================================

# Lint all charts
lint:
	@echo "Linting SpireDB chart..."
	@helm lint ./charts/spiredb
	@echo "Linting SpireSQL chart..."
	@helm lint ./charts/spiresql
	@echo "Linting Spire umbrella chart..."
	@helm lint ./charts/spire

# Show what would be installed (dry-run)
template:
	helm template spire ./charts/spire

# Get status of deployment
status:
	helm status spire --namespace spire

# ============================================================================
# Port Forwarding
# ============================================================================

# Port-forward to SpireSQL via HAProxy (load balanced)
pf-sql:
	@echo "Port-forwarding to SpireSQL via HAProxy on localhost:5432"
	@echo "Connect with: psql -h localhost -p 5432"
	kubectl port-forward -n spire svc/spire-haproxy 5432:5432

# Port-forward to SpireDB (Redis)
pf-db:
	@echo "Port-forwarding to SpireDB on localhost:6379"
	@echo "Connect with: redis-cli -p 6379"
	kubectl port-forward -n spire svc/spire-spiredb 6379:6379

# ============================================================================
# Help
# ============================================================================

help:
	@echo "Spire Charts Makefile"
	@echo ""
	@echo "Umbrella Chart (Complete Stack):"
	@echo "  make install        - Install SpireDB + SpireSQL + HAProxy"
	@echo "  make install-prod   - Install with production settings"
	@echo "  make upgrade        - Upgrade existing installation"
	@echo "  make uninstall      - Remove deployment"
	@echo ""
	@echo "Individual Charts:"
	@echo "  make install-spiredb   - Install only SpireDB"
	@echo "  make install-spiresql  - Install only SpireSQL"
	@echo ""
	@echo "Utilities:"
	@echo "  make lint           - Lint all charts"
	@echo "  make template       - Preview manifests"
	@echo "  make status         - Check deployment status"
	@echo "  make deps           - Update chart dependencies"
	@echo ""
	@echo "Port Forwarding:"
	@echo "  make pf-sql         - Forward PostgreSQL (5432)"
	@echo "  make pf-db          - Forward Redis (6379)"
