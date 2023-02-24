import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_notes/presentation/utils/notes_provider.dart';
import 'package:supabase_notes/presentation/utils/todos_provider.dart';

final isCheckedProvider = StateProvider<bool>((ref) => false);

class TodoFuture extends ConsumerWidget {
  const TodoFuture({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValue型が帰ってくるので、こちら指定する．
    AsyncValue config = ref.watch(todoFutureProvider);
    bool isChecked = ref.watch(isCheckedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Future'),
      ),
      body: config.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (notes) {
          return ListView.builder(
            itemCount: notes.length, // なぜかコードの保管機能で出てこない？
            itemBuilder: (BuildContext context, int index) {
              final note = notes[index];
              return ListTile(
                leading: Checkbox(
                    checkColor: Colors.green,
                    fillColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.black),
                    value: note['done'],
                    onChanged: (value) {
                      ref.read(isCheckedProvider.notifier).state = value!;
                    }),
                title: Column(
                  children: [
                    Text(note['title']),
                    Text(note['body']),
                  ],
                ),
                subtitle: Text(note['date']),
              );
            },
          );
        },
      ),
    );
  }
}
