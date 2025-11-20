WITH u AS (
  SELECT user_id FROM public.users WHERE username='alice_music'
),
t AS (
  SELECT CASE
           WHEN EXISTS (
             SELECT 1 FROM public.playlists p
             JOIN u ON u.user_id=p.owner_id
             WHERE p.title='Road Trip'
           )
           THEN 'Road Trip '||to_char(clock_timestamp(),'YYYYMMDDHH24MISS')
           ELSE 'Road Trip'
         END AS title, (SELECT user_id FROM u) AS owner_id
)
INSERT INTO public.playlists (playlist_id, owner_id, title, is_public, created_at)
SELECT gen_random_uuid()::text, t.owner_id, t.title, FALSE, to_char(clock_timestamp(),'YYYY-MM-DD HH24:MI:SS')
FROM t
RETURNING playlist_id, owner_id, title, is_public;

-- созданеие плейлиста Road Trip у alice_music
-- в общем если есть уже такое название то просто создает с суффиксом даты/времени (чтобы не было дублей)