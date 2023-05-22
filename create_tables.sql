-- Drop tables if they exist
DROP TABLE IF EXISTS "action" CASCADE;
DROP TABLE IF EXISTS commentTag CASCADE;
DROP TABLE IF EXISTS comment CASCADE;
DROP TABLE IF EXISTS review CASCADE;
DROP TABLE IF EXISTS playlist_tags CASCADE;
DROP TABLE IF EXISTS event_tags CASCADE;
DROP TABLE IF EXISTS concert_hall_tags CASCADE;
DROP TABLE IF EXISTS parent_child_tags CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS post CASCADE;
DROP TABLE IF EXISTS futureConcert CASCADE;
DROP TABLE IF EXISTS pastConcert CASCADE;
DROP TABLE IF EXISTS concert CASCADE;
DROP TABLE IF EXISTS pastConcertMedia CASCADE;
DROP TABLE IF EXISTS playlist CASCADE;
DROP TABLE IF EXISTS playlist_music CASCADE;
DROP TABLE IF EXISTS page_playlist CASCADE;
DROP TABLE IF EXISTS music_notes CASCADE;
DROP TABLE IF EXISTS music CASCADE;
DROP TABLE IF EXISTS user_page CASCADE;
DROP TABLE IF EXISTS associations CASCADE;
DROP TABLE IF EXISTS concertHall CASCADE;
DROP TABLE IF EXISTS place CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS "group" CASCADE;
DROP TABLE IF EXISTS "event" CASCADE;
DROP TABLE IF EXISTS friendship CASCADE;
DROP TABLE IF EXISTS follow CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;

