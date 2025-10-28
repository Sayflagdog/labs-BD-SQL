-- автогенерация UUID в дальнейшем


-- TRACKS
CREATE TABLE IF NOT EXISTS public.tracks (
  track_id UUID PRIMARY KEY,
  title TEXT NOT NULL,
  duration_seconds INTEGER NOT NULL CHECK (duration_seconds > 0),
  album_id UUID NOT NULL REFERENCES public.albums(album_id) ON DELETE CASCADE,
  genre_id INTEGER NOT NULL REFERENCES public.genres(genre_id) ON DELETE RESTRICT
);

-- PODCASTS
CREATE TABLE IF NOT EXISTS public.podcasts (
  podcast_id UUID PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  author_id UUID NOT NULL REFERENCES public.artists(artist_id) ON DELETE CASCADE
);

-- EPISODES
CREATE TABLE IF NOT EXISTS public.episodes (
  episode_id UUID PRIMARY KEY,
  podcast_id UUID NOT NULL REFERENCES public.podcasts(podcast_id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  duration_seconds INTEGER NOT NULL CHECK (duration_seconds > 0),
  publication_date TIMESTAMP NOT NULL
);

-- PLAYLISTS
CREATE TABLE IF NOT EXISTS public.playlists (
  playlist_id UUID PRIMARY KEY,
  owner_id UUID NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  is_public BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- M:N artists <-> tracks
CREATE TABLE IF NOT EXISTS public.artist_track (
  artist_id UUID NOT NULL REFERENCES public.artists(artist_id) ON DELETE CASCADE,
  track_id  UUID NOT NULL REFERENCES public.tracks(track_id)  ON DELETE CASCADE,
  PRIMARY KEY (artist_id, track_id)
);

-- M:N tracks <-> playlists
CREATE TABLE IF NOT EXISTS public.track_playlist (
  track_id    UUID NOT NULL REFERENCES public.tracks(track_id)    ON DELETE CASCADE,
  playlist_id UUID NOT NULL REFERENCES public.playlists(playlist_id) ON DELETE CASCADE,
  position    INTEGER NOT NULL CHECK (position > 0),
  PRIMARY KEY (playlist_id, track_id),
  UNIQUE (playlist_id, position)
);

-- LISTENING HISTORY: ровно один из track_id / episode_id
CREATE TABLE IF NOT EXISTS public.listening_history (
  event_id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.users(user_id) ON DELETE CASCADE,
  track_id UUID REFERENCES public.tracks(track_id) ON DELETE CASCADE,
  episode_id UUID REFERENCES public.episodes(episode_id) ON DELETE CASCADE,
  listened_at TIMESTAMP NOT NULL,
  progress_seconds INTEGER NOT NULL CHECK (progress_seconds >= 0),
  CHECK ( (track_id IS NULL) <> (episode_id IS NULL) )
);
