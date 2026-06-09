# Rama `diseño` — Overhaul visual de la app Flutter

## Objetivo

Igualar la estética de la app Flutter con el landing page, que usa una paleta cálida de café (marrón profundo, dorado, crema) y tipografía elegante (Playfair Display + Inter).

---

## Ramas activas

| Rama | Commits | Propósito |
|------|---------|-----------|
| `main` | 3 commits | Producción — landing page + password recovery |
| `diseño` | 9 commits | **Rama actual** — tema premium + migración completa de estilos |

Para continuar desde otra máquina:

```bash
git checkout diseño
flutter pub get
```

---

## Qué se cambió hasta ahora

### 1. Tema base (`lib/core/theme/app_theme.dart`)

**Paleta de colores** — alineada con el landing page (CSS tokens):

| Viejo | Nuevo | Uso |
|-------|-------|-----|
| `#795548` (primary) | `#4E342E` (brown800) | Color principal, botones, AppBar |
| `#6D8B3C` (secondary) | `#C8A96E` (gold) | Acentos, estrellas, iconos |
| `#BCAAA4` (tertiary) | `#BCAAA4` (brown200) | Placeholders, iconos inactivos |
| `#F5F0E8` (surface) | `#EFEBE9` (brown50) | Fondos de cards, superficies |
| `#FAFAFA` (background) | `#FFFFFF` (white) | Scaffold background → pasó a brown50 |
| `#F9A825` (star) | `#C8A96E` (gold) | Estrellas de rating |

**Tipografía** — `google_fonts` agregado como dependencia:

- **Títulos**: Playfair Display (serif, elegante, igual al landing)
- **Cuerpo**: Inter (sans-serif, legible)

**Otros cambios en el tema**:
- Cards: border-radius 20px, borde sutil brown100, sin elevación
- Botones: pill-shaped (border-radius 50px), sombra marrón
- Inputs: border-radius 16px, borde brown100, focus en brown600
- AppBar: fondo blanco, texto marrón oscuro, sin elevación
- BottomNav: sin elevación, labels con Inter
- SnackBar: flotante, border-radius 12px
- Diálogos: border-radius 20px, títulos en Playfair Display

### 2. Migración de estilos hardcodeados → `Theme.of(context)`

**Archivos migrados (26 incluyendo AuthGate)**:

`lib/app.dart`, `lib/core/theme/app_theme.dart`, `lib/features/auth/login_screen.dart`, `lib/features/auth/register_screen.dart`, `lib/features/home/home_screen.dart`, `lib/features/map/map_screen.dart`, `lib/features/notifications/notifications_screen.dart`, `lib/features/profile/profile_screen.dart`, `lib/features/reviews/review_form_screen.dart`, `lib/features/reviews/widgets/review_card.dart`, `lib/features/shops/add_product_screen.dart`, `lib/features/shops/add_shop_screen.dart`, `lib/features/shops/claim_shop_screen.dart`, `lib/features/shops/edit_shop_screen.dart`, `lib/features/shops/manage_menu_screen.dart`, `lib/features/shops/rate_menu_item_screen.dart`, `lib/features/shops/rate_product_screen.dart`, `lib/features/shops/shop_detail_screen.dart`, `lib/features/shops/shop_list_screen.dart`, `lib/features/shops/widgets/menu_item_card.dart`, `lib/features/shops/widgets/opening_hours_widget.dart`, `lib/features/shops/widgets/photo_gallery.dart`, `lib/features/shops/widgets/product_card.dart`, `lib/features/shops/widgets/shop_card.dart`, `lib/widgets/empty_state.dart`, `lib/widgets/error_display.dart`, `lib/widgets/loading_indicator.dart`

---

## ERRORES ENCONTRADOS Y CORREGIDOS

Esto es lo que impedía que se vieran los cambios visuales:

### Error 1 (CORREGIDO): `ColorScheme.fromSeed` regeneraba colores

