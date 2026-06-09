// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Trago Amargo';

  @override
  String get appTagline => 'Muchas cafeterías, poca calidad y sabor';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get email => 'Email';

  @override
  String get password => 'Contraseña';

  @override
  String get displayName => 'Nombre';

  @override
  String get signInWithGoogle => 'Iniciar Sesión con Google';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get alreadyAccount => '¿Ya tienes cuenta?';

  @override
  String get enter => 'Entrar';

  @override
  String get guestMessage => 'Inicia sesión para comenzar a reseñar';

  @override
  String get guestSubtitle =>
      'Guarda tus cafeterías favoritas y comparte tu opinión';

  @override
  String get guestFavoritesMessage => 'Inicia sesión para ver tus favoritos';

  @override
  String get guestFavoritesSubtitle =>
      'Guarda tus cafeterías favoritas y accede a ellas desde cualquier dispositivo';

  @override
  String get home => 'Cafeterías';

  @override
  String get map => 'Mapa';

  @override
  String get favorites => 'Favoritos';

  @override
  String get profile => 'Perfil';

  @override
  String get searchHint => 'Buscar cafetería...';

  @override
  String get addShop => 'Agregar Cafetería';

  @override
  String get filters => 'Filtros';

  @override
  String get clear => 'Limpiar';

  @override
  String get roastLevel => 'Nivel de Tostado';

  @override
  String get priceRange => 'Rango de Precio';

  @override
  String get wifi => 'WiFi';

  @override
  String get wifiAvailable => 'WiFi disponible';

  @override
  String get proximity => 'Proximidad (Ciudad)';

  @override
  String get proximityHint => 'Ej: Guadalajara, Zapopan...';

  @override
  String get noShops => 'No hay cafeterías';

  @override
  String get noShopsSubtitle => 'Sé el primero en agregar una cafetería';

  @override
  String get loading => 'Cargando cafeterías...';

  @override
  String get review => 'Reseña';

  @override
  String get reviews => 'Reseñas';

  @override
  String get favorite => 'Favorito';

  @override
  String get saved => 'Guardado';

  @override
  String get report => 'Reportar';

  @override
  String get reportReason => 'Motivo';

  @override
  String get reportDetails => 'Detalles adicionales...';

  @override
  String get sendReport => 'Enviar reporte';

  @override
  String get reportSent => 'Reporte enviado';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reply => 'Responder';

  @override
  String get replyHint => 'Escribe tu respuesta...';

  @override
  String get replyPublished => 'Respuesta publicada';

  @override
  String get editShop => 'Editar cafetería';

  @override
  String get completeInfo => 'Completar información';

  @override
  String get editReview => 'Editar Reseña';

  @override
  String get writeReview => 'Escribir Reseña';

  @override
  String get publishReview => 'Publicar Reseña';

  @override
  String get updateReview => 'Actualizar Reseña';

  @override
  String get reviewPublished => '¡Reseña publicada!';

  @override
  String get reviewUpdated => '¡Reseña actualizada!';

  @override
  String get quality => 'Calidad del grano';

  @override
  String get qualityDesc => 'Evalúa la calidad y frescura del café';

  @override
  String get flavor => 'Sabrozura';

  @override
  String get flavorDesc => 'Qué tan sabroso está el café';

  @override
  String get roast => 'Manejo del tostado';

  @override
  String get roastDesc => 'Qué tan bien manejan los niveles de tostado';

  @override
  String get service => 'Servicio';

  @override
  String get serviceDesc => 'Atención del personal y ambiente del lugar';

  @override
  String get comment => 'Comentario';

  @override
  String get commentHint => 'Comparte tu experiencia...';

  @override
  String get menu => 'Menú';

  @override
  String get menuItems => 'items';

  @override
  String get flagshipDrinks => 'Bebidas insignia';

  @override
  String get addMenuItem => 'Agregar al menú';

  @override
  String get addFlagship => 'Agregar bebida insignia';

  @override
  String get claimShop => 'Reclamar esta cafetería';

  @override
  String get claimPending => 'Reclamación pendiente de aprobación';

  @override
  String get owner => 'Dueño';

  @override
  String get ownerBadge => 'Dueño verificado';

  @override
  String get save => 'Guardar Cambios';

  @override
  String get shopUpdated => 'Cafetería actualizada';

  @override
  String get myCafes => 'Mis Cafeterías';

  @override
  String get myFavorites => 'Mis Favoritos';

  @override
  String get memberSince => 'Miembro desde';

  @override
  String get viewAllReviews => 'Ver todas mis reseñas';

  @override
  String get noReviews => 'No ha escrito reseñas aún';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get noNotifications => 'No tienes notificaciones';

  @override
  String get welcomeTitle => '¡Bienvenido a Trago Amargo!';

  @override
  String get welcomeBody =>
      'Muchas cafeterías, poca calidad y sabor. Ayúdanos a encontrar las mejores.';

  @override
  String newReviewTitle(Object shopName) {
    return 'Nueva reseña en $shopName';
  }

  @override
  String newReviewBody(Object userName) {
    return '$userName calificó tu cafetería';
  }

  @override
  String get replyTitle => 'Respondieron tu reseña';

  @override
  String replyBody(Object shopName, Object userName) {
    return '$userName respondió tu reseña en $shopName';
  }

  @override
  String get photos => 'Fotos';

  @override
  String get addPhoto => 'Agregar fotos';

  @override
  String get photoUpdated => 'Foto actualizada';

  @override
  String get photoAdded => 'Foto agregada';

  @override
  String get contact => 'Contacto';

  @override
  String get ratings => 'Calificaciones';

  @override
  String get basicInfo => 'Información básica';

  @override
  String get moreDetails => 'Más detalles';

  @override
  String get moreDetailsOpt => 'Más detalles (opcional)';

  @override
  String get hours => 'Horarios';

  @override
  String get hoursOpt => 'Horarios (opcional)';

  @override
  String get name => 'Nombre';

  @override
  String get nameRequired => 'Nombre de la cafetería *';

  @override
  String get originAltitude => 'Origen y Altura del Café';

  @override
  String get originAltitudeRequired => 'Origen y Altura del Café *';

  @override
  String get originHint => 'Ej: Etiopía Yirgacheffe, 1,900 msnm';

  @override
  String get address => 'Dirección';

  @override
  String get addressRequired => 'Dirección *';

  @override
  String get addressHint => 'Ej: Av. Juárez 123, Guadalajara';

  @override
  String get description => 'Descripción';

  @override
  String get brewingMethods => 'Métodos de Preparación';

  @override
  String get seatingMode => 'Tipo de espacio';

  @override
  String get phone => 'Teléfono';

  @override
  String get instagram => 'Instagram';

  @override
  String get instagramHint => 'Instagram (sin @)';

  @override
  String get requiredFields => 'Requerido';

  @override
  String get optionalNote =>
      'Solo necesitas nombre, origen del café y dirección. El resto es opcional.';

  @override
  String get required => 'Requerido';

  @override
  String get selectRoast => 'Selecciona al menos un nivel de tostado';

  @override
  String get roastLevelsRequired => 'Niveles de Tostado *';

  @override
  String get duplicateAddress => 'Ya existe una cafetería con esta dirección.';

  @override
  String get shopAdded => 'Cafetería agregada';

  @override
  String get roastClaro => 'Claro';

  @override
  String get roastMedio => 'Medio';

  @override
  String get roastOscuro => 'Oscuro';

  @override
  String get offensive => 'Contenido ofensivo';

  @override
  String get falseInfo => 'Información falsa';

  @override
  String get spam => 'Spam';

  @override
  String get other => 'Otro';

  @override
  String get expert => 'Experto';

  @override
  String get aficionado => 'Aficionado';

  @override
  String get novato => 'Novato';

  @override
  String get flagExpert => 'Platillo insignia';

  @override
  String get mustTry => 'Imperdible';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteMenuItem => '¿Eliminar este item del menú?';

  @override
  String get deleteConfirm => 'Eliminar';

  @override
  String get myCafesStat => 'Cafeterías';

  @override
  String get reservations => 'Reseñas';

  @override
  String get noUserReviews => 'No ha escrito reseñas aún';

  @override
  String get noPublishedShops => 'No ha publicado cafeterías aún';

  @override
  String get pleaseSelectReason => 'Selecciona un motivo';

  @override
  String get ownerMenu => 'Administrar Menú';

  @override
  String get claimApproved => 'Tu solicitud de dueño fue aprobada';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get noRating => 'Sin calif';

  @override
  String get seatingEmpty => 'Seleccionar...';

  @override
  String get seatingTable => 'Mesas y sillas';

  @override
  String get seatingToGo => 'Solo para llevar';

  @override
  String get seatingPublic => 'Espacio público';

  @override
  String get brewingV60 => 'V60';

  @override
  String get brewingChemex => 'Chemex';

  @override
  String get brewingAeropress => 'Aeropress';

  @override
  String get brewingFrenchPress => 'French Press';

  @override
  String get brewingEspresso => 'Espresso';

  @override
  String get brewingColdBrew => 'Cold Brew';

  @override
  String get brewingSifon => 'Sifón';

  @override
  String get user => 'Usuario';

  @override
  String get someone => 'Alguien';

  @override
  String get itemDeleted => 'Ítem eliminado';

  @override
  String get reviewLoading => 'Cargando reseñas...';

  @override
  String get viewProfile => 'Ver perfil';

  @override
  String get reviewOf => 'la reseña de';

  @override
  String reviewsOfUser(Object userName) {
    return 'Reseñas de $userName';
  }

  @override
  String shopsOfUser(Object userName) {
    return 'Cafeterías de $userName';
  }

  @override
  String get gallery => 'Galería';

  @override
  String get camera => 'Cámara';

  @override
  String get photosOpt => 'Fotos (opcional)';

  @override
  String get uploading => 'Subiendo...';

  @override
  String get uploadError => 'Error al subir foto';

  @override
  String get shopName => 'Nombre';

  @override
  String get roastingLevels => 'Niveles de Tostado';

  @override
  String get addReview => 'Escribir reseña';

  @override
  String get noShopFound => 'Cafetería no encontrada';

  @override
  String get errorLoading => 'Error al cargar';

  @override
  String dateFormat(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get noFavorites => 'No tienes favoritos';

  @override
  String get noFavoritesSubtitle =>
      'Guarda cafeterías tocando el corazón en su perfil';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get confirmPasswordRequired => 'Confirma tu contraseña';

  @override
  String get selectRoastLevels => 'Selecciona al menos un nivel de tostado';

  @override
  String get wifiSwitch => 'WiFi disponible';

  @override
  String get spaceType => 'Tipo de espacio';

  @override
  String get addCoffeeShop => 'Agregar Cafetería';

  @override
  String get editCoffeeShop => 'Editar Cafetería';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get shopSaved => 'Cafetería actualizada';

  @override
  String get gpsVerification => 'Verificación GPS';

  @override
  String get gpsStep1 => 'Paso 1 de 2: Verificación GPS';

  @override
  String get gpsDesc => 'Debes estar a 20 metros o menos del local.';

  @override
  String get verifyLocation => 'Verificar mi ubicación';

  @override
  String get gpsNotEnabled => 'Activa el GPS de tu dispositivo.';

  @override
  String get gpsPermissionDenied => 'Permiso de ubicación denegado.';

  @override
  String get gpsPermissionPermanent =>
      'Activa los permisos de ubicación en ajustes.';

  @override
  String tooFar(Object distance) {
    return 'Estás a ${distance}m del local. Máximo 20m permitido.';
  }

  @override
  String get alreadyClaimPending =>
      'Ya tienes una solicitud pendiente de revisión.';

  @override
  String get shopHasOwner => 'Esta cafetería ya tiene un dueño verificado.';

  @override
  String get locationError => 'Error al obtener ubicación. Intenta de nuevo.';

  @override
  String get docsStep2 => 'Paso 2 de 2: Documentos y Selfie';

  @override
  String get docsSubtitle =>
      'Sube documentos que acrediten tu propiedad y una selfie en el local.';

  @override
  String get propertyDocs => 'Documentos de propiedad';

  @override
  String get docsDesc => 'Recibos de luz, agua, renta (mín. 1, máx. 2)';

  @override
  String get selfie => 'Selfie en el establecimiento';

  @override
  String get selfieDesc =>
      'Con uniforme del local si es posible (mín. 1, máx. 2)';

  @override
  String get docsPolicy =>
      'La dirección del documento debe coincidir con la cafetería. Revisaremos tu caso en 24-48h.';

  @override
  String get submitClaim => 'Enviar solicitud';

  @override
  String get claimSubmitted =>
      'Solicitud enviada. Revisaremos tus documentos pronto.';

  @override
  String get claimOwner => 'Acreditar como Dueño';

  @override
  String get ownerVerified => 'Dueño Verificado';

  @override
  String get hasOwnerMessage => 'Esta cafetería ya tiene un dueño verificado.';

  @override
  String get goBack => 'Volver';

  @override
  String get notificationsLogin => 'Inicia sesión para ver notificaciones';

  @override
  String get noNotificationsYet => 'No tienes notificaciones';

  @override
  String minutesAgo(Object minutes) {
    return 'Hace $minutes min';
  }

  @override
  String hoursAgo(Object hours) {
    return 'Hace ${hours}h';
  }

  @override
  String get signInToReview => 'Inicia sesión para escribir una reseña';

  @override
  String get publish => 'Publicar';

  @override
  String get alreadyReviewed => 'Ya tienes una reseña. Puedes editarla.';

  @override
  String get monday => 'lunes';

  @override
  String get tuesday => 'martes';

  @override
  String get wednesday => 'miércoles';

  @override
  String get thursday => 'jueves';

  @override
  String get friday => 'viernes';

  @override
  String get saturday => 'sábado';

  @override
  String get sunday => 'domingo';

  @override
  String get language => 'Idioma';
}
