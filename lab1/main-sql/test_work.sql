-- Топ жанров по числу треков
SELECT g.name, COUNT(*) AS tracks_count
FROM public.tracks t
JOIN public.genres g ON g.genre_id=t.genre_id
GROUP BY g.name
ORDER BY tracks_count DESC, g.name;

-- Самые популярные треки по числу добавлений в плейлистах
SELECT t.title, COUNT(*) AS times_in_playlists
FROM public.track_playlist tp
JOIN public.tracks t ON t.track_id=tp.track_id
GROUP BY t.track_id, t.title
ORDER BY times_in_playlists DESC, t.title
LIMIT 10;

-- Пользовательские паттерны: сколько событий треков vs эпизодов
SELECT u.username,
       SUM((lh.track_id   IS NOT NULL)::int) AS track_events,
       SUM((lh.episode_id IS NOT NULL)::int) AS episode_events
FROM public.users u
LEFT JOIN public.listening_history lh ON lh.user_id=u.user_id
GROUP BY u.user_id, u.username
ORDER BY track_events DESC, episode_events DESC
LIMIT 10;











