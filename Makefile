.PHONY: reset-password

reset-password:
	ansible-playbook playbooks/reset-password-rescue.yml -i inventories/rescue/hosts.yml
