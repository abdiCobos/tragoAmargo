import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Trago Amargo'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In es, this message translates to:
  /// **'Muchas cafeterías, poca calidad y sabor'**
  String get appTagline;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get login;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @displayName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get displayName;

  /// No description provided for @signInWithGoogle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión con Google'**
  String get signInWithGoogle;

  /// No description provided for @noAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta?'**
  String get noAccount;

  /// No description provided for @alreadyAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta?'**
  String get alreadyAccount;

  /// No description provided for @enter.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get enter;

  /// No description provided for @guestMessage.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para comenzar a reseñar'**
  String get guestMessage;

  /// No description provided for @guestSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Guarda tus cafeterías favoritas y comparte tu opinión'**
  String get guestSubtitle;

  /// No description provided for @guestFavoritesMessage.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para ver tus favoritos'**
  String get guestFavoritesMessage;

  /// No description provided for @guestFavoritesSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Guarda tus cafeterías favoritas y accede a ellas desde cualquier dispositivo'**
  String get guestFavoritesSubtitle;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Cafeterías'**
  String get home;

  /// No description provided for @map.
  ///
  /// In es, this message translates to:
  /// **'Mapa'**
  String get map;

  /// No description provided for @favorites.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favorites;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @searchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar cafetería...'**
  String get searchHint;

  /// No description provided for @addShop.
  ///
  /// In es, this message translates to:
  /// **'Agregar Cafetería'**
  String get addShop;

  /// No description provided for @filters.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get filters;

  /// No description provided for @clear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clear;

  /// No description provided for @roastLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel de Tostado'**
  String get roastLevel;

  /// No description provided for @priceRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de Precio'**
  String get priceRange;

  /// No description provided for @wifi.
  ///
  /// In es, this message translates to:
  /// **'WiFi'**
  String get wifi;

  /// No description provided for @wifiAvailable.
  ///
  /// In es, this message translates to:
  /// **'WiFi disponible'**
  String get wifiAvailable;

  /// No description provided for @proximity.
  ///
  /// In es, this message translates to:
  /// **'Proximidad (Ciudad)'**
  String get proximity;

  /// No description provided for @proximityHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Guadalajara, Zapopan...'**
  String get proximityHint;

  /// No description provided for @noShops.
  ///
  /// In es, this message translates to:
  /// **'No hay cafeterías'**
  String get noShops;

  /// No description provided for @noShopsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Sé el primero en agregar una cafetería'**
  String get noShopsSubtitle;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando cafeterías...'**
  String get loading;

  /// No description provided for @review.
  ///
  /// In es, this message translates to:
  /// **'Reseña'**
  String get review;

  /// No description provided for @reviews.
  ///
  /// In es, this message translates to:
  /// **'Reseñas'**
  String get reviews;

  /// No description provided for @favorite.
  ///
  /// In es, this message translates to:
  /// **'Favorito'**
  String get favorite;

  /// No description provided for @saved.
  ///
  /// In es, this message translates to:
  /// **'Guardado'**
  String get saved;

  /// No description provided for @report.
  ///
  /// In es, this message translates to:
  /// **'Reportar'**
  String get report;

  /// No description provided for @reportReason.
  ///
  /// In es, this message translates to:
  /// **'Motivo'**
  String get reportReason;

  /// No description provided for @reportDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles adicionales...'**
  String get reportDetails;

  /// No description provided for @sendReport.
  ///
  /// In es, this message translates to:
  /// **'Enviar reporte'**
  String get sendReport;

  /// No description provided for @reportSent.
  ///
  /// In es, this message translates to:
  /// **'Reporte enviado'**
  String get reportSent;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @reply.
  ///
  /// In es, this message translates to:
  /// **'Responder'**
  String get reply;

  /// No description provided for @replyHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu respuesta...'**
  String get replyHint;

  /// No description provided for @replyPublished.
  ///
  /// In es, this message translates to:
  /// **'Respuesta publicada'**
  String get replyPublished;

  /// No description provided for @editShop.
  ///
  /// In es, this message translates to:
  /// **'Editar cafetería'**
  String get editShop;

  /// No description provided for @completeInfo.
  ///
  /// In es, this message translates to:
  /// **'Completar información'**
  String get completeInfo;

  /// No description provided for @editReview.
  ///
  /// In es, this message translates to:
  /// **'Editar Reseña'**
  String get editReview;

  /// No description provided for @writeReview.
  ///
  /// In es, this message translates to:
  /// **'Escribir Reseña'**
  String get writeReview;

  /// No description provided for @publishReview.
  ///
  /// In es, this message translates to:
  /// **'Publicar Reseña'**
  String get publishReview;

  /// No description provided for @updateReview.
  ///
  /// In es, this message translates to:
  /// **'Actualizar Reseña'**
  String get updateReview;

  /// No description provided for @reviewPublished.
  ///
  /// In es, this message translates to:
  /// **'¡Reseña publicada!'**
  String get reviewPublished;

  /// No description provided for @reviewUpdated.
  ///
  /// In es, this message translates to:
  /// **'¡Reseña actualizada!'**
  String get reviewUpdated;

  /// No description provided for @quality.
  ///
  /// In es, this message translates to:
  /// **'Calidad del grano'**
  String get quality;

  /// No description provided for @qualityDesc.
  ///
  /// In es, this message translates to:
  /// **'Evalúa la calidad y frescura del café'**
  String get qualityDesc;

  /// No description provided for @flavor.
  ///
  /// In es, this message translates to:
  /// **'Sabrozura'**
  String get flavor;

  /// No description provided for @flavorDesc.
  ///
  /// In es, this message translates to:
  /// **'Qué tan sabroso está el café'**
  String get flavorDesc;

  /// No description provided for @roast.
  ///
  /// In es, this message translates to:
  /// **'Manejo del tostado'**
  String get roast;

  /// No description provided for @roastDesc.
  ///
  /// In es, this message translates to:
  /// **'Qué tan bien manejan los niveles de tostado'**
  String get roastDesc;

  /// No description provided for @service.
  ///
  /// In es, this message translates to:
  /// **'Servicio'**
  String get service;

  /// No description provided for @serviceDesc.
  ///
  /// In es, this message translates to:
  /// **'Atención del personal y ambiente del lugar'**
  String get serviceDesc;

  /// No description provided for @comment.
  ///
  /// In es, this message translates to:
  /// **'Comentario'**
  String get comment;

  /// No description provided for @commentHint.
  ///
  /// In es, this message translates to:
  /// **'Comparte tu experiencia...'**
  String get commentHint;

  /// No description provided for @menu.
  ///
  /// In es, this message translates to:
  /// **'Menú'**
  String get menu;

  /// No description provided for @menuItems.
  ///
  /// In es, this message translates to:
  /// **'items'**
  String get menuItems;

  /// No description provided for @flagshipDrinks.
  ///
  /// In es, this message translates to:
  /// **'Bebidas insignia'**
  String get flagshipDrinks;

  /// No description provided for @addMenuItem.
  ///
  /// In es, this message translates to:
  /// **'Agregar al menú'**
  String get addMenuItem;

  /// No description provided for @addFlagship.
  ///
  /// In es, this message translates to:
  /// **'Agregar bebida insignia'**
  String get addFlagship;

  /// No description provided for @claimShop.
  ///
  /// In es, this message translates to:
  /// **'Reclamar esta cafetería'**
  String get claimShop;

  /// No description provided for @claimPending.
  ///
  /// In es, this message translates to:
  /// **'Reclamación pendiente de aprobación'**
  String get claimPending;

  /// No description provided for @owner.
  ///
  /// In es, this message translates to:
  /// **'Dueño'**
  String get owner;

  /// No description provided for @ownerBadge.
  ///
  /// In es, this message translates to:
  /// **'Dueño verificado'**
  String get ownerBadge;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get save;

  /// No description provided for @shopUpdated.
  ///
  /// In es, this message translates to:
  /// **'Cafetería actualizada'**
  String get shopUpdated;

  /// No description provided for @myCafes.
  ///
  /// In es, this message translates to:
  /// **'Mis Cafeterías'**
  String get myCafes;

  /// No description provided for @myFavorites.
  ///
  /// In es, this message translates to:
  /// **'Mis Favoritos'**
  String get myFavorites;

  /// No description provided for @memberSince.
  ///
  /// In es, this message translates to:
  /// **'Miembro desde'**
  String get memberSince;

  /// No description provided for @viewAllReviews.
  ///
  /// In es, this message translates to:
  /// **'Ver todas mis reseñas'**
  String get viewAllReviews;

  /// No description provided for @noReviews.
  ///
  /// In es, this message translates to:
  /// **'No ha escrito reseñas aún'**
  String get noReviews;

  /// No description provided for @notifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In es, this message translates to:
  /// **'No tienes notificaciones'**
  String get noNotifications;

  /// No description provided for @welcomeTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a Trago Amargo!'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In es, this message translates to:
  /// **'Muchas cafeterías, poca calidad y sabor. Ayúdanos a encontrar las mejores.'**
  String get welcomeBody;

  /// No description provided for @newReviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva reseña en {shopName}'**
  String newReviewTitle(Object shopName);

  /// No description provided for @newReviewBody.
  ///
  /// In es, this message translates to:
  /// **'{userName} calificó tu cafetería'**
  String newReviewBody(Object userName);

  /// No description provided for @replyTitle.
  ///
  /// In es, this message translates to:
  /// **'Respondieron tu reseña'**
  String get replyTitle;

  /// No description provided for @replyBody.
  ///
  /// In es, this message translates to:
  /// **'{userName} respondió tu reseña en {shopName}'**
  String replyBody(Object shopName, Object userName);

  /// No description provided for @photos.
  ///
  /// In es, this message translates to:
  /// **'Fotos'**
  String get photos;

  /// No description provided for @addPhoto.
  ///
  /// In es, this message translates to:
  /// **'Agregar fotos'**
  String get addPhoto;

  /// No description provided for @photoUpdated.
  ///
  /// In es, this message translates to:
  /// **'Foto actualizada'**
  String get photoUpdated;

  /// No description provided for @photoAdded.
  ///
  /// In es, this message translates to:
  /// **'Foto agregada'**
  String get photoAdded;

  /// No description provided for @contact.
  ///
  /// In es, this message translates to:
  /// **'Contacto'**
  String get contact;

  /// No description provided for @ratings.
  ///
  /// In es, this message translates to:
  /// **'Calificaciones'**
  String get ratings;

  /// No description provided for @basicInfo.
  ///
  /// In es, this message translates to:
  /// **'Información básica'**
  String get basicInfo;

  /// No description provided for @moreDetails.
  ///
  /// In es, this message translates to:
  /// **'Más detalles'**
  String get moreDetails;

  /// No description provided for @moreDetailsOpt.
  ///
  /// In es, this message translates to:
  /// **'Más detalles (opcional)'**
  String get moreDetailsOpt;

  /// No description provided for @hours.
  ///
  /// In es, this message translates to:
  /// **'Horarios'**
  String get hours;

  /// No description provided for @hoursOpt.
  ///
  /// In es, this message translates to:
  /// **'Horarios (opcional)'**
  String get hoursOpt;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @nameRequired.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la cafetería *'**
  String get nameRequired;

  /// No description provided for @originAltitude.
  ///
  /// In es, this message translates to:
  /// **'Origen y Altura del Café'**
  String get originAltitude;

  /// No description provided for @originAltitudeRequired.
  ///
  /// In es, this message translates to:
  /// **'Origen y Altura del Café *'**
  String get originAltitudeRequired;

  /// No description provided for @originHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Etiopía Yirgacheffe, 1,900 msnm'**
  String get originHint;

  /// No description provided for @address.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// No description provided for @addressRequired.
  ///
  /// In es, this message translates to:
  /// **'Dirección *'**
  String get addressRequired;

  /// No description provided for @addressHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Av. Juárez 123, Guadalajara'**
  String get addressHint;

  /// No description provided for @description.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// No description provided for @brewingMethods.
  ///
  /// In es, this message translates to:
  /// **'Métodos de Preparación'**
  String get brewingMethods;

  /// No description provided for @seatingMode.
  ///
  /// In es, this message translates to:
  /// **'Tipo de espacio'**
  String get seatingMode;

  /// No description provided for @phone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phone;

  /// No description provided for @instagram.
  ///
  /// In es, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @instagramHint.
  ///
  /// In es, this message translates to:
  /// **'Instagram (sin @)'**
  String get instagramHint;

  /// No description provided for @requiredFields.
  ///
  /// In es, this message translates to:
  /// **'Requerido'**
  String get requiredFields;

  /// No description provided for @optionalNote.
  ///
  /// In es, this message translates to:
  /// **'Solo necesitas nombre, origen del café y dirección. El resto es opcional.'**
  String get optionalNote;

  /// No description provided for @required.
  ///
  /// In es, this message translates to:
  /// **'Requerido'**
  String get required;

  /// No description provided for @selectRoast.
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos un nivel de tostado'**
  String get selectRoast;

  /// No description provided for @roastLevelsRequired.
  ///
  /// In es, this message translates to:
  /// **'Niveles de Tostado *'**
  String get roastLevelsRequired;

  /// No description provided for @duplicateAddress.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cafetería con esta dirección.'**
  String get duplicateAddress;

  /// No description provided for @shopAdded.
  ///
  /// In es, this message translates to:
  /// **'Cafetería agregada'**
  String get shopAdded;

  /// No description provided for @roastClaro.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get roastClaro;

  /// No description provided for @roastMedio.
  ///
  /// In es, this message translates to:
  /// **'Medio'**
  String get roastMedio;

  /// No description provided for @roastOscuro.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get roastOscuro;

  /// No description provided for @offensive.
  ///
  /// In es, this message translates to:
  /// **'Contenido ofensivo'**
  String get offensive;

  /// No description provided for @falseInfo.
  ///
  /// In es, this message translates to:
  /// **'Información falsa'**
  String get falseInfo;

  /// No description provided for @spam.
  ///
  /// In es, this message translates to:
  /// **'Spam'**
  String get spam;

  /// No description provided for @other.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get other;

  /// No description provided for @expert.
  ///
  /// In es, this message translates to:
  /// **'Experto'**
  String get expert;

  /// No description provided for @aficionado.
  ///
  /// In es, this message translates to:
  /// **'Aficionado'**
  String get aficionado;

  /// No description provided for @novato.
  ///
  /// In es, this message translates to:
  /// **'Novato'**
  String get novato;

  /// No description provided for @flagExpert.
  ///
  /// In es, this message translates to:
  /// **'Platillo insignia'**
  String get flagExpert;

  /// No description provided for @mustTry.
  ///
  /// In es, this message translates to:
  /// **'Imperdible'**
  String get mustTry;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @deleteMenuItem.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar este item del menú?'**
  String get deleteMenuItem;

  /// No description provided for @deleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get deleteConfirm;

  /// No description provided for @myCafesStat.
  ///
  /// In es, this message translates to:
  /// **'Cafeterías'**
  String get myCafesStat;

  /// No description provided for @reservations.
  ///
  /// In es, this message translates to:
  /// **'Reseñas'**
  String get reservations;

  /// No description provided for @noUserReviews.
  ///
  /// In es, this message translates to:
  /// **'No ha escrito reseñas aún'**
  String get noUserReviews;

  /// No description provided for @noPublishedShops.
  ///
  /// In es, this message translates to:
  /// **'No ha publicado cafeterías aún'**
  String get noPublishedShops;

  /// No description provided for @pleaseSelectReason.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un motivo'**
  String get pleaseSelectReason;

  /// No description provided for @ownerMenu.
  ///
  /// In es, this message translates to:
  /// **'Administrar Menú'**
  String get ownerMenu;

  /// No description provided for @claimApproved.
  ///
  /// In es, this message translates to:
  /// **'Tu solicitud de dueño fue aprobada'**
  String get claimApproved;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get createAccount;

  /// No description provided for @noRating.
  ///
  /// In es, this message translates to:
  /// **'Sin calif'**
  String get noRating;

  /// No description provided for @seatingEmpty.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar...'**
  String get seatingEmpty;

  /// No description provided for @seatingTable.
  ///
  /// In es, this message translates to:
  /// **'Mesas y sillas'**
  String get seatingTable;

  /// No description provided for @seatingToGo.
  ///
  /// In es, this message translates to:
  /// **'Solo para llevar'**
  String get seatingToGo;

  /// No description provided for @seatingPublic.
  ///
  /// In es, this message translates to:
  /// **'Espacio público'**
  String get seatingPublic;

  /// No description provided for @brewingV60.
  ///
  /// In es, this message translates to:
  /// **'V60'**
  String get brewingV60;

  /// No description provided for @brewingChemex.
  ///
  /// In es, this message translates to:
  /// **'Chemex'**
  String get brewingChemex;

  /// No description provided for @brewingAeropress.
  ///
  /// In es, this message translates to:
  /// **'Aeropress'**
  String get brewingAeropress;

  /// No description provided for @brewingFrenchPress.
  ///
  /// In es, this message translates to:
  /// **'French Press'**
  String get brewingFrenchPress;

  /// No description provided for @brewingEspresso.
  ///
  /// In es, this message translates to:
  /// **'Espresso'**
  String get brewingEspresso;

  /// No description provided for @brewingColdBrew.
  ///
  /// In es, this message translates to:
  /// **'Cold Brew'**
  String get brewingColdBrew;

  /// No description provided for @brewingSifon.
  ///
  /// In es, this message translates to:
  /// **'Sifón'**
  String get brewingSifon;

  /// No description provided for @user.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get user;

  /// No description provided for @someone.
  ///
  /// In es, this message translates to:
  /// **'Alguien'**
  String get someone;

  /// No description provided for @itemDeleted.
  ///
  /// In es, this message translates to:
  /// **'Ítem eliminado'**
  String get itemDeleted;

  /// No description provided for @reviewLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando reseñas...'**
  String get reviewLoading;

  /// No description provided for @viewProfile.
  ///
  /// In es, this message translates to:
  /// **'Ver perfil'**
  String get viewProfile;

  /// No description provided for @reviewOf.
  ///
  /// In es, this message translates to:
  /// **'la reseña de'**
  String get reviewOf;

  /// No description provided for @reviewsOfUser.
  ///
  /// In es, this message translates to:
  /// **'Reseñas de {userName}'**
  String reviewsOfUser(Object userName);

  /// No description provided for @shopsOfUser.
  ///
  /// In es, this message translates to:
  /// **'Cafeterías de {userName}'**
  String shopsOfUser(Object userName);

  /// No description provided for @gallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get camera;

  /// No description provided for @photosOpt.
  ///
  /// In es, this message translates to:
  /// **'Fotos (opcional)'**
  String get photosOpt;

  /// No description provided for @uploading.
  ///
  /// In es, this message translates to:
  /// **'Subiendo...'**
  String get uploading;

  /// No description provided for @uploadError.
  ///
  /// In es, this message translates to:
  /// **'Error al subir foto'**
  String get uploadError;

  /// No description provided for @shopName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get shopName;

  /// No description provided for @roastingLevels.
  ///
  /// In es, this message translates to:
  /// **'Niveles de Tostado'**
  String get roastingLevels;

  /// No description provided for @addReview.
  ///
  /// In es, this message translates to:
  /// **'Escribir reseña'**
  String get addReview;

  /// No description provided for @noShopFound.
  ///
  /// In es, this message translates to:
  /// **'Cafetería no encontrada'**
  String get noShopFound;

  /// No description provided for @errorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar'**
  String get errorLoading;

  /// No description provided for @dateFormat.
  ///
  /// In es, this message translates to:
  /// **'{day}/{month}/{year}'**
  String dateFormat(Object day, Object month, Object year);

  /// No description provided for @noFavorites.
  ///
  /// In es, this message translates to:
  /// **'No tienes favoritos'**
  String get noFavorites;

  /// No description provided for @noFavoritesSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Guarda cafeterías tocando el corazón en su perfil'**
  String get noFavoritesSubtitle;

  /// No description provided for @passwordMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordMismatch;

  /// No description provided for @confirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get confirmPasswordRequired;

  /// No description provided for @selectRoastLevels.
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos un nivel de tostado'**
  String get selectRoastLevels;

  /// No description provided for @wifiSwitch.
  ///
  /// In es, this message translates to:
  /// **'WiFi disponible'**
  String get wifiSwitch;

  /// No description provided for @spaceType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de espacio'**
  String get spaceType;

  /// No description provided for @addCoffeeShop.
  ///
  /// In es, this message translates to:
  /// **'Agregar Cafetería'**
  String get addCoffeeShop;

  /// No description provided for @editCoffeeShop.
  ///
  /// In es, this message translates to:
  /// **'Editar Cafetería'**
  String get editCoffeeShop;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get saveChanges;

  /// No description provided for @shopSaved.
  ///
  /// In es, this message translates to:
  /// **'Cafetería actualizada'**
  String get shopSaved;

  /// No description provided for @gpsVerification.
  ///
  /// In es, this message translates to:
  /// **'Verificación GPS'**
  String get gpsVerification;

  /// No description provided for @gpsStep1.
  ///
  /// In es, this message translates to:
  /// **'Paso 1 de 2: Verificación GPS'**
  String get gpsStep1;

  /// No description provided for @gpsDesc.
  ///
  /// In es, this message translates to:
  /// **'Debes estar a 20 metros o menos del local.'**
  String get gpsDesc;

  /// No description provided for @verifyLocation.
  ///
  /// In es, this message translates to:
  /// **'Verificar mi ubicación'**
  String get verifyLocation;

  /// No description provided for @gpsNotEnabled.
  ///
  /// In es, this message translates to:
  /// **'Activa el GPS de tu dispositivo.'**
  String get gpsNotEnabled;

  /// No description provided for @gpsPermissionDenied.
  ///
  /// In es, this message translates to:
  /// **'Permiso de ubicación denegado.'**
  String get gpsPermissionDenied;

  /// No description provided for @gpsPermissionPermanent.
  ///
  /// In es, this message translates to:
  /// **'Activa los permisos de ubicación en ajustes.'**
  String get gpsPermissionPermanent;

  /// No description provided for @tooFar.
  ///
  /// In es, this message translates to:
  /// **'Estás a {distance}m del local. Máximo 20m permitido.'**
  String tooFar(Object distance);

  /// No description provided for @alreadyClaimPending.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes una solicitud pendiente de revisión.'**
  String get alreadyClaimPending;

  /// No description provided for @shopHasOwner.
  ///
  /// In es, this message translates to:
  /// **'Esta cafetería ya tiene un dueño verificado.'**
  String get shopHasOwner;

  /// No description provided for @locationError.
  ///
  /// In es, this message translates to:
  /// **'Error al obtener ubicación. Intenta de nuevo.'**
  String get locationError;

  /// No description provided for @docsStep2.
  ///
  /// In es, this message translates to:
  /// **'Paso 2 de 2: Documentos y Selfie'**
  String get docsStep2;

  /// No description provided for @docsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Sube documentos que acrediten tu propiedad y una selfie en el local.'**
  String get docsSubtitle;

  /// No description provided for @propertyDocs.
  ///
  /// In es, this message translates to:
  /// **'Documentos de propiedad'**
  String get propertyDocs;

  /// No description provided for @docsDesc.
  ///
  /// In es, this message translates to:
  /// **'Recibos de luz, agua, renta (mín. 1, máx. 2)'**
  String get docsDesc;

  /// No description provided for @selfie.
  ///
  /// In es, this message translates to:
  /// **'Selfie en el establecimiento'**
  String get selfie;

  /// No description provided for @selfieDesc.
  ///
  /// In es, this message translates to:
  /// **'Con uniforme del local si es posible (mín. 1, máx. 2)'**
  String get selfieDesc;

  /// No description provided for @docsPolicy.
  ///
  /// In es, this message translates to:
  /// **'La dirección del documento debe coincidir con la cafetería. Revisaremos tu caso en 24-48h.'**
  String get docsPolicy;

  /// No description provided for @submitClaim.
  ///
  /// In es, this message translates to:
  /// **'Enviar solicitud'**
  String get submitClaim;

  /// No description provided for @claimSubmitted.
  ///
  /// In es, this message translates to:
  /// **'Solicitud enviada. Revisaremos tus documentos pronto.'**
  String get claimSubmitted;

  /// No description provided for @claimOwner.
  ///
  /// In es, this message translates to:
  /// **'Acreditar como Dueño'**
  String get claimOwner;

  /// No description provided for @ownerVerified.
  ///
  /// In es, this message translates to:
  /// **'Dueño Verificado'**
  String get ownerVerified;

  /// No description provided for @hasOwnerMessage.
  ///
  /// In es, this message translates to:
  /// **'Esta cafetería ya tiene un dueño verificado.'**
  String get hasOwnerMessage;

  /// No description provided for @goBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get goBack;

  /// No description provided for @notificationsLogin.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para ver notificaciones'**
  String get notificationsLogin;

  /// No description provided for @noNotificationsYet.
  ///
  /// In es, this message translates to:
  /// **'No tienes notificaciones'**
  String get noNotificationsYet;

  /// No description provided for @minutesAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {minutes} min'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace {hours}h'**
  String hoursAgo(Object hours);

  /// No description provided for @signInToReview.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para escribir una reseña'**
  String get signInToReview;

  /// No description provided for @publish.
  ///
  /// In es, this message translates to:
  /// **'Publicar'**
  String get publish;

  /// No description provided for @alreadyReviewed.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes una reseña. Puedes editarla.'**
  String get alreadyReviewed;

  /// No description provided for @monday.
  ///
  /// In es, this message translates to:
  /// **'lunes'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In es, this message translates to:
  /// **'martes'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In es, this message translates to:
  /// **'miércoles'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In es, this message translates to:
  /// **'jueves'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In es, this message translates to:
  /// **'viernes'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In es, this message translates to:
  /// **'sábado'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In es, this message translates to:
  /// **'domingo'**
  String get sunday;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Restablecer contraseña'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu email y te enviaremos un enlace para restablecer tu contraseña.'**
  String get resetPasswordDesc;

  /// No description provided for @sendResetLink.
  ///
  /// In es, this message translates to:
  /// **'Enviar enlace'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In es, this message translates to:
  /// **'Se ha enviado un enlace de restablecimiento a tu email.'**
  String get resetLinkSent;

  /// No description provided for @howToGetThere.
  ///
  /// In es, this message translates to:
  /// **'Cómo llegar'**
  String get howToGetThere;

  /// No description provided for @approxTime.
  ///
  /// In es, this message translates to:
  /// **'~{time} min'**
  String approxTime(Object time);

  /// No description provided for @chooseMapApp.
  ///
  /// In es, this message translates to:
  /// **'¿Con qué app quieres abrir la ruta?'**
  String get chooseMapApp;

  /// No description provided for @googleMaps.
  ///
  /// In es, this message translates to:
  /// **'Google Maps'**
  String get googleMaps;

  /// No description provided for @waze.
  ///
  /// In es, this message translates to:
  /// **'Waze'**
  String get waze;

  /// No description provided for @openStreetMap.
  ///
  /// In es, this message translates to:
  /// **'OpenStreetMap'**
  String get openStreetMap;

  /// No description provided for @needLocation.
  ///
  /// In es, this message translates to:
  /// **'Activa tu ubicación para calcular la distancia.'**
  String get needLocation;

  /// No description provided for @openInBrowser.
  ///
  /// In es, this message translates to:
  /// **'Abrir en navegador'**
  String get openInBrowser;

  /// No description provided for @distanceAway.
  ///
  /// In es, this message translates to:
  /// **'a {distance}'**
  String distanceAway(Object distance);

  /// No description provided for @viewDetails.
  ///
  /// In es, this message translates to:
  /// **'Ver detalles'**
  String get viewDetails;

  /// No description provided for @tapForPreview.
  ///
  /// In es, this message translates to:
  /// **'Toca un marcador para ver detalles'**
  String get tapForPreview;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
