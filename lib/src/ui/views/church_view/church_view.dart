import 'package:canton_design_system/canton_design_system.dart';
import 'package:collection/collection.dart';
import 'package:elisha/src/models/daily_reading.dart';
import 'package:elisha/src/models/youTube_video.dart';
import 'package:elisha/src/providers/api_provider.dart';
import 'package:elisha/src/services/shared_pref_manager/shared_pref_manager.dart';
import 'package:elisha/src/ui/views/church_view/components/church_view_header.dart';
import 'package:elisha/src/ui/views/church_view/components/daily_readings_card.dart';
import 'package:elisha/src/ui/views/church_view/components/sunday_mass_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ChurchView extends StatefulWidget {
  //const ChurchView(this.reading, {Key? key}) : super(key: key);
  const ChurchView();

  //final DailyReading reading;

  @override
  _ChurchViewState createState() => _ChurchViewState();
}

class _ChurchViewState extends State<ChurchView> {

  var _basicTiles = List<CollapsibleTile>.empty();

  bool isDoNotDisturbFunctionOn = false;
  bool isDNDPolicyAccessGranted = false;
  String dndStat = "";

  Future<void> setDoNotDisturbOffWIthAppOnMessageClipView() async {
    final prefs = await SharedPreferences.getInstance();

    final bool dndStatus = prefs.getBool('sharedPrefStatus') ?? false;
    if (dndStatus) {
      await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
    }
  }


  void assertLoactionAndSetDND() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String? storedLocationOfCurrentView = sharedPrefs.getString('messageClipkey');

    if (storedLocationOfCurrentView != null) {
      // String s = PrefManager.getDND() ?? "off";
      // if (s == "on") {}
      var isNotificationPolicyAccessGranted = (await FlutterDnd.isNotificationPolicyAccessGranted);
      if ((isNotificationPolicyAccessGranted) != null && isNotificationPolicyAccessGranted) {
        setDoNotDisturbOffWIthAppOnMessageClipView();
      }
    }
  }

  Future<List<YouTubeVideoModel>> get videoClipsFuture {
    return RemoteAPI.getYouTubeVideos();
  }

  void fetchClipGroupNames() async {
    List<YouTubeVideoModel> videoClips = await videoClipsFuture;
    final videGroups = groupBy(videoClips, (YouTubeVideoModel youTubeVid) {
      return youTubeVid.groupName;
    });

    List<String> colasi = videGroups.keys.toList();

    List<CollapsibleTile> cola = colasi
        .map((video) => CollapsibleTile(tileTitle: video)).toList();

    setState(() {
      _basicTiles = cola;
    });
  }


  //late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    assertLoactionAndSetDND();
    fetchClipGroupNames();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: _content(context)
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ChurchViewHeader(),
        const SizedBox(height: 20),
        Column(
          children: _basicTiles.map((tile) => CollapsibleTileWidget(tile: tile)).toList(),
        )
      ],
    );
  }


  
  // @override
  // void dispose() {
  //   _controller.close();
  //   super.dispose();
  // }
}

class CollapsibleTile {
  final String tileTitle;


  const CollapsibleTile({
    required this.tileTitle,
});
}

class CollapsibleTileWidget  extends StatefulWidget{
  final CollapsibleTile tile;

  const CollapsibleTileWidget({Key? key, required this.tile}) : super(key: key);

  @override
  State<CollapsibleTileWidget> createState() => _CollapsibleTileWidgetState();
}

class _CollapsibleTileWidgetState extends State<CollapsibleTileWidget> {

  var _videoClips = List<YouTubeVideoModel>.empty();
  var _controllers = List<YoutubePlayerController>.empty();

  Future<List<YouTubeVideoModel>> get videoClipsFuture {
    return RemoteAPI.getYouTubeVideos();
  }
  Future<List<YouTubeVideoModel>?> getVideosForGroup(String groupName) async {
    List<YouTubeVideoModel> videoClips = await videoClipsFuture;

    final videGroups = groupBy(videoClips, (YouTubeVideoModel youTubeVid) {
      return youTubeVid.groupName;
    });

    return videGroups[groupName];
  }



  void fetchAndUpdateUIVideos(String groupName) async {

    List<YouTubeVideoModel>? messageClips = await getVideosForGroup(groupName);

    List<YoutubePlayerController>? controllers = messageClips
        ?.map((video) => YoutubePlayerController(
        initialVideoId: video.youtubeVideoId,
        params: YoutubePlayerParams(
          startAt: Duration(seconds: video.startAt ?? 2000),
          endAt: video.endAt != null ? Duration(seconds: video.endAt!) : null,
          showControls: false,
          showFullscreenButton: true,
          //desktopMode: true,
          //privacyEnhanced: true,
          useHybridComposition: true,
        )))
        .toList();


    setState(() {
      _controllers = controllers!;
      _videoClips = messageClips!;
    });
  }

  Future<List<YoutubePlayerController>?> getControllersForGroup(String groupName) async {
    List<YouTubeVideoModel>? messageClips = await getVideosForGroup(groupName);

    List<YoutubePlayerController>? controllers = messageClips
        ?.map((video) => YoutubePlayerController(
        initialVideoId: video.youtubeVideoId,
        params: YoutubePlayerParams(
          startAt: Duration(seconds: video.startAt ?? 2000),
          endAt: video.endAt != null ? Duration(seconds: video.endAt!) : null,
          showControls: false,
          showFullscreenButton: true,
          //desktopMode: true,
          //privacyEnhanced: true,
          useHybridComposition: true,
        )))
        .toList();

    return controllers;
  }



  @override
  void initState() {
    fetchAndUpdateUIVideos(widget.tile.tileTitle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.tile.tileTitle;

    if (_videoClips.isEmpty) {

      return ListTile(title: Text(title));

    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ExpansionTile(
            title: Text(
                title
            ),
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _videoClips.length,
                itemBuilder: (context, index) {
                  final video = _videoClips[index];
                  final controller = _controllers[index];
                  return GestureDetector(
                    onTap: () {
                      var startTime = Duration(seconds: video.startAt ?? 2000);
                      controller.load(video.youtubeVideoId,
                          startAt: startTime,
                          endAt: video.endAt != null ? Duration(
                              seconds: video.endAt!) : null);
                    },
                    child: Card(
                      color: CantonMethods.alternateCanvasColorType2(context),
                      shape: CantonSmoothBorder.defaultBorder(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 17, vertical: 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: controller != null
                                  ? YoutubePlayerIFrame(controller: controller)
                                  : const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              video.title + ' by ' + video.ministering,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline4,
                            ),
                            const SizedBox(height: 7),
                            Text(
                              video.shortDesc,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .overline
                                  ?.copyWith(
                                letterSpacing: 2,
                                fontWeight: FontWeight.w500,
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'Get full message ',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyText1,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'here',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        //decoration: TextDecoration.underline
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await launch(video.youtubeVideoUrl);
                                        }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
