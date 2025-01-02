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

<img src="docs/videos/demo2.gif" alt="See it in action" width="800"/>

## Downloading

1. Go to the [Latest Release](https://github.com/ryan-andrew/android_sideloader/releases/latest)
2. Click on the `Assets` dropdown
3. Download the `Android.Sideloader.exe`


## Using

### Prerequisites

1. Ensure that USB debugging is turned on in your Android device settings
    - https://developer.android.com/studio/debug/dev-options#enable
2. Make sure you tap `Allow` when prompted on your Android device when you connect your device
    > <img src="docs/images/allow_debugging.png" alt="See it in action" width="200"/>
    > 
    > Tapping `Always allow from this computer` will ensure that you only ever need to do this once

### Steps

- The first time you launch Android Sideloader, Windows may warn you that the app is not from a known developer. You
will need to click "Run Anyway".
- Additionally, ADB may request networking permissions from the Windows Firewall. This
is due to the way ADB works internally, setting up a local server. This app does not require or use the Internet.
- On your device, you should see a dialog the first time your run the app.

## Troubleshooting

### My device does not appear in the `Connected Devices` list!

- Ensure that USB debugging is turned on in your Android device settings
    - https://developer.android.com/studio/debug/dev-options#enable 
- Make sure you tap `Allow` when prompted on your Android device when you connect your device
  > <img src="docs/images/allow_debugging.png" alt="See it in action" width="200"/>
- Try a different USB cable - not all of them will work
- Try a different USB port on your computer

### Something else

If you have any other problems, please [create an issue](https://github.com/ryan-andrew/android_sideloader/issues/new).
Please also attach the logs to the issue. Logs can be saved via the first button on the bottom right of the app:

<img src="docs/images/save_logs.png" alt="See it in action" width="400"/>