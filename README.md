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

project_root/
│
├── assets/
│   ├── images/            # App images & product assets
│   ├── icons/             # SVG icons
│   ├── fonts/             # Custom fonts
│   └── translations/      # Localization files (AR / EN)
│
├── lib/
│   ├── core/
│   │   ├── routing/       # AppRouter & route management
│   │   ├── theme/         # Colors, text styles
│   │   ├── widgets/       # Global reusable widgets
│   │   └── services/      # DioHelper & API config
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── cubit/     # AuthCubit (Login, Register, OTP, Reset)
│   │   │   ├── data/
│   │   │   │   ├── repo/  # AuthRepo & implementation
│   │   │   │   ├── services/ # API services
│   │   │   │   └── local/ # Local storage (token)
│   │   │   └── presentation/ # Auth screens UI
│   │   │
│   │   ├── home/          # Home screen (OnProgress)
│   │   ├── product/       # Product details & listing (OnProgress)
│   │   ├── cart/          # Cart system (OnProgress)
│   │   ├── categories/    # Categories browsing (OnProgress)
│   │   ├── profile/       # User profile (Planned)
│   │   └── layout/        # Bottom Navigation Bar (OnProgress)
│   │
│   └── main.dart          # App entry point

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
