# file structure
...
lib
    src
        config
        constants
        models
        pages
        services
        utils
        widgets
        app.dart
    main.dart

# ลบ comment regex
- use regex alt+x
- //.*
- click select all and delete

# format code windows
- ctrl+alt+l

# search file or directory
- ctrl+f

# search code
- ctrl+shift+f

# make app logo
for android
1. generate logo https://makeappicon.com/
2. replace to android/app/src/main/res
3. new run

for ios
src \ios\Runner\Assets.xcassets

# build apk
https://docs.flutter.dev/deployment/android

1. Create an upload keystore
- On Mac/Linux, use the following command:
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias keystore

- On Windows, use the following command:
keytool -genkey -v -keystore C:\Users\LEGION\Desktop\keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias keystore


2. Reference the keystore from the app
Create a file named [project]/android/key.properties that contains a reference to your keystore:

<>
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=keystore
storeFile=<location of the key store file, such as /Users/<user name>/keystore.jks>
<>

3. Configure signing in gradle
Configure gradle to use your upload key when building your app in release mode by editing the [project]/android/app/build.gradle file.

    1. Add the keystore information from your properties file before the android block:

       <>
       def keystoreProperties = new Properties()
       def keystorePropertiesFile = rootProject.file('key.properties')
       if (keystorePropertiesFile.exists()) {
           keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
       }

       android {
             ...
       }
       <>

       Load the key.properties file into the keystoreProperties object.

    2. Find the buildTypes block:
       buildTypes {
           release {
               // TODO: Add your own signing config for the release build.
               // Signing with the debug keys for now,
               // so `flutter run --release` works.
               signingConfig signingConfigs.debug
           }
       }

       And replace it with the following signing configuration info:
     <>
        signingConfigs {
            release {
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
                storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
                storePassword keystoreProperties['storePassword']
            }
        }
        buildTypes {
            release {
                signingConfig signingConfigs.release
            }
        }
     <>

4. build apk
$ flutter build apk


5. success
- √  Built
- C:\Users\LEGION\Desktop\StudioProjects\flutter_mystock\build\app\outputs\apk\release

# for second build
$ flutter build --build-name=1.0.1 --build-number=2





