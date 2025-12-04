-- сессия 1, часть 1.1 (Фантомное чтение)
BEGIN;

SELECT COUNT(*) AS cnt_public
FROM public.playlists
WHERE is_public = TRUE;
-- cnt_public = 11, после сессии 2 резудьтат стал 12









