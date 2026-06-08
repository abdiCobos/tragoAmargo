# Trago Amargo — Continuar traducción i18n

## Rama actual
`translate` (commit `dc05570`)

## Lo que ya está hecho

### Configuración
- `flutter_localizations` + `intl` en `pubspec.yaml`
- `l10n.yaml` configurado
- ARB files: `lib/l10n/app_es.arb` y `lib/l10n/app_en.arb` con ~150 strings
- `lib/l10n/app_localizations.dart` generado automáticamente
- `lib/app.dart` actualizado con `supportedLocales`, `localizationDelegates`, `locale`

### Pantallas ya traducidas

| Pantalla | Archivo |
|---|---|
| Splash + config | `lib/app.dart` |
| Home (navbar, título, botón Entrar) | `lib/features/home/home_screen.dart` |
| Lista de cafeterías (búsqueda, filtros, estados vacíos) | `lib/features/shops/shop_list_screen.dart` |
| Login | `lib/features/auth/login_screen.dart` |
| Register | `lib/features/auth/register_screen.dart` |
| Shop Detail (~60 strings) | `lib/features/shops/shop_detail_screen.dart` |

### Pantallas PENDIENTES de traducir

| Prioridad | Pantalla | Archivo |
|---|---|---|
| Alta | Perfil de usuario | `lib/features/profile/profile_screen.dart` |
| Alta | Agregar cafetería | `lib/features/shops/add_shop_screen.dart` |
| Alta | Editar cafetería | `lib/features/shops/edit_shop_screen.dart` |
| Media | Formulario de reseña | `lib/features/reviews/review_form_screen.dart` |
| Media | Notificaciones | `lib/features/notifications/notifications_screen.dart` |
| Media | Claim shop | `lib/features/shops/claim_shop_screen.dart` |
| Baja | Favoritos | `lib/features/favorites/favorites_screen.dart` |
| Baja | Mapa | `lib/features/map/map_screen.dart` |

## Cómo seguir traduciendo

### 1. Clonar o pull
```bash
git checkout translate
git pull origin translate
flutter pub get
flutter gen-l10n
```

### 2. Método para traducir cada pantalla

**Opción A — PowerShell (recomendado para muchas strings):**
```powershell
$f = 'lib\features\profile\profile_screen.dart'
$c = [System.IO.File]::ReadAllText($f)
$c = $c.Replace("'Texto en español'", 'l10n.nombreDeLaKey')
$c = $c.Replace("'Otro texto'", 'l10n.otraKey')
[System.IO.File]::WriteAllText($f, $c)
```

**Opción B — Agregar el import manualmente y usar `edit_file`:**
1. Agregar al inicio: `import '../../l10n/app_localizations.dart';`
2. En el método `build`, obtener: `final l10n = AppLocalizations.of(context);`
3. Reemplazar strings una por una con `edit_file`

### 3. Si falta una string en los ARB

Agregarla al final de `app_es.arb` y `app_en.arb` antes del `}`:
```json
"nuevaKey": "Texto en español"
```
```json
"nuevaKey": "English text"
```
Luego regenerar:
```bash
flutter gen-l10n
```

### 4. Verificar que compila
```bash
dart analyze lib/
```

### 5. Commit y push
```bash
git add .
git commit -m "i18n: traducida pantalla X"
git push origin translate
```

## Strings importantes ya disponibles en los ARB

Todas las strings de UI comunes ya existen: `login`, `register`, `logout`, `email`, `password`, `cancel`, `save`, `delete`, `report`, `reply`, `review`, `reviews`, `favorite`, `favorites`, `saved`, `profile`, `home`, `map`, `addShop`, `searchHint`, `filters`, `clear`, `roastLevel`, `priceRange`, `wifi`, `proximity`, `loading`, `noShops`, `menu`, `flagshipDrinks`, `contact`, `ratings`, `description`, `hours`, `phone`, `instagram`, `address`, `name`, `originAltitude`, `brewingMethods`, `seatingMode`, `owner`, `ownerMenu`, `claimShop`, `completeInfo`, `editShop`, `addPhoto`, `photoUpdated`, `notifications`, `noNotifications`, `logout`, `myCafes`, `myFavorites`, `memberSince`, `viewProfile`, `viewAllReviews`, `noReviews`, `noRating`, `sendReport`, `reportSent`, `reportReason`, `reportDetails`, `reviewPublished`, `reviewUpdated`, `replyPublished`, `replyHint`, `replyTitle`, `someone`, `user`, `offensive`, `falseInfo`, `spam`, `other`, `shopUpdated`, `photoAdded`, `itemDeleted`, `reviewLoading`, `reviewOf`.

## Para probar en web
```bash
flutter run -d edge
```

## Para probar en Android
```bash
flutter run -d <device-id>
```
