# 🧩 Bavix ERP — Flutter Mobile ERP System

> **⚠️ This project is actively under development. New features and modules are added continuously.**

A professional, enterprise-grade Flutter mobile application connected to a live **ERPNext / Frappe** backend. Bavix ERP enables role-based sales management, HR operations, inventory control, and AI-powered ERP automation — all from a premium, dark-capable mobile interface.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Screenshots](#-screenshots)
- [Features](#-features)
- [Modules](#-modules)
  - [Authentication & Permissions](#-authentication--permissions)
  - [Sales Module](#-sales-module)
  - [Inventory Module](#-inventory-module)
  - [Customer Module](#-customer-module)
  - [HR Module](#-hr-module)
  - [Bavix AI Assistant](#-bavix-ai-assistant)
  - [Global Search](#-global-search)
  - [Dashboard](#-dashboard)
- [Architecture](#-architecture)
- [Folder Structure](#-folder-structure)
- [Tech Stack](#-tech-stack)
- [ERPNext Integration](#-erpnext-integration)
- [Firebase & AI Integration](#-firebase--ai-integration)
- [Localization & Theming](#-localization--theming)
- [Setup Instructions](#-setup-instructions)
- [Environment Variables](#-environment-variables)
- [Firebase Setup Notes](#-firebase-setup-notes)
- [Future Improvements](#-future-improvements)
- [Developer](#-developer)

---

## 🌐 Overview

**Bavix ERP** is a Flutter mobile client for ERPNext-powered businesses. The app communicates with a live Frappe Cloud instance (`bavix.k.frappe.cloud`) using session-cookie-based authentication and the Frappe REST API.

The app supports multiple **user roles** (Admin, Sales, HR, Customer, Employee), each with its own tailored home screen, navigation, and permission set. A standout feature is **Bavix AI** — a built-in AI assistant powered by **Google Gemini via Firebase AI** — that understands natural language commands in both Arabic and English and can create sales orders, search items, and navigate ERP data hands-free.

---

## 📸 Screenshots

> _Screenshots will be added here. Use the placeholders below to add images after your captures._

| Splash / Onboarding | Login | Admin Dashboard |
|---|---|---|
| ![Splash](screenshots/splash.png) | ![Login](screenshots/login.png) | ![Admin Dashboard](screenshots/admin_home.png) |

| Sales Orders | Inventory Dashboard | Bavix AI Chat |
|---|---|---|
| ![Sales Orders](screenshots/sales_orders.png) | ![Inventory](screenshots/inventory.png) | ![AI Assistant](screenshots/ai_assistant.png) |

| HR Module | Customer Home | Profile |
|---|---|---|
| ![HR](screenshots/hr_home.png) | ![Customer](screenshots/customer_home.png) | ![Profile](screenshots/profile.png) |

---

## ✅ Features

### Implemented

- 🔐 Session-based authentication with ERPNext (Frappe cookie auth + CSRF handling)
- 🛡️ Role-Based Access Control (Admin, Sales, HR, Customer, Employee)
- 📋 Access request & admin approval workflow
- 🧑‍💼 Role-specific home screens (Admin, Sales, HR, Customer)
- 📦 Sales Orders — list, details, create delivery notes, create sales invoices
- 🧾 Sales Invoices — list, details, print view
- 🚚 Delivery Notes — list, details
- 🏪 Items / Inventory — list, details, create items, stock entries, warehouse management
- 👥 Customers — list, create
- 👔 HR — Employees, Attendance, Leave Requests, Payroll, Salary Slips
- 🤖 Bavix AI Assistant — conversational ERP copilot (Gemini via Firebase AI)
- 🔍 Global Search across ERPNext doctypes
- 🌗 Dark / Light theme with persistent preference
- 🌐 Full bilingual support — English 🇬🇧 & Arabic 🇸🇦 (RTL-aware)
- 🔔 Smart toast notifications with cleaned, user-friendly error messages
- 📱 Responsive layout system with breakpoint helpers
- 💾 Persistent cookie-based session (Dio + PersistCookieJar)
- 🎨 Premium UI — glassmorphism, animations (`flutter_animate`), Lottie, Rive

### In Progress / Partially Implemented

- 📊 Admin dashboard analytics (KPI cards scaffolded, live ERPNext data charts in progress)
- 🕐 HR — some sub-modules (payroll creation, some attendance workflows) show a "coming soon" bottom sheet
- 🏭 Warehouse transfer flows (partial)
- 🗓️ HR self-service portal for employees

---

## 📦 Modules

### 🔐 Authentication & Permissions

The auth module handles the complete identity lifecycle:

| Feature | Status |
|---|---|
| Email + Password login (ERPNext session cookie) | ✅ Done |
| Session persistence (SharedPreferences + SecureStorage) | ✅ Done |
| Onboarding screen (shown once on first launch) | ✅ Done |
| Splash screen with auto-login check | ✅ Done |
| Role extraction from Frappe user doc (roles + role_profiles) | ✅ Done |
| App role mapping (Admin / Sales / HR / Customer / Employee) | ✅ Done |
| Permission model (`AppPermissionModel`) per role | ✅ Done |
| Access request submission (new user signup flow) | ✅ Done |
| Admin access-request approval screen | ✅ Done |
| Customer self-registration | ✅ Done |
| Logout with cookie + local storage cleanup | ✅ Done |

**Roles and their access:**

| Role | Admin Dashboard | Sales | HR | Inventory | Customer Portal |
|---|---|---|---|---|---|
| Admin | ✅ | ✅ | ✅ | ✅ | ✅ |
| Sales | ❌ | ✅ | ❌ | ✅ | ❌ |
| HR | ❌ | ❌ | ✅ | ❌ | ❌ |
| Customer | ❌ | ❌ | ❌ | ❌ | ✅ |
| Employee | ❌ | ✅ | ❌ | ❌ | ❌ |

---

### 📦 Sales Module

Connected to the ERPNext Sales Order, Delivery Note, and Sales Invoice doctypes.

| Feature | Status |
|---|---|
| Sales Orders list (paginated, pull-to-refresh) | ✅ Done |
| Sales Order details | ✅ Done |
| Create Delivery Note from Sales Order | ✅ Done |
| Create Sales Invoice from Sales Order | ✅ Done |
| Sales Invoices list | ✅ Done |
| Sales Invoice details | ✅ Done |
| Sales Invoice printable view | ✅ Done |
| Delivery Notes list | ✅ Done |
| Delivery Note details | ✅ Done |
| Create Sales Order (manual form) | ✅ Done |
| Create Sales Order via AI natural language | ✅ Done |

---

### 🏪 Inventory Module

| Feature | Status |
|---|---|
| Items list | ✅ Done |
| Item details | ✅ Done |
| Create new Item | ✅ Done |
| Inventory Dashboard (KPI cards, charts) | ✅ Done |
| Stock Entries list | ✅ Done |
| Create Stock Entry | ✅ Done |
| Warehouse list & lookup | ✅ Done |

---

### 👥 Customer Module

| Feature | Status |
|---|---|
| Customers list | ✅ Done |
| Create Customer | ✅ Done |
| Customer home portal (role-specific view) | ✅ Done |

---

### 👔 HR Module

The HR module is partially implemented. Screens with full data binding are marked ✅; screens that show a "coming soon" sheet for sub-features not yet wired are marked 🚧.

| Feature | Status |
|---|---|
| HR Home Screen (module hub) | ✅ Done |
| Employees list | ✅ Done |
| Create Employee form | ✅ Done |
| Attendance list | ✅ Done |
| Create Attendance | ✅ Done |
| Leave Requests list | ✅ Done |
| Create Leave Request | ✅ Done |
| Payroll list | ✅ Done |
| Payroll Entry details | ✅ Done |
| Create Payroll Entry | ✅ Done |
| Salary Slip details | ✅ Done |
| HR sub-module placeholders ("coming soon") | 🚧 In Progress |

---

### 🤖 Bavix AI Assistant

The AI assistant is a first-class ERP copilot powered by **Google Gemini** via **Firebase AI (`firebase_ai`)**.

| Feature | Status |
|---|---|
| Natural language chat (Arabic + English) | ✅ Done |
| Create Sales Orders via conversational input | ✅ Done |
| Draft preview card (confirm before submitting) | ✅ Done |
| Customer lookup & fuzzy suggestion | ✅ Done |
| Item lookup & fuzzy suggestion | ✅ Done |
| Search items by name via chat | ✅ Done |
| Find customers via chat | ✅ Done |
| Navigate to Sales Orders list via chat | ✅ Done |
| Trigger invoice / delivery note creation | ✅ Done |
| Voice input (Speech-to-Text) | ✅ Done |
| Quick commands bar | ✅ Done |
| Multi-session chat history (create, switch, delete) | ✅ Done |
| Persistent local chat memory (JSON on-device) | ✅ Done |
| Scroll-to-bottom floating button | ✅ Done |
| Animated message bubbles (`flutter_animate`) | ✅ Done |
| Arabic-aware auto-language detection | ✅ Done |

**How Bavix AI works:**

1. User types or speaks a message in any language.
2. The prompt is sent to `Gemini 3.1 Flash Lite` via Firebase AI.
3. Gemini returns a structured JSON describing the ERP action to take (e.g. `create_sales_order`, `search_item`, `find_customer`).
4. The app validates, resolves entities against live ERPNext data, and either:
   - Shows a confirmation draft (for sales orders), or
   - Replies with a direct answer / navigation action.

---

### 🔍 Global Search

| Feature | Status |
|---|---|
| Search across ERPNext doctypes | ✅ Done |
| Debounced live search | ✅ Done |

---

### 📊 Dashboard

Role-aware home dashboards:

| Dashboard | Status |
|---|---|
| Admin Home (full ERP overview, KPIs) | ✅ Done |
| Sales Home (sales-focused widgets) | ✅ Done |
| HR Home (HR module hub) | ✅ Done |
| Customer Home (customer portal) | ✅ Done |
| General Home (legacy entry point) | ✅ Done |

---

## 🏛️ Architecture

The app follows **Feature-First Clean Architecture** with a clear separation of concerns:

```
Feature
├── data/
│   ├── models/       ← Dart data classes (Freezed/manual)
│   ├── remote/       ← API services (Dio HTTP calls)
│   ├── local/        ← Local storage (SharedPreferences, SecureStorage)
│   └── repo/         ← Repository pattern (single source of truth)
├── logic/
│   └── cubit/        ← Bloc/Cubit state management
└── presentation/
    ├── screens/      ← Full page UI
    └── widgets/      ← Modular, reusable UI components
```

**Core layer** (`lib/core/`) is shared across all features:

| Core Module | Purpose |
|---|---|
| `di/` | Manual Dependency Injection (`InjectionContainer`) |
| `network/` | `DioFactory` — HTTP client, cookie manager, CSRF interceptor |
| `theme/` | `ThemeCubit`, `buildLightTheme()`, `buildDarkTheme()`, persistent preference |
| `language/` | `LanguageCubit`, persistent locale preference |
| `constants/` | `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppGradients`, `AppDuration` |
| `widgets/` | `PremiumWidgets`, `PremiumNavigation`, `AiChatMemory`, `ResponsiveLayout` |
| `helpers/` | `AppNavigator` (global key), `AppToast` (smart error cleaning) |
| `animations/` | Shared animation utilities |

**State Management:** Flutter BLoC / Cubit

**Dependency Injection:** Manual DI via `InjectionContainer` (static singletons, no `get_it`)

---

## 📁 Folder Structure

```
erp_sales/
├── lib/
│   ├── main.dart                    ← App entry point, DI init, Firebase init
│   ├── home_screen.dart             ← General home (legacy)
│   ├── firebase_options.dart        ← Generated Firebase config
│   ├── l10n/                        ← ARB translation files + generated localizations
│   │   ├── app_en.arb
│   │   ├── app_ar.arb
│   │   └── app_localizations.dart (+ _en, _ar)
│   ├── core/
│   │   ├── animations/
│   │   ├── constants/               ← AppColors, AppTypography, AppSpacing...
│   │   ├── di/                      ← InjectionContainer
│   │   ├── helpers/                 ← AppNavigator, AppToast
│   │   ├── language/                ← LanguageCubit + local storage
│   │   ├── network/                 ← DioFactory (cookie + CSRF)
│   │   ├── theme/                   ← ThemeCubit + buildTheme
│   │   └── widgets/                 ← PremiumWidgets, AiChatMemory, Navigation
│   └── features/
│       ├── ai_assistant/            ← Bavix AI (Gemini + Firebase AI)
│       ├── auth/                    ← Login, register, splash, roles, permissions
│       ├── customers/               ← Customer list + create
│       ├── dashboard/               ← Role dashboards
│       ├── hr/                      ← HR employees, attendance, leaves, payroll
│       ├── items/                   ← Inventory, stock entries, warehouses
│       ├── sales_orders/            ← Sales orders, invoices, delivery notes
│       └── search/                  ← Global ERPNext search
├── assets/
│   ├── Icons/                       ← SVG icons
│   └── lottie/                      ← Lottie animation files
├── .env                             ← Local env variables (not committed)
├── firebase.json
├── pubspec.yaml
└── ARCHITECTURE.md
```

---

## 🛠️ Tech Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter (Dart SDK `^3.10.8`) |
| **State Management** | `flutter_bloc` ^9.1.1 (Cubit pattern) |
| **HTTP Client** | `dio` ^5.9.2 |
| **Session Management** | `dio_cookie_manager` + `cookie_jar` (persistent cookies) |
| **AI / LLM** | `firebase_ai` ^3.12.1 (Google Gemini via Firebase) |
| **Firebase** | `firebase_core` ^4.9.0 |
| **Local Storage** | `flutter_secure_storage`, `shared_preferences` |
| **Serialization** | `freezed_annotation`, `json_serializable`, `build_runner` |
| **Animations** | `flutter_animate`, `lottie`, `rive` |
| **Localization** | `flutter_localizations` + ARB (EN + AR) |
| **Charts** | `fl_chart` |
| **Fonts** | `google_fonts` |
| **Images** | `cached_network_image` |
| **Pull-to-Refresh** | `pull_to_refresh` |
| **Skeleton Loading** | `shimmer` |
| **Voice Input** | `speech_to_text` |
| **Toast** | `fluttertoast` |
| **Dotted Border** | `dotted_border` |
| **Responsive** | `sizer` |
| **UUID** | `uuid` |
| **Env Vars** | `flutter_dotenv` |
| **App Icons** | `flutter_launcher_icons` |
| **Device Preview** | `device_preview` (development only) |

---

## 🌐 ERPNext Integration

The app integrates with a **Frappe / ERPNext** instance hosted on Frappe Cloud.

**Base URL:** `https://bavix.k.frappe.cloud`

**Authentication mechanism:**
- Standard Frappe login endpoint (`/api/method/login`)
- Session cookie (`sid`) persisted via `PersistCookieJar`
- CSRF token captured from response headers and forwarded on every mutating request (`X-Frappe-CSRF-Token`)

**Key API patterns used:**

| Pattern | Usage |
|---|---|
| `GET /api/resource/{DocType}` | List documents (sales orders, items, customers...) |
| `GET /api/resource/{DocType}/{name}` | Fetch single document |
| `POST /api/resource/{DocType}` | Create new document |
| `POST /api/method/frappe.client.get_list` | Advanced filtered list queries |
| `GET /api/method/frappe.auth.get_logged_user` | Verify active session |
| `GET /api/resource/User/{email}` | Fetch user profile + roles |
| `POST /api/method/logout` | Invalidate session |

**Doctypes integrated:**

- `Sales Order`, `Sales Invoice`, `Delivery Note`
- `Item`, `Warehouse`, `Stock Entry`
- `Customer`
- `Employee`, `Attendance`, `Leave Request`, `Payroll Entry`, `Salary Slip`
- `User` (for roles & access management)

---

## 🔥 Firebase & AI Integration

### Firebase Setup

The app uses Firebase for AI features only (not Firestore or Auth).

- **Project config:** `lib/firebase_options.dart` (generated via `flutterfire configure`)
- **Initialization:** `Firebase.initializeApp()` called in `main()` before `runApp()`

### Bavix AI (Firebase AI + Google Gemini)

| Detail | Value |
|---|---|
| Package | `firebase_ai` ^3.12.1 |
| Provider | `FirebaseAI.googleAI()` |
| Model | `gemini-3.1-flash-lite` |
| Mode | Text generation (structured JSON output) |
| Languages | Arabic + English (auto-detected) |

The AI does **not** store any data on Firebase. All conversation history is persisted locally on the device using JSON file storage via `path_provider`.

---

## 🌐 Localization & Theming

### Localization

| Detail | Value |
|---|---|
| Supported Languages | English (`en`), Arabic (`ar`) |
| RTL Support | Yes (Flutter handles RTL for Arabic) |
| ARB Files | `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb` |
| Generated class | `AppLocalizations` |
| Switching | `LanguageCubit` + `SharedPreferences` (persists across sessions) |
| Bulk ARB tool | `localize_bulk.ps1` (PowerShell helper for batch key insertion) |

### Theming

| Detail | Value |
|---|---|
| Modes | Light + Dark |
| Switching | `ThemeCubit` + `SharedPreferences` |
| Color System | `AppColors` (neon blue / deep dark palette) |
| Typography | `AppTypography` (8 text scales, headline → caption) |
| Spacing | `AppSpacing` (xs → xxxl, 8px base unit) |
| Radius | `AppRadius` (xs → full) |
| Shadows | `AppElevation` (sm → glass) |
| Gradients | `AppGradients` (primary, neon header, success, error...) |
| Responsive | `AppBreakpoints` (mobile 480 / tablet 768 / desktop 1024 / wide 1440) |

---

## 🚀 Setup Instructions

### Prerequisites

- Flutter SDK `^3.10.8`
- Dart SDK compatible with above
- Android Studio or VS Code with Flutter extension
- Active Firebase project with Firebase AI (Vertex AI / Google AI) enabled
- Access to the ERPNext / Frappe backend

### Steps

```bash
# 1. Clone the repository
git clone <repo-url>
cd erp_sales

# 2. Install dependencies
flutter pub get

# 3. Create your .env file (see Environment Variables section)
cp .env.example .env
# Edit .env with your values

# 4. Generate Firebase config (if not already done)
# Install flutterfire CLI if needed:
dart pub global activate flutterfire_cli
flutterfire configure

# 5. Run code generation (Freezed + JSON serializable)
dart run build_runner build --delete-conflicting-outputs

# 6. Run the app
flutter run
```

> **Note:** `device_preview` is enabled in `main.dart` for development purposes. Disable it before building a release.

---

## 🔐 Environment Variables

Create a `.env` file in the project root. The app loads it via `flutter_dotenv`.

```env
# ERPNext base URL (already hardcoded in DioFactory, override here if needed)
ERP_BASE_URL=https://bavix.k.frappe.cloud

# Add any additional API keys your build requires
```

> The `.env` file is in `.gitignore` and must never be committed to version control.

---

## 🔥 Firebase Setup Notes

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com).
2. Enable **Firebase AI Logic** (Vertex AI / Google AI Studio) in your Firebase project.
3. Run `flutterfire configure` to generate `lib/firebase_options.dart`.
4. Add `google-services.json` (Android) to `android/app/`.
5. Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`.
6. Ensure your Firebase project has billing enabled (Gemini API requires a billing account).

> The app only uses Firebase for the Gemini AI model. Firestore, Firebase Auth, and Analytics are **not** used.

---

## 🔭 Future Improvements

| Feature | Priority |
|---|---|
| Full HR self-service employee portal | High |
| Push notifications (Firebase Messaging) | High |
| Offline mode with local cache & sync | Medium |
| Admin KPI dashboard with real-time charts | Medium |
| PDF export / print for invoices & slips | Medium |
| AI voice-to-order full flow (speak → confirm → submit) | Medium |
| Multi-company / multi-branch support | Low |
| Barcode / QR scanner for item lookup | Low |
| Attendance face-recognition (AI camera) | Low |
| Warehouse transfer workflow | Low |
| Unit & integration testing | High |
| CI/CD pipeline (GitHub Actions) | Medium |

---

## 👨‍💻 Developer

| Field | Value |
|---|---|
| **Developer** | Ahmed Al-Jamal |
| **GitHub** | [@AhmedAljamal15](https://github.com/AhmedAljamal15) |
| **Project** | Bavix ERP — Flutter ERP Mobile Client |
| **Status** | 🟡 Active Development |
| **Backend** | ERPNext / Frappe Cloud (`bavix.k.frappe.cloud`) |
| **AI** | Google Gemini via Firebase AI |

---

<div align="center">

**Built with ❤️ using Flutter + ERPNext + Firebase AI**

</div>
