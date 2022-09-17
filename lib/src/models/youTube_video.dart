import 'dart:convert';

List<YouTubeVideoModel> youTubeVideoFromJson(List<dynamic> jsonList) =>
    List<YouTubeVideoModel>.from(jsonList.map((x) => YouTubeVideoModel.fromJson(x)));

String youTubeVideoToJson(List<YouTubeVideoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => null)));

class YouTubeVideoModel {
  String title;
  String youtubeVideoUrl;
  String youtubeVideoId;
  String shortDesc;
  String ministering;
  String groupName;
  int? startAt;
  int? endAt;

  YouTubeVideoModel({required this.title, required this.youtubeVideoUrl, required this.youtubeVideoId,
    required this.shortDesc, required this.ministering, required this.groupName, required this.startAt, required this.endAt});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'youtubeVideoUrl': youtubeVideoUrl,
      'youtubeVideoId': youtubeVideoId,
      'shortDesc': shortDesc,
      'ministering': ministering,
      'groupName': groupName,
      'startAt': startAt,
      'endAt': endAt,
    };
  }

  @override
  String toString() {
    return 'YouTubeVideoModel{title: $title, youtubeVideoUrl: $youtubeVideoUrl, youtubeVideoId: $youtubeVideoId, shortDesc: $shortDesc, ministering: $ministering, groupName: $groupName, startAt: $startAt, endAt: $endAt}';
  }

  factory YouTubeVideoModel.fromJson(Map<String, dynamic> json) => YouTubeVideoModel(
      title: json['title']?? '',
      youtubeVideoUrl: json['youtubeVideoUrl']?? '',
      youtubeVideoId: json['youtubeVideoId']?? '',
      shortDesc: json['shortDesc']?? '',
      ministering: json['ministering']?? '',
      groupName: json['groupName']?? '',
      startAt: json['startAt'],
      endAt: json['endAt']
  );
}