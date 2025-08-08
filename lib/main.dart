import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form_provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const FS033App());
}

class FS033App extends StatelessWidget {
  const FS033App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FS.033 – Inspección',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
