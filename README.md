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

## Setting Up a Basic Flutter App

To set up and run the basic Flutter app:

1. **Install Flutter:**
   - Follow the instructions on the [official Flutter installation guide](https://flutter.dev/docs/get-started/install) to set up Flutter on your machine.

2. **Install Dependencies:**
   - Open a terminal and navigate to the project root directory.
   - Run `flutter pub get` to install the project dependencies.

3. **Run the App:**
   - Connect a device or start an emulator.
   - Run `flutter run` in the terminal to build and launch the app on your device/emulator.

4. **Explore the Code:**
   - Dive into the `lib` directory to explore the source code.
   - Make any necessary adjustments based on your project requirements.

Feel free to explore the source code and contribute to the development of this intuitive and secure journaling application. Happy journaling!