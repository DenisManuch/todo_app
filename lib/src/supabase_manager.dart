import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/api/api_key.dart';
import 'package:todo_app/src/notes_service.dart';


class Services extends InheritedWidget {
  final AuthService authService;
  final NotesService notesService;

  // ignore: public_member_api_docs
  factory Services({required Widget child}) {
    final client = SupabaseClient(supabaseUrl, supabaseKey);
    final authService = AuthService(client.auth);
    final notesService = NotesService(client);

    return Services._(
      authService: authService,
      notesService: notesService,
      child: child,
    );
  }

  const Services._({
    required this.authService,
    required this.notesService,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static Services of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>()!;
  }
}


///
class AuthService {
  static const supabaseSessionKey = 'supabase_session';

  final GoTrueClient _client;
///
  AuthService(this._client) {
    _client.refreshSession();
  }
///
  Future<bool> signUp(String email, String password) async {
    final response = await _client.signUp(email, password);
    if (response.error == null) {
      await _persistSession(response.data!);

      return true;
    }

    return false;
  }
///
  Future<bool> signIn(String email, String password) async {
    final response = await _client.signIn(email: email, password: password);
    if (response.error == null) {
      await _persistSession(response.data!);

      return true;
    }

    return false;
  }

  Future<void> _persistSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(supabaseSessionKey, session.persistSessionString);
  }
///
  Future<bool> signOut() async {
    final response = await _client.signOut();
    if (response.error == null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(supabaseSessionKey);
      
      return true;
    }

    return false;
  }
///
  Future<bool> recoverSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(supabaseSessionKey)) {
      final jsonStr = prefs.getString(supabaseSessionKey)!;
      final response = await _client.recoverSession(jsonStr);
      if (response.error == null) {
        await _persistSession(response.data!);

        return true;
      }
    }

    return false;
  }
}
