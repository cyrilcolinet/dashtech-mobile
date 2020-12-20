import 'package:flutter_file_store/presentation/core/bindings/app_bindings.dart';
import 'package:flutter_file_store/presentation/core/theme/app_colors.dart';
import 'package:flutter_file_store/presentation/core/theme/app_theme.dart';
import 'package:flutter_file_store/presentation/core/translations/app_translations.dart';
import 'package:flutter_file_store/presentation/core/utils/logger_utils.dart';
import 'package:flutter_file_store/presentation/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DashTech',
      theme: lightTheme,
      initialBinding: AppBindings(),
      enableLog: true,
      logWriterCallback: Logger.write,
      debugShowCheckedModeBanner: false,
      color: const Color(accentColor),
      locale: const Locale('fr', 'FR'),
      fallbackLocale: const Locale('fr', 'FR'),
      translationsKeys: AppTranslation.translations,
      navigatorKey: Get.key,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}