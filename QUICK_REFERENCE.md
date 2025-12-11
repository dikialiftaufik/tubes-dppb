# The Komars - Quick Reference

## 📁 Project Structure

```
tubes-dppb/
│
├── lib/
│   ├── main.dart                      ★ Entry point
│   ├── constants.dart                 ★ Colors & Styles
│   ├── models.dart                    ✨ NEW - Data models
│   │
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   └── reset_password_screen.dart
│   │
│   ├── menu/
│   │   ├── menu_screen.dart           ✨ UPDATED - Grid + Filter
│   │   └── menu_detail_screen.dart    ✨ NEW
│   │
│   ├── cart/
│   │   └── cart_screen.dart           ✨ NEW
│   │
│   ├── order/
│   │   ├── checkout_screen.dart       ✨ NEW
│   │   └── order_status_screen.dart   ✨ NEW
│   │
│   ├── profile/
│   │   ├── profile_screen.dart        ✨ UPDATED
│   │   ├── edit_profile_screen.dart
│   │   └── feedback_screen.dart
│   │
│   └── home/
│       ├── home_screen.dart
│       ├── main_screen.dart
│       ├── my_reservation_screen.dart
│       └── menu_screen.dart
│
├── android/
├── ios/
├── web/
├── windows/
├── macos/
├── linux/
│
└── pubspec.yaml
```

---

## 🎯 File Quick Reference

### Models (`lib/models.dart`)
```dart
class MenuItem {        // Product definition
  String id, name, category, meat
  double price
  String description, imageUrl
}

class CartItem {        // Cart item with quantity
  MenuItem menuItem
  int quantity
  double totalPrice  // computed property
}

class Order {          // Order with status
  String id, status
  List<CartItem> items
  String deliveryAddress, paymentMethod
  double totalPrice
  DateTime orderDate, completedDate
}
```

### Screens Quick Access

| Screen | File | Purpose |
|--------|------|---------|
| Menu Grid | `menu_screen.dart` | Browse menu with filter |
| Menu Detail | `menu_detail_screen.dart` | View & select menu |
| Cart | `cart_screen.dart` | Review & manage cart |
| Checkout | `checkout_screen.dart` | Payment & confirmation |
| Order Status | `order_status_screen.dart` | Track orders |
| Profile | `profile_screen.dart` | View & manage profile |

---

## 🔄 Navigation Flow Chart

```
LoginScreen
    ↓
MainScreen (Bottom Nav)
├── MenuScreen [Index 0]
│   └── MenuDetailScreen → CartScreen → CheckoutScreen
├── MyReservationScreen [Index 1]
├── HomeScreen [Index 2]
│   └── ProfileScreen
│       └── OrderStatusScreen
│       └── EditProfileScreen
│       └── FeedbackScreen
│       └── LoginScreen (Logout)
└── MyReservationScreen [Index 3]
```

---

## 🎨 Color System

```dart
// Primary Color (Burnt Orange)
AppColors.primary = Color(0xFFE65100)
Usage: CTA buttons, highlights, badges

// Secondary Color (Charcoal)
AppColors.secondary = Color(0xFF212121)
Usage: Text, headings, dark elements

// Background (Off-white)
AppColors.background = Color(0xFFFAFAFA)
Usage: Screen background, cards

// Surface (White)
AppColors.surface = Colors.white
Usage: Cards, surfaces, overlays

// Error (Red)
AppColors.error = Color(0xFFB00020)
Usage: Destructive actions, cancel buttons
```

---

## 🔧 Component Cheat Sheet

### Buttons

```dart
// Primary (Orange)
ElevatedButton(
  onPressed: () {},
  style: AppStyles.primaryButtonStyle,
  child: Text('Action'),
)

// Secondary (Outlined)
OutlinedButton(
  onPressed: () {},
  child: Text('Cancel'),
)

// With Icon
ElevatedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.add),
  label: Text('Add'),
)
```

### Cards

```dart
Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: // content
  ),
)
```

### Form Fields

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Label',
    prefixIcon: Icon(Icons.icon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Required';
    return null;
  },
)
```

### Grid Layout

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: isMobile ? 2 : 3,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 0.75,
  ),
  itemBuilder: (context, index) => // item widget
)
```

---

## 📱 Responsive Design Pattern

