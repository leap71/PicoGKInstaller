#!/bin/bash

strPicoGKVersion="1.2"
strPicoGKArchitecture="arm64"
strPicoGKPrefix="picogk.${strPicoGKVersion}"
strPicoGKDylib="${strPicoGKPrefix}.dylib"
strPicoGKPgk="PicoGK_${strPicoGKArchitecture}_v${strPicoGKVersion}.pkg"
strPicoGKVolume="PicoGK v${strPicoGKVersion}"
strPicoGKDmg="PicoGK_${strPicoGKArchitecture}_v${strPicoGKVersion}.dmg"
strPicoGKBundle="com.PicoGK.picogkruntime"

strRunDirectory=$(pwd)
strRepoRoot=$(git rev-parse --show-toplevel)

# read the Developer ID for signing
# from the main GitHub directory 
# (intentionally outside this repo)

cd $strRepoRoot
cd ..
read -r strDeveloperID < ./DeveloperID.txt
cd $strRunDirectory

function L71_UpdateSubmodules
{
    echo "Updating submodules"

    cd "$strRepoRoot"

    git submodule update --init --recursive
    git submodule foreach --recursive 'git checkout main || :'
    git submodule foreach --recursive 'git pull origin main || :'

    # Go back to where we were
    cd "$strRunDirectory"
}

function L71_bUpdateLibraryName 
{
    local strBinary=$1
    local strOldLib=$2
    local strNewLib=$3

    echo "Updating dependency names for $strBinary"

    # Check if the old library name is in the binary
    if otool -L "$strBinary" | grep -q "$strOldLib"; then
        # If yes, use install_name_tool to change the library name
        install_name_tool -change "$strOldLib" "$strNewLib" "$strBinary"
    else
        # If no, print an error message and return a non-zero status
        echo "Error: Library name $strOldLib not found in $strBinary"
        return 1
    fi
}

function L71_Sign
{
    echo "Signing with identity '${strDeveloperID}'"
    local strBinary=$1
    codesign --timestamp --options runtime --force --verbose -i "${strPicoGKBundle}" --sign "Developer ID Application: ${strDeveloperID}" "${strBinary}"
}

# Update all submodules, so we don't create an outdated installer

L71_UpdateSubmodules

echo $strPicoGKDmg

echo "-------------------------------"
echo "Patching dylibs to be installed"
echo "-------------------------------"

rm files/*

cp source/*.dylib files/
mv files/liblzma.5.dylib files/${strPicoGKPrefix}_liblzma.5.dylib
mv files/libzstd.1.dylib files/${strPicoGKPrefix}_libzstd.1.dylib
mv files/${strPicoGKPrefix}.?.dylib files/${strPicoGKDylib}

L71_Sign files/${strPicoGKPrefix}_liblzma.5.dylib
L71_Sign files/${strPicoGKPrefix}_libzstd.1.dylib

L71_bUpdateLibraryName files/${strPicoGKDylib} /opt/homebrew/opt/xz/lib/liblzma.5.dylib   /usr/local/lib/${strPicoGKPrefix}_liblzma.5.dylib
L71_bUpdateLibraryName files/${strPicoGKDylib} /opt/homebrew/opt/zstd/lib/libzstd.1.dylib /usr/local/lib/${strPicoGKPrefix}_libzstd.1.dylib

L71_Sign files/${strPicoGKDylib}

echo "-------------------------------"
echo "Create install .PKG"
echo "-------------------------------"

# Create a flat package
pkgbuild --root files --install-location /usr/local/lib --identifier ${strPicoGKBundle} --version $strPicoGKVersion "../../${strPicoGKPgk}_unsigned"

productsign --sign "Developer ID Installer: ${strDeveloperID}" "../../${strPicoGKPgk}_unsigned" ../../$strPicoGKPgk

rm "../../${strPicoGKPgk}_unsigned"

echo "Package creation complete!"

echo "-------------------------------"
echo "Creating Disk Image" 
echo "-------------------------------"

#Remove existing DMG if exists

rm ../../$strPicoGKDmg > /dev/null   

mkdir ./Temp > /dev/null
rm -r ./Temp/*

cp ../../$strPicoGKPgk "./Temp/Install PicoGK.pkg"
mkdir "./Temp/PicoGK Example"
cp -r "../../../PicoGK Example" "./Temp/"

# Create HIDPI multi-size TIFF

tiffutil -cathidpicheck ../Common/PicoGKInstaller.png ../Common/PicoGKInstaller@2x.png -out ./Temp/.background.tiff

../../../Tools/create-dmg/create-dmg \
    --volname "${strPicoGKVolume}" \
    --background ./Temp/.background.tiff \
    --icon-size 100 \
    --window-size 700 600 \
    --icon "Install PicoGK.pkg" 290 230 \
    --icon "PicoGK Example" 160 400 \
    --eula ../Common/LICENSE.rtf \
    "../../${strPicoGKDmg}" ./Temp

echo "Signing DMG"

L71_Sign "../../${strPicoGKDmg}"

xcrun notarytool submit "../../${strPicoGKDmg}" --keychain-profile "notarytoolpwd" --wait

xcrun stapler staple "../../${strPicoGKDmg}"

xcrun stapler validate "../../${strPicoGKDmg}"

