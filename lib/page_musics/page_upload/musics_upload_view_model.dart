import 'package:flutter/material.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_dto.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_model.dart';

class MusicsUploadViewModel extends ChangeNotifier{
  static const MUSIC_LOADING = 0;
  static const MUSIC_UPLOAD_PREPARING = 1;
  static const MUSIC_UPLOADING = 2;

  static const UPLOAD_FREEZE = 0;
  static const UPLOADING = 1;
  static const UPLOAD_SUCCESS = 2;
  static const UPLOAD_FAIL = 3;

  final MusicsUploadModel _musicsUploadModel = MusicsUploadModel(
    musicInfos: []
  );

  List<MusicInfo> get musicInfos => _musicsUploadModel.musicInfos;

  int musicState = MUSIC_LOADING;

  void setMusicLoadingState(){
    musicState = MUSIC_LOADING;
    notifyListeners();
  }

  void setUploadPreparingState(){
    musicState = MUSIC_UPLOAD_PREPARING;
    notifyListeners();
  }

  void setMusicUploadingState(){
    musicState = MUSIC_UPLOADING;
    notifyListeners();
  }

  Future<Map<String, String>> loadMusic() async {
    Map<String, String> loadFailures = await _musicsUploadModel.getMusicInfos();
    setUploadPreparingState();
    return loadFailures;
  }

  void onMusicDeletePressed(int index){
    _musicsUploadModel.musicInfos.removeAt(index);
    notifyListeners();
  }

}