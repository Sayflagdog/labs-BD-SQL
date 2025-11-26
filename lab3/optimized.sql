-- S1
CREATE INDEX IF NOT EXISTS idx_tracks_genre_id
    ON tracks (genre_id);

-- S2
CREATE INDEX IF NOT EXISTS idx_episodes_publication_date 
    ON episodes (publication_date DESC);

-- S3 + W1
CREATE INDEX IF NOT EXISTS idx_lh_user_listened_at
    ON listening_history (user_id, listened_at);

-- W2
CREATE INDEX IF NOT EXISTS idx_lh_track_listened_at
    ON listening_history (track_id, listened_at);

-- D1, S4 и прочие выборки по владельцу
CREATE INDEX IF NOT EXISTS idx_playlists_owner_id
    ON playlists (owner_id);

-- S4, D2, D4, D5
CREATE INDEX IF NOT EXISTS idx_track_playlist_playlist_id
    ON track_playlist (playlist_id);

-- S5
CREATE INDEX IF NOT EXISTS idx_artist_track_artist_id
    ON artist_track (artist_id);
