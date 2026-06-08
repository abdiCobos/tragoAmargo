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

  /// No description provided for @hours.
  ///
  /// In es, this message translates to:
  /// **'Horarios'**
  String get hours;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @originAltitude.
  ///
  /// In es, this message translates to:
  /// **'Origen y Altura del Café'**
  String get originAltitude;

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
