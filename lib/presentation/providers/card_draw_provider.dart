import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/card_model.dart';
import '../../data/repositories/card_draw_repository.dart';
import '../../domain/services/bot_ai_service.dart';

/// Provider for CardDrawRepository
final cardDrawRepositoryProvider = Provider<CardDrawRepository>((ref) {
  return CardDrawRepository();
});

/// Provider for BotAIService
final botAIServiceProvider = Provider<BotAIService>((ref) {
  return BotAIService();
});

/// Controller for card draw operations
class CardDrawController extends StateNotifier<AsyncValue<void>> {
  final CardDrawRepository _cardDrawRepository;
  final BotAIService _botAIService;

  CardDrawController(this._cardDrawRepository, this._botAIService)
      : super(const AsyncValue.data(null));

  /// Start card draw phase for a lobby
  Future<void> startCardDraw(String lobbyId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _cardDrawRepository.startCardDraw(lobbyId);
    });
  }

  /// Pick a card for a player position
  Future<void> pickCard({
    required String lobbyId,
    required int position,
    required CardModel card,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _cardDrawRepository.pickCard(
        lobbyId: lobbyId,
        position: position,
        card: card,
      );
    });
  }

  /// Bot picks a random card
  Future<void> botPickCard({
    required String lobbyId,
    required int position,
    required List<CardModel> availableCards,
  }) async {
    if (availableCards.isEmpty) {
      return;
    }

    // Bot selects a random card
    final selectedCard = _botAIService.selectCardForDraw(availableCards);

    await pickCard(
      lobbyId: lobbyId,
      position: position,
      card: selectedCard,
    );
  }
}

/// Provider for CardDrawController
final cardDrawControllerProvider =
    StateNotifierProvider<CardDrawController, AsyncValue<void>>((ref) {
  final cardDrawRepository = ref.watch(cardDrawRepositoryProvider);
  final botAIService = ref.watch(botAIServiceProvider);
  return CardDrawController(cardDrawRepository, botAIService);
});
