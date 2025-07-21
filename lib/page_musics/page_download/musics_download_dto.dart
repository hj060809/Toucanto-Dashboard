class MusicURL {
  MusicURL({
    required this.url,
    required this.videoID,
  });

  final String url;
  final String videoID;
}

class Downloadable {
  static const int DOWNLOAD_FROZEN = 0;
  static const int DOWNLOAD_READY = 1;
  static const int DOWNLOADING = 2;
  static const int DOWNLOAD_SUCCESS = 3;
  static const int DOWNLOAD_FAIL = 4;

  Downloadable({
    required this.url,
    required this.futureVideoInfo,
    this.downloadState = DOWNLOAD_FROZEN,
  });

  MusicURL url;
  Future<VideoInfo> futureVideoInfo;
  int downloadState;

  factory Downloadable.fromJson(Map<String, dynamic> json) {
    return Downloadable(
      url: MusicURL(url: json["url"]["url"], videoID: json["url"]["video_id"]),
      futureVideoInfo: Future(() {
        return VideoInfo.fromJson(json["video_info"]);
      }),
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    // toJson 구현할 일 더 생기면 Serializable로 재구현
    MusicURL musicURL = this.url;
    VideoInfo videoInfo = await this.futureVideoInfo;

    return {
      "url": {"url": musicURL.url, "video_id": musicURL.videoID},
      "video_info": {
        "title": videoInfo.title,
        "author_name": videoInfo.authorName,
        "thumbnail_url": videoInfo.thumbNail.thumbNailURL,
        "thumbnail_width": videoInfo.thumbNail.thumbnailWidth,
        "thumbnail_height": videoInfo.thumbNail.thumbnailHeight,
      },
    };
  }

  void setReady() {
    downloadState = DOWNLOAD_READY;
  }

  void setDownload() {
    downloadState = DOWNLOADING;
  }

  void freeze() {
    downloadState = DOWNLOAD_FROZEN;
  }

  void result(bool isSuccess) {
    downloadState = isSuccess ? DOWNLOAD_SUCCESS : DOWNLOAD_FAIL;
  }
}

class ThumbNail {
  final String? thumbNailURL;
  final int thumbnailHeight;
  final int thumbnailWidth;

  ThumbNail({
    required this.thumbNailURL,
    required this.thumbnailHeight,
    required this.thumbnailWidth,
  });
}

class VideoInfo {
  final String title;
  final String authorName;
  final ThumbNail thumbNail;

  VideoInfo({
    required this.title,
    required this.authorName,
    required this.thumbNail,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      title: json["title"],
      authorName: json["author_name"],
      thumbNail: ThumbNail(
        thumbNailURL: json["thumbnail_url"],
        thumbnailHeight: json["thumbnail_height"],
        thumbnailWidth: json["thumbnail_width"],
      ),
    );
  }

  factory VideoInfo.defaultInfo({
    String title = "Unknown",
    String authorName = "Anonymous",
    String? thumbNailURL,
    int thumbnailHeight = 512,
    int thumbnailWidth = 512,
  }) {
    return VideoInfo(
      title: title,
      authorName: authorName,
      thumbNail: ThumbNail(
        thumbNailURL: thumbNailURL,
        thumbnailHeight: thumbnailHeight,
        thumbnailWidth: thumbnailWidth,
      ),
    );
  }
}
