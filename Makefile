.PHONY: install uninstall

install:
	-helm uninstall spiredb
	helm install spiredb ./charts/spiredb

uninstall:
	helm uninstall spiredb
	kubectl delete pvc -l app.kubernetes.io/instance=spiredb
