# Restaurant

## Qu'est-ce que c'est ?

Restaurant est une app iOS qui permet de commander les plats d'un restaurant. 

## Contexte 

Restaurant est le 5<sup>ème</sup> et dernier projet de [App Development with Swift](https://books.apple.com/us/book/app-development-with-swift/id1465002990) (Apple, 2017), un guide d'apprentissage du développement d'applications iPhone.

Le projet a été développé en suivant globalement l es instructions du guide, bien que plusieurs libertés aient été prises dans la réalisation. 

D'un point de vue pédagogique, ce projet renforce les acquis des projets [Light](https://github.com/Ludophilia/Light), [Apple Pie](https://github.com/Ludophilia/Apple-Pie), [Personality Quizz](https://github.com/Ludophilia/PersonalityQuizz) et [ToDoList](https://github.com/Ludophilia/ToDoList) et entraine entre autres à l'acquisition des éléments suivants :

- App
    - Prise en main de AppDelegate et SceneDelegate (UIKit) pour mettre en place des routines à chaque étape de la vie de l'application (démarrage, mise en arrière plan, arrêt...)
    - Utilisation de Notification et NotificationCenter (Foundation) pour coordonner certaines opérations entre plusieurs parties de l'application. Ex : Changement dans le panier qui modifie l'état du TabBarController.

- UI
    - Utilisation de DispatchQueue (Dispatch) pour gérer les tâches UI asynchrones à effectuer sur le thread principal. 
    - Utilisation des animations avec les propriétés et méthodes transform et animate() de UIView et les CGAffineTransform (Core Graphics).
    - Utilisation de ViewControllers additionnels comme AlertController (UIKit).
    - Utilisation d'un UITabBarController pour gérer l'UITabBar.

- Réseau
    - Prise en main du dictionnaire "App Transport Security Settings" de Info.plist pour permettre la communication en HTTP non sécurisée.
    - Gestion de la communication HTTP avec le serveur via les méthodes de URLSession, URLRequest, URLSessionDataTask (Foundation).
    - Structuration des objets de la couche model avec le protocole CodingKey (Swift Standard Library) pour permettre leur sérialisation ou désérialisation vers ou depuis un JSON.
    - Mise en place d'un cache URLCache (Foundation) pour les requêtes réseau réccurentes.

- Restauration d'état
    -  Gestion de la Restoration d'État avec NSUserActivity (Foundation), UISceneSession, UIResponder, et SceneDelegate (UIKIt).

## Compatibilité 

L'application est optimisée pour iOS 15.

L'application nécessite l'exécution d'un mini serveur HTTP Python contenu dans le fichier `restaurantserver.py`. Ce serveur nécessite une version de Python >= 3.6.

 Pour lancer le serveur :
 1. Lancer le terminal
 2. Se placer dans le dossier PyRestaurant
 3. Utiliser la commande `python3 restaurantserver.py`

## Captures

<img src="walkthough_iphone13.gif" style="height:750px">

