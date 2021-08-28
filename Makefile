PRODUCT_NAME=RegexRename
APP_BUILD_DIR=$(PWD)/build/UninstalledProducts
APP_INSTALL_DIR=/Applications
BUILD_TYPE=Deployment
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer/

deps:
	which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew tap Homebrew/bundle
	brew bundle check || brew bundle

build:
	xcodebuild \
		CONFIGURATION_BUILD_DIR=$(APP_BUILD_DIR) \
		-project $(PRODUCT_NAME).xcodeproj \
		-target $(PRODUCT_NAME) \
		-configuration ${BUILD_TYPE} build

clean:
	rm -rf $(APP_BUILD_DIR)

install: build
	cp -r $(APP_BUILD_DIR)/$(PRODUCT_NAME).app $(APP_INSTALL_DIR)

format:
	swiftformat *.swift

test:
	xcodebuild -project RegexRename.xcodeproj -scheme RegexRename test | xcbeautify

# xcrun swift -F $(DEVELOPER_DIR)/Platforms/MacOSX.platform/Developer/Library/Frameworks/ $(PRODUCT_NAME)/StringTest.swift

.PHONY: build clean install
