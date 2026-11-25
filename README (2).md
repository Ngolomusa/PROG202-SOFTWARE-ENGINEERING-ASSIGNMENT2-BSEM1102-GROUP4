# DSalone MediStock

Flutter Android prototype for managing medicine inventory at a health facility. This README explains the project structure, setup, how to run the app on an Android emulator, how to check the core workflows, and what is not yet implemented.

> **Prototype notice:** This is a coursework demonstration, not a production health-information system. Do not enter real patient information. The app currently stores its working data in memory, so changes reset when the app process is restarted.

## 1. What the app does

The app presents 18 navigable destinations:

1. Dashboard
2. Current stock
3. Medicine directory
4. Register medicine
5. Medicine details
6. Receive stock
7. Dispense medicine
8. Stock alerts (low stock and expiring soon)
9. Stock records
10. Search medicines
11. Dispensing records
12. Received stock records
13. Stock adjustment
14. Supplier directory
15. Add supplier
16. Delivery details
17. Facility profile
18. Settings & Help

The main connected workflows use a shared `MediStockStore`:

- Register medicines with an ID, name, category, and unit.
- Receive stock for a registered medicine, with quantity, expiry date, reorder level, and supplier/source.
- Dispense medicine to a recipient reference. The available quantity is reduced and a transaction record is created.
- Review inventory, search by medicine name/ID/category, and view low-stock and expiry alerts.
- Review received-stock and dispensing transaction records.

Low stock means quantity is at or below the reorder level. In the current store logic, “expiring soon” means within 60 days.

Some destinations are demonstration screens, not complete data-management features: the supplier directory uses sample data; Add supplier and Stock adjustment validate their forms but do not update the shared store; Delivery details and Facility profile show sample information; Settings switches are local screen state only.

## 2. Project structure

The current local project is expected at `C:\src\medistock_app` and is organized approximately as follows:

```text
medistock_app/
├── android/                    # Android platform project
├── lib/
│   ├── main.dart               # App entry point, theme, routes, shared navigation
│   ├── medi_stock_store.dart   # Shared in-memory models, sample data, and stock logic
│   └── screens/                # Screen implementations
├── test/                       # Flutter tests, if present in the local project
├── pubspec.yaml                # Flutter package/dependency configuration
└── README.md
```

The store file is directly under `lib`, not under `lib/data`. From `main.dart`, the relative import should therefore be:

```dart
import 'medi_stock_store.dart';
```

Do not change it to `data/medi_stock_store.dart` unless you also move the file and update all imports.

## 3. Requirements

On the Windows computer, install or confirm:

- Flutter SDK and Dart (the project has previously been run with Flutter from `C:\src\flutter\flutter`).
- Android Studio with Android SDK and Android emulator support.
- A booted Android emulator or a USB-connected Android phone with developer debugging enabled.
- Internet access for the first dependency and Gradle downloads.

The previously configured Android SDK path was `C:\Android\Sdk`. Android Studio’s bundled Java is normally sufficient for this project. The missing Visual Studio component reported by `flutter doctor` is for Windows desktop builds and is not required to build/run this Android app.

## 4. Run the app from PowerShell

### A. Start the emulator

Open Android Studio, start the project’s Android emulator from **Device Manager**, and wait until the Android home screen is fully loaded.

### B. Open the project folder

Open PowerShell and run:

```powershell
Set-Location 'C:\src\medistock_app'
```

Confirm you are in the right folder:

```powershell
Get-Location
Test-Path '.\pubspec.yaml'
```

The second command should print `True`.

### C. Check Flutter and the connected device

```powershell
flutter doctor -v
flutter devices
```

Confirm that Android toolchain is available and that the emulator appears in the device list. The emulator ID has previously been `emulator-5554`; if `flutter devices` shows a different ID, use that ID instead.

If Flutter is not pointed to the Android SDK, set the path once:

```powershell
flutter config --android-sdk 'C:\Android\Sdk'
```

