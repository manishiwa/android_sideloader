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
installing drivers** - Just download and run!

#### See it in action:

<img src="docs/videos/demo2.gif" alt="See it in action" width="800"/>

## Table of Contents

- [Downloading](#downloading)
- [First Time Setup](#first-time-setup)
    - [Prerequisites](#prerequisites)
    - [First Time Setup Steps](#first-time-setup-steps)
- [How to Use](#how-to-use)
    - [How to Use Steps](#how-to-use-steps)
    - [Video Demonstration](#video-demonstration)
- [Troubleshooting](#troubleshooting)

## Downloading

1. Go to the [Latest Release](https://github.com/ryan-andrew/android_sideloader/releases/latest)
2. Click on the `Assets` dropdown
3. Choose your download
   - `AndroidSideloader-v*.*.*-Windows-Installer.exe`
     - This will installer Android Sideloader on your PC. For those who prefer having it installed in a normal way.
   - `AndroidSideloader-v*.*.*-Windows-Portable.zip`
     - This is a portable package of Android Sideloader. Unzip this wherever you want and run `android_sideloader.exe`
       from inside the new folder.

## First Time Setup

### Prerequisites

Ensure that USB debugging is turned on in your Android device settings
  - https://developer.android.com/studio/debug/dev-options#enable

### First Time Setup Steps

1. The first time you launch Android Sideloader, Windows may warn you that the app is not from a known developer. You
will need to click "More Info", then "Run Anyway".

    <figure>
      <img src="docs/images/smart-screen-1.png" alt="Click &quot;More Info&quot;" width="300"/>
      <br>
      <figcaption><em>Click "More Info"</em></figcaption>
    </figure>
    <br>
    <figure>
      <img src="docs/images/smart-screen-2.png" alt="Click &quot;Run Anyway&quot;" width="300"/>
      <br>
      <figcaption><em>Click "Run Anyway"</em></figcaption>
    </figure>

2. Additionally, ADB may request networking permissions from the Windows Firewall. This
is due to the way ADB works internally, setting up a local server. This app does not require or use the Internet.
3.  On your device, you may see a dialog the first time your run the app. Make sure you tap `Allow` when prompted.

    <figure>
      <img src="docs/images/allow_debugging.png" alt="Tapping &quot;Always allow from this computer&quot; will ensure that you only ever need to do this once" width="200"/>
      <br>
      <figcaption><em>Tapping "Always allow from this computer" will ensure that you only ever need to do this once</em></figcaption>
    </figure>

## How to Use

### How to Use Steps

1. Open Android Sideloader

    <figure>
      <img src="docs/images/demo-initial-screen.png" alt="The Android Sideloader screen" width="400"/>
      <br> 
      <figcaption><em>The Android Sideloader screen</em></figcaption>
    </figure>

2. Select your device

    <figure>
      <img src="docs/images/demo-select-device.png" alt="Devices appear in &quot;Connected Devices&quot; list" width="400"/>
      <br>
      <figcaption><em>Devices appear in "Connected Devices" list</em></figcaption>
    </figure>

3. Choose an APK file (or drag and drop one)

    <figure>
      <img src="docs/images/demo-select-apk.png" alt="A file browser window will appear where you can select the APK file you want to install" width="400"/>
      <br>
      <figcaption><em>A file browser window will appear where you can select the APK file you want to install</em></figcaption>
    </figure>
    <br>
    <br>
    <figure>
      <img src="docs/images/demo-drag-apk.png" alt="You can also just drag and drop your APK file into the Android Sideloader window" width="400"/>
      <br>
      <figcaption><em>You can also just drag and drop your APK file into the Android Sideloader window</em></figcaption>
    </figure>

4. Click `Install APK`

    <figure>
      <img src="docs/images/demo-install-apk.png" alt="" width="400"/>
      <br>
      <figcaption><em></em></figcaption>
    </figure>

5. The app is installed

    <figure>
      <img src="docs/images/demo-app-installed.png" alt="" width="400"/>
      <br>
      <figcaption><em></em></figcaption>
    </figure>
   
### Video Demonstration

<img src="docs/videos/demo2.gif" alt="See it in action" width="500"/>

## Troubleshooting

### My device does not appear in the `Connected Devices` list!

- Ensure that USB debugging is turned on in your Android device settings
    - https://developer.android.com/studio/debug/dev-options#enable 
- Make sure you tap `Allow` when prompted on your Android device when you connect your device
    <figure>
      <img src="docs/images/allow_debugging.png" alt="Tapping &quot;Always allow from this computer&quot; will ensure that you only ever need to do this once" width="200"/>
      <br>
      <figcaption><em>Tapping "Always allow from this computer" will ensure that you only ever need to do this once</em></figcaption>
    </figure>
- Try a different USB cable - not all of them will work
- Try a different USB port on your computer

### Something else

If you have any other problems, please [create an issue](https://github.com/ryan-andrew/android_sideloader/issues/new).
Please also attach the logs to the issue. Logs can be saved via the first button on the bottom right of the app:

<img src="docs/images/save_logs.png" alt="See it in action" width="400"/>
