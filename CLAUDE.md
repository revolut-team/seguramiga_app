# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SeguroApp is a Flutter mobile application for insurance and health services management (MVP). Built with Flutter SDK ^3.10.1 using Dart.

## Build & Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on specific device
flutter run -d <device_id>

# Static analysis
flutter analyze

# Run tests
flutter test

# Run single test file
flutter test test/widget_test.dart

# Build for platforms
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

## Architecture

**Feature-First Structure** - Each feature is self-contained with its own screens and widgets:

```
lib/
├── main.dart              # App entry point
├── core/                  # Core utilities
│   ├── constants/         # App-wide constants (spacing, sizes, timeouts, Venezuela data)
│   ├── theme/             # Design system (colors, typography, theme)
│   └── widgets/           # Reusable UI components (10 widgets)
├── features/              # Feature modules
│   ├── auth/              # Authentication (phone + PIN login)
│   ├── home/              # Dashboard with insurance card, services grid
│   ├── profile/           # User profile with plan info
│   ├── registration/      # User registration & payment flow
│   │   ├── screens/       # 7 screens (4 registration + 3 payment)
│   │   └── widgets/       # Form widgets (progress, document, date picker, plan cards)
│   ├── insurance/         # Insurance details & QR scanning
│   │   └── screens/       # Insurance details, QR scanner, scan result
│   ├── services/          # Insurance services (8 sub-features + pharmacy payment)
│   ├── emergency/         # Emergency services
│   ├── benefits/          # Plan benefits
│   └── notifications/     # Notification center
└── shared/                # Cross-feature shared code
    ├── navigation/        # GoRouter configuration (app_router.dart)
    ├── widgets/           # Shell widgets (main_shell.dart)
    ├── models/            # Data models (insurance, registration, payment, user)
    └── services/          # Business services (qr_service.dart)
```

## Key Technical Decisions

