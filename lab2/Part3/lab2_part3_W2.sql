CREATE public.mv_top_tracks_30d AS
SELECT
    t.track_id,
    t.title,
    COUNT(lh.event_id) AS play_count,
    COUNT(DISTINCT lh.user_id) AS unique_users,
    MAX(lh.listened_at) AS last_play_at
FROM public.tracks t
JOIN public.listening_history lh ON lh.track_id = t.track_id
WHERE lh.listened_at >= now() - INTERVAL '30 days'
GROUP BY t.track_id, t.title
ORDER BY play_count DESC;


-- Показывает трек, число прослушиваний, число уникальных слушателей и последнее прослушивание

