import 'package:elisha/src/ui/views/bible/search_view/search.dart';

import 'widgets.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      surfaceTintColor: Colors.white,
      centerTitle: true,
      floating: true,
      title: const BibleNavigation(),
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SearchView(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