```dart
final isMobile = MediaQuery.of(context).size.width < 600;

// Usage in GridView
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: isMobile ? 2 : 3,
  ),
)

// Usage in Padding
padding: EdgeInsets.all(isMobile ? 16 : 24),
```

---

## 🔄 State Management Patterns

### StatefulWidget with setState

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  List<CartItem> items = [];
  
  void _updateCart() {
    setState(() {
      items.add(newItem);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // rebuild on setState
  }
}
```

### Passing Data Between Screens

```dart
// Send data with arguments
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(item: selectedItem),
  ),
);

// Receive data back
final result = await Navigator.push(...);
if (result != null) {
  setState(() {
    // Update with returned data
  });
}
```

---

## 💾 Data Flow Patterns

### Menu Browsing
```
MenuScreen (List<MenuItem>)
    ↓ [Select]
MenuDetailScreen (MenuItem)
    ↓ [Add to Cart]
CartScreen (List<CartItem>)
```

### Checkout Flow
```
CartScreen (cartItems, totalPrice)
    ↓ [Checkout]
CheckoutScreen (cartItems, totalPrice)
    ↓ [Confirm]
OrderStatusScreen (Order)
```

---

## 🎯 Common Tasks

### Add New Menu
1. Update `allMenuItems` list di `menu_screen.dart`
2. Add new `MenuItem` object dengan proper ID

### Change Colors
1. Edit `constants.dart` - `AppColors` class
2. All screens automatically update

### Add New Screen
1. Create `new_screen.dart` in `lib/`
2. Add import to navigation screen
3. Add route in `Navigator.push()`

### Update Responsive Breakpoint
1. Change breakpoint value: `MediaQuery.of(context).size.width < 600`
2. Adjust grid columns accordingly
3. Test on multiple devices

---

## 🐛 Debugging Tips

### Check Console Output
```bash
# Run with debug logging
flutter run -v

# Analyze for issues
dart analyze lib/
```

### Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| "Target of URI doesn't exist" | Check import path, file must exist |
| "Build failed" | Run `flutter clean` then `flutter pub get` |
| "Layout overflow" | Add `Expanded` or `Flexible` widgets |
| "State not updating" | Call `setState()` after data change |
| "Navigation error" | Check `mounted` before using `context` |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0      # Typography
  flutter_svg: ^2.0.9       # SVG support
  cupertino_icons: ^1.0.8   # iOS icons

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0       # Lint rules
```

---

## 🚀 Build & Deploy

### Development
```bash
flutter run
flutter run -d <device-id>
```

### Testing
```bash
flutter test
dart analyze lib/
```

### Build APK (Android)
```bash
flutter build apk
flutter build apk --release
```

### Build iOS
```bash
flutter build ios
```

### Build Web
```bash
flutter build web
```

---

## 📝 Code Style Guide

### Naming Conventions
```dart
// Classes: PascalCase
class MenuDetailScreen { }

// Variables: camelCase
String menuName;
bool _isVisible;  // private with underscore

// Constants: camelCase
const primaryColor = Color(0xFFE65100);

// Methods: camelCase
void updateCart() { }
```

### Formatting
```dart
// Use 2-space indentation
// Max 80 characters per line (wrap long lines)
// Add blank line between methods
// Add comments for complex logic
```

---

## 🔐 Security Best Practices

✅ **Do:**
- ✓ Validate user input
- ✓ Use https for API calls
- ✓ Hash passwords (backend)
- ✓ Sanitize user data
- ✓ Use environment variables for secrets

❌ **Don't:**
- ✗ Hardcode API keys
- ✗ Store sensitive data in plaintext
- ✗ Log sensitive information
- ✗ Use deprecated methods
- ✗ Ignore SSL certificate errors

---

## 📊 Performance Tips

1. **Lazy Loading**: Use `ListView.builder` instead of `ListView`
2. **Image Optimization**: Cache images, use appropriate sizes
3. **State Management**: Use Provider for complex apps
4. **Avoid Rebuilds**: Use `const` widgets where possible
5. **Async Operations**: Use `async/await` properly with error handling

---

## 🎓 Learning Resources

- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design](https://material.io/design)
- [Flutter UI Patterns](https://flutterdesignpatterns.com)

---

## 📞 Support & Contribution

For bugs or feature requests:
1. Check existing issues
2. Open new issue with details
3. Submit PR with changes

---

**Last Updated**: December 11, 2025  
**Version**: 1.0.0  
**Status**: Production Ready ✅
