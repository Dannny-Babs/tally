
# Tally — Personal Finance Tracker

**Tally** is a Flutter-based personal finance app designed to help you track income, expenses, savings, gifts/paybacks, and more—complete with rich visualizations, AI-powered insights, and powerful filtering/grouping. Everything is built with a clean, minimal aesthetic, BLoC state management, and sliver-based scrolls for iOS-grade smoothness.

---

## 📌 Key Features

- **Unified Dashboard**  
  - Monthly summary cards: Income • Expenses • Savings  
  - Recent activity feed + “Add more” quick-add modal  
  - AI Insights modal: data-driven summary, trends, suggestions  
- **Income & Expense Tabs**  
  - **Summary**: total + category breakdown  
  - **Custom Stacked Progress Bar** (Expenses)  
  - **Weekly Spending Bar Chart**  
  - **Sticky date-grouped transaction lists** (Today, This Week, Last Week, etc.)  
  - **Infinite scroll** with “Oops, that’s all!” at end  
  - **Date-range filter** (This Month / Last Month / This Year / Custom)  
- **Add-Item Modals**  
  - **Add Income** & **Add Expense** bottom sheets  
  - Rich forms: Amount, Date & Time, Category, Tag, Payment Method, Receipt upload, Notes, Recurrence  
  - Full validation, inline errors, BLoC integration  
- **Categories Management**  
  - Create/edit/delete custom categories  
  - Color-coded swatches, per-category spend totals, drill-down pie charts  
- **Settings & Security**  
  - Profile details: country, salary, student status (for tax)  
  - Notification toggles, data sync/backup, biometric lock  
  - Error & 404 fallback screens  

---

## 🛠️ Installation & Setup

1. **Clone the repo**  
   ```bash
   git clone https://github.com/yourusername/tally.git
   cd tally
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **iOS Setup**

   * Add Info.plist keys in `ios/Runner/Info.plist`:

     ```xml
     <key>NSPhotoLibraryUsageDescription</key>
     <string>We need access to your photos to attach receipts.</string>
     <key>NSCameraUsageDescription</key>
     <string>We need to use your camera for new receipts.</string>
     <key>NSMicrophoneUsageDescription</key>
     <string>We need mic for recording videos.</string>
     ```
   * Test on a real device to avoid HEIC simulator issues on iOS 14+.

4. **Android Setup**

   * No extra manifest changes required (SDK 21+).
   * Ensure you handle lost data by calling `ImagePickerService.retrieveLostData()` in `initState()`.

5. **Run**

   ```bash
   flutter run
   ```

---

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart       # Semantic color palette
│   │   ├── app_text_styles.dart  # Space Grotesk/Mono text themes
│   │   └── app_theme.dart        # Material ThemeData
│   ├── widgets/
│   │   ├── activity_card.dart
│   │   ├── labeled_input.dart
│   │   ├── custom_tab_bar.dart
│   │   ├── empty_state_placeholder.dart
│   │   ├── error_screen.dart
│   │   └── platform_back_button.dart
│   └── services/
│       └── image_picker_service.dart
├── features/
│   ├── dashboard/
│   │   ├── views/
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── income_screen_refactored.dart
│   │   │   └── expense_screen_refactored.dart
│   │   ├── widgets/
│   │   │   ├── date_filter_widget.dart
│   │   │   ├── transaction_groups.dart
│   │   │   ├── add_options_modal.dart
│   │   │   └── insight_modal.dart
│   │   └── bloc/
│   │       ├── transaction_bloc.dart
│   │       ├── transaction_event.dart
│   │       └── transaction_state.dart
│   ├── transactions/
│   │   ├── views/
│   │   │   ├── income_screen.dart
│   │   │   ├── add_income_modal.dart
│   │   │   ├── expense_screen.dart
│   │   │   └── add_expense_modal.dart
│   │   ├── bloc/
│   │   │   ├── category_bloc.dart
│   │   │   ├── category_event.dart
│   │   │   ├── category_state.dart
│   │   │   └── transaction_bloc.dart  (see above)
│   │   └── repositories/             # Supabase / local storage stubs
│   ├── savings/
│   ├── paybacks/
│   ├── gifting/
│   ├── stats/
│   └── settings/
│       ├── views/settings_screen.dart
│       └── widgets/profile_card.dart ...
└── main.dart
```

---

## 🚀 Usage Guide

1. **Navigate Tabs**

   * **🏠 Home**: overview, quick-add, AI insights
   * **➕ Add**: opens Add-Options modal
   * **⚙️ Settings**: profile, sync, notifications

2. **Add Transactions**

   * Tap “+ Add” or “+ Add Income/Expense” in tabs
   * Fill required fields, attach receipt if any, and Save

3. **Filter & Group**

   * Use the dropdown/segmented control on Income/Expense tabs to change date range
   * Scroll through grouped sections—headers stick as you scroll

4. **Manage Categories**

   * In Expenses tab, tap “Manage Categories” to add/edit/delete
   * Colors auto-apply to charts and bars

5. **View Insights**

   * On Home, tap AI-bubble icon to see summary modal
   * Follow actionable suggestions or open full Stats page

---

## 🔧 Testing & QA

* **Unit Tests**: add `bloc_test` cases for `TransactionBloc` and `CategoryBloc`.
* **Widget Tests**: pump screens and verify placeholder, empty, error states.
* **Manual QA**: run on iOS and Android, test keyboard insets, sliver stickiness, image picking, infinite scroll.

---

## 📜 Changelog

* **v1.0.0** – Initial release with Dashboard, Income, Expense, Add-modals, AI insights.
* **v1.1.0** – Sliver refactor, date-range filter, sticky headers, stacked progress bar.
* **v1.2.0** – Category management, image picker service, lost-data handling.

---

## 🤝 Contributing

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/YourFeature`
3. Commit your changes: `git commit -m "feat: Add YourFeature"`
4. Push to the branch: `git push origin feature/YourFeature`
5. Open a Pull Request

Please follow our [contribution guidelines](./CONTRIBUTING.md) and code style.

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).

---

*Happy budgeting! 💰*
