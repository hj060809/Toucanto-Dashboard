import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<String>> readExtraTagList() async {
  final _supabase = Supabase.instance.client;
  final extraTags = await _supabase.from("EXTRA_TAGS").select();
  return extraTags.map((m) => m["code"].toString()).toList();
}

Future<List<String>> readEnumList(String type) async {
  final _supabase = Supabase.instance.client;
  return (await _supabase.rpc<List<dynamic>>(
    'get_enum_values',
    params: {'enum_type': type},
  )).cast<String>();
}