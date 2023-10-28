#!/bin/bash

# check for arguments
if [ $# -eq 0 ]; then
    echo "Download YouTube Music Playlist: $0 <youtube-video-link>"
    exit 1
fi
youtube_link="$1"

# get playlist title and create directory
playlist_title=$(yt-dlp -f 140 --skip-download --print playlist_title --no-warnings -I 1:1 ${youtube_link})
mkdir "$playlist_title"
cd "$playlist_title" || exit

# download playlist
yt-dlp -f 140 "${youtube_link}"
