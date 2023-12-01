import 'package:flutter/material.dart';
import 'recettes.dart';
import 'package:provider/provider.dart';
import './providers/main_provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // La ressource est ajouté au compteur
  void incrementCount(int index) {
    // Accès à l'instance du Provider
    MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: false);

    mainProvider.addRessource(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, mainProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ressources'),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu_book),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Recettes()),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Consumer<MainProvider>(
                    builder: (context, mainProvider, _) {
                      return Text(
                        "Temps écoulé: ${mainProvider.elapsedTimeInSeconds} s",
                        style: TextStyle(fontSize: 16.0),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Ressource(
                      index: index,
                      onMinePressed: () {
                        incrementCount(index);
                      },
                      mainProvider: mainProvider,
                    );
                  },
                ),
              ),
              Text('Bois récolté : ${mainProvider.boisCounter}'),
              Text('Fer récolté : ${mainProvider.ferCounter}'),
              Text('Cuivre récolté : ${mainProvider.cuivreCounter}'),
            ],
          ),
        ),
      );
    });
  }
}

class Ressource extends StatelessWidget {
  final int index;
  final VoidCallback? onMinePressed;
  final MainProvider mainProvider;

  const Ressource(
      {required this.index,
      this.onMinePressed,
      required this.mainProvider,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String resourceName;

    switch (index) {
      case 0:
        color = Color(0xFF967969);
        resourceName = 'Bois';
        break;
      case 1:
        color = Color(0xFFCED4DA);
        resourceName = 'Fer';
        break;
      case 2:
        color = Color(0xFFD9480F);
        resourceName = 'Cuivre';
        break;
      case 3:
        if (mainProvider.recipes[2].count >= 1000 &&
            mainProvider.recipes[4].count >= 1000) {
          color = Color(0xFF000000);
          resourceName = 'Charbon';
        } else {
          return Container();
        }
        break;
      default:
        color = Colors.transparent;
        resourceName = '';
    }

    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(resourceName),
          ElevatedButton(
            onPressed: onMinePressed,
            child: const Text('Miner'),
          ),
        ],
      ),
    );
  }
}
