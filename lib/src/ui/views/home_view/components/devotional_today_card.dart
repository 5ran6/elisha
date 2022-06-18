import 'package:cached_network_image/cached_network_image.dart';
import 'package:canton_design_system/canton_design_system.dart';

import '../../devotional_page/devotional_page.dart';

class DevotionalTodayCard  extends StatelessWidget {
  final String title;
  final String mainWriteUp;
  final String image;
  final bool internetInfo;


  const DevotionalTodayCard ({required this.title, required this.mainWriteUp, required this.image, required this.internetInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CantonMethods.alternateCanvasColorType2(context),
      shape: CantonSmoothBorder.defaultBorder(),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DevotionalPage(),
          ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                //trailing: Icon(Icons.share),
                title: Text(title,
                    style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  mainWriteUp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.normal),
                ),
              ),
              //const SizedBox(height: 5),
              Card(
                elevation: 0.0,
                shape: CantonSmoothBorder.defaultBorder(),
                margin: const EdgeInsets.all(5.0),
                child: internetInfo == true ? CachedNetworkImage(
                  imageUrl: image,
                  imageBuilder: (context, imageProvider) => Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ): Image.asset('assets/images/light.jpg'),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(onPressed: () {},
                      child: Text('VIEW', style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),)),
                  IconButton(
                    icon: const Icon(Icons.bookmark),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
