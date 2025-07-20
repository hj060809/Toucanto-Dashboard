import 'package:flutter/material.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_dto.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_model.dart';

class MusicsUploadViewModel extends ChangeNotifier {
  static const MUSIC_LOADING = 0;
  static const MUSIC_UPLOAD_PREPARING = 1;
  static const MUSIC_UPLOADING = 2;

  static const UPLOAD_FREEZE = 0;
  static const UPLOADING = 1;
  static const UPLOAD_SUCCESS = 2;
  static const UPLOAD_FAIL = 3;

  static const LOADING = 0;
  static const LOADED = 1;
  static const LOAD_FAILED = 2;

  final MusicsUploadModel _musicsUploadModel = MusicsUploadModel(
    musicInfos: [],
  );

  List<MusicInfo> get musicInfos => _musicsUploadModel.musicInfos;

  List<Artist> get artists => _musicsUploadModel.artists;

  int musicState = MUSIC_LOADING;
  int enumState = LOADING;
  int artistState = LOADING;

  bool allPrepared = false;

  void checkLoadState() {
    if (musicState == MUSIC_UPLOAD_PREPARING &&
        enumState == LOADED &&
        artistState == LOADED) {
      allPrepared = true;
    } else {
      allPrepared = false;
    }
    notifyListeners();
  }

  Future<int> setEnums() async {
    try {
      await _musicsUploadModel.initializeVEs();
      enumState = LOADED;
    } catch (e) {
      enumState = LOAD_FAILED;
    }
    checkLoadState();
    return enumState;
  }

  Future<void> setArtists() async {
    await _musicsUploadModel.getAllArtists();
    print(artists);
    artistState = LOADED;
    checkLoadState();
  }

  void setMusicLoadingState() {
    musicState = MUSIC_LOADING;
    checkLoadState();
  }

  void setUploadPreparingState() {
    musicState = MUSIC_UPLOAD_PREPARING;
    checkLoadState();
  }

  void setMusicUploadingState() {
    musicState = MUSIC_UPLOADING;
    checkLoadState();
  }

  Future<Map<String, String>> loadMusic() async {
    Map<String, String> loadFailures = await _musicsUploadModel.getMusicInfos();
    setUploadPreparingState();
    return loadFailures;
  }

  void onMusicDeletePressed(int index) {
    _musicsUploadModel.musicInfos.removeAt(index);
    notifyListeners();
  }
}
