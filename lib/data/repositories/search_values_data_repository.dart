import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../../core/strings/db_values.dart';
import '../../domain/entities/word_search_entity.dart';
import '../../domain/repositories/search_values_repository.dart';
import '../models/word_search_model.dart';
import '../services/collections_service.dart';

class SearchValuesDataRepository implements SearchValuesRepository {
  final CollectionsService _collectionsService;

  const SearchValuesDataRepository(this._collectionsService);

  @override
  Future<List<WordSearchEntity>> getAllSearchValues() async {
    final Database database = await _collectionsService.db;
    final List<Map<String, Object?>> resources = await database.query(DBValues.dbTableOfSearchedValues, orderBy: '${DBValues.dbId} DESC');
    final List<WordSearchEntity> allSearchValues = resources.isNotEmpty ? resources.map((c) => _mapToEntity(WordSearchModel.fromMap(c))).toList() : [];
    return allSearchValues;
  }

  @override
  Future<int> addSearchValue({required String searchValue}) async {
    final Database database = await _collectionsService.db;
    WordSearchModel searchModel = WordSearchModel(
      id: 0,
      searchValue: searchValue,
    );
    final int addSearchValue = await database.insert(DBValues.dbTableOfSearchedValues, searchModel.toMap(), conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return addSearchValue;
  }

  @override
  Future<int> deleteSearchValueById({required int searchValueId}) async {
    final Database database = await _collectionsService.db;
    final int deleteSearchValue = await database.delete(DBValues.dbTableOfSearchedValues, where: '${DBValues.dbId} = ?', whereArgs: [searchValueId]);
    return deleteSearchValue;
  }

  @override
  Future<int> deleteAllSearchValues() async {
    final Database database = await _collectionsService.db;
    final int deleteAllSearchValues = await database.delete(DBValues.dbTableOfSearchedValues);
    return deleteAllSearchValues;
  }

  // Mapping to entity
  WordSearchEntity _mapToEntity(WordSearchModel model) {
    return WordSearchEntity(
      id: model.id,
      searchValue: model.searchValue,
    );
  }
}
