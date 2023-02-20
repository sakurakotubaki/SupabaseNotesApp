import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabaseインスタンス化するプロバイダー.
final notesProvider = StateProvider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});