import 'package:flutter/cupertino.dart';

import '../../domain/entities/favorite_dictionary_entity.dart';
import '../../domain/usecases/favorite_dictionary_use_case.dart';

class FavoriteWordsState extends ChangeNotifier {
  final FavoriteDictionaryUseCase _favoriteDictionaryUseCase;

  FavoriteWordsState(this._favoriteDictionaryUseCase);

  Future<List<FavoriteDictionaryEntity>> fetchAllFavoriteWords() async {
    return await _favoriteDictionaryUseCase.fetchAllFavoriteWords();
  }

  Future<bool> fetchIsWordFavorite({required int wordNumber}) async {
    return await _favoriteDictionaryUseCase.fetchIsWordFavorite(wordId: wordNumber);
  }

  Future<List<FavoriteDictionaryEntity>> fetchFavoriteWordsByCollectionId({required int collectionId}) async {
    return await _favoriteDictionaryUseCase.fetchFavoriteWordsByCollectionId(collectionId: collectionId);
  }

  Future<FavoriteDictionaryEntity> fetchFavoriteWordById({required int favoriteWordId}) async {
    return await _favoriteDictionaryUseCase.fetchFavoriteWordById(favoriteWordId: favoriteWordId);
  }

  Future<void> addFavoriteWord({required FavoriteDictionaryEntity model}) async {
    await _favoriteDictionaryUseCase.fetchAddFavoriteWord(model: model);
    notifyListeners();
  }

  Future<void> changeFavoriteWord({required int favoriteWordId, required int serializableIndex}) async {
    await _favoriteDictionaryUseCase.fetchChangeFavoriteWord(wordId: favoriteWordId, serializableIndex: serializableIndex);
    notifyListeners();
  }

  Future<void> moveFavoriteWord({required int wordNumber, required int oldCollectionId, required int collectionId}) async {
    await _favoriteDictionaryUseCase.fetchMoveFavoriteWord(wordNr: wordNumber, oldCollectionId: oldCollectionId, collectionId: collectionId);
    notifyListeners();
  }

  Future<void> deleteFavoriteWord({required int favoriteWordId}) async {
    await _favoriteDictionaryUseCase.fetchDeleteFavoriteWord(favoriteWordId: favoriteWordId);
    notifyListeners();
  }
}
