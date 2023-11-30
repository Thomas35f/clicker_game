import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/main_provider.dart';

class Inventaire extends StatefulWidget {
  const Inventaire({Key? key}) : super(key: key);

  @override
  _Inventaire createState() => _Inventaire();
}

class _Inventaire extends State<Inventaire> {
  bool _sortByQuantity = false; // Ajout de cette variable pour gérer le tri

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaire'),
        actions: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Ajustez selon vos besoins
            children: [
              IconButton(
                icon: Icon(Icons.sort_by_alpha),
                onPressed: () {
                  setState(() {
                    _sortByQuantity = false;
                  });
                },
                tooltip: 'Trier par nom',
              ),
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  setState(() {
                    _sortByQuantity = true;
                  });
                },
                tooltip: 'Trier par quantité',
              ),
              Consumer<MainProvider>(
                builder: (context, mainProvider, _) {
                  return Text(
                    "Temps écoulé: ${mainProvider.elapsedTimeInSeconds} s",
                    style: TextStyle(fontSize: 16.0),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Consumer<MainProvider>(
        builder: (context, provider, child) {
          List<Recipe> filteredRecipes = _sortByQuantity
              ? provider.recipes.where((recipe) => recipe.count > 0).toList()
              : provider.recipes.where((recipe) => recipe.count > 0).toList();

          if (_sortByQuantity) {
            filteredRecipes.sort((a, b) => a.count.compareTo(b.count));
          } else {
            filteredRecipes = filteredRecipes
              ..sort((a, b) => a.name.compareTo(b.name));
          }

          return ListView.builder(
            itemCount: filteredRecipes.length,
            itemBuilder: (context, index) {
              Recipe recipe = filteredRecipes[index];
              return ListTile(
                title: Text(recipe.name),
                subtitle: Text('Quantité produite: ${recipe.count}'),
              );
            },
          );
        },
      ),
    );
  }
}
