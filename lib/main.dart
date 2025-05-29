import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:uts_pbm/screens/splash_secreen.dart'; // Pastikan path ini benar

void main() async {
  // Jadikan main async
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding Flutter siap

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://pracvfzljfijbailraay.supabase.co', // URL Supabase Anda
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InByYWN2ZnpsamZpamJhaWxyYWF5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg0MjgxMTcsImV4cCI6MjA2NDAwNDExN30.oSQyEQqJfNkpYGLcZ2GPHabKtHWNAkRKikolt9Vwskk', // Anon Key Supabase Anda
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DBS APPLICATION ',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