### D. Get dependencies and launch

From the project folder:

```powershell
flutter pub get
flutter run -d emulator-5554
```

Replace `emulator-5554` with the ID shown by `flutter devices`, if different. The first Android build may take a long time because Gradle downloads Android and Flutter artifacts. Keep the terminal open while it is working. When the build succeeds, Flutter installs the APK and starts the app on the emulator.

Useful keys in the running `flutter run` terminal:

- `r` — hot reload after a code change.
- `R` — hot restart the app.
- `q` — stop the Flutter run session.

### E. Build an APK without launching

```powershell
flutter build apk --debug
```

When successful, the debug APK is normally written to:

```text
build\app\outputs\flutter-apk\app-debug.apk
```

A debug APK is for development/testing. Follow your lecturer’s instructions for the required final deliverable and release-build configuration.

## 5. Run from Android Studio instead

1. In Android Studio, choose **Open** and select `C:\src\medistock_app` (the folder containing `pubspec.yaml`).
2. Wait for Flutter/Gradle project loading and dependency resolution to finish.
3. Start the Android emulator in Device Manager.
4. Select the emulator in the device selector.
5. Open `lib/main.dart` and press the green **Run** button.

The PowerShell method above is useful when you need to see the complete build output. Avoid running two builds at once from Android Studio and PowerShell; let one build finish or stop it before starting another.

## 6. How to use the app

1. Start on **Dashboard** and use its cards or quick actions.
2. Open **Current stock** to view balances, search, or select the Low stock/Expiring filters.
3. Use **Medicine directory** to browse registered medicines; select a row for details.
4. Use **Register medicine** to add a medicine. Complete all fields and use a unique medicine ID.
5. Use **Receive stock** to select a medicine, enter a positive quantity, reorder level, supplier/source, and expiry date. Confirm the receipt to update the in-memory inventory.
6. Use **Dispense medicine** to select stock, enter a quantity and recipient reference, and confirm. The app should reject an amount greater than the displayed available balance.
7. Review **Stock alerts**, **Stock records**, **Dispensing records**, and **Received stock records** to see current in-session information.
8. Use the bottom navigation bar for frequent destinations. Open the drawer to access the complete screen list. Use the system back control to return through the navigation stack.

The project starts with sample medicines. Any medicines or transactions you add during a session are temporary and will be cleared when the app process is restarted.

## 7. Checks to perform before submission

Run these from the project directory and record the actual results:

```powershell
flutter pub get
flutter analyze
flutter test
```

Then launch the app on the emulator and manually check:

- Each drawer item opens the correct screen; bottom navigation works; back navigation returns as expected.
- Registering a medicine with all fields works; leaving required fields blank is rejected; duplicate IDs are rejected.
- Receiving a positive quantity updates the stock balance and creates a received-stock record.
- Dispensing a valid quantity reduces the balance and creates a dispensing record.
- Dispensing more than the available quantity is rejected without making the balance negative.
- Low-stock and expiry alerts match the quantities, reorder levels, and sample expiry dates.
- Search finds medicines by name, ID, and category.
- The supplier and adjustment pages are described as prototypes unless their data-saving behavior has been completed.

The app has been reported by the developer to build and run on the Android emulator, but the checks above should be re-run on the final local version. Do not report a test as passed unless it was actually run and observed.

## 8. Screenshots for the report

Capture genuine screenshots from the running Android emulator; do not use mock-ups. Android Studio’s emulator toolbar has a screenshot/camera control. Save the images in a `screenshots` folder in the project (create the folder if it does not exist). Suggested filenames:

```text
screenshots/
├── 01-dashboard.png
├── 02-current-stock.png
├── 03-medicine-details.png
├── 04-register-medicine.png
├── 05-receive-stock.png
├── 06-dispense-medicine.png
├── 07-stock-alerts.png
├── 08-transaction-records.png
├── 09-search-or-suppliers.png
└── 10-settings-or-facility.png
```

