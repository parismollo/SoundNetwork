-- Drop tables if they exist
DROP TABLE IF EXISTS user_playlist CASCADE;
DROP TABLE IF EXISTS playlist_music CASCADE;
DROP TABLE IF EXISTS page_playlist CASCADE;
DROP TABLE IF EXISTS playlist CASCADE;
DROP TABLE IF EXISTS music CASCADE;
DROP TABLE IF EXISTS user_page CASCADE;

DROP TABLE IF EXISTS associations CASCADE;
DROP TABLE IF EXISTS places CASCADE;
DROP TABLE IF EXISTS persons CASCADE;
DROP TABLE IF EXISTS groups CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Question: Est-ce qu'on met a chaque fois user_id, playlist_id, page_id....
-- Ou alors on met juste un attribut id dans chaque table ?

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE events (
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE groups (
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE persons (
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE places (
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE associations (
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);






-- User Page
-- 0 - 10 playlists --> table page_playlist
CREATE TABLE user_page (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Music
-- 0-n notes --> Table de Notes (Morceau_ID, USER_ID, Note (int))
-- 0-n playlists
CREATE TABLE music (
  id SERIAL PRIMARY KEY,
  author_id INT NOT NULL, -- user_id
  name VARCHAR(100) NOT NULL, -- nom de la musique
  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- CREATE TABLE music_note (

-- );

-- Playlist
-- 0 - n user_page --> table page_playlist
CREATE TABLE playlist (
  id SERIAL PRIMARY KEY,
  author_id INT NOT NULL, -- user_id
  name VARCHAR(100) NOT NULL, -- nom de la playlist
  user_page INT, -- Pas de NOT NULL ici car elle est pas forcement sur une page
  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (user_page) REFERENCES user_page(id)
);

-- Lien user_page/playlist
-- 0 - 10 playlists par user_page
-- 0 - n  user_pages par playlist
CREATE TABLE page_playlist (
  user_page_id INT,
  playlist_id INT,
  PRIMARY KEY (user_page_id, playlist_id),
  FOREIGN KEY (user_page_id) REFERENCES user_page(id),
  FOREIGN KEY (playlist_id) REFERENCES playlist(id)

  -- Contrainte: 10 playlists max pour 1 page
);

---------------------------------------------------------------------
----------- Contrainte: 10 playlists max pour 1 page ----------------
---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION max_playlists_per_page_check() RETURNS trigger AS $$
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
--------------------------------------------------------------------

-- Lien playlist/music
-- 0 - 20 musiques par playlist
-- 0 - n  playlists par musique
CREATE TABLE playlist_music (
  playlist_id INT,
  music_id INT,
  PRIMARY KEY (playlist_id, music_id),
  FOREIGN KEY (playlist_id) REFERENCES playlist(id),
  FOREIGN KEY (music_id) REFERENCES music(id)

  -- Contrainte: 20 musiques max pour 1 playlist
  -- CONSTRAINT max_musics_per_playlist CHECK (
  --   (SELECT COUNT(*) FROM playlist_music WHERE playlist_id = NEW.playlist_id) < 20
  -- )

  ------------------ TODO -------------------------------
  -- Contrainte: Si l'AUTEUR de la playlist est un GROUPE alors
  -- il ne peut y avoir que des musiques de ce GROUPE
  -- CONSTRAINT if_group_only_group_musics CHECK (
  --   -- Debut d'une requete...
  --   SELECT p.author_id
  --   FROM playlist p
  --   JOIN playlist_music pm ON (pm.playlist_id = p.id)
  --   WHERE p.author_id IN (SELECT user_id FROM groups)
  -- )
  -------------------------------------------------------

);

-- Contrainte: 20 musiques max pour 1 playlist
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
EXECUTE PROCEDURE check_max_musics_per_playlist();


------------------------------------------------------------------
----------------------------- A VERIFIER -------------------------
------------------------------------------------------------------
-- Lien user/playlist
-- Un user peut créer 0 - n playlists
CREATE TABLE user_playlist (
  user_id INT,
  playlist_id INT,
  PRIMARY KEY (user_id, playlist_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (playlist_id) REFERENCES playlist(id)
);
------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------