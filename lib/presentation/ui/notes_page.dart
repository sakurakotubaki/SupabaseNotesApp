import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_notes/presentation/utils/notes_notifire.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Streamでリアルタイムにデータを取得する.
  final _noteStream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
  // Formの値を保存するTextEditingController.
  TextEditingController _body = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Page'),
      ), // StreamBuilderで、画面に描画する.
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _noteStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final notes = snapshot.data!;

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
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
                                      title: const Text('Add a Note'),
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
                                              final noteID = notes[index]['id'];
                                              // Formから取得したデータを更新する.
                                              ref
                                                  .read(
                                                      notesController.notifier)
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
                  title: Text(notes[index]['body']), // Mapでbodyデータを取得.
                  subtitle: Text(notes[index]['created_at']),// 作成された日時を取得.
                );
              },
            );
          }),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}