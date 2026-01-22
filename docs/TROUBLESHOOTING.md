# Troubleshooting Guide

## SocketException: Send failed (OS Error: No route to host, errno = 65)

This error occurs when Flutter cannot connect to the device via mDNS (multicast DNS). This is a network connectivity issue, not a code problem.

### Quick Fixes

#### 1. Restart Flutter Daemon
```bash
# Kill all Flutter processes
killall -9 dart
killall -9 flutter

# Restart Flutter
flutter doctor
```

#### 2. Use Direct Connection (Bypass mDNS)
```bash
# Run with specific device and disable mDNS
flutter run --device-id=00008120-001A25961E44C01E --no-pub
```

#### 3. Check Network Settings
- Ensure your Mac and iPhone are on the same Wi-Fi network
- Disable VPN if active
- Check firewall settings

#### 4. Try Different Connection Method
```bash
# List available devices
flutter devices

# Try running on simulator first
flutter run -d "iPhone 15 Pro"

# Or try USB connection only
flutter run --device-id=00008120-001A25961E44C01E --no-pub
```

#### 5. Reset Network Settings
```bash
# On Mac: System Settings > Network > Reset
# On iPhone: Settings > General > Reset > Reset Network Settings
```

#### 6. Use Release Mode (Bypasses Debug Connection)
```bash
flutter run --release --device-id=00008120-001A25961E44C01E
```

#### 7. Alternative: Build and Install Manually
```bash
# Build iOS app
flutter build ios --release

# Then install via Xcode or TestFlight
```

### Permanent Solutions

#### Option 1: Use USB Connection Only
Add to your `~/.zshrc` or `~/.bash_profile`:
```bash
export FLUTTER_HOST=localhost
```

#### Option 2: Disable mDNS Discovery
Create or edit `~/.flutter_settings`:
```json
{
  "enable-macos-desktop": true,
  "enable-windows-desktop": true,
  "enable-linux-desktop": true
}
```

#### Option 3: Update Flutter
Your Flutter version is quite old (3.13.8). Consider updating:
```bash
flutter upgrade
```

### For Deployment (Recommended)

Since you're preparing for deployment, use release builds which don't require debug connections:

**iOS:**
```bash
flutter build ios --release
# Then use Xcode to archive and distribute
```

**Android:**
```bash
flutter build appbundle --release
# Upload to Play Store
```

### Common Causes

1. **Network Issues**: Mac and device not on same network
2. **Firewall**: Blocking mDNS traffic (port 5353)
3. **VPN**: Interfering with local network discovery
4. **Flutter Version**: Older versions may have mDNS issues
5. **macOS Network Settings**: Network location or proxy settings

### If Nothing Works

1. **Use Xcode directly**:
   ```bash
   open ios/Runner.xcworkspace
   # Build and run from Xcode
   ```

2. **Use Android Studio** for Android builds

3. **Build release versions** and install via TestFlight/Play Store

---

**Note**: This error doesn't affect your app's functionality. It only affects the debug connection. Release builds work fine.

