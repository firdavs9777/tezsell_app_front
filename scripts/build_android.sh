#!/bin/bash

# Android Build Script
# This script builds the Android APK/AAB for release

echo "🚀 Building Android Release..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build APK
echo "📱 Building Android APK..."
flutter build apk --release

# Build App Bundle (for Play Store)
echo "📦 Building Android App Bundle..."
flutter build appbundle --release

echo "✅ Android build complete!"
echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
echo "📦 AAB location: build/app/outputs/bundle/release/app-release.aab"

