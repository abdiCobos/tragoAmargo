# Rama `diseño` — Overhaul visual de la app Flutter

## Objetivo

Igualar la estética de la app Flutter con el landing page, que usa una paleta cálida de café (marrón profundo, dorado, crema) y tipografía elegante (Playfair Display + Inter).

---

## Ramas activas

| Rama | Propósito |
|------|-----------|
| `main` | Producción — tiene el landing page original + password recovery |
| `diseño` | **Rama actual** — contiene todos los cambios de tema más la migración de estilos |

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

**Problema original**: 34 archivos usaban `TextStyle(fontSize: X, color: AppColors.Y)` directamente, ignorando completamente `ThemeData`. Cambiar el tema no hacía nada visible.

**Archivos migrados (24 en total)**:

#### Cards (4) — de `Container` a `Card` widget
- `lib/features/shops/widgets/shop_card.dart`
- `lib/features/reviews/widgets/review_card.dart`
- `lib/features/shops/widgets/menu_item_card.dart`
- `lib/features/shops/widgets/product_card.dart`

#### Widgets base (3)
- `lib/widgets/empty_state.dart`
- `lib/widgets/error_display.dart`
- `lib/widgets/loading_indicator.dart`

#### Auth (2)
- `lib/features/auth/login_screen.dart`
- `lib/features/auth/register_screen.dart`

#### Pantallas principales (5)
- `lib/features/home/home_screen.dart`
- `lib/features/profile/profile_screen.dart`
- `lib/features/shops/shop_list_screen.dart`
- `lib/features/shops/shop_detail_screen.dart`
- `lib/features/map/map_screen.dart`

#### Pantallas secundarias (7)
- `lib/features/notifications/notifications_screen.dart`
- `lib/features/reviews/review_form_screen.dart`
- `lib/features/shops/add_shop_screen.dart`
- `lib/features/shops/edit_shop_screen.dart`
- `lib/features/shops/claim_shop_screen.dart`
- `lib/features/shops/manage_menu_screen.dart`
- `lib/features/shops/add_product_screen.dart`

#### Rate screens (2)
- `lib/features/shops/rate_menu_item_screen.dart`
- `lib/features/shops/rate_product_screen.dart`

#### Widgets de shop (2)
- `lib/features/shops/widgets/photo_gallery.dart`
- `lib/features/shops/widgets/opening_hours_widget.dart`

**FavoritesScreen no se tocó** — ya usaba `ShopCard` y `EmptyState` migrados, se beneficia indirectamente.

---

## El problema del deploy (por qué no se ve nada)

Este es el problema principal que hay que resolver. Hay dos capas:

### Capa 1: Google Fonts no carga sin internet

`google_fonts` descarga las fuentes de Google Fonts en runtime. Si ya visitaste la app antes, el navegador pudo haber cacheado la versión vieja. Probá:

1. Abrí la app en una ventana de incógnito
2. O hacé Ctrl+Shift+R (hard refresh)
3. O abrí las DevTools (F12) → Application → Clear site data

### Capa 2: El tema no se aplica correctamente

El `textTheme` se construye así en `app_theme.dart`:

```dart
final textTheme = GoogleFonts.interTextTheme();
final displayTheme = GoogleFonts.playfairDisplayTextTheme();
```

Pero los widgets migrados usan `theme.textTheme.titleMedium`, `theme.textTheme.bodyMedium`, etc. Si Google Fonts falla (sin internet, o el bundle no incluye las fuentes), el tema cae a la fuente por defecto y no se nota la diferencia.

### Posible fix: bundling de fuentes

En lugar de depender de `google_fonts` en runtime, se pueden descargar los archivos `.ttf` de Playfair Display e Inter y declararlos en `pubspec.yaml` como assets. Esto garantiza que siempre carguen, con o sin internet.

---

## Próximos pasos

1. **Verificar que Google Fonts está funcionando** — si no, evaluar bundling local de las fuentes
2. **Ajustar contraste** — la paleta nueva es más oscura, algunos textos pueden necesitar ajuste
3. **Probar en iOS/Android** — `google_fonts` funciona distinto en móvil (puede precachear)
4. **Si todo funciona, mergear `diseño` → `main`**

---

## Comandos útiles

```bash
# Cambiar a la rama diseño
git checkout diseño

# Ver diferencias con main
git diff main --stat

# Build web
flutter build web --release

# Deploy a Firebase
firebase deploy --only hosting

# Después del build, reemplazar index.html con landing
powershell -Command "(Get-Content 'web/landing/index.html' -Raw) -replace 'href=\"\.\./favicon\.png\"', 'href=\"favicon.png\"' -replace 'href=\"css/style\.css\"', 'href=\"landing/css/style.css\"' -replace 'src=\"js/main\.js\"', 'src=\"landing/js/main.js\"' | Set-Content 'build/web/index.html' -NoNewline"

# Verificar que el landing se aplicó
findstr /C:"landing/css/style.css" build\web\index.html
```

---

## Estructura de la paleta

```
brown900:  #3E2723  — más oscuro (footer, gradientes)
brown800:  #4E342E  — primario (botones, AppBar texto, iconos activos)
brown700:  #5D4037  — texto secundario oscuro
brown600:  #6D4C41  — hover states, texto interactivo
brown200:  #BCAAA4  — placeholder icons, iconos inactivos
brown100:  #D7CCC8  — bordes de cards
brown50:   #EFEBE9  — fondo de cards, superficies
cream:     #FFF8E1  — fondo alternativo (about section)
gold:      #C8A96E  — acentos, estrellas, precio
goldLight: #E8D5B0  — gradientes, badges
white:     #FFFFFF  — fondo de cards principales
black:     #1A1A1A  — texto principal
gray600:   #757575  — texto secundario
gray400:   #BDBDBD  — iconos inactivos (bottom nav)
gray200:   #EEEEEE  — divisores
error:     #C62828  — errores
success:   #2E7D32  — éxito
```
