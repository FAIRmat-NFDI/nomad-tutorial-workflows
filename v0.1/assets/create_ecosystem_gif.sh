ffmpeg \
-loop 1 -t 10 -i NOMAD_ecosystem_OG.jpg \
-loop 1 -t 10 -i NOMAD_ecosystem.jpg \
-f lavfi -i color=c=white:s=1920x1080:r=24 \
-filter_complex \
"[0:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1,fade=t=out:st=9.5:d=1[v0]; \
 [1:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1,fade=t=in:st=0:d=1,fade=t=out:st=9.5:d=1[v1]; \
 [v0][v1]concat=n=2:v=1:a=0,format=yuv420p[v]" -map "[v]" NOMAD_ecosystem.gif
