# hindu_pay

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



lib/
│
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── router/
│   │   └── app_router.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       └── app_text_styles.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── network/
│   ├── storage/
│   ├── utils/
│   └── widgets/
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── payments/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── pooja/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── pandit/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── donation/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── temple/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── darshan/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── shop/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── cart/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── orders/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── l10n/



final-------------



lib/
│
├── main.dart
│
├── app/
│   ├── router/
│   │   └── app_router.dart
│   │
│   └── theme/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       ├── app_text_styles.dart
│       └── theme_controller.dart
│
├── core/
│   ├── widgets/
│   │   ├── app_button.dart
│   │   │
│   │   └── shimmer/
│   │       ├── app_shimmer.dart
│   │       ├── shimmer_box.dart
│   │       └── product_shimmer.dart
│   │
│   ├── network/
│   ├── errors/
│   ├── storage/
│   └── utils/
│
└── features/
    ├── auth/
    ├── home/
    ├── payments/
    ├── pooja/
    ├── pandit/
    ├── donation/
    ├── temple/
    ├── darshan/
    ├── shop/
    ├── cart/
    ├── orders/
    └── profile/




==================
=====================

                         Flutter App
                             │
                             ▼
                    ┌─────────────────┐
                    │   Presentation  │
                    │  BLoC / Cubit   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │     Domain      │
                    │    UseCases     │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │      Data       │
                    │   Repository    │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   DataSource    │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │    ApiClient    │
                    │      Dio        │
                    └────────┬────────┘
                             │
                             ▼
                         Backend API







core/
├── network       → API
├── errors        → Error handling
├── storage       → Token/local data
├── utils         → Common utilities
└── widgets       → Reusable UI


auth/
│
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart
│   │
│   ├── models/
│   │   └── user_model.dart
│   │
│   └── repositories/
│       └── auth_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── user.dart
│   │
│   ├── repositories/
│   │   └── auth_repository.dart
│   │
│   └── usecases/
│       ├── login.dart
│       ├── verify_otp.dart
│       └── logout.dart
│
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    │
    ├── pages/
    │   ├── splash_page.dart
    │   ├── login_page.dart
    │   └── otp_page.dart
    │
    └── widgets/
        ├── mobile_input.dart
        └── otp_input.dart


                         ┌─────────────┐
                         │    AUTH     │
                         └──────┬──────┘
                                │
                                ▼
                         ┌─────────────┐
                         │    HOME     │
                         └──────┬──────┘
                                │
            ┌───────────────────┼───────────────────┐
            │                   │                   │
            ▼                   ▼                   ▼
        ┌───────┐          ┌─────────┐         ┌─────────┐
        │ POOJA │          │ TEMPLE  │         │  SHOP   │
        └───┬───┘          └────┬────┘         └────┬────┘
            │                   │                   │
            ▼                   ▼                   ▼
        ┌───────┐          ┌─────────┐         ┌─────────┐
        │PANDIT │          │ DARSHAN │         │  CART   │
        └───┬───┘          └────┬────┘         └────┬────┘
            │                   │                   │
            └──────────┬────────┴──────────┬────────┘
                       │                   │
                       ▼                   ▼
                  ┌──────────┐       ┌──────────┐
                  │ PAYMENTS │       │  ORDERS  │
                  └──────────┘       └──────────┘

        DONATION ────────────────┐
        VIVAH ───────────────────┤
        POOJA ───────────────────┤
        DARSHAN ─────────────────┤
        SHOP ────────────────────┘
                       │
                       ▼
                    ORDERS




Final Home flow

                         HOME
                           │
             ┌─────────────┴─────────────┐
             │                           │
        Module Tabs                Bottom Navigation
             │                           │
     ┌───────┼────────┐          ┌───────┼────────┐
     │       │        │          │       │        │
   Pooja   Pandit   Darshan     Home   Orders    Cart
     │       │        │                           │
     │       │        │                        Profile
     │       │        │
     └───────┼────────┘
             │
        Donation / Shop

        
#   h i n d u P a y  
 