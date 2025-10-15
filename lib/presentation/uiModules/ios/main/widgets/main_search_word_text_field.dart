import 'package:flutter/cupertino.dart';

import '../../../../../core/routes/route_names.dart';
import '../../../../../core/strings/app_constraints.dart';
import '../../../../../core/strings/app_strings.dart';

class MainSearchWordTextField extends StatelessWidget {
  const MainSearchWordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      readOnly: true,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9)),
        color: CupertinoColors.tertiarySystemBackground,
      ),
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      placeholder: AppStrings.searchWords,
      placeholderStyle: const TextStyle(
        fontSize: 16,
        color: CupertinoColors.systemGrey,
        fontFamily: AppConstraints.fontSFPro,
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteNames.searchWordsPage);
      },
    );
  }
}
