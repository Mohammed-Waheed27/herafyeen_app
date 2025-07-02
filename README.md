# Herafy App - Onboarding Module

This module implements the onboarding experience for the Herafy app, following clean architecture principles and modern Flutter development practices.

## Features

- Three-page onboarding flow with smooth animations
- Responsive design using flutter_screenutil
- State management using flutter_bloc
- Clean architecture implementation
- Modern UI/UX design

## Setup

1. Ensure you have Flutter installed and set up on your development machine
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Create the following directory structure for assets:
   ```
   assets/
   └── images/
       └── onboarding/
           ├── onboarding1.png
           ├── onboarding2.png
           └── onboarding3.png
   ```
5. Run the app using `flutter run`

## Architecture

The module follows clean architecture principles with the following structure:

```
lib/
└── features/
    └── splash_screen_onboarding/
        └── onboarding_screens/
            ├── bloc/
            │   ├── onboarding_bloc.dart
            │   ├── onboarding_event.dart
            │   └── onboarding_state.dart
            ├── models/
            │   └── onboarding_model.dart
            ├── widgets/
            │   └── onboarding_page.dart
            └── onboarding_main.dart
```

## Dependencies

- flutter_bloc: ^8.1.3
- equatable: ^2.0.5
- flutter_screenutil: ^5.9.0

## Contributing

Please follow the existing code style and architecture patterns when contributing to this module.
