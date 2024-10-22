import 'package:elisha/src/providers/bible/controllers.dart';
import 'widgets.dart';

class SearchBox extends GetView<BibleService> {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(32),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        onChanged: (value) {
          controller.search(value);
        },
      ),
    );
  }
}
