// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GamePlayer _$GamePlayerFromJson(Map<String, dynamic> json) {
  return _GamePlayer.fromJson(json);
}

/// @nodoc
mixin _$GamePlayer {
  int get position => throw _privateConstructorUsedError; // 0-3
  String? get userId => throw _privateConstructorUsedError; // null if bot
  String get username => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  bool get isBot => throw _privateConstructorUsedError;
  List<CardModel> get hand => throw _privateConstructorUsedError;

  /// Serializes this GamePlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamePlayerCopyWith<GamePlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamePlayerCopyWith<$Res> {
  factory $GamePlayerCopyWith(
    GamePlayer value,
    $Res Function(GamePlayer) then,
  ) = _$GamePlayerCopyWithImpl<$Res, GamePlayer>;
  @useResult
  $Res call({
    int position,
    String? userId,
    String username,
    String displayName,
    bool isBot,
    List<CardModel> hand,
  });
}

/// @nodoc
class _$GamePlayerCopyWithImpl<$Res, $Val extends GamePlayer>
    implements $GamePlayerCopyWith<$Res> {
  _$GamePlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? userId = freezed,
    Object? username = null,
    Object? displayName = null,
    Object? isBot = null,
    Object? hand = null,
  }) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            isBot: null == isBot
                ? _value.isBot
                : isBot // ignore: cast_nullable_to_non_nullable
                      as bool,
            hand: null == hand
                ? _value.hand
                : hand // ignore: cast_nullable_to_non_nullable
                      as List<CardModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GamePlayerImplCopyWith<$Res>
    implements $GamePlayerCopyWith<$Res> {
  factory _$$GamePlayerImplCopyWith(
    _$GamePlayerImpl value,
    $Res Function(_$GamePlayerImpl) then,
  ) = __$$GamePlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int position,
    String? userId,
    String username,
    String displayName,
    bool isBot,
    List<CardModel> hand,
  });
}

/// @nodoc
class __$$GamePlayerImplCopyWithImpl<$Res>
    extends _$GamePlayerCopyWithImpl<$Res, _$GamePlayerImpl>
    implements _$$GamePlayerImplCopyWith<$Res> {
  __$$GamePlayerImplCopyWithImpl(
    _$GamePlayerImpl _value,
    $Res Function(_$GamePlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? userId = freezed,
    Object? username = null,
    Object? displayName = null,
    Object? isBot = null,
    Object? hand = null,
  }) {
    return _then(
      _$GamePlayerImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        isBot: null == isBot
            ? _value.isBot
            : isBot // ignore: cast_nullable_to_non_nullable
                  as bool,
        hand: null == hand
            ? _value._hand
            : hand // ignore: cast_nullable_to_non_nullable
                  as List<CardModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GamePlayerImpl extends _GamePlayer {
  const _$GamePlayerImpl({
    required this.position,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.isBot,
    required final List<CardModel> hand,
  }) : _hand = hand,
       super._();

  factory _$GamePlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$GamePlayerImplFromJson(json);

  @override
  final int position;
  // 0-3
  @override
  final String? userId;
  // null if bot
  @override
  final String username;
  @override
  final String displayName;
  @override
  final bool isBot;
  final List<CardModel> _hand;
  @override
  List<CardModel> get hand {
    if (_hand is EqualUnmodifiableListView) return _hand;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hand);
  }

  @override
  String toString() {
    return 'GamePlayer(position: $position, userId: $userId, username: $username, displayName: $displayName, isBot: $isBot, hand: $hand)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamePlayerImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.isBot, isBot) || other.isBot == isBot) &&
            const DeepCollectionEquality().equals(other._hand, _hand));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    position,
    userId,
    username,
    displayName,
    isBot,
    const DeepCollectionEquality().hash(_hand),
  );

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamePlayerImplCopyWith<_$GamePlayerImpl> get copyWith =>
      __$$GamePlayerImplCopyWithImpl<_$GamePlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GamePlayerImplToJson(this);
  }
}

