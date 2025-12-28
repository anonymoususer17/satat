import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lobby_model.dart';

/// Repository for lobby operations
class LobbyRepository {
  final FirebaseFirestore _firestore;

  LobbyRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Generate a unique 6-digit lobby code
  String _generateLobbyCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Create a new lobby
  Future<LobbyModel> createLobby({
    required String hostUserId,
    required String hostUsername,
  }) async {
    try {
      // Generate unique code
      String code = _generateLobbyCode();

      // Check if code already exists (very unlikely but possible)
      var existingLobby = await _firestore
          .collection('lobbies')
          .where('code', isEqualTo: code)
          .where('status', isEqualTo: LobbyStatus.waiting.name)
          .limit(1)
          .get();

      // Regenerate if code exists
      while (existingLobby.docs.isNotEmpty) {
        code = _generateLobbyCode();
        existingLobby = await _firestore
            .collection('lobbies')
            .where('code', isEqualTo: code)
            .where('status', isEqualTo: LobbyStatus.waiting.name)
            .limit(1)
            .get();
      }

      // Create lobby document
      final lobbyRef = _firestore.collection('lobbies').doc();
      final lobby = createEmptyLobby(
        id: lobbyRef.id,
        hostUserId: hostUserId,
        hostUsername: hostUsername,
        code: code,
      );

      await lobbyRef.set(_lobbyToFirestore(lobby));

      return lobby;
    } catch (e) {
      throw Exception('Failed to create lobby: ${e.toString()}');
    }
  }

  /// Get lobby by ID
  Future<LobbyModel> getLobbyById(String lobbyId) async {
    try {
      final doc = await _firestore.collection('lobbies').doc(lobbyId).get();

      if (!doc.exists) {
        throw Exception('Lobby not found');
      }

      return _lobbyFromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get lobby: ${e.toString()}');
    }
  }

