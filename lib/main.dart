import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/provider/theme_changer_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeChanger(),
        child: Consumer<ThemeChanger>(
          builder: (context, themeChanger, child) {
            return MaterialApp(
              theme:  ThemeData(
                brightness: Brightness.light
              ),
              themeMode: Provider.of<ThemeChanger>(context).themeMode,
              darkTheme: ThemeData(
                brightness: Brightness.dark
              ),
              title: "Weather_App",
              debugShowCheckedModeBanner: false,
              home:const WeatherPage(),
            );
          },
        ));
  }
}