CREATE TABLE "user" (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE follow (
  follower_id INT NOT NULL,
  followed_id INT NOT NULL,
  FOREIGN KEY (follower_id) REFERENCES "user" (id) ON DELETE CASCADE,
  FOREIGN KEY (followed_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE friendship (
  friend1_id INT NOT NULL,
  friend2_id INT NOT NULL,
  FOREIGN KEY (friend1_id) REFERENCES "user" (id) ON DELETE CASCADE,
  FOREIGN KEY (friend2_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE "event" (
  user_id INT PRIMARY KEY,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE "group" (
  user_id INT PRIMARY KEY,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE person (
  user_id INT PRIMARY KEY,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE place (
  user_id INT PRIMARY KEY,
  address VARCHAR(255) UNIQUE NOT NULL,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE concertHall (
  place_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  FOREIGN KEY (place_id) REFERENCES place (user_id) ON DELETE CASCADE
);

CREATE TABLE associations (
  user_id INT PRIMARY KEY,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE user_page (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE music (
  id SERIAL PRIMARY KEY,
  author_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  FOREIGN KEY (author_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE music_notes (
  music_id INT NOT NULL,
  user_id INT NOT NULL,
  note INT NOT NULL CHECK (note >= 0 AND note <= 5),
  FOREIGN KEY (music_id) REFERENCES music (id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE
);

CREATE TABLE playlist (
  id SERIAL PRIMARY KEY,
  author_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  user_page INT,
  FOREIGN KEY (author_id) REFERENCES "user" (id) ON DELETE CASCADE,
  FOREIGN KEY (user_page) REFERENCES user_page (id) ON DELETE CASCADE
);

CREATE TABLE page_playlist (
  user_page_id INT,
  playlist_id INT,
  PRIMARY KEY (user_page_id, playlist_id),
  FOREIGN KEY (user_page_id) REFERENCES user_page (id) ON DELETE CASCADE,
  FOREIGN KEY (playlist_id) REFERENCES playlist (id) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION max_playlists_per_page_check() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM page_playlist WHERE user_page_id = NEW.user_page_id) > 10 THEN
        RAISE EXCEPTION 'Le nombre maximum de playlists pour une page est de 10';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER max_playlists_per_page
AFTER INSERT OR UPDATE ON page_playlist
FOR EACH ROW
EXECUTE FUNCTION max_playlists_per_page_check();

CREATE TABLE playlist_music (
  playlist_id INT,
  music_id INT,
  PRIMARY KEY (playlist_id, music_id),
  FOREIGN KEY (playlist_id) REFERENCES playlist (id) ON DELETE CASCADE,
  FOREIGN KEY (music_id) REFERENCES music (id) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_author_and_songs_per_playlist()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM "group"
    WHERE "group".user_id = (SELECT author_id FROM playlist WHERE NEW.playlist_id = playlist.id)
  ) THEN 
    IF (
      SELECT COUNT(*) FROM music
      WHERE music.id = NEW.music_id AND
      music.author_id != (SELECT author_id FROM playlist WHERE NEW.playlist_id = playlist.id)
    ) > 0 THEN RAISE EXCEPTION 'Playlist with group as author can only contain songs from the same author group';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_author_and_songs_per_playlist
BEFORE INSERT OR UPDATE ON playlist_music
FOR EACH ROW
EXECUTE FUNCTION check_author_and_songs_per_playlist();

CREATE OR REPLACE FUNCTION check_max_musics_per_playlist() 
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM playlist_music WHERE playlist_id = NEW.playlist_id) >= 20 THEN
        RAISE EXCEPTION 'Playlist cannot have more than 20 musics.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER max_musics_per_playlist
AFTER INSERT OR UPDATE ON playlist_music
FOR EACH ROW
EXECUTE FUNCTION check_max_musics_per_playlist();

CREATE TABLE concert (
  id SERIAL PRIMARY KEY,
  organizer_event_id INT NOT NULL,
  artists_group_id INT NOT NULL,
  place_id INT NOT NULL,
  price INT NOT NULL,
  supporting_cause VARCHAR(250) NOT NULL,
  outdoor_space BOOLEAN NOT NULL,
  child_allowed BOOLEAN NOT NULL,
  concert_date DATE NOT NULL DEFAULT CURRENT_DATE,
  FOREIGN KEY (organizer_event_id) REFERENCES "event" (user_id) ON DELETE CASCADE, 
  FOREIGN KEY (artists_group_id) REFERENCES "group" (user_id) ON DELETE CASCADE,
  FOREIGN KEY (place_id) REFERENCES place (user_id) ON DELETE CASCADE
);

CREATE TABLE pastConcert (
  concert_id INT PRIMARY KEY,
  nb_participants INT NOT NULL,
  FOREIGN KEY (concert_id) REFERENCES concert (id) ON DELETE CASCADE
);

CREATE TABLE pastConcertMedia (
  pastconcert_id INT NOT NULL,
  photo VARCHAR(256) NOT NULL,
  FOREIGN KEY (pastconcert_id) REFERENCES pastConcert (concert_id) ON DELETE CASCADE
);

CREATE TABLE futureConcert (
  concert_id INT PRIMARY KEY,
  need_volunteers BOOLEAN NOT NULL,
  nb_interested_people INT NOT NULL,
  nb_available_spots INT NOT NULL,
  FOREIGN KEY (concert_id) REFERENCES concert (id) ON DELETE CASCADE
);

CREATE TABLE post (
  id SERIAL PRIMARY KEY,
  text VARCHAR(250) NOT NULL,
  user_id INT NOT NULL,
  concert_id INT NOT NULL,
  post_date DATE NOT NULL DEFAULT CURRENT_DATE,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE,
  FOREIGN KEY (concert_id) REFERENCES concert (id) ON DELETE CASCADE
);

CREATE TABLE tags (
  name VARCHAR(50) PRIMARY KEY,
  is_parent BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE parent_child_tags (
  parent VARCHAR(50) NOT NULL,
  child VARCHAR(50) NOT NULL,
  FOREIGN KEY (parent) REFERENCES tags (name) ON DELETE CASCADE,
  FOREIGN KEY (child) REFERENCES tags (name) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_if_parent()
RETURNS TRIGGER AS $$
BEGIN
  IF(
    SELECT 1 FROM tags
    WHERE tags.name = NEW.parent
    AND NOT tags.is_parent
  ) THEN RAISE EXCEPTION 'Tag passed as parent is not a main category.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_if_parent
BEFORE INSERT OR UPDATE ON parent_child_tags
FOR EACH ROW
EXECUTE FUNCTION check_if_parent();

CREATE TABLE concert_hall_tags (
  place_id INT NOT NULL,
  tag_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (place_id, tag_name),
  FOREIGN KEY (place_id) REFERENCES concertHall (place_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_name) REFERENCES tags (name) ON DELETE CASCADE
);

CREATE TABLE event_tags (
  event_id INT NOT NULL,
  tag_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (event_id, tag_name),
  FOREIGN KEY (event_id) REFERENCES "event" (user_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_name) REFERENCES tags (name) ON DELETE CASCADE
);

CREATE TABLE playlist_tags (
  playlist_id INT NOT NULL,
  tag_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (playlist_id, tag_name),
  FOREIGN KEY (playlist_id) REFERENCES playlist (id) ON DELETE CASCADE,
  FOREIGN KEY (tag_name) REFERENCES tags (name) ON DELETE CASCADE
);

CREATE TABLE review (
  id SERIAL PRIMARY KEY,
  note INT NOT NULL,
  user_id INT NOT NULL,
  event_user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE,
  FOREIGN KEY (event_user_id) REFERENCES "event" (user_id) ON DELETE CASCADE
);

CREATE TABLE comment (
  id SERIAL PRIMARY KEY,
  content VARCHAR(250),
  review_id INT,
  FOREIGN KEY (review_id) REFERENCES review (id) ON DELETE CASCADE
);

CREATE TABLE commentTag (
  comment_id INT NOT NULL,
  tag_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (comment_id, tag_name),
  FOREIGN KEY (comment_id) REFERENCES comment (id) ON DELETE CASCADE,
  FOREIGN KEY (tag_name) REFERENCES tags (name) ON DELETE CASCADE
);

CREATE TABLE action (
  id SERIAL PRIMARY KEY,
  type VARCHAR(20) CHECK (type IN ('Participé', 'Interessé')),
  user_id INT,
  event_id INT,
  FOREIGN KEY (user_id) REFERENCES "user" (id) ON DELETE CASCADE,
  FOREIGN KEY (event_id) REFERENCES "event" (user_id) ON DELETE CASCADE
);
