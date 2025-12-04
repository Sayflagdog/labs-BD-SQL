-- часть 1.1, неповторяющееся чтение

-- сессия 1
BEGIN;

SELECT title, is_public
FROM public.playlists
WHERE title = 'My Picks'
LIMIT 1;


-- результат после сессии 2 (ответ изменился на true)






