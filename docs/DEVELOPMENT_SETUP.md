# Field Master - Development Setup Guide

## 1. Introduction

This guide provides step-by-step instructions for setting up the Field Master development environment. It covers all necessary tools, configurations, and best practices for developing the Field Service Management application.

## 2. System Requirements

### 2.1 Minimum Specifications
- **Operating System**: Windows 10+, macOS 12+, Linux Ubuntu 20.04+
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 10GB free space for Flutter and tools
- **Display**: 1920x1080 minimum resolution
- **Network**: Stable internet connection for package downloads

### 2.2 Development Tools
- **Git**: 2.30.0 or higher
- **Flutter SDK**: 3.5.0 or higher
- **Dart SDK**: 3.0 or higher
- **Visual Studio Code**: 1.80.0 or higher
- **Android Studio**: Arctic Fox or higher (for Android development)
- **Xcode**: 14.0 or higher (for iOS development, macOS only)

## 3. Environment Setup

### 3.1 Flutter Installation

#### Windows Installation
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\flutter

# Add Flutter to PATH
setx PATH "%PATH%;C:\flutter\bin"

# Verify installation
flutter doctor
```

#### macOS Installation
```bash
# Download Flutter SDK
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.5.0-stable.zip
unzip flutter_macos_3.5.0-stable.zip

# Move to Applications
sudo mv flutter /Applications/flutter

# Add to PATH in ~/.zshrc or ~/.bashrc
export PATH="$PATH:/Applications/flutter/bin"

# Reload shell
source ~/.zshrc

# Verify installation
flutter doctor
```

#### Linux Installation
```bash
# Download Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.5.0-stable.tar.xz
tar xf flutter_linux_3.5.0-stable.tar.xz

# Move to /opt
sudo mv flutter /opt/flutter

# Add to PATH in ~/.bashrc
export PATH="$PATH:/opt/flutter/bin"

# Reload shell
source ~/.bashrc

# Verify installation
flutter doctor
```

### 3.2 IDE Setup

#### Visual Studio Code Configuration
1. **Install Flutter Extension**
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Flutter" and install

2. **Install Dart Extension**
   - Search for "Dart" and install

3. **Recommended Extensions**
   - Flutter Widget Snippets
   - Awesome Flutter Snippets
   - Flutter Files
   - Pubspec Assist

4. **VS Code Settings** (Add to settings.json)
```json
{
  "dart.previewFlutterUiGuides": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "files.associations": {
    "*.dart": "dart"
  }
}
```

#### Android Studio Setup
1. **Download and Install**
   - Download from https://developer.android.com/studio
   - Follow installation wizard

2. **Install Flutter Plugin**
   - Open Android Studio
   - Go to File → Settings → Plugins
   - Search for "Flutter" and install
   - Restart Android Studio

3. **Configure Android SDK**
   - Open Android Studio
   - Go to Tools → SDK Manager
   - Install Android API 21+ and build tools

### 3.3 Mobile Development Setup

#### Android Development
1. **Install Android SDK**
   ```bash
   flutter doctor --android-licenses
   flutter doctor
   ```

2. **Set up Android Emulator**
   ```bash
   # List available emulators
   flutter emulators

   # Launch emulator
   flutter emulators --launch Pixel_4_API_30

   # Or create new emulator
   flutter emulators --create --name Pixel_4_API_30
   ```

3. **Connect Physical Device**
   - Enable Developer Options
   - Enable USB Debugging
   - Connect via USB
   - Accept RSA fingerprint

#### iOS Development (macOS only)
1. **Install Xcode**
   - Download from App Store
   - Install command line tools: `xcode-select --install`

2. **Configure iOS Simulator**
   ```bash
   # List available simulators
   flutter devices

   # Launch iOS simulator
   open -a Simulator
   ```

3. **Code Signing Setup**
   - Create Apple Developer account
   - Add Apple ID to Xcode preferences
   - Configure signing certificates

## 4. Project Setup

### 4.1 Repository Clone
```bash
# Clone the repository
git clone https://github.com/your-org/field-master.git
cd field-master

# Checkout development branch
git checkout develop

# Install dependencies
flutter pub get
```

### 4.2 Firebase Configuration

#### Firebase Project Setup
1. **Create Firebase Project**
   - Go to https://console.firebase.google.com
   - Create new project: "field-master-dev"
   - Enable Google Analytics (optional)

2. **Enable Firebase Services**
   - Authentication (Email/Password, Anonymous)
   - Firestore Database (Test mode initially)
   - Storage (Default rules)
   - App Check (Play Integrity API for Android)

3. **Download Configuration Files**
   ```bash
   # Android configuration
   # Download google-services.json and place in android/app/

   # iOS configuration
   # Download GoogleService-Info.plist and place in ios/Runner/
   ```

4. **FlutterFire CLI Setup**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Configure Firebase for Flutter
   flutterfire configure --project=field-master-dev
   ```

### 4.3 Environment Configuration

#### Development Environment Variables
Create `.env` files for different environments:

