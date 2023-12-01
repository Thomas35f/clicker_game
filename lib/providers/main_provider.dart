import 'dart:async';

import 'package:flutter/material.dart';

// Chaque recette est une instance de cette classe
class Recipe {
  String name;
  String description;
  Map<String, int> cost;
  int count;

  Recipe({
    required this.name,
    required this.description,
    required this.cost,
    this.count = 0,
  });
}

class MainProvider extends ChangeNotifier {
  // Temps écoulé en secondes
  int elapsedTimeInSeconds = 0;

  // Timer pour mettre à jour le temps
  late Timer time;

  MainProvider() {
    // MAJ du temps chaque seconde
    time = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      elapsedTimeInSeconds++;
      notifyListeners();
    });

    // Le mineur récolte 3 cuivres et 3 fers toutes les secondes
    Timer.periodic(Duration(milliseconds: 333), (Timer timer) {
      Recipe mineurRecipe =
          recipes.firstWhere((recipe) => recipe.name == 'Mineur');
      if (mineurRecipe.count == 1) {
        addRessource(1);
        addRessource(2);
      }
    });

    // Création de 2 recettes toutes les secondes
    Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      Recipe fonderieRecipe =
          recipes.firstWhere((recipe) => recipe.name == 'Fonderie');
      if (fonderieRecipe.count == 1) {
        createRecipe(2);
        createRecipe(4);
      }
    });

    // Le dieu mineur
    Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      Recipe dieuMineurRecipe =
          recipes.firstWhere((recipe) => recipe.name == 'Dieu mineur');
      if (dieuMineurRecipe.count == 1) {
        for (int i = 1; i < 10; i++) {
          addRessource(0);
        }
        for (int i = 1; i < 10; i++) {
          addRessource(1);
        }
        for (int i = 1; i < 10; i++) {
          addRessource(2);
        }
      }
    });
  }

  // Ressources
  int boisCounter = 0;
  int ferCounter = 0;
  int cuivreCounter = 0;
  int charbonCounter = 0;

  // Recettes
  List<Recipe> recipes = [
    Recipe(
      name: 'Hache',
      description: 'Outil pour couper du bois.',
      cost: {'bois': 5},
    ),
    Recipe(
      name: 'Pioche',
      description: 'Outil pour miner des minéraux.',
      cost: {'bois': 3, 'fer': 2},
    ),
    Recipe(
        name: 'Lingot de fer',
        description: 'Lingot de fer utilisé dans diverses fabrications.',
        cost: {'fer': 1}),
    Recipe(
        name: 'Plaque de fer',
        description: 'Plaque de fer utilisé dans diverses fabrications.',
        cost: {'fer': 3, 'cuivre': 2}),
    Recipe(
        name: 'Lingot de cuivre',
        description: 'Lingot de cuivre utilisé dans diverses fabrications.',
        cost: {'cuivre': 1}),
    Recipe(
        name: 'Tige en metal',
        description: 'Une tige de métal',
        cost: {'Lingot de fer': 1}),
    Recipe(
        name: 'Fil electrique',
        description:
            'Un fil électrique pour fabriquer des composantsélectroniques',
        cost: {'Lingot de cuivre': 1}),
    Recipe(
        name: 'Mineur',
        description: 'un bon mineur',
        cost: {'Plaque de fer': 10, 'Fil electrique': 5}),
    Recipe(
        name: 'Fonderie',
        description: 'Un bâtiment qui permet d’automatiser la production.',
        cost: {'Fil electrique': 5, 'Tige en metal': 8}),
    Recipe(
        name: 'Dieu mineur',
        description: 'Il est pas là pour rigoler lui...',
        cost: {
          'Lingot de fer': 50,
          'Lingot de cuivre': 50,
          'Fil electrique': 50,
          'Tige en metal': 50,
        }),
  ];

  // Ajout d'une ressource à son compteur
  void addRessource(int index) {
    switch (index) {
      case 0:
        boisCounter++;
        break;
      case 1:
        ferCounter++;
        break;
      case 2:
        cuivreCounter++;
        break;
      case 3:
        charbonCounter++;
        break;
    }

    notifyListeners();
  }

  // Création d'une recette à partir de matériaux/recettes existants
  void createRecipe(int index) {
    Recipe recipe = recipes[index];
    bool canProduce = true;

    // On vérifie si les ressources/recettes nécessaires sont disponibles.
    // On switch sur toutes les ressources de la recette. Si une ressource n'est pas en quantité suffisante, on ne peut pas créer la recette
    recipe.cost.forEach((resource, amount) {
      switch (resource) {
        case 'bois':
          if (boisCounter < amount) canProduce = false;
          break;
        case 'fer':
          if (ferCounter < amount) canProduce = false;
          break;
        case 'cuivre':
          if (cuivreCounter < amount) canProduce = false;
          break;
        case 'charbon':
          if (charbonCounter < amount) canProduce = false;
          break;
        case 'Lingot de fer':
          if (recipes[2].count < amount) canProduce = false;
          break;
        case 'Lingot de cuivre':
          if (recipes[4].count < amount) canProduce = false;
          break;
        case 'Plaque de fer':
          if (recipes[3].count < amount) canProduce = false;
          break;
        case 'Fil electrique':
          if (recipes[6].count < amount) canProduce = false;
          break;
        case 'Tige en metal':
          if (recipes[5].count < amount) canProduce = false;
          break;
      }
    });

    // Si les ressources sont disponibles, recette créée
    if (canProduce) {
      recipe.cost.forEach((resource, amount) {
        switch (resource) {
          case 'bois':
            boisCounter -= amount;
            break;
          case 'fer':
            ferCounter -= amount;
            break;
          case 'cuivre':
            cuivreCounter -= amount;
            break;
          case 'charbon':
            charbonCounter -= amount;
            break;
          case 'Lingot de fer':
            recipes[2].count -= amount;
            break;
          case 'Lingot de cuivre':
            recipes[4].count -= amount;
            break;
          case 'Plaque de fer':
            recipes[3].count -= amount;
            break;
          case 'Tige en metal':
            recipes[5].count -= amount;
            break;
          case 'Fil electrique':
            recipes[6].count -= amount;
            break;
        }
      });

      recipe.count++;

      notifyListeners();
    }
  }

  // Pour montrer que le bouton "Produire" des recettes est disabled si les ressources ne sont pas nécessaires
  bool canProduceRecipe(int index) {
    Recipe recipe = recipes[index];
    bool canProduce = true;

    recipe.cost.forEach((resource, amount) {
      switch (resource) {
        case 'bois':
          if (boisCounter < amount) canProduce = false;
          break;
        case 'fer':
          if (ferCounter < amount) canProduce = false;
          break;
        case 'cuivre':
          if (cuivreCounter < amount) canProduce = false;
          break;
        case 'charbon':
          if (charbonCounter < amount) canProduce = false;
          break;
        case 'Lingot de fer':
          if (recipes[2].count < amount) canProduce = false;
          break;
        case 'Lingot de cuivre':
          if (recipes[4].count < amount) canProduce = false;
          break;
        case 'Plaque de fer':
          if (recipes[3].count < amount) canProduce = false;
          break;
        case 'Fil electrique':
          if (recipes[6].count < amount) canProduce = false;
          break;
        case 'Tige en metal':
          if (recipes[5].count < amount) canProduce = false;
          break;
      }
    });

    return canProduce;
  }
}
