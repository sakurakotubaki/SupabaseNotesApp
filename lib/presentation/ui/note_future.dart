import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_notes/presentation/utils/notes_provider.dart';

class NotesFuture extends ConsumerWidget {
  const NotesFuture({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue config = ref.watch(notesFutureProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future'),
      ),
      body: config.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (notes) {
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['body']),
              );
            },
          );
        },
      ),
    );
  }
}
