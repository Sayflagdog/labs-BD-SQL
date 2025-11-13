WITH u AS (
  SELECT user_id FROM public.users WHERE username = 'alice_music' LIMIT 1
),
ins AS (
  INSERT INTO public.playlists (playlist_id, owner_id, title, is_public, created_at)
  SELECT gen_random_uuid(), u.user_id, 'My Picks', FALSE, now()
  FROM u
  WHERE NOT EXISTS (
    SELECT 1 FROM public.playlists p
    WHERE p.owner_id = u.user_id AND p.title = 'My Picks'
  )
  RETURNING playlist_id
)
--  целевой playlist_id 
SELECT COALESCE(
  (SELECT playlist_id FROM ins),
  (SELECT p.playlist_id
     FROM public.playlists p JOIN u ON p.owner_id = u.user_id
    WHERE p.title = 'My Picks'
    LIMIT 1)
) AS playlist_id;

