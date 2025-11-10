--Часть1

--S2
SELECT e.title AS episode, p.title AS podcast, e.publication_date
FROM public.episodes e
JOIN public.podcasts p ON p.podcast_id = e.podcast_id
ORDER BY e.publication_date DESC
LIMIT 10;









