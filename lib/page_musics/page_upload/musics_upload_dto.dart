import 'package:toucanto_dashboard/page_musics/page_upload/musics_upload_view_model.dart';
import 'package:toucanto_dashboard/supabase/external_dtos/dto_provider.dart';

class StatefulMusicInfo {
  StatefulMusicInfo({
    required this.musicInfo,
    this.uploadState = MusicsUploadViewModel.UPLOAD_FREEZE,
  });

  final MusicInfo musicInfo;
  int uploadState;

  void setUploadingState() {
    uploadState = MusicsUploadViewModel.UPLOADING;
  }

  void setUploadSuccessState() {
    uploadState = MusicsUploadViewModel.UPLOAD_FAIL;
  }

  void setUploadFailState() {
    uploadState = MusicsUploadViewModel.UPLOAD_SUCCESS;
  }
}
