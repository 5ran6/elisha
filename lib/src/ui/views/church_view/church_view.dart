import 'package:canton_design_system/canton_design_system.dart';
import 'package:elisha/src/models/daily_reading.dart';
import 'package:elisha/src/models/youTube_video.dart';
import 'package:elisha/src/providers/api_provider.dart';
import 'package:elisha/src/ui/views/church_view/components/church_view_header.dart';
import 'package:elisha/src/ui/views/church_view/components/daily_readings_card.dart';
import 'package:elisha/src/ui/views/church_view/components/sunday_mass_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
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
  var _videoClips = List<YouTubeVideoModel>.empty();


  Future<List<YouTubeVideoModel>> get videoClipsFuture {
    return RemoteAPI.getYouTubeVideos();
  }

  void fetchAndUpdateUIVideos() async {
    List<YouTubeVideoModel> videoClips = await this.videoClipsFuture;
    setState(() {
      _videoClips = videoClips;
    });
  }

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    fetchAndUpdateUIVideos();

    _controller = YoutubePlayerController(
      initialVideoId: '',
      params: const YoutubePlayerParams(
        //startAt: Duration(minutes: 1, seconds: 36),
        showControls: true,
        showFullscreenButton: true,
        //desktopMode: true,
        //privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    };
    _controller.onExitFullscreen = () {};
  }

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {

    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ChurchViewHeader(),

        const SizedBox(height: 20),

        _videoClips.isNotEmpty ? _buildVideoCard(_videoClips) :
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),

      ],
    );
  }

  Widget _buildVideoCard(List<YouTubeVideoModel> listVid) => Expanded(
    child: ListView.builder(
          itemCount: listVid.length,
          itemBuilder: (context, index) {
            final video = listVid[index];
            return GestureDetector(
              onTap: () {
                var startTime = Duration(seconds: video.startAt ?? 0);
                _controller.load(video.youtubeVideoId,
                    startAt: startTime, endAt: video.endAt != null ? Duration(seconds: video.endAt!) : null);
              },
              child: Card(
                color: CantonMethods.alternateCanvasColorType2(context),
                shape: CantonSmoothBorder.defaultBorder(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _controller != null
                            ? YoutubePlayerIFrame(controller: _controller)
                            : const Center(child: CircularProgressIndicator()),
                      ),

                      const SizedBox(height: 15),
                      Text(
                        video.title + ' by ' + video.ministering,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        video.shortDesc,
                        style: Theme.of(context).textTheme.overline?.copyWith(
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Text('Get full message ', style: Theme.of(context).textTheme.bodyText1,),
                          RichText(
                            text: TextSpan(
                                text: 'here',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    //decoration: TextDecoration.underline
                                ),
                                recognizer:TapGestureRecognizer()
                                  ..onTap = () async {
                                    await launch(video.youtubeVideoUrl);
                                  }
                            ),
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
  );

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
