# Caja de Herramientas (Flutter)

App con 8 vistas: inicio (caja de herramientas), género, persona aleatoria,
universidades, clima RD, pokémon, noticias WordPress y acerca de.

## Puesta en marcha

1. Dentro de esta carpeta, genera las carpetas de plataforma:
   `flutter create .`
2. `flutter pub get`
3. Agrega tus imágenes en `assets/images/`:
   - `caja_herramientas.png` (foto de la caja de herramientas)
   - `tu_foto.png` (vista "Acerca de")
   - `icono.png` (tu foto, para el ícono de la app)
4. Genera el ícono: `dart run flutter_launcher_icons`
5. Android: en `android/app/src/main/AndroidManifest.xml` agrega, antes de `<application>`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
   y dentro de `<manifest>` (para abrir links):
   ```xml
   <queries>
     <intent>
       <action android:name="android.intent.action.VIEW"/>
       <data android:scheme="https"/>
     </intent>
   </queries>
   ```
6. `flutter run`

## Pendientes tuyos
- Cambiar teléfono y GitHub en `lib/screens/acerca_screen.dart`.
- Publicar en el foro la API de WordPress usada:
  `https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3`
- Subir a Git:
  ```
  git init
  git add .
  git commit -m "App caja de herramientas"
  git branch -M main
  git remote add origin <URL-de-tu-repo>
  git push -u origin main
  ```