  /// Get lobby by code
  Future<LobbyModel> getLobbyByCode(String code) async {
    try {
      final query = await _firestore
          .collection('lobbies')
          .where('code', isEqualTo: code)
          .where('status', isEqualTo: LobbyStatus.waiting.name)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('Lobby not found or already started');
      }

      return _lobbyFromFirestore(query.docs.first);
    } catch (e) {
      throw Exception('Failed to find lobby: ${e.toString()}');
    }
  }

  /// Watch lobby changes (real-time)
  Stream<LobbyModel> watchLobby(String lobbyId) {
    return _firestore
        .collection('lobbies')
        .doc(lobbyId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception('Lobby not found');
      }
      return _lobbyFromFirestore(doc);
    });
  }

  /// Get active lobbies list
  Stream<List<LobbyModel>> watchActiveLobbies() {
    return _firestore
        .collection('lobbies')
        .where('status', isEqualTo: LobbyStatus.waiting.name)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _lobbyFromFirestore(doc)).toList());
  }

  /// Join lobby
  Future<void> joinLobby({
    required String lobbyId,
    required String userId,
    required String username,
    required String displayName,
  }) async {
    try {
      final lobbyRef = _firestore.collection('lobbies').doc(lobbyId);
      final lobbyDoc = await lobbyRef.get();

      if (!lobbyDoc.exists) {
        throw Exception('Lobby not found');
      }

      final lobby = _lobbyFromFirestore(lobbyDoc);

      if (lobby.status != LobbyStatus.waiting) {
        throw Exception('Lobby is not available');
      }

      // Check if user is already in lobby
      if (lobby.players.any((p) => p.userId == userId)) {
        throw Exception('You are already in this lobby');
      }

      // Find first empty slot
      final emptySlotIndex =
          lobby.players.indexWhere((p) => p.userId == null && !p.isBot);

      if (emptySlotIndex == -1) {
        throw Exception('Lobby is full');
      }

      // Update the slot
      final updatedPlayers = List<PlayerSlot>.from(lobby.players);
      updatedPlayers[emptySlotIndex] = PlayerSlot(
        position: emptySlotIndex,
        userId: userId,
        username: username,
        displayName: displayName,
        isBot: false,
        isReady: false,
      );

      await lobbyRef.update({
        'players': updatedPlayers.map((p) => _playerSlotToMap(p)).toList(),
      });
    } catch (e) {
      throw Exception('Failed to join lobby: ${e.toString()}');
    }
  }

  /// Leave lobby
  Future<void> leaveLobby({
    required String lobbyId,
    required String userId,
  }) async {
    try {
      final lobbyRef = _firestore.collection('lobbies').doc(lobbyId);
      final lobbyDoc = await lobbyRef.get();

      if (!lobbyDoc.exists) {
        return; // Lobby doesn't exist, nothing to do
      }

      final lobby = _lobbyFromFirestore(lobbyDoc);

      // Find player's slot
      final playerSlotIndex =
          lobby.players.indexWhere((p) => p.userId == userId);

      if (playerSlotIndex == -1) {
        return; // Player not in lobby
      }

      // If host is leaving and lobby has other players, assign new host
      if (lobby.hostUserId == userId) {
        final otherPlayer =
            lobby.players.firstWhere((p) => p.userId != null && p.userId != userId,
                orElse: () => const PlayerSlot(position: 0, isBot: false, isReady: false));

        if (otherPlayer.userId != null) {
          // Transfer host to another player
          final updatedPlayers = List<PlayerSlot>.from(lobby.players);
          updatedPlayers[playerSlotIndex] = PlayerSlot(
            position: playerSlotIndex,
            isBot: false,
            isReady: false,
          );

          await lobbyRef.update({
            'hostUserId': otherPlayer.userId,
            'hostUsername': otherPlayer.username,
            'players': updatedPlayers.map((p) => _playerSlotToMap(p)).toList(),
          });
          return;
        } else {
          // Last player leaving, delete lobby
          await lobbyRef.delete();
          return;
        }
      }

      // Clear the player's slot
      final updatedPlayers = List<PlayerSlot>.from(lobby.players);
      updatedPlayers[playerSlotIndex] = PlayerSlot(
        position: playerSlotIndex,
        isBot: false,
        isReady: false,
      );

      await lobbyRef.update({
        'players': updatedPlayers.map((p) => _playerSlotToMap(p)).toList(),
      });
    } catch (e) {
      throw Exception('Failed to leave lobby: ${e.toString()}');
    }
  }

  /// Toggle ready status
  Future<void> toggleReady({
    required String lobbyId,
    required String userId,
  }) async {
    try {
      final lobbyRef = _firestore.collection('lobbies').doc(lobbyId);
      final lobbyDoc = await lobbyRef.get();

      if (!lobbyDoc.exists) {
        throw Exception('Lobby not found');
      }

      final lobby = _lobbyFromFirestore(lobbyDoc);

      // Find player's slot
      final playerSlotIndex =
          lobby.players.indexWhere((p) => p.userId == userId);

      if (playerSlotIndex == -1) {
        throw Exception('You are not in this lobby');
      }

      final player = lobby.players[playerSlotIndex];
      final updatedPlayers = List<PlayerSlot>.from(lobby.players);
      updatedPlayers[playerSlotIndex] = PlayerSlot(
        position: player.position,
        userId: player.userId,
        username: player.username,
        displayName: player.displayName,
        isBot: player.isBot,
        isReady: !player.isReady,
      );

      await lobbyRef.update({
        'players': updatedPlayers.map((p) => _playerSlotToMap(p)).toList(),
      });
    } catch (e) {
      throw Exception('Failed to toggle ready: ${e.toString()}');
    }
  }

  /// Add bot to empty slot
  Future<void> addBot({
    required String lobbyId,
    required int position,
  }) async {
    try {
      final lobbyRef = _firestore.collection('lobbies').doc(lobbyId);
      final lobbyDoc = await lobbyRef.get();

      if (!lobbyDoc.exists) {
        throw Exception('Lobby not found');
      }

      final lobby = _lobbyFromFirestore(lobbyDoc);

      if (position < 0 || position >= 4) {
        throw Exception('Invalid position');
      }

      final slot = lobby.players[position];

      if (slot.userId != null || slot.isBot) {
        throw Exception('Slot is not empty');
      }

      final updatedPlayers = List<PlayerSlot>.from(lobby.players);
      updatedPlayers[position] = PlayerSlot(
        position: position,
        username: 'Bot ${position + 1}',
        displayName: 'Bot ${position + 1}',
        isBot: true,
        isReady: true, // Bots are always ready
      );

      await lobbyRef.update({
        'players': updatedPlayers.map((p) => _playerSlotToMap(p)).toList(),
      });
    } catch (e) {
      throw Exception('Failed to add bot: ${e.toString()}');
    }
  }

  /// Remove bot or kick player
  Future<void> removePlayerFromSlot({
    required String lobbyId,
    required int position,
    required String requestingUserId,
  }) async {
    try {
      final lobbyRef = _firestore.collection('lobbies').doc(lobbyId);
      final lobbyDoc = await lobbyRef.get();

      if (!lobbyDoc.exists) {
        throw Exception('Lobby not found');
      }

      final lobby = _lobbyFromFirestore(lobbyDoc);

      // Only host can remove players/bots
      if (lobby.hostUserId != requestingUserId) {
        throw Exception('Only the host can remove players');
      }

      if (position < 0 || position >= 4) {
        throw Exception('Invalid position');
      }

      final slot = lobby.players[position];

      if (slot.userId == lobby.hostUserId) {
        throw Exception('Host cannot be removed');
      }

      final updatedPlayers = List<PlayerSlot>.from(lobby.players);
      updatedPlayers[position] = PlayerSlot(
        position: position,
        isBot: false,
        isReady: false,
      );

      await lobbyRef.update({
        'players': updatedPlayers.map((p) => _playerSlotToMap(p)).toList(),
      });
    } catch (e) {
      throw Exception('Failed to remove player: ${e.toString()}');
    }
  }

  /// Convert LobbyModel to Firestore format
  Map<String, dynamic> _lobbyToFirestore(LobbyModel lobby) {
    return {
      'id': lobby.id,
      'hostUserId': lobby.hostUserId,
      'hostUsername': lobby.hostUsername,
      'code': lobby.code,
      'status': lobby.status.name,
      'createdAt': FieldValue.serverTimestamp(),
      'players': lobby.players.map((p) => _playerSlotToMap(p)).toList(),
      'gameId': lobby.gameId,
    };
  }

  /// Convert PlayerSlot to Map
  Map<String, dynamic> _playerSlotToMap(PlayerSlot slot) {
    return {
      'position': slot.position,
      'userId': slot.userId,
      'username': slot.username,
      'displayName': slot.displayName,
      'isBot': slot.isBot,
      'isReady': slot.isReady,
    };
  }

  /// Convert Firestore document to LobbyModel
  LobbyModel _lobbyFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final playersData = data['players'] as List<dynamic>? ?? [];
    final players = playersData.map((p) {
      final playerMap = p as Map<String, dynamic>;
      return PlayerSlot(
        position: playerMap['position'] as int,
        userId: playerMap['userId'] as String?,
        username: playerMap['username'] as String?,
        displayName: playerMap['displayName'] as String?,
        isBot: playerMap['isBot'] as bool? ?? false,
        isReady: playerMap['isReady'] as bool? ?? false,
      );
    }).toList();

    return LobbyModel(
      id: doc.id,
      hostUserId: data['hostUserId'] as String,
      hostUsername: data['hostUsername'] as String,
      code: data['code'] as String,
      status: LobbyStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => LobbyStatus.waiting,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      players: players,
      gameId: data['gameId'] as String?,
    );
  }
}
