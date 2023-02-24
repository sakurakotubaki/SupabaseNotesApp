import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabaseをインスタンス化するプロバイダー.
final todoProvider = StateProvider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
// Supabaseからリアルタイムにデータを取得するプロバイダー.
final todoStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return Supabase.instance.client.from('todo').stream(primaryKey: ['id']);
});
// Supabaseから一度だけデータを取得するプロバイダー.
final todoFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await Supabase.instance.client
      .from('todo')
      .select<List<Map<String, dynamic>>>();
});