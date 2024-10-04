import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_docor_app/home_screen.dart';
import 'package:green_docor_app/splash_screen.dart';
import 'package:green_docor_app/firebase_options.dart';


Future<void> main() async
{
  try
  {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  }
  catch(errorMsg)
  {
    print("Error:: " + errorMsg.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Decor',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}


