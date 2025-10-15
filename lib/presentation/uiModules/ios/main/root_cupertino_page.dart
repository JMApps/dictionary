import 'package:flutter/cupertino.dart';

import '../../../../core/routes/cupertino_routes.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/styles/cupertino_themes.dart';
import 'main_cupertino_page.dart';

class RootCupertinoPage extends StatelessWidget {
  const RootCupertinoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: MediaQuery.of(context).platformBrightness == Brightness.dark ? CupertinoThemes.cupertinoDark : CupertinoThemes.cupertinoLight,
      onGenerateRoute: CupertinoRoutes.onGeneratorRoute,
      home: const MainCupertinoPage(),
    );
  }
}
