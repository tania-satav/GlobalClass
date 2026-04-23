# Keep Me Hydrated  
### Global Classroom Project 2026  

---
## Team 1 | Team Tech

| Name | Student ID | Role(s) |
|------|------------|----------|
| **Tania Satavalekar** | C21331753 | Team Lead · Documentation |
| **(Lucas) Chong Tian Le Wong** | C23496364 | Backend Developer · Backend Tester |
| **Inas Saighi** | C23374831 | Designer · Frontend Developer |
| **Peter Dike** | C23445532 | Backend Developer · Database Handling |
| **Maxim Horovecs** | C23433246 | Frontend Developer · Lead Tester |

---

## Project Overview

**Keep Me Hydrated** is a lightweight mobile application designed to help users track and maintain their daily water intake.

The app enables users to:

- Set personalised daily hydration goals suited to preference
- Log water consumption easily  
- View visual progress towards their goal  
- Receive scheduled reminder notifications  
- Track historical hydration data  

Stretch features (if time permits):

- Streak and achievement tracking  
- Data export functionality

The objective of this project is to promote consistent hydration habits through a simple, intuitive, and user-friendly interface.

---

## Core Features

### Included Features
- User profile creation  
- Daily hydration goal setting  
- Personalised hydration recommendations  
- Water intake logging  
- Daily progress dashboard  
- Reminder notifications  
- Historical hydration tracking  
- Local data storage  
- Visual feedback through plant growth system  

### Stretch Features
- Achievement and streak tracking  
- Export hydration data  
- Enhanced analytics and insights  

---

## Technologies Used

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform mobile development |
| **Dart** | Programming language |
| **Android Studio** | Development environment |
| **GitHub** | Version control & collaboration |
| **SQLite / Local Storage** | Persistent data handling |
| **Notification Services** | Reminder scheduling |

---

## Project Structure

```text
GlobalClass/
│
├── android/          # Android configuration
├── ios/              # iOS configuration
├── lib/              # Main application code
├── assets/           # Images, icons, UI assets
├── test/             # Testing files
├── pubspec.yaml      # Project dependencies
└── README.md         # Project documentation

## Installation & Setup

### Prerequisites

Ensure the following are installed:

- **Flutter SDK (3.0+)**
- **Dart SDK**
- **Android Studio**
- **Git**
- **Android Emulator or Physical Device**
- **Xcode** *(Mac only for iOS)*

---

### Clone Repository

```bash
git clone https://github.com/tania-satav/GlobalClass.git
```

---

### Navigate to Project Directory

```bash
cd GlobalClass
```

---

### Install Dependencies

```bash
flutter pub get
```

---

### Verify Flutter Installation

```bash
flutter doctor
```

Expected output:

```text
No issues found!
```

---

### Run the Application

```bash
flutter run
```

---

## Running on Android

### Android Emulator

1. Open **Android Studio**
2. Launch **Device Manager**
3. Start an Emulator
4. Run:

```bash
flutter run
```

---

### Physical Android Device

1. Enable **Developer Options**
2. Enable **USB Debugging**
3. Connect device via USB
4. Confirm device detection:

```bash
flutter devices
```

5. Run:

```bash
flutter run
```

---

## Running on iOS (Mac Only)

Navigate into the iOS folder:

```bash
cd ios
```

Install CocoaPods:

```bash
pod install
```

Return to root:

```bash
cd ..
```

Run app:

```bash
flutter run
```

Requirements:

- Xcode installed
- iOS Simulator configured

---

## First Launch

After successful launch, users should see:

1. Welcome / Login Screen  
2. Profile Creation  
3. Hydration Goal Setup  
4. Dashboard Screen  
5. Water Logging Functionality  

---

## Development Methodology

This project follows an **Agile Development Approach**, using iterative sprints to:

- Plan features incrementally  
- Develop core functionality  
- Test frequently  
- Refine based on feedback  
- Reduce development risks  

---

## Project Status

### Current Phase

**Development & Testing**

### Completed

- Core UI development  
- Database integration  
- Hydration tracking logic  
- Reminder system  
- Progress dashboard  

### In Progress

- Final testing  
- Bug fixes  
- UI refinements  
- Final presentation and documentation  

---

## Troubleshooting

### Flutter Packages Not Installing

```bash
flutter clean
flutter pub get
```

---

### Device Not Detected

```bash
flutter devices
```

Ensure USB debugging is enabled.

---

### Build Errors

```bash
flutter clean
flutter run
```

---

## Repository Link

**GitHub Repository:**  
https://github.com/tania-satav/GlobalClass

---

## Contributors

This project was developed collaboratively by **Team 1 – Team Tech** as part of the **Global Classroom Project**.

- **Project Lead:** Tania Satavalekar  
- **Backend Development:** Peter Dike  
- **Application Logic:** (Lucas) Chong Tian Le Wong  
- **UI/UX Design:** Inas Saighi  
- **UI/UX Front-End Development:** Inas Saighi & Maxim Horovecs  
- **Testing & Quality Assurance:** Maxim Horovecs  
- **Documentation:** Tania Satavalekar  

- Team 1 | Team Tech**

---

## Acknowledgements

Special thanks to project mentor, Art , client Liz, and the Global Classroom programme led by Paul Bourke for guidance and support throughout development.

---

## License

This repository is intended for **educational and academic purposes**.
