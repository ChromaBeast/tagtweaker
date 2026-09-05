---
description: Build, verify, and distribute Tag Tweaker to Firebase App Distribution and GitHub Releases
---

# Tag Tweaker Distribution Workflow

This workflow automates the end-to-end release process: running test/lint checks, compiling optimized split-per-ABI release APKs, distributing builds to Firebase App Distribution testers, and publishing release assets to GitHub Releases.

> [!IMPORTANT]
> **GitHub Security & Secret Hygiene:**
> Never commit `service-account.json`, `android/key.properties`, or upload keystores to Git.
> Verify that all sensitive credential files are excluded in `.gitignore`.

---

## Prerequisites

1. **Flutter SDK** installed and in `PATH`.
2. **Firebase CLI** installed (`npm install -g firebase-tools` or standalone binary).
3. **GitHub CLI** (`gh`) installed and authenticated (`gh auth status`).
4. Firebase service account credential file present locally at `service-account.json` (gitignored).

---

## Step 1: Pre-Release Validation

Ensure code cleanliness, styling, and test regression checks pass:

```powershell
flutter analyze
flutter test
```

---

## Step 2: Version Bump

Update the version in `pubspec.yaml` (format: `<major>.<minor>.<patch>+<buildNumber>`):

```yaml
version: 1.1.0+2
```

---

## Step 3: Compile Split-per-ABI Release APKs

Generate architecture-optimized APKs for minimum download footprint:

```powershell
flutter build apk --release --split-per-abi
```

Generated artifacts:
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

---

## Step 4: Distribute to Firebase App Distribution (Testers)

Set the service account credentials in environment and distribute to the `testers` group:

```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS = "$PSScriptRoot\service-account.json"

firebase appdistribution:distribute "build\app\outputs\flutter-apk\app-arm64-v8a-release.apk" `
  --app "1:768847026435:android:12d5205e1198d3e5167136" `
  --groups "testers" `
  --release-notes-file "RELEASE_NOTES.md" `
  --project "tagtweaker-sheersh"
```

---

## Step 5: Publish Release to GitHub Releases

Tag the release and publish all generated split APKs:

```powershell
# 1. Commit any updated release notes or version bumps
git add pubspec.yaml RELEASE_NOTES.md
git commit -m "chore: release v1.1.0"

# 2. Tag the release
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin main --tags

# 3. Create GitHub Release with all split APK binaries attached
gh release create v1.1.0 `
  "build/app/outputs/flutter-apk/app-arm64-v8a-release.apk#ARM64 APK (Modern Devices)" `
  "build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk#ARMv7 APK (Older 32-bit Devices)" `
  "build/app/outputs/flutter-apk/app-x86_64-release.apk#x86_64 APK (Emulators & Tablets)" `
  --title "Tag Tweaker v1.1.0 — The Snappy & Lean Update" `
  --notes-file "RELEASE_NOTES.md"
```
