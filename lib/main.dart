import 'package:flutter/material.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/group_notes_widget.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/supabase_manager.dart';



void main() {
  
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Services(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login',
        
        theme: ThemeData(
          primaryColor: primaryColor,
          backgroundColor: darkBlue,
          appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: textColor, fontSize: 20),
          iconTheme: IconThemeData(color: iconColor)
          ),
        ),
        home: Builder(
          builder: (context) {
            return FutureBuilder<bool>(
              future: Services.of(context).authService.recoverSession(),
              builder: (context, snapshot) {
                final sessionRecovered = snapshot.data ?? false;
                return sessionRecovered ? const GroupNotesWidget() : const LoginWidget();
              },
            );
          },
        ),
      ),
    );
  }
}