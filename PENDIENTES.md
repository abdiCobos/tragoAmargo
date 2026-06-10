# PENDIENTES — Rama `maps`

## Estado actual

Rama: `maps` (3 commits adelante de `main`)
Último commit: `feat: interactive map markers with preview card + directions`

---

## 🚨 Bugs activos

### 1. Botones "Cómo llegar" no funcionan en web

**Síntoma:** Al tocar "Google Maps" u "OpenStreetMap" en el bottom sheet del mapa, no pasa nada. No abre pestaña nueva ni navega.

**Causa probable:** El navegador aplica popup blocker porque el `launchUrl` no se percibe como resultado directo del gesto del usuario. Posibles razones:
- `Navigator.pop(sheetContext)` se ejecuta junto con `launchUrl` en el mismo handler, y el pop cierra el sheet antes de que el navegador procese el `window.open`
- `webOnlyWindowName: '_blank'` en `launchUrl` debería funcionar, pero si hay algún delay o el contexto se pierde al cerrar el modal bottom sheet, el navegador lo bloquea
- Podría necesitarse `webOnlyWindowName: '_self'` en vez de `'_blank'` para que abra en la misma pestaña

**Archivo:** `lib/features/map/map_screen.dart`, método `_showPreviewSheet`, líneas donde se construyen los botones Google Maps y OpenStreetMap

**Soluciones a probar:**
1. Cambiar `webOnlyWindowName: '_blank'` → `'_self'` para que navegue en la misma pestaña (evita popup blocker)
2. Mover `Navigator.pop(sheetContext)` **después** de un pequeño delay (`Future.delayed`) para asegurar que el launch se complete primero
3. Usar `launchUrl` con `mode: LaunchMode.externalApplication` en vez de `platformDefault`
4. Como último recurso, reemplazar `url_launcher` por `dart:html` `window.open()` directamente (solo en web, con conditional import)

**Antecedente:** Se probó 5 veces. El `_openDirections` original con diálogo intermedio se eliminó porque tampoco funcionaba. La versión actual tiene los botones directo en el bottom sheet.

---

### 2. Botón brújula solo visible en móvil, no en desktop

**Síntoma:** El `FloatingActionButton.small` con ícono `Icons.explore` (brújula) aparece en navegador móvil pero no en PC/desktop.

**Causa probable:** El `FloatingActionButton` en Flutter web puede tener problemas de renderizado en desktop. Podría ser un bug de `flutter_map` o del Stack layout.

**Archivo:** `lib/features/map/map_screen.dart`, alrededor de línea 330, dentro del `Stack` del `build()`

**Solución propuesta:** Reemplazar `FloatingActionButton.small` por un `Material` + `InkWell` con un `Card` o `Container` circular. O usar `Positioned` con un `IconButton` dentro de un `Card`.

**Funcionalidad esperada del botón:** Al tocarlo, debe rotar el mapa para que el norte apunte hacia arriba (como Google Maps). Actualmente solo re-centra en `center` (que es la primera cafetería de la lista). Debería:
1. Obtener la rotación actual del mapa
2. Animarla a 0 (norte arriba)
3. Si no se puede rotar, al menos hacer reset del zoom y centro

---

### 3. Crashlytics no funciona en Flutter web

**Confirmado:** Firebase Crashlytics **no tiene soporte para Flutter web**. Solo reporta en Android e iOS.

**Archivo:** `lib/core/utils/crash_reporting.dart`, `lib/main.dart`

**Acción pendiente:** Para debugging en web, usar `debugPrint` con un prefijo consistente o integrar Sentry (que sí soporta web). Por ahora los errores en web se pierden.

---

## 🛠️ Mejoras pendientes

### 4. Brújula debe orientar al norte, no centrar en la primera cafetería

El botón brújula actualmente llama a `_mapController.move(center, 13.0)`, donde `center` es la primera cafetería. Debería:
- Leer la rotación actual del mapa
- Si `flutter_map` no expone rotación, entonces al menos mover al centro geográfico de todas las cafeterías o a la ubicación del usuario

### 5. Ubicación del usuario no siempre se detecta

`_getUserLocation()` puede fallar silenciosamente si el usuario niega permisos. Sería bueno mostrar un SnackBar amigable pidiendo activar ubicación para calcular distancias.

---

## 📁 Archivos clave modificados en `maps`

| Archivo | Cambio |
|---------|--------|
| `lib/features/map/map_screen.dart` | Mapa interactivo con preview sheet + botones de direcciones |
| `lib/core/utils/crash_reporting.dart` | Utilidad Crashlytics (solo mobile) |
| `lib/main.dart` | Init de Crashlytics |
| `lib/services/geocoding_service.dart` | Reporte de errores a Crashlytics |
| `lib/services/storage_service.dart` | Reporte de errores a Crashlytics |
| `lib/providers/auth_provider.dart` | Reporte de errores a Crashlytics |
| `lib/providers/coffee_shops_provider.dart` | Reporte de errores a Crashlytics |
| `lib/providers/reviews_provider.dart` | Reporte de errores a Crashlytics |
| `pubspec.yaml` | Agregados `url_launcher` y `firebase_crashlytics` |

---

## 🚀 Comandos útiles

```bash
# Volver a la rama maps
git checkout maps
flutter pub get

# Build web
flutter build web --release

# Deploy (preparar landing page)
powershell -Command "Copy-Item 'build\web\index.html' 'build\web\app.html'"
# Luego sobreescribir build/web/index.html con el landing page (web/landing/index.html)
# Corregir paths en el landing: css/style.css → landing/css/style.css, js/main.js → landing/js/main.js, ../favicon.png → favicon.png
firebase deploy --only hosting

# Análisis estático
flutter analyze
```

---

## 🌐 URLs

- **Landing:** https://tragoamargo-ee5c5.web.app/
- **App Flutter:** https://tragoamargo-ee5c5.web.app/app
- **Firebase Console:** https://console.firebase.google.com/project/tragoamargo-ee5c5/overview
- **Firebase Hosting:** https://tragoamargo-ee5c5.web.app
