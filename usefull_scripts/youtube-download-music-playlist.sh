#!/bin/bash

# check for arguments
if [ $# -eq 0 ]; then
    echo "Download YouTube Music Playlist: $0 <youtube-video-link>"
    exit 1
fi
youtube_link="$1"

# get playlist title and create directory
playlist_title=$(yt-dlp --skip-download --print playlist_title --no-warnings -I 1:1 ${youtube_link})

if [ -z "$playlist_title" ]; then
    echo "Could not fetch playlist title :/ Set directory name to timecode"
    playlist_title=$(date +%s)
fi

mkdir "$playlist_title"
cd "$playlist_title" || exit

# download playlist
yt-dlp --ignore-errors --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" --yes-playlist "${youtube_link}"
