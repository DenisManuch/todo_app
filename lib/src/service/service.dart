// ignore_for_file: unused_local_variable

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/api/api_key.dart';

///
const notes = 'notes';

///
Future getNotesProvider() async {
  // await Supabase.initialize(
  //   url: supabaseUrl,
  //   anonKey: supabaseKey,
  // );
  //final client = SupabaseClient(supabaseUrl, supabaseKey);
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  final client = SupabaseClient(supabaseUrl, supabaseKey);
  Future<PostgrestResponse<dynamic>> data;
  // ignore: join_return_with_assignment
  //data = await client.from('todo_list').select('*').limit(1) as Note?;

  return data = client.from('todo_list').select('*').limit(1)
      as Future<PostgrestResponse<dynamic>>;
}