`ColorScheme.fromSeed(seedColor: brown800, ...)` estaba regenerando toda la paleta desde el seed color y pisando nuestros colores explícitos. La solución fue reemplazarlo por un `ColorScheme(...)` explícito con todos los valores definidos manualmente.

Archivo: `lib/core/theme/app_theme.dart`

### Error 2 (CORREGIDO): AuthGate (splash screen) ignoraba el tema

El `AuthGate` en `lib/app.dart` usaba `const TextStyle(...)` y `AppColors.primary` directamente, sin `Theme.of(context)`. Migrado a usar `theme.textTheme` y `theme.colorScheme`.

### Error 3 (ACTIVO - PROBABLE CULPABLE): Google Fonts falla silenciosamente

`google_fonts` descarga las fuentes de Google Fonts en **runtime**. Si:
- No hay internet
- La descarga falla por timeout
- El navegador bloquea la petición (CORS, CSP)
- La fuente tarda en cargar y ya se renderizó el texto

...entonces el tema cae silenciosamente a la fuente por defecto (Roboto) y NO se ve ningún cambio tipográfico. Los colores del `ColorScheme` sí deberían verse, pero la tipografía no.

**Diagnóstico**: abrí las DevTools (F12) → pestaña Network → filtrá por "googleapis" o "fonts". Si ves requests a `fonts.googleapis.com`, están funcionando. Si no hay requests o están en rojo, es el problema.

---

## TAREAS PENDIENTES (ejecutar en orden)

### Tarea 1: BUNDLEAR FUENTES LOCALMENTE (CRÍTICO)

Eliminar la dependencia de `google_fonts` en runtime y embeber las fuentes como assets locales. Esto garantiza que la tipografía siempre cargue.

**Paso a paso**:

a) Descargar los archivos .ttf:
```
https://fonts.google.com/download?family=Playfair+Display  → PlayfairDisplay-VariableFont_wght.ttf o los static (Regular 400, Bold 700, Black 900)
https://fonts.google.com/download?family=Inter              → Inter-VariableFont_opsz,wght.ttf o los static (Regular 400, Medium 500, SemiBold 600, Bold 700)
```

b) Crear carpeta y copiar los .ttf:
```bash
mkdir -p assets/fonts
# Copiar los .ttf descargados a assets/fonts/
```

c) Registrar en `pubspec.yaml`:
```yaml
flutter:
  fonts:
    - family: PlayfairDisplay
      fonts:
        - asset: assets/fonts/PlayfairDisplay-Regular.ttf
          weight: 400
        - asset: assets/fonts/PlayfairDisplay-Bold.ttf
          weight: 700
        - asset: assets/fonts/PlayfairDisplay-Black.ttf
          weight: 900
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

d) Modificar `lib/core/theme/app_theme.dart`:
```dart
// ANTES (google_fonts - descarga en runtime)
import 'package:google_fonts/google_fonts.dart';

final textTheme = GoogleFonts.interTextTheme();
final displayTheme = GoogleFonts.playfairDisplayTextTheme();

