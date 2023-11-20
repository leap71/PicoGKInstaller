#!/bin/bash

for file in files/picogk.1.1.*.dylib; do
    mv "$file" "${file/.0./.}"  # This removes the '.0.' part in the filename
done

install_name_tool -change /opt/homebrew/opt/xz/lib/liblzma.5.dylib /usr/local/lib/liblzma.5.dylib files/picogk.1.1.dylib
install_name_tool -change /opt/homebrew/opt/zstd/lib/libzstd.1.dylib /usr/local/lib/libzstd.1.dylib files/picogk.1.1.dylib
codesign -s LEAP71 files/picogk.1.1.dylib

# Create a flat package
pkgbuild --root files --install-location /usr/local/lib --identifier com.leap71.picogkruntime --version 1.1 ../picogkruntime_1.1_Mac_arm64.pkg

echo "Package creation complete!"
