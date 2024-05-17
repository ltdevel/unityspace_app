# Unity Space
Пространства теперь на Android, IOS, Desktop
## Ручная сборка проекта:
### Android:
1. Ввести команду для сборки: 
```
flutter build apk --release  
```

### macOS:

1. Ввести команду для сборки: 

```
flutter build macos
```

2. Перейти в папку dmg_creator:

```
cd installers/dmg_creator
```

3. Ввести команду для генерации dmg файла:

```
appdmg ./config.json ./unity_space.dmg
```

### Windows:

1. Ввести команду для сборки:
```
flutter build windows
```

2. Установить программу Inno Setup:
- (Ссылка для скачивания) https://jrsoftware.org/isdl.php
- (Видео туториал для работы с Inno Setup) https://www.youtube.com/watch?v=XvwX-hmYv0E&ab_channel=RetroPortalStudio

3. Запустить desktop_inno_script.iss по пути :
```
installers/exe_creator/desktop_inno_script.iss
```
