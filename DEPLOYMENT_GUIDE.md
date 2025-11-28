# Deployment Guide

This guide will help you deploy the Sabzi_Market app to both iOS and Android.

## 📋 Pre-Deployment Checklist

### ✅ Code Quality
- [x] All improvements implemented
- [x] Image caching optimized
- [x] Error handling improved
- [x] Upload state management added
- [x] Camera support added

### ✅ Platform Configuration
- [x] iOS deployment target: 12.0
- [x] Android minSdk: 21
- [x] Android targetSdk: 35
- [x] Permissions configured

## 🍎 iOS Deployment

### Prerequisites
1. Apple Developer Account ($99/year)
2. Xcode installed
3. Valid provisioning profiles

### Steps

1. **Update Version**
   ```bash
   # Update version in pubspec.yaml
   version: 1.0.0+1  # Format: version+buildNumber
   ```

2. **Build iOS**
   ```bash
   chmod +x build_ios.sh
   ./build_ios.sh
   ```

3. **Open in Xcode**
   ```bash
   open ios/Runner.xcworkspace
   ```

4. **Configure Signing**
   - Select Runner target
   - Go to "Signing & Capabilities"
   - Select your Team
   - Xcode will automatically manage provisioning

5. **Archive**
   - Select "Any iOS Device" as target
   - Product > Archive
   - Wait for archive to complete

6. **Distribute**
   - Click "Distribute App"
   - Choose distribution method (App Store, Ad Hoc, Enterprise)
   - Follow the wizard

### App Store Connect
1. Create app in App Store Connect
2. Upload build via Xcode or Transporter
3. Fill in app information
4. Submit for review

## 🤖 Android Deployment

### Prerequisites
1. Google Play Developer Account ($25 one-time)
2. Keystore file for signing
3. App signing key configured

### Steps

1. **Update Version**
   ```bash
   # Update version in pubspec.yaml
   version: 1.0.0+1  # Format: version+buildNumber
   ```

2. **Build Android**
   ```bash
   chmod +x build_android.sh
   ./build_android.sh
   ```

3. **Sign APK/AAB** (if not using Play App Signing)
   ```bash
   # APK is already signed if you have key.properties configured
   # AAB needs to be signed for upload
   ```

4. **Upload to Play Store**
   - Go to Google Play Console
   - Create new app or select existing
   - Upload AAB file
   - Fill in store listing
   - Submit for review

## 🔐 Signing Configuration

### Android Keystore
Your app already has keystore configuration in `android/key.properties`:
- Key alias
- Key password
- Store file path
- Store password

**Important:** Keep your keystore file and passwords secure!

### iOS Signing
Configured automatically via Xcode with your Apple Developer account.

## 📊 Build Artifacts

### Android
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **AAB**: `build/app/outputs/bundle/release/app-release.aab`

### iOS
- **Archive**: Created in Xcode Organizer
- **IPA**: Generated during distribution

## 🚀 Quick Build Commands

### Android
```bash
# APK only
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release

# Split APKs by ABI (smaller file size)
flutter build apk --split-per-abi --release
```

### iOS
```bash
# Build iOS
flutter build ios --release

# Build IPA directly
flutter build ipa --release
```

## 📝 Version Management

Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1
#        ^     ^
#        |     +-- Build number (increment for each build)
#        +-------- Version name (increment for releases)
```

## 🔍 Testing Before Deployment

1. **Test on Real Devices**
   ```bash
   # Android
   flutter run --release
   
   # iOS
   flutter run --release
   ```

2. **Test All Features**
   - [ ] Image upload (camera & gallery)
   - [ ] Product/Service creation
   - [ ] Image loading (should be fast with caching)
   - [ ] Error handling
   - [ ] Dark/Light theme
   - [ ] Multi-language support

3. **Performance Check**
   - [ ] App startup time
   - [ ] Image loading speed
   - [ ] Memory usage
   - [ ] Network requests

## 🐛 Common Issues

### iOS
- **Pod install errors**: Run `cd ios && pod install --repo-update`
- **Signing issues**: Check Team selection in Xcode
- **Archive fails**: Clean build folder in Xcode

### Android
- **Build fails**: Check `android/local.properties` for SDK path
- **Signing errors**: Verify `key.properties` configuration
- **Gradle errors**: Update Gradle version if needed

## 📱 App Store Requirements

### iOS
- App icons (all sizes)
- Launch screen
- Privacy policy URL
- App description
- Screenshots (all device sizes)

### Android
- App icon (512x512)
- Feature graphic (1024x500)
- Screenshots
- Privacy policy URL
- App description

## 🎯 Post-Deployment

1. Monitor crash reports (Firebase Crashlytics recommended)
2. Track analytics
3. Monitor user reviews
4. Plan updates based on feedback

## 📚 Additional Resources

- [Flutter Deployment Guide](https://docs.flutter.dev/deployment)
- [iOS App Store Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Google Play Policies](https://play.google.com/about/developer-content-policy/)

---

**Good luck with your deployment! 🚀**

