-- сессия 2 фантомное чтение
BEGIN;

INSERT INTO public.playlists (playlist_id, owner_id, title, is_public, created_at)
VALUES (
    gen_random_uuid(),
    (SELECT user_id FROM public.users ORDER BY registration_date LIMIT 1),
    'Phantom public playlist',
    TRUE,
    now()
);

COMMIT;



