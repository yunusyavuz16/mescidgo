#!/bin/bash

echo "Cleaning Flutter project..."
flutter clean
rm pubspec.lock

echo "Cleaning iOS dependencies..."
cd ios && rm -rf Pods Podfile.lock && pod install --repo-update && cd ..

echo "Fetching Flutter dependencies..."
flutter pub get

echo "Done! 🎉"