// DESPUÉS (fuentes locales)
final textTheme = const TextTheme(
  bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400),
  bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400),
  bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400),
  titleLarge: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 22, fontWeight: FontWeight.w700),
  titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
  titleSmall: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
  headlineLarge: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 32, fontWeight: FontWeight.w900),
  headlineMedium: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 28, fontWeight: FontWeight.w700),
  headlineSmall: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 24, fontWeight: FontWeight.w700),
  labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
  labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500),
);
```

Reemplazar también todas las referencias a `GoogleFonts.playfairDisplay(...)` por `TextStyle(fontFamily: 'PlayfairDisplay', ...)` y `GoogleFonts.inter(...)` por `TextStyle(fontFamily: 'Inter', ...)` dentro de `app_theme.dart`.

e) Verificar que ya no se necesita el import de google_fonts en pubspec.yaml:
```bash
flutter pub remove google_fonts   # si ya no se usa en ningún otro lado
```

f) Build y verificar que la tipografía cambia:
```bash
flutter build web --release
```

### Tarea 2: VERIFICAR QUE EL THEME ES EFECTIVO

Después de hacer el fix de fuentes locales, abrí la app en incógnito y verificá:

- ✅ La AppBar tiene fondo **blanco** (no marrón)
- ✅ El título de la AppBar usa **Playfair Display** (no Roboto)
- ✅ Los botones son **pill-shaped** (border-radius 50px)
- ✅ Las cards tienen borde sutil y border-radius 20px
- ✅ El fondo de la app es **beige claro** (#EFEBE9), no blanco puro
- ✅ El texto usa **Inter** como fuente (no Roboto)
- ✅ Los iconos activos en el bottom nav son **marrón oscuro**, no marrón claro
- ✅ Las estrellas de rating son **doradas** (#C8A96E), no amarillas (#F9A825)

Si después del bundle local **seguís sin ver cambios**, el problema está en otra parte — avisame y debugueamos.

### Tarea 3: LIMPIEZA FINAL

- Eliminar `google_fonts` de `pubspec.yaml` si ya no se usa
- Correr `flutter analyze` y verificar que no haya nuevos warnings
- Si todo OK, mergear `diseño` → `main`:

```bash
git checkout main
git merge diseño
flutter build web --release
# aplicar fix del landing...
firebase deploy --only hosting
```

---

## Comandos del deploy (recordatorio)

```bash
# Build
flutter build web --release

# Fix landing (IMPORTANTE: siempre después del build)
powershell -Command "(Get-Content 'web/landing/index.html' -Raw) -replace 'href=\"\.\./favicon\.png\"', 'href=\"favicon.png\"' -replace 'href=\"css/style\.css\"', 'href=\"landing/css/style.css\"' -replace 'src=\"js/main\.js\"', 'src=\"landing/js/main.js\"' | Set-Content 'build/web/index.html' -NoNewline"

# Verificar fix
findstr /C:"landing/css/style.css" build\web\index.html

# Deploy
firebase deploy --only hosting
```

---

## Paleta completa

```
brown900:  #3E2723  — más oscuro
brown800:  #4E342E  — primario (botones, iconos activos)
brown700:  #5D4037  — texto secundario oscuro
brown600:  #6D4C41  — hover / focus
brown200:  #BCAAA4  — placeholder icons
brown100:  #D7CCC8  — bordes de cards
brown50:   #EFEBE9  — fondo de cards y scaffold
cream:     #FFF8E1  — fondo alternativo
gold:      #C8A96E  — acentos, estrellas, precio
goldLight: #E8D5B0  — gradientes, badges
white:     #FFFFFF  — cards principales, AppBar
black:     #1A1A1A  — texto principal
gray600:   #757575  — texto secundario
gray400:   #BDBDBD  — iconos inactivos
gray200:   #EEEEEE  — divisores
error:     #C62828  — errores
success:   #2E7D32  — éxito
```

---

## Historial de commits en `diseño`

```
ee5e074 fix: explicit ColorScheme instead of fromSeed, migrate AuthGate to Theme.of(context)
79dc4a8 docs: DISEÑO.md — instrucciones del overhaul visual, rama diseño
51291e3 refactor: migrate remaining 12 screens to Theme.of(context)
e0371ac refactor: migrate shop_detail_screen.dart (945 lines) to Theme.of(context)
7c41e9d refactor: migrate 11 files to Theme.of(context) - cards, widgets, auth, home, shop_list, profile
b35a866 feat: premium theme overhaul matching landing page aesthetic
aa5b4c1 feat: password recovery - AuthProvider, l10n keys, Forgot Password UI
6af2435 fix: landing page - CDMX to GDL, remove 'Sin anuncios' from CTA
7216ced feat: landing page with HTML/CSS/JS
```
