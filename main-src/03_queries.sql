-- Проверочные запросы для тестирования базы данных

-- 1. Проверка количества записей в основных таблицах
SELECT 'users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 'artists', COUNT(*) FROM artists
UNION ALL
SELECT 'tracks', COUNT(*) FROM tracks
UNION ALL
SELECT 'albums', COUNT(*) FROM albums
UNION ALL
SELECT 'genres', COUNT(*) FROM genres
UNION ALL
SELECT 'playlists', COUNT(*) FROM playlists
UNION ALL
SELECT 'listening_history', COUNT(*) FROM listening_history
ORDER BY table_name;

-- 2. Пользователи и их страны
SELECT username, email, country_code 
FROM users 
ORDER BY country_code, username;

-- 3. Треки с информацией об альбомах и жанрах
SELECT 
    t.title as track_title,
    a.title as album_title,
    a.release_year,
    g.name as genre,
    t.duration_seconds
FROM tracks t
LEFT JOIN albums a ON t.album_id = a.album_id
LEFT JOIN genres g ON t.genre_id = g.genre_id
ORDER BY a.release_year DESC, t.title;

-- 4. Артисты и их треки (связь многие-ко-многим)
SELECT 
    ar.name as artist_name,
    t.title as track_title,
    al.title as album_title
FROM artists ar
JOIN artist_track at ON ar.artist_id = at.artist_id
JOIN tracks t ON at.track_id = t.track_id
LEFT JOIN albums al ON t.album_id = al.album_id
ORDER BY ar.name, t.title;

-- 5. Плейлисты пользователей с количеством треков
SELECT 
    u.username,
    p.title as playlist_title,
    p.is_public,
    COUNT(tp.track_id) as track_count
FROM playlists p
JOIN users u ON p.owner_id = u.user_id
LEFT JOIN track_playlist tp ON p.playlist_id = tp.playlist_id
GROUP BY u.username, p.title, p.is_public
ORDER BY u.username, track_count DESC;

-- 6. История прослушиваний пользователей
SELECT 
    u.username,
    CASE 
        WHEN lh.track_id IS NOT NULL THEN 'Track: ' || t.title
        WHEN lh.episode_id IS NOT NULL THEN 'Episode: ' || e.title
    END as content_title,
    lh.progress_seconds,
    lh.listened_at
FROM listening_history lh
JOIN users u ON lh.user_id = u.user_id
LEFT JOIN tracks t ON lh.track_id = t.track_id
LEFT JOIN episodes e ON lh.episode_id = e.episode_id
ORDER BY lh.listened_at DESC
LIMIT 10;

-- 7. Самые популярные треки (по количеству прослушиваний)
SELECT 
    t.title as track_title,
    COUNT(lh.event_id) as listen_count
FROM tracks t
JOIN listening_history lh ON t.track_id = lh.track_id
GROUP BY t.title
ORDER BY listen_count DESC
LIMIT 10;

-- 8. Подкасты и их эпизоды
SELECT 
    p.title as podcast_title,
    ar.name as author,
    e.title as episode_title,
    e.duration_seconds,
    e.publication_date
FROM podcasts p
JOIN artists ar ON p.author_id = ar.artist_id
JOIN episodes e ON p.podcast_id = e.podcast_id
ORDER BY p.title, e.publication_date DESC;

-- 9. Пользователи по странам
SELECT 
    country_code,
    COUNT(*) as user_count
FROM users
WHERE country_code IS NOT NULL
GROUP BY country_code
ORDER BY user_count DESC;

-- 10. Средняя длительность треков по жанрам
SELECT 
    g.name as genre,
    ROUND(AVG(t.duration_seconds) / 60, 2) as avg_duration_minutes,
    COUNT(t.track_id) as track_count
FROM genres g
LEFT JOIN tracks t ON g.genre_id = t.genre_id
GROUP BY g.name
HAVING COUNT(t.track_id) > 0
ORDER BY avg_duration_minutes DESC;

-- 11. Проверка ограничения целостности (трек ИЛИ эпизод)
SELECT 
    event_id,
    user_id,
    track_id IS NOT NULL as has_track,
    episode_id IS NOT NULL as has_episode
FROM listening_history
WHERE (track_id IS NULL AND episode_id IS NULL) 
   OR (track_id IS NOT NULL AND episode_id IS NOT NULL);

-- 12. Треки в плейлистах с позициями
SELECT 
    p.title as playlist_title,
    u.username as owner,
    t.title as track_title,
    tp.position
FROM track_playlist tp
JOIN playlists p ON tp.playlist_id = p.playlist_id
JOIN users u ON p.owner_id = u.user_id
JOIN tracks t ON tp.track_id = t.track_id
ORDER BY p.title, tp.position;

-- 13. Статистика по пользователям: треки vs подкасты
SELECT 
    u.username,
    COUNT(CASE WHEN lh.track_id IS NOT NULL THEN 1 END) as track_listens,
    COUNT(CASE WHEN lh.episode_id IS NOT NULL THEN 1 END) as episode_listens,
    COUNT(*) as total_listens
FROM users u
LEFT JOIN listening_history lh ON u.user_id = lh.user_id
GROUP BY u.username
HAVING COUNT(*) > 0
ORDER BY total_listens DESC;