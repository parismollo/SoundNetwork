# NoiseBook_BD6
Projet de L3 semestre 6 (Licence d'informatique générale).

## Description
Ce projet a pour but de représenter un réseau social centré sur la musique.

## Modélisation conceptuelle
> Deadline: 03/04/23

## Requêtes

Il est maintenant temps d’utiliser votre base de données pour faire vivre votre réseau social. Imaginez
20 questions sur la base de données que vous avez modélisée, et écrivez des requêtes SQL permettant d’y
répondre. L’originalité des questions et la difficulté des requêtes (si tant est que celle-ci soit nécessaire)
seront prises en compte dans la notation. Parmi vos requêtes, il faut au minimum :
— une requête qui porte sur au moins trois tables ;
— une ’auto jointure’ ou ’jointure réflexive’ (jointure de deux copies d’une même table)
— une sous-requête corrélée ;
— une sous-requête dans le FROM ;
— une sous-requête dans le WHERE ;
— deux agrégats nécessitant GROUP BY et HAVING ;
— une requête impliquant le calcul de deux agrégats (par exemple, les moyennes d’un ensemble de
maximums) ;
— une jointure externe (LEFT JOIN, RIGHT JOIN ou FULL JOIN) ;
— deux requêtes équivalentes exprimant une condition de totalité, l’une avec des sous requêtes corré-
lées et l’autre avec de l’agrégation ;
— deux requêtes qui renverraient le même résultat si vos tables ne contenaient pas de nulls, mais
qui renvoient des résultats différents ici (vos données devront donc contenir quelques nulls), vous
proposerez également de petites modifications de vos requêtes (dans l’esprit de ce qui sera présenté
dans le cours sur l’information incomplète) afin qu’elles retournent le même résultat ;
— une requête récursive (par exemple, une requête permettant de calculer quel est le prochain jour
off d’un groupe actuellement en tournée) ;
Exemple : Napalm Death est actuellement en tournée (Campagne for Musical Destruction 2023),
ils jouent sans interruption du 28/02 au 05/03, mais ils ont un jour off le 06/03 entre Utrecht
(05/03) et Bristol (07/03). En supposant qu’on est aujourd’hui le 28/02, je souhaite connaître leur
prochain jour off, qui est donc le 06/03.
— une requête utilisant du fenêtrage (par exemple, pour chaque mois de 2022, les dix groupes dont
les concerts ont eu le plus de succès ce mois-ci, en termes de nombre d’utilisateurs ayant indiqué
souhaiter y participer).
Prenez l’habitude de bien programmer vos requêtes SQL. Structurez vos requêtes et surtout indentez-les
correctement. N’utilisez pas les sous-requêtes là où une jointure suffirait. N’utilisez pas les vues si c’est
uniquement dans le but de simplifier l’écriture d’une requête complexe. Enfin, vous pouvez essayer de
trouver une requête qui vous semble difficile (ou impossible) à effectuer dans votre modèle, et suggérer
une modification de votre modélisation initiale qui faciliterait l’implémentation de cette requête.










## VERSION 1
--------------

1. Quels utilisateurs suivent l'utilisateur avec l'ID 5 ?

```sql
SELECT u.name
FROM "user" u
JOIN follow f ON f.follower_id = u.id
WHERE f.followed_id = 5;
```

2. Quels utilisateurs sont amis avec l'utilisateur dont le nom est "John" ?

```sql
SELECT u.name
FROM "user" u
JOIN friendship f ON f.friend1_id = u.id OR f.friend2_id = u.id
WHERE u.name = 'John';
```

3. Quels événements ont été créés par des groupes ?

```sql
SELECT e.user_id
FROM "event" e
JOIN "group" g ON g.user_id = e.user_id;
```

4. Quels artistes font partie du groupe dont l'ID est 10 ?

```sql
SELECT u.name
FROM "user" u
JOIN "group" g ON g.user_id = u.id
WHERE g.user_id = 10;
```

5. Quels utilisateurs ont créé des pages personnelles ?

```sql
SELECT u.name
FROM "user" u
JOIN user_page up ON up.user_id = u.id;
```

6. Quelles chansons ont été notées par l'utilisateur avec l'ID 7 ?

```sql
SELECT m.name
FROM music m
JOIN music_notes mn ON mn.music_id = m.id
WHERE mn.user_id = 7;
```

7. Quelles playlists contiennent la chanson avec l'ID 15 ?

```sql
SELECT p.name
FROM playlist p
JOIN playlist_music pm ON pm.playlist_id = p.id
WHERE pm.music_id = 15;
```

8. Quels concerts ont eu lieu dans la salle de concert avec l'ID 3 ?

```sql
SELECT c.id
FROM concert c
WHERE c.place_id = 3;
```

9. Quels concerts en plein air ont été organisés ?

```sql
SELECT c.id
FROM concert c
WHERE c.outdoor_space = TRUE;
```

10. Quels utilisateurs ont participé à des concerts organisés par l'utilisateur dont l'ID est 8 ?

```sql
SELECT u.name
FROM "user" u
JOIN action a ON a.user_id = u.id
JOIN concert c ON c.id = a.event_id AND c.organizer_event_id = 8
WHERE a.type = 'Participé';
```

11. Quelles sont les étiquettes associées à la salle de concert avec l'ID 2 ?

```sql
SELECT t.name
FROM tags t
JOIN concert_hall_tags cht ON cht.tag_name = t.name
WHERE cht.place_id = 2;
```

12. Quels événements ont les étiquettes "Rock" et "Festival" ?

```sql
SELECT e.user_id
FROM "event" e
JOIN event_tags et ON et.event_id = e.user_id
JOIN tags t ON t.name = et.tag_name
WHERE t.name IN ('Rock', 'Festival')
GROUP BY e.user_id
HAVING COUNT(DISTINCT t.name) = 2;
```

13. Quelles playlists ont les étiquettes "Party" et "Dance" ?

```sql
SELECT p.name
FROM playlist p
JOIN playlist_tags pt1 ON pt1.playlist_id = p.id
JOIN tags t1 ON t1.name = pt1.tag_name
JOIN playlist_tags pt2 ON pt2.playlist_id = p.id
JOIN tags t2 ON t2.name = pt2.tag_name
WHERE t1.name = 'Party' AND t2.name = 'Dance';
```

14. Quels concerts ont reçu des critiques avec une note supérieure à 4 ?

```sql
SELECT c.id
FROM concert c
JOIN review r ON r.event_user_id = c.organizer_event_id
WHERE r.note > 4;
```

15. Quels commentaires ont été laissés sur la critique avec l'ID 12 ?

```sql
SELECT c.content
FROM comment c
WHERE c.review_id = 12;
```

16. Quelles actions ont été effectuées par l'utilisateur avec l'ID 3 ?

```sql
SELECT a.type
FROM action a
WHERE a.user_id = 3;
```

17. Quels utilisateurs ont créé des playlists contenant plus de 15 chansons ?

```sql
SELECT u.name
FROM "user" u
JOIN playlist p ON p.author_id = u.id
JOIN (
    SELECT pm.playlist_id, COUNT(pm.music_id) AS num_songs
    FROM playlist_music pm
    GROUP BY pm.playlist_id
    HAVING COUNT(pm.music_id) > 15
) sub ON sub.playlist_id = p.id;
```

18. Quels utilisateurs ont créé des pages personnelles et sont amis avec l'utilisateur dont l'ID est 6 ?

```sql
SELECT u.name
FROM "user" u
JOIN user_page up ON up.user_id = u.id
JOIN friendship f ON (f.friend1_id = u.id AND f.friend2_id = 6) OR (f.friend1_id = 6 AND f.friend2_id = u.id);
```

19. Quels événements ont été organisés par des utilisateurs qui suivent l'utilisateur avec l'ID 9 ?

```sql
SELECT e.user_id
FROM "event" e
JOIN follow f ON f.followed_id = e.user_id
WHERE f.follower_id = 9;
```

20. Quels utilisateurs ont créé des playlists contenant des chansons de leur propre groupe ?

```sql
SELECT u.name
FROM "user" u
JOIN "group" g ON g.user_id = u.id
JOIN music m ON m.author_id = g.user_id
JOIN playlist_music pm ON pm.music_id = m.id
JOIN playlist p ON p.id = pm.playlist_id AND p.author_id = u.id;
```

Notez que les requêtes sont basées sur la structure de la base de données fournie, et il est important d'avoir les données appropriées pour obtenir des résultats significatifs.



























## VERSION 2
--------

1. Quels sont les utilisateurs qui ont le plus d'amis en commun avec l'utilisateur X ?
2. Quels sont les utilisateurs qui ont participé à tous les événements organisés par l'utilisateur X ?
3. Quels sont les utilisateurs qui ont participé à un concert d'un artiste suivi par l'utilisateur X ?
4. Quels sont les utilisateurs qui ont organisé des événements dans toutes les salles de concert d'une ville donnée ?
5. Quels sont les utilisateurs qui ont organisé des événements dans des salles de concert de tous les pays ?
6. Quels sont les utilisateurs qui ont assisté à des événements organisés par leurs propres amis ?
7. Quels sont les utilisateurs qui ont créé des playlists contenant uniquement des musiques d'un genre musical spécifique ?
8. Quels sont les utilisateurs qui ont participé à des événements dans tous les mois de l'année ?
9. Quels sont les utilisateurs qui ont donné la note maximale à tous les concerts d'un artiste donné ?
10. Quels sont les utilisateurs qui ont organisé des événements dans des salles de concert où ils n'ont jamais assisté à un concert ?
11. Quels sont les utilisateurs qui ont assisté à des concerts organisés par des utilisateurs dont ils ne suivent pas ?
12. Quels sont les utilisateurs qui ont donné la note maximale à toutes les musiques d'un album donné ?
13. Quels sont les utilisateurs qui ont organisé des événements dont les tags correspondent à tous les tags d'un événement spécifique ?
14. Quels sont les utilisateurs qui ont donné la note minimale à tous les concerts auxquels ils ont participé, sauf un ?
15. Quels sont les utilisateurs qui ont créé une playlist contenant des musiques de tous les artistes qu'ils suivent ?
16. Quels sont les utilisateurs qui ont organisé des événements dans des salles de concert situées dans des villes différentes de leur lieu de résidence ?
17. Quels sont les utilisateurs qui ont assisté à des événements organisés par des utilisateurs qu'ils suivent depuis moins de 6 mois ?
18. Quels sont les utilisateurs qui ont créé une playlist contenant des musiques d'au moins un artiste dont le nom contient une certaine séquence de lettres ?
19. Quels sont les utilisateurs qui ont participé à des événements organisés par des utilisateurs ayant le même nom de famille ?
20. Quels sont les utilisateurs qui ont donné une note supérieure à la moyenne à toutes les musiques d'un genre musical donné ?


## VERSION 3

Quels sont les artistes les plus suivis par les utilisateurs qui ont assisté à des événements organisés dans une salle de concert spécifique ?
Quels sont les événements auxquels ont participé des utilisateurs qui suivent un artiste dont la nationalité diffère de celle de l'organisateur de l'événement ?
Quels sont les utilisateurs qui ont assisté à des événements organisés par des utilisateurs qui ont également assisté à des événements auxquels ils n'ont pas participé ?
Quels sont les albums les mieux notés par les utilisateurs qui ont assisté à des concerts d'un artiste suivi par l'utilisateur X ?
Quels sont les utilisateurs qui ont organisé des événements dans des villes où ils ont également assisté à des concerts d'artistes dont le genre musical correspond à un genre musical spécifique ?
Quels sont les utilisateurs qui ont donné une note supérieure à la moyenne à tous les albums d'artistes originaires d'un pays donné ?
Quels sont les événements qui se sont déroulés dans des salles de concert situées dans des villes où aucun utilisateur n'a organisé d'événement ?
Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont la popularité est supérieure à la moyenne des popularités des artistes qu'ils suivent ?
Quels sont les utilisateurs qui ont donné la note minimale à tous les concerts organisés par des utilisateurs qui les suivent ?
Quels sont les utilisateurs qui ont créé des playlists contenant des musiques de tous les genres musicaux auxquels ils ont assisté lors de concerts ?
Quels sont les événements organisés par des utilisateurs qui ont assisté à des concerts dans des salles de concert où ils n'ont jamais organisé d'événement ?
Quels sont les utilisateurs qui ont assisté à des concerts d'artistes ayant une moyenne de notes supérieure à la moyenne des moyennes de notes de tous les artistes suivis par l'utilisateur X ?
Quels sont les utilisateurs qui ont donné la note maximale à tous les concerts organisés dans une salle de concert spécifique ?
Quels sont les utilisateurs qui ont créé des playlists contenant des musiques de tous les artistes ayant participé à des événements organisés dans une ville donnée ?
Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont le nombre de fans est supérieur à la moyenne des nombres de fans de tous les artistes suivis par les utilisateurs qui les suivent ?
Quels sont les utilisateurs qui ont organisé des événements dans des salles de concert situées dans des pays où aucun de leurs amis n'a assisté à un concert ?
Quels sont les utilisateurs qui ont donné la note minimale à tous les albums d'artistes dont le genre musical est différent de celui de l'utilisateur X ?
Quels sont les utilisateurs qui ont assisté à des événements organisés par des utilisateurs dont le nom de famille est le même que le leur ?
Quels sont les utilisateurs qui ont donné une note supérieure à la moyenne à tous les concerts auxquels ils ont participé, sauf ceux organisés par l'utilisateur X ?

## VERSION 4
----
Quels sont les événements organisés par des utilisateurs qui ont reçu une note supérieure à la moyenne attribuée par les utilisateurs de leur pays d'origine ?

Quels sont les utilisateurs qui ont organisé des événements dans des salles de concert dont la capacité est supérieure à la moyenne des capacités des salles de concert situées dans la même ville ?

- Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont la moyenne des notes attribuées par les utilisateurs de leur pays d'origine est supérieure à la moyenne des notes attribuées par les utilisateurs de tous les pays ?

Quels sont les événements organisés dans des salles de concert ayant une capacité supérieure à la capacité moyenne des salles de concert de la même ville, et dont la date est postérieure à celle de tous les autres événements organisés dans la même salle ?

Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont la moyenne des notes attribuées par les utilisateurs qui les suivent est supérieure à la moyenne des notes attribuées par les utilisateurs qui suivent tous les artistes ?

Quels sont les utilisateurs qui ont donné la note maximale à tous les concerts organisés par des utilisateurs ayant un nombre de followers supérieur à leur propre nombre de followers ?

Quels sont les événements organisés par des utilisateurs qui ont donné une note supérieure à la moyenne à tous les albums d'un genre musical spécifique ?

Quels sont les utilisateurs qui ont créé des playlists contenant des musiques d'artistes originaires d'un pays donné ?

Quels sont les utilisateurs qui ont assisté à des événements organisés par des utilisateurs dont la moyenne des notes attribuées par leurs amis est supérieure à la moyenne des notes attribuées à tous les événements organisés dans la même ville ?

Quels sont les événements organisés par des utilisateurs qui ont assisté à des concerts d'artistes ayant une popularité supérieure à la moyenne des popularités des artistes suivis par les utilisateurs qui les suivent ?

Quels sont les utilisateurs qui ont organisé des événements dans des salles de concert situées dans des villes dont le nombre d'utilisateurs qui ont assisté à un concert est supérieur à la moyenne des nombres d'utilisateurs qui ont assisté à un concert dans toutes les villes ?
Quels sont les utilisateurs qui ont donné la note minimale à tous les concerts organisés par des utilisateurs ayant une moyenne de notes supérieure à la moyenne des moyennes de notes attribuées à tous les concerts ?
Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont la popularité est supérieure à la moyenne des popularités des artistes suivis par leurs amis qui habitent dans la même ville ?
Quels sont les utilisateurs qui ont organisé des événements dans des salles de concert dont le pays est différent de celui de leur lieu de résidence ?
Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont le genre musical est différent de celui de tous les autres artistes organisant des événements dans la même salle de concert ?
Quels sont les utilisateurs qui ont créé des playlists contenant des musiques de tous les albums d'artistes ayant une popularité supérieure à la moyenne des popularités de tous les artistes ?
Quels sont les événements organisés par des utilisateurs qui ont assisté à des concerts d'artistes dont la moyenne des notes attribuées par les utilisateurs qui les suivent est supérieure à la moyenne des notes attribuées par les utilisateurs qui suivent tous les artistes organisant des événements dans la même salle de concert ?

## VERSION 5 - 20 meilleurs questions 
-----
Quels sont les utilisateurs qui ont participé à tous les événements organisés par l'utilisateur X ?
Quels sont les utilisateurs qui ont participé à un concert d'un artiste suivi par l'utilisateur X ?

Quels sont les utilisateurs qui ont organisé des événements dans toutes les salles de concert d'une ville donnée ?

Quels sont les utilisateurs qui ont créé des playlists contenant uniquement des musiques d'un genre musical spécifique ?
Quels sont les utilisateurs qui ont donné la note maximale à tous les concerts d'un artiste donné ?

Quels sont les utilisateurs qui ont assisté à des concerts organisés par des utilisateurs qu'ils ne suivent pas ?

Quels sont les utilisateurs qui ont donné la note maximale à toutes les musiques d'un album donné ?

Quels sont les utilisateurs qui ont créé une playlist contenant des musiques d'au moins un artiste dont le nom contient une certaine séquence de lettres ?
Quels sont les utilisateurs qui ont donné une note supérieure à la moyenne à toutes les musiques d'un genre musical donné ?

Quels sont les utilisateurs qui ont donné la note maximale à tous les concerts organisés dans une salle de concert spécifique ?



## VERSION 6 - 20 meilleurs questions avec 5 complexes, reponse FINALE
Quels sont les utilisateurs qui ont créé des playlists contenant uniquement des musiques d'un genre musical spécifique ?

Quels sont les utilisateurs qui ont assisté à des événements organisés par des utilisateurs qu'ils suivent depuis moins de 6 mois ?

Quels sont les utilisateurs qui ont créé une playlist contenant des musiques de tous les artistes qu'ils suivent ?

Quels sont les utilisateurs qui ont donné la note maximale à tous les concerts organisés dans une salle de concert spécifique ?

Quels sont les utilisateurs qui ont organisé des événements dans des salles de concert dont la capacité est supérieure à la moyenne des capacités des salles de concert situées dans la même ville ?

Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont la moyenne des notes attribuées par les utilisateurs qui les suivent est supérieure à la moyenne des notes attribuées par les utilisateurs qui suivent tous les artistes ?

Quels sont les utilisateurs qui ont donné la note maximale à tous les concerts organisés par des utilisateurs ayant un nombre de followers supérieur à leur propre nombre de followers ?

Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont le genre musical est différent de celui de tous les autres artistes suivis par l'utilisateur X ?

-- Quels sont les utilisateurs qui ont donné une note supérieure à la moyenne à toutes les musiques d'un genre musical donné ?
-- Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont la moyenne des notes attribuées par les utilisateurs de leur pays d'origine est supérieure à la moyenne des notes attribuées par les utilisateurs de tous les pays ?
-- Quels sont les événements organisés dans des salles de concert ayant une capacité supérieure à la capacité moyenne des salles de concert de la même ville, et dont la date est postérieure à celle de tous les autres événements organisés dans la même salle ?


## Version Question sur page utilisateur, categories, places de concert, playlists etc...

Combien de playlists contiennent au moins une musique de la catégorie musicale "Hip-hop" ?

Combien de playlists contiennent au moins une musique de l'artiste favori de l'utilisateur X ?

Combien de playlists contiennent au moins une musique des catégories musicales "Rap" et "Trap" ?

Combien de playlists contiennent au moins une musique de l'artiste XYZ et ont été créées par des utilisateurs ayant plus de 1000 followers ?



































## Organisation des questions

## QUESTIONS FACILES (5 questions ?)
- Quel est l'artiste qui apparait dans le plus de playlist (avec le tag "Rock" ou pas)?
- Quel est le concert qui a le plus de photos et de vidéos ?
- Quels sont les 5 concerts en plein air les moins chers ?
- Quels sont les 5 personnes les plus populaires (avec le plus de followers) ?
- Quelle musique apparait dans le plus de playlist ?

## QUESTIONS MOYENNES (10 questions ?)
- Quels sont les utilisateurs qui ont assisté à des événements organisés par leurs propres amis ?
- Quel(s) est(sont) le(s) genre(s) musical(aux) le(s) plus (moins) représenté(s) dans les playlists des utilisateurs ?
- Quels sont les utilisateurs qui ont organisé des événements dans des salles de concert situées dans des villes différentes de leur lieu de résidence ?
- Quel est l'événement qui a reçu le plus grand nombre de critiques (positives ou negatives ou rien] de la part des utilisateurs ?
- Quels sont les utilisateurs qui ont créé une playlist contenant des musiques de tous les artistes qu'ils suivent ?
- Quelle page utilisateur contient le plus grand nombre de playlists avec le tag "Summer Vibes" ?
- Quel(s) est(sont) le(s) place(s) de concert qui propose(nt) le plus de variété musicale dans sa programmation ?
- Quels sont les utilisateurs qui ont donné la note minimale à tous les concerts auxquels ils ont participé, sauf un ?
- Quels sont les utilisateurs qui ont assisté à des événements organisés par des utilisateurs qu'ils suivent depuis moins de 6 mois ?
- Quel(s) est(sont) le(s) place(s) de concert qui a accueilli le plus grand nombre d'événements au cours de l'année dernière ?

## QUESTIONS DIFFICILES (5 questions ?)
- Quel(s) est(sont) le(s) genre(s) musical(aux) le plus populaire(s) parmi les utilisateurs actifs ? Un utilisateur actif est utilisateur qui a posté au moins un commentaire sur un evenement au cours des 7 derniers jours (par exemple).
- Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont la popularité est supérieure à la popularité moyenne des artistes suivis par leurs amis ?
- Quels sont les événements organisés par des utilisateurs dont la moyenne des notes attribuées par leurs amis est supérieure à la moyenne des notes attribuées à tous les événements ?
- Pour chaque mois de 2022, quels sont les cinq groupes dont les concerts ont été les plus partagés ce mois-ci, en termes de nombre de photos/vidéos postées?