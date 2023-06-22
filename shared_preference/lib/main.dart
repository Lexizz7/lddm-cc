import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;
  var _themeBrightness = Brightness.light;

  _setIsDark(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = value;
      _themeBrightness = _isDark ? Brightness.dark : Brightness.light;
      prefs.setBool('isDark', _isDark);
    });
  }

  _loadIsDark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = (prefs.getBool('isDark') ?? false);
      _themeBrightness = _isDark ? Brightness.dark : Brightness.light;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadIsDark();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green, brightness: _themeBrightness),
        ),
        home: Scaffold(
          appBar: AppBar(
              title: const Text('SharedPreferences'),
              elevation: 1,
              bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(20),
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Escolha um tema',
                            style: TextStyle(color: Colors.grey)),
                      )))),
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        _setIsDark(false);
                      },
                      icon: const Icon(Icons.light_mode),
                      style:
                          ElevatedButton.styleFrom(elevation: _isDark ? 1 : 5),
                      label: const Text("Light")),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                      onPressed: () {
                        _setIsDark(true);
                      },
                      style:
                          ElevatedButton.styleFrom(elevation: _isDark ? 5 : 1),
                      icon: const Icon(Icons.dark_mode),
                      label: const Text("Dark"))
                ],
              )),
        ));
    ;
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: _themeData,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('SharedPreferences'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      //_theme = 'Light';
                      _setSelectedTheme('Light');
                    },
                    child: const Text("Light")),
                ElevatedButton(
                    onPressed: () {
                      //_theme = 'Dark';
                      _setSelectedTheme('Dark');
                    },
                    child: const Text("Dark"))
              ],
            )));
  }

  String _theme = 'Light';
  var _themeData = ThemeData.light();
  @override
  void initState() {
    super.initState();
    _loadSelectedTheme();
  }

  _loadSelectedTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme = (prefs.getString('theme') ?? 'Light');
      _themeData = _theme == 'Dark' ? ThemeData.dark() : ThemeData.light();
    });
  }

  _setSelectedTheme(theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme = theme;
      _themeData = theme == 'Dark' ? ThemeData.dark() : ThemeData.light();
      prefs.setString('theme', theme);
    });
  }
}
