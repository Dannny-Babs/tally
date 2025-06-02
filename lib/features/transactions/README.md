# Transactions Feature

This module handles all transaction-related functionality, including expenses and income tracking.

## Structure

- `bloc/` - Business Logic Components
  - `transaction_bloc.dart` - Main transaction management
  - `category_bloc.dart` - Category management
  - `transaction_model.dart` - Transaction data model
- `views/` - UI Components
  - `expense_screen.dart` - Expense tracking screen
  - `income_screen.dart` - Income tracking screen
  - `add_expense_screen.dart` - Add expense form
  - `add_income_screen.dart` - Add income form
  - `widgets/` - Feature-specific widgets
- `widgets/` - Shared widgets
  - `activity_card.dart` - Transaction list item
  - `category_card.dart` - Category display
  - `date_filter_widget.dart` - Date range filter
  - `empty_state_placeholder.dart` - Empty state UI
  - `error_screen.dart` - Error state UI
  - `labeled_input.dart` - Form input with label
  - `top_categories_widget.dart` - Category summary

## Key Features

- Track expenses and income
- Categorize transactions
- Filter by date range
- View transaction history
- Category-based analytics
- Empty and error states
- Loading states with shimmer effects

## Phase A Fixes

### Completed
- Fixed import paths using barrel files
- Added proper controller disposal
- Added documentation for public widgets
- Added TODOs for future phases
- Fixed undefined names and types
- Added error handling placeholders

### Pending
- Extract large files into smaller widgets (Phase C)
- Move business logic to BLoC (Phase D)
- Implement proper error handling (Phase E)
- Add shimmer loading states (Phase B)
- Create shared widgets for duplicate code (Phase C) 