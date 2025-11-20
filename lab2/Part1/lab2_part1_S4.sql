--Часть1

--S4
SELECT p.playlist_id,
       p.title,
       u.username AS owner,
       (SELECT COUNT(*)
          FROM public.track_playlist tp
         WHERE tp.playlist_id = p.playlist_id) AS tracks_in_playlist,
       p.is_public, p.created_at
FROM public.playlists p
JOIN public.users u ON u.user_id = p.owner_id
ORDER BY tracks_in_playlist DESC, p.created_at DESC;


-- список всех плейлистов
-- т.е кто владелец, сколько в плейлисте треков, публичный ли он, когда создан, а сортировка была по размеру плейлиста






