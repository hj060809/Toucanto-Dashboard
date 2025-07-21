import 'dart:io';
import 'package:toucanto_dashboard/global_constants.dart';
import 'package:toucanto_dashboard/supabase/cache_manager/expiration_checker.dart';
import 'package:toucanto_dashboard/utils/logic_utils.dart';

//typedef EnumReader = Future<List<String>> Function();

Future<void> updateEnumCache(List<String> data, String enumType) async {
  final cacheFile = await getFile(
    MUSIC_DOWNLOAD_CACHES_PATH,
    "$enumType.properties",
    "",
  );
  await writePropertyFile(cacheFile, data.asMap(), KVReverse: true);

  notifyCacheUpdateAt(enumType);
}

Future<List<String>?> getEnumCache(String enumType) async {
  if (await readExpirationAt(enumType)) {
    return null;
  }

  File? file = await getNullableFile(
    MUSIC_DOWNLOAD_CACHES_PATH,
    "$enumType.properties",
  );
  if (file == null) {
    return null;
  }

  Map<String, int> enums = parseMapValueToInt(await readPropertyFile(file));

  List<String> sortedCodes = enums.keys.toList();
  sortedCodes.sort((ea, eb) {
    return enums[ea]!.compareTo(enums[eb]!);
  });

  return sortedCodes;
}
