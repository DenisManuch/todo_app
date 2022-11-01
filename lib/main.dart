// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/group_notes_widget.dart';
import 'package:todo_app/screens/login_widget.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/provider/provider_data.dart';
import 'package:todo_app/src/supabase_manager.dart';

Future<void> main() async {
  
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color colText = textColorK;
    const Color colIcon = iconColorK;

    return Services(
      child: ChangeNotifierProvider<ProviderData>(
        create: (context) => ProviderData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Login',
          theme: ThemeData(
            primaryColor: primaryColor,
            backgroundColor: darkBlue,
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(color: colText, fontSize: 20),
              iconTheme: IconThemeData(color: colIcon),
            ),
          ),
          home: Builder(
            builder: (context) {
              return FutureBuilder<bool>(
                future: Services.of(context).authService.recoverSession(),
                builder: (context, snapshot) {
                  final sessionRecovered = snapshot.data ?? false;
      
                  return sessionRecovered
                      ? const GroupNotesWidget()
                      : const LoginWidget();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
