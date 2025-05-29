# Core Module

This module contains the core functionality and shared components used throughout the app.

## Structure

- `theme/` - App-wide theming (colors, text styles, etc.)
- `widgets/` - Reusable widgets
  - `base/` - Base widget classes
  - `shared/` - Shared UI components

## Key Components

### Theme
- `AppColors` - Color palette and semantic colors
- `AppTextStyles` - Typography system

### Widgets
- `DisposableStatefulWidget` - Base class for widgets that need resource cleanup
- Shimmer Components:
  - `ShimmerWrapper` - Base shimmer effect
  - `ShimmerCard` - Card with shimmer effect
  - `ShimmerList` - List with shimmer effect
  - `ShimmerInput` - Input field with shimmer effect
  - `ShimmerSummary` - Summary card with shimmer effect 