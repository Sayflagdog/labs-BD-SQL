UPDATE public.genres
SET name = 'Hip-Hop'
WHERE name IN ('Hip Hop','hiphop','HipHop')
RETURNING genre_id, name;

-- приводит распространённые синонимы к каноническому написанию хип хопа
-- список обновлённых жанров, если пусто то синонимов в таблице нет