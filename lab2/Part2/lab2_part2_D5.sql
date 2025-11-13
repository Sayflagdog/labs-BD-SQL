DELETE FROM public.playlists p
WHERE p.title LIKE 'Playlist %'
  AND NOT EXISTS (SELECT 1 FROM public.track_playlist tp
                  WHERE tp.playlist_id = p.playlist_id);

-- удаление всех пустых автогенеренные плейлисты Playlist %