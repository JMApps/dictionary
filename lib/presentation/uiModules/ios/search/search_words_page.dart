import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../data/repositories/search_values_data_repository.dart';
import '../../../../data/services/collections_service.dart';
import '../../../../data/state/search_query_state.dart';
import '../../../../data/state/search_values_state.dart';
import '../../../../domain/usecases/search_values_use_case.dart';
import 'lists/search_words_list.dart';

class SearchWordsPage extends StatefulWidget {
  const SearchWordsPage({super.key});

  @override
  State<SearchWordsPage> createState() => _SearchWordsPageState();
}

class _SearchWordsPageState extends State<SearchWordsPage> {
  final TextEditingController _wordsController = TextEditingController();

  @override
  void dispose() {
    _wordsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchQueryState(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchValuesState(
            SearchValuesUseCase(
              SearchValuesDataRepository(
                CollectionsService(),
              ),
            ),
          ),
        ),
      ],
      child: Consumer<SearchQueryState>(
        builder: (BuildContext context, query, _) {
          _wordsController.text = query.getQuery;
          return CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGroupedBackground,
            navigationBar: CupertinoNavigationBar(
              middle: CupertinoSearchTextField(
                controller: _wordsController,
                autofocus: true,
                autocorrect: false,
                placeholder: AppStrings.searchWords,
                onChanged: (value) => query.setQuery = value,
                onSubmitted: (value) async {
                  if (value.trim().isNotEmpty) {
                    await Provider.of<SearchValuesState>(
                      context,
                      listen: false,
                    ).fetchAddSearchValue(
                      searchValue: value.trim().toLowerCase(),
                    );
                  }
                },
              ),
              leading: const SizedBox(),
              trailing: CupertinoButton(
                padding: AppStyles.mardingOnlyLeftMini,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(AppStrings.cancel),
              ),
            ),
            child: const SafeArea(
              bottom: false,
              child: SearchWordsList(),
            ),
          );
        },
      ),
    );
  }
}
