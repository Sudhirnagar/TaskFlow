# TaskFlow - Gig Workers Task Management App

A feature-rich task management application built with Flutter, implementing Clean Architecture and BLoC pattern for state management.

## 📱 Features

### ✅ User Authentication
- Email/Password registration and login using Firebase Authentication
- Persistent user sessions
- Secure logout functionality
- Error handling with user-friendly messages

### ✅ Task Management
- **Create** tasks with title, description, due date, and priority
- **Edit** existing tasks
- **Delete** tasks with confirmation
- **Toggle** task completion status
- **Real-time synchronization** with Firebase Firestore

### ✅ Task Filtering & Organization
- Filter by status: All, Completed, Incomplete
- Filter by priority: Low, Medium, High
- Automatic sorting by due date (earliest to latest)
- Tasks organized by sections: Today, Tomorrow, This Week

### ✅ Modern UI/UX
- Clean Material Design interface
- Responsive layout for iOS and Android
- Smooth animations and transitions
- Priority-based color coding
- Swipe-to-delete gesture
- Date badges showing relative time (Today, Tomorrow, Overdue)

## 🏗️ Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Shared utilities and constants
│   ├── constants/          # App colors, strings
│   ├── errors/             # Failures and exceptions
│   ├── usecases/           # Base usecase interface
│   └── utils/              # Validators, formatters
│
├── features/
│   ├── auth/               # Authentication feature
│   │   ├── data/          # Data sources, models, repositories
│   │   ├── domain/        # Entities, repositories, use cases
│   │   └── presentation/  # BLoC, pages, widgets
│   │
│   └── tasks/             # Tasks feature
│       ├── data/          # Data sources, models, repositories
│       ├── domain/        # Entities, repositories, use cases
│       └── presentation/  # BLoC, pages, widgets
│
└── injection_container.dart # Dependency injection setup
```

### Clean Architecture Layers

1. **Presentation Layer**: UI components, BLoC state management
2. **Domain Layer**: Business logic, entities, repository interfaces
3. **Data Layer**: Repository implementations, data sources, models

## 🔧 Technologies Used

- **Flutter** - UI framework
- **BLoC** - State management (flutter_bloc)
- **Firebase Auth** - User authentication
- **Cloud Firestore** - Real-time database
- **GetIt** - Dependency injection
- **Dartz** - Functional programming (Either type)
- **Equatable** - Value equality
- **Google Fonts** - Custom typography
- **Intl** - Date formatting

## 📦 Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Firebase account
- Android Studio / VS Code with Flutter plugins

### Step 1: Clone and Install Dependencies

```bash
# Clone the repository
git clone <repository-url>
cd task_management_app

# Install dependencies
flutter pub get
```

### Step 2: Firebase Setup

#### 2.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" and follow the setup wizard
3. Enable Google Analytics (optional)

#### 2.2 Add Android App
1. In Firebase Console, click "Add app" → Android icon
2. Register app with package name: `com.example.task_management_app`
3. Download `google-services.json`
4. Place it in `android/app/` directory

#### 2.3 Add iOS App (if targeting iOS)
1. In Firebase Console, click "Add app" → iOS icon
2. Register app with bundle ID: `com.example.taskManagementApp`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory
5. Open `ios/Runner.xcworkspace` in Xcode
6. Drag `GoogleService-Info.plist` into the project

#### 2.4 Enable Authentication
1. Go to Firebase Console → Authentication
2. Click "Get started"
3. Enable "Email/Password" sign-in method

#### 2.5 Setup Firestore Database
1. Go to Firebase Console → Firestore Database
2. Click "Create database"
3. Start in **production mode**
4. Choose a location close to your users
5. Update Firestore Security Rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Tasks collection
    match /tasks/{taskId} {
      allow read, write: if request.auth != null && 
                           request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
                      request.auth.uid == request.resource.data.userId;
    }
  }
}
```

### Step 3: Configure Android

Edit `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 33  // or higher
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}

dependencies {
    // Add at the end
    implementation platform('com.google.firebase:firebase-bom:32.0.0')
}
```

Edit `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

Add to `android/app/build.gradle` (at the very end):

```gradle
apply plugin: 'com.google.gms.google-services'
```

### Step 4: Configure iOS (if targeting iOS)

Edit `ios/Podfile`:

```ruby
platform :ios, '12.0'  # or higher

# Uncomment this line
use_frameworks!
```

### Step 5: Run the App

```bash
# Check for issues
flutter doctor

# Run on connected device/emulator
flutter run

