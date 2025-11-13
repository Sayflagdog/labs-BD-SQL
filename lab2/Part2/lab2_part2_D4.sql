UPDATE public.playlists
SET is_public = TRUE
WHERE title LIKE 'My Picks%';

-- все плейлисты с префиксом My Picks будут публичными