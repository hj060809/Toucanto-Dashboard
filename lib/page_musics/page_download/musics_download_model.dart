import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:toucanto_dashboard/page_musics/page_download/musics_download_dto.dart';
import 'package:toucanto_dashboard/global_constants.dart';
import 'package:toucanto_dashboard/utils/logic_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicsDownloadModel {
  List<Downloadable> downloadables;
  String? downloadPath;
  // if it is null, do not save in external storage, save only internal storage

  MusicsDownloadModel({
    required this.downloadables,
    required this.downloadPath,
  });

  Future<VideoInfo> fetchVideoInfo(String videoInfoURL) async {
    //vecSVX1QYbQ
    try {
      final response = await http.get(Uri.parse(videoInfoURL));
      print(response.statusCode);
      if (response.statusCode == 200) {
        return VideoInfo.fromJson(json.decode(response.body));
      }
    } catch (e) {
      return VideoInfo.defaultInfo(
        title: "Error: fail to get Information",
        authorName: e.runtimeType.toString(),
      );
    }

    return VideoInfo.defaultInfo(
      title: "Error: fail to get Information",
      authorName: "Unknown Cause",
    );

    //throw Exception("Failed to fetch Video Information");
  }

  String replaceSpecialChar(String name) {
    return name.replaceAll(RegExp(r'[,.<>?!|/\*":]'), '');
  }

  Future<String?> downloadMusic(
    MusicURL musicURL,
    List<Directory> saveDirs,
    String ffmpegPath,
    YoutubeExplode youtubeExplode,
  ) async {
    //이거 파일 이름에서 오류나는 경우가 많음
    IOSink? sink;
    File? webmFile;

    try {
      Video video = await youtubeExplode.videos.get(musicURL.url);
      StreamManifest streamManifest = await youtubeExplode.videos.streamsClient
          .getManifest(musicURL.url);
      AudioOnlyStreamInfo streamInfo = streamManifest.audioOnly.first;

      String title = replaceSpecialChar(video.title);
      Stream<List<int>> audioStream = youtubeExplode.videos.streamsClient.get(
        streamInfo,
      );

      Directory originalDir = saveDirs.last;
      String webmFilePath = '${originalDir.path}/${musicURL.videoID}.webm';
      webmFile = File(webmFilePath);
      sink = webmFile.openWrite();

      await for (final data in audioStream) {
        sink.add(data);
      }

      for (Directory saveDir in saveDirs) {
        // 파일 복붙 로직 변경 가능
        String mp3FilePath = '${saveDir.path}/$title.mp3';
        var result = await Process.run(
          ffmpegPath,
          [
            '-i',
            webmFilePath,
            '-vn',
            '-ar',
            '44100',
            '-ac',
            '2',
            '-b:a',
            '320k',
            mp3FilePath,
          ],
          runInShell: true,
        );
        if (result.exitCode != 0) {
          return null;
        }
      }

      return title;
    } catch (e) {
      print('Error: $e');
      return null;
    } finally {
      await sink?.close();
      await webmFile?.delete().catchError((_) => webmFile!);
    }
  }

  void backUp() async {
    Map<String, List> backUpJson = {"back_up": []};
    for (Downloadable downloadable in downloadables) {
      Map<String, dynamic> downloadableJson = await downloadable.toJson();
      backUpJson["back_up"]!.add(downloadableJson);
    }

    String jsonString = jsonEncode(backUpJson);
    File file = await getFile(
      MUSIC_DOWNLOAD_CACHES_PATH,
      "downloadable_back_up.json",
      "",
    );
    file.writeAsString(jsonString);
  }

  Future<bool> registerMusic(
    Downloadable downloadable,
    String musicFileTitle,
  ) async {
    MusicURL url = downloadable.url;
    VideoInfo videoInfo = await downloadable.futureVideoInfo;

    Map<String, dynamic> incompletedID = {
      "file_name": musicFileTitle,
      "download_time": DateTime.now().millisecondsSinceEpoch,
      "uploader": videoInfo.authorName,
      "title": videoInfo.title,
      "audio_id": null,
      "vector_id": null,
      "duplications": {},
      "thumbnail_url": videoInfo.thumbNail.thumbNailURL,
      "from": "Youtube",
      "URL_code": url.videoID,
    };

    File tempIdFile = await getFile(
      MUSIC_DOWNLOAD_STORAGE_PATH,
      "temporary_identifiers.json",
      '{"temps":[]}',
    );
    String jsonString = await tempIdFile.readAsString();
    List<dynamic> tempIds = jsonDecode(jsonString)["temps"];
    tempIds.add(incompletedID);
    String modifiedJsonString = jsonEncode({"temps": tempIds});
    tempIdFile.writeAsString(modifiedJsonString);

    return Future(() {
      return true;
    });
  }

  Future<ProcessResult> identifyMusics() async {
    Directory applierPath = await getDirectory(MUSIC_DOWNLOAD_APPLIER_PATH);

    /*File applier = File('${applierPath.path}/identify.py');
    if(!(await applier.exists())){ applier 파일 설치 코드
      
    }*/

    return await Process.run('python', [
      '${applierPath.path}/identify.py',
    ], runInShell: true);
    //이거 SeriousPython으로 실행과정 통합할 예정
    //아직 미통합 상태
    //임시 코드임!!!!!!
  }

  Iterable<String?> ExtractURL(String text) {
    RegExp urlPattern = RegExp(
      "https:\/\/www\.youtube\.com\/watch\\?v=...........",
    );
    return urlPattern.allMatches(text).map((match) {
      return match.group(0);
    });
  }

  bool IsValidURL(String url) {
    RegExp urlPattern = RegExp(
      "https:\/\/www\.youtube\.com\/watch\\?v=...........",
    );
    return urlPattern.hasMatch(url);
  }

  String? ExtractVideoID(String url) {
    RegExp videoIDPattern = RegExp("(?<=v=)[^&]+");
    var match = videoIDPattern.firstMatch(url);
    return match?.group(0);
  }

  bool isContainedURL(MusicURL musicURL, List<Downloadable> downloadables) {
    for (var downloadable in downloadables) {
      if (downloadable.url.videoID == musicURL.videoID) {
        return true;
      }
    }
    return false;
  }

  MusicURL? createMusicURL(String url) {
    if (IsValidURL(url)) {
      var videoID = ExtractVideoID(url);
      if (videoID != null) {
        return MusicURL(url: url, videoID: videoID);
      }
    }
    return null;
  }
}
