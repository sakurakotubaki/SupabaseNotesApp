import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabaseをインスタンス化するプロバイダー.
final notesProvider = StateProvider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
// Supabaseからリアルタイムにデータを取得するプロバイダー.
final notesStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
});
// Supabaseから一度だけデータを取得するプロバイダー.
final notesFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await Supabase.instance.client
      .from('notes')
      .select<List<Map<String, dynamic>>>();
});