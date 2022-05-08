terraform_bin = /usr/local/bin/terraform
terraform_dir = "./terraform"
TMPDIR := $(shell mktemp -d)


.PHONY: remove-initial-resources
remove-initial-resources:
	-cd $(terraform_dir) && $(terraform_bin) state rm "helm_release.argo-cd"
	-cd $(terraform_dir) && $(terraform_bin) state rm "kubernetes_secret.sealed-secret-key"
	-cd $(terraform_dir) && $(terraform_bin) state rm "kubernetes_secret.cert-manager-selfsigned"

.PHONY: redeploy
redeploy: remove-initial-resources
	cd $(terraform_dir) && $(terraform_bin) apply -parallelism=10000 -auto-approve \
		-replace="esxi_guest.rke2-server[0]" \
		-replace="esxi_guest.rke2-server[1]" \
		-replace="esxi_guest.rke2-server[2]" \
		-replace="esxi_guest.rke2-agent[0]" \
		-replace="esxi_guest.rke2-agent[1]" \
		-replace="esxi_guest.rke2-agent[2]" \
		-replace="esxi_guest.rke2-agent[3]" \
		-replace="esxi_virtual_disk.rke2-server_1[0]" \
		-replace="esxi_virtual_disk.rke2-server_1[1]" \
		-replace="esxi_virtual_disk.rke2-server_1[2]" \
		-replace="esxi_virtual_disk.rke2-agent_1[0]" \
		-replace="esxi_virtual_disk.rke2-agent_1[1]" \
		-replace="esxi_virtual_disk.rke2-agent_1[2]" \
		-replace="esxi_virtual_disk.rke2-agent_1[3]"

.PHONY: update-cert
update-cert:
	echo $(TMPDIR)
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.crt"]' | base64 -d > $(TMPDIR)/tls.crt
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.key"]' | base64 -d > $(TMPDIR)/tls.key
	open $(TMPDIR)/tls.crt && sleep 30
	rm -fr $(TMPDIR)

.PHONY: update-esxi-cert
update-esxi-cert:
	echo $(TMPDIR)
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.crt"]' | base64 -d > $(TMPDIR)/rui.crt
	@kubectl -n kube-system get secret selfsigned -o json | jq -r '.data["tls.key"]' | base64 -d > $(TMPDIR)/rui.key
	scp $(TMPDIR)/rui.* esxi:/etc/vmware/ssl/
	ssh esxi "/etc/init.d/hostd restart && /etc/init.d/vpxa restart"
	rm -fr $(TMPDIR)

