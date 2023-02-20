import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_notes/presentation/utils/notes_provider.dart';

// AsyncNotifierを使うためのAsyncNotifierProviderを定義する.
final notesController = AsyncNotifierProvider<NotesController, void>(NotesController.new);

// Supabaseを操作するAsyncNotifier
class NotesController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  // データを追加するメソッド.
  Future<void> addNotes(String _body) async {

    final appRepository = ref.read(notesProvider);
    await appRepository.from('notes').insert({'body': _body});
  }

  // データを更新するメソッド.
  Future<void> updateNotes(dynamic noteID, String _body) async {

    final appRepository = ref.read(notesProvider);
    await appRepository.from('notes').update({'body': _body}).match({'id': noteID});
  }

  // データを削除するメソッド.
  Future<void> deleteNotes(dynamic noteID) async {

    final appRepository = ref.read(notesProvider);
    await appRepository.from('notes').delete().match({'id': noteID});
  }
}
