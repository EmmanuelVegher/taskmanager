import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:task_manager/services/notification_services.dart';
import 'package:task_manager/services/theme_services.dart';
import 'package:task_manager/splashscreen.dart';
import 'package:task_manager/theme.dart';
import 'db/db_helper.dart';
import 'controllers/task_controller.dart'; // Import TaskController


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await DBHelper.initDb();

  // Initialize TaskController here (before NotifyHelper initialization)
  Get.put(TaskController()); // Initialize TaskController

  // Initialize notifications
  NotifyHelper notifyHelper = NotifyHelper();
  await notifyHelper.initializeNotification();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp()); // Use const for MyApp constructor
}

class MyApp extends StatelessWidget {
  final Color _primaryColor = const Color(0xffeef444c);
  final Color _accentColor = HexColor("#ff7f7f");
  MyApp({Key? key}) : super(key: key); // Use const for constructor

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: const SplashScreen(), // Use const for SplashScreen constructor
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}