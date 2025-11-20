--Часть1

--S5
WITH per_artist AS (
  SELECT at.artist_id, COUNT(DISTINCT at.track_id) AS tracks_cnt
  FROM public.artist_track at
  GROUP BY at.artist_id
),
avg_cnt AS (
  SELECT AVG(tracks_cnt) AS avg_tracks FROM per_artist
)
SELECT a.name, p.tracks_cnt
FROM per_artist p
JOIN public.artists a ON a.artist_id = p.artist_id
WHERE p.tracks_cnt > (SELECT avg_tracks FROM avg_cnt)
ORDER BY p.tracks_cnt DESC, a.name;


-- артисты у которых количество треков больше среднего по всем артистам






