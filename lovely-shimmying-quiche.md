# Satat Card Game - Implementation Plan

## Project Overview

Building a cross-platform (iOS + Android) multiplayer card game for the traditional Lebanese game "Satat" - a 4-player partnership trick-taking card game with a unique trump system and the special Heart-2 rule.

### Key Requirements
- **Platforms**: iOS and Android (single codebase)
- **Players**: Always 4 players in fixed partnerships
- **Networking**: Real-time internet multiplayer (synchronous)
- **Features**: Core gameplay, friends system, lobby with invite codes, rule-based bot AI, game history & statistics
- **Aesthetics**: Simple, elegant graphics with smooth animations (Balatro-inspired)
- **Timeline**: Learning-focused, flexible pace (estimated ~15 weeks for full MVP)
- **Hosting**: Firebase free tier initially, upgrade as needed

---

## Technology Stack (Recommended)

### Frontend: **Flutter**
- **Why**: Single codebase for iOS + Android, excellent animation framework, strong performance, great for card game UIs
- **Language**: Dart (easy learning curve from Angular/TypeScript background)
- **State Management**: Riverpod (modern, type-safe, similar to Angular's DI)

### Backend: **Firebase**
- **Authentication**: Email/password via Firebase Auth
- **Database**: Cloud Firestore (real-time synchronization)
- **Functions**: Cloud Functions (TypeScript) for server-side game logic validation
- **Hosting**: Generous free tier, pay-as-you-go scaling

### Additional Libraries
- `go_router` - Navigation and routing
- `freezed` - Immutable data models with code generation
- `json_serializable` - JSON serialization
- Flutter animation libraries (built-in)

---

## Architecture Overview

### High-Level System Design
```
┌─────────────────────────────────────────────┐
│         Client Layer (Flutter)              │
│  UI → State (Riverpod) → Domain → Data      │
└─────────────────────────────────────────────┘
              ↕ Firebase SDK ↕
┌─────────────────────────────────────────────┐
│        Backend Layer (Firebase)             │
│  Auth | Firestore | Cloud Functions         │
└─────────────────────────────────────────────┘
```

### Clean Architecture Layers
1. **Presentation Layer**: Flutter widgets, screens, animations
2. **State Layer**: Riverpod providers managing app state
3. **Domain Layer**: Pure Dart business logic (game rules, validations, bot AI)
4. **Data Layer**: Firebase integration, repositories

### Project Structure
```
lib/
├── main.dart
├── app/
│   ├── app.dart                    # Root app widget
│   └── router.dart                 # Navigation
├── core/
│   ├── constants/
│   │   ├── game_constants.dart     # Card values, Satat rules
│   │   └── app_constants.dart      # Theme, colors, sizes
│   ├── theme/
│   │   ├── app_theme.dart          # Material theme
│   │   └── card_styles.dart        # Card visual styles
│   └── utils/
├── data/
│   ├── models/                     # JSON-serializable models
│   │   ├── user_model.dart
│   │   ├── game_model.dart
│   │   ├── lobby_model.dart
│   │   ├── card_model.dart
│   │   └── friend_model.dart
│   ├── repositories/               # Data layer abstraction
│   │   ├── auth_repository.dart
│   │   ├── game_repository.dart
│   │   ├── lobby_repository.dart
│   │   └── friend_repository.dart
│   └── datasources/                # Firebase wrappers
│       └── firestore_datasource.dart
├── domain/
│   ├── entities/                   # Business entities
│   │   ├── card.dart
│   │   ├── player.dart
│   │   ├── trick.dart
│   │   └── game_state.dart
│   ├── usecases/                   # Business logic
│   │   ├── play_card_usecase.dart
│   │   ├── determine_winner_usecase.dart
│   │   └── validate_move_usecase.dart
│   └── services/
│       ├── game_logic_service.dart # Core Satat rules
│       ├── trump_service.dart      # Trump determination
│       └── bot_ai_service.dart     # Bot decision logic
├── presentation/
│   ├── providers/                  # Riverpod providers
│   │   ├── auth_provider.dart
│   │   ├── game_provider.dart
│   │   ├── lobby_provider.dart
│   │   └── friends_provider.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── lobby/
│   │   │   ├── lobby_list_screen.dart
│   │   │   ├── lobby_create_screen.dart
│   │   │   └── lobby_room_screen.dart
│   │   ├── game/
│   │   │   ├── game_screen.dart
│   │   │   └── game_over_screen.dart
│   │   ├── friends/
│   │   │   └── friends_screen.dart
│   │   └── profile/
│   │       ├── profile_screen.dart
│   │       └── stats_screen.dart
│   └── widgets/
│       ├── common/
│       ├── game/
│       │   ├── card_widget.dart
│       │   ├── hand_widget.dart
│       │   ├── trick_area_widget.dart
│       │   ├── score_board_widget.dart
│       │   └── trump_indicator_widget.dart
│       └── animations/
│           ├── card_deal_animation.dart
│           ├── card_play_animation.dart
│           └── trick_collect_animation.dart
└── tests/
    ├── unit/
    ├── widget/
    └── integration/
```

---

## Core Data Models

### Firestore Database Schema

```
users/{userId}
  ├── email: string
  ├── username: string
  ├── displayName: string
  ├── createdAt: timestamp
  ├── stats/
  │   ├── gamesPlayed: number
  │   ├── gamesWon: number
  │   ├── gamesLost: number
  │   └── perfectWins: number (13-0 victories)
  └── friends: string[] (userIds)

friendRequests/{requestId}
  ├── fromUserId: string
  ├── toUserId: string
  ├── status: string (pending, accepted, rejected)
  └── createdAt: timestamp

lobbies/{lobbyId}
  ├── hostUserId: string
  ├── code: string (6-digit invite code)
  ├── status: string (waiting, ready, in_game)
  ├── createdAt: timestamp
  ├── players: map
  │   └── {userId}: { position, isReady, username, isBot }
  └── gameId: string (reference when game starts)

games/{gameId}
  ├── lobbyId: string
  ├── status: string (active, completed)
  ├── currentTurn: number (0-3, player position)
  ├── currentTrick: number (0-12)
  ├── dealer: number
  ├── trumpSuit: string (hearts, diamonds, clubs, spades)
  ├── trumpCaller: number
  ├── players: map
  │   └── {userId}: { position, hand: Card[], teamId, isBot }
  ├── tricks: array of completed tricks
  ├── currentTrickCards: map { position: card }
  ├── scores: map { team0: number, team1: number }
  ├── winner: number (teamId, null if ongoing)
  └── isPerfectWin: boolean

gameHistory/{historyId}
  ├── gameId: string
  ├── players: map { userId: position }
  ├── winner: number (teamId)
  ├── isPerfectWin: boolean
  ├── finalScore: map
  ├── completedAt: timestamp
  └── duration: number (seconds)
```

### Key Dart Models

**Card Model**:
```dart
enum Suit { hearts, diamonds, clubs, spades }
enum Rank { two, three, ..., king, ace }

@freezed
class Card with _$Card {
  const factory Card({
    required Suit suit,
    required Rank rank,
  }) = _Card;

  // Extension: isHeartTwo, value (H2 = 100), displayName
}
```

**Game State Model**:
```dart
@freezed
class GameModel with _$GameModel {
  const factory GameModel({
    required String id,
    required GameStatus status,
    required int currentTurn,        // 0-3
    required int currentTrick,       // 0-12
    required Suit trumpSuit,
    required Map<String, PlayerGameState> players,
    required List<Trick> tricks,
    required Map<int, Card?> currentTrickCards,
    required Map<int, int> scores,   // teamId -> tricksWon
    int? winner,
    @Default(false) bool isPerfectWin,
  }) = _GameModel;
}
```

---

## Implementation Phases

### Phase 0: Project Setup
**Deliverables**: Development environment ready, Firebase configured

- Install Flutter SDK, Android Studio, Xcode (for iOS)
- Create Flutter project: `flutter create satat`
- Setup Firebase project (Authentication, Firestore, Cloud Functions)
- Add dependencies (riverpod, freezed, firebase packages, go_router)
- Configure Firebase in iOS/Android
- Setup folder structure
- Define core constants (card suits, ranks, Satat game rules)

**Critical Files Created**:
- `lib/core/constants/game_constants.dart` - All Satat rules as constants
- `lib/core/theme/app_theme.dart` - Material theme
- `pubspec.yaml` - Dependencies
- `firebase.json`, `firestore.rules`, `firestore.indexes.json`

---

### Phase 1: Authentication & User Management
**Deliverables**: Users can register, login, view profile

- Create `AuthRepository` and `AuthProvider`
- Build login screen (email/password with validation)
- Build registration screen
- Implement Firebase Authentication integration
- Create basic profile screen showing username, stats
- Setup navigation with `go_router` (auth-guarded routes)
- Cloud Function: `onUserCreate` (initialize Firestore user doc)

**Critical Files**:
- `lib/data/repositories/auth_repository.dart`
- `lib/presentation/providers/auth_provider.dart`
- `lib/presentation/screens/auth/login_screen.dart`
- `lib/presentation/screens/auth/register_screen.dart`
- `functions/src/users/onUserCreate.ts`

**Testing**: Unit tests for auth repository, widget tests for forms, integration test for full registration flow

---

### Phase 2: Friends System
**Deliverables**: Add friends, manage requests, search users

- Create `FriendsRepository` and `FriendsProvider`
- Build friends list screen
- Build add friend dialog (search by username)
- Show pending/sent friend requests
- Accept/reject request UI
- Cloud Functions: `sendFriendRequest`, `acceptFriendRequest`, `rejectFriendRequest`

**Critical Files**:
- `lib/data/repositories/friend_repository.dart`
- `lib/presentation/providers/friends_provider.dart`
- `lib/presentation/screens/friends/friends_screen.dart`
- `functions/src/friends/` (Cloud Functions)

---

### Phase 3: Lobby System
**Deliverables**: Create lobbies, join via code, invite friends, add bots

- Create `LobbyRepository` and `LobbyProvider`
- Build lobby list screen (active lobbies)
- Build lobby creation dialog
- Build lobby room screen (4 player slots, ready-up buttons)
- Implement join by 6-digit code
- Implement invite from friend list
- Add bot to empty slots
- Real-time lobby updates (Firestore listeners)
- Cloud Functions: `createLobby`, `joinLobby`, `leaveLobby`, `toggleReady`, `addBot`

**Critical Files**:
- `lib/data/repositories/lobby_repository.dart`
- `lib/presentation/providers/lobby_provider.dart`
- `lib/presentation/screens/lobby/lobby_room_screen.dart`
- `functions/src/lobby/` (Cloud Functions)

---

### Phase 4: Core Game Logic - Foundation
**Deliverables**: Card models, game rules implementation, dealing & trump selection

- Create all data models with `freezed` (Card, GameModel, PlayerGameState, Trick)
- Implement `GameLogicService` (pure Dart):
  - Shuffle deck (cryptographically secure random)
  - Deal 13 cards to each player
  - Trump determination rules
  - Validate suit-following rules
  - Heart-2 special rules (can be played anytime, always wins, must trump if H2 led)
  - Determine trick winner
- Design card widget UI (elegant, Balatro-inspired)
- Build basic game screen layout
- Implement card dealing animation
- Build trump selection UI (first 5 cards or last 4 cards option)
- Cloud Functions: `startGame`, `dealCards`, `selectTrump`

**Critical Files** ⭐:
- `lib/domain/services/game_logic_service.dart` - **CORE GAME RULES**
- `lib/data/models/card_model.dart`
- `lib/data/models/game_model.dart`
- `lib/presentation/widgets/game/card_widget.dart`
- `lib/presentation/screens/game/game_screen.dart`
- `functions/src/game/startGame.ts`
- `functions/src/game/dealCards.ts`

**Testing**: Extensive unit tests for all Satat rules (H2 supremacy, trump hierarchy, suit following, edge cases)

---

### Phase 5: Core Game Logic - Gameplay
**Deliverables**: Play cards, win tricks, complete games

- Create `GameRepository` and `GameProvider`
- Implement card play UI (tap/drag card)
- Card play animation (hand → trick area)
- Highlight valid playable cards
- Show turn indicator
- Implement trick winner determination
- Trick collection animation (cards fly to winner)
- Score tracking and display
- Win condition detection (first to 7 tricks, 7-0 continuation, 13-0 perfect)
- Game over screen
- Cloud Function: `playCard` (validate move, update state)
- Cloud Function: `checkTrickComplete` (determine winner, update scores)
- Cloud Function: `checkGameEnd` (win conditions, update stats, create history)

**Critical Files** ⭐:
- `lib/presentation/providers/game_provider.dart` - **GAME STATE MANAGEMENT**
- `lib/data/repositories/game_repository.dart`
- `functions/src/game/onPlayCard.ts` - **SERVER VALIDATION**
- `functions/src/game/determineTrickWinner.ts`
- `functions/src/game/checkGameEnd.ts`

**Testing**: Integration tests for full game flow, unit tests for all rule edge cases, test 7-0 and 13-0 scenarios

---

### Phase 6: Bot AI Implementation
**Deliverables**: Rule-based bot players for practice mode

**Bot Strategy (Simple Rule-Based)**:
1. Always follow suit if possible
2. If partner is winning trick, play lowest valid card
3. If team needs to win, play highest non-trump card that wins
4. Use trump cards when team is losing badly
5. Save Heart-2 for later tricks unless desperate (trick 10+)
6. Play lowest card by default

**Implementation**:
- Create `BotAIService` in domain layer
- Implement decision tree for card selection
- Cloud Function: `botPlayCard` (triggered automatically after human plays)
- Bot response time: <500ms

**Critical Files**:
- `lib/domain/services/bot_ai_service.dart`
- `functions/src/bot/botPlayCard.ts`

**Testing**: 100 bot-only games to ensure no invalid moves, verify response time, test decision quality

---

### Phase 7: Real-time Synchronization & Disconnection Handling
**Deliverables**: Robust multiplayer with disconnect recovery

**Real-time Sync**:
- All clients subscribe to Firestore game document listeners
- Optimistic updates (show card play immediately, revert if server rejects)
- Server is single source of truth (Cloud Functions validate all moves)

**Disconnect Handling**:
- Firebase Presence system (detect online/offline)
- Grace period: 30 seconds before showing "disconnected"
- Game pauses when player disconnects
- Reconnection: Player rejoins and receives full game state
- Timeout: After 2 minutes, forfeit game (other team wins)

**Critical Files**:
- `lib/data/repositories/game_repository.dart` (add presence logic)
- `lib/presentation/widgets/game/connection_indicator.dart`
- `functions/src/game/handleDisconnect.ts`

**Testing**: Simulate disconnections (airplane mode), test reconnection, test timeout behavior

---

### Phase 8: Game History & Statistics
**Deliverables**: View past games and player stats

- Build stats screen (win/loss ratio, total games, perfect wins)
- Build game history list (paginated)
- Build game detail screen (show final state, players, winner)
- Query Firestore for user's game history
- Update user stats on game completion (already in Phase 5)

**Critical Files**:
- `lib/presentation/screens/profile/stats_screen.dart`
- `lib/data/repositories/game_history_repository.dart`

---

### Phase 9: Polish & Animations
**Deliverables**: Smooth animations and Balatro-inspired aesthetics

- Implement all card animations (deal, play, trick collect)
- Add score increment animations
- Add celebration animation on win
- Polish UI (gradient backgrounds, particle effects, card hover effects)
- Add haptic feedback
- Improve loading states and error messages
- Use free/open-source card graphics (public domain card designs)

**Focus**: 60fps performance, smooth UX, elegant simplicity

---

### Phase 10: Testing & Bug Fixes
**Deliverables**: Stable, bug-free experience

- End-to-end testing (full game flows)
- Stress testing (multiple concurrent games)
- Edge case testing (all special Satat scenarios)
- Performance optimization
- Security audit (Firestore rules, Cloud Functions)
- Fix all critical/high-priority bugs

---

### Phase 11: Beta & Launch
**Deliverables**: Published to App Store & Play Store

- Internal beta (TestFlight for iOS, Internal Track for Android)
- Gather feedback from friends
- Polish based on feedback
- Create app store assets (icon, screenshots, description)
- Create privacy policy
- Submit to App Store & Play Store
- Monitor crash reports (Firebase Crashlytics)

---

## Key Technical Challenges & Solutions

### 1. Real-time Synchronization
**Challenge**: All 4 players must see the same game state simultaneously with <200ms latency.

**Solution**:
- Firestore real-time listeners on all clients
- Cloud Functions as single source of truth
- Optimistic UI updates (revert if server rejects)
- Server timestamp for conflict resolution

### 2. Preventing Cheating
**Challenge**: Players could modify client code to play invalid cards.

**Solution**:
- **Zero trust client**: All game logic validated server-side
- Cloud Functions validate: Is it player's turn? Is card in hand? Does card follow suit rules?
- Firestore security rules prevent direct writes to `games` collection
- Atomic transactions for race condition safety

### 3. Card Shuffling Fairness
**Challenge**: Players must trust shuffling is random, not rigged.

**Solution**:
- Use `crypto.randomBytes()` for cryptographically secure randomness
- Shuffling only in Cloud Functions (never client-side)
- Fisher-Yates shuffle algorithm
- Statistical testing: 10,000 shuffles, verify uniform distribution

### 4. Disconnect Handling
**Challenge**: Mobile networks are unreliable.

**Solution**:
- Firebase Presence detection (`.onDisconnect()`)
- 30-second grace period before showing "disconnected"
- Game state preserved, auto-resume on reconnect
- 2-minute timeout → forfeit (other team wins)

### 5. Bot AI Performance
**Challenge**: Bots must respond quickly and play reasonably well.

**Solution**:
- Rule-based AI (not ML) for simplicity and speed
- Decision tree with clear priorities
- Target response time: <300ms
- Server-side bot logic (Cloud Functions)

---

## Critical Files Summary

These are the most important files that will contain the core implementation:

1. **`lib/domain/services/game_logic_service.dart`**
   - Pure Dart implementation of all Satat rules
   - Trick winner determination, H2 logic, suit following validation
   - Most important file for game correctness

2. **`lib/data/models/game_model.dart`**
   - Central game state structure
   - All other systems depend on this model

3. **`lib/presentation/providers/game_provider.dart`**
   - Manages real-time game state with Riverpod
   - Connects UI to backend via repositories
   - Handles optimistic updates

4. **`functions/src/game/onPlayCard.ts`**
   - Server-side card play validation
   - Prevents cheating, enforces rules
   - Updates Firestore game state

5. **`lib/presentation/widgets/game/card_widget.dart`**
   - Core UI component for cards
   - All animations and interactions flow from here

6. **`lib/presentation/screens/game/game_screen.dart`**
   - Main gameplay screen layout
   - Coordinates all game widgets

---

## Next Steps to Get Started

### 1. Setup Development Environment
```bash
# Install Flutter SDK (follow: https://flutter.dev/docs/get-started/install)
# Install Android Studio + Xcode

# Verify installation
flutter doctor

# Create project
flutter create satat
cd satat

# Add dependencies to pubspec.yaml:
# - flutter_riverpod
# - freezed_annotation
# - json_annotation
# - firebase_core, firebase_auth, cloud_firestore, cloud_functions
# - go_router

flutter pub get
```

### 2. Setup Firebase Project
1. Go to https://console.firebase.google.com
2. Create new project: "Satat Card Game"
3. Enable Authentication (Email/Password provider)
4. Create Firestore database (start in test mode)
5. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
6. Follow FlutterFire CLI setup: `flutterfire configure`

### 3. Setup Cloud Functions
```bash
cd functions
npm install
```

### 4. Create Core Files
Start with the foundation:
- `lib/core/constants/game_constants.dart` - Define all Satat rules
- `lib/data/models/card_model.dart` - Card data model
- `lib/core/theme/app_theme.dart` - App theme and colors

### 5. First Feature: Authentication
Build login/register screens to get a working feature quickly and learn Flutter basics.

---

## Learning Resources

### Flutter
- Official docs: https://flutter.dev/docs
- "Write your first Flutter app" codelab
- Flutter animations documentation

### Firebase
- FlutterFire docs: https://firebase.flutter.dev
- Firestore data modeling guide
- Cloud Functions for Firebase (TypeScript)

### Riverpod
- Official docs: https://riverpod.dev
- Provider pattern tutorials

### Game Development
- Study card game UIs (Hearthstone, Balatro)
- Flutter animations tutorials on YouTube

---

## Summary

This plan provides a complete roadmap for building a production-ready Satat card game:

✅ **Cross-platform**: Flutter for iOS + Android with single codebase
✅ **Real-time Multiplayer**: Firebase Firestore for live game synchronization
✅ **Scalable Backend**: Cloud Functions for server-side logic, generous free tier
✅ **Clean Architecture**: Testable, maintainable code structure
✅ **Comprehensive Features**: All MVP requirements (gameplay, friends, lobbies, bots, stats)
✅ **Learning-Focused**: Flexible timeline, modern best practices

**Key Success Factors**:
- Start with Phase 0 (setup) and Phase 1 (auth) to get quick wins
- Build Phase 4 & 5 (core game logic) early - it's the most complex
- Test multiplayer frequently using Firebase emulator
- Use free/open assets for MVP, focus on gameplay first
- Iterate based on feedback from friends during beta

Good luck! This is an ambitious but achievable project that will give you deep experience with Flutter, Firebase, real-time systems, and game development.
