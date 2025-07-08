class AudioID {
  AudioID({
    required this.methodCode,
    required this.id,
    required this.settingJSON,
  });

  final String methodCode;
  final String id;
  final String settingJSON;
}

class VectorID {
  VectorID({
    required this.methodCode,
    required this.id,
    required this.settingJSON,
  });

  final String methodCode;
  final List<double> id;
  final String settingJSON;
}

class IdentifiedMusicInfo{
  IdentifiedMusicInfo({
    required this.fileName,
    required this.title,
    required this.downloadTime,
    required this.uploader,
    required this.thumbnailURL,
    required this.source,
    required this.urlCode,
    required this.audioID,
    required this.vectorID,
    required this.duplicatedMusics,
  });

  final String fileName;
  final String title;
  final int downloadTime;
  final String uploader;
  final String thumbnailURL;
  final String source;
  final String urlCode;
  final AudioID audioID;
  final VectorID vectorID;
  final Map<String, String> duplicatedMusics;
}