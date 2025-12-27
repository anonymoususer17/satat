# Satat - Lebanese Card Game

A cross-platform mobile application for playing Satat, a traditional Lebanese 4-player partnership trick-taking card game.

## About Satat

Satat is a strategic card game played with 4 players in fixed partnerships. The game features:
- **Partnership Play**: Players sitting opposite are partners (teams of 2)
- **Trump System**: One player selects the trump suit each hand
- **Special Card**: The 2 of Hearts is the highest card in the game and can be played at any time
- **Trick-Taking**: First team to win 7 tricks wins the game
- **Perfect Wins**: Teams can continue after winning 7-0 to attempt a perfect 13-0 victory

## Features

### Current (Phase 0 - Complete ✅)
- ✅ Project setup with Flutter & Firebase
- ✅ Clean architecture structure
- ✅ Core game rules implemented as constants
- ✅ Elegant Balatro-inspired theme

### Planned (MVP)
- 🎯 **Authentication**: Email/password login and registration
- 🎯 **Friends System**: Add friends, manage friend requests
- 🎯 **Lobby System**: Create/join lobbies with invite codes
- 🎯 **Core Gameplay**: Full Satat rules implementation with real-time multiplayer
- 🎯 **Bot AI**: Rule-based AI for practice games
- 🎯 **Game History**: Track stats and view past games
- 🎯 **Smooth Animations**: Card dealing, playing, and trick collection

## Tech Stack

### Frontend
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Navigation**: go_router
- **Data Models**: Freezed + JSON Serialization

### Backend
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore (real-time sync)
- **Functions**: Cloud Functions (TypeScript) for server-side validation
- **Hosting**: Firebase (free tier initially)

## Project Structure

```
lib/
├── app/                    # App-level configuration
├── core/
│   ├── constants/         # Game rules and constants
│   ├── theme/            # App theme and styling
│   └── utils/            # Utility functions
├── data/
│   ├── models/           # Data models (Firestore documents)
│   ├── repositories/     # Data layer abstraction
│   └── datasources/      # Firebase service wrappers
├── domain/
│   ├── entities/         # Business entities
│   ├── usecases/         # Business logic
│   └── services/         # Game logic, bot AI
└── presentation/
    ├── providers/        # Riverpod state providers
    ├── screens/          # UI screens
    └── widgets/          # Reusable UI components
```

## Getting Started

### Prerequisites
- Flutter SDK (3.10.4 or higher)
- Android Studio / Xcode (for mobile development)
- Firebase CLI and FlutterFire CLI
- Node.js (for Cloud Functions)

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd satat
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration** ⚠️

   Firebase config files are **not included** in the repository for security.

   To set up Firebase:

   a. Create a Firebase project at https://console.firebase.google.com

   b. Install FlutterFire CLI:
   ```bash
   flutter pub global activate flutterfire_cli
   ```

   c. Configure your Firebase project:
   ```bash
   flutterfire configure
   ```

   This will create:
   - `lib/firebase_options.dart`
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

   d. Enable Firebase services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Cloud Functions

4. **Run the app**
   ```bash
   flutter run
   ```

### Cloud Functions Setup (Future Phase)

```bash
cd functions
npm install
firebase deploy --only functions
```

## Development

### Running Tests
```bash
flutter test
```

### Code Generation (for Freezed models)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Firebase Emulator (for local development)
```bash
firebase emulators:start
```

## Game Rules

See `lib/core/constants/game_constants.dart` for detailed Satat rules documentation.

### Quick Rules Summary:
1. **Card Hierarchy**: Heart 2 > Trump Cards > Non-Trump (by rank)
2. **Following Suit**: Must follow suit if possible (except H2 can be played anytime)
3. **Trump Selection**: Trump maker chooses from first 5 cards or defers to last 4
4. **Winning**: First team to 7 tricks wins (can continue to 13-0 if winning 7-0)
5. **H2 Special**: Heart 2 always wins and can be played on any trick

## Contributing

This is a personal learning project, but suggestions and feedback are welcome!

## Architecture Decisions

- **Clean Architecture**: Separation of concerns for testability and maintainability
- **Server-Side Validation**: All game logic validated on Cloud Functions to prevent cheating
- **Real-Time Sync**: Firestore listeners for live multiplayer experience
- **Optimistic Updates**: UI updates immediately, reverts if server rejects

## License

Private project - All rights reserved

## Acknowledgments

- Game design inspired by traditional Lebanese card game Satat
- UI/UX inspired by Balatro's elegant simplicity
- Built with Flutter and Firebase
