# Core Widgets Library

Reusable widget components following Flutter best practices for code reusability and maintainability.

## Components

### PrimaryButton

Consistent primary button style across the application with loading state support.

### RiskBadge

Risk level indicator with color coding and iconography for visual consistency.

### StatCard

Statistics card widget for displaying numerical data with icons and labels.

### AppLoadingIndicator

Reusable loading indicator with optional message for consistent loading states.

### EmptyStateWidget

Empty state display widget with icon, title, message, and optional action button.

## Usage

```dart
import 'package:safeguard_ai/core/widgets/primary_button.dart';
import 'package:safeguard_ai/core/widgets/risk_badge.dart';
import 'package:safeguard_ai/core/widgets/stat_card.dart';
import 'package:safeguard_ai/core/widgets/loading_indicator.dart';
import 'package:safeguard_ai/core/widgets/empty_state_widget.dart';

// Primary button
PrimaryButton(
  label: 'Submit',
  icon: Icons.send,
  onPressed: () => handleSubmit(),
)

// Risk badge
RiskBadge(riskLevel: 'YÜKSEK')

// Statistics card
StatCard(
  title: 'Total Reports',
  value: '42',
  icon: Icons.description,
)

// Loading indicator
AppLoadingIndicator(message: 'Loading...')

// Empty state
EmptyStateWidget(
  icon: Icons.folder_open,
  title: 'No reports yet',
  message: 'Start by creating your first analysis',
  actionLabel: 'Create Report',
  onAction: () => createReport(),
)
```

## Design Principles

- **Consistency**: All widgets follow the same design system
- **Reusability**: Components can be used across different features
- **Maintainability**: Centralized styling and behavior
