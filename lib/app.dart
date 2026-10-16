import 'package:flutter/material.dart';

import 'features/vehicles/presentation/pages/vehicles_page.dart';

class CarAssistantApp extends StatelessWidget {
  const CarAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: Brightness.light),
      darkTheme: ThemeData(colorSchemeSeed: Colors.indigo, brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const VehiclesPage(),
    );
  }
}
