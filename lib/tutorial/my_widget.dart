import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_notes/tutorial/home_page.dart';
// Supabaseをインスタンス化する.
final supabase = Supabase.instance.client;

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  // ログインと新規登録に使用するTextEditingController.
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  //ログイン判定をする変数.
  bool _redirecting = false;

  //ユーザーの新規登録をするメソッド.
  Future<void> signUpUser(String _email, String _password) async {
    final AuthResponse res =
        await supabase.auth.signUp(email: _email, password: _password);
    log(res.toString());
  }

  //ログインをするメソッド.
  Future<void> signInUser(String _email, String _password) async {
    final AuthResponse res = await supabase.auth
        .signInWithPassword(email: _email, password: _password);
    log(res.toString());
  }

  late final StreamSubscription<AuthState> _authSubscription;
  //セッションを使うための変数.
  User? _user;

  // ログインした状態を維持するためのロジック．
  @override
  void initState() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      // ユーザーがログインしているかをifで判定する.
      if (_redirecting) return;
      if (session != null) {
        _redirecting = true;
        //ユーザーがログインしていたら、アプリのページへリダイレクトする.
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      }
      setState(() {
        _user = session?.user;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginPage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(hintText: 'メールアドレスを入力'),
            ),
            TextField(
              controller: _password,
              decoration: InputDecoration(hintText: 'パスワードを入力'),
            ),
            ElevatedButton(
              onPressed: () async {
                //　ログイン用ボタン
                signInUser(_email.text, _password.text);
              },
              child: const Text('SignIn'),
            ),
            ElevatedButton(
              // 新規登録用のボタン.
              onPressed: () async {
                signUpUser(_email.text, _password.text);
              },
              child: const Text('SignUp'),
            ),
          ],
        ),
      ),
    );
  }
}
