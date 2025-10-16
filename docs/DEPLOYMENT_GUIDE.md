# Field Master - Deployment Guide

## 1. Overview

This guide provides comprehensive instructions for deploying Field Master across different environments and platforms. The application supports multiple deployment targets including mobile (iOS/Android), web, and desktop platforms.

## 2. Prerequisites

### 2.1 Development Tools
- **Flutter SDK**: 3.5.0 or higher
- **Dart SDK**: 3.0 or higher
- **Android Studio**: For Android development
- **Xcode**: For iOS development (macOS only)
- **Visual Studio Code**: Recommended IDE

### 2.2 Firebase Configuration
- Firebase project with Authentication, Firestore, and Storage enabled
- Google Maps API key
- Firebase App Check configured
- Push notification certificates (iOS)

### 2.3 CI/CD Tools
- **Git**: Version control
- **GitHub Actions**: CI/CD pipeline (optional)
- **Firebase CLI**: For hosting and functions deployment

## 3. Environment Configuration

### 3.1 Firebase Projects

#### Development Environment
```bash
# Firebase Project: field-master-dev
firebase use field-master-dev
```

#### Staging Environment
```bash
# Firebase Project: field-master-staging
firebase use field-master-staging
```

#### Production Environment
```bash
# Firebase Project: field-master-prod
firebase use field-master-prod
```

### 3.2 Environment Variables

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>GOOGLE_MAPS_API_KEY</key>
<string>YOUR_GOOGLE_MAPS_API_KEY</string>
```

#### Web (`web/index.html`)
```html
<script type="text/javascript">
  // Google Maps API Key
</script>
```

## 4. Build and Release Process

### 4.1 Flutter Build Commands

#### Development Build
```bash
# Android Development
flutter build apk --flavor development --target lib/main_development.dart

# iOS Development
flutter build ios --flavor development --target lib/main_development.dart

# Web Development
flutter build web --flavor development --target lib/main_development.dart
```

#### Staging Build
```bash
# Android Staging
flutter build apk --flavor staging --target lib/main_staging.dart

# iOS Staging
flutter build ios --flavor staging --target lib/main_staging.dart

# Web Staging
flutter build web --flavor staging --target lib/main_staging.dart
```

#### Production Build
```bash
# Android Production (APK)
flutter build apk --flavor production --target lib/main_production.dart

# Android Production (AAB - App Bundle)
flutter build appbundle --flavor production --target lib/main_production.dart

# iOS Production
flutter build ios --flavor production --target lib/main_production.dart

# Web Production
flutter build web --flavor production --target lib/main_production.dart
```

### 4.2 Platform-Specific Configurations

#### Android Configuration
1. **Build Gradle**: Update version codes and names
2. **Signing Config**: Configure keystore for release builds
3. **Firebase**: Download and place `google-services.json`
4. **Maps API**: Configure API key in manifest

#### iOS Configuration
1. **Info.plist**: Update bundle identifier and display name
2. **Signing**: Configure certificates and provisioning profiles
3. **Firebase**: Download and place `GoogleService-Info.plist`
4. **Maps API**: Configure API key in Info.plist

#### Web Configuration
1. **Firebase**: Configure hosting and authentication
2. **Maps API**: Add API key to index.html
3. **PWA**: Configure manifest.json for progressive web app
4. **Build**: Optimize for production deployment

## 5. Deployment Procedures

### 5.1 Mobile App Deployment

#### Google Play Store (Android)
1. **Internal Testing**
   ```bash
   # Upload AAB to Internal Testing
   firebase appdistribution:distribute android/app/build/outputs/bundle/productionRelease/app-production-release.aab \
     --app YOUR_FIREBASE_APP_ID \
     --release-notes "Bug fixes and performance improvements"
   ```

2. **Alpha/Beta Testing**
   ```bash
   # Create release on GitHub for testing
   gh release create v1.0.0-beta.1 \
     --title "Field Master v1.0.0 Beta 1" \
     --notes "New features and improvements"
   ```

3. **Production Release**
   ```bash
   # Build and sign AAB for production
   flutter build appbundle --flavor production

   # Upload to Google Play Console
   # Follow Google Play publishing guidelines
   ```

#### App Store (iOS)
1. **TestFlight**
   ```bash
   # Build IPA for TestFlight
   flutter build ios --flavor staging --export-method ad-hoc

   # Upload to TestFlight
   # Use Transporter app or altool
   ```

2. **App Store Release**
   ```bash
   # Build for App Store
   flutter build ios --flavor production --export-method app-store

   # Upload using Application Loader or Transporter
   # Submit for review
   ```

### 5.2 Web Deployment

#### Firebase Hosting
```bash
# Build for production
flutter build web --flavor production

