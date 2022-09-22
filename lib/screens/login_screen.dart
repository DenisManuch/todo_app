import 'package:flutter/material.dart';
import 'package:todo_app/screens/group_notes_widget.dart';
import 'package:todo_app/src/supabase_manager.dart';



class LoginWidget extends StatefulWidget {
  const LoginWidget();

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() async {
  final success = await Services.of(context)
      .authService
      .signUp(_emailController.text, _passwordController.text);
  if (success) {
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const GroupNotesWidget()));
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Something went wrong.')));
  }
}

  void _signIn() async {
  final success = await Services.of(context)
      .authService
      .signIn(_emailController.text, _passwordController.text);
  await _handleResponse(success);
}

Future<void> _handleResponse(bool success) async {
  if (success) {
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const GroupNotesWidget()));
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Something went wrong.')));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('To do app'),
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _signIn,
              icon: const Icon(Icons.login),
              label: const Text('Sign in'),
            ),
            const SizedBox(height: 15,),
            ElevatedButton.icon(
              onPressed: _signUp,
              icon: const Icon(Icons.app_registration),
              label: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}