default:
	cd ~/scripts
	sudo chmod -x plnx-env-setup.sh
	sudo chmod -x petalinux-v2022.2-10141622-installer.run
	sudo bash ./plnx-env-setup.sh
	sudo apt install rsync
	sudo apt update
	sudo apt install libidn11
	bash ./petalinux-v2022.2-10141622-installer.run -d ../petalinux/ -p aarch64
	source ~/petalinux/settings.sh

