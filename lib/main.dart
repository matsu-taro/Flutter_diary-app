import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/entry_page.dart';
import 'pages/analysis_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const MyDiary());
}

class MyDiary extends StatelessWidget {
  const MyDiary({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDiary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      //  最初に表示するページ
      initialRoute: '/home',

      //  ページルーティング設定
      routes: {
        '/home': (context) => const HomePage(),
        // '/entry': (context) => EntryPage(),
        // '/analysis': (context) => AnalysisPage(),
        // '/settings': (context) =>  SettingsPage(),
      },
    );
  }
}
