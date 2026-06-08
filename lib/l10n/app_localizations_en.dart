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
  String get contact => 'Contact';

  @override
  String get ratings => 'Ratings';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get moreDetails => 'More Details';

  @override
  String get hours => 'Hours';

  @override
  String get name => 'Name';

  @override
  String get originAltitude => 'Coffee Origin and Altitude';

  @override
  String get originHint => 'E.g.: Ethiopia Yirgacheffe, 1,900 masl';

  @override
  String get address => 'Address';

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
}
