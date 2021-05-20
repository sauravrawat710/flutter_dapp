import 'package:flutter/material.dart';
import 'package:flutter_dapp/models/add_response_model.dart';
import 'package:flutter_dapp/screens/add_screen.dart';
import 'package:flutter_dapp/screens/detail_screen.dart';
import 'package:flutter_dapp/screens/fetch_screen.dart';
import 'package:flutter_dapp/screens/home_screen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive
    ..init(appDocDir.path)
    ..registerAdapter(AppResponseModelAdapter());
  await FlutterDownloader.initialize(debug: true);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter DApps',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(),
      routes: {
        AddScreen.routeName: (ctx) => AddScreen(),
        FetchScreen.routeName: (ctx) => FetchScreen(),
        DetailScreen.routeName: (ctx) => DetailScreen(),
      },
    );
  }
}
