#!/bin/bash

# iOS Build Script
# This script builds the iOS app for release

echo "🚀 Building iOS Release..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Install CocoaPods dependencies
echo "🍎 Installing CocoaPods dependencies..."
cd ios
pod install
cd ..

# Build iOS
echo "📱 Building iOS app..."
flutter build ios --release

echo "✅ iOS build complete!"
echo "📱 IPA location: build/ios/iphoneos/Runner.app"
echo ""
echo "📝 Next steps:"
echo "1. Open Xcode: open ios/Runner.xcworkspace"
echo "2. Select 'Any iOS Device' as target"
echo "3. Product > Archive"
echo "4. Distribute App to App Store"

