import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_notes/presentation/utils/notes_notifire.dart';
import 'package:supabase_notes/presentation/utils/notes_provider.dart';

class NotesStream extends ConsumerWidget {
  const NotesStream({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesStream = ref.watch(notesStreamProvider);
    TextEditingController _body = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialogのFormからデータをPostする.
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Add a Note'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  children: [
                    TextFormField(
                      controller: _body,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          // Formから取得したデータを保存する.
                          await ref
                              .read(notesController.notifier)
                              .addNotes(_body.text);
                          Navigator.of(context).pop();
                        },
                        child: Text('Post'))
                  ],
                );
              });
        },
        child: const Icon(Icons.pending_actions),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 400,
          height: 600,
          child: notesStream.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (notes) {
              // Display all the messages in a scrollable list view.
              return ListView.builder(
                // Show messages from bottom to top
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: const Text('Edit a Note'),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 1.0),
                                        children: [
                                          TextFormField(
                                            controller: _body,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                // Listのデータを受け取りMapでindexから、選択したリストのidを取得する.
                                                final noteID =
                                                    notes[index]['id'];
                                                // Formから取得したデータを更新する.
                                                ref
                                                    .read(notesController
                                                        .notifier)
                                                    .updateNotes(
                                                        noteID, _body.text);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Put'))
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              )),
                          IconButton(
                            onPressed: () async {
                              // Listのデータを受け取りMapでindexから、選択したリストのidを取得する.
                              final noteID = notes[index]['id'];
                              // ボタンを押すとクエリが実行されて、データが削除される!
                              ref
                                  .read(notesController.notifier)
                                  .deleteNotes(noteID);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text(note['body']),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
