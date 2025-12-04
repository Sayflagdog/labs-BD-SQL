-- сессия 2, часть 1.1 (/Lost Update)

BEGIN;

SELECT likes_count
FROM public.playlists
WHERE title = 'My Picks'
LIMIT 1;

UPDATE public.playlists
SET likes_count = 10 + 1
WHERE title = 'My Picks';

COMMIT;









