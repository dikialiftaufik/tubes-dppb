# 🚀 Quick Start Commands

## Useful Development Commands

### Setup & Dependencies
```bash
# Get all dependencies
flutter pub get

# Upgrade all packages to latest compatible versions
flutter pub upgrade

# Clean build artifacts
flutter clean

# Get dependencies and clean
flutter pub get && flutter clean
```

### Code Quality & Analysis
```bash
# Analyze Dart code for errors
dart analyze lib/

# Check specific file
dart analyze lib/menu_screen.dart

# Format all Dart files
dart format lib/

# Format specific file
dart format lib/menu_screen.dart
```

### Running the App
```bash
# Run on default device
flutter run

# Run in release mode
flutter run --release

# Run on specific device
flutter run -d emulator-5554

# Run on web
flutter run -d chrome

# Run with debug output
flutter run -v
```

### Building for Deployment
```bash
# Build APK for Android
flutter build apk

# Build app bundle for Google Play
flutter build appbundle

# Build iOS app
flutter build ios

# Build web
flutter build web
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage

# Run specific test
flutter test -k "test_name"
```

### Debugging & Troubleshooting
```bash
# Show Flutter devices
flutter devices

# Show Flutter doctor info
flutter doctor

# Show Flutter doctor in verbose mode
flutter doctor -v

# Check for outdated packages
flutter pub outdated

# Update to latest SDK
flutter upgrade

# Get info about Flutter install
flutter --version
```

### IDE Commands (in VS Code Terminal)
```bash
# Search for any compilation errors in project
dart analyze .

# Check specific directory
dart analyze lib/

# Dart format check (without formatting)
dart format --line-length 80 lib/ --set-exit-if-changed

# Run pub get in current directory
dart pub get
```

## Project Structure Reference

```
lib/
├── main.dart                    # App entry point
├── main_screen.dart             # Bottom navigation shell
├── constants.dart               # Design system colors & styles
├── models.dart                  # Data classes (MenuItem, CartItem, Order)
│
├── Authentication Flow
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── forgot_password_screen.dart
│   └── reset_password_screen.dart
│
├── Main Navigation
│   ├── home_screen.dart
│   ├── menu_screen.dart              # [NEW] Menu grid with filtering
│   ├── menu_detail_screen.dart        # [NEW] Product detail view
│   ├── profile_screen.dart            # [UPDATED] Added order access
│   └── feedback_screen.dart
│
├── Shopping Flow
│   ├── cart_screen.dart              # [NEW] Shopping cart
│   ├── checkout_screen.dart          # [NEW] Payment & delivery
│   └── order_status_screen.dart      # [NEW] Order tracking
│
└── Legacy Features
    ├── edit_profile_screen.dart
    ├── my_reservation_screen.dart
    └── reservation_form_screen.dart
```

## Common Development Tasks

### Adding a New MenuItem
Edit `lib/models.dart` and add to the `allMenuItems` list in `menu_screen.dart`:

```dart
MenuItem(
  id: '7',
  name: 'Gulai Ayam',
  category: 'Gulai',
  meat: 'Ayam',
  price: 38000,
  description: 'Daging ayam dengan kuah gulai kuning yang gurih',
  imageUrl: 'assets/gulai_ayam.png',
)
```

Then update the `FilterChip` category options if needed.

### Modifying Prices
In `lib/menu_screen.dart`, find the menu item and update the `price` parameter:
```dart
price: 40000,  // Updated from 35000
```

### Changing Colors
Edit `lib/constants.dart` in the `AppColors` class:
```dart
static const Color primary = Color(0xFFE65100);  // Burnt Orange
```

### Adding Payment Methods
In `lib/checkout_screen.dart`, modify the `_selectedPaymentMethod` state and add new radio option in the Payment section:

```dart
_buildPaymentOption(
  title: 'Dana',
  icon: Icons.mobile_screen_share,
  value: 'dana',
)
```

### Changing Delivery Fee
In `lib/checkout_screen.dart`, find:
```dart
const double deliveryFee = 10000;  // Change this value
```

## Environment Variables & Configuration

Create a `.env` file in project root for sensitive data (API keys, etc.):
```
API_BASE_URL=https://api.example.com
PAYMENT_KEY=your_payment_key_here
FIREBASE_PROJECT_ID=your_project_id
```

## Important Files to Know

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Dependencies and package configuration |
| `analysis_options.yaml` | Dart code analysis rules |
| `lib/constants.dart` | Design system (colors, fonts, styles) |
| `lib/models.dart` | Data classes and structures |
| `lib/main.dart` | App initialization and routing |
| `android/app/build.gradle.kts` | Android build configuration |
| `ios/Runner.xcodeproj` | iOS project configuration |

## Performance Tips

1. **Use const constructors** where possible:
   ```dart
   const Text('Hello')  // Better
   Text('Hello')        // Slower
   ```

2. **Cache images**:
   ```dart
   Image.asset('assets/image.png', cacheHeight: 200, cacheWidth: 200)
   ```

3. **Use ListView.builder** for long lists:
   ```dart
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemTile(items[index]),
   )
   ```

4. **Minimize rebuilds** with const and proper state management

## Troubleshooting Common Issues

### Issue: "Gradle build failed"
```bash
flutter clean
rm -rf android/.gradle
flutter pub get
flutter run
```

### Issue: "Target of URI doesn't exist"
```bash
flutter pub get
flutter clean
flutter run
```

### Issue: "CocoaPods dependency conflict"
```bash
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter pub get
flutter run
```

### Issue: "Web app not building"
```bash
flutter clean
flutter web --web-renderer html
flutter run -d chrome
```

### Issue: "Hot reload not working"
Try hot restart:
```bash
flutter run
# Then press 'R' for hot restart (not 'r' for hot reload)
```

## Git Commands for Version Control

```bash
# Initialize git
git init

# Add all changes
git add .

# Commit changes
git commit -m "Add shopping cart feature"

# Check status
git status

# View log
git log --oneline

# Create branch
git checkout -b feature/payments

# Switch branch
git checkout main

# Merge branch
git merge feature/payments
```

## Documentation Files Reference

| File | Content |
|------|---------|
| `FINAL_CHECKLIST.md` | Complete implementation status & checklist |
| `DOKUMENTASI_HALAMAN_BARU.md` | Feature breakdown & testing checklist |
| `IMPLEMENTATION_GUIDE.md` | Detailed layouts & code samples |
| `USER_GUIDE_INDONESIA.md` | User-facing guide with pricing |
| `QUICK_REFERENCE.md` | Developer code snippets & reference |
| `ARCHITECTURE.md` | System architecture & data flows |
| `COMPLETION_SUMMARY.md` | Project status & next steps |

## Need Help?

1. **Check the docs** - Most questions answered in documentation files
2. **Run analysis** - `dart analyze lib/` to find issues
3. **Check Flutter doctor** - `flutter doctor -v` for environment issues
4. **Search codebase** - Use Ctrl+Shift+F in VS Code to find code
5. **Review git history** - `git log` to see what changed

---

**Last Updated**: December 11, 2025
