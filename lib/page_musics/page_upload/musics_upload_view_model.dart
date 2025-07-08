import 'package:flutter/material.dart';
import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_model.dart';

class MusicsUploadViewModel extends ChangeNotifier{
  final MusicsUploadModel _musicsUploadModel = MusicsUploadModel();

  bool isUploading = false;

}