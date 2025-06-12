# Tally — Personal Finance Tracker

**Tally** is a Flutter-based personal finance app designed to help you track income, expenses, savings, and more. Built with a clean, minimal aesthetic and BLoC state management, it offers a smooth, native-like experience across platforms.

---

## 📌 Current Features

### Core Functionality

- **Local Data Management**
  - Secure local storage using SharedPreferences
  - Efficient data serialization/deserialization
  - Automatic data persistence

### User Profile & Settings

- **Profile Management**
  - Basic profile information (name, email)
  - Financial details (annual salary, tax rate)
  - Regional settings (country, currency)
  - Student status tracking

- **Preferences**
  - Push notification controls
  - Biometric authentication (Face ID)
  - PIN code protection
  - Local data persistence

### Savings Management

- **Savings Accounts**
  - Multiple account support
  - Balance tracking
  - Currency support
  - Account descriptions
  - Local data persistence

---

## 🚧 Planned Features

### Authentication & Cloud Sync

- **Authentication Options**
  - Supabase Authentication
  - Firebase Authentication
  - Email/Password login
  - Social login (Google, Apple)
  - Biometric authentication

- **Cloud Integration**
  - Supabase real-time sync
  - Firebase Firestore sync
  - Automatic conflict resolution
  - Offline support

### Enhanced Financial Tracking

- **Income & Expenses**
  - Transaction categorization
  - Receipt attachment
  - Recurring transactions
  - Payment method tracking
  - Date-based filtering

- **Visual Analytics**
  - Monthly summaries
  - Category breakdowns
  - Spending trends
  - Custom date ranges
  - Export capabilities

### Advanced Features

- **AI-Powered Insights**
  - Spending pattern analysis
  - Budget recommendations
  - Anomaly detection
  - Smart categorization

- **Gift & Payback Tracking**
  - Gift tracking
  - Debt management
  - Payment reminders
  - Settlement tracking

---

## 🛠️ Technical Implementation

### Architecture

```
lib/
├── core/
│   ├── repositories/
│   │   └── base_repository.dart      # Base storage implementation
│   ├── theme/
│   │   ├── app_colors.dart          # Color system
│   │   ├── app_text_styles.dart     # Typography
│   │   └── app_theme.dart           # Theme configuration
│   └── widgets/                     # Shared UI components
├── features/
│   ├── settings/
│   │   ├── repositories/
│   │   │   ├── profile_repository.dart
│   │   │   ├── preferences_repository.dart
│   │   │   └── accounts_repository.dart
│   │   ├── bloc/
│   │   │   └── accounts/
│   │   │       └── accounts_state.dart
│   │   └── views/
│   │       └── settings_screen.dart
│   └── [other feature modules]
└── main.dart
```

### Data Models

- **Profile**

  ```dart
  class Profile {
    final String name;
    final String email;
    final double? annualSalary;
    final double? taxRate;
    final String? country;
    final String? currency;
    final bool? studentStatus;
  }
  ```

- **SavingsAccount**

  ```dart
  class SavingsAccount {
    final String id;
    final String name;
    final double balance;
    final String currency;
    final String? description;
  }
  ```

### Storage Implementation

- **Local Storage**
  - SharedPreferences for small data
  - Efficient serialization
  - Automatic persistence
  - Type-safe access

- **Future Cloud Options**
  - Supabase
    - Real-time subscriptions
    - Row Level Security
    - PostgreSQL database
  - Firebase
    - Firestore collections
    - Security rules
    - Offline persistence

---

## 🚀 Getting Started

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/tally.git
   cd tally
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the App**

   ```bash
   flutter run
   ```

---

## 🔧 Development Setup

### Local Development

1. **Environment Setup**
   - Flutter SDK (latest stable)
   - Dart SDK (latest stable)
   - Android Studio / VS Code
   - iOS development tools (for iOS)

2. **Code Style**
   - Follow Flutter style guide
   - Use BLoC pattern for state management
   - Implement repository pattern for data access
   - Write unit tests for business logic

### Future Cloud Setup

1. **Supabase Setup**

   ```bash
   # Add to pubspec.yaml
   supabase_flutter: ^2.0.0
   ```

2. **Firebase Setup**

   ```bash
   # Add to pubspec.yaml
   firebase_core: ^2.0.0
   firebase_auth: ^4.0.0
   cloud_firestore: ^4.0.0
   ```

---

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

### Development Guidelines

- Follow the existing architecture
- Write tests for new features
- Update documentation
- Use meaningful commit messages

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🔮 Roadmap

### Phase 1: Core Features (Current)

- ✅ Local data management
- ✅ Basic profile management
- ✅ Savings account tracking
- ✅ User preferences

### Phase 2: Authentication & Sync

- 🔄 Authentication implementation
- 🔄 Cloud data sync
- 🔄 Offline support
- 🔄 Data migration

### Phase 3: Enhanced Features

- 📅 Transaction management
- 📅 Category system
- 📅 Analytics & insights
- 📅 Export functionality

### Phase 4: Advanced Features

- 📅 AI integration
- 📅 Gift tracking
- 📅 Budget planning
- 📅 Multi-device sync

---

*Happy coding! 🚀*