abstract class _GamePlayer extends GamePlayer {
  const factory _GamePlayer({
    required final int position,
    required final String? userId,
    required final String username,
    required final String displayName,
    required final bool isBot,
    required final List<CardModel> hand,
  }) = _$GamePlayerImpl;
  const _GamePlayer._() : super._();

  factory _GamePlayer.fromJson(Map<String, dynamic> json) =
      _$GamePlayerImpl.fromJson;

  @override
  int get position; // 0-3
  @override
  String? get userId; // null if bot
  @override
  String get username;
  @override
  String get displayName;
  @override
  bool get isBot;
  @override
  List<CardModel> get hand;

  /// Create a copy of GamePlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamePlayerImplCopyWith<_$GamePlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameResult _$GameResultFromJson(Map<String, dynamic> json) {
  return _GameResult.fromJson(json);
}

/// @nodoc
mixin _$GameResult {
  int get winningTeam => throw _privateConstructorUsedError; // 0 or 1
  int get team0Tricks => throw _privateConstructorUsedError;
  int get team1Tricks => throw _privateConstructorUsedError;
  String get resultType =>
      throw _privateConstructorUsedError; // 'normal', '7-0', '13-0', 'callout-win', 'callout-loss'
  int? get callerPosition =>
      throw _privateConstructorUsedError; // Position of player who called out (null for normal wins)
  bool? get cheatDetected => throw _privateConstructorUsedError;

  /// Serializes this GameResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameResultCopyWith<GameResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameResultCopyWith<$Res> {
  factory $GameResultCopyWith(
    GameResult value,
    $Res Function(GameResult) then,
  ) = _$GameResultCopyWithImpl<$Res, GameResult>;
  @useResult
  $Res call({
    int winningTeam,
    int team0Tricks,
    int team1Tricks,
    String resultType,
    int? callerPosition,
    bool? cheatDetected,
  });
}

