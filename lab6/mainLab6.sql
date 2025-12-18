DROP TABLE IF EXISTS public.albums CASCADE;

CREATE TABLE public.albums (
  album_id     uuid NOT NULL,
  title        text NOT NULL,
  release_year integer NOT NULL,
  PRIMARY KEY (album_id, release_year)
) PARTITION BY RANGE (release_year);



CREATE TABLE public.albums_p_before_1970
PARTITION OF public.albums
FOR VALUES FROM (MINVALUE) TO (1970);

CREATE TABLE public.albums_p_1970_1999
PARTITION OF public.albums
FOR VALUES FROM (1970) TO (2000);

CREATE TABLE public.albums_p_2000_plus
PARTITION OF public.albums
FOR VALUES FROM (2000) TO (MAXVALUE);


INSERT INTO public.albums (album_id, title, release_year)
SELECT album_id, title, release_year
FROM public.albums_stage;



