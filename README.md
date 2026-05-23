<div align="center">

# 🧩 Bavix ERP

### Flutter Mobile ERP System · ERPNext · Firebase AI · BLoC

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase_AI-Gemini-FFCA28?logo=firebase&logoColor=black)
![ERPNext](https://img.shields.io/badge/Backend-ERPNext%20%2F%20Frappe-0089FF)
![Status](https://img.shields.io/badge/Status-Active%20Development-yellow)
![License](https://img.shields.io/badge/License-Private-red)

**A premium, enterprise-grade Flutter mobile client for ERPNext — with an AI-powered ERP copilot built in.**

</div>

---

## 💡 Why Bavix ERP?

Most ERP systems are desktop-first and complex to navigate on mobile. **Bavix ERP** bridges that gap:

- 📱 **Mobile-first ERP** — full ERPNext workflow from your phone
- 🤖 **AI-powered** — create sales orders, search items, and navigate ERP data through natural language
- 🌐 **Bilingual** — full Arabic 🇸🇦 and English 🇬🇧 support with runtime switching
- 🛡️ **Role-aware** — each user sees exactly what they are permitted to see
- 🎨 **Premium UI** — dark/light themes, glassmorphism, smooth animations

---

## 📖 Overview

Bavix ERP is a **Flutter mobile application** that connects to a **Frappe / ERPNext** backend over a secure REST API. It supports multiple user roles — Admin, Sales, HR, Customer, and Employee — each with a tailored home screen and permission model.

The centerpiece feature is **Bavix AI**, a conversational ERP copilot powered by **Google Gemini via Firebase AI**. Users can type or speak natural-language commands in Arabic or English to create sales orders, look up customers and items, and navigate ERP screens — all without touching a single form field.

> ⚠️ This project is **actively under development**. New modules and features are added continuously.

---

## ✨ Key Features

- 🔐 Session-based authentication with ERPNext (cookie auth + CSRF protection)
- 🛡️ Role-Based Access Control with granular `AppPermissionModel` per role
- 📋 Access request & admin approval workflow
- 🤖 **Bavix AI** — conversational ERP copilot (Google Gemini, Arabic + English)
- 🗣️ Voice input via Speech-to-Text
- 📦 Full Sales pipeline — Orders → Delivery Notes → Invoices
- 🏪 Inventory management — Items, Stock Entries, Warehouses
- 👥 Customer management — list, create, customer portal
- 👔 HR module — Employees, Attendance, Leave Requests, Payroll, Salary Slips
- 🔍 Global search across ERPNext doctypes
- 🌗 Dark / Light theme with persistent user preference
- 🌐 Full bilingual UI — English & Arabic, runtime switching
- 📱 Responsive layout with breakpoint helpers (mobile / tablet / desktop)
- 💾 Persistent session across app restarts
- 🎨 Premium UI — glassmorphism, `flutter_animate`, Lottie, Rive

---

## 📦 Modules

### 🔐 Authentication & Permissions

- Email + Password login backed by ERPNext session cookies
- Auto-login on app restart with session validation
- Onboarding screen (shown once on first launch)
- Role extraction from Frappe user profile (roles + role profiles)
- Automatic mapping to app roles: **Admin**, **Sales**, **HR**, **Customer**, **Employee**
- Fine-grained permission model controlling module visibility per role
- Access request submission for new users awaiting admin approval
- Admin screen to review and approve pending access requests
- Customer self-registration
- Secure logout with full cookie and local storage cleanup

| Role | Admin Hub | Sales | HR | Inventory | Customer Portal |
|---|:---:|:---:|:---:|:---:|:---:|
| Admin | ✅ | ✅ | ✅ | ✅ | ✅ |
| Sales | — | ✅ | — | ✅ | — |
| HR | — | — | ✅ | — | — |
| Customer | — | — | — | — | ✅ |
| Employee | — | ✅ | — | — | — |

---

### 📦 Sales Module

- Sales Orders — list, details, create (manual form + AI voice)
- Create Delivery Note directly from a Sales Order
- Create Sales Invoice directly from a Sales Order
- Sales Invoices — list, details, printable view
- Delivery Notes — list, details
- Pull-to-refresh and paginated loading throughout

---

### 🏪 Inventory Module

- Items list with search and filtering
- Item details with stock information
- Create new Items
- Inventory Dashboard with KPI cards and charts (`fl_chart`)
- Stock Entries list and creation
- Warehouse listing and lookup

---

### 👥 Customer Module

- Customer directory list
- Create new Customers
- Role-specific Customer home portal

---

### 👔 HR Module

Full HR workflow implemented. Some advanced sub-features are scaffolded and marked as coming in the next version.

- Employee directory and create employee form
- Attendance records and manual attendance entry
- Leave Requests — list and create
- Payroll Entries — list, details, create
- Salary Slip detail view

> Some HR sub-modules display a **"Coming Soon"** sheet — these are prepared for the next ERP version.

---

### 🤖 Bavix AI Assistant

The most distinctive feature of this app. Bavix AI is a conversational ERP copilot powered by **Google Gemini via Firebase AI**.

**How it works:**
1. The user types or speaks a command in Arabic or English.
2. The message is sent to a Gemini model which returns a structured JSON intent.
3. The app validates the intent against live ERPNext data (customers, items).
4. For sales order creation, a **draft preview card** is shown for the user to confirm before submitting.

**Supported AI intents:**
- Create a sales order via natural language
- Search for items by name
- Find customers by name
- Navigate to the Sales Orders list
- Trigger invoice or delivery note creation from an order
- General ERP Q&A (conversational fallback)

**Additional AI features:**
- 🗣️ Voice input (Speech-to-Text toggle)
- 💡 Quick commands bar for common actions
- 💬 Multi-session chat history — create, switch, and delete sessions
- 💾 Persistent local chat memory (stored on-device)
- 🌐 Auto language detection (Arabic / English) for AI responses
- ✨ Animated message bubbles with `flutter_animate`

---

### 🔍 Global Search

- Debounced live search across ERPNext doctypes
- Results navigate directly to the relevant module

---

### 📊 Dashboards

Role-aware home dashboards, each tailored to the user's role:

- **Admin Home** — full ERP overview with KPI summary cards
- **Sales Home** — sales-focused widgets and quick actions
- **HR Home** — HR module hub
- **Customer Home** — customer order portal

---

## 🏛️ Architecture

The project follows **Feature-First Clean Architecture**:

```
feature/
├── data/
│   ├── models/    ← Dart data classes (Freezed / manual)
│   ├── remote/    ← API services (Dio HTTP calls to ERPNext)
│   ├── local/     ← Local storage (SharedPreferences, SecureStorage)
│   └── repo/      ← Repository — single source of truth
├── logic/
│   └── cubit/     ← Bloc/Cubit state management
└── presentation/
    ├── screens/   ← Full-page UI
    └── widgets/   ← Modular, reusable UI components
```

**Core layer** (`lib/core/`) is shared across all features:

| Module | Responsibility |
|---|---|
| `di/` | Manual Dependency Injection (`InjectionContainer`) |
| `network/` | `DioFactory` — HTTP client, persistent cookie session, CSRF interceptor |
| `theme/` | `ThemeCubit`, light & dark theme builders, persisted preference |
| `language/` | `LanguageCubit`, locale persistence |
| `constants/` | Design system — `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppGradients` |
| `widgets/` | `PremiumWidgets`, navigation components, `AiChatMemory`, responsive layout |
| `helpers/` | `AppNavigator` (global key), `AppToast` (smart error message cleaning) |

**State Management:** Flutter BLoC / Cubit pattern  
**Dependency Injection:** Manual `InjectionContainer` with static singletons (no external DI package)

---

## 📁 Folder Structure

```
erp_sales/
├── lib/
│   ├── main.dart                    ← Entry point — DI init, Firebase init, theme/locale bootstrap
│   ├── home_screen.dart             ← General navigation hub
│   ├── firebase_options.dart        ← Generated Firebase config (do not commit secrets)
│   ├── l10n/                        ← ARB files + generated localizations
│   │   ├── app_en.arb
│   │   ├── app_ar.arb
│   │   └── app_localizations.dart
│   ├── core/
│   │   ├── constants/               ← Design tokens (colors, typography, spacing…)
│   │   ├── di/                      ← InjectionContainer
│   │   ├── helpers/                 ← AppNavigator, AppToast
│   │   ├── language/                ← LanguageCubit + local storage
│   │   ├── network/                 ← DioFactory (cookie + CSRF handling)
│   │   ├── theme/                   ← ThemeCubit + theme builders
│   │   ├── animations/              ← Shared animation utilities
│   │   └── widgets/                 ← Shared premium widgets
│   └── features/
│       ├── ai_assistant/            ← Bavix AI (Gemini + Firebase AI)
│       ├── auth/                    ← Login, onboarding, roles, permissions
│       ├── customers/               ← Customer list + create
│       ├── dashboard/               ← Role-specific dashboards
│       ├── hr/                      ← HR — employees, attendance, leaves, payroll
│       ├── items/                   ← Inventory — items, stock entries, warehouses
│       ├── sales_orders/            ← Sales orders, invoices, delivery notes
│       └── search/                  ← Global ERPNext search
├── assets/
│   ├── Icons/                       ← SVG icon assets
│   └── lottie/                      ← Lottie animation files
├── .env                             ← Local environment variables (never commit)
├── firebase.json
├── pubspec.yaml
└── ARCHITECTURE.md
```

---

## 🛠️ Tech Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter · Dart SDK `^3.10.8` |
| **State Management** | `flutter_bloc` ^9.1.1 (Cubit pattern) |
| **HTTP Client** | `dio` ^5.9.2 |
| **Session Management** | `dio_cookie_manager` + `cookie_jar` (persistent cookies) |
| **AI / LLM** | `firebase_ai` ^3.12.1 (Google Gemini via Firebase) |
| **Firebase** | `firebase_core` ^4.9.0 |
| **Local Storage** | `flutter_secure_storage` · `shared_preferences` |
| **Serialization** | `freezed_annotation` · `json_serializable` · `build_runner` |
| **Animations** | `flutter_animate` · `lottie` · `rive` |
| **Localization** | `flutter_localizations` · ARB (EN + AR) |
| **Charts** | `fl_chart` |
| **Fonts** | `google_fonts` |
| **Images** | `cached_network_image` |
| **Pull-to-Refresh** | `pull_to_refresh` |
| **Skeleton Loading** | `shimmer` |
| **Voice Input** | `speech_to_text` |
| **Notifications** | `fluttertoast` |
| **Env Variables** | `flutter_dotenv` |
| **App Icons** | `flutter_launcher_icons` |
| **Device Preview** | `device_preview` _(development only)_ |

---

## 🚀 Setup Instructions

### Prerequisites

- Flutter SDK `^3.10.8`
- Android Studio or VS Code with the Flutter extension
- An active Firebase project with Firebase AI (Google AI) enabled
- Access to a Frappe / ERPNext backend instance

### Steps

```bash
# 1. Clone the repository
git clone <repo-url>
cd erp_sales

# 2. Install dependencies
flutter pub get

# 3. Set up your environment file
cp .env.example .env
# Edit .env — see Environment Variables section

# 4. Configure Firebase
# Install flutterfire CLI if needed:
dart pub global activate flutterfire_cli
# Then run:
flutterfire configure
# This generates lib/firebase_options.dart

# 5. Run code generation (Freezed + JSON serializable)
dart run build_runner build --delete-conflicting-outputs

# 6. Run the app
flutter run
```

> **Note:** `device_preview` is enabled in `main.dart` for development convenience. Set `enabled: false` or remove it before building a production release.

---

## 🔥 Firebase Setup Notes

1. Create a project in the [Firebase Console](https://console.firebase.google.com).
2. Enable **Firebase AI Logic** — select the Google AI (Gemini) provider.
3. Run `flutterfire configure` to generate `lib/firebase_options.dart`.
4. Add `google-services.json` to `android/app/`.
5. Add `GoogleService-Info.plist` to `ios/Runner/`.
6. Ensure your Firebase project has **billing enabled** — the Gemini API requires a billing account.

> This app uses Firebase **only** for the Gemini AI model. Firestore, Firebase Auth, and Analytics are not used.

---

## 🔒 Security Notes

- All authentication is handled via ERPNext's built-in session mechanism (HTTP-only cookies).
- CSRF tokens are automatically captured and forwarded on every mutating request.
- The Firebase config file (`firebase_options.dart`) contains only public project identifiers — no service account keys.
- No user credentials are stored in plaintext. Session state is managed via secure cookie persistence.

---

## 🔭 Future Improvements

- 🔔 Push notifications via Firebase Cloud Messaging
- 📴 Offline mode with local cache and background sync
- 📊 Admin KPI dashboard with real-time live charts
- 🖨️ PDF export and print for invoices and salary slips
- 🎤 Full voice-to-order flow (speak → AI draft → confirm → submit)
- 📷 Barcode / QR scanner for fast item lookup
- 🏭 Warehouse transfer workflow completion
- 🧑‍💼 Full HR self-service employee portal
- 🌍 Multi-company / multi-branch support
- ✅ Unit and integration test coverage
- 🚀 CI/CD pipeline via GitHub Actions

---

## 👨‍💻 Developer

| | |
|---|---|
| **Developer** | Ahmed Gad Al-Jamal |
| **GitHub** | [@AhmedAljamal15](https://github.com/AhmedAljamal15) |
| **Project** | Bavix ERP — Flutter Mobile ERP Client |
| **Status** | 🟡 Actively Under Development |
| **Backend** | Frappe / ERPNext |
| **AI** | Google Gemini via Firebase AI |

---

<div align="center">

**Built with ❤️ using Flutter · ERPNext · Firebase AI**

</div>
