# Journal App

Journal is an Android application designed to provide users with a secure and user-friendly platform for creating and managing personal journal entries. This app incorporates user registration/authentication via email, Google, or Facebook along with journal entry creation, metadata tagging, and user profiles.

## Project Overview

- **Project Name:** Journal
- **GitHub Link:** [Journal App Repository](https://github.com/Rithvik99/journal_app)
- **Author:** Rithvik Ramasani
- **Student ID:** IMT2020543

## Project Description

Journal is a comprehensive Android app that prioritizes user privacy, offering seamless registration/authentication through various methods. The app's key functionalities include user authentication, journal entry management, and data organization through robust metadata tagging. Users can link multiple authentication methods to a single account, providing flexibility and convenience.

### Features

1. **Authentication:**
   - Email/Password authentication
   - Google OAuth
   - Facebook OAuth

2. **OAuth Integration:**
   - Firebase Authentication for token-based OAuth with Google and Facebook
   - Secure token exchange mechanisms for data privacy and integrity

3. **Cross-Authentication:**
   - Link multiple authentication methods to a single account
   - Seamless login using email/password, Gmail, or Facebook

## Problem Definition

OAuth (Open Authorization) is employed to securely access user resources on a server without exposing credentials. The OAuth flow involves client registration, authorization requests, consent screens, and token exchange mechanisms.

## App Screens

1. **Login-Register Screen:**
   - Email/password login
   - Registration for new users
   - Social media login buttons (Google and Facebook)

2. **Home Screen:**
   - Calendar view for date selection
   - Buttons/icons for creating and viewing journal entries
   - Navigation drawer for accessing other app sections

3. **Journal Entry Details Screen:**
   - Display title, date, content, and metadata
   - Navigation button to return to the home screen

4. **Create Journal Entry Screen:**
   - Input fields for title, date, content, and metadata
   - Save and cancel buttons for creating or editing entries

5. **User Profile Screen:**
   - Display user information and profile picture
   - Buttons to link social media accounts
   - Logout button

## Setting Up OAuth

### Google:
   - Create a Google Sign-In Project
   - Enable Google Sign-In in the Firebase console

### Facebook:
   - Create a Facebook app
   - Enable Facebook Sign-In in the Firebase console

## Development Environment

### Tech Stack:
   - Flutter
   - Dart
   - Firebase (Authentication and Firestore)
   - Facebook API

### IDE:
   - Visual Studio Code (VSCode)

### Testing Environment:
   - Android simulator

# Setup

Follow these steps to set up your Flutter app on your local machine:

## Prerequisites
Before you get started, make sure you have the following installed:

- Flutter SDK
- Git

## Clone the Repository
Clone the repository to your local machine and navigate to the project directory:

```bash
git clone https://github.com/Rithvik99/journal_app
cd journal_app
```

## Get Dependencies
Run the following command to fetch the necessary dependencies:

```bash
flutter pub get
```

## USB Debugging
Ensure that USB debugging is enabled on your Android device. If you're unsure how to do this, refer to the Android Developer Documentation.

## Run the App
Connect your Android device to your computer and run the app using the following command:

```bash
flutter run
```

This command will build the app and install it on your connected Android device.

## Build the App
To create a standalone APK for your application, use the following command:

```bash
flutter build apk
```

You'll find the built APK file in the `build/app/outputs/flutter-apk/` directory. Install this APK on your Android device by transferring it to the device and opening the file using a file manager.

Feel free to explore the source code and contribute to the development of this intuitive and secure journaling application. Happy journaling!