# Deploy to Firebase Hosting
firebase deploy --only hosting

# Preview deployment
firebase hosting:channel:deploy preview
```

#### Custom Hosting
```bash
# Build optimized web app
flutter build web --web-renderer html --pwa-strategy offline-first

# Deploy to your hosting provider
# Upload contents of build/web/ to your web server
```

### 5.3 Desktop Deployment

#### Windows Deployment
```bash
# Build Windows executable
flutter build windows --flavor production

# Create installer (using third-party tools)
# Use Inno Setup or NSIS for installer creation
```

#### macOS Deployment
```bash
# Build macOS app
flutter build macos --flavor production

# Create .dmg or .pkg installer
# Code sign the application
```

## 6. Automated Deployment

### 6.1 GitHub Actions Workflow

#### Basic CI/CD Pipeline (`.github/workflows/deploy.yml`)
```yaml
name: Deploy Field Master

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.5.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage

  build_android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.5.0'
      - run: flutter build apk --flavor production
      - uses: actions/upload-artifact@v3
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-production-release.apk

  deploy_web:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.5.0'
      - run: flutter build web --flavor production
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          projectId: field-master-prod
```

### 6.2 Firebase Deployment Scripts

#### Automated Firebase Deployment (`scripts/deploy.sh`)
```bash
#!/bin/bash

# Deploy to Firebase Hosting
echo "Deploying to Firebase Hosting..."
firebase deploy --only hosting

# Deploy to Firebase App Distribution (Android)
echo "Deploying Android app to internal testing..."
firebase appdistribution:distribute build/app/outputs/bundle/productionRelease/app-production-release.aab \
  --app YOUR_FIREBASE_APP_ID \
  --release-notes "$(git log --oneline -1)"

echo "Deployment completed successfully!"
```

## 7. Rollback Procedures

### 7.1 Mobile App Rollback

#### Android Rollback
1. **Internal Testing Rollback**
   ```bash
   # Upload previous version to internal testing
   firebase appdistribution:distribute path/to/previous/app.aab \
     --app YOUR_FIREBASE_APP_ID \
     --release-notes "Rollback to previous version"
   ```

2. **Production Rollback**
   - Access Google Play Console
   - Navigate to Release management
   - Rollback to previous release

#### iOS Rollback
1. **TestFlight Rollback**
   - Upload previous build to TestFlight
   - Notify testers of rollback

2. **App Store Rollback**
   - Contact Apple Support for expedited review
   - Submit previous version for review

### 7.2 Web Rollback

#### Firebase Hosting Rollback
```bash
# View available versions
firebase hosting:versions:list

# Rollback to specific version
firebase hosting:rollback VERSION_NAME

# Deploy specific git commit
firebase hosting:channel:deploy rollback --expires 1h
```

## 8. Monitoring and Maintenance

### 8.1 Post-Deployment Verification

#### Health Checks
- [ ] Application launches successfully
- [ ] Authentication flow works
- [ ] Core features functional
- [ ] Push notifications working
- [ ] Location services enabled
- [ ] Maps integration functional

#### Performance Monitoring
- App startup time < 3 seconds
- Screen transitions < 500ms
- API responses < 2 seconds
- Crash-free sessions > 99.5%

### 8.2 Log Monitoring

#### Firebase Crashlytics
```bash
# View crash reports
firebase crashlytics:symbols:upload --app YOUR_APP_ID build/app/outputs/symbols