**`.env.development`**
```env
FIREBASE_PROJECT_ID=field-master-dev
GOOGLE_MAPS_API_KEY=your_dev_maps_api_key
ENVIRONMENT=development
DEBUG=true
```

**`.env.staging`**
```env
FIREBASE_PROJECT_ID=field-master-staging
GOOGLE_MAPS_API_KEY=your_staging_maps_api_key
ENVIRONMENT=staging
DEBUG=false
```

**`.env.production`**
```env
FIREBASE_PROJECT_ID=field-master-prod
GOOGLE_MAPS_API_KEY=your_prod_maps_api_key
ENVIRONMENT=production
DEBUG=false
```

### 4.4 Google Maps Setup

#### API Key Configuration
1. **Google Cloud Console**
   - Go to https://console.cloud.google.com
   - Create new project or select existing
   - Enable Maps SDK for Android/iOS
   - Create API key with appropriate restrictions

2. **Platform Configuration**
   ```xml
   <!-- Android: android/app/src/main/AndroidManifest.xml -->
   <meta-data
     android:name="com.google.android.geo.API_KEY"
     android:value="YOUR_API_KEY"/>
   ```

   ```xml
   <!-- iOS: ios/Runner/Info.plist -->
   <key>GOOGLE_MAPS_API_KEY</key>
   <string>YOUR_API_KEY</string>
   ```

## 5. Development Workflow

### 5.1 Running the Application

#### Development Mode
```bash
# Run on connected device/emulator
flutter run --flavor development --target lib/main_development.dart

# Run on web
flutter run -d web --flavor development

# Run on specific device
flutter run -d emulator-5554 --flavor development
```

#### Staging Mode
```bash
# Run staging build
flutter run --flavor staging --target lib/main_staging.dart
```

#### Production Mode
```bash
# Run production build
flutter run --flavor production --target lib/main_production.dart
```

### 5.2 Code Quality Tools

#### Analysis and Formatting
```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format .

# Fix analysis issues automatically
dart fix --apply
```

#### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/auth/auth_bloc_test.dart

# Run integration tests
flutter test integration_test/
```

### 5.3 Package Management

#### Adding Dependencies
```bash
# Add new package
flutter pub add package_name

# Add development dependency
flutter pub add --dev package_name

# Update dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

#### Local Packages Setup
```bash
# Link local packages
flutter pub get

# Update package dependencies
cd packages/auth_repo
flutter pub get
cd ../..

# Run tests for all packages
flutter pub run build_runner test --delete-conflicting-outputs
```

## 6. Debugging and Development Tools

### 6.1 Flutter DevTools

#### Launch DevTools
```bash
# Launch DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Or use VS Code Flutter extension
# Command Palette → Flutter: Open DevTools
```

#### Useful DevTools
- **Inspector**: Widget tree and layout exploration
- **Performance**: Frame rendering analysis
- **Memory**: Memory usage and leak detection
- **Network**: API call monitoring
- **Logging**: Debug print and log viewing

### 6.2 Debugging Techniques

#### Breakpoints and Debugging
1. **Set Breakpoints**: Click left of line numbers in VS Code
2. **Debug Mode**: Use `print()` statements for quick debugging
3. **Flutter Inspector**: Visual widget tree debugging
4. **Hot Reload**: `r` in terminal or Ctrl+R in VS Code

#### Common Debug Commands
```bash
# Clear cache and restart
flutter clean
flutter run

# Check device connection
flutter devices

# View connected devices
adb devices  # Android
# or
flutter devices
```

### 6.3 Logging and Monitoring

#### Structured Logging
```dart
import 'package:logger/logger.dart';

final logger = Logger();

// Usage
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

#### Firebase Logging
```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Record error
FirebaseCrashlytics.instance.recordError(error, stackTrace);

// Set custom key
FirebaseCrashlytics.instance.setCustomKey('user_id', userId);
```

## 7. Best Practices

### 7.1 Code Organization

#### File Structure
```
lib/
├── core/                 # Core functionality
│   ├── errors/          # Error handling
│   ├── usecases/        # Business logic
│   └── repositories/    # Data interfaces
├── features/            # Feature modules
│   ├── auth/           # Authentication
│   ├── home/           # Home screen
│   └── settings/       # Settings
├── shared/              # Shared utilities
│   ├── widgets/        # Common widgets
│   ├── utils/          # Helper functions
│   └── constants/      # App constants
└── main.dart           # App entry point
```

#### Naming Conventions
- **Files**: snake_case.dart (e.g., `user_model.dart`)
- **Classes**: PascalCase (e.g., `UserModel`)
- **Variables**: camelCase (e.g., `userName`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `API_KEY`)

### 7.2 State Management

#### BLoC Pattern Implementation
```dart
// Define events
abstract class AuthEvent extends Equatable {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
}

// Define states
abstract class AuthState extends Equatable {}

class Authenticated extends AuthState {
  final User user;
}

// Implement BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(Unauthenticated()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await repository.login(
        event.email,
        event.password,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
