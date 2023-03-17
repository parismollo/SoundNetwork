# NoiseBook Database
- [NoiseBook Database](#noisebook-database)
  - [User](#user)
  - [User Friendship](#user-friendship)
  - [User Follows](#user-follows)
  - [Post: Concert](#post-concert)
  - [Concert](#concert)
  - [Action](#action)
  - [Avis](#avis)
  - [Commentaire](#commentaire)
  - [Mot clée (Hashtags)](#mot-clée-hashtags)
  - [Page Utilisateur](#page-utilisateur)
  - [Playlist](#playlist)
  - [Morceau](#morceau)
  - [User Historique](#user-historique)
  - [User Suggestions](#user-suggestions)

## User
* ID
* Type
  - Person
  - Group
  - Association
  - Salle de Concert
    - Mot clé
  - Lieux (not sure)
    - Mot clé
  - Evenements (not sure)
    - Mot clé

Pas oublier que chaque type a une spécialisation de sorte que seulement les lieux, groupes et
les evenements ont des Mot clés.

## User Friendship
* User 1
* User 2

## User Follows
* User Follows
* User Followed

## Post: Concert
* ID
* ID user
* message
* ID concert

## Concert
Le concert aura deux spécialisations, une concernant le futur et une concernant le passé. 
* prix
* organisateurs
* line-up (ceux qui vont se présenter)
* nombre de places dispo.
* lieu (si connu et légal)
* besoin de volontaires pour aider
* cause en soutient
* espace extérieur
* possibilité d'amener des enfants 

Si passé on pourra archiver un ensemble de données telles que:
  * nombre de participants
  * avis des participants concernant telle performance de tel groupe lors du concert
  * photos, vidéos, etc.

## Action
* Type in ('interessé', 'participe')
* User ID
* Event ID

## Avis
* User ID
* Event ID
* Note
* Commentaires ID

## Commentaire
  * Texte
  * Table avec Mot clées ID's (hashtags comme Insta, twitter)

## Mot clée (Hashtags)
Ici il est important de respecter la contrainte suivante: *Attention à bien représenter le concept de sous-catégorie musicale. Un utilisateur cherchant tous les événements à venir relevant du genre Electronic doit pouvoir trouver une date taguée Freetekno, qui en est un sous-genre, même si le tag Electronic n’est pas directement associé à l’événement*

**Pour cela on peut définir une table catégorie qui contient un attribut sous catégorie, ou faire un table de relations entre categories, de façon que d'un côte on a la catégorie père et d'autre la sous catégorie. (À voir)**

  * NOM: mot qui peut être un:
    * genre musical
    * sous-genre musical
    * mot quelconque
  * table relations mot clé avec user
  * table relations mot clé avec avis

## Page Utilisateur
* User ID
* Playlists (max 10)

## Playlist
  * Author ID (USER ID)
  * Morceaux (max 20)
  * Table de Tags (mots clés)

**Attention**: Si le Type(Playlist.Author) == Groupe, alors CHECK IF Morceau.Author == Playlist.Author, i.e le auteur de la chanson doit être le même du auteur de la playlist si c'est un groupe la auteur de la playlist.

## Morceau
  * Author (User)
  * Table de Notes (Morceau_ID, USER_ID, Note (int))

## User Historique
- Events (par exemple concerts) qui user a participé.
- Musiques qui user a ecouté (?)


## User Suggestions
Ici en fonction de l'utilisateur on doit proposer des suggestions des chansons, concerts, etc. Probablement l'algorithme utilisera des tags afin de proposer quelque chose. Par contre, dans le pdf il dit "*concerts auxquels ils ont assistés, genres voisins qu’ils pourraient explorer, personnes avec lesquelles ils pourraient avoir des affinités, villes dans lesquelles ils pourraient trouver à s’amuser,....*". Ici on perçoit un niveau plus profond de recommendation car par exemple on doit en fonction des concerts et leurs tags identifier quelles villes contiendront les concerts qui peuvent interésser l'utilisateur.

Probablement un table de la structure suivante:

* User_ID
* Table Playlist recommendés (Et ici, on aurait une liste des playlist pour ce user mise en ensemble grace au algorithme de suggestion/recommendation)
* Table Villes recommendés
* Table personnes recommendés
...


**Attention au paragraphe suivante:**

**Réfléchissez au préalable aux requêtes que vous serez amenés à implémenter (Section 3 et 4) pour savoir quellesinformations seront indispensables dans votre base.** Vous commencerez par réaliser le modèle conceptuel de données (schéma entités-associations) pour le Rendu 1, puis vous pourrez passer à l’implémentation dans PostgreSQL pour le Rendu 2. **Utilisez les différents outils étudiés en cours et en TP clés primaires/étrangères, contraintes d’intégrité, types adaptés ...**