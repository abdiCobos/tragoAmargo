// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Trago Amargo';

  @override
  String get appTagline => 'Many coffee shops, little quality and flavor';

  @override
  String get login => 'Sign In';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Sign Out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get displayName => 'Name';

  @override
  String get signInWithGoogle => 'Sign In with Google';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get alreadyAccount => 'Already have an account?';

  @override
  String get enter => 'Sign In';

  @override
  String get guestMessage => 'Sign in to start reviewing';

  @override
  String get guestSubtitle =>
      'Save your favorite coffee shops and share your opinion';

  @override
  String get guestFavoritesMessage => 'Sign in to see your favorites';

  @override
  String get guestFavoritesSubtitle =>
      'Save your favorite coffee shops and access them from any device';

  @override
  String get home => 'Coffee Shops';

  @override
  String get map => 'Map';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get searchHint => 'Search coffee shop...';

  @override
  String get addShop => 'Add Coffee Shop';

  @override
  String get filters => 'Filters';

  @override
  String get clear => 'Clear';

  @override
  String get roastLevel => 'Roast Level';

  @override
  String get priceRange => 'Price Range';

  @override
  String get wifi => 'WiFi';

  @override
  String get wifiAvailable => 'WiFi available';

  @override
  String get proximity => 'Proximity (City)';

  @override
  String get proximityHint => 'E.g.: Guadalajara, Zapopan...';

  @override
  String get noShops => 'No coffee shops';

  @override
  String get noShopsSubtitle => 'Be the first to add a coffee shop';

  @override
  String get loading => 'Loading coffee shops...';

  @override
  String get review => 'Review';

  @override
  String get reviews => 'Reviews';

  @override
  String get favorite => 'Favorite';

  @override
  String get saved => 'Saved';

  @override
  String get report => 'Report';

  @override
  String get reportReason => 'Reason';

  @override
  String get reportDetails => 'Additional details...';

  @override
  String get sendReport => 'Submit report';

  @override
  String get reportSent => 'Report submitted';

  @override
  String get cancel => 'Cancel';

  @override
  String get reply => 'Reply';

  @override
  String get replyHint => 'Write your reply...';

  @override
  String get replyPublished => 'Reply published';

  @override
  String get editShop => 'Edit Coffee Shop';

  @override
  String get completeInfo => 'Complete information';

  @override
  String get editReview => 'Edit Review';

  @override
  String get writeReview => 'Write Review';

  @override
  String get publishReview => 'Publish Review';

  @override
  String get updateReview => 'Update Review';

  @override
  String get reviewPublished => 'Review published!';

  @override
  String get reviewUpdated => 'Review updated!';

  @override
  String get quality => 'Bean Quality';

  @override
  String get qualityDesc => 'Evaluate the quality and freshness of the coffee';

  @override
  String get flavor => 'Flavor';

  @override
  String get flavorDesc => 'How tasty the coffee is';

  @override
  String get roast => 'Roast Management';

  @override
  String get roastDesc => 'How well they handle roast levels';

  @override
  String get service => 'Service';

  @override
  String get serviceDesc => 'Staff service and atmosphere';

  @override
  String get comment => 'Comment';

  @override
  String get commentHint => 'Share your experience...';

  @override
  String get menu => 'Menu';

  @override
  String get menuItems => 'items';

  @override
  String get flagshipDrinks => 'Flagship Drinks';

  @override
  String get addMenuItem => 'Add Menu Item';

  @override
  String get addFlagship => 'Add Flagship Drink';

  @override
  String get claimShop => 'Claim this coffee shop';

  @override
  String get claimPending => 'Claim pending approval';

  @override
  String get owner => 'Owner';

  @override
  String get ownerBadge => 'Verified Owner';

  @override
  String get save => 'Save Changes';

  @override
  String get shopUpdated => 'Coffee shop updated';

  @override
  String get myCafes => 'My Coffee Shops';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get memberSince => 'Member since';

  @override
  String get viewAllReviews => 'View all my reviews';

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get welcomeTitle => 'Welcome to Trago Amargo!';

  @override
  String get welcomeBody =>
      'Many coffee shops, little quality and flavor. Help us find the best ones.';

  @override
  String newReviewTitle(Object shopName) {
    return 'New review at $shopName';
  }

  @override
  String newReviewBody(Object userName) {
    return '$userName rated your coffee shop';
  }

  @override
  String get replyTitle => 'Someone replied to your review';

  @override
  String replyBody(Object shopName, Object userName) {
    return '$userName replied to your review at $shopName';
  }

  @override
  String get photos => 'Photos';

  @override
  String get addPhoto => 'Add photos';

  @override
  String get photoUpdated => 'Photo updated';

  @override
  String get photoAdded => 'Photo added';

  @override
  String get contact => 'Contact';

  @override
  String get ratings => 'Ratings';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get moreDetails => 'More Details';

  @override
  String get moreDetailsOpt => 'More Details (optional)';

  @override
  String get hours => 'Hours';

  @override
  String get hoursOpt => 'Hours (optional)';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Coffee Shop Name *';

  @override
  String get originAltitude => 'Coffee Origin and Altitude';

  @override
  String get originAltitudeRequired => 'Coffee Origin and Altitude *';

  @override
  String get originHint => 'E.g.: Ethiopia Yirgacheffe, 1,900 masl';

  @override
  String get address => 'Address';

  @override
  String get addressRequired => 'Address *';

  @override
  String get addressHint => 'E.g.: 123 Main St, San Francisco';

  @override
  String get description => 'Description';

  @override
  String get brewingMethods => 'Brewing Methods';

  @override
  String get seatingMode => 'Space Type';

  @override
  String get phone => 'Phone';

  @override
  String get instagram => 'Instagram';

  @override
  String get instagramHint => 'Instagram (without @)';

  @override
  String get requiredFields => 'Required';

  @override
  String get optionalNote =>
      'You only need name, coffee origin and address. The rest is optional.';

  @override
  String get required => 'Required';

  @override
  String get selectRoast => 'Select at least one roast level';

  @override
  String get roastLevelsRequired => 'Roast Levels *';

  @override
  String get duplicateAddress =>
      'A coffee shop already exists at this address.';

  @override
  String get shopAdded => 'Coffee shop added';

  @override
  String get roastClaro => 'Light';

  @override
  String get roastMedio => 'Medium';

  @override
  String get roastOscuro => 'Dark';

  @override
  String get offensive => 'Offensive content';

  @override
  String get falseInfo => 'False information';

  @override
  String get spam => 'Spam';

  @override
  String get other => 'Other';

  @override
  String get expert => 'Expert';

  @override
  String get aficionado => 'Aficionado';

  @override
  String get novato => 'Novice';

  @override
  String get flagExpert => 'Flagship item';

  @override
  String get mustTry => 'Must try';

  @override
  String get delete => 'Delete';

  @override
  String get deleteMenuItem => 'Delete this menu item?';

  @override
  String get deleteConfirm => 'Delete';

  @override
  String get myCafesStat => 'Coffee Shops';

  @override
  String get reservations => 'Reviews';

  @override
  String get noUserReviews => 'No reviews yet';

  @override
  String get noPublishedShops => 'No coffee shops published yet';

  @override
  String get pleaseSelectReason => 'Select a reason';

  @override
  String get ownerMenu => 'Manage Menu';

  @override
  String get claimApproved => 'Your ownership claim has been approved';

  @override
  String get createAccount => 'Create Account';

  @override
  String get noRating => 'No rating';

  @override
  String get seatingEmpty => 'Select...';

  @override
  String get seatingTable => 'Tables and chairs';

  @override
  String get seatingToGo => 'Takeout only';

  @override
  String get seatingPublic => 'Public space';

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
  String get brewingSifon => 'Siphon';

  @override
  String get user => 'User';

  @override
  String get someone => 'Someone';

  @override
  String get itemDeleted => 'Item deleted';

  @override
  String get reviewLoading => 'Loading reviews...';

  @override
  String get viewProfile => 'View profile';

  @override
  String get reviewOf => 'review by';

  @override
  String reviewsOfUser(Object userName) {
    return 'Reviews by $userName';
  }

  @override
  String shopsOfUser(Object userName) {
    return 'Coffee Shops by $userName';
  }

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get photosOpt => 'Photos (optional)';

  @override
  String get uploading => 'Uploading...';

  @override
  String get uploadError => 'Error uploading photo';

  @override
  String get shopName => 'Name';

  @override
  String get roastingLevels => 'Roast Levels';

  @override
  String get addReview => 'Write review';

  @override
  String get noShopFound => 'Coffee shop not found';

  @override
  String get errorLoading => 'Error loading';

  @override
  String dateFormat(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get noFavorites => 'No favorites yet';

  @override
  String get noFavoritesSubtitle =>
      'Save coffee shops by tapping the heart on their profile';

  @override
  String get passwordMismatch => 'Passwords don\'t match';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get selectRoastLevels => 'Select at least one roast level';

  @override
  String get wifiSwitch => 'WiFi available';

  @override
  String get spaceType => 'Space Type';

  @override
  String get addCoffeeShop => 'Add Coffee Shop';

  @override
  String get editCoffeeShop => 'Edit Coffee Shop';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get shopSaved => 'Coffee shop updated';

  @override
  String get gpsVerification => 'GPS Verification';

  @override
  String get gpsStep1 => 'Step 1 of 2: GPS Verification';

  @override
  String get gpsDesc => 'You must be within 20 meters of the location.';

  @override
  String get verifyLocation => 'Verify my location';

  @override
  String get gpsNotEnabled => 'Enable GPS on your device.';

  @override
  String get gpsPermissionDenied => 'Location permission denied.';

  @override
  String get gpsPermissionPermanent =>
      'Enable location permissions in settings.';

  @override
  String tooFar(Object distance) {
    return 'You are ${distance}m away. Maximum 20m allowed.';
  }

  @override
  String get alreadyClaimPending =>
      'You already have a pending claim for review.';

  @override
  String get shopHasOwner => 'This coffee shop already has a verified owner.';

  @override
  String get locationError => 'Error getting location. Try again.';

  @override
  String get docsStep2 => 'Step 2 of 2: Documents and Selfie';

  @override
  String get docsSubtitle =>
      'Upload documents proving ownership and a selfie at the location.';

  @override
  String get propertyDocs => 'Ownership documents';

  @override
  String get docsDesc => 'Utility bills, rent receipts (min. 1, max. 2)';

  @override
  String get selfie => 'Selfie at the location';

  @override
  String get selfieDesc => 'In uniform if possible (min. 1, max. 2)';

  @override
  String get docsPolicy =>
      'The document address must match the coffee shop. We\'ll review your case in 24-48h.';

  @override
  String get submitClaim => 'Submit claim';

  @override
  String get claimSubmitted =>
      'Request submitted. We will review your documents soon.';

  @override
  String get claimOwner => 'Claim as Owner';

  @override
  String get ownerVerified => 'Verified Owner';

  @override
  String get hasOwnerMessage =>
      'This coffee shop already has a verified owner.';

  @override
  String get goBack => 'Go back';

  @override
  String get notificationsLogin => 'Sign in to see notifications';

  @override
  String get noNotificationsYet => 'No notifications';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes min ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String get signInToReview => 'Sign in to write a review';

  @override
  String get publish => 'Publish';

  @override
  String get alreadyReviewed => 'You already have a review. You can edit it.';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get language => 'Language';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordDesc =>
      'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Link';

  @override
  String get resetLinkSent => 'A reset link has been sent to your email.';
}
