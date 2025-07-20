import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:toucanto_dashboard/global_constants.dart';
import 'dart:io';
import 'package:toucanto_dashboard/utils/logic_utils.dart';
import 'package:toucanto_dashboard/page_musics/page_download/musics_download_model.dart';
import 'package:toucanto_dashboard/page_musics/page_download/musics_download_dto.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicsDownloadViewModel extends ChangeNotifier {
  static const URL_APPLY_SUCCESS = 0;
  static const URL_APPLY_DUPLICATED = 1;
  static const URL_APPLY_NOT_FOUND = 2;
  static const URL_APPLY_UNKNOWN_ERROR = 4;

  static const DOWNLOAD_ERROR_OCCURED = 0;
  static const DOWNLOAD_SUCCESS = 1;
  static const DOWNLOAD_EMPTY_LIST = 2;

  static const DOWNLOAD_STATE_NOT_STARTED = 0;
  static const DOWNLOADING = 1;
  static const DOWNLOAD_STATE_CLEAN_UP = 2;

  final MusicsDownloadModel _musicsDownloadModel = MusicsDownloadModel(
    downloadables: [],
    downloadPath: null,
  );

  List<Downloadable> get downloadables => _musicsDownloadModel.downloadables;
  String? get downloadPath => _musicsDownloadModel.downloadPath;

  int downloadingState = DOWNLOAD_STATE_NOT_STARTED;

  void startDownload() {
    downloadingState = DOWNLOADING;
    for (int i = 0; i < downloadables.length; i++) {
      downloadables[i].setReady();
    }
    notifyListeners();
  }

  void cleanUpDownload() {
    downloadingState = DOWNLOAD_STATE_CLEAN_UP;
    notifyListeners();
  }

  void stopDownload() {
    downloadingState = DOWNLOAD_STATE_NOT_STARTED;
    notifyListeners();
  }

  void setDownloadables(List<Downloadable> ds) {
    _musicsDownloadModel.downloadables = ds;
    _musicsDownloadModel.backUp();
    notifyListeners();
  }

  void setDownloadablesNoBackUp(List<Downloadable> ds) {
    _musicsDownloadModel.downloadables = ds;
    notifyListeners();
  }

  void addDownloadables(Downloadable downloadable) {
    //downloadables.add(downloadable);
    downloadables.insert(0, downloadable);
    notifyListeners();
  }

  void clearDownloadables() {
    for (int i = downloadables.length - 1; i >= 0; i--) {
      if (downloadables[i].downloadState == Downloadable.DOWNLOAD_FAIL) {
        downloadables[i].freeze();
      } else {
        _musicsDownloadModel.downloadables.removeAt(i);
      }
    }
    _musicsDownloadModel.backUp();
    notifyListeners();
  }

  void registURL(MusicURL musicURL) {
    String videoInfoURL =
        'https://www.youtube.com/oembed?url=${musicURL.url}&format=json';

    Future<VideoInfo> result = _musicsDownloadModel.fetchVideoInfo(
      videoInfoURL,
    );

    Downloadable downloadable = Downloadable(
      url: musicURL,
      futureVideoInfo: result,
    );

    addDownloadables(downloadable);
    // 내부 저장 로직 => sqlite로 저장, 다운로드 기록도 관리
  }

  int onPressedApplyURL(String text) {
    Iterable<String?> urls = _musicsDownloadModel.ExtractURL(text);

    bool showDuplicateToast = false;
    bool showNotFoundToast = false;

    for (String? url in urls) {
      if (url != null) {
        MusicURL? musicURL = _musicsDownloadModel.createMusicURL(url);

        if (musicURL == null) {
          showNotFoundToast = true;
          continue;
        }
        if (_musicsDownloadModel.isContainedURL(musicURL, downloadables)) {
          showDuplicateToast = true;
          continue;
        }

        registURL(musicURL);
      }
    }

    _musicsDownloadModel.backUp();

    if (urls.isEmpty) {
      return URL_APPLY_NOT_FOUND;
    } else if (showDuplicateToast) {
      return URL_APPLY_DUPLICATED;
    } else if (showNotFoundToast) {
      return URL_APPLY_UNKNOWN_ERROR;
    }
    return URL_APPLY_SUCCESS;
  }

  void onPressedDeleteDownloadable(int index) {
    downloadables.removeAt(index);
    _musicsDownloadModel.backUp();
    //리스트 역순 정렬해서 그럼
    notifyListeners();
  }

  void onPressedSelectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;

      File newFile = new File(file.path!);
      String content = utf8.decode(newFile.readAsBytesSync());

      onPressedApplyURL(content);
    }
  }

  void onPressedSelectExternalStorage() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    _musicsDownloadModel.downloadPath = selectedDirectory;
    notifyListeners();
  }

  void onPressedUnSelectExternalStorage() async {
    _musicsDownloadModel.downloadPath = null;
    notifyListeners();
  }

  void loadSavedList() async {
    File file = await getFile(
      MUSIC_DOWNLOAD_CACHES_PATH,
      "downloadable_back_up.json",
      '{"back_up":[]}',
    );
    String jsonString = await file.readAsString();
    List<dynamic> backUpJson = jsonDecode(jsonString)["back_up"];
    List<Downloadable> downloadablesFromJson = [];
    for (Map<String, dynamic> downloadableJson in backUpJson) {
      downloadablesFromJson.add(
        Downloadable.fromJson(downloadableJson),
      ); // 이거 시발 왜 작동 안함?
    }
    setDownloadablesNoBackUp(downloadablesFromJson);
  }

  Future<int> onPressedDownload() async {
    //wrapper 작성 어떻게 함
    if (downloadables.isEmpty) {
      return DOWNLOAD_EMPTY_LIST;
    }
    startDownload();
    // 다운로드시 프로그래스바 설정

    List<Directory> saveDirs = [];

    if (downloadPath != null) {
      Directory dir = Directory(
        "$downloadPath\\Musics - ${getCurrentTimeString()}",
      );
      await dir.create();
      saveDirs.add(dir);
    }

    Directory downloadDir = await getDirectory(
      MUSIC_DOWNLOAD_TEMPORARY_STORAGE_PATH,
    );
    saveDirs.add(downloadDir);

    bool isSuccessAll = true;

    String ffmpegPath = await prepareFFmpeg();
    YoutubeExplode youtubeExplode = YoutubeExplode();
    for (int i = 0; i < downloadables.length; i++) {
      downloadables[i].setDownload();
      notifyListeners();

      String? musicFileTitle = await _musicsDownloadModel.downloadMusic(
        downloadables[i].url,
        saveDirs,
        ffmpegPath,
        youtubeExplode,
      );
      bool isSuccess = musicFileTitle != null;

      downloadables[i].result(isSuccess);
      notifyListeners();

      // 음악 등록 프로세스
      if (isSuccess) {
        await _musicsDownloadModel.registerMusic(
          downloadables[i],
          musicFileTitle,
        );
      }
      isSuccessAll &= isSuccess;
    }
    youtubeExplode.close();

    _musicsDownloadModel.downloadPath = null;

    cleanUpDownload();

    ProcessResult result = await _musicsDownloadModel.identifyMusics();
    print(result.stderr);
    print(result.stdout);

    stopDownload();
    clearDownloadables();

    if (isSuccessAll) {
      return DOWNLOAD_SUCCESS;
    } else {
      return DOWNLOAD_ERROR_OCCURED;
    }
  }

  /*

    왜 model에서 모든 다운로드 로직을 담당하지 않고,
    저장 경로 접근과 목록 순회를 viewmodel에서 담당하나?

    => 1개 음악의 download마다 성공 여부를 받아와서 view 처리에 사용해야 해서
    => 개별 음악 download마다 저장 경로를 얻어오는 것을 비효율적이므로 viewmodel에서 경로 접근을 담당
    
  */
}
