import 'package:flutter/material.dart';
import 'home.dart';

import 'package:provider/provider.dart';
import 'providers/main_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: const MainApp(),
    ),
  );
}
