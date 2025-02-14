export EXTENSION_NAME = AEPPlaces
export APP_NAME = PlacesTestApp
export APP_NAME_OBJC = PlacesTestApp_objc
CURRENT_DIRECTORY := ${CURDIR}
PROJECT_NAME = $(EXTENSION_NAME)
TARGET_NAME_XCFRAMEWORK = $(EXTENSION_NAME).xcframework
SCHEME_NAME_XCFRAMEWORK = AEPPlacesXCF

SIMULATOR_ARCHIVE_PATH = $(CURRENT_DIRECTORY)/build/ios_simulator.xcarchive/Products/Library/Frameworks/
IOS_ARCHIVE_PATH = $(CURRENT_DIRECTORY)/build/ios.xcarchive/Products/Library/Frameworks/

setup:
	(pod install)

setup-tools: install-swiftlint install-githook

pod-repo-update:
	(pod repo update)

# pod repo update may fail if there is no repo (issue fixed in v1.8.4). Use pod install --repo-update instead
pod-install:
	(pod install --repo-update)

ci-pod-install:
	(bundle exec pod install --repo-update)

pod-update: pod-repo-update
	(pod update)

open:
	open $(PROJECT_NAME).xcworkspace

clean:
	(rm -rf build)

clean-ios-test-files:
	rm -rf iosresults.xcresult

archive: clean pod-install build	
	xcodebuild -create-xcframework -framework $(SIMULATOR_ARCHIVE_PATH)$(EXTENSION_NAME).framework -framework $(IOS_ARCHIVE_PATH)$(EXTENSION_NAME).framework -output ./build/$(TARGET_NAME_XCFRAMEWORK)

build:
	xcodebuild archive -workspace $(PROJECT_NAME).xcworkspace -scheme $(SCHEME_NAME_XCFRAMEWORK) -archivePath "./build/ios.xcarchive" -sdk iphoneos -destination="iOS" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
	xcodebuild archive -workspace $(PROJECT_NAME).xcworkspace -scheme $(SCHEME_NAME_XCFRAMEWORK) -archivePath "./build/ios_simulator.xcarchive" -sdk iphonesimulator -destination="iOS Simulator" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

test:
	@echo "######################################################################"
	@echo "### Unit Testing iOS"
	@echo "######################################################################"
	xcodebuild test -workspace $(PROJECT_NAME).xcworkspace -scheme $(PROJECT_NAME) -destination 'platform=iOS Simulator,name=iPhone 14' -derivedDataPath build/out -enableCodeCoverage YES

install-githook:
	./Scripts/git-hooks/setup.sh

format: swift-format lint-autocorrect

check-format:
	swiftformat --lint $(PROJECT_NAME)/Sources --swiftversion 5.1


lint-autocorrect:
	./Pods/SwiftLint/swiftlint --fix $(PROJECT_NAME)/Sources

lint:
	./Pods/SwiftLint/swiftlint lint $(PROJECT_NAME)/Sources

build-test-apps:
	xcodebuild -workspace $(PROJECT_NAME).xcworkspace -scheme $(APP_NAME) -destination 'platform=iOS Simulator,name=iPhone 8'
	xcodebuild -workspace $(PROJECT_NAME).xcworkspace -scheme $(APP_NAME_OBJC) -destination 'platform=iOS Simulator,name=iPhone 8'

# make check-version VERSION=4.0.0
check-version:
	(sh ./Scripts/version.sh $(VERSION))

test-SPM-integration:
	(sh ./Scripts/test-spm.sh)

test-podspec:
	(sh ./Scripts/test-podspec.sh)

test-update-versions:
	(sh ./Scripts/update-versions.sh -n Places -v 9.9.9 -d "AEPCore 8.8.8, AEPServices 8.8.8")

zip:
	cd build && zip -r -X $(PROJECT_NAME).xcframework.zip $(PROJECT_NAME).xcframework/
	swift package compute-checksum build/$(PROJECT_NAME).xcframework.zip
