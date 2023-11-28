# PicoGK Runtime Installer
This is the **source code** for the creation of the PicoGK Runtime installers. 

It is hosted at https://github.com/leap71/PicoGKInstaller.

**You don't need to clone this repo, unless you want to build installers yourself, which you probably will never do**, unless you want to deploy your own self-compiled versions of PicoGK. If you build installers yourself, you must clearly indicate the fact that they are not official PicoGK installers.

Please see the [main PicoGK project](https://github.com/leap71/PicoGK) for more information about PicoGK. 

**If you are looking to install PicoGK, head over to the latest releases and [download the latest setup packages](https://github.com/leap71/PicoGK/releases).**

## Building the installers

The Windows installer uses InnoSetup, which can be downloaded at https://jrsoftware.org/isdl.php#stable

The Mac installer uses the [create-dmg](https://github.com/create-dmg/create-dmg) tool. It is included as a submodule. 

Make sure to run

```
git submodule update --init --recursive --remote
```

before building an installer. This will initialize and update all submodules to the latest versions (including PicoGK and other submodules included in the example folder), and also clone create-dmg.

When running **CreateInstaller.sh** on the Mac. Make sure to enable viewing of hidden files in the Finder **[SHIFT] [COMMAND] [.]**. If hidden files are not visible, the Apple Script in create-dmg tool that customizes the disk image fails.
