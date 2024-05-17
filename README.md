# Unity Space


## Ручная сборка проекта

### Android:
Ввести комманды: 

Для сборки:
- flutter build apk --release

### macOS:

Ввести комманды: 

Для сборки:
- flutter build macos

Для того чтобы собрать dmg файл, стоит перейти в папку dmg_creator:

- cd installers/dmg_creator

затем для сборки dmg файла:
- appdmg ./config.json ./unity_space.dmg

### Windows:

Для сборки:
- flutter build windows

Для запуска скрипта нужно установить программу Inno Setup:
- (Ссылка для скачивания) https://jrsoftware.org/isdl.php
- (Видео туториал для работы с Inno Setup) https://www.youtube.com/watch?v=XvwX-hmYv0E&ab_channel=RetroPortalStudio

затем для сборки сборки exe файла запустите desktop_inno_script.iss по пути : 
- installers/exe_creator/desktop_inno_script.iss