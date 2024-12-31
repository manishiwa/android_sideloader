<div align="center">
<img src="assets/icon.png" alt="App Screenshot" width="200"/>

# Android Sideloader

</div>


### Super-simple, portable, non-technical sideloading for everyone

Android Sideloader is a portable app that lets you very easily sideload apps onto your Android device.
Just:
1. Open Android Sideloader
2. Select your device
3. Choose an APK file (or drag and drop one)
4. Click `Install APK`

That's it! The entire process only takes a few seconds. **No command lines, no installing SDKs, no installing ADB, no
installing drivers** - you don't even install this app! Just download and run.

#### See it in action:

<img src="docs/videos/demo.gif" alt="See it in action" width="800"/>

## Downloading

1. Go to the [Latest Release](https://github.com/ryan-andrew/android_sideloader/releases/latest)
2. Click on the `Assets` dropdown
3. Download the `Android.Sideloader.exe`


## Using

- The first time you launch Android Sideloader, Windows may warn you that the app is not from a known developer. You
will need to click "Run Anyway".
- Additionally, ADB may request networking permissions from the Windows Firewall. This
is due to the way ADB works internally, setting up a local server. This app does not require or use the Internet.

## Troubleshooting

### My device does not appear in the `Connected Devices` list!

- Ensure that USB debugging is turned on in your Android device settings
- Make sure you tap `Allow` when prompted on your Android device
- Try a different USB cable - not all of them will work
- Try a different USB port on your computer
