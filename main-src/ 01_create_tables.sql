CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    country_code CHAR(2)
);

-- Таблица артистов
CREATE TABLE IF NOT EXISTS artists (
    artist_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    bio TEXT
);

-- Таблица жанров
CREATE TABLE IF NOT EXISTS genres (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Таблица альбомов
CREATE TABLE IF NOT EXISTS albums (
    album_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    release_year INTEGER CHECK (release_year >= 1900 AND release_year <= EXTRACT(YEAR FROM CURRENT_DATE))
);

-- Таблица подкастов
CREATE TABLE IF NOT EXISTS podcasts (
    podcast_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    author_id UUID NOT NULL REFERENCES artists(artist_id) ON DELETE CASCADE
);

-- Таблица эпизодов подкастов
CREATE TABLE IF NOT EXISTS episodes (
    episode_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    podcast_id UUID NOT NULL REFERENCES podcasts(podcast_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    duration_seconds INTEGER NOT NULL CHECK (duration_seconds > 0),
    publication_date TIMESTAMP
);

-- Таблица треков
CREATE TABLE IF NOT EXISTS tracks (
    track_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    duration_seconds INTEGER NOT NULL CHECK (duration_seconds > 0),
    album_id UUID REFERENCES albums(album_id) ON DELETE SET NULL,
    genre_id INTEGER REFERENCES genres(genre_id) ON DELETE SET NULL
);

-- Таблица плейлистов
CREATE TABLE IF NOT EXISTS playlists (
    playlist_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Таблица истории прослушиваний
CREATE TABLE IF NOT EXISTS listening_history (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    track_id UUID REFERENCES tracks(track_id) ON DELETE CASCADE,
    episode_id UUID REFERENCES episodes(episode_id) ON DELETE CASCADE,
    listened_at TIMESTAMP NOT NULL DEFAULT NOW(),
    progress_seconds INTEGER NOT NULL CHECK (progress_seconds >= 0),
    -- Ограничение: должен быть заполнен либо track_id, либо episode_id
    CONSTRAINT chk_track_or_episode CHECK (
        (track_id IS NULL AND episode_id IS NOT NULL) OR
        (track_id IS NOT NULL AND episode_id IS NULL)
    )
);

-- Таблица связей артистов и треков (многие-ко-многим)
CREATE TABLE IF NOT EXISTS artist_track (
    artist_id UUID NOT NULL REFERENCES artists(artist_id) ON DELETE CASCADE,
    track_id UUID NOT NULL REFERENCES tracks(track_id) ON DELETE CASCADE,
    PRIMARY KEY (artist_id, track_id)
);

-- Таблица связей треков и плейлистов (многие-ко-многим)
CREATE TABLE IF NOT EXISTS track_playlist (
    track_id UUID NOT NULL REFERENCES tracks(track_id) ON DELETE CASCADE,
    playlist_id UUID NOT NULL REFERENCES playlists(playlist_id) ON DELETE CASCADE,
    position INTEGER NOT NULL CHECK (position > 0),
    PRIMARY KEY (track_id, playlist_id)
);

-- Создание индексов для улучшения производительности
CREATE INDEX IF NOT EXISTS idx_listening_history_user_id ON listening_history(user_id);
CREATE INDEX IF NOT EXISTS idx_listening_history_listened_at ON listening_history(listened_at);
CREATE INDEX IF NOT EXISTS idx_tracks_album_id ON tracks(album_id);
CREATE INDEX IF NOT EXISTS idx_tracks_genre_id ON tracks(genre_id);
CREATE INDEX IF NOT EXISTS idx_playlists_owner_id ON playlists(owner_id);