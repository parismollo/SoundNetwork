-- 1. Quel est l'artiste qui apparait dans le plus de playlist ?

-- SELECT music.author_id, "user".name, COUNT(*) as playlist_count 
-- FROM playlist_music 
-- JOIN music ON playlist_music.music_id = music.id
-- JOIN "user" ON music.author_id = "user".id 
-- GROUP BY music.author_id, "user".name
-- ORDER BY playlist_count DESC 
-- LIMIT 1;


-- -- 2. Quel est le concert qui a le plus de photos et de vidéos ?
-- SELECT pastConcert.concert_id, COUNT(*) as media_count
-- FROM pastConcertMedia media
-- JOIN pastConcert ON media.pastconcert_id = pastConcert.concert_id
-- GROUP BY pastConcert.concert_id
-- ORDER BY media_count DESC 
-- LIMIT 1;


-- -- 3. Quels sont les 5 concerts en plein air les moins chers ?
-- SELECT concert.id, concert.price
-- FROM concert
-- WHERE concert.outdoor_space = TRUE
-- ORDER BY concert.price ASC 
-- LIMIT 5;

-- -- 4. Quels sont les 5 personnes les plus populaires (avec le plus de followers) ?
-- SELECT follow.followed_id, "user".name, COUNT(*) as followers_count 
-- FROM follow 
-- JOIN "user" ON follow.followed_id = "user".id 
-- GROUP BY follow.followed_id, "user".name
-- ORDER BY followers_count DESC 
-- LIMIT 5;


-- -- 5. Quelle musique apparait dans le plus de playlist ?
-- SELECT playlist_music.music_id, music.name, COUNT(*) as playlist_count 
-- FROM playlist_music 
-- JOIN music ON playlist_music.music_id = music.id
-- GROUP BY playlist_music.music_id, music.name
-- ORDER BY playlist_count DESC 
-- LIMIT 1;

-- -- 6. Quels sont les utilisateurs qui ont assisté à des événements organisés par leurs propres amis ?
-- SELECT action.user_id
-- FROM action 
-- JOIN "event" ON action.event_id = "event".user_id 
-- JOIN friendship ON action.user_id = friendship.friend1_id 
-- WHERE "event".user_id = friendship.friend2_id 
-- GROUP BY action.user_id;

-- -- 7. Quel(s) est(sont) le(s) genre(s) musical(aux) le(s) plus (moins) représenté(s) dans les playlists des utilisateurs ?
-- SELECT playlist_tags.tag_name, COUNT(*) as tag_count 
-- FROM playlist_tags
-- GROUP BY playlist_tags.tag_name
-- ORDER BY tag_count DESC 
-- LIMIT 1;

-- -- Least represented
-- SELECT playlist_tags.tag_name, COUNT(*) as tag_count 
-- FROM playlist_tags
-- GROUP BY playlist_tags.tag_name
-- ORDER BY tag_count ASC 
-- LIMIT 1;

-- -- 8. Quels sont les utilisateurs qui ont organisé des concerts dans au moins 2 lieux (place) différents ?

-- SELECT "event".user_id
-- FROM "event"
-- JOIN concert ON "event".user_id = concert.organizer_event_id
-- JOIN place ON concert.place_id = place.user_id
-- GROUP BY "event".user_id
-- HAVING COUNT(DISTINCT place.user_id) >= 2;

-- -- 9. Quel est l'événement qui a reçu le plus grand nombre de critiques (positives) de la part des utilisateurs ?

-- SELECT review.event_user_id, COUNT(*) as review_count 
-- FROM review 
-- WHERE review.note >= 3
-- GROUP BY review.event_user_id
-- HAVING COUNT(*) >= ALL (
--   SELECT COUNT(*) as review_count 
--   FROM review 
--   WHERE review.note >= 3
--   GROUP BY review.event_user_id
-- );

-- -- 10. Quels sont les utilisateurs qui ont créé une playlist contenant des musiques de tous les artistes qu'ils suivent ?

-- SELECT playlist.author_id
-- FROM playlist 
-- JOIN playlist_music ON playlist.id = playlist_music.playlist_id 
-- JOIN music ON playlist_music.music_id = music.id
-- JOIN follow ON playlist.author_id = follow.follower_id
-- WHERE music.author_id = follow.followed_id
-- GROUP BY playlist.author_id;


-- -- 11. Quelle page utilisateur contient le plus grand nombre de playlists avec le tag "Hip Hop" ?

-- SELECT page_playlist.user_page_id, COUNT(*) as playlist_count 
-- FROM page_playlist 
-- JOIN playlist_tags ON page_playlist.playlist_id = playlist_tags.playlist_id 
-- WHERE playlist_tags.tag_name = 'Hip Hop'
-- GROUP BY page_playlist.user_page_id
-- ORDER BY playlist_count DESC 
-- LIMIT 1;


-- -- 12. Quels sont les places de concert qui proposent le plus de variété musicale dans sa programmation ?

-- SELECT concert.place_id, COUNT(DISTINCT music.author_id) as variety_count
-- FROM concert 
-- JOIN "group" ON concert.artists_group_id = "group".user_id 
-- JOIN music ON "group".user_id = music.author_id 
-- GROUP BY concert.place_id
-- ORDER BY variety_count DESC
-- LIMIT 1;


