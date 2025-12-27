/// Core constants for the Satat card game
///
/// Satat is a 4-player partnership trick-taking card game with special rules:
/// - Heart 2 is the highest card in the game
/// - Players must follow suit if possible (except H2 can be played anytime)
/// - Trump suit determined by trump maker
/// - First team to win 7 tricks wins (can continue to 13-0 if winning 7-0)

class GameConstants {
  // Game Setup
  static const int totalPlayers = 4;
  static const int cardsPerPlayer = 13;
  static const int totalCards = 52;
  static const int numberOfTeams = 2;
  static const int playersPerTeam = 2;

  // Trick Winning
  static const int tricksToWin = 7;
  static const int totalTricks = 13;
  static const int perfectWinTricks = 13;

  // Dealing
  static const int firstDealBatchSize = 5;
  static const int subsequentDealBatchSize = 4;
  static const int lastFourCards = 4;

  // Trump Selection
  static const int maxReshuffles = 2;
  static const bool pictureCardsRequiredForTrump = true;

  // Timing (for synchronous gameplay)
  static const int turnTimeoutSeconds = 120; // 2 minutes
  static const int disconnectGracePeriodSeconds = 30;
  static const int disconnectTimeoutSeconds = 120; // 2 minutes

  // Teams
  static const int team0 = 0;
  static const int team1 = 1;

  // Positions (clockwise)
  static const int position0 = 0; // Trump maker
  static const int position1 = 1;
  static const int position2 = 2; // Trump maker's partner
  static const int position3 = 3;

  // Partnership mapping: position -> teamId
  static const Map<int, int> positionToTeam = {
    0: team0, // Position 0 and 2 are partners (team 0)
    1: team1, // Position 1 and 3 are partners (team 1)
    2: team0,
    3: team1,
  };

  // Card Values (for comparison, H2 is handled specially)
  static const Map<String, int> rankValues = {
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10,
    'jack': 11,
    'queen': 12,
    'king': 13,
    'ace': 14,
  };

  // Special Card: Heart 2
  static const int heart2Value = 100; // Always highest

  // Lobby
  static const int lobbyCodeLength = 6;
  static const int minPlayersToStart = 4; // Always need exactly 4

  // Game Result Types
  static const String resultNormalWin = 'normal'; // 7-12 tricks
  static const String result7to0Win = '7-0'; // Won first 7 tricks
  static const String resultPerfectWin = '13-0'; // Won all 13 tricks
}

/// Satat Game Rules Documentation
///
/// 1. CARD HIERARCHY:
///    - Heart 2 (H2) is the HIGHEST card in the entire game
///    - Trump cards beat non-trump cards
///    - Within same suit, higher rank wins (Ace > King > Queen > ... > 3 > 2)
///    - Exception: H2 beats everything, even trump Ace
///
/// 2. FOLLOWING SUIT:
///    - Players MUST follow the suit that was led if they have it
///    - Exception: H2 can be played at ANY time, even if player has the led suit
///    - If player doesn't have led suit, they can play any card (trump or discard)
///
/// 3. HEART 2 SPECIAL RULES:
///    - H2 can be played on ANY trick, regardless of suit led
///    - If H2 is LED, other players must play TRUMP if they have trump
///    - If H2 is led and player has no trump, they can play any card
///    - H2 ALWAYS wins the trick
///    - Player is NOT forced to play H2 even if they have no cards of led suit
///
/// 4. TRUMP SELECTION:
///    - Dealer's left player (position 0) is the trump maker
///    - Trump maker sees first 5 cards
///    - Options:
///      a) Choose trump from first 5 cards
///      b) Defer to last 4 cards (choose 1 face-down, that card's suit is trump)
///      c) If no pictures (J, Q, K) in first 5, can request reshuffle (max 2 reshuffles)
///    - After 2 reshuffles, must choose trump even without pictures
///
/// 5. WINNING TRICKS:
///    - Trick winner is determined by:
///      1. If H2 played -> H2 wins
///      2. Else if trumps played -> highest trump wins
///      3. Else -> highest card of led suit wins
///
/// 6. WINNING THE GAME:
///    - First team to win 7 tricks wins the game
///    - SPECIAL: If team wins first 7 tricks (7-0), they can continue playing
///    - If they win all 13 tricks (13-0), it's a "perfect win"
///    - Perfect win has special consequences for next deal
///
/// 7. DEAL ROTATION:
///    - If trump maker's team wins (normal): same dealer deals again
///    - If dealer's team wins: deal passes to the left
///    - If 7-0 or 13-0 loss: deal passes to partner of previous dealer
///
/// 8. CARD PASSING (after 7-0 or 13-0 loss):
///    - Each losing team member passes 1 TRUMP to player on right
///    - Each winning team member passes 1 unwanted card to player on left
///    - Cards passed simultaneously (before seeing received card)
///    - If loser has no trump, must pass highest ranking card
class GameRules {
  static const String followSuitRule = 'Must follow suit if possible';
  static const String heart2Rule = 'Heart 2 can be played anytime and always wins';
  static const String heart2LeadRule = 'When H2 is led, must play trump if you have trump';
  static const String trumpRule = 'Trump beats non-trump';
  static const String winCondition = 'First team to 7 tricks wins';
  static const String perfectWinCondition = 'Winning all 13 tricks is a perfect win';
}
