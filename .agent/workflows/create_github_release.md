---
description: Build and release the Flutter application to GitHub
---

1. Build the release APK
// turbo
flutter build apk --release

2. Build the app bundle
// turbo
flutter build appbundle --release

3. Create a git tag (Update 'v1.0.0' to your desired version)
git tag -a v1.0.0 -m "Release v1.0.0"

4. Push changes and tags
git push origin main --tags

5. Create GitHub Release (Ensure 'gh' CLI is installed or do this manually on web)
gh release create v1.0.0 build/app/outputs/flutter-apk/app-release.apk build/app/outputs/bundle/release/app-release.aab --generate-notes
