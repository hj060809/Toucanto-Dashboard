import 'package:toucanto_dashboard/utils/object_utils.dart';

class AudioID {
  AudioID({
    required this.methodCode,
    required this.id,
    required this.settingJSON,
  });

  final String methodCode;
  final String id;
  final Map<String, dynamic> settingJSON;

  factory AudioID.fromJson(Map<String, dynamic> json) {
    return AudioID(
      methodCode: json["AIGM"],
      id: json["id"],
      settingJSON: json["settings"],
    );
  }
}

class VectorID {
  VectorID({
    required this.methodCode,
    required this.id,
    required this.settingJSON,
  });

  final String methodCode;
  final List<double> id;
  final Map<String, dynamic> settingJSON;

  factory VectorID.fromJson(Map<String, dynamic> json) {
    List<dynamic> id = json["id"];
    return VectorID(
      methodCode: json["VIGM"],
      id: id.cast<double>(),
      settingJSON: json["settings"],
    );
  }
}

class MusicIdentifier {
  MusicIdentifier({
    required this.downloadTime,
    required this.uploader,
    required this.thumbnailURL,
    required this.source,
    required this.urlCode,
    required this.audioID,
    required this.vectorID,
    required this.duplicatedMusics,
  });

  final DateTime downloadTime;
  final String uploader;
  final String thumbnailURL;
  final String source;
  final String urlCode;
  final AudioID audioID;
  final VectorID vectorID;
  Map<String, String> duplicatedMusics;

  factory MusicIdentifier.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> duplications = json["duplications"];
    return MusicIdentifier(
      downloadTime: DateTime.fromMillisecondsSinceEpoch(json["download_time"]),
      uploader: json["uploader"],
      thumbnailURL: json["thumbnail_url"],
      source: json["from"],
      urlCode: json["URL_code"],
      audioID: AudioID.fromJson(json["audio_id"]),
      vectorID: VectorID.fromJson(json["vector_id"]),
      duplicatedMusics: duplications.cast<String, String>(),
    );
  }
}

class MusicPreference {
  MusicPreference({
    this.averageListeningDuration = 0,
    this.likes = 0,
    this.playCount = 0,
  });

  final double averageListeningDuration;
  final int likes;
  final int playCount;
}

class Artist {
  Artist({
    required this.name,
    required this.debutDate,
    this.nationality,
  });

  String name;
  DateTime debutDate;
  VEnum? nationality;
}

class MusicProfileImage {
  MusicProfileImage({required this.imagePath});

  String imagePath;
}

class MusicInfo {
  MusicInfo({
    required this.fileName,
    required this.duration,
    required this.identifier,
    MusicPreference? preference,
    this.title,
    this.releaseDate,
    this.genre,
    this.moods,
    this.language,
    this.artist,
    this.profileImage,
    this.extraTags,
  }) : preference = preference ?? MusicPreference();

  final String fileName;
  String? title;
  final double duration;
  final MusicIdentifier identifier;
  DateTime? releaseDate;
  VEnum? genre; // enum in Supabase
  List<VEnum>? moods; // enum in Supabase
  VEnum? language; // enum in Supabase
  MusicPreference preference;
  Artist? artist;
  MusicProfileImage? profileImage;
  List<VEnum>? extraTags; // enum in Supabase
}