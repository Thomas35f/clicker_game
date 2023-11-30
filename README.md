# Installation
``` bash
flutter pub get
flutter run
```

## Références / Ressources
- https://codelabs.developers.google.com/codelabs/flutter-codelab-first?hl=fr#4 > Le codelab m'a servi pour me remémorer l'organisation générale des widgets
- https://api.flutter.dev/flutter/widgets/widgets-library.html > La doc de Flutter concernant ses widgets
- https://github.com/Thomas35f/e_commerce_app > Un projet fait l'an dernier en flutter. C'est une application e-commerce
- https://chat.openai.com/ > Pour résoudre les bugs que je rencontrais

## Choix de design / implémenation : 
- Chaque page a son fichier dédié
- Le fichier main.dart appelle la homepage
- J'ai commencé le projet en implémentant un MultiProvider en pensant mettre plusieurs providers (un pour les ressources et un pour les recettes). Finalement, comme les 2 sont très liés, j'ai tout concentré dans un seul fichier en essayant de bien séparer les éléments. Le fichier main_provider.dart est donc le point central de l'appli qui gère les initialisations des ressources et des recettes.

- Une ressource est un compteur simple. Chacune est associée en front à un widget Ressource de type Stateless.
- Pour les recettes, j'ai une liste qui va contenir des instances de la classe Recipe. Chaque instance a un nom, une desciption, un coût et un compteur (0 par défaut)

Lors de l'ajout d'une ressource, il s'agit d'une simple incrémentation de compteur à la ressource associée. L'index est utilisé.

Pour créer une recette, on a un bool canProduce qui va être défini en fonction de si les ressources sont disponibles. Au début du jeu, on utilise des matériaux puis ça évolue vers des recettes créées avant. On fait donc un switch sur le compteur de ressources ainsi que le compteur des recettes (d'où leur initialisation à 0 par défaut).

Si c'est bon, on créé la recette puis on décrémente les ressources utilisées de leur compteur respectif.