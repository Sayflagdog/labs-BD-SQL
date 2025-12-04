-- часть 1.1, неповторяющееся чтение

-- сессия 2! 
BEGIN;

UPDATE public.playlists
SET is_public = TRUE
WHERE title = 'My Picks';

COMMIT;