-- -- 13. Quels sont les utilisateurs qui ont donné la note minimale à tous les evenements auxquels ils ont participé?

-- SELECT review.user_id 
-- FROM review 
-- JOIN "event" ON review.event_user_id = "event".user_id 
-- JOIN action ON review.user_id = action.user_id AND "event".user_id = action.event_id
-- WHERE action.type = 'Participe'
-- GROUP BY review.user_id 
-- HAVING MIN(review.note) = 1 AND COUNT(DISTINCT "event".user_id) = COUNT(DISTINCT review.id);


-- -- 14. Quels sont les places qui ont accueilli le plus grand nombre de concert au cours de l'année dernière ?

-- SELECT concert.place_id, COUNT(*) as event_count 
-- FROM concert 
-- WHERE concert.concert_date > CURRENT_DATE - INTERVAL '1 year'
-- GROUP BY concert.place_id
-- ORDER BY event_count DESC
-- LIMIT 1;


-- -- 15. Quel est le genre musical le plus populaire parmi les utilisateurs actifs ? Un utilisateur actif est utilisateur
-- -- qui a posté au moins un commentaire sur un evenement au cours des 7 derniers jours.

-- SELECT pt.tag_name, COUNT(*) AS tag_count
-- FROM comment AS c
-- JOIN review AS r ON c.review_id = r.id
-- JOIN playlist AS p ON r.user_id = p.author_id
-- JOIN playlist_tags AS pt ON p.id = pt.playlist_id
-- WHERE r.review_date > CURRENT_DATE - INTERVAL '7 days'
-- GROUP BY pt.tag_name
-- ORDER BY tag_count DESC 
-- LIMIT 1;



-- -- 16. Quels sont les utilisateurs qui ont assisté à des concerts d'artistes dont la popularité est supérieure à la popularité moyenne des artistes suivis par leurs amis ?

-- WITH artist_popularity AS (
--   SELECT 
--     artists_group_id AS artist_id, 
--     COUNT(*) AS popularity
--   FROM concert
--   GROUP BY artists_group_id
-- )

-- SELECT action.user_id
-- FROM action
-- JOIN concert ON action.event_id = concert.organizer_event_id
-- JOIN artist_popularity ap ON concert.artists_group_id = ap.artist_id
-- WHERE action.type = 'Participe' AND ap.popularity > (
--     SELECT AVG(popularity)
--     FROM artist_popularity ap2
--     JOIN "group" g ON ap2.artist_id = g.user_id
--     JOIN follow ON g.user_id = follow.followed_id
--     JOIN friendship ON follow.follower_id = friendship.friend2_id
--     WHERE friendship.friend1_id = action.user_id
-- )
-- GROUP BY action.user_id;


-- -- 17 Quels sont les utilisateurs qui ont attribué une note supérieure à la moyenne pour les musiques appartenant à une playlist avec le tag 'Hip Hop' ?

-- SELECT mn.user_id
-- FROM music_notes mn
-- JOIN playlist_music pm ON pm.music_id = mn.music_id
-- JOIN playlist_tags pt ON pt.playlist_id = pm.playlist_id
-- WHERE pt.tag_name = 'Hip Hop'
-- GROUP BY mn.user_id
-- HAVING AVG(mn.note) > (
--     SELECT AVG(mn2.note)
--     FROM music_notes mn2
--     JOIN playlist_music pm2 ON pm2.music_id = mn2.music_id
--     JOIN playlist_tags pt2 ON pt2.playlist_id = pm2.playlist_id
--     WHERE pt2.tag_name = 'Hip Hop'
-- );



-- 18. Trouver les 5 utilisateurs qui ont donné les notes moyennes les plus élevées pour la musique et les lister avec leurs notes moyennes.
-- SELECT 
--     user_id, 
--     AVG(note) AS average_rating 
-- FROM 
--     music_notes 
-- GROUP BY 
--     user_id 
-- ORDER BY 
--     average_rating DESC 
-- LIMIT 5;



-- 19. Trouvez tous les tags qui sont directement ou indirectement sous un tag de catégorie principale.

-- WITH RECURSIVE tag_hierarchy AS (
--   SELECT child 
--   FROM parent_child_tags 
--   WHERE parent = 'Classical'
--   UNION ALL
--   SELECT pct.child 
--   FROM parent_child_tags pct 
--   JOIN tag_hierarchy th ON pct.parent = th.child
-- )
-- SELECT * FROM tag_hierarchy;

--  Get each user's total participation count to concerts along with a rank based on the count.
--  20. Donner le classement entre les utilisateurs selon leur nombre total de participations à des concerts.

-- WITH user_participations AS (
--   SELECT a.user_id,
--          COUNT(*) as participation_count
--   FROM action a
--   WHERE a.type = 'Participe'
--   GROUP BY a.user_id
-- )

-- SELECT up.user_id, up.participation_count,
--   RANK() OVER (ORDER BY up.participation_count DESC) as rank
-- FROM user_participations up;

