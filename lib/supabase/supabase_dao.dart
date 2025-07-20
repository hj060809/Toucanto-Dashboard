import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDao {
  final _supabase = Supabase.instance.client;

  Future<PostgrestList> readArtists() async {
    return await _supabase.from("artist_information").select();
  }

  Future<int> readVersionAt(String dataName) async {
    final versionRecord = await _supabase
        .from("versions")
        .select("version")
        .eq("name", dataName)
        .limit(1);
    return versionRecord[0]["version"];
  }

  Future<List<String>> readExtraTagList() async {
    final extraTags = await _supabase.from("EXTRA_TAGS").select();
    return extraTags.map((m) => m["code"].toString()).toList();
  }

  Future<List<String>> _readEnumList(String type) async {
    return (await _supabase.rpc<List<dynamic>>(
      'get_enum_values',
      params: {'enum_type': type},
    )).cast<String>();
  }

  Future<List<String>> readGenreList() async {
    return await _readEnumList("genre");
  }

  Future<List<String>> readLanguageList() async {
    return await _readEnumList("language");
  }

  Future<List<String>> readMoodList() async {
    return await _readEnumList("mood");
  }

  Future<List<String>> readNationalityList() async {
    return await _readEnumList("nationality");
  }
}

SupabaseDao supabaseDao = SupabaseDao();
