#!/bin/bash

strPicoGKVersion="1.1"
strPicoGKArchitecture="arm64"
strPicoGKDylib="picogk.${strPicoGKVersion}.dylib"
strPicoGKPgk="PicoGK_${strPicoGKArchitecture}_v${strPicoGKVersion}.pkg"
strPicoGKVolume="PicoGK v${strPicoGKVersion}"
strPicoGKDmg="PicoGK_${strPicoGKArchitecture}_v${strPicoGKVersion}.dmg"

echo $strPicoGKDmg

echo "-------------------------------"
echo "Patching dylibs to be installed"
echo "-------------------------------"

for file in files/${strPicoGKDylib}; do
    mv "$file" "${file/.0./.}"  # This removes the '.0.' part in the filename
done

# codesign -s LEAP71 files/liblzma.5.dylib
# codesign -s LEAP71 files/libzstd.1.dylib
install_name_tool -change /opt/homebrew/opt/xz/lib/liblzma.5.dylib      /usr/local/lib/liblzma.5.dylib files/${strPicoGKDylib}
install_name_tool -change /opt/homebrew/opt/zstd/lib/libzstd.1.dylib    /usr/local/lib/libzstd.1.dylib files/${strPicoGKDylib}
codesign -s LEAP71 files/${strPicoGKDylib}

echo "-------------------------------"
echo "Create install .PKG"
echo "-------------------------------"

# Create a flat package
pkgbuild --root files --install-location /usr/local/lib --identifier com.PicoGK.picogkruntime --version $strPicoGKVersion ../../$strPicoGKPgk

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
