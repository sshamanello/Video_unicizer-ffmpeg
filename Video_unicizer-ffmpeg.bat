@echo off
for %%G in (*.mp4) do (
    set "input_file=%%G"
    set "output_name=%%~nG_1.mp4"    
    rem Генерация случайного процента от 1% до 3%
    set /a "random_percentage=(1 + %random% %% 3)"

    echo Обработка файла: !input_file!
    rem затухание
    ffmpeg -i "%%G" -y -vf fade=in:st=0:d=5 "%%~nG_1.mp4"
    rem вотермарка
    ffmpeg -i "%%G" -y -i logo.png -filter_complex "[1]format=rgba,colorchannelmixer=aa=0.3[logo];[0][logo]overlay=main_w-overlay_w-5:5:format=auto,format=yuv420p" "%%~nG_1.mp4"
    rem блюр
    ffmpeg -i "%%G" -y -vf "boxblur=0.5:0.5" "%%~nG_1.mp4"
    rem Ускорение рандомное
    ffmpeg -i "%%G" -y -filter:v "setpts=0.99*PTS" "%%~nG_1.mp4"
    rem Температура видео
    ffmpeg -i "%%G" -y -vf "colorbalance=rs=2" "%%~nG_1.mp4"
    rem шум
    ffmpeg -i "%%G" -y -vf noise=alls=1:allf=t "%%~nG_1.mp4" 
    rem ФПС 25 
    ffmpeg -i "%%G" -y -filter:v "setpts=1.25*PTS"
    rem Удаление исходного файла
    del "%%G"
)

pause
