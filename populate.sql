-- Import CSV files into corresponding tables
COPY "user"(id, name) FROM 'CSV/user.csv' DELIMITER ',' CSV HEADER;
COPY follow(follower_id, followed_id) FROM 'CSV/follow.csv' DELIMITER ',' CSV HEADER;
COPY friendship(friend1_id, friend2_id) FROM 'CSV/friendship.csv' DELIMITER ',' CSV HEADER;
COPY "event"(user_id) FROM 'CSV/event.csv' DELIMITER ',' CSV HEADER;
COPY "group"(user_id) FROM 'CSV/group.csv' DELIMITER ',' CSV HEADER;
COPY person(user_id) FROM 'CSV/person.csv' DELIMITER ',' CSV HEADER;
COPY place(user_id, address) FROM 'CSV/place.csv' DELIMITER ',' CSV HEADER;
COPY concertHall(place_id, name) FROM 'CSV/concertHall.csv' DELIMITER ',' CSV HEADER;
COPY associations(user_id) FROM 'CSV/associations.csv' DELIMITER ',' CSV HEADER;
COPY music(id, author_id, name) FROM 'CSV/music.csv' DELIMITER ',' CSV HEADER;
COPY post(id, user_id, text, user_page) FROM 'CSV/post.csv' DELIMITER ',' CSV HEADER;
COPY review(id, user_id, text, music_id) FROM 'CSV/review.csv' DELIMITER ',' CSV HEADER;
COPY comment(id, user_id, content, review_id) FROM 'CSV/comment.csv' DELIMITER ',' CSV HEADER;
COPY action(id, type, user_id, event_id) FROM 'CSV/action.csv' DELIMITER ',' CSV HEADER;
COPY user_page(id, user_id) FROM 'CSV/user_page.csv' DELIMITER ',' CSV HEADER;
COPY playlist(id, author_id, name, user_page) FROM 'CSV/playlist.csv' DELIMITER ',' CSV HEADER;
COPY music_notes(music_id, user_id, note) FROM 'CSV/music_notes.csv' DELIMITER ',' CSV HEADER;
COPY playlist_music(playlist_id, music_id) FROM 'CSV/playlist_music.csv' DELIMITER ',' CSV HEADER;
COPY page_playlist(user_page_id, playlist_id) FROM 'CSV/page_playlist.csv' DELIMITER ',' CSV HEADER;
COPY pastConcert(concert_id, nb_participants) FROM 'CSV/pastConcert.csv' DELIMITER ',' CSV HEADER;
COPY pastConcertMedia(pastconcert_id, photo) FROM 'CSV/pastConcertMedia.csv' DELIMITER ',' CSV HEADER;
COPY futureConcert(concert_id, need_volunteers, nb_interested_people, nb_available_spots) FROM 'CSV/futureConcert.csv' DELIMITER ',' CSV HEADER;
COPY tags(name) FROM 'CSV/tag.csv' DELIMITER ',' CSV HEADER;
COPY parent_child_tags(parent, child) FROM 'CSV/parent_child_tags.csv' DELIMITER ',' CSV HEADER;
COPY concert_hall_tags(place_id, tag_name) FROM 'CSV/concert_hall_tags.csv' DELIMITER ',' CSV HEADER;
COPY event_tags(event_id, tag_name) FROM 'CSV/event_tags.csv' DELIMITER ',' CSV HEADER;
COPY playlist_tags(playlist_id, tag_name) FROM 'CSV/playlist_tags.csv' DELIMITER ',' CSV HEADER;
COPY commentTag(comment_id, tag_name) FROM 'CSV/commentTag.csv' DELIMITER ',' CSV HEADER;

-- Manually generate the concert data from 'CSV/concert.csv' due to the complexity of the data format
BEGIN;
CREATE TEMP TABLE tmp_concert AS SELECT * FROM concert LIMIT 0;  -- create an empty temporary table with the same structure as 'concert'
COPY tmp_concert FROM 'CSV/concert.csv' DELIMITER ',' CSV HEADER;  -- import csv data into the temporary table
INSERT INTO concert(id, organizer_event_id, artists_group_id, place_id, price, supporting_cause, outdoor_space, child_allowed, concert_date) 
SELECT id, organizer_event_id, artists_group_id, place_id, price, supporting_cause, outdoor_space::boolean, child_allowed::boolean, concert_date::date FROM tmp_concert;
DROP TABLE tmp_concert;
COMMIT;