# Monitor crash dashboard
firebase crashlytics:viewer:open
```

#### Firebase Performance Monitoring
- Automatic performance data collection
- Custom trace points for critical operations
- Network request monitoring

### 8.3 Database Monitoring

#### Firestore Monitoring
- Database read/write operations
- Connection pool monitoring
- Query performance analysis
- Storage utilization tracking

## 9. Security Considerations

### 9.1 Pre-Deployment Security

#### Code Security
- [ ] Dependency vulnerability scanning
- [ ] Code signing verification
- [ ] API key protection
- [ ] Sensitive data encryption

#### Infrastructure Security
- [ ] Firebase security rules review
- [ ] Network security configuration
- [ ] Access control verification
- [ ] SSL/TLS certificate validation

### 9.2 Runtime Security

#### Monitoring
- Suspicious activity detection
- Unauthorized access attempts
- Data breach monitoring
- Security incident response

## 10. Troubleshooting

### 10.1 Common Deployment Issues

#### Build Failures
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --flavor production
```

#### Firebase Configuration Issues
```bash
# Verify Firebase configuration
firebase projects:list
firebase use YOUR_PROJECT_ID
```

#### Certificate Issues (iOS)
```bash
# Check certificate validity
security find-identity -v -p codesigning
```

### 10.2 Emergency Contacts

#### Technical Support
- **Email**: devops@fieldmaster.com
- **Slack**: #deployment-alerts
- **Phone**: +260-XXX-XXXXX (24/7 emergency)

## 11. Version Management

### 11.1 Version Control Strategy

#### Semantic Versioning
- **Major**: Breaking changes (1.x.x → 2.x.x)
- **Minor**: New features (x.1.x → x.2.x)
- **Patch**: Bug fixes (x.x.1 → x.x.2)

#### Release Branches
```
main (Production: v1.2.3)
├── develop (Development: v1.3.0)
│   ├── feature/new-analytics (v1.3.0-alpha.1)
│   └── hotfix/critical-bug (v1.2.4)
└── release/v1.3.0 (Release candidate)
```

### 11.2 Release Checklist

#### Pre-Release
- [ ] All tests passing
- [ ] Code review completed
- [ ] Documentation updated
- [ ] Security audit passed
- [ ] Performance benchmarks met

#### Release Day
- [ ] Build verification
- [ ] Deployment automation
- [ ] Rollback plan ready
- [ ] Monitoring alerts configured
- [ ] Team notification sent

#### Post-Release
- [ ] User feedback monitoring
- [ ] Performance monitoring
- [ ] Bug reports tracking
- [ ] Success metrics analysis

## 12. Cost Optimization

### 12.1 Firebase Cost Management

#### Firestore Optimization
- Implement query optimization
- Use composite indexes
- Implement data pagination
- Monitor read/write operations

#### Storage Optimization
- Image compression before upload
- Implement file cleanup policies
- Use appropriate storage classes
- Monitor storage utilization

### 12.2 Performance Optimization

#### Bundle Size Optimization
```bash
# Analyze bundle size
flutter build apk --analyze-size

# Optimize assets
flutter build apk --split-per-abi
```

#### Network Optimization
- Implement request caching
- Use image optimization
- Implement lazy loading
- Monitor network usage

## 13. Compliance and Regulations

### 13.1 Data Protection

#### GDPR Compliance
- Data processing agreements
- User consent management
- Data deletion capabilities
- Privacy policy updates

#### Local Regulations
- Data localization requirements
- Industry-specific compliance
- Export control regulations
- Consumer protection laws

### 13.2 Accessibility Compliance

#### WCAG 2.1 AA Compliance
- Screen reader support
- Keyboard navigation
- Color contrast ratios
- Alternative text for images

## 14. Success Metrics

### 14.1 Deployment Success

#### Technical Metrics
- Deployment success rate > 99%
- Average deployment time < 15 minutes
- Rollback necessity < 1%
- Post-deployment issues < 5%

#### Business Metrics
- User adoption rate
- Feature utilization
- Customer satisfaction
- Revenue impact

---

*This deployment guide is regularly updated. Last revision: January 2025*
