import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/features/favorites/domain/entities/favorite_entity.dart';
import 'package:dairymart/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:dairymart/features/favorites/domain/usecases/toggle_favorite_usecase.dart';
import 'package:dairymart/features/favorites/domain/usecases/check_favorite_usecase.dart';
import 'package:dairymart/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:dairymart/core/usecases/usecase.dart';

// ========== USE CASE PROVIDERS ==========
final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>((ref) {
  return GetFavoritesUseCase(ref.read(favoriteRepositoryProvider));
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref) {
  return ToggleFavoriteUseCase(ref.read(favoriteRepositoryProvider));
});

final checkFavoriteUseCaseProvider = Provider<CheckFavoriteUseCase>((ref) {
  return CheckFavoriteUseCase(ref.read(favoriteRepositoryProvider));
});

// ========== STATE WRAPPER ==========
class FavoritesState {
  final bool isLoading;
  final List<FavoriteEntity> favorites;
  final String? error;

  FavoritesState({this.isLoading = false, this.favorites = const [], this.error});

  FavoritesState copyWith({bool? isLoading, List<FavoriteEntity>? favorites, String? error}) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      favorites: favorites ?? this.favorites,
      error: error,
    );
  }
}

// ========== NOTIFIER ==========
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  FavoritesNotifier({
    required GetFavoritesUseCase getFavoritesUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
  })  : _getFavoritesUseCase = getFavoritesUseCase,
        _toggleFavoriteUseCase = toggleFavoriteUseCase,
        super(FavoritesState()) {
    getFavorites();
  }

  Future<void> getFavorites() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getFavoritesUseCase(NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (favorites) => state = state.copyWith(isLoading: false, favorites: favorites),
    );
  }

  Future<void> toggleFavorite(String productId) async {
    final result = await _toggleFavoriteUseCase(productId);
    
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (isFavorited) {
        getFavorites(); 
      },
    );
  }
}

// ========== PROVIDERS ==========
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(
    getFavoritesUseCase: ref.read(getFavoritesUseCaseProvider),
    toggleFavoriteUseCase: ref.read(toggleFavoriteUseCaseProvider),
  );
});

final favoriteStatusProvider = FutureProvider.family<bool, String>((ref, productId) async {
  final checkFavoriteUseCase = ref.read(checkFavoriteUseCaseProvider);
  final result = await checkFavoriteUseCase(productId);
  return result.fold((l) => false, (r) => r);
});


