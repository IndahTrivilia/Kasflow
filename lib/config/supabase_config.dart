import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://onemmlbjvsecwdsfljnj.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9uZW1tbGJqdnNlY3dkc2Zsam5qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQzMDQ5NjUsImV4cCI6MjA3OTg4MDk2NX0.SNU5TTQjTuSQGraCF394OPlvPw44b8pvDBhlleWLQms';

  static Future<void> init() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