- **Navigation**: GoRouter v13 with named routes and ShellRoute for bottom navigation
- **State Management**: Provider package installed but not yet integrated (StatefulWidget currently used)
- **Design System**: Material 3 with custom theme in `core/theme/`
  - Primary color: Dark Blue (#1A365D)
  - Fonts: Poppins (headings), Inter (body)
- **Authentication**: Phone-based login with PIN verification, biometric auth available via `local_auth`

## Navigation Routes

Routes defined in `shared/navigation/app_router.dart`:
- Auth: `/login`, `/pin`, `/recover-pin` (no shell)
- Registration: `/register/personal`, `/register/contact`, `/register/address`, `/register/pin-setup` (no shell)
- Payment: `/plan-selection`, `/payment-checkout`, `/payment-success` (no shell)
- Main (with bottom nav shell): `/home`, `/services`, `/activity`, `/profile`
- Services: `/telemedicine`, `/pharmacy`, `/appointments`, `/directory`, `/exams`, `/reimbursements`, `/authorizations`, `/claims`
- Pharmacy Payment: `/pharmacy/payment-methods`, `/pharmacy/payment-process`, `/pharmacy/payment-success`
- Insurance: `/insurance-details`, `/qr-scanner`, `/qr-result`
- Profile Screens: `/plan-details`, `/personal-data`, `/dependents`, `/history`, `/payment-methods`, `/digital-card`, `/certificates`, `/notification-settings`, `/security-settings`, `/support`, `/privacy`
- Other: `/emergency`, `/benefits`, `/notifications`

## Reusable Components

Located in `core/widgets/`:
- `CustomButton` - Multi-type button (primary, secondary, outline, text, emergency)
- `CustomCard`, `ServiceCard`, `InfoCard` - Card variants
- `CustomAppBar` - Custom app bar with consistent styling
- `EmergencyButton` - Emergency action button
- `LoadingOverlay` - Loading state overlay
- `StatusBadge` - Status indicators
- `QuickActionButton` - Quick action buttons for home screen
- `SectionHeader` - Section headers with title and optional action

Located in `features/registration/widgets/`:
- `ProgressIndicator` - Multi-step form progress indicator
- `DocumentInputField` - Venezuelan ID document input
- `DatePickerField` - Date picker with age validation
- `FormFieldWrapper` - Consistent form field styling
- `CoverageItem` - Insurance coverage item display
- `PlanComparisonCard` - Plan comparison card with features

Import core widgets via `core/widgets/widgets.dart` barrel file.

## Design System Constants

Located in `core/constants/app_constants.dart`:
- Spacing: `AppConstants.spacingXs` (12), `AppConstants.spacingSm` (16), `AppConstants.spacingMd` (24), `AppConstants.spacingLg` (32), `AppConstants.spacingXl` (40), `AppConstants.spacingXxl` (48)
- Border radius: `AppConstants.radiusSm` (8), `AppConstants.radiusMd` (12), `AppConstants.radiusLg` (16)
- Icon sizes: `AppConstants.iconSm` (16), `AppConstants.iconMd` (24), `AppConstants.iconLg` (32)

Located in `core/constants/venezuela_data.dart`:
- `VenezuelaStates.states` - List of 24 Venezuelan states
- `VenezuelaPhoneCodes.mobileCodes` - Mobile operator codes (0412, 0414, 0416, 0424, 0426)
- `VenezuelaPhoneCodes.landlineCodes` - Landline area codes (0212, 0241, 0243, etc.)

## Current Project Status

### ✅ Completed Features

**Registration Flow:**
- Personal information screen with document validation
- Contact information screen with phone/email validation
- Address information screen with Venezuelan states
- PIN setup screen with security validation
- Progress indicator widget for multi-step forms
- Document input field for Venezuelan IDs
- Date picker field with age validation

**Payment Flow:**
- Plan selection screen with 3 plans (Básico, Estándar, Premium)
- Payment checkout screen with plan summary and terms
- Payment success screen with order confirmation
- Coverage item widget
- Plan comparison card widget
- All payment routes integrated in app_router.dart

**Insurance Feature:**
- Insurance details screen
- QR scanner screen (using mobile_scanner)
- QR scan result screen
- QR service for code generation/parsing

**Pharmacy Feature:**
- Pharmacy screen with medication catalog
- Payment methods selection screen
- Payment process screen
- Payment success screen

**Models:**
- `InsurancePlan` - Insurance plan data structure
- `RegistrationData` - User registration data model
- `PaymentDetails` - Payment transaction model
- `UserInsuranceModel` - User's active insurance data

**Profile Screens (stub implementations):**
- Plan details, Personal data, Dependents, History
- Payment methods, Digital card, Certificates
- Notification settings, Security settings, Support, Privacy

### 🚧 Pending / Future Work

- Provider state management integration
- Backend API integration
- Complete profile screen implementations (currently stubs)
- Push notifications
- Biometric authentication integration

## Common Patterns & Best Practices

### Widget Lifecycle Management

**IMPORTANT:** Always protect state updates during navigation and disposal:

```dart
// Check mounted before setState
if (mounted) {
  setState(() {
    // state updates
  });
}

// Use navigation flag to prevent updates during navigation
bool _isNavigating = false;

// Set flag before navigation
setState(() {
  _isNavigating = true;
});

// Check flag in callbacks
onChanged: (value) {
  if (mounted && !_isNavigating) {
    setState(() {
      // safe to update
    });
  }
}

// Safe disposal with try-catch
@override
void dispose() {
  try {
    _controller.dispose();
  } catch (e) {
    // Ignore disposal errors
  }
  super.dispose();
}
```

### Form Validation

- Use `GlobalKey<FormState>` with `Form` widget
- Validate in real-time with `onChanged` for better UX
- Use `TextFormField` with `validator` parameter
- Clear errors when user starts typing

### Navigation Best Practices

- Use `context.push()` for forward navigation
- Use `context.go()` for replacing entire stack
- Use `context.pushReplacement()` to replace current route
- Pass data between screens using `extra` parameter
- Always check `mounted` before navigating in async functions

### Asset Management

**SVG Images:**
- Use `flutter_svg` package for SVG rendering
- Store SVGs in `assets/images/`
- If SVG doesn't render correctly (colors missing), create a clean version without complex filters
- Example: `logo_horizontal_clean.svg` was created to fix color rendering issues

## Known Issues & Solutions

### Issue: TextEditingController disposed error
**Problem:** `FlutterError (A TextEditingController was used after being disposed)`

**Solution:**
1. Add `_isNavigating` flag to track navigation state
2. Disable input fields when navigating: `enabled: !_isNavigating`
3. Clear controllers before navigation: `_controller.clear()`
4. Check `mounted && !_isNavigating` in all callbacks
5. Wrap dispose() in try-catch blocks

**Example:** See `lib/features/registration/screens/pin_setup_screen.dart:38-52` and `:117-128`

### Issue: SVG not showing colors
**Problem:** Complex SVG filters may not render correctly in Flutter

**Solution:**
- Create a simplified version without filter effects
- Remove `<filter>` and `<feOffset>` tags
- Keep only basic color definitions in `<style>`
- Example: `assets/images/logo_horizontal_clean.svg`

## Venezuelan-Specific Features

The app includes Venezuela-specific constants and validations:

- **States:** 24 states + Distrito Capital
- **Phone codes:** Mobile (0412, 0414, 0416, 0424, 0426) and landline codes
- **Document types:** V (Venezuelan), E (Foreign), J (Legal entity), P (Passport)
- **Currency:** Bolívares (Bs.) with USD conversion mock

## Dependencies

Key packages used:
- `go_router: ^13.0.0` - Navigation
- `provider: ^6.1.1` - State management (installed, not yet integrated)
- `flutter_svg: ^2.0.9` - SVG rendering
- `local_auth: ^2.1.8` - Biometric authentication
- `pin_code_fields: ^8.0.1` - PIN input UI
- `intl: ^0.19.0` - Internationalization
- `qr_flutter: ^4.1.0` - QR code generation
- `share_plus: ^7.2.2` - Share functionality
- `mobile_scanner: ^3.5.5` - QR code scanning
- `google_fonts: ^6.1.0` - Custom fonts (Poppins, Inter)
- `flutter_animate: ^4.3.0` - Animations
- `cached_network_image: ^3.3.1` - Image caching
- `shimmer: ^3.0.0` - Loading shimmer effects
- `percent_indicator: ^4.2.3` - Progress indicators
- `url_launcher: ^6.2.2` - External URL launching
- `image_picker: ^1.0.7` - Image selection

## Project Documentation

For more details on implementation plans and progress:
- **PLAN.md** - Detailed implementation plan with current status and next steps
- **CLAUDE.md** - This file, general project guidance for Claude Code