Insert these genuine captures into the 10 reserved frames in the assignment report. The report files prepared with this project are named `DSalone_MediStock_Assignment_Report.docx` and `DSalone_MediStock_Assignment_Report.pdf`. Fill in personal/course details, add evidence, and export the final PDF after inserting screenshots. The DOCX uses Tahoma; if the provided PDF draft uses a substitute font on your computer, export a fresh PDF from Microsoft Word on Windows to preserve Tahoma.

## 9. Known limitations

- **Lag:** noticeable lag has been reported. Its cause has not been diagnosed and no performance fix is claimed here. Profile and investigate it after the report is completed.
- **No persistence:** shared application data is held in memory and resets when the app is restarted.
- **Prototype-only screens:** supplier management, stock adjustment, delivery details, facility profile, and settings are not all connected to persistent business logic.
- **Single expiry date per medicine:** the current model does not maintain multiple stock batches/lots with separate expiry dates, so it does not implement FEFO batch dispensing.
- **No production security or backend:** authentication, role permissions, audit controls, cloud synchronization, and production data protection are not implemented or verified.

## 10. Troubleshooting

### Emulator is not listed

Start it from Android Studio’s Device Manager, then run:

```powershell
flutter devices
```

Use the exact device ID printed by Flutter. If necessary, close and restart the emulator, then check again.

### `flutter pub get` or the first Gradle build is taking a long time

The first build downloads dependencies. A growing Gradle temporary download file or new build output can indicate progress. Do not delete temporary/cache files while Gradle is running. If it stops progressing or fails with a network/DNS message, check the connection and try again when the network is stable:

```powershell
nslookup storage.googleapis.com
```

A Java warning mentioning a restricted method is not necessarily the build failure; look for the final `BUILD FAILED` section and the underlying error. Do not start a second build while the first one is still running.

### Build errors after code changes

First check the first Dart error reported by Flutter; later messages may be consequences of that error. Confirm imports match the actual folder layout, especially `import 'medi_stock_store.dart';` from `lib/main.dart`. After fixing source errors, run:

```powershell
flutter pub get
flutter run -d emulator-5554
```

Use `flutter clean` only when there is evidence of stale generated build output or when specifically troubleshooting a build issue. It deletes generated build files and makes the next build take longer:

```powershell
flutter clean
flutter pub get
flutter run -d emulator-5554
```

### Android SDK or NDK path problem

Confirm the configured SDK path is `C:\Android\Sdk` and run `flutter doctor -v`. If the SDK is installed elsewhere, point Flutter to the real SDK folder with `flutter config --android-sdk 'FULL\PATH\TO\Sdk'`. Do not guess or move SDK/NDK folders while Android Studio or Gradle is using them.

### App data seems to disappear

This is expected in the current prototype: its shared store is in memory. Restarting the app returns to the sample data. Persistent database storage is a future enhancement.

## 11. GitHub and submission

Create the repository in your own GitHub account, review the files before publishing, and do not upload passwords, API keys, or other private credentials. From PowerShell, check the current Git state first:

```powershell
git status
```

If this project is not already a Git repository, initialize it from the project root:

```powershell
git init
git add .
git commit -m "Add DSalone MediStock Flutter prototype"
```

Create an empty repository on GitHub, then connect and push using the URL GitHub provides:

```powershell
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git push -u origin main
```

Replace the example URL with your actual repository URL. If a remote already exists, inspect it with `git remote -v` rather than adding a duplicate. Confirm that the repository contains the Flutter source, README, and any assignment files that your lecturer expects.

Before final submission:

- Complete all blank cover-page details in the report.
- Add genuine screenshots to the report and project screenshots folder.
- Verify all 18 destinations and the relevant form scenarios on the final build.
- Re-check GridView and image-widget requirements.
- Run and record `flutter analyze` and `flutter test` results, if applicable.
- Add the GitHub repository URL to the report.
- Export and inspect the final PDF using the required Tahoma, 12 pt, 1.5-spacing, justified format.
