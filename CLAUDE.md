# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Satat is a Flutter-based multiplayer card game implementing a traditional 4-player partnership trick-taking game with real-time Firebase backend. The game features trump selection, special card rules (H2), and bot AI opponents.

## Build & Development Commands

### Setup
```bash
# Install dependencies
flutter pub get

# Configure Firebase (required for new clones)
flutterfire configure
```

### Code Generation
```bash
# Generate Freezed models and JSON serialization (required after model changes)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Running
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Run with Firebase emulator (local development)
firebase emulators:start
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart
```

### Build
```bash
# Build APK (Android)
flutter build apk

# Build app bundle (Android)
flutter build appbundle

# Build iOS
flutter build ios
```

## Architecture

### Clean Architecture Pattern

The codebase follows clean architecture with clear separation of concerns:

```
lib/
├── app/                    # App-level (router, main app config)
├── core/                   # Shared constants, theme, utils
├── data/                   # Data layer (models, repositories, Firebase)
├── domain/                 # Business logic (services, use cases)
└── presentation/           # UI layer (providers, screens, widgets)
```

**Key architectural principles:**
- **Data Layer** (`data/`): Contains Firestore models with Freezed for immutability and JSON serialization. Repositories handle all Firebase operations and data transformations.
- **Domain Layer** (`domain/services/`): Pure business logic with no Firebase dependencies. `GameLogicService` handles all Satat rules validation, `BotAIService` implements bot decision-making, `BotControllerService` orchestrates bot actions.
- **Presentation Layer** (`presentation/`): Riverpod providers for state management, screens for UI, widgets for reusable components.

### State Management with Riverpod

- **Providers** (`presentation/providers/`): All state lives in Riverpod providers
- **Stream Providers**: Used for real-time Firestore sync (e.g., `gameProvider`, `lobbyProvider`)
- **State Notifier Providers**: Used for controller actions with loading/error states (e.g., `GameController`, `LobbyController`)
- **Provider Pattern**: Each repository/service has a provider for dependency injection

Example provider pattern:
```dart
// Repository provider
final gameRepositoryProvider = Provider<GameRepository>((ref) => GameRepository());

// Stream provider for real-time data
final gameProvider = StreamProvider.family<GameModel, String>((ref, gameId) {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.watchGame(gameId);
});

// State notifier for actions
final gameControllerProvider = StateNotifierProvider<GameController, GameControllerState>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return GameController(repository);
});
```

### Data Flow

1. **User Action** → UI calls controller method
2. **Controller** → Calls repository method (sets loading state)
3. **Repository** → Validates with domain services → Updates Firestore
4. **Firestore** → Real-time listener triggers
5. **Stream Provider** → Automatically updates UI

### Game State Synchronization

- All game state lives in Firestore and syncs in real-time via Stream Providers
- Game logic validation happens in `GameLogicService` before Firestore writes
- Firestore updates are atomic - repository methods perform all validations before writing
- No local state caching - UI always reflects Firestore state

### Bot System Architecture

Bots are managed through a multi-layer system:

1. **Bot AI Service** (`bot_ai_service.dart`): Pure strategy logic for card selection and trump decisions. Rule-based AI with no side effects.
2. **Bot Controller Service** (`bot_controller_service.dart`): Orchestrates bot actions by watching game state and calling repository methods when it's a bot's turn.
3. **Integration**: Screens call `BotControllerService.handleBotTurn()` after each state change to trigger bot actions when needed.

Bot turn handling is currently triggered reactively from UI after game state updates. Bots make decisions using valid cards from `GameLogicService.getValidCards()`.

## Satat Game Rules Implementation

The game implements these core rules (see `lib/core/constants/game_constants.dart` for full documentation):

### Card Hierarchy
1. **Heart 2 (H2)** - Highest card, beats everything
2. **Trump cards** - Beat non-trump
3. **Non-trump** - Ranked by value (A > K > Q > ... > 3 > 2)

### Following Suit Rules
- Must follow suit if possible
- **Exception**: H2 can be played anytime
- **Special**: When H2 is led, must play trump if you have it

### Trump Selection Phase
- Trump maker (left of dealer) sees first 5 cards
- Options:
  - Choose trump from first 5
  - Defer to last 4 (pick one face-down)
  - Reshuffle if no pictures in first 5 (max 2 reshuffles)

### Win Conditions
- **Normal Win**: First team to 7 tricks
- **7-0 Win**: Win first 7 tricks (team can choose to continue)
- **Perfect Win (13-0)**: Win all 13 tricks

### Game Flow
```
GamePhase.trumpSelection → GamePhase.playing → GamePhase.ended
```

All rule validation is centralized in `GameLogicService.validateCardPlay()` and enforced in `GameRepository.playCard()` before Firestore writes.

## Firebase Structure

### Collections
- `users`: User profiles and friend lists
- `friendRequests`: Friend request documents
- `lobbies`: Game lobbies with player slots and bot management
- `games`: Active game state with full game data

### Security Considerations
- Firebase config files (`firebase_options.dart`, `google-services.json`) are gitignored
- New clones must run `flutterfire configure` to generate config files
- Authentication required for all Firestore operations
- Game state validation happens client-side (server-side Cloud Functions are planned but not yet implemented)

## Models & Code Generation

All data models use Freezed for immutability and JSON serialization:

```dart
@freezed
class GameModel with _$GameModel {
  const factory GameModel({
    required String id,
    required GamePhase phase,
    // ... fields
  }) = _GameModel;

  factory GameModel.fromJson(Map<String, dynamic> json) => _$GameModelFromJson(json);
}
```

**Important**: After modifying any model in `data/models/`, you MUST run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Models include:
- `CardModel`: Card with suit/rank, includes `compareForTrick()` for game logic
- `TrickModel`: Single trick state with cards played and winner
- `GameModel`: Complete game state with players, tricks, scores
- `LobbyModel`: Pre-game lobby with player slots
- `UserModel`, `FriendRequestModel`: User/social features

## Navigation

Uses go_router with declarative routing in `lib/app/router.dart`:

- Authentication redirects handled automatically
- Routes: `/login`, `/register`, `/`, `/friends`, `/lobby`, `/lobby/:id`, `/game/:id`
- Game/lobby screens take IDs as path parameters and use family providers to watch state

## Common Development Patterns

### Adding a new game feature
1. Define business logic in `GameLogicService` (domain layer)
2. Add repository method in `GameRepository` to handle Firestore operations
3. Add controller method in `GameController` (presentation layer)
4. Update UI to call controller method
5. If models changed, run `build_runner`

### Adding a new Firestore model
1. Create model in `data/models/` with Freezed annotations
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Create repository in `data/repositories/` for CRUD operations
4. Create provider in `presentation/providers/` for state management
5. Use StreamProvider for real-time sync or FutureProvider for one-time fetches

### Working with bot behavior
- Bot decision logic goes in `BotAIService` methods
- Bot orchestration (when to trigger) goes in `BotControllerService`
- Bot turns are triggered from UI after state changes via `handleBotTurn()`
- Test bot logic by running games with bot players in various positions

## Known Patterns & Conventions

- Position numbering: 0-3 (clockwise), positions 0 & 2 are team 0, positions 1 & 3 are team 1
- Team numbering: 0 or 1
- Card comparison: Use `CardModel.compareForTrick()`, not manual comparison
- Error handling: Repositories throw exceptions with descriptive messages, controllers catch and store in state
- Firestore updates: Always validate with `GameLogicService` before writing
- Bot players: `userId` is null, `isBot` is true
