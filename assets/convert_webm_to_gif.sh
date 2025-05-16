# ffmpeg -i md-setup-workflow.webm -pix_fmt rgb24 md-setup-workflow.gif

# fnm="md-setup-workflow"
# fnm="eln-entry-from-gui"
# fnm="MetaInfo-browser"
# fnm="md-upload-prod"
fnm="metainfo-browser-basic-eln"
input="$fnm.webm"
output="$fnm.gif"

ffmpeg -i "$input" -vf "fps=15,scale=640:-1:flags=lanczos,palettegen" palette.png
ffmpeg -i "$input" -i palette.png -filter_complex "fps=15,scale=640:-1:flags=lanczos [x];[x][1:v] paletteuse" "$output"

