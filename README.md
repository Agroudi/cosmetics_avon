<h1>📱 Cosmetics Avon App</h1>

A modern, scalable cosmetics e-commerce mobile application built with Flutter, delivering a seamless shopping experience with a pixel-perfect UI based on Figma designs.
The app is currently in progress, with a strong focus on clean architecture, performance, and zero-bug implementation standards.

<h1>🚀 Project Setup & Installation Guide</h1>

🔧 Prerequisites

Flutter (latest stable version)
Dart SDK
Android Studio / VS Code
Emulator or physical device

<h1>📥 Installation Steps</h1>

Clone the repository:
git clone https://github.com/your-username/cosmetics_avon.git
Navigate to project directory:
cd cosmetics_avon
Install dependencies:
flutter pub get
Run the app:
flutter run

<h1>🏗️ Architectural Overview</h1>


```text
project_root/
│
├── assets/
│   ├── fonts/             # Custom fonts
│   ├── icons/             # SVG icons
│   ├── images/            # App images & product assets
│   ├── lottie/            # Lottie animations
│   └── translations/      # Localization files (AR / EN)
│
├── lib/
│   ├── core/
│   │   ├── cubit/         # Global cubits (e.g. ThemeCubit)
│   │   ├── helpers/       # Helper classes & utilities
│   │   ├── routing/       # AppRouter & route definitions
│   │   ├── services/      # DioHelper & API config
│   │   ├── theme/         # Colors, text styles, app theme
│   │   └── widgets/       # Global reusable widgets
│   │
│   ├── features/
│   │   ├── auth/          # Authentication & user identity
│   │   │   ├── cubit/        # AuthCubit logic
│   │   │   ├── data/
│   │   │   │   ├── models/   # Data models
│   │   │   │   ├── repo/     # AuthRepo & implementations
│   │   │   │   └── services/ # Auth API services
│   │   │   ├── presentation/ # Auth screens
│   │   │   └── widgets/      # Auth-specific widgets
│   │   │
│   │   ├── boarding/      # Onboarding screens
│   │   │   ├── model/
│   │   │   └── presentation/
│   │   │
│   │   ├── cart/          # Cart system
│   │   │   ├── cubit/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   ├── repo/
│   │   │   │   └── services/
│   │   │   ├── presentation/
│   │   │   └── widgets/
│   │   │
│   │   ├── categories/    # Product categories
│   │   │   ├── cubit/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   ├── repo/
│   │   │   │   └── services/
│   │   │   ├── presentation/
│   │   │   └── widgets/
│   │   │
│   │   ├── checkout/      # Checkout, payment & order placement
│   │   │   ├── cubit/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   └── services/
│   │   │   └── presentation/
│   │   │
│   │   ├── home/          # Home screen content
│   │   │   ├── cubit/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   ├── repo/
│   │   │   │   └── services/
│   │   │   ├── presentation/
│   │   │   └── widgets/
│   │   │
│   │   ├── orders/        # Order history
│   │   │   ├── cubit/
│   │   │   ├── data/
│   │   │   │   └── services/
│   │   │   └── presentation/
│   │   │
│   │   ├── profile/       # User profile
│   │   │   ├── cubit/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   ├── repo/
│   │   │   │   └── services/
│   │   │   ├── presentation/
│   │   │   └── widgets/
│   │   │
│   │   ├── settings/      # App settings
│   │   │   └── presentation/
│   │   │
│   │   ├── splash/        # Splash screen & initial logic
│   │   │   └── presentaion/
│   │   │
│   │   └── vouchers/      # Vouchers & discount codes
│   │       └── presentation/
│   │
│   ├── gen/               # Generated code (assets, fonts, locale keys)
│   │
│   ├── cosmetics_app.dart # Root app widget (MaterialApp & routing)
│   └── main.dart          # App entry point (DI & bootstrapping)
```

<h1>⚙️ Features</h1>

<h2>🔐 Authentication System</h2>

Login (Phone / Email + Password)
Register new account
Forgot password flow
OTP Verification (Email & SMS)
Reset password

<h2>🌍 Multi-language Support</h2>

Arabic 🇪🇬 (RTL)
English 🇺🇸 (LTR)
Powered by EasyLocalization

<h2>💄 E-commerce Functionality (Cosmetics)</h2>

Browse products (OnProgress)
View product details (OnProgress)
Categories system (OnProgress)
Shopping cart (OnProgress)

<h2>💾 Token Management</h2>

Secure token storage using SharedPreferences
Persistent login support

<h2>🎯 Clean Architecture</h2>

Separation of concerns (Cubit / Repo / API Services)
SOLID principles applied
Scalable & maintainable structure

<h2>⚡ UI/UX Excellence</h2>

Pixel-perfect implementation based on Figma
Zero bugs policy (UI & logic aligned with design)
Fully responsive using ScreenUtil
Smooth user experience and navigation

<h1>🧠 State & Data Management</h1>

<h2>🔄 State Management</h2>

Flutter Bloc (Cubit)
Handles all states: Loading / Success / Error

<h2>🌐 API Handling</h2>

Dio for REST API integration
Advanced error handling (status codes + server messages)

<h2>💾 Local Storage</h2>

SharedPreferences
Stores authentication token for persistent sessions

<h1>🧩 Key Widgets Used</h1>

TextFormField → User input handling
BlocListener → Navigation & side effects
BlocBuilder → UI state updates
AppButton → Custom reusable button
ListView → Product & list rendering
Navigator / AppRouter → Clean navigation system
SVG Icons → Scalable UI assets

<h1>📦 Dependencies</h1>

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc:
  dio:
  shared_preferences:
  easy_localization:
  flutter_screenutil:
  flutter_svg:
  lottie:
  flutter_animate:
  toastification:
  connectivity_plus:
  image_picker:
  pin_code_fields:
  intl_phone_field:

<h1>🎨 UI/UX</h1>

Clean and modern design
Fully responsive across devices
RTL / LTR supported
Consistent spacing & typography
Smooth transitions and user flow

<h1>📌 Notes</h1>

Authentication system is fully functional with API integration
OTP system supports both Email & Phone verification
Token is securely stored for auto-login
The project is currently under active development (On Progress)
Built with a zero-bugs mindset and strict adherence to Figma design
