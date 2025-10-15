import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/strings/app_constraints.dart';
import 'data/repositories/collections_data_repository.dart';
import 'data/repositories/default_dictionary_data_repository.dart';
import 'data/repositories/favorite_dictionary_data_repository.dart';
import 'data/services/collections_service.dart';
import 'data/services/default_dictionary_service.dart';
import 'data/services/notifications/local_notice_service.dart';
import 'data/state/app_settings_state.dart';
import 'data/state/collections_state.dart';
import 'data/state/default_dictionary_state.dart';
import 'data/state/favorite_words_state.dart';
import 'data/state/word_exact_match_state.dart';
import 'domain/usecases/collections_use_case.dart';
import 'domain/usecases/default_dictionary_use_case.dart';
import 'domain/usecases/favorite_dictionary_use_case.dart';
import 'presentation/uiModules/android/main/root_material_page.dart';
import 'presentation/uiModules/ios/main/root_cupertino_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNoticeService().setupNotification();
  await DefaultDictionaryService().initializeDatabase();

  await Hive.initFlutter();
  await Hive.openBox(AppConstraints.keyMainAppSettingsBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsState()),
        ChangeNotifierProvider(
          create: (_) => DefaultDictionaryState(
            DefaultDictionaryUseCase(DefaultDictionaryDataRepository(DefaultDictionaryService())),
          ),
        ),
        ChangeNotifierProvider(create: (_) => WordExactMatchState()),
        ChangeNotifierProvider(
          create: (_) =>
              CollectionsState(CollectionsUseCase(CollectionsDataRepository(CollectionsService()))),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteWordsState(
            FavoriteDictionaryUseCase(FavoriteDictionaryDataRepository(CollectionsService())),
          ),
        ),
      ],
      child: Platform.isAndroid ? const RootMaterialPage() : const RootCupertinoPage(),
    ),
  );
}