```

### 7.3 Error Handling

#### Global Error Handler
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  runApp(const FieldMasterApp());
}
```

#### Repository Error Handling
```dart
class AuthRepository {
  Future<User> login(String email, String password) async {
    try {
      final result = await _remoteDataSource.login(email, password);
      return result;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    }
  }
}
```

## 8. Testing Setup

### 8.1 Unit Testing

#### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/unit/auth_repository_test.dart

# Watch mode for TDD
flutter test --watch
```

#### Test Structure
```dart
// test/unit/auth_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  group('AuthRepository', () {
    late AuthRepository repository;
    late MockAuthRemoteDataSource remoteDataSource;

    setUp(() {
      remoteDataSource = MockAuthRemoteDataSource();
      repository = AuthRepository(remoteDataSource);
    });

    test('login returns user on success', () async {
      // Arrange
      when(() => remoteDataSource.login(any(), any()))
          .thenAnswer((_) async => User(id: '1', email: 'test@test.com'));

      // Act
      final result = await repository.login('test@test.com', 'password');

      // Assert
      expect(result.email, 'test@test.com');
    });
  });
}
```

### 8.2 Widget Testing

#### Widget Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('LoginForm shows error on invalid input', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: LoginForm()));

    // Act
    await tester.enterText(find.byType(TextField).first, 'invalid-email');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Assert
    expect(find.text('Please enter a valid email'), findsOneWidget);
  });
}
```

### 8.3 Integration Testing

#### Integration Test Setup
```dart
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('login flow', (WidgetTester tester) async {
      // Test complete user journey
    });
  });
}
```

## 9. Performance Optimization

### 9.1 Build Optimization

#### Bundle Size Optimization
```bash
# Analyze bundle size
flutter build apk --analyze-size

# Split per ABI (Android)
flutter build apk --split-per-abi

# Enable R8/ProGuard (Android)
flutter build apk --obfuscate --split-debug-info=build/debug-info
```

#### Asset Optimization
```bash
# Compress images
flutter build apk --target-platform android-arm64 --shrink

# Optimize web build
flutter build web --web-renderer html --pwa-strategy offline-first
```

### 9.2 Runtime Performance

#### Memory Management
```dart
// Use const widgets where possible
const Text('Hello World');

// Dispose controllers properly
class MyWidget extends StatefulWidget {
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

#### Network Optimization
```dart
// Use caching
final cachedResponse = await cache.get('api/users');

// Implement pagination
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(title: Text(items[index])),
);
```

## 10. Troubleshooting

### 10.1 Common Issues

#### Flutter Installation Issues
```bash
# Clear Flutter cache
flutter doctor --android-licenses
flutter clean

# Update Flutter
flutter upgrade
```

#### Package Resolution Issues
```bash
# Clear pub cache
flutter pub cache clean
flutter pub get

# Repair pub cache
flutter pub cache repair
```

#### Device Connection Issues
```bash
# Restart ADB server
adb kill-server
adb start-server

# Check device connection
flutter devices
```

### 10.2 Performance Issues

#### Slow Build Times
```bash
# Enable build caching
flutter build apk --fast-start

# Use daemon for faster builds
flutter --version  # Keep daemon running
```

#### App Performance Issues
```bash
# Profile performance
flutter run --profile

# Check for memory leaks
# Use Flutter Inspector in DevTools
```

## 11. Contributing Guidelines

### 11.1 Development Workflow

#### Git Workflow
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push and create PR
git push origin feature/new-feature
```

#### Code Review Process
1. Create pull request with clear description
2. Ensure all tests pass
3. Update documentation if needed
4. Get approval from code reviewers
5. Merge to develop branch

### 11.2 Code Standards

#### Dart Code Style
- Use trailing commas in multi-line collections
- Prefer const over final where possible
- Use async/await over .then()
- Handle errors appropriately

#### Documentation
- Add doc comments for public APIs
- Update README for new features
- Include code examples where helpful

## 12. Resources and References

### 12.1 Official Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Material Design Guidelines](https://material.io/design)

### 12.2 Community Resources
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter Reddit](https://www.reddit.com/r/FlutterDev/)
- [Flutter YouTube](https://www.youtube.com/c/flutterdev)

### 12.3 Development Tools
- [Flutter DevTools](https://docs.flutter.dev/development/tools/devtools)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Android Debug Bridge](https://developer.android.com/studio/command-line/adb)
- [Flutter Inspector](https://docs.flutter.dev/development/tools/inspector)

## 13. Support and Contact

### 13.1 Getting Help

#### Development Support
- **Team Chat**: #dev-support channel
- **Email**: dev-team@fieldmaster.com
- **Wiki**: https://wiki.fieldmaster.com
- **Issue Tracker**: GitHub Issues

#### Emergency Contacts
- **On-call Developer**: +260-XXX-XXXXX
- **DevOps Team**: devops@fieldmaster.com
- **Security Issues**: security@fieldmaster.com

---

*This development setup guide is regularly updated. Last revision: January 2025*
