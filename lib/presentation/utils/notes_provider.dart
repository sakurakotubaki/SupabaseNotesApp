import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabaseインスタンス化するプロバイダー.
final notesProvider = StateProvider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final notesStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
});