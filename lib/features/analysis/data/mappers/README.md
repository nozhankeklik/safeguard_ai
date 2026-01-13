# Data Mappers

This directory contains mapper classes for converting between Domain entities and Data models.

## Purpose

Mappers follow the Clean Architecture principle by isolating data transformation logic between layers:
- **Domain Entities** → **Data Models** (for persistence/API)
- **Data Models** → **Domain Entities** (for business logic)

## Usage

Mappers ensure type safety and maintain separation of concerns between Data and Domain layers.

## Example

```dart
// Entity to Model
final model = ReportMapper.toModel(entity);

// Model to Entity
final entity = ReportMapper.toEntity(model);
```

## Note

Mapper pattern is used to keep domain entities pure and independent from data layer implementations.
