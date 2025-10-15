import 'package:flutter/material.dart';

import '../../../../core/routes/material_routes.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/styles/material_themes.dart';
import 'main_material_page.dart';

class RootMaterialPage extends StatelessWidget {
  const RootMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: MaterialThemes().lightTheme,
      darkTheme: MaterialThemes().darkTheme,
      onGenerateRoute: MaterialRoutes.onGeneratorRoute,
      home: const MainMaterialPage(),
    );
  }
}
