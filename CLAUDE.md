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
│   ├── constants/         # App-wide constants (spacing, sizes, timeouts)
│   ├── theme/             # Design system (colors, typography, theme)
│   └── widgets/           # Reusable UI components
├── features/              # Feature modules
│   ├── auth/              # Authentication (phone + PIN login)
│   ├── home/              # Dashboard
│   ├── profile/           # User profile
│   ├── services/          # Insurance services (8 sub-features)
│   ├── emergency/         # Emergency services
│   ├── benefits/          # Plan benefits
│   └── notifications/     # Notification center
└── shared/                # Cross-feature shared code
    ├── navigation/        # GoRouter configuration (app_router.dart)
    ├── widgets/           # Shell widgets (main_shell.dart)
    ├── models/            # Data models (to be implemented)
    ├── providers/         # State management (to be implemented)
    └── services/          # API/business services (to be implemented)
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
- Main (with bottom nav shell): `/home`, `/services`, `/activity`, `/profile`
- Services: `/telemedicine`, `/pharmacy`, `/appointments`, `/directory`, `/exams`, `/reimbursements`, `/authorizations`, `/claims`
- Other: `/emergency`, `/benefits`, `/notifications`

## Reusable Components

Located in `core/widgets/`:
- `CustomButton` - Multi-type button (primary, secondary, outline, text, emergency)
- `CustomCard`, `ServiceCard`, `InfoCard` - Card variants
- `EmergencyButton` - Emergency action button
- `LoadingOverlay` - Loading state overlay
- `StatusBadge` - Status indicators

Import all via `core/widgets/widgets.dart` barrel file.

## Design System Constants

Located in `core/constants/app_constants.dart`:
- Spacing: `AppSpacing.xs` (12), `AppSpacing.sm` (16), `AppSpacing.md` (24), etc.
- Border radius: `AppRadius.sm` (8), `AppRadius.md` (12), `AppRadius.lg` (16)
- Icon sizes: `AppIconSize.sm` (16), `AppIconSize.md` (24), `AppIconSize.lg` (32)
