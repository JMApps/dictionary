import 'package:flutter/cupertino.dart';

import '../../domain/entities/args/collection_args.dart';
import '../../domain/entities/args/word_args.dart';
import '../../domain/entities/args/word_favorite_collection_args.dart';
import '../../domain/entities/args/word_move_args.dart';
import '../../presentation/uiModules/ios/cards/card_mode_page.dart';
import '../../presentation/uiModules/ios/cards/cards_mode_detail_page.dart';
import '../../presentation/uiModules/ios/cards/swipe/card_swipe_mode_page.dart';
import '../../presentation/uiModules/ios/cards/swipe/cards_swipe_mode_detail_page.dart';
import '../../presentation/uiModules/ios/collections/all_collections_page.dart';
import '../../presentation/uiModules/ios/constructors/word_constructor_detail_page.dart';
import '../../presentation/uiModules/ios/constructors/word_constructor_page.dart';
import '../../presentation/uiModules/ios/favorites/add_favorite_word_page.dart';
import '../../presentation/uiModules/ios/favorites/collection_detail_page.dart';
import '../../presentation/uiModules/ios/favorites/favorite_word_detail_page.dart';
import '../../presentation/uiModules/ios/favorites/favorite_word_select_collection.dart';
import '../../presentation/uiModules/ios/favorites/move_favorite_word_page.dart';
import '../../presentation/uiModules/ios/quiz/quiz_detail_page.dart';
import '../../presentation/uiModules/ios/quiz/quiz_page.dart';
import '../../presentation/uiModules/ios/search/search_words_page.dart';
import '../../presentation/uiModules/ios/search/word_detail_page.dart';
import '../../presentation/uiModules/ios/settings/app_settings_page.dart';
import 'route_names.dart';

class CupertinoRoutes {
  static Route onGeneratorRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouteNames.appSettingsPage:
        return CupertinoPageRoute(
          builder: (_) => const AppSettingsPage(),
        );
      case RouteNames.searchWordsPage:
        return CupertinoPageRoute(
          builder: (_) => const SearchWordsPage(),
        );
      case RouteNames.addFavoriteWordPage:
        final WordArgs wordArgs = routeSettings.arguments as WordArgs;
        return CupertinoPageRoute(
            builder: (_) => AddFavoriteWordPage(wordNumber: wordArgs.wordNumber));
      case RouteNames.favoriteWordSelectionCollectionPage:
        final WordFavoriteCollectionArgs favoriteCollectionArgs =
            routeSettings.arguments as WordFavoriteCollectionArgs;
        return CupertinoPageRoute(
          builder: (_) => FavoriteWordSelectCollection(
            wordModel: favoriteCollectionArgs.wordModel,
            serializableIndex: favoriteCollectionArgs.serializableIndex,
          ),
        );
      case RouteNames.wordFavoriteDetailPage:
        final WordArgs wordArgs = routeSettings.arguments as WordArgs;
        return CupertinoPageRoute(
          builder: (_) =>
              FavoriteWordDetailPage(favoriteWordNumber: wordArgs.wordNumber),
        );
      case RouteNames.moveFavoriteWordPage:
        final WordMoveArgs wordMoveArgs =
            routeSettings.arguments as WordMoveArgs;
        return CupertinoPageRoute(
          builder: (_) => MoveFavoriteWordPage(
            wordNumber: wordMoveArgs.wordNumber,
            oldCollectionId: wordMoveArgs.oldCollectionId,
          ),
        );
      case RouteNames.quizPage:
        return CupertinoPageRoute(
          builder: (_) => const QuizPage(),
        );
      case RouteNames.quizDetailPage:
        final CollectionArgs collectionArgs =
            routeSettings.arguments as CollectionArgs;
        return CupertinoPageRoute(
          builder: (_) => QuizDetailPage(
            collectionModel: collectionArgs.collectionModel,
          ),
        );
      case RouteNames.allCollectionsPage:
        return CupertinoPageRoute(
          builder: (_) => const AllCollectionsPage(),
        );
      case RouteNames.collectionDetailPage:
        final CollectionArgs collectionArgs =
            routeSettings.arguments as CollectionArgs;
        return CupertinoPageRoute(
          builder: (_) => CollectionDetailPage(
            collectionModel: collectionArgs.collectionModel,
          ),
        );
      case RouteNames.wordDetailPage:
        final WordArgs wordArgs = routeSettings.arguments as WordArgs;
        return CupertinoPageRoute(
          builder: (_) => WordDetailPage(wordNumber: wordArgs.wordNumber),
        );
      case RouteNames.cardModePage:
        return CupertinoPageRoute(
          builder: (_) => const CardModePage(),
        );
      case RouteNames.cardSwipeModePage:
        return CupertinoPageRoute(
          builder: (_) => const CardSwipeModePage(),
        );
      case RouteNames.cardsModeDetailPage:
        final CollectionArgs collectionArgs =
            routeSettings.arguments as CollectionArgs;
        return CupertinoPageRoute(
          builder: (_) => CardsModeDetailPage(
            collectionModel: collectionArgs.collectionModel,
          ),
        );
      case RouteNames.cardsSwipeModeDetailPage:
        final CollectionArgs collectionArgs =
            routeSettings.arguments as CollectionArgs;
        return CupertinoPageRoute(
          builder: (_) => CardsSwipeModeDetailPage(
            collectionModel: collectionArgs.collectionModel,
          ),
        );
      case RouteNames.wordConstructorPage:
        return CupertinoPageRoute(
          builder: (_) => const WordConstructorPage(),
        );
      case RouteNames.wordConstructorDetailPage:
        final CollectionArgs collectionArgs =
            routeSettings.arguments as CollectionArgs;
        return CupertinoPageRoute(
          builder: (_) => WordConstructorDetailPage(
            collectionModel: collectionArgs.collectionModel,
          ),
        );
      default:
        throw Exception('Invalid route ${routeSettings.name}');
    }
  }
}
