# BLoC Unit Tests

This directory contains unit tests for BLoC components following the bloc_test framework.

## Test Structure

- `analysis_bloc_test.dart` - Tests for AnalysisBloc state transitions
- `history_bloc_test.dart` - Tests for HistoryBloc state management

## Test Strategy

### AnalysisBloc Tests
- Verifies initial state
- Tests successful image analysis flow
- Tests failure scenarios
- Tests reset functionality

### HistoryBloc Tests
- Verifies report loading
- Tests filtering by risk level
- Tests report deletion

## Running Tests

```bash
flutter test test/bloc/
```

## Test Coverage

BLoC tests ensure:
- Correct state transitions
- Event handling
- Error state management
- Business logic validation
