PRODUCT_NAME=RegexRename
APP_BUILD_DIR=$(PWD)/build/UninstalledProducts
APP_INSTALL_DIR=/Applications
BUILD_TYPE=Deployment

build:
	xcodebuild \
		CONFIGURATION_BUILD_DIR=$(APP_BUILD_DIR) \
		-project RegexRename.xcodeproj \
		-target RegexRename \
		-configuration ${BUILD_TYPE} build

clean:
	rm -rf $(APP_BUILD_DIR)

install: build
	cp -r $(APP_BUILD_DIR)/$(PRODUCT_NAME).app $(APP_INSTALL_DIR)

.PHONY: build clean install