# Build for release
flutter build apk        # Android
flutter build ios        # iOS
```

## 📱 App Screens

### 1. Onboarding Screen
- Welcome message with app branding
- Introduction to task management
- Navigate to registration

### 2. Registration Screen
- Email and password fields with validation
- Social login buttons (UI only)
- Link to login page

### 3. Login Screen
- Email and password authentication
- "Forgot Password" link
- Link to registration page

### 4. Tasks List Screen
- Header with date and user info
- Filter chips for status and priority
- Tasks organized by: Today, Tomorrow, This Week
- Floating action button to create tasks
- Logout option

### 5. Task Detail/Edit Screen
- Create or edit task
- Form fields: Title, Description, Due Date, Priority
- Date picker for due date selection
- Priority selector (Low, Medium, High)
- Delete button (edit mode only)

## 🎨 Design Features

### Color Scheme
- **Primary**: Purple (#6C63FF)
- **Background**: Light Gray (#F5F6FA)
- **Success**: Green (#38A169)
- **Error**: Red (#E53E3E)

### Priority Colors
- **Low**: Green (#68D391)
- **Medium**: Yellow/Orange (#FBD38D)
- **High**: Red (#FC8181)

### UI Components
- Rounded corners (12-20px radius)
- Soft shadows for depth
- Custom color-coded priority badges
- Swipe-to-delete gesture
- Check/uncheck animations
- Date badges with relative time

## 🔐 Security

- Firebase Authentication for secure user management
- Firestore Security Rules to protect user data
- Password validation (minimum 6 characters)
- Email format validation

## 🧪 Testing

### Test User Account
For quick testing, you can create a test account:
1. Open the app
2. Navigate to Register
3. Enter email: `test@example.com`
4. Enter password: `test123`
5. Click "Sign up"

### Test Scenarios
1. **Registration**: Create a new account
2. **Login**: Sign in with existing credentials
3. **Create Task**: Add a new task with all fields
4. **Edit Task**: Modify an existing task
5. **Toggle Completion**: Mark task as complete/incomplete
6. **Delete Task**: Swipe to delete or use delete button
7. **Filters**: Test all filter combinations
8. **Logout**: Sign out and verify session cleared

## 📝 Firebase Data Structure

### Users Collection
```
users/
  {userId}/
    email: "user@example.com"
    createdAt: Timestamp
```

### Tasks Collection
```
tasks/
  {taskId}/
    userId: "user123"
    title: "Complete project"
    description: "Finish the Flutter app"
    dueDate: Timestamp
    priority: "high" | "medium" | "low"
    isCompleted: false
    createdAt: Timestamp
    updatedAt: Timestamp
```

## 🚀 Future Enhancements

- [ ] Push notifications for task reminders
- [ ] Task categories/tags
- [ ] Recurring tasks
- [ ] Task sharing and collaboration
- [ ] Calendar view
- [ ] Dark mode support
- [ ] Offline mode with sync
- [ ] Task attachments
- [ ] Subtasks support
- [ ] Analytics dashboard

## 🐛 Troubleshooting

### Common Issues

**Issue**: Firebase not initializing
- **Solution**: Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly placed

**Issue**: Build fails on Android
- **Solution**: Update `minSdkVersion` to 21 in `android/app/build.gradle`

**Issue**: Authentication errors
- **Solution**: Verify Email/Password is enabled in Firebase Console

**Issue**: Firestore permission denied
- **Solution**: Update Firestore Security Rules as shown in setup

**Issue**: Tasks not syncing
- **Solution**: Check internet connection and Firestore rules

## 📄 License

This project is created for educational purposes as part of a coding assessment.

## 👨‍💻 Developer Notes

### Code Quality
- ✅ Clean Architecture implementation
- ✅ SOLID principles followed
- ✅ Proper error handling
- ✅ Type-safe code
- ✅ Commented complex logic
- ✅ Consistent naming conventions

### Performance
- Real-time listeners for instant updates
- Optimized widget rebuilds using BLoC
- Efficient date filtering and sorting
- Lazy loading of dependencies

### Scalability
- Easy to add new features
- Modular architecture
- Reusable widgets and utilities
- Clear separation of concerns

## 📞 Support

For issues or questions, please create an issue in the repository or contact the development team.

---

**Deadline**: January 21, 2026 EOD

**Status**: ✅ Complete - Ready for submission

**Note**: This app demonstrates proficiency in Flutter, Clean Architecture, BLoC pattern, Firebase integration, and modern mobile app development practices.
