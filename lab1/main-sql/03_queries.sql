-- 0) Подсчёт строк по всем таблицам
SELECT 'users' AS t, COUNT(*) FROM public.users
UNION ALL SELECT 'artists', COUNT(*) FROM public.artists
UNION ALL SELECT 'genres', COUNT(*) FROM public.genres
UNION ALL SELECT 'albums', COUNT(*) FROM public.albums
UNION ALL SELECT 'tracks', COUNT(*) FROM public.tracks
UNION ALL SELECT 'podcasts', COUNT(*) FROM public.podcasts
UNION ALL SELECT 'episodes', COUNT(*) FROM public.episodes
UNION ALL SELECT 'playlists', COUNT(*) FROM public.playlists
UNION ALL SELECT 'artist_track', COUNT(*) FROM public.artist_track
UNION ALL SELECT 'track_playlist', COUNT(*) FROM public.track_playlist
UNION ALL SELECT 'listening_history', COUNT(*) FROM public.listening_history
ORDER BY t;

-- 1) Контроль целостности (осиротевшие ссылки)
SELECT 'tracks without album' AS check, COUNT(*) AS n
FROM public.tracks t
LEFT JOIN public.albums a ON a.album_id=t.album_id
WHERE a.album_id IS NULL
UNION ALL
SELECT 'tracks without genre', COUNT(*)
FROM public.tracks t
LEFT JOIN public.genres g ON g.genre_id=t.genre_id
WHERE g.genre_id IS NULL
UNION ALL
SELECT 'episodes without podcast', COUNT(*)
FROM public.episodes e
LEFT JOIN public.podcasts p ON p.podcast_id=e.podcast_id
WHERE p.podcast_id IS NULL;

-- 2) Топ жанров по количеству треков
SELECT g.name, COUNT(*) AS tracks_count
FROM public.tracks t
JOIN public.genres g ON g.genre_id=t.genre_id
GROUP BY g.name
ORDER BY tracks_count DESC, g.name;

-- 3) Самые часто добавляемые треки в плейлисты
SELECT t.title, COUNT(*) AS times_in_playlists
FROM public.track_playlist tp
JOIN public.tracks t ON t.track_id=tp.track_id
GROUP BY t.track_id, t.title
ORDER BY times_in_playlists DESC, t.title
LIMIT 10;

-- 4) Активность слушателей: треки vs эпизоды
SELECT u.username,
       SUM((lh.track_id   IS NOT NULL)::int) AS track_events,
       SUM((lh.episode_id IS NOT NULL)::int) AS episode_events
FROM public.users u
LEFT JOIN public.listening_history lh ON lh.user_id=u.user_id
GROUP BY u.user_id, u.username
ORDER BY track_events DESC, episode_events DESC
LIMIT 10;

-- 5) Связки артистов и треков (топ-артисты по числу треков)
SELECT a.name AS artist, COUNT(*) AS tracks_cnt
FROM public.artist_track at
JOIN public.artists a ON a.artist_id=at.artist_id
GROUP BY a.artist_id, a.name
ORDER BY tracks_cnt DESC, artist
LIMIT 10;

-- 6) Самые «популярные» плейлисты (по числу треков)
SELECT p.title, u.username AS owner, COUNT(tp.track_id) AS tracks_cnt
FROM public.playlists p
JOIN public.users u ON u.user_id=p.owner_id
LEFT JOIN public.track_playlist tp ON tp.playlist_id=p.playlist_id
GROUP BY p.playlist_id, p.title, u.username
ORDER BY tracks_cnt DESC, p.title
LIMIT 10;

-- 7) Эпизоды по дате публикации (последние 10)
SELECT e.title, e.publication_date, p.title AS podcast
FROM public.episodes e
JOIN public.podcasts p ON p.podcast_id=e.podcast_id
ORDER BY e.publication_date DESC
LIMIT 10;

