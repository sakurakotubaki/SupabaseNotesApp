# SupabaseApp
Flutter始めるSupabase

公式とタイラーさんの動画を参考に環境構築をする
https://supabase.com/docs/guides/getting-started/quickstarts/flutter
https://www.youtube.com/watch?v=F2j6Q-4nLEE

## 環境構築をする
Supabase クライアントを初期化する
lib/main.dartメイン関数を開いて編集し、プロジェクト URL と公開 API (anon) キーを使用して Supabase を初期化します。

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  runApp(MyApp());
}
```

アプリからnotesテーブルのデータを取得する
```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  final _future = Supabase.instance.client
      .from('notes')
      .select<List<Map<String, dynamic>>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: ((context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['body']),
                subtitle: Text(note['created_at']),
              );
            }),
          );
        },
      ),
    );
  }
}
```