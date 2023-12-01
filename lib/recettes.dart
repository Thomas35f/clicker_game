import 'package:flutter/material.dart';
import 'package:flutter_shop/inventaire.dart';
import 'package:provider/provider.dart';
import './providers/main_provider.dart';

class Recettes extends StatefulWidget {
  const Recettes({Key? key}) : super(key: key);

  @override
  _Recettes createState() => _Recettes();
}

class _Recettes extends State<Recettes> {
  // Création de la recette
  void createRecipe(int index) {
    // Accès à l'instance du Provider
    MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: false);

    mainProvider.createRecipe(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, mainProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Recettes'),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.backpack_rounded),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Inventaire()),
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
        body: Container(
          child: ListView.builder(
            itemCount: mainProvider.recipes.length,
            itemBuilder: (context, index) {
              var recipe = mainProvider.recipes[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('${recipe.name} (${recipe.count.toString()})'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${recipe.description}'),
                      Text('Coût en ressources: ${recipe.cost}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      createRecipe(index);
                    },
                    child: Text('Produire'),
                    style: ElevatedButton.styleFrom(
                      primary: mainProvider.canProduceRecipe(index)
                          ? null
                          : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
