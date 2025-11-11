-- Часть1

--S1
SELECT g.name AS genre, COUNT(t.track_id) AS tracks
FROM public.genres g
LEFT JOIN public.tracks t ON t.genre_id = g.genre_id
GROUP BY g.name
ORDER BY tracks DESC, genre;

