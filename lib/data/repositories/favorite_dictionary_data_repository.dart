import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

import '../../core/strings/db_values.dart';
import '../../domain/entities/favorite_dictionary_entity.dart';
import '../../domain/repositories/favorite_dictionary_repository.dart';
import '../models/favorite_dictionary_model.dart';
import '../services/collections_service.dart';

class FavoriteDictionaryDataRepository implements FavoriteDictionaryRepository {
  final CollectionsService _collectionsService;

  const FavoriteDictionaryDataRepository(this._collectionsService);

  @override
  Future<List<FavoriteDictionaryEntity>> getAllFavoriteWords() async {
    final Database database = await _collectionsService.db;
    final List<Map<String, Object?>> resources = await database.query(DBValues.dbTableOfFavoriteWords);
    final List<FavoriteDictionaryEntity> allFavoriteWords = resources.isNotEmpty ? resources.map((c) => FavoriteDictionaryEntity.fromModel(FavoriteDictionaryModel.fromMap(c))).toList() : [];
    return allFavoriteWords;
  }

  @override
  Future<bool> isWordFavorite({required int wordNumber}) async {
    try {
      final Database database = await _collectionsService.db;
      final List<Map<String, Object?>> isFavorite = await database.query(
        DBValues.dbTableOfFavoriteWords,
        where: '${DBValues.dbWordNumber} = ?',
        whereArgs: [wordNumber],
      );
      return isFavorite.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<FavoriteDictionaryEntity>> getFavoriteWordsByCollectionId({required int collectionId}) async {
    final Database database = await _collectionsService.db;
    final List<Map<String, Object?>> resources = await database.query(DBValues.dbTableOfFavoriteWords, where: '${DBValues.dbCollectionId} = ?', whereArgs: [collectionId]);
    final List<FavoriteDictionaryEntity> collectionFavoriteWords = resources.isNotEmpty ? resources.map((c) => FavoriteDictionaryEntity.fromModel(FavoriteDictionaryModel.fromMap(c))).toList() : [];
    return collectionFavoriteWords;
  }

  @override
  Future<FavoriteDictionaryEntity> getFavoriteWordById({required int favoriteWordId}) async {
    final Database database = await _collectionsService.db;
    final List<Map<String, Object?>> resources = await database.query(DBValues.dbTableOfFavoriteWords, where: '${DBValues.dbWordNumber} = ?', whereArgs: [favoriteWordId]);
    final FavoriteDictionaryEntity? favoriteWordById = resources.isNotEmpty ? FavoriteDictionaryEntity.fromModel(FavoriteDictionaryModel.fromMap(resources.first)) : null;
    return favoriteWordById!;
  }

  @override
  Future<void> addFavoriteWord({required FavoriteDictionaryEntity model}) async {
    final Database database = await _collectionsService.db;

    FavoriteDictionaryModel favoriteWordModel = FavoriteDictionaryModel(
      articleId: model.articleId,
      translation: model.translation,
      arabic: model.arabic,
      id: model.id,
      wordNumber: model.wordNumber,
      arabicWord: model.arabicWord,
      form: model.form,
      additional: model.additional,
      vocalization: model.vocalization,
      homonymNr: model.homonymNr,
      root: model.root,
      forms: model.forms,
      collectionId: model.collectionId,
      serializableIndex: model.serializableIndex,
      ankiCount: model.ankiCount,
    );

    await database.transaction((txn) async {
      await txn.insert(DBValues.dbTableOfFavoriteWords, favoriteWordModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      await _updateCollectionWordCount(txn, model.collectionId);
    });
  }

  @override
  Future<void> changeFavoriteWord({required int wordNumber, required int serializableIndex}) async {
    final Database database = await _collectionsService.db;
    final Map<String, int> serializableMap = {
      DBValues.dbSerializableIndex: serializableIndex,
    };
    await database.update(DBValues.dbTableOfFavoriteWords, serializableMap, where: '${DBValues.dbWordNumber} = ?', whereArgs: [wordNumber], conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  @override
  Future<void> moveFavoriteWord({required int wordNumber, required int oldCollectionId, required int collectionId}) async {
    final Database database = await _collectionsService.db;
    await database.transaction((txn) async {
      await txn.update(DBValues.dbTableOfFavoriteWords, {DBValues.dbCollectionId: collectionId}, where: '${DBValues.dbWordNumber} = ?', whereArgs: [wordNumber], conflictAlgorithm: ConflictAlgorithm.replace);
      await _updateCollectionWordCount(txn, oldCollectionId);
      await _updateCollectionWordCount(txn, collectionId);
    });
  }

  @override
  Future<void> deleteFavoriteWord({required int favoriteWordId}) async {
    final Database database = await _collectionsService.db;
    final word = await getFavoriteWordById(favoriteWordId: favoriteWordId);
    await database.transaction((txn) async {
        await txn.delete(DBValues.dbTableOfFavoriteWords, where: '${DBValues.dbWordNumber} = ?', whereArgs: [favoriteWordId]);
        await _updateCollectionWordCount(txn, word.collectionId);
      },
    );
  }

  Future<void> _updateCollectionWordCount(sql.Transaction txn, int collectionId) async {
    final wordsCountResult = await txn.rawQuery('''
      SELECT COUNT(*) AS cnt FROM ${DBValues.dbTableOfFavoriteWords} WHERE ${DBValues.dbCollectionId} = ?
    ''', [collectionId]);
    final wordsCount = wordsCountResult.first['cnt'] as int;
    await txn.update(DBValues.dbTableOfCollections, {DBValues.dbWordsCount: wordsCount}, where: '${DBValues.dbId} = ?', whereArgs: [collectionId]);
  }
}
