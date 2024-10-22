import 'package:elisha/src/models/models.dart';
import 'widgets.dart';

class VerseWidget extends StatefulWidget {
  const VerseWidget({
    Key? key,
    required this.verse,
  }) : super(key: key);

  final Verse verse;

  @override
  State<VerseWidget> createState() => _VerseWidgetState();
}

class _VerseWidgetState extends State<VerseWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.verse.highlighted = !widget.verse.highlighted;
        });
      },
      onLongPress: () {
        setState(() {
          if (!widget.verse.highlighted) widget.verse.highlighted = true;
        });
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return VerseNoteTray(verse: widget.verse);
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  height: 1.90,
                ),
            children: [
              TextSpan(
                text: "${widget.verse.id}. ",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
              ),
              TextSpan(
                text: widget.verse.text,
                style: widget.verse.highlighted
                    ? const TextStyle(
                        color: Colors.blue,
                        decorationColor: Colors.blue,
                        decoration: TextDecoration.underline,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
