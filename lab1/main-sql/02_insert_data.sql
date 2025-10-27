-- Импорт данных из CSV файлов

-- 1. Импорт жанров
COPY genres(genre_id, name) 
FROM '/tmp/data/genres.csv' 
WITH (FORMAT CSV, HEADER);

-- 2. Импорт артистов
COPY artists(artist_id, name, bio) 
FROM '/tmp/data/artists.csv' 
WITH (FORMAT CSV, HEADER);

-- 3. Импорт пользователей
COPY users(user_id, email, username, registration_date, country_code) 
FROM '/tmp/data/users.csv' 
WITH (FORMAT CSV, HEADER);

-- 4. Импорт альбомов
COPY albums(album_id, title, release_year) 
FROM '/tmp/data/albums.csv' 
WITH (FORMAT CSV, HEADER);

-- 5. Импорт треков
COPY tracks(track_id, title, duration_seconds, album_id, genre_id) 
FROM '/tmp/data/tracks.csv' 
WITH (FORMAT CSV, HEADER);

-- 6. Импорт подкастов
COPY podcasts(podcast_id, title, description, author_id) 
FROM '/tmp/data/podcasts.csv' 
WITH (FORMAT CSV, HEADER);

-- 7. Импорт эпизодов
COPY episodes(episode_id, podcast_id, title, description, duration_seconds, publication_date) 
FROM '/tmp/data/episodes.csv' 
WITH (FORMAT CSV, HEADER);

-- 8. Импорт плейлистов
COPY playlists(playlist_id, owner_id, title, is_public, created_at) 
FROM '/tmp/data/playlists.csv' 
WITH (FORMAT CSV, HEADER);

-- 9. Импорт связей артистов и треков
COPY artist_track(artist_id, track_id) 
FROM '/tmp/data/artist_track.csv' 
WITH (FORMAT CSV, HEADER);

-- 10. Импорт связей треков и плейлистов
COPY track_playlist(track_id, playlist_id, position) 
FROM '/tmp/data/track_playlist.csv' 
WITH (FORMAT CSV, HEADER);

-- 11. Импорт истории прослушиваний
COPY listening_history(event_id, user_id, track_id, episode_id, listened_at, progress_seconds) 
FROM '/tmp/data/listening_history.csv' 
WITH (FORMAT CSV, HEADER);

-- Проверка импорта
SELECT 'genres' as table_name, COUNT(*) as count FROM genres
UNION ALL SELECT 'artists', COUNT(*) FROM artists
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'albums', COUNT(*) FROM albums
UNION ALL SELECT 'tracks', COUNT(*) FROM tracks
UNION ALL SELECT 'podcasts', COUNT(*) FROM podcasts
UNION ALL SELECT 'episodes', COUNT(*) FROM episodes
UNION ALL SELECT 'playlists', COUNT(*) FROM playlists
UNION ALL SELECT 'artist_track', COUNT(*) FROM artist_track
UNION ALL SELECT 'track_playlist', COUNT(*) FROM track_playlist
UNION ALL SELECT 'listening_history', COUNT(*) FROM listening_history
ORDER BY table_name;