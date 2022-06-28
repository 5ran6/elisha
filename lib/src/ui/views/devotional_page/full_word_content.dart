import 'package:canton_design_system/canton_design_system.dart';

class FullWordContentPage extends StatelessWidget {
  final String mainWriteUp;

  const FullWordContentPage({required this.mainWriteUp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                  title: const Text('Word', style: TextStyle(fontFamily: "Palatino", fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      // style: Theme.of(context)
                      //     .textTheme
                      //     .headline4
                      //     ?.copyWith(fontWeight: FontWeight.bold)
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(mainWriteUp, style: TextStyle(fontFamily: "Palatino", fontSize: 20, color: Colors.black),
                    // style: Theme.of(context)
                    //     .textTheme
                    //     .headline5
                    //     ?.copyWith(fontWeight: FontWeight.normal)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
