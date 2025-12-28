import 'package:freezed_annotation/freezed_annotation.dart';
import 'card_model.dart';
import 'trick_model.dart';

part 'game_model.freezed.dart';
part 'game_model.g.dart';

/// Game phase enumeration
enum GamePhase {
  trumpSelection, // Waiting for trump to be selected
  playing, // Game in progress
  ended; // Game completed
}

/// Represents a player in the game
@freezed
class GamePlayer with _$GamePlayer {
  const GamePlayer._();

  const factory GamePlayer({
    required int position, // 0-3
    required String? userId, // null if bot
    required String username,
    required String displayName,
    required bool isBot,
    required List<CardModel> hand, // Cards in hand
  }) = _GamePlayer;

  factory GamePlayer.fromJson(Map<String, dynamic> json) => _$GamePlayerFromJson(json);

  /// Get team number (0 or 1)
  int get team => position % 2 == 0 ? 0 : 1;

  /// Sort hand by suit and rank
  List<CardModel> get sortedHand {
    final sorted = List<CardModel>.from(hand);
    sorted.sort((a, b) {
      // First sort by suit
      final suitCompare = a.suit.index.compareTo(b.suit.index);
      if (suitCompare != 0) return suitCompare;
      // Then by rank within suit
      return a.rank.value.compareTo(b.rank.value);
    });
    return sorted;
  }
}

/// Game result information
@freezed
class GameResult with _$GameResult {
  const factory GameResult({
    required int winningTeam, // 0 or 1
    required int team0Tricks,
    required int team1Tricks,
    required String resultType, // 'normal', '7-0', or '13-0'
  }) = _GameResult;

  factory GameResult.fromJson(Map<String, dynamic> json) => _$GameResultFromJson(json);
}

/// Main game state model
@freezed
class GameModel with _$GameModel {
  const GameModel._();

  const factory GameModel({
    required String id,
    required String lobbyId,
    required GamePhase phase,
    required List<GamePlayer> players, // 4 players
    required int dealerPosition, // Who dealt this hand
    required int trumpMakerPosition, // Position 0 (left of dealer)
    CardSuit? trumpSuit, // null until trump is selected
    required TrickModel? currentTrick, // null if between tricks or game ended
    required List<TrickModel> completedTricks, // History of tricks
    required int team0TricksWon,
    required int team1TricksWon,
    GameResult? result, // null until game ends
    required DateTime createdAt,
    DateTime? endedAt,
    // Trump selection state
    List<CardModel>? trumpMakerFirstFive, // First 5 cards shown to trump maker
    List<CardModel>? trumpMakerLastFour, // Last 4 cards (if deferred)
    int? reshuffleCount, // Number of reshuffles (max 2)
  }) = _GameModel;

  factory GameModel.fromJson(Map<String, dynamic> json) => _$GameModelFromJson(json);

  /// Get current turn position (who should play next)
  int? get currentTurnPosition {
    if (phase == GamePhase.ended) return null;
    if (phase == GamePhase.trumpSelection) return trumpMakerPosition;
    if (currentTrick == null) return null;
    return currentTrick!.nextPosition;
  }

  /// Check if game is over
  bool get isGameOver => phase == GamePhase.ended || result != null;

  /// Get total tricks won by a team
  int tricksWonByTeam(int team) {
    return team == 0 ? team0TricksWon : team1TricksWon;
  }

  /// Get player by position
  GamePlayer getPlayerByPosition(int position) {
    return players.firstWhere((p) => p.position == position);
  }

  /// Get player by user ID
  GamePlayer? getPlayerByUserId(String userId) {
    try {
      return players.firstWhere((p) => p.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Check if it's a specific player's turn
  bool isPlayerTurn(String userId) {
    final player = getPlayerByUserId(userId);
    if (player == null) return false;
    return currentTurnPosition == player.position;
  }

  /// Get the next lead position for a new trick
  int getNextLeadPosition() {
    if (currentTrick != null && currentTrick!.isComplete && currentTrick!.winnerPosition != null) {
      return currentTrick!.winnerPosition!;
    }
    // Default to position after dealer
    return (dealerPosition + 1) % 4;
  }
}

/// Helper function to create a new game from a lobby
GameModel createGameFromLobby({
  required String gameId,
  required String lobbyId,
  required List<Map<String, dynamic>> lobbyPlayers, // Players from lobby
  required int dealerPosition,
}) {
  // Create game players from lobby players
  final gamePlayers = <GamePlayer>[];
  for (int i = 0; i < 4; i++) {
    final lobbyPlayer = lobbyPlayers[i];
    gamePlayers.add(GamePlayer(
      position: i,
      userId: lobbyPlayer['userId'] as String?,
      username: lobbyPlayer['username'] as String,
      displayName: lobbyPlayer['displayName'] as String,
      isBot: lobbyPlayer['isBot'] as bool,
      hand: [], // Cards will be dealt later
    ));
  }

  return GameModel(
    id: gameId,
    lobbyId: lobbyId,
    phase: GamePhase.trumpSelection,
    players: gamePlayers,
    dealerPosition: dealerPosition,
    trumpMakerPosition: (dealerPosition + 1) % 4, // Left of dealer
    trumpSuit: null,
    currentTrick: null,
    completedTricks: [],
    team0TricksWon: 0,
    team1TricksWon: 0,
    result: null,
    createdAt: DateTime.now(),
    endedAt: null,
    trumpMakerFirstFive: null,
    trumpMakerLastFour: null,
    reshuffleCount: 0,
  );
}
