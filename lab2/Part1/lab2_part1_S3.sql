--Часть1

--S3
SELECT u.username,
       COUNT(lh.event_id)       AS plays,
       COALESCE(SUM(lh.progress_seconds), 0) AS seconds_total
FROM public.users u
LEFT JOIN public.listening_history lh
       ON lh.user_id = u.user_id
      AND (lh.listened_at)::timestamp >= now() - INTERVAL '7 days'
GROUP BY u.user_id, u.username
ORDER BY plays DESC, seconds_total DESC
LIMIT 10;


-- топ 10 пользователей по прослушиваниям за последние 7 дней (сколько раз включал что то и сколько секунд суммарно)