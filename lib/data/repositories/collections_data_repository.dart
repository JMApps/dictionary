import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

import '../../core/strings/db_values.dart';
import '../../domain/entities/collection_entity.dart';
import '../../domain/repositories/collections_repository.dart';
import '../models/collection_model.dart';
import '../services/collections_service.dart';

class CollectionsDataRepository implements CollectionsRepository {
  final CollectionsService _collectionsService;

  const CollectionsDataRepository(this._collectionsService);

  @override
  Future<List<CollectionEntity>> getAllCollections({required String sortedBy}) async {
    final Database database = await _collectionsService.db;
    final List<Map<String, Object?>> resources = await database.query(DBValues.dbTableOfCollections, orderBy: sortedBy);
    final List<CollectionEntity> allCollections = resources.isNotEmpty ? resources.map((c) => CollectionEntity.fromModel(CollectionModel.fromMap(c))).toList() : [];
    return allCollections;
  }

  @override
  Future<List<CollectionEntity>> getAllButOneCollection({required int collectionId, required String sortedBy}) async {
    final Database database = await _collectionsService.db;
    final List<Map<String, Object?>> resources = await database.query(DBValues.dbTableOfCollections, where: '${DBValues.dbId} <> ?', whereArgs: [collectionId], orderBy: sortedBy);
    final List<CollectionEntity> allCollections = resources.isNotEmpty ? resources.map((c) => CollectionEntity.fromModel(CollectionModel.fromMap(c))).toList() : [];
    return allCollections;
  }

  @override
  Future<CollectionEntity> getCollectionById({required int collectionId}) async {
    final Database database = await _collectionsService.db;
    final List<Map<String, Object?>> resources = await database.query(DBValues.dbTableOfCollections, where: '${DBValues.dbId} = ?', whereArgs: [collectionId]);
    final CollectionEntity? collectionById = resources.isNotEmpty ? CollectionEntity.fromModel(CollectionModel.fromMap(resources.first)) : null;
    return collectionById!;
  }

  @override
  Future<void> addCollection({required Map<String, dynamic> mapCollection}) async {
    final Database database = await _collectionsService.db;
    await database.insert(DBValues.dbTableOfCollections, mapCollection, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  @override
  Future<void> changeCollection({required Map<String, dynamic> mapCollection}) async {
    final Database database = await _collectionsService.db;
    await database.update(DBValues.dbTableOfCollections, mapCollection, where: '${DBValues.dbId} = ?', whereArgs: [mapCollection[DBValues.dbId]]);
  }

  @override
  Future<int> deleteCollection({required int collectionId}) async {
    final Database database = await _collectionsService.db;
    final int deleteCollection = await database.delete(DBValues.dbTableOfCollections, where: '${DBValues.dbId} = ?', whereArgs: [collectionId]);
    await database.delete(DBValues.dbTableOfFavoriteWords, where: '${DBValues.dbCollectionId} = ?', whereArgs: [collectionId]);
    return deleteCollection;
  }

  @override
  Future<int> deleteAllCollections() async {
    final Database database = await _collectionsService.db;
    final int deleteAllCollections = await database.delete(DBValues.dbTableOfCollections);
    await database.delete(DBValues.dbTableOfFavoriteWords);
    return deleteAllCollections;
  }

  @override
  Future<int> getWordCount({required int collectionId}) async {
    final Database database = await _collectionsService.db;
    final wordsCountMaps = await database.query(DBValues.dbTableOfCollections, where: '${DBValues.dbId} = ?', whereArgs: [collectionId], columns: [(DBValues.dbWordsCount)]);
    _getWordsCount(collectionId);
    return wordsCountMaps.first[DBValues.dbWordsCount] as int;
  }

  Future<void> _getWordsCount(int collectionId) async {
    final Database database = await _collectionsService.db;
    var result = await database.rawQuery('''SELECT COUNT(*) AS cnt FROM ${DBValues.dbTableOfFavoriteWords} WHERE ${DBValues.dbCollectionId} = $collectionId''');
    int wordsCount = result.first['cnt'] as int;
    await database.update(DBValues.dbTableOfCollections, {DBValues.dbWordsCount: wordsCount}, where: '${DBValues.dbId} = ?', whereArgs: [collectionId]);
  }
}
