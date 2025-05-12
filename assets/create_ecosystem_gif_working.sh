ffmpeg \
-loop 1 -t 5 -i NOMAD_ecosystem_OG.jpg \
-loop 1 -t 5 -i NOMAD_ecosystem_OG.jpg \
-loop 1 -t 5 -i NOMAD_ecosystem_OG.jpg \
-loop 1 -t 5 -i NOMAD_ecosystem_OG.jpg \
-loop 1 -t 5 -i NOMAD_ecosystem_OG.jpg \
-filter_complex \
"[0:v]fade=t=out:st=4:d=1[v0]; \
 [1:v]fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v1]; \
 [2:v]fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v2]; \
 [3:v]fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v3]; \
 [4:v]fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v4]; \
 [v0][v1][v2][v3][v4]concat=n=5:v=1:a=0,format=yuv420p[v]" -map "[v]" NOMAD_ecosystem.gif
