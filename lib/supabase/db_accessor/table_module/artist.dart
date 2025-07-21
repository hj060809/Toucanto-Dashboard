import 'package:supabase_flutter/supabase_flutter.dart';

Future<PostgrestList> readArtists() async {
  final _supabase = Supabase.instance.client;
  return await _supabase.from("artist_information").select();
}