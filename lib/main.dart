import 'package:flutter/material.dart';
import 'package:guess_ur_number/providers/number_guesser_provider.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'UI/guessito_screen.dart';

void main() {
  runApp(
    DevicePreview(
        builder: (context) => const MyApp(),
        enabled: true,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NumberGuesserProvider()),
      ],
      child: MaterialApp(
        title: "Numero Guesser",
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          primarySwatch: Colors.indigo,
        ),
        home: const GuessitoScreen(),
      ),
    );
  }
}