import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_notes/presentation/utils/todos_provider.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStream = ref.watch(todoStreamProvider);
    TextEditingController _body = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialogのFormからデータをPostする.
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Add a todo'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  children: [
                    TextFormField(
                      controller: _body,
                    ),
                    ElevatedButton(
                        onPressed: () async {

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
          child: dataStream.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (data) {
              // Display all the messages in a scrollable list view.
              return ListView.builder(
                // Show messages from bottom to top
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final todo = data[index];
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
                                        title: const Text('Edit a todo'),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 1.0),
                                        children: [
                                          TextFormField(
                                            controller: _body,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {

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

                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text(todo['title']),
                    subtitle: Text(todo['body']),
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
