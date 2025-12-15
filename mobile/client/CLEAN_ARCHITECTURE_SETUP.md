# Clean Architecture Setup Guide

This document explains the Clean Architecture implementation for the OurRide Flutter app with BLoC pattern.

## 📁 Project Structure

```
lib/
├── core/                          # Core functionality shared across features
│   ├── constants/                 # App-wide constants
│   ├── errors/                    # Error handling
│   │   ├── exceptions.dart       # Custom exceptions
│   │   └── failures.dart         # Failure classes for Either pattern
│   ├── usecases/                  # Base use case interfaces
│   │   └── usecase.dart
│   ├── network/                   # Network layer
│   │   ├── api_client.dart       # HTTP client wrapper
│   │   └── network_info.dart     # Connectivity checker
│   ├── utils/                     # Utility functions
│   └── theme/                     # App theme
│
├── config/                        # App configuration
│   ├── router/                   # Navigation/routing
│   ├── injections/               # Dependency injection
│   │   └── injection_container.dart
│   ├── localization/             # i18n
│   └── environment.dart          # Environment variables
│
├── features/                      # Feature modules
│   └── auth/                     # Authentication feature
│       ├── domain/               # Business logic layer
│       │   ├── entities/        # Business objects
│       │   │   ├── user.dart
│       │   │   └── auth_response.dart
│       │   ├── repositories/    # Repository interfaces
│       │   │   └── auth_repository.dart
│       │   └── usecases/        # Business use cases
│       │       ├── send_otp.dart
│       │       ├── verify_otp.dart
│       │       ├── social_login.dart
│       │       ├── complete_profile.dart
│       │       └── check_phone.dart
│       │
│       ├── data/                # Data layer
│       │   ├── models/         # Data models (JSON serializable)
│       │   │   ├── user_model.dart
│       │   │   └── auth_response_model.dart
│       │   ├── datasource/     # Data sources
│       │   │   ├── auth_remote_data_source.dart
│       │   │   └── auth_local_data_source.dart
│       │   └── repositories_impl/  # Repository implementations
│       │       └── auth_repository_impl.dart
│       │
│       └── presentation/       # UI layer
│           ├── pages/          # Screen widgets
│           │   ├── signup_page.dart
│           │   ├── signin_page.dart
│           │   ├── otp_page.dart
│           │   └── profile_completion_page.dart
│           ├── widgets/        # Reusable widgets
│           └── bloc/           # State management
│               ├── auth_bloc.dart
│               ├── auth_event.dart
│               └── auth_state.dart
│
├── common/                      # Shared widgets/components
│   ├── widgets/
│   ├── extensions/
│   └── animations/
│
└── main.dart                    # App entry point
```

## 🏗️ Architecture Layers

### 1. **Domain Layer** (Business Logic)
- **Entities**: Pure Dart classes representing business objects
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Single-purpose business logic operations

### 2. **Data Layer** (Data Management)
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: 
  - Remote: API calls
  - Local: SharedPreferences, SQLite, etc.
- **Repository Implementation**: Implements domain repository interface

### 3. **Presentation Layer** (UI)
- **Pages**: Screen widgets
- **Widgets**: Reusable UI components
- **BLoC**: State management (Events → States)

## 🔄 Data Flow

```
UI (Widget) 
  ↓ (dispatches event)
BLoC (AuthBloc)
  ↓ (calls use case)
Use Case (VerifyOtp)
  ↓ (calls repository)
Repository (AuthRepositoryImpl)
  ↓ (calls data source)
Data Source (AuthRemoteDataSource)
  ↓ (makes HTTP request)
API Client (ApiClient)
  ↓ (returns response)
Data Source → Repository → Use Case → BLoC → UI
```

## 📦 Dependencies

### Required Packages
- `flutter_bloc`: State management
- `equatable`: Value equality
- `dartz`: Functional programming (Either type)
- `dio`: HTTP client
- `get_it`: Dependency injection
- `shared_preferences`: Local storage
- `connectivity_plus`: Network connectivity
- `json_annotation`: JSON serialization

### Dev Dependencies
- `build_runner`: Code generation
- `json_serializable`: JSON code generation
- `injectable_generator`: DI code generation

## 🚀 Setup Instructions

### 1. Install Dependencies
```bash
cd mobile/client
flutter pub get
```

### 2. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Update Environment
Edit `lib/config/environment.dart` to set your backend URL:
```dart
static const String baseUrl = 'http://your-backend-url:8080';
```

### 4. Initialize DI in main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
```

## 📝 Usage Example

### Using BLoC in a Widget

```dart
BlocProvider(
  create: (context) => sl<AuthBloc>(),
  child: BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthSuccess) {
        // Navigate to next screen
      } else if (state is AuthError) {
        // Show error
      }
    },
    builder: (context, state) {
      if (state is AuthLoading) {
        return CircularProgressIndicator();
      }
      return YourWidget();
    },
  ),
)
```

### Dispatching Events

```dart
context.read<AuthBloc>().add(
  SendOtpEvent(
    phoneNumber: '1234567890',
    countryCode: '+1',
  ),
);
```

## 🔌 Backend Integration

The app integrates with the Spring Boot backend at:
- Base URL: `http://localhost:8080/api`
- Endpoints:
  - `POST /auth/send-otp`
  - `POST /auth/resend-otp`
  - `POST /auth/verify-otp`
  - `POST /auth/social-login`
  - `POST /auth/complete-profile`
  - `POST /auth/refresh-token`
  - `GET /auth/check-phone`

## ✅ Next Steps

1. **Complete UI Implementation**: Copy UI code from original screens to new BLoC-based pages
2. **Add Error Handling**: Implement user-friendly error messages
3. **Add Loading States**: Show loading indicators during API calls
4. **Token Management**: Implement automatic token refresh
5. **Offline Support**: Add caching for offline functionality
6. **Testing**: Add unit and integration tests

## 🐛 Troubleshooting

### Issue: Code generation errors
**Solution**: Run `flutter pub run build_runner clean` then `flutter pub run build_runner build`

### Issue: Dependency injection errors
**Solution**: Ensure `init()` is called before `runApp()` in `main.dart`

### Issue: Network errors
**Solution**: Check `environment.dart` has correct backend URL and backend is running

## 📚 Resources

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Dartz Package](https://pub.dev/packages/dartz)

