# 💰 Smart Expense Tracker

<div align="center">

<img width="551" height="905" alt="1 tracker" src="https://github.com/user-attachments/assets/3d64a51d-a390-435b-b429-11ef815c9d84" />


**A modern, feature-rich expense tracking application built with Flutter & Supabase**

[Features](#-features) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack) • [Architecture](#-architecture) • [Getting Started](#-getting-started)

</div>

---

## 📖 Overview

Smart Expense Tracker is a full-stack mobile application that helps users manage their finances with ease. Built using Clean Architecture principles and modern Flutter best practices, it provides real-time expense tracking, visual analytics, and cloud synchronization across devices.

### 🎯 Key Highlights

- ✅ **Production-Ready Code** - Clean Architecture with complete separation of concerns
- ✅ **Real-time Synchronization** - Powered by Supabase for instant data updates
- ✅ **Advanced State Management** - BLoC pattern for predictable state handling
- ✅ **Beautiful UI/UX** - Material Design 3 with smooth animations
- ✅ **Secure Authentication** - Email/password authentication with Row Level Security
- ✅ **Visual Analytics** - Interactive charts and spending insights

---

## ✨ Features

### 🔐 Authentication
- Secure user registration and login
- Email/password authentication via Supabase Auth
- Persistent sessions with automatic token refresh
- Password reset functionality

### 💸 Expense Management
- ➕ Add, edit, and delete expenses
- 🏷️ Categorize expenses (Food, Transport, Shopping, etc.)
- 📅 Date-based expense tracking
- 💵 Multi-currency support
- 🔄 Real-time sync across devices
- 📱 Swipe-to-delete functionality

### 📊 Analytics & Insights
- 📈 Visual spending breakdown by category
- 🥧 Interactive pie charts
- 📉 Spending trends over time
- 🎯 Period-based analysis (Week, Month, Year)
- 💡 Category-wise percentage distribution

### 🎨 User Experience
- 🌓 Dark & Light theme support
- 📱 Responsive design for all screen sizes
- ♿ Accessibility-friendly
- 🎭 Smooth animations and transitions
- 🔔 Success/error notifications
- ⚡ Pull-to-refresh functionality

---

## 📱 Screenshots

<div align="center">

| Login Screen | Home Dashboard | Add Expense |
|:------------:|:--------------:|:-----------:|
| ![Login](<img width="473" height="747" alt="6 tracker" src="https://github.com/user-attachments/assets/502e2f26-96f9-4045-b7d0-827a7a74bc90" />
) | ![Home](<img width="551" height="905" alt="1 tracker" src="https://github.com/user-attachments/assets/9f8323d5-bc11-4fce-aa26-ef28a045e9a2" />
) | ![Add](<img width="587" height="912" alt="3 tracker" src="https://github.com/user-attachments/assets/c746cd4b-39d5-45d7-a9e2-b046e5bd171f" />
) |

| Analytics |
|:---------:|:----------------:|:-------:|
|![Analytics](<img width="562" height="911" alt="2 tracker" src="https://github.com/user-attachments/assets/a1ceb309-6ed5-4873-8eae-88269a85f4d9" />

</div>

> 

---

## 🛠️ Tech Stack

### Frontend
- **Framework:** Flutter 3.5.0
- **Language:** Dart 3.5.0
- **State Management:** flutter_bloc 8.1.6
- **UI Components:** Material Design 3
- **Charts:** fl_chart 0.69.0
- **Fonts:** Google Fonts (Inter)

### Backend
- **BaaS:** Supabase 2.7.0
- **Database:** PostgreSQL (via Supabase)
- **Authentication:** Supabase Auth
- **Real-time:** Supabase Realtime

### Architecture & Patterns
- **Architecture:** Clean Architecture
- **Design Pattern:** BLoC (Business Logic Component)
- **Dependency Injection:** get_it + injectable
- **Data Layer:** Repository Pattern
- **Error Handling:** dartz (Either type)

### Additional Libraries
- `equatable` - Value equality
- `intl` - Internationalization & formatting
- `shared_preferences` - Local storage
- `hive` - NoSQL local database
- `image_picker` - Image selection (receipts)

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a **feature-first** folder structure:

```
lib/
├── core/
│   ├── config/           # App configuration & DI
│   ├── constants/        # App-wide constants
│   ├── error/           # Error handling & failures
│   ├── theme/           # App theming
│   └── utils/           # Utility functions
│
└── features/
    ├── authentication/
    │   ├── data/
    │   │   ├── models/           # Data models
    │   │   └── repositories/     # Repository implementations
    │   ├── domain/
    │   │   ├── entities/         # Business entities
    │   │   └── repositories/     # Repository interfaces
    │   └── presentation/
    │       ├── bloc/             # BLoC state management
    │       └── pages/            # UI screens
    │
    ├── expenses/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/          # Reusable widgets
    │
    └── analytics/
        └── presentation/
```

### Layer Responsibilities

- **Presentation Layer:** UI components, BLoC, user interactions
- **Domain Layer:** Business logic, entities, repository interfaces
- **Data Layer:** API calls, data models, repository implementations

### Data Flow

```
UI → BLoC → Repository → Supabase → Repository → BLoC → UI
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.5.0 or higher)
- Dart SDK (3.5.0 or higher)
- Supabase Account
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/smart-expense-tracker.git
   cd smart-expense-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   
   a. Create a new project at [supabase.com](https://supabase.com)
   
   b. Run the SQL schema (in Supabase SQL Editor):
   ```sql
   -- See database/schema.sql for complete schema
   CREATE TABLE expenses (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
     amount DECIMAL(10,2) NOT NULL,
     category TEXT NOT NULL,
     description TEXT NOT NULL,
     date TIMESTAMP NOT NULL,
     created_at TIMESTAMP DEFAULT NOW()
   );
   
   -- Enable RLS
   ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
   
   -- Create policies (see schema.sql for details)
   ```
   
   c. Get your credentials from **Settings → API**

4. **Configure the app**
   
   Update `lib/main.dart`:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 📊 Database Schema

### Tables

#### `expenses`
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Foreign key to auth.users |
| amount | DECIMAL(10,2) | Expense amount |
| category | TEXT | Expense category |
| description | TEXT | Expense description |
| date | TIMESTAMP | Expense date |
| created_at | TIMESTAMP | Record creation time |

### Row Level Security (RLS)

All tables have RLS enabled with policies ensuring users can only access their own data:

```sql
-- Users can only view their own expenses
CREATE POLICY "Users can view own expenses"
  ON expenses FOR SELECT
  USING (auth.uid() = user_id);
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test
```

### Test Coverage Goals
- Unit Tests: 70%+
- Widget Tests: 60%+
- Integration Tests: Core flows

---

## 📦 Build & Release

### Android
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# App bundle for Play Store
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release

# Create IPA
flutter build ipa
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new features

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Ahmed Talat**

- GitHub: [@AhmedTalat99](https://github.com/AhmedTalat99)
- LinkedIn: [Ahmed Talat](www.linkedin.com/in/ahmed-talat-41243b3bb)
- Email: ahmed99talat@gmail.com

---

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- [Supabase](https://supabase.com) for the backend infrastructure
- [BLoC Library](https://bloclibrary.dev) for state management
- [FL Chart](https://pub.dev/packages/fl_chart) for beautiful charts
- [Google Fonts](https://fonts.google.com) for typography

---

## 🗺️ Roadmap

- [ ] Add receipt photo upload
- [ ] Implement budget limits with notifications
- [ ] Add recurring expense tracking
- [ ] Multi-currency conversion
- [ ] Export data to CSV/PDF
- [ ] Add biometric authentication
- [ ] Widget for home screen
- [ ] Apple Watch companion app
- [ ] Web version
- [ ] Desktop app (Windows/macOS/Linux)

---

## 📧 Contact & Support

If you have any questions or need help, feel free to:

- Open an [issue](https://github.com/yourusername/smart-expense-tracker/issues)
- Email: ahmed99talat@gmail.com
- LinkedIn: [Ahmed Talat](www.linkedin.com/in/ahmed-talat-41243b3bb)

---

<div align="center">

**⭐ Star this repo if you find it helpful!**

Made with ❤️ and Flutter

</div>
