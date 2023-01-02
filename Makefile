terraform_bin = terraform
terraform_dir = "./terraform"
TMPDIR := $(shell mktemp -d)


.PHONY: remove-kustomization-resources-state
remove-kustomization-resources-state:
	-cd $(terraform_dir) && $(terraform_bin) state rm \
		"kustomization_resource.argo-cd-dev-resource-p0" \
		"kustomization_resource.argo-cd-dev-resource-p1" \
		"kustomization_resource.argo-cd-dev-resource-p2" \
		"kubernetes_secret.sealed-secret-key"

.PHONY: redeploy
redeploy: remove-kustomization-resources-state
	cd $(terraform_dir) && $(terraform_bin) apply -auto-approve \
		-replace="esxi_guest.rke2-server[0]" \
		-replace="esxi_guest.rke2-server[1]" \
		-replace="esxi_guest.rke2-server[2]" \
		-replace="esxi_guest.rke2-agent[0]" \
		-replace="esxi_guest.rke2-agent[1]" \
		-replace="esxi_guest.rke2-agent[2]" \
		-replace="esxi_guest.rke2-agent[3]"

.PHONY: get-cert
get-cert:
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.crt"]' | base64 -d > ~/Downloads/tls.crt
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.key"]' | base64 -d > ~/Downloads/tls.key
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["ca.crt"]' | base64 -d > ~/Downloads/ca.crt

.PHONY: update-cert
update-cert:
	echo $(TMPDIR)
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.crt"]' | base64 -d > $(TMPDIR)/tls.crt
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.key"]' | base64 -d > $(TMPDIR)/tls.key
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["ca.crt"]' | base64 -d > $(TMPDIR)/ca.crt
	open $(TMPDIR)/ca.crt && sleep 30
	rm -fr $(TMPDIR)

.PHONY: update-esxi-cert
update-esxi-cert:
	echo $(TMPDIR)
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.crt"]' | base64 -d > $(TMPDIR)/rui.crt
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.key"]' | base64 -d > $(TMPDIR)/rui.key
	scp $(TMPDIR)/rui.* esxi:/etc/vmware/ssl/
	ssh esxi "/etc/init.d/hostd restart && /etc/init.d/vpxa restart"
	rm -fr $(TMPDIR)

.PHONY: get-argocd-admin-password
get-argocd-admin-password:
	@kubectl -n argocd get secret argocd-initial-admin-secret -o json | jq -r ".data.password" | base64 -d

