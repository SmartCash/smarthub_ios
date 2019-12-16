#!/bin/sh

# Copies the debug settings bundle during build phase for debug builds
# Also can modify some settings bundle plist value by this script.
# For example: update the version number

PLISTBUDDY=/usr/libexec/PlistBuddy

# updateArray - add items to the arrays in the Settings.bundle PSMultiValueSpecifier
# args:
# $1 new value
# $2 filepath to output plist
function updateArray {
	$PLISTBUDDY -c "add PreferenceSpecifiers:2:Titles:0 string $1" $2
}

# updateVersion - update app's bundle short version string
# args:
# $1 filepath to output plist
function updateVersion {
    version=$($PLISTBUDDY -c "Print CFBundleShortVersionString" "${INFOPLIST_FILE}") 
    echo "Updating displayed app version on Settings.bundle/Root.plist to: " "$version"
    $PLISTBUDDY -c "Set PreferenceSpecifiers:1:DefaultValue $version" $1
}


SHOW_DEBUG=false

case "$GCC_PREPROCESSOR_DEFINITIONS" in
        *DEBUG=1*)
                SHOW_DEBUG=true
        ;;
esac

if $SHOW_DEBUG; then
    # Copy the debug Settings.bundle into the app bundle
	echo "Running debug Build"
    echo "Overriding Settings.bundle with contents of DebugSettings.bundle"
    rm -rf $BUILT_PRODUCTS_DIR/$EXECUTABLE_FOLDER_PATH/Settings.bundle
    cp -R $SRCROOT/Source/Supporting\ Files/SettingsBundle/DebugSettings.bundle $BUILT_PRODUCTS_DIR/$EXECUTABLE_FOLDER_PATH/Settings.bundle

else
    echo "Running release Build"
	echo "Settings.bundle will be used"
fi

updateVersion $BUILT_PRODUCTS_DIR/$EXECUTABLE_FOLDER_PATH/Settings.bundle/Root.plist
   