/// @nodoc
class _$GameResultCopyWithImpl<$Res, $Val extends GameResult>
    implements $GameResultCopyWith<$Res> {
  _$GameResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winningTeam = null,
    Object? team0Tricks = null,
    Object? team1Tricks = null,
    Object? resultType = null,
    Object? callerPosition = freezed,
    Object? cheatDetected = freezed,
  }) {
    return _then(
      _value.copyWith(
            winningTeam: null == winningTeam
                ? _value.winningTeam
                : winningTeam // ignore: cast_nullable_to_non_nullable
                      as int,
            team0Tricks: null == team0Tricks
                ? _value.team0Tricks
                : team0Tricks // ignore: cast_nullable_to_non_nullable
                      as int,
            team1Tricks: null == team1Tricks
                ? _value.team1Tricks
                : team1Tricks // ignore: cast_nullable_to_non_nullable
                      as int,
            resultType: null == resultType
                ? _value.resultType
                : resultType // ignore: cast_nullable_to_non_nullable
                      as String,
            callerPosition: freezed == callerPosition
                ? _value.callerPosition
                : callerPosition // ignore: cast_nullable_to_non_nullable
                      as int?,
            cheatDetected: freezed == cheatDetected
                ? _value.cheatDetected
                : cheatDetected // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameResultImplCopyWith<$Res>
    implements $GameResultCopyWith<$Res> {
  factory _$$GameResultImplCopyWith(
    _$GameResultImpl value,
    $Res Function(_$GameResultImpl) then,
  ) = __$$GameResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int winningTeam,
    int team0Tricks,
    int team1Tricks,
    String resultType,
    int? callerPosition,
    bool? cheatDetected,
  });
}

/// @nodoc
class __$$GameResultImplCopyWithImpl<$Res>
    extends _$GameResultCopyWithImpl<$Res, _$GameResultImpl>
    implements _$$GameResultImplCopyWith<$Res> {
  __$$GameResultImplCopyWithImpl(
    _$GameResultImpl _value,
    $Res Function(_$GameResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winningTeam = null,
    Object? team0Tricks = null,
    Object? team1Tricks = null,
    Object? resultType = null,
    Object? callerPosition = freezed,
    Object? cheatDetected = freezed,
  }) {
    return _then(
      _$GameResultImpl(
        winningTeam: null == winningTeam
            ? _value.winningTeam
            : winningTeam // ignore: cast_nullable_to_non_nullable
                  as int,
        team0Tricks: null == team0Tricks
            ? _value.team0Tricks
            : team0Tricks // ignore: cast_nullable_to_non_nullable
                  as int,
        team1Tricks: null == team1Tricks
            ? _value.team1Tricks
            : team1Tricks // ignore: cast_nullable_to_non_nullable
                  as int,
        resultType: null == resultType
            ? _value.resultType
            : resultType // ignore: cast_nullable_to_non_nullable
                  as String,
        callerPosition: freezed == callerPosition
            ? _value.callerPosition
            : callerPosition // ignore: cast_nullable_to_non_nullable
                  as int?,
        cheatDetected: freezed == cheatDetected
            ? _value.cheatDetected
            : cheatDetected // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameResultImpl implements _GameResult {
  const _$GameResultImpl({
    required this.winningTeam,
    required this.team0Tricks,
    required this.team1Tricks,
    required this.resultType,
    this.callerPosition,
    this.cheatDetected,
  });

  factory _$GameResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameResultImplFromJson(json);

  @override
  final int winningTeam;
  // 0 or 1
  @override
  final int team0Tricks;
  @override
  final int team1Tricks;
  @override
  final String resultType;
  // 'normal', '7-0', '13-0', 'callout-win', 'callout-loss'
  @override
  final int? callerPosition;
  // Position of player who called out (null for normal wins)
  @override
  final bool? cheatDetected;

  @override
  String toString() {
    return 'GameResult(winningTeam: $winningTeam, team0Tricks: $team0Tricks, team1Tricks: $team1Tricks, resultType: $resultType, callerPosition: $callerPosition, cheatDetected: $cheatDetected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameResultImpl &&
            (identical(other.winningTeam, winningTeam) ||
                other.winningTeam == winningTeam) &&
            (identical(other.team0Tricks, team0Tricks) ||
                other.team0Tricks == team0Tricks) &&
            (identical(other.team1Tricks, team1Tricks) ||
                other.team1Tricks == team1Tricks) &&
            (identical(other.resultType, resultType) ||
                other.resultType == resultType) &&
            (identical(other.callerPosition, callerPosition) ||
                other.callerPosition == callerPosition) &&
            (identical(other.cheatDetected, cheatDetected) ||
                other.cheatDetected == cheatDetected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    winningTeam,
    team0Tricks,
    team1Tricks,
    resultType,
    callerPosition,
    cheatDetected,
  );

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameResultImplCopyWith<_$GameResultImpl> get copyWith =>
      __$$GameResultImplCopyWithImpl<_$GameResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameResultImplToJson(this);
  }
}

abstract class _GameResult implements GameResult {
  const factory _GameResult({
    required final int winningTeam,
    required final int team0Tricks,
    required final int team1Tricks,
    required final String resultType,
    final int? callerPosition,
    final bool? cheatDetected,
  }) = _$GameResultImpl;

  factory _GameResult.fromJson(Map<String, dynamic> json) =
      _$GameResultImpl.fromJson;

  @override
  int get winningTeam; // 0 or 1
  @override
  int get team0Tricks;
  @override
  int get team1Tricks;
  @override
  String get resultType; // 'normal', '7-0', '13-0', 'callout-win', 'callout-loss'
  @override
  int? get callerPosition; // Position of player who called out (null for normal wins)
  @override
  bool? get cheatDetected;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameResultImplCopyWith<_$GameResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameModel _$GameModelFromJson(Map<String, dynamic> json) {
  return _GameModel.fromJson(json);
}

/// @nodoc
mixin _$GameModel {
  String get id => throw _privateConstructorUsedError;
  String get lobbyId => throw _privateConstructorUsedError;
  GamePhase get phase => throw _privateConstructorUsedError;
  List<GamePlayer> get players =>
      throw _privateConstructorUsedError; // 4 players
  int get dealerPosition =>
      throw _privateConstructorUsedError; // Who dealt this hand
  int get trumpMakerPosition =>
      throw _privateConstructorUsedError; // Position 0 (left of dealer)
  CardSuit? get trumpSuit =>
      throw _privateConstructorUsedError; // null until trump is selected
  TrickModel? get currentTrick =>
      throw _privateConstructorUsedError; // null if between tricks or game ended
  List<TrickModel> get completedTricks =>
      throw _privateConstructorUsedError; // History of tricks
  int get team0TricksWon => throw _privateConstructorUsedError;
  int get team1TricksWon => throw _privateConstructorUsedError;
  String get team0Name => throw _privateConstructorUsedError;
  String get team1Name => throw _privateConstructorUsedError;
  GameResult? get result =>
      throw _privateConstructorUsedError; // null until game ends
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get endedAt =>
      throw _privateConstructorUsedError; // Trump selection state
  List<CardModel>? get trumpMakerFirstFive =>
      throw _privateConstructorUsedError; // First 5 cards shown to trump maker
  List<CardModel>? get trumpMakerLastFour =>
      throw _privateConstructorUsedError; // Last 4 cards (if deferred)
  int? get reshuffleCount =>
      throw _privateConstructorUsedError; // Number of reshuffles (max 2)
  // Cheating tracking - maps player position to suits they claimed not to have
  Map<int, List<String>> get playerSuitClaims =>
      throw _privateConstructorUsedError;

  /// Serializes this GameModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameModelCopyWith<GameModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameModelCopyWith<$Res> {
  factory $GameModelCopyWith(GameModel value, $Res Function(GameModel) then) =
      _$GameModelCopyWithImpl<$Res, GameModel>;
  @useResult
  $Res call({
    String id,
    String lobbyId,
    GamePhase phase,
    List<GamePlayer> players,
    int dealerPosition,
    int trumpMakerPosition,
    CardSuit? trumpSuit,
    TrickModel? currentTrick,
    List<TrickModel> completedTricks,
    int team0TricksWon,
    int team1TricksWon,
    String team0Name,
    String team1Name,
    GameResult? result,
    DateTime createdAt,
    DateTime? endedAt,
    List<CardModel>? trumpMakerFirstFive,
    List<CardModel>? trumpMakerLastFour,
    int? reshuffleCount,
    Map<int, List<String>> playerSuitClaims,
  });

  $TrickModelCopyWith<$Res>? get currentTrick;
  $GameResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$GameModelCopyWithImpl<$Res, $Val extends GameModel>
    implements $GameModelCopyWith<$Res> {
  _$GameModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lobbyId = null,
    Object? phase = null,
    Object? players = null,
    Object? dealerPosition = null,
    Object? trumpMakerPosition = null,
    Object? trumpSuit = freezed,
    Object? currentTrick = freezed,
    Object? completedTricks = null,
    Object? team0TricksWon = null,
    Object? team1TricksWon = null,
    Object? team0Name = null,
    Object? team1Name = null,
    Object? result = freezed,
    Object? createdAt = null,
    Object? endedAt = freezed,
    Object? trumpMakerFirstFive = freezed,
    Object? trumpMakerLastFour = freezed,
    Object? reshuffleCount = freezed,
    Object? playerSuitClaims = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            lobbyId: null == lobbyId
                ? _value.lobbyId
                : lobbyId // ignore: cast_nullable_to_non_nullable
                      as String,
            phase: null == phase
                ? _value.phase
                : phase // ignore: cast_nullable_to_non_nullable
                      as GamePhase,
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<GamePlayer>,
            dealerPosition: null == dealerPosition
                ? _value.dealerPosition
                : dealerPosition // ignore: cast_nullable_to_non_nullable
                      as int,
            trumpMakerPosition: null == trumpMakerPosition
                ? _value.trumpMakerPosition
                : trumpMakerPosition // ignore: cast_nullable_to_non_nullable
                      as int,
            trumpSuit: freezed == trumpSuit
                ? _value.trumpSuit
                : trumpSuit // ignore: cast_nullable_to_non_nullable
                      as CardSuit?,
            currentTrick: freezed == currentTrick
                ? _value.currentTrick
                : currentTrick // ignore: cast_nullable_to_non_nullable
                      as TrickModel?,
            completedTricks: null == completedTricks
                ? _value.completedTricks
                : completedTricks // ignore: cast_nullable_to_non_nullable
                      as List<TrickModel>,
            team0TricksWon: null == team0TricksWon
                ? _value.team0TricksWon
                : team0TricksWon // ignore: cast_nullable_to_non_nullable
                      as int,
            team1TricksWon: null == team1TricksWon
                ? _value.team1TricksWon
                : team1TricksWon // ignore: cast_nullable_to_non_nullable
                      as int,
            team0Name: null == team0Name
                ? _value.team0Name
                : team0Name // ignore: cast_nullable_to_non_nullable
                      as String,
            team1Name: null == team1Name
                ? _value.team1Name
                : team1Name // ignore: cast_nullable_to_non_nullable
                      as String,
            result: freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as GameResult?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            trumpMakerFirstFive: freezed == trumpMakerFirstFive
                ? _value.trumpMakerFirstFive
                : trumpMakerFirstFive // ignore: cast_nullable_to_non_nullable
                      as List<CardModel>?,
            trumpMakerLastFour: freezed == trumpMakerLastFour
                ? _value.trumpMakerLastFour
                : trumpMakerLastFour // ignore: cast_nullable_to_non_nullable
                      as List<CardModel>?,
            reshuffleCount: freezed == reshuffleCount
                ? _value.reshuffleCount
                : reshuffleCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            playerSuitClaims: null == playerSuitClaims
                ? _value.playerSuitClaims
                : playerSuitClaims // ignore: cast_nullable_to_non_nullable
                      as Map<int, List<String>>,
          )
          as $Val,
    );
  }

  /// Create a copy of GameModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TrickModelCopyWith<$Res>? get currentTrick {
    if (_value.currentTrick == null) {
      return null;
    }

    return $TrickModelCopyWith<$Res>(_value.currentTrick!, (value) {
      return _then(_value.copyWith(currentTrick: value) as $Val);
    });
  }

  /// Create a copy of GameModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $GameResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameModelImplCopyWith<$Res>
    implements $GameModelCopyWith<$Res> {
  factory _$$GameModelImplCopyWith(
    _$GameModelImpl value,
    $Res Function(_$GameModelImpl) then,
  ) = __$$GameModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String lobbyId,
    GamePhase phase,
    List<GamePlayer> players,
    int dealerPosition,
    int trumpMakerPosition,
    CardSuit? trumpSuit,
    TrickModel? currentTrick,
    List<TrickModel> completedTricks,
    int team0TricksWon,
    int team1TricksWon,
    String team0Name,
    String team1Name,
    GameResult? result,
    DateTime createdAt,
    DateTime? endedAt,
    List<CardModel>? trumpMakerFirstFive,
    List<CardModel>? trumpMakerLastFour,
    int? reshuffleCount,
    Map<int, List<String>> playerSuitClaims,
  });

  @override
  $TrickModelCopyWith<$Res>? get currentTrick;
  @override
  $GameResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$GameModelImplCopyWithImpl<$Res>
    extends _$GameModelCopyWithImpl<$Res, _$GameModelImpl>
    implements _$$GameModelImplCopyWith<$Res> {
  __$$GameModelImplCopyWithImpl(
    _$GameModelImpl _value,
    $Res Function(_$GameModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lobbyId = null,
    Object? phase = null,
    Object? players = null,
    Object? dealerPosition = null,
    Object? trumpMakerPosition = null,
    Object? trumpSuit = freezed,
    Object? currentTrick = freezed,
    Object? completedTricks = null,
    Object? team0TricksWon = null,
    Object? team1TricksWon = null,
    Object? team0Name = null,
    Object? team1Name = null,
    Object? result = freezed,
    Object? createdAt = null,
    Object? endedAt = freezed,
    Object? trumpMakerFirstFive = freezed,
    Object? trumpMakerLastFour = freezed,
    Object? reshuffleCount = freezed,
    Object? playerSuitClaims = null,
  }) {
    return _then(
      _$GameModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        lobbyId: null == lobbyId
            ? _value.lobbyId
            : lobbyId // ignore: cast_nullable_to_non_nullable
                  as String,
        phase: null == phase
            ? _value.phase
            : phase // ignore: cast_nullable_to_non_nullable
                  as GamePhase,
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<GamePlayer>,
        dealerPosition: null == dealerPosition
            ? _value.dealerPosition
            : dealerPosition // ignore: cast_nullable_to_non_nullable
                  as int,
        trumpMakerPosition: null == trumpMakerPosition
            ? _value.trumpMakerPosition
            : trumpMakerPosition // ignore: cast_nullable_to_non_nullable
                  as int,
        trumpSuit: freezed == trumpSuit
            ? _value.trumpSuit
            : trumpSuit // ignore: cast_nullable_to_non_nullable
                  as CardSuit?,
        currentTrick: freezed == currentTrick
            ? _value.currentTrick
            : currentTrick // ignore: cast_nullable_to_non_nullable
                  as TrickModel?,
        completedTricks: null == completedTricks
            ? _value._completedTricks
            : completedTricks // ignore: cast_nullable_to_non_nullable
                  as List<TrickModel>,
        team0TricksWon: null == team0TricksWon
            ? _value.team0TricksWon
            : team0TricksWon // ignore: cast_nullable_to_non_nullable
                  as int,
        team1TricksWon: null == team1TricksWon
            ? _value.team1TricksWon
            : team1TricksWon // ignore: cast_nullable_to_non_nullable
                  as int,
        team0Name: null == team0Name
            ? _value.team0Name
            : team0Name // ignore: cast_nullable_to_non_nullable
                  as String,
        team1Name: null == team1Name
            ? _value.team1Name
            : team1Name // ignore: cast_nullable_to_non_nullable
                  as String,
        result: freezed == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as GameResult?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        trumpMakerFirstFive: freezed == trumpMakerFirstFive
            ? _value._trumpMakerFirstFive
            : trumpMakerFirstFive // ignore: cast_nullable_to_non_nullable
                  as List<CardModel>?,
        trumpMakerLastFour: freezed == trumpMakerLastFour
            ? _value._trumpMakerLastFour
            : trumpMakerLastFour // ignore: cast_nullable_to_non_nullable
                  as List<CardModel>?,
        reshuffleCount: freezed == reshuffleCount
            ? _value.reshuffleCount
            : reshuffleCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        playerSuitClaims: null == playerSuitClaims
            ? _value._playerSuitClaims
            : playerSuitClaims // ignore: cast_nullable_to_non_nullable
                  as Map<int, List<String>>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameModelImpl extends _GameModel {
  const _$GameModelImpl({
    required this.id,
    required this.lobbyId,
    required this.phase,
    required final List<GamePlayer> players,
    required this.dealerPosition,
    required this.trumpMakerPosition,
    this.trumpSuit,
    required this.currentTrick,
    required final List<TrickModel> completedTricks,
    required this.team0TricksWon,
    required this.team1TricksWon,
    this.team0Name = 'Team 1',
    this.team1Name = 'Team 2',
    this.result,
    required this.createdAt,
    this.endedAt,
    final List<CardModel>? trumpMakerFirstFive,
    final List<CardModel>? trumpMakerLastFour,
    this.reshuffleCount,
    final Map<int, List<String>> playerSuitClaims = const {},
  }) : _players = players,
       _completedTricks = completedTricks,
       _trumpMakerFirstFive = trumpMakerFirstFive,
       _trumpMakerLastFour = trumpMakerLastFour,
       _playerSuitClaims = playerSuitClaims,
       super._();

  factory _$GameModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameModelImplFromJson(json);

  @override
  final String id;
  @override
  final String lobbyId;
  @override
  final GamePhase phase;
  final List<GamePlayer> _players;
  @override
  List<GamePlayer> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  // 4 players
  @override
  final int dealerPosition;
  // Who dealt this hand
  @override
  final int trumpMakerPosition;
  // Position 0 (left of dealer)
  @override
  final CardSuit? trumpSuit;
  // null until trump is selected
  @override
  final TrickModel? currentTrick;
  // null if between tricks or game ended
  final List<TrickModel> _completedTricks;
  // null if between tricks or game ended
  @override
  List<TrickModel> get completedTricks {
    if (_completedTricks is EqualUnmodifiableListView) return _completedTricks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedTricks);
  }

  // History of tricks
  @override
  final int team0TricksWon;
  @override
  final int team1TricksWon;
  @override
  @JsonKey()
  final String team0Name;
  @override
  @JsonKey()
  final String team1Name;
  @override
  final GameResult? result;
  // null until game ends
  @override
  final DateTime createdAt;
  @override
  final DateTime? endedAt;
  // Trump selection state
  final List<CardModel>? _trumpMakerFirstFive;
  // Trump selection state
  @override
  List<CardModel>? get trumpMakerFirstFive {
    final value = _trumpMakerFirstFive;
    if (value == null) return null;
    if (_trumpMakerFirstFive is EqualUnmodifiableListView)
      return _trumpMakerFirstFive;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // First 5 cards shown to trump maker
  final List<CardModel>? _trumpMakerLastFour;
  // First 5 cards shown to trump maker
  @override
  List<CardModel>? get trumpMakerLastFour {
    final value = _trumpMakerLastFour;
    if (value == null) return null;
    if (_trumpMakerLastFour is EqualUnmodifiableListView)
      return _trumpMakerLastFour;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // Last 4 cards (if deferred)
  @override
  final int? reshuffleCount;
  // Number of reshuffles (max 2)
  // Cheating tracking - maps player position to suits they claimed not to have
  final Map<int, List<String>> _playerSuitClaims;
  // Number of reshuffles (max 2)
  // Cheating tracking - maps player position to suits they claimed not to have
  @override
  @JsonKey()
  Map<int, List<String>> get playerSuitClaims {
    if (_playerSuitClaims is EqualUnmodifiableMapView) return _playerSuitClaims;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_playerSuitClaims);
  }

  @override
  String toString() {
    return 'GameModel(id: $id, lobbyId: $lobbyId, phase: $phase, players: $players, dealerPosition: $dealerPosition, trumpMakerPosition: $trumpMakerPosition, trumpSuit: $trumpSuit, currentTrick: $currentTrick, completedTricks: $completedTricks, team0TricksWon: $team0TricksWon, team1TricksWon: $team1TricksWon, team0Name: $team0Name, team1Name: $team1Name, result: $result, createdAt: $createdAt, endedAt: $endedAt, trumpMakerFirstFive: $trumpMakerFirstFive, trumpMakerLastFour: $trumpMakerLastFour, reshuffleCount: $reshuffleCount, playerSuitClaims: $playerSuitClaims)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lobbyId, lobbyId) || other.lobbyId == lobbyId) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.dealerPosition, dealerPosition) ||
                other.dealerPosition == dealerPosition) &&
            (identical(other.trumpMakerPosition, trumpMakerPosition) ||
                other.trumpMakerPosition == trumpMakerPosition) &&
            (identical(other.trumpSuit, trumpSuit) ||
                other.trumpSuit == trumpSuit) &&
            (identical(other.currentTrick, currentTrick) ||
                other.currentTrick == currentTrick) &&
            const DeepCollectionEquality().equals(
              other._completedTricks,
              _completedTricks,
            ) &&
            (identical(other.team0TricksWon, team0TricksWon) ||
                other.team0TricksWon == team0TricksWon) &&
            (identical(other.team1TricksWon, team1TricksWon) ||
                other.team1TricksWon == team1TricksWon) &&
            (identical(other.team0Name, team0Name) ||
                other.team0Name == team0Name) &&
            (identical(other.team1Name, team1Name) ||
                other.team1Name == team1Name) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            const DeepCollectionEquality().equals(
              other._trumpMakerFirstFive,
              _trumpMakerFirstFive,
            ) &&
            const DeepCollectionEquality().equals(
              other._trumpMakerLastFour,
              _trumpMakerLastFour,
            ) &&
            (identical(other.reshuffleCount, reshuffleCount) ||
                other.reshuffleCount == reshuffleCount) &&
            const DeepCollectionEquality().equals(
              other._playerSuitClaims,
              _playerSuitClaims,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    lobbyId,
    phase,
    const DeepCollectionEquality().hash(_players),
    dealerPosition,
    trumpMakerPosition,
    trumpSuit,
    currentTrick,
    const DeepCollectionEquality().hash(_completedTricks),
    team0TricksWon,
    team1TricksWon,
    team0Name,
    team1Name,
    result,
    createdAt,
    endedAt,
    const DeepCollectionEquality().hash(_trumpMakerFirstFive),
    const DeepCollectionEquality().hash(_trumpMakerLastFour),
    reshuffleCount,
    const DeepCollectionEquality().hash(_playerSuitClaims),
  ]);

  /// Create a copy of GameModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameModelImplCopyWith<_$GameModelImpl> get copyWith =>
      __$$GameModelImplCopyWithImpl<_$GameModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameModelImplToJson(this);
  }
}

abstract class _GameModel extends GameModel {
  const factory _GameModel({
    required final String id,
    required final String lobbyId,
    required final GamePhase phase,
    required final List<GamePlayer> players,
    required final int dealerPosition,
    required final int trumpMakerPosition,
    final CardSuit? trumpSuit,
    required final TrickModel? currentTrick,
    required final List<TrickModel> completedTricks,
    required final int team0TricksWon,
    required final int team1TricksWon,
    final String team0Name,
    final String team1Name,
    final GameResult? result,
    required final DateTime createdAt,
    final DateTime? endedAt,
    final List<CardModel>? trumpMakerFirstFive,
    final List<CardModel>? trumpMakerLastFour,
    final int? reshuffleCount,
    final Map<int, List<String>> playerSuitClaims,
  }) = _$GameModelImpl;
  const _GameModel._() : super._();

  factory _GameModel.fromJson(Map<String, dynamic> json) =
      _$GameModelImpl.fromJson;

  @override
  String get id;
  @override
  String get lobbyId;
  @override
  GamePhase get phase;
  @override
  List<GamePlayer> get players; // 4 players
  @override
  int get dealerPosition; // Who dealt this hand
  @override
  int get trumpMakerPosition; // Position 0 (left of dealer)
  @override
  CardSuit? get trumpSuit; // null until trump is selected
  @override
  TrickModel? get currentTrick; // null if between tricks or game ended
  @override
  List<TrickModel> get completedTricks; // History of tricks
  @override
  int get team0TricksWon;
  @override
  int get team1TricksWon;
  @override
  String get team0Name;
  @override
  String get team1Name;
  @override
  GameResult? get result; // null until game ends
  @override
  DateTime get createdAt;
  @override
  DateTime? get endedAt; // Trump selection state
  @override
  List<CardModel>? get trumpMakerFirstFive; // First 5 cards shown to trump maker
  @override
  List<CardModel>? get trumpMakerLastFour; // Last 4 cards (if deferred)
  @override
  int? get reshuffleCount; // Number of reshuffles (max 2)
  // Cheating tracking - maps player position to suits they claimed not to have
  @override
  Map<int, List<String>> get playerSuitClaims;

  /// Create a copy of GameModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameModelImplCopyWith<_$GameModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
