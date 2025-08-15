PROJECT_DIR=/home/chustillo/projects/Eth_Gen_Ana_petaproject
RECIPE_DIR=$(PROJECT_DIR)/project-spec/meta-user/recipes-modules/pckgendriver/files
SERVER_RECIPE_DIR=$(PROJECT_DIR)/project-spec/meta-user/recipes-apps/webserver/files
DOCKER_CONTAINER=peta_container
SETTINGS_PATH= /home/chustillo/petalinux/settings.sh

SD_PART1_PATH = /media/chustillo/6C8E-865C
SD_PART2_PATH = /media/chustillo/46f91566-ca96-4954-8c2b-462c40af0ae4


all: copy-driver copy-server build-project export-project dismount
project: copy-driver build-driver export-driver

copy-driver:	
	@echo "Copiando archivos al contenedor (Driver)"
	@for file in $(shell ls driver/); do \
		docker cp /home/chustillo/web_server/driver/$$file $(DOCKER_CONTAINER):$(RECIPE_DIR)/;\
	done
	

copy-server:
	@echo "Copiando archivos al contendor (Server)"
	@for file in $(shell ls html/); do \
		docker cp /home/chustillo/web_server/html/$$file $(DOCKER_CONTAINER):$(SERVER_RECIPE_DIR)/;\
	done

build-driver:
	@echo "Ejecutando petalinux-build para pckgendriver..."
	docker exec $(DOCKER_CONTAINER) bash -c "source $(SETTINGS_PATH) && cd $(PROJECT_DIR) && petalinux-build -c pckgendriver -x cleansstate"
	docker exec $(DOCKER_CONTAINER) bash -c "source $(SETTINGS_PATH) && cd $(PROJECT_DIR) && petalinux-build -c pckgendriver"

export-driver: 
	@echo "Exportando pckgendriver.ko fuera del contenedor..."
	docker cp $(DOCKER_CONTAINER):$(PROJECT_DIR)/build/tmp/sysroots-components/zynqmp_generic/pckgendriver/lib/modules/5.15.36-xilinx-v2022.2/extra/pckgendriver.ko .

	scp -P 2222 -O pckgendriver.ko root@192.168.1.100:/lib/modules/5.15.36-xilinx-v2022.2/extra/pckgendriver.ko

build-project:
	docker exec $(DOCKER_CONTAINER) bash -c "source $(SETTINGS_PATH) && cd $(PROJECT_DIR) && petalinux-build -c pckgendriver -x cleansstate"
	docker exec $(DOCKER_CONTAINER) bash -c "source $(SETTINGS_PATH) && cd $(PROJECT_DIR) && petalinux-build -c pckgendriver"
	docker exec $(DOCKER_CONTAINER) bash -c "source $(SETTINGS_PATH) && cd $(PROJECT_DIR) && petalinux-build -c webserver -x cleansstate"
	docker exec $(DOCKER_CONTAINER) bash -c "source $(SETTINGS_PATH) && cd $(PROJECT_DIR) && petalinux-build -c webserver"
	docker exec $(DOCKER_CONTAINER) bash -c "source $(SETTINGS_PATH) && cd $(PROJECT_DIR) && petalinux-build"
	docker exec $(DOCKER_CONTAINER) bash -c "source $(SETTINGS_PATH) && cd $(PROJECT_DIR) && petalinux-package --boot --force --fsbl  $(PROJECT_DIR)/images/linux/zynqmp_fsbl.elf --fpga $(PROJECT_DIR)/images/linux/system.bit --u-boot"

export-project:
	rm -rf sd_images/part*/*
	docker cp $(DOCKER_CONTAINER):$(PROJECT_DIR)/images/linux/BOOT.BIN sd_images/part1/
	docker cp $(DOCKER_CONTAINER):$(PROJECT_DIR)/images/linux/boot.scr sd_images/part1/
	docker cp $(DOCKER_CONTAINER):$(PROJECT_DIR)/images/linux/image.ub sd_images/part1/
	docker cp $(DOCKER_CONTAINER):$(PROJECT_DIR)/images/linux/Image sd_images/part1/
	docker cp $(DOCKER_CONTAINER):$(PROJECT_DIR)/images/linux/system.dtb sd_images/part1/
	docker cp $(DOCKER_CONTAINER):$(PROJECT_DIR)/images/linux/rootfs.tar.gz sd_images/part2/
	@if findmnt $(SD_PART2_PATH) > /dev/null; then \
		sudo rm -rf $(SD_PART2_PATH)/*;\
		cp sd_images/part2/* $(SD_PART2_PATH);\
		cd $(SD_PART2_PATH);\
		tar -xf rootfs.tar.gz;\
		cd -;\
		sudo cp misc/20-wired.network $(SD_PART2_PATH)/etc/systemd/network/20-wired.network;\
		sudo cp misc/shadow $(SD_PART2_PATH)/etc/shadow;\
		sudo cp misc/pckgendriver.conf $(SD_PART2_PATH)/etc/modules-load.d/pckgendriver.conf;\
	else \
		echo "Volumen NO montado, te peinas"; \
	fi

	@if findmnt $(SD_PART1_PATH) > /dev/null; then \
		rm -rf $(SD_PART1_PATH)/*;\
		cp sd_images/part1/* $(SD_PART1_PATH);\
	else \
		echo "Volumen NO montado, te peinas"; \
	fi

export-test:
	scp -P 2222 -O test_scripts/pl_config.py root@192.168.1.100:/home/root/
	scp -P 2222 -O test_scripts/dma_read_test.py root@192.168.1.100:/home/root/

clean:
	docker exec $(DOCKER_CONTAINER) bash -c "source $(SETTINGS_PATH) && cd $(PROJECT_DIR) && petalinux-build -c pckgendriver -x clean"

dismount:
	umount $(SD_PART1_PATH);
	umount $(SD_PART2_PATH);

.PHONY: all copy build clean

