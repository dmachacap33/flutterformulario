# FS033 Flutter App

App Flutter para **Inspección de Herramientas (FS.033)** con:
- Formulario interactivo (cabecera + 20 filas con Q1..Q9 y Observaciones)
- Guardado local (SharedPreferences)
- Generación de **PDF** con **fondo corporativo idéntico** (Letter apaisado) usando `pdf` + `printing`
- Botones: Guardar local, Cargar local, Limpiar, Generar/Compartir PDF

## Ejecutar
```bash
flutter pub get
flutter run -d chrome  # o emulador/telefono
```

## Web build (para GitHub Pages o Intranet)
```bash
flutter build web --release
# Publica la carpeta build/web como sitio estático
```

## Notas
- El fondo se carga desde `assets/images/template_bg.png` (derivado del PDF FS033 R4 en rev.pdf).
- Puedes sustituir la imagen por una de mayor resolución si la empresa lo exige.
