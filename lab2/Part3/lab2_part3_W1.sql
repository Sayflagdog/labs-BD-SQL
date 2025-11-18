CREATE OR REPLACE VIEW public.vw_user_activity AS
SELECT
    u.user_id,
    u.username,
    COUNT(lh.event_id) AS play_count,
    COALESCE(SUM(lh.progress_seconds),0) AS total_seconds,
    MAX(lh.listened_at) AS last_activity
FROM public.users u
LEFT JOIN public.listening_history lh ON lh.user_id = u.user_id
GROUP BY u.user_id, u.username;

-- Показывает username, сколько раз пользователь слушал контент, общую длительность прослушивания и последний момент активности

-- если пользователь ещё ничего не слушал в тблице listening_history то ему ставится 0


