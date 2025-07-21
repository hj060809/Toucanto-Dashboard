import 'dart:convert';
import 'dart:io';

import 'package:toucanto_dashboard/supabase/data_manager.dart';
import 'package:toucanto_dashboard/supabase/external_dtos/dto_provider.dart';
import 'package:toucanto_dashboard/utils/logic_utils.dart';
import 'package:toucanto_dashboard/global_constants.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_dto.dart';
import 'package:toucanto_dashboard/utils/object_utils.dart';

class MusicsUploadModel {
  List<StatefulMusicInfo> statefulMusicInfos;

  late VariableEnumerator genreVE;
  late VariableEnumerator languageVE;
  late VariableEnumerator moodVE;
  late VariableEnumerator nationalityVE;
  late VariableEnumerator extraTagsVE;

  late List<Artist> artists;

  MusicsUploadModel({required this.statefulMusicInfos});

  Future<void> initializeVEs() async {
    await Future.wait([
      getGenreEnum().then((ve) {
        genreVE = ve;
      }),
      getLanguageEnum().then((ve) {
        languageVE = ve;
      }),
      getMoodEnum().then((ve) {
        moodVE = ve;
      }),
      getNationalityEnum().then((ve) {
        nationalityVE = ve;
      }),
      getExtraTagEnum().then((ve) {
        extraTagsVE = ve;
      }),
    ]);
  }

  Future<void> initializeArtistList() async {
    artists = await getAllArtists(nationalityVE);
  }

  Future<double?> getMp3Duration(String mp3Path, String ffprobePath) async {
    final result = await Process.run(
      ffprobePath,
      [
        '-v',
        'error',
        '-show_entries',
        'format=duration',
        '-of',
        'default=noprint_wrappers=1:nokey=1',
        mp3Path,
      ],
      runInShell: true,
    );
    if (result.exitCode == 0) {
      return double.tryParse(result.stdout.toString().trim());
    }
    return null;
  }

  Future<Map<String, String>> getMusicInfos() async {
    File permanentIdFile = await getFile(
      MUSIC_DOWNLOAD_STORAGE_PATH,
      "identifiers.json",
      '{"identifiers":[]}',
    );
    String jsonString = await permanentIdFile.readAsString();
    List<dynamic> ids = jsonDecode(jsonString)["identifiers"];

    String ffprobePath = await prepareFFprobe();

    Map<String, String> failures = {};

    for (Map<String, dynamic> id in ids) {
      MusicIdentifier musicIdentifier = MusicIdentifier.fromJson(id);
      String fileName = id['file_name'];
      File? musicFile = await getNullableFile(
        MUSIC_DOWNLOAD_PERMANENT_STORAGE_PATH,
        "$fileName.mp3",
      );
      if (musicFile == null) {
        failures[fileName] = "Fail to Load Mp3 File";
        continue;
      }

      double? duration = await getMp3Duration(musicFile.path, ffprobePath);
      if (duration == null) {
        failures[fileName] = "Fail to Get Duration";
        continue;
      }

      statefulMusicInfos.add(
        StatefulMusicInfo(
          musicInfo: MusicInfo(
            fileName: fileName,
            duration: duration,
            identifier: musicIdentifier,
          ),
        ),
      );
    }

    return failures;
  }
}
