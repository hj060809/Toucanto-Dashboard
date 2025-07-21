import 'package:toucanto_dashboard/supabase/cache_manager/manager.dart';
import 'package:toucanto_dashboard/supabase/db_accessor/accessor.dart';
import 'package:toucanto_dashboard/supabase/external_dtos/dto_provider.dart';
import 'package:toucanto_dashboard/utils/object_utils.dart';

Future<List<Artist>> getAllArtists(VariableEnumerator nationalityVE) async {
  List<Map<String, dynamic>> rawArtists = await readArtists();

  return rawArtists.map((rawArtist) => Artist(
      name: rawArtist["name"],
      debutDate: rawArtist["debut_date"],
      nationality: nationalityVE.getVEnumFromCode(rawArtist["nationality"])
    )
  ).toList();
}

Future<VariableEnumerator> _getEnum(String enumType) async {
  List<String>? enumStr = await getEnumCache(enumType);
  if (enumStr == null) {
    enumStr = enumType == "extra_tag"
        ? await readExtraTagList()
        : await readEnumList(enumType);
    updateEnumCache(enumStr, enumType);
  }

  return VariableEnumerator(enumName: enumType, codeList: enumStr);
}

Future<VariableEnumerator> getGenreEnum() async {
  return _getEnum("genre");
}

Future<VariableEnumerator> getLanguageEnum() async {
  return _getEnum("language");
}

Future<VariableEnumerator> getMoodEnum() async {
  return _getEnum("mood");
}

Future<VariableEnumerator> getNationalityEnum() async {
  return _getEnum("nationality");
}

Future<VariableEnumerator> getExtraTagEnum() async {
  return _getEnum("extra_tag");
}
