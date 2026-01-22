import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ru'),
    Locale('uz'),
  ];

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @loginToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToYourAccount;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseLanguage;

  /// Subtitle for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for the app'**
  String get selectPreferredLanguage;

  /// Text for continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Main heading text on home screen
  ///
  /// In en, this message translates to:
  /// **'Sell and buy any of your products only with us'**
  String get sellAndBuyProducts;

  /// Subtitle text on home screen
  ///
  /// In en, this message translates to:
  /// **'Used products or second-hand market'**
  String get usedProductsMarket;

  /// Welcome title on home screen
  ///
  /// In en, this message translates to:
  /// **'Your neighborhood marketplace'**
  String get home_welcome_title;

  /// Welcome subtitle on home screen
  ///
  /// In en, this message translates to:
  /// **'Buy and sell with people nearby.\nSafe, simple, and local.'**
  String get home_welcome_subtitle;

  /// Get started button on home screen
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get home_get_started;

  /// Sign in button on home screen
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get home_sign_in;

  /// Terms notice on home screen
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy'**
  String get home_terms_notice;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Already have an account'**
  String get alreadyHaveAccount;

  /// Login screen title and button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Login screen header text
  ///
  /// In en, this message translates to:
  /// **'Login to Account'**
  String get loginToAccount;

  /// Phone number input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Register link text on login screen
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Phone number validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpectedError;

  /// Forgot password placeholder message
  ///
  /// In en, this message translates to:
  /// **'Forgot password feature coming soon'**
  String get forgotPasswordComingSoon;

  /// Selected country label
  ///
  /// In en, this message translates to:
  /// **'Selected:'**
  String get selectedCountryLabel;

  /// Full phone number label
  ///
  /// In en, this message translates to:
  /// **'Full:'**
  String get fullPhoneLabel;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Search tab label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Notifications tab label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Tezsell'**
  String get appTitle;

  /// Instruction to select region
  ///
  /// In en, this message translates to:
  /// **'Please select your region'**
  String get selectRegion;

  /// Search input hint text
  ///
  /// In en, this message translates to:
  /// **'Search district or city'**
  String get searchHint;

  /// API error message
  ///
  /// In en, this message translates to:
  /// **'A problem occurred while calling the API'**
  String get apiError;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Message shown when list is empty
  ///
  /// In en, this message translates to:
  /// **'Empty List'**
  String get emptyList;

  /// Error message when data fails to load
  ///
  /// In en, this message translates to:
  /// **'There is an error while loading data'**
  String get dataLoadingError;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @confirmRegionSelection.
  ///
  /// In en, this message translates to:
  /// **'Do you want to select {regionName} region?'**
  String confirmRegionSelection(Object regionName);

  /// Instruction to select district or city
  ///
  /// In en, this message translates to:
  /// **'Please select your district or city'**
  String get selectDistrictOrCity;

  /// Confirmation message for district selection
  ///
  /// In en, this message translates to:
  /// **'Do you want to select {regionName} region - {districtName}?'**
  String confirmDistrictSelection(String regionName, String districtName);

  /// Message when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResultsFound;

  /// Error message with error code
  ///
  /// In en, this message translates to:
  /// **'Error: {errorCode}'**
  String errorWithCode(String errorCode);

  /// Data loading failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to load data. Error: {error}'**
  String failedToLoadData(String error);

  /// Title for phone verification screen
  ///
  /// In en, this message translates to:
  /// **'Phone Number Verification'**
  String get phoneVerification;

  /// Prompt to enter phone number
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enterPhonePrompt;

  /// Hint text for phone number input
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumberHint;

  /// Shows selected country and code
  ///
  /// In en, this message translates to:
  /// **'Selected: {countryName} ({countryCode})'**
  String selectedCountry(String countryName, String countryCode);

  /// Shows complete phone number
  ///
  /// In en, this message translates to:
  /// **'Full number: {phoneNumber}'**
  String fullNumber(String phoneNumber);

  /// Button text to send verification code
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// Label for verification code input
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enterVerificationCode;

  /// Hint for verification code format
  ///
  /// In en, this message translates to:
  /// **'123456'**
  String get verificationCodeHint;

  /// Button text to resend verification code
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// Shows expiration time
  ///
  /// In en, this message translates to:
  /// **'Expires: {time}'**
  String expires(String time);

  /// Button text to verify and continue
  ///
  /// In en, this message translates to:
  /// **'Verify and Continue'**
  String get verifyAndContinue;

  /// Error message for invalid verification code
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidVerificationCode;

  /// Success message when code is sent
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get verificationCodeSent;

  /// Error message when code sending fails
  ///
  /// In en, this message translates to:
  /// **'Failed to send verification code'**
  String get failedToSendCode;

  /// Success message when code is resent
  ///
  /// In en, this message translates to:
  /// **'Verification code resent successfully'**
  String get verificationCodeResent;

  /// Error message when code resending fails
  ///
  /// In en, this message translates to:
  /// **'Failed to resend verification code'**
  String get failedToResendCode;

  /// Title for password verification screen
  ///
  /// In en, this message translates to:
  /// **'Password Verification'**
  String get passwordVerification;

  /// Instruction text for completing registration
  ///
  /// In en, this message translates to:
  /// **'Enter username and password to complete registration'**
  String get completeRegistrationPrompt;

  /// Label for username input field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @username_required.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get username_required;

  /// No description provided for @username_min_length.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 2 characters'**
  String get username_min_length;

  /// Hint text for username input
  ///
  /// In en, this message translates to:
  /// **'Username123'**
  String get usernameHint;

  /// Label for password confirmation field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Label for profile image selection
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileImage;

  /// Instructions for image selection
  ///
  /// In en, this message translates to:
  /// **'Images will appear here, please press profile image'**
  String get imageInstructions;

  /// Button text to complete registration
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Error message when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Error message when registration fails
  ///
  /// In en, this message translates to:
  /// **'Registration error'**
  String get registrationError;

  /// About us menu item
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about;

  /// Chat functionality
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Real estate section
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get realEstate;

  /// Language selector display
  ///
  /// In en, this message translates to:
  /// **'ENG'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// Russian language option
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRu;

  /// Uzbek language option
  ///
  /// In en, this message translates to:
  /// **'Uzbek'**
  String get languageUz;

  /// Service liked message
  ///
  /// In en, this message translates to:
  /// **'Service liked'**
  String get serviceLiked;

  /// Support menu item
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Business services section
  ///
  /// In en, this message translates to:
  /// **'Business Services'**
  String get service;

  /// About us content description
  ///
  /// In en, this message translates to:
  /// **'TezSell is a fast and easy marketplace for buying and selling new and used products. Our mission is to create the most convenient and efficient platform for every user, ensuring smooth transactions and a user-friendly experience. Whether you\'re looking to sell or buy, TezSell makes it easy to connect and complete transactions in just a few steps.We prioritize the security and privacy of our users. All transactions are carefully monitored to ensure safety and compliance, providing peace of mind to both buyers and sellers. Our simple and intuitive interface allows users to quickly list products and find what they need. We also facilitate real-time communication through Telegram, making the buying and selling process even smoother.'**
  String get aboutContent;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred, please check the server'**
  String get errorMessage;

  /// Location search label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get searchLocation;

  /// Category search label
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get searchCategory;

  /// Product search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search for products'**
  String get searchProductPlaceholder;

  /// Service search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search for services'**
  String get searchServicePlaceholder;

  /// No description provided for @search_products_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Find great deals in your neighborhood'**
  String get search_products_subtitle;

  /// No description provided for @search_services_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Find professionals in your neighborhood'**
  String get search_services_subtitle;

  /// No description provided for @search_products_error.
  ///
  /// In en, this message translates to:
  /// **'Error searching products'**
  String get search_products_error;

  /// No description provided for @search_services_error.
  ///
  /// In en, this message translates to:
  /// **'Error searching services'**
  String get search_services_error;

  /// No description provided for @load_more_products_error.
  ///
  /// In en, this message translates to:
  /// **'Error loading more products'**
  String get load_more_products_error;

  /// No description provided for @load_more_services_error.
  ///
  /// In en, this message translates to:
  /// **'Error loading more services'**
  String get load_more_services_error;

  /// No description provided for @try_different_keywords.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords'**
  String get try_different_keywords;

  /// Search button text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchText;

  /// Selected category prefix
  ///
  /// In en, this message translates to:
  /// **'Selected Category: '**
  String get selectedCategory;

  /// Selected location prefix
  ///
  /// In en, this message translates to:
  /// **'Selected Location: '**
  String get selectedLocation;

  /// No products error message
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get productError;

  /// No services error message
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get serviceError;

  /// Location selection header
  ///
  /// In en, this message translates to:
  /// **'Select a location'**
  String get locationHeader;

  /// Location search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search region here'**
  String get locationPlaceholder;

  /// Category selection header
  ///
  /// In en, this message translates to:
  /// **'Select a Category'**
  String get categoryHeader;

  /// Category search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search Categories'**
  String get categoryPlaceholder;

  /// No categories error message
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get categoryError;

  /// First page button
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get paginationFirst;

  /// Previous page button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get paginationPrevious;

  /// Page information text
  ///
  /// In en, this message translates to:
  /// **'Page of'**
  String get pageInfo;

  /// Next page button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get pageNext;

  /// Last page button
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get pageLast;

  /// Loading products message
  ///
  /// In en, this message translates to:
  /// **'Loading products ...'**
  String get loadingMessageProduct;

  /// Loading error message
  ///
  /// In en, this message translates to:
  /// **'Error while loading'**
  String get loadingMessageError;

  /// Product like error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred while liking product'**
  String get likeProductError;

  /// Product dislike error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred while disliking product'**
  String get dislikeProductError;

  /// Loading location message
  ///
  /// In en, this message translates to:
  /// **'Loading location ...'**
  String get loadingMessageLocation;

  /// Location loading error
  ///
  /// In en, this message translates to:
  /// **'Error while loading location'**
  String get loadingLocationError;

  /// Loading categories message
  ///
  /// In en, this message translates to:
  /// **'Loading categories ...'**
  String get loadingMessageCategory;

  /// Category loading error
  ///
  /// In en, this message translates to:
  /// **'Error loading categories:'**
  String get loadingCategoryError;

  /// Profile update success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdateSuccessMessage;

  /// Profile update failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileUpdateFailMessage;

  /// See more button text
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMoreBtn;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile Page'**
  String get profilePageTitle;

  /// Edit profile modal title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileModalTitle;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// Location field label
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get locationLabel;

  /// Profile image field label
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileImageLabel;

  /// File chooser label
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get chooseFileLabel;

  /// Upload button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get uploadBtnLabel;

  /// Uploading button label
  ///
  /// In en, this message translates to:
  /// **'Updating ...'**
  String get uploadingBtnLabel;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBtnLabel;

  /// Products section title
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// Services section title
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// My products section title
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get myProductsTitle;

  /// My services section title
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get myServicesTitle;

  /// Favorite products section title
  ///
  /// In en, this message translates to:
  /// **'Favorite Products'**
  String get favoriteProductsTitle;

  /// Favorite services section title
  ///
  /// In en, this message translates to:
  /// **'Favorite Services'**
  String get favoriteServicesTitle;

  /// No favorites message
  ///
  /// In en, this message translates to:
  /// **'No Favorites'**
  String get noFavorites;

  /// Add new product button
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addNewProductBtn;

  /// Add new item button
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get addNew;

  /// Add new service button
  ///
  /// In en, this message translates to:
  /// **'Add New Service'**
  String get addNewServiceBtn;

  /// Download mobile app message
  ///
  /// In en, this message translates to:
  /// **'Download the mobile app'**
  String get downloadMobileApp;

  /// Phone verification success message
  ///
  /// In en, this message translates to:
  /// **'Phone number verified! You can proceed to the next step.'**
  String get registerPhoneNumberSuccess;

  /// Region selected message
  ///
  /// In en, this message translates to:
  /// **'Region selected:'**
  String get regionSelectedMessage;

  /// District selected message
  ///
  /// In en, this message translates to:
  /// **'District selected:'**
  String get districtSelectMessage;

  /// Phone number empty error
  ///
  /// In en, this message translates to:
  /// **'Please verify your phone number before proceeding'**
  String get phoneNumberEmptyMessage;

  /// Region empty error
  ///
  /// In en, this message translates to:
  /// **'Please select the region first'**
  String get regionEmptyMessage;

  /// District empty error
  ///
  /// In en, this message translates to:
  /// **' Please select the district'**
  String get districtEmptyMessage;

  /// Username password empty error
  ///
  /// In en, this message translates to:
  /// **'Please input username and password'**
  String get usernamePasswordEmptyMessage;

  /// Register screen title
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousButton;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// Complete button text
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeButton;

  /// Step indicator text
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} out of 4'**
  String stepIndicator(int currentStep);

  /// District selection title
  ///
  /// In en, this message translates to:
  /// **'District List'**
  String get districtSelectTitle;

  /// District selection instruction
  ///
  /// In en, this message translates to:
  /// **'Select a district:'**
  String get districtSelectParagraph;

  /// Phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Send OTP button
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// Send again button
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get sendAgain;

  /// Verify button
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// OTP send failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP. Server returned false.'**
  String get failedToSendOtp;

  /// OTP send error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sending OTP.'**
  String get errorSendingOtp;

  /// Invalid phone number error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get invalidPhoneNumber;

  /// Verification success message
  ///
  /// In en, this message translates to:
  /// **'Successfully verified'**
  String get verificationSuccess;

  /// Verification error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again later.'**
  String get verificationError;

  /// Regions list title
  ///
  /// In en, this message translates to:
  /// **'Regions List'**
  String get regionsList;

  /// Username input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// Welcome login message
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tezsell, log in with your phone number'**
  String get welcomeMessage;

  /// Register link text
  ///
  /// In en, this message translates to:
  /// **'No account yet? Register here'**
  String get noAccount;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Successfully logged'**
  String get successLogin;

  /// My profile menu item
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'logout'**
  String get logout;

  /// Product title field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get newProductTitle;

  /// Product description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get newProductDescription;

  /// Product price field
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get newProductPrice;

  /// Product condition field
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get newProductCondition;

  /// Product category field
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get newProductCategory;

  /// Product images field
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get newProductImages;

  /// Add new service title
  ///
  /// In en, this message translates to:
  /// **'Add New Service'**
  String get addNewService;

  /// Creating text
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// Service name field
  ///
  /// In en, this message translates to:
  /// **'Service Name '**
  String get serviceName;

  /// Service name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter service title'**
  String get serviceNamePlaceholder;

  /// Service description field
  ///
  /// In en, this message translates to:
  /// **'Service Description '**
  String get serviceDescription;

  /// Service description placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter service description'**
  String get serviceDescriptionPlaceholder;

  /// Service category field
  ///
  /// In en, this message translates to:
  /// **'Service Category '**
  String get serviceCategory;

  /// Category selection instruction
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// Loading categories text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingCategories;

  /// Category loading error
  ///
  /// In en, this message translates to:
  /// **'Error loading categories'**
  String get errorLoadingCategories;

  /// Service images field
  ///
  /// In en, this message translates to:
  /// **'Service Images'**
  String get serviceImages;

  /// Image upload help text
  ///
  /// In en, this message translates to:
  /// **'Click the + icon to add images (maximum 10)'**
  String get imageUploadHelper;

  /// Maximum images error
  ///
  /// In en, this message translates to:
  /// **'You can upload a maximum of 10 images'**
  String get maxImagesError;

  /// Category not found error
  ///
  /// In en, this message translates to:
  /// **'Category not found'**
  String get categoryNotFound;

  /// Product creation success
  ///
  /// In en, this message translates to:
  /// **'Product created successfully'**
  String get productCreatedSuccess;

  /// Product like success
  ///
  /// In en, this message translates to:
  /// **'Product liked successfully'**
  String get productLikeSuccess;

  /// Product dislike success
  ///
  /// In en, this message translates to:
  /// **'Product disliked successfully'**
  String get productDislikeSuccess;

  /// Service creation error
  ///
  /// In en, this message translates to:
  /// **'Error while creating service'**
  String get errorCreatingService;

  /// Product creation error
  ///
  /// In en, this message translates to:
  /// **'Error while creating product'**
  String get errorCreatingProduct;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred while creating the service'**
  String get unknownError;

  /// Submit button
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Select category action
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategoryAction;

  /// Select condition action
  ///
  /// In en, this message translates to:
  /// **'Select Condition'**
  String get selectCondition;

  /// Sum/Total label
  ///
  /// In en, this message translates to:
  /// **'Sum'**
  String get sum;

  /// No comments message
  ///
  /// In en, this message translates to:
  /// **' No comments yet. Be the first to comment!'**
  String get noComments;

  /// Comment like success
  ///
  /// In en, this message translates to:
  /// **'Comment liked successfully'**
  String get commentLikeSuccess;

  /// Comment like error
  ///
  /// In en, this message translates to:
  /// **'Error while liking comment'**
  String get commentLikeError;

  /// Unknown error message generic
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownErrorMessage;

  /// Comment dislike success
  ///
  /// In en, this message translates to:
  /// **'Comment disliked successfully'**
  String get commentDislikeSuccess;

  /// Comment dislike error
  ///
  /// In en, this message translates to:
  /// **'Error while disliking comment'**
  String get commentDislikeError;

  /// Reply validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a reply first'**
  String get replyInfo;

  /// Reply success message
  ///
  /// In en, this message translates to:
  /// **'Reply added successfully'**
  String get replySuccessMessage;

  /// Reply error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred during the creation of the reply'**
  String get replyErrorMessage;

  /// Comment update success
  ///
  /// In en, this message translates to:
  /// **'Comment updated successfully'**
  String get commentUpdateSuccess;

  /// Comment update error
  ///
  /// In en, this message translates to:
  /// **'Error updating comment item'**
  String get commentUpdateError;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment?'**
  String get deleteConfirmationMessage;

  /// Comment delete success
  ///
  /// In en, this message translates to:
  /// **'Comment deleted successfully'**
  String get commentDeleteSuccess;

  /// Comment delete error
  ///
  /// In en, this message translates to:
  /// **'Error deleting comment'**
  String get commentDeleteError;

  /// Edit button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// Reply button label
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get replyLabel;

  /// Replies section title
  ///
  /// In en, this message translates to:
  /// **'replies'**
  String get replyTitle;

  /// Reply input placeholder
  ///
  /// In en, this message translates to:
  /// **'Write a reply...'**
  String get replyPlaceholder;

  /// Chat login required message
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to start a chat'**
  String get chatLoginMessage;

  /// Can't chat with yourself message
  ///
  /// In en, this message translates to:
  /// **'You can\'t chat with yourself.'**
  String get chatYourselfMessage;

  /// Chat room created message
  ///
  /// In en, this message translates to:
  /// **'Chat room created!'**
  String get chatRoomMessage;

  /// Chat room creation error
  ///
  /// In en, this message translates to:
  /// **'Failed to create chat!'**
  String get chatRoomError;

  /// Chat creation error
  ///
  /// In en, this message translates to:
  /// **'Chat creation failed!'**
  String get chatCreationError;

  /// Products total count
  ///
  /// In en, this message translates to:
  /// **'Products total'**
  String get productsTotal;

  /// Items per page
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get perPage;

  /// Clear filters button
  ///
  /// In en, this message translates to:
  /// **'Clear all filters'**
  String get clearAllFilters;

  /// Upload instruction
  ///
  /// In en, this message translates to:
  /// **'Click to upload'**
  String get clickToUpload;

  /// Product in stock status
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get productInStock;

  /// Product out of stock status
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get productOutStock;

  /// Back to products button
  ///
  /// In en, this message translates to:
  /// **'Back to products'**
  String get productBack;

  /// Message seller button
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get messageSeller;

  /// Recommended products section
  ///
  /// In en, this message translates to:
  /// **'Recommended Products'**
  String get recommendedProducts;

  /// Product delete confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product?'**
  String get deleteConfirmationProduct;

  /// Product delete success
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productDeleteSuccess;

  /// Product delete error
  ///
  /// In en, this message translates to:
  /// **'Error deleting product'**
  String get productDeleteError;

  /// New condition
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newCondition;

  /// Used condition
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// Image validation error
  ///
  /// In en, this message translates to:
  /// **'Some files were not added. Please use JPG, PNG, GIF or WebP files under 5MB.'**
  String get imageValidType;

  /// Image removal confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this image?'**
  String get imageConfirmMessage;

  /// Title required validation
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequiredMessage;

  /// Description required validation
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descRequiredMessage;

  /// Price required validation
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceRequiredMessage;

  /// Condition required validation
  ///
  /// In en, this message translates to:
  /// **'Condition is required'**
  String get conditionRequiredMessage;

  /// Fill required fields message
  ///
  /// In en, this message translates to:
  /// **'Please fill the required fields'**
  String get pleaseFillAllRequired;

  /// One image required validation
  ///
  /// In en, this message translates to:
  /// **'At least one product image is required'**
  String get oneImageConfirmMessage;

  /// Category required validation
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get categoryRequiredMessage;

  /// Location info missing error
  ///
  /// In en, this message translates to:
  /// **'User location information is missing'**
  String get locationInfoError;

  /// Edit product title
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProductTitle;

  /// Image upload requirements
  ///
  /// In en, this message translates to:
  /// **'At least one image is required. You can upload up to 10 images (JPG, PNG, GIF, WebP under 5MB each).'**
  String get imageUploadRequirements;

  /// Product update success
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get productUpdatedSuccess;

  /// Product update failed
  ///
  /// In en, this message translates to:
  /// **'Product update failed'**
  String get productUpdateFailed;

  /// Product update error
  ///
  /// In en, this message translates to:
  /// **'Error occurred while updating the product'**
  String get errorUpdatingProduct;

  /// Back to services button
  ///
  /// In en, this message translates to:
  /// **'Back to services'**
  String get serviceBack;

  /// Like button label
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get likeLabel;

  /// Comments section label
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsLabel;

  /// Write comment placeholder
  ///
  /// In en, this message translates to:
  /// **'Write a comment ...'**
  String get writeComment;

  /// Posting comment text
  ///
  /// In en, this message translates to:
  /// **'Posting...'**
  String get postingLabel;

  /// Comment created success
  ///
  /// In en, this message translates to:
  /// **'Comment created'**
  String get commentCreated;

  /// Post comment button
  ///
  /// In en, this message translates to:
  /// **'Post Comment'**
  String get postCommentLabel;

  /// Login required for comments
  ///
  /// In en, this message translates to:
  /// **'Please log in to view and post comments.'**
  String get loginPrompt;

  /// Recommended services section
  ///
  /// In en, this message translates to:
  /// **'Recommended Services'**
  String get recommendedServices;

  /// Comments visibility notice
  ///
  /// In en, this message translates to:
  /// **'Comments are only visible to logged-in users.'**
  String get commentsVisibilityNotice;

  /// Coming soon text
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Service update success
  ///
  /// In en, this message translates to:
  /// **'Service updated successfully'**
  String get serviceUpdateSuccess;

  /// Service update error
  ///
  /// In en, this message translates to:
  /// **'Error updating service item'**
  String get serviceUpdateError;

  /// Edit service modal title
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get editServiceModalTitle;

  /// Phone number input instruction without country code
  ///
  /// In en, this message translates to:
  /// **'Enter phone number without code'**
  String get enterPhoneNumberWithoutCode;

  /// Hero section title
  ///
  /// In en, this message translates to:
  /// **'TezSell'**
  String get heroTitle;

  /// Hero section subtitle
  ///
  /// In en, this message translates to:
  /// **'Your Fast & Easy Marketplace for Uzbekistan'**
  String get heroSubtitle;

  /// Start selling button
  ///
  /// In en, this message translates to:
  /// **'Start Selling'**
  String get startSelling;

  /// Browse products button
  ///
  /// In en, this message translates to:
  /// **'Browse Products'**
  String get browseProducts;

  /// Features section title
  ///
  /// In en, this message translates to:
  /// **'Why Choose TezSell?'**
  String get featuresTitle;

  /// Listing feature title
  ///
  /// In en, this message translates to:
  /// **'Simple Product Listing'**
  String get listingTitle;

  /// Listing feature description
  ///
  /// In en, this message translates to:
  /// **'List your items with just a few clicks. Add photos, set your price, and connect with buyers instantly.'**
  String get listingDescription;

  /// Location feature title
  ///
  /// In en, this message translates to:
  /// **'Location-Based Browsing'**
  String get locationTitle;

  /// Location feature description
  ///
  /// In en, this message translates to:
  /// **'Find deals near you. Our location-based system helps you discover items in your neighborhood.'**
  String get locationDescription;

  /// Location page subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose your region and district to see nearby listings'**
  String get location_subtitle;

  /// Category feature title
  ///
  /// In en, this message translates to:
  /// **'Category Filtering'**
  String get categoryTitle;

  /// Category feature description
  ///
  /// In en, this message translates to:
  /// **'Easily navigate through different categories to find exactly what you\'re looking for.'**
  String get categoryDescription;

  /// Inspiration section title
  ///
  /// In en, this message translates to:
  /// **'Inspired by Korea\'s Carrot Market'**
  String get inspirationTitle;

  /// Inspiration description 1
  ///
  /// In en, this message translates to:
  /// **'We\'ve built TezSell with inspiration from Korea\'s successful Carrot Market (당근마켓), but tailored it specifically to meet the unique needs of Uzbekistan\'s local communities.'**
  String get inspirationDescription1;

  /// Inspiration description 2
  ///
  /// In en, this message translates to:
  /// **'Our mission is to create a trustworthy platform where neighbors can buy, sell, and connect with each other easily.'**
  String get inspirationDescription2;

  /// Coming soon section title
  ///
  /// In en, this message translates to:
  /// **'Coming Soon to TezSell'**
  String get comingSoonTitle;

  /// In-app chat feature
  ///
  /// In en, this message translates to:
  /// **'In-App Chat'**
  String get inAppChat;

  /// Secure transactions feature
  ///
  /// In en, this message translates to:
  /// **'Secure Transactions'**
  String get secureTransactions;

  /// Real estate listings feature
  ///
  /// In en, this message translates to:
  /// **'Real Estate Listings'**
  String get realEstateListings;

  /// Stay updated text
  ///
  /// In en, this message translates to:
  /// **'Stay Updated'**
  String get stayUpdated;

  /// Coming soon badge
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoonBadge;

  /// CTA section title
  ///
  /// In en, this message translates to:
  /// **'Join the TezSell Community Today!'**
  String get ctaTitle;

  /// CTA section description
  ///
  /// In en, this message translates to:
  /// **'Be part of building a better marketplace experience for Uzbekistan. Share your feedback and help us grow!'**
  String get ctaDescription;

  /// Create account button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Learn more button
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// Reply update success
  ///
  /// In en, this message translates to:
  /// **'Reply updated successfully'**
  String get replyUpdateSuccess;

  /// Reply update error
  ///
  /// In en, this message translates to:
  /// **'Failed to update reply'**
  String get replyUpdateError;

  /// Reply delete success
  ///
  /// In en, this message translates to:
  /// **'Reply deleted successfully'**
  String get replyDeleteSuccess;

  /// Reply delete error
  ///
  /// In en, this message translates to:
  /// **'Failed to delete reply'**
  String get replyDeleteError;

  /// Reply delete confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this reply?'**
  String get replyDeleteConfirmation;

  /// Authentication required message
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authenticationRequired;

  /// Valid reply text required
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid reply text'**
  String get enterValidReply;

  /// Saving text
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Deleting text
  ///
  /// In en, this message translates to:
  /// **'Deleting...'**
  String get deleting;

  /// Properties section
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// Agents section
  ///
  /// In en, this message translates to:
  /// **'Agents'**
  String get agents;

  /// Become agent button
  ///
  /// In en, this message translates to:
  /// **'Become an Agent'**
  String get becomeAgent;

  /// Main/Primary label
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// Upload button text for main product
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Title for filtered products
  ///
  /// In en, this message translates to:
  /// **'Filtered Products'**
  String get filtered_products;

  /// Title for filtered services
  ///
  /// In en, this message translates to:
  /// **'Filtered Services'**
  String get filtered_services;

  /// No description provided for @productDetail.
  ///
  /// In en, this message translates to:
  /// **'Product Detail'**
  String get productDetail;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @locationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get locationNotAvailable;

  /// No description provided for @noTitle.
  ///
  /// In en, this message translates to:
  /// **'No Title'**
  String get noTitle;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get noCategory;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No Description'**
  String get noDescription;

  /// No description provided for @som.
  ///
  /// In en, this message translates to:
  /// **'Som'**
  String get som;

  /// About me menu item
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get about_me;

  /// About my name menu title
  ///
  /// In en, this message translates to:
  /// **'My Name'**
  String get my_name;

  /// No description provided for @customer_support.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get customer_support;

  /// No description provided for @customer_center.
  ///
  /// In en, this message translates to:
  /// **'Customer Center'**
  String get customer_center;

  /// No description provided for @customer_inquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get customer_inquiries;

  /// No description provided for @customer_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get customer_terms;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @tap_change_profile.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tap_change_profile;

  /// No description provided for @language_settings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get language_settings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select a language'**
  String get selectLanguage;

  /// No description provided for @select_theme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get select_theme;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @location_settings.
  ///
  /// In en, this message translates to:
  /// **'Location Settings'**
  String get location_settings;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @data_storage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get data_storage;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibilty'**
  String get accessibility;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @light_theme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light_theme;

  /// No description provided for @dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark_theme;

  /// No description provided for @system_theme.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get system_theme;

  /// No description provided for @my_products.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get my_products;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @delete_product.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get delete_product;

  /// No description provided for @delete_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product?'**
  String get delete_confirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @error_loading_products.
  ///
  /// In en, this message translates to:
  /// **'Error loading products: {error}'**
  String error_loading_products(String error);

  /// No description provided for @product_deleted_success.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get product_deleted_success;

  /// No description provided for @error_deleting_product.
  ///
  /// In en, this message translates to:
  /// **'Error deleting product: {error}'**
  String error_deleting_product(String error);

  /// No description provided for @no_products_found.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get no_products_found;

  /// No description provided for @add_first_product.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first product'**
  String get add_first_product;

  /// No description provided for @no_title.
  ///
  /// In en, this message translates to:
  /// **'No title'**
  String get no_title;

  /// No description provided for @no_description.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get no_description;

  /// No description provided for @in_stock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get in_stock;

  /// No description provided for @out_of_stock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get out_of_stock;

  /// No description provided for @new_condition.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get new_condition;

  /// No description provided for @edit_product.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get edit_product;

  /// No description provided for @delete_product_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get delete_product_tooltip;

  /// No description provided for @sum_currency.
  ///
  /// In en, this message translates to:
  /// **'Sum'**
  String get sum_currency;

  /// No description provided for @edit_product_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get edit_product_title;

  /// No description provided for @product_name.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get product_name;

  /// No description provided for @product_description.
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get product_description;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @condition_new.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get condition_new;

  /// No description provided for @condition_used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get condition_used;

  /// No description provided for @condition_refurbished.
  ///
  /// In en, this message translates to:
  /// **'Refurbished'**
  String get condition_refurbished;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @existing_images.
  ///
  /// In en, this message translates to:
  /// **'Existing Images'**
  String get existing_images;

  /// No description provided for @new_images.
  ///
  /// In en, this message translates to:
  /// **'New Images'**
  String get new_images;

  /// No description provided for @image_instructions.
  ///
  /// In en, this message translates to:
  /// **'Images will appear here. Please press the upload icon above.'**
  String get image_instructions;

  /// No description provided for @update_button.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update_button;

  /// No description provided for @loading_category_error.
  ///
  /// In en, this message translates to:
  /// **'Error loading categories: {error}'**
  String loading_category_error(String error);

  /// No description provided for @error_picking_images.
  ///
  /// In en, this message translates to:
  /// **'Error picking images: {error}'**
  String error_picking_images(String error);

  /// No description provided for @please_fill_all_required.
  ///
  /// In en, this message translates to:
  /// **'Please fill all the fields'**
  String get please_fill_all_required;

  /// No description provided for @invalid_price_message.
  ///
  /// In en, this message translates to:
  /// **'Invalid price entered. Please enter a valid number.'**
  String get invalid_price_message;

  /// No description provided for @category_required_message.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid category.'**
  String get category_required_message;

  /// No description provided for @one_image_required_message.
  ///
  /// In en, this message translates to:
  /// **'At least one product image is required'**
  String get one_image_required_message;

  /// No description provided for @product_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Product successfully updated'**
  String get product_updated_success;

  /// No description provided for @error_updating_product.
  ///
  /// In en, this message translates to:
  /// **'Error while updating product: {error}'**
  String error_updating_product(String error);

  /// No description provided for @my_services.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get my_services;

  /// No description provided for @delete_service.
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get delete_service;

  /// No description provided for @delete_service_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this service?'**
  String get delete_service_confirmation;

  /// No description provided for @no_services_found.
  ///
  /// In en, this message translates to:
  /// **'No services found'**
  String get no_services_found;

  /// No description provided for @add_first_service.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first service'**
  String get add_first_service;

  /// No description provided for @edit_service.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get edit_service;

  /// No description provided for @delete_service_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get delete_service_tooltip;

  /// No description provided for @service_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Service deleted successfully'**
  String get service_deleted_successfully;

  /// No description provided for @error_deleting_service.
  ///
  /// In en, this message translates to:
  /// **'Error deleting service'**
  String get error_deleting_service;

  /// No description provided for @error_loading_services.
  ///
  /// In en, this message translates to:
  /// **'Error loading services'**
  String get error_loading_services;

  /// No description provided for @service_name.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get service_name;

  /// No description provided for @enter_service_name.
  ///
  /// In en, this message translates to:
  /// **'Enter service name'**
  String get enter_service_name;

  /// No description provided for @service_name_required.
  ///
  /// In en, this message translates to:
  /// **'Service name is required'**
  String get service_name_required;

  /// No description provided for @service_name_min_length.
  ///
  /// In en, this message translates to:
  /// **'Service name must be at least 3 characters'**
  String get service_name_min_length;

  /// No description provided for @enter_service_description.
  ///
  /// In en, this message translates to:
  /// **'Enter service description'**
  String get enter_service_description;

  /// No description provided for @service_description_required.
  ///
  /// In en, this message translates to:
  /// **'Service description is required'**
  String get service_description_required;

  /// No description provided for @service_description_min_length.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters'**
  String get service_description_min_length;

  /// No description provided for @category_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get category_required;

  /// No description provided for @no_categories_available.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get no_categories_available;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select location'**
  String get select_location;

  /// No description provided for @location_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a location'**
  String get location_required;

  /// No description provided for @no_locations_available.
  ///
  /// In en, this message translates to:
  /// **'No locations available'**
  String get no_locations_available;

  /// No description provided for @add_images.
  ///
  /// In en, this message translates to:
  /// **'Add Images'**
  String get add_images;

  /// No description provided for @current_images.
  ///
  /// In en, this message translates to:
  /// **'Current Images'**
  String get current_images;

  /// No description provided for @no_images_selected.
  ///
  /// In en, this message translates to:
  /// **'No images selected'**
  String get no_images_selected;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @map_main.
  ///
  /// In en, this message translates to:
  /// **'Map & Properties'**
  String get map_main;

  /// No description provided for @agent_status.
  ///
  /// In en, this message translates to:
  /// **'Agent Status'**
  String get agent_status;

  /// No description provided for @admin_panel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get admin_panel;

  /// No description provided for @propertiesFound.
  ///
  /// In en, this message translates to:
  /// **'Properties Found'**
  String get propertiesFound;

  /// No description provided for @propertiesSaved.
  ///
  /// In en, this message translates to:
  /// **'properties saved'**
  String get propertiesSaved;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'saved'**
  String get saved;

  /// No description provided for @loadingProperties.
  ///
  /// In en, this message translates to:
  /// **'Loading properties...'**
  String get loadingProperties;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load properties. Please try again.'**
  String get failedToLoad;

  /// No description provided for @noPropertiesFound.
  ///
  /// In en, this message translates to:
  /// **'No properties found'**
  String get noPropertiesFound;

  /// No description provided for @tryAdjusting.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get tryAdjusting;

  /// No description provided for @search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search by title or location...'**
  String get search_placeholder;

  /// No description provided for @search_filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get search_filters;

  /// No description provided for @search_button.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_button;

  /// No description provided for @search_clear_filters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get search_clear_filters;

  /// No description provided for @filter_options_sale_and_rent.
  ///
  /// In en, this message translates to:
  /// **'Sale and Rent'**
  String get filter_options_sale_and_rent;

  /// No description provided for @filter_options_for_sale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get filter_options_for_sale;

  /// No description provided for @filter_options_for_rent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get filter_options_for_rent;

  /// No description provided for @filter_options_all_types.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get filter_options_all_types;

  /// No description provided for @filter_options_apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get filter_options_apartment;

  /// No description provided for @filter_options_house.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get filter_options_house;

  /// No description provided for @filter_options_townhouse.
  ///
  /// In en, this message translates to:
  /// **'Townhouse'**
  String get filter_options_townhouse;

  /// No description provided for @filter_options_villa.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get filter_options_villa;

  /// No description provided for @filter_options_commercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get filter_options_commercial;

  /// No description provided for @filter_options_office.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get filter_options_office;

  /// No description provided for @property_card_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get property_card_featured;

  /// No description provided for @property_card_bed.
  ///
  /// In en, this message translates to:
  /// **'bedroom'**
  String get property_card_bed;

  /// No description provided for @property_card_bath.
  ///
  /// In en, this message translates to:
  /// **'bathroom'**
  String get property_card_bath;

  /// No description provided for @property_card_parking.
  ///
  /// In en, this message translates to:
  /// **'parking'**
  String get property_card_parking;

  /// No description provided for @property_card_view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get property_card_view_details;

  /// No description provided for @property_card_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get property_card_contact;

  /// No description provided for @property_card_balcony.
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get property_card_balcony;

  /// No description provided for @property_card_garage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get property_card_garage;

  /// No description provided for @property_card_garden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get property_card_garden;

  /// No description provided for @property_card_pool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get property_card_pool;

  /// No description provided for @property_card_elevator.
  ///
  /// In en, this message translates to:
  /// **'Elevator'**
  String get property_card_elevator;

  /// No description provided for @property_card_furnished.
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get property_card_furnished;

  /// No description provided for @property_card_sales.
  ///
  /// In en, this message translates to:
  /// **'sales'**
  String get property_card_sales;

  /// No description provided for @pricing_month.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get pricing_month;

  /// No description provided for @results_properties_found.
  ///
  /// In en, this message translates to:
  /// **'Properties Found'**
  String get results_properties_found;

  /// No description provided for @results_properties_saved.
  ///
  /// In en, this message translates to:
  /// **'properties saved'**
  String get results_properties_saved;

  /// No description provided for @results_saved.
  ///
  /// In en, this message translates to:
  /// **'saved'**
  String get results_saved;

  /// No description provided for @results_loading_properties.
  ///
  /// In en, this message translates to:
  /// **'Loading properties...'**
  String get results_loading_properties;

  /// No description provided for @results_failed_to_load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load properties. Please try again.'**
  String get results_failed_to_load;

  /// No description provided for @results_no_properties_found.
  ///
  /// In en, this message translates to:
  /// **'No properties found'**
  String get results_no_properties_found;

  /// No description provided for @results_try_adjusting.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get results_try_adjusting;

  /// No description provided for @no_properties_found.
  ///
  /// In en, this message translates to:
  /// **'No properties found'**
  String get no_properties_found;

  /// No description provided for @no_category_properties.
  ///
  /// In en, this message translates to:
  /// **'No properties in this category'**
  String get no_category_properties;

  /// No description provided for @properties_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading properties...'**
  String get properties_loading;

  /// No description provided for @all_properties_loaded.
  ///
  /// In en, this message translates to:
  /// **'All properties loaded'**
  String get all_properties_loaded;

  /// No description provided for @pagination_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get pagination_previous;

  /// No description provided for @pagination_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get pagination_next;

  /// No description provided for @pagination_page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get pagination_page;

  /// No description provided for @pagination_page_of.
  ///
  /// In en, this message translates to:
  /// **'Page 1 of'**
  String get pagination_page_of;

  /// No description provided for @contact_modal_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_modal_title;

  /// No description provided for @contact_modal_agent_contact.
  ///
  /// In en, this message translates to:
  /// **'Agent Contact'**
  String get contact_modal_agent_contact;

  /// No description provided for @contact_modal_property_owner.
  ///
  /// In en, this message translates to:
  /// **'Property Owner'**
  String get contact_modal_property_owner;

  /// No description provided for @contact_modal_agent_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Agent Phone Number'**
  String get contact_modal_agent_phone_number;

  /// No description provided for @contact_modal_owner_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Owner Phone Number'**
  String get contact_modal_owner_phone_number;

  /// No description provided for @contact_modal_license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get contact_modal_license;

  /// No description provided for @contact_modal_rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get contact_modal_rating;

  /// No description provided for @contact_modal_call_now.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get contact_modal_call_now;

  /// No description provided for @contact_modal_copy_number.
  ///
  /// In en, this message translates to:
  /// **'Copy Number'**
  String get contact_modal_copy_number;

  /// No description provided for @contact_modal_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get contact_modal_close;

  /// No description provided for @contact_modal_contact_hours.
  ///
  /// In en, this message translates to:
  /// **'Contact Hours: 9:00 AM - 8:00 PM'**
  String get contact_modal_contact_hours;

  /// No description provided for @contact_modal_agent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get contact_modal_agent;

  /// No description provided for @errors_toggle_save_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle property save:'**
  String get errors_toggle_save_failed;

  /// No description provided for @errors_copy_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to copy phone number:'**
  String get errors_copy_failed;

  /// No description provided for @errors_phone_copied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied to clipboard'**
  String get errors_phone_copied;

  /// No description provided for @errors_error_occurred_regions.
  ///
  /// In en, this message translates to:
  /// **'An error occurred with regions'**
  String get errors_error_occurred_regions;

  /// No description provided for @errors_error_occurred_districts.
  ///
  /// In en, this message translates to:
  /// **'An error occurred with districts'**
  String get errors_error_occurred_districts;

  /// No description provided for @errors_please_fill_all_required_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get errors_please_fill_all_required_fields;

  /// No description provided for @errors_authentication_required.
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get errors_authentication_required;

  /// No description provided for @errors_user_info_missing.
  ///
  /// In en, this message translates to:
  /// **'User information missing'**
  String get errors_user_info_missing;

  /// No description provided for @errors_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please check your input data'**
  String get errors_validation_error;

  /// No description provided for @errors_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errors_permission_denied;

  /// No description provided for @errors_server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred'**
  String get errors_server_error;

  /// No description provided for @errors_network_error.
  ///
  /// In en, this message translates to:
  /// **'Network connection error'**
  String get errors_network_error;

  /// No description provided for @errors_timeout_error.
  ///
  /// In en, this message translates to:
  /// **'Request timeout exceeded'**
  String get errors_timeout_error;

  /// No description provided for @errors_custom_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errors_custom_error;

  /// No description provided for @errors_error_creating_property.
  ///
  /// In en, this message translates to:
  /// **'Error creating property'**
  String get errors_error_creating_property;

  /// No description provided for @errors_unknown_error_message.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get errors_unknown_error_message;

  /// No description provided for @errors_coordinates_not_found.
  ///
  /// In en, this message translates to:
  /// **'Could not find coordinates for this address. Please enter them manually.'**
  String get errors_coordinates_not_found;

  /// No description provided for @errors_coordinates_error.
  ///
  /// In en, this message translates to:
  /// **'Error getting coordinates. Please enter them manually.'**
  String get errors_coordinates_error;

  /// No description provided for @property_info_views.
  ///
  /// In en, this message translates to:
  /// **'views'**
  String get property_info_views;

  /// No description provided for @property_info_listed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get property_info_listed;

  /// No description provided for @property_info_price_per_sqm.
  ///
  /// In en, this message translates to:
  /// **'/sqm'**
  String get property_info_price_per_sqm;

  /// No description provided for @property_info_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get property_info_saved;

  /// No description provided for @property_info_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get property_info_save;

  /// No description provided for @property_info_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get property_info_share;

  /// No description provided for @loading_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading_loading;

  /// No description provided for @loading_loading_details.
  ///
  /// In en, this message translates to:
  /// **'Loading property details...'**
  String get loading_loading_details;

  /// No description provided for @loading_property_not_found.
  ///
  /// In en, this message translates to:
  /// **'Property not found'**
  String get loading_property_not_found;

  /// No description provided for @loading_property_not_found_message.
  ///
  /// In en, this message translates to:
  /// **'The property you\'re looking for doesn\'t exist or has been removed.'**
  String get loading_property_not_found_message;

  /// No description provided for @loading_back_to_properties.
  ///
  /// In en, this message translates to:
  /// **'Back to Properties'**
  String get loading_back_to_properties;

  /// No description provided for @loading_title.
  ///
  /// In en, this message translates to:
  /// **'Loading agents...'**
  String get loading_title;

  /// No description provided for @loading_message.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we load the list of agents.'**
  String get loading_message;

  /// No description provided for @loading_agent_not_found.
  ///
  /// In en, this message translates to:
  /// **'Agent not found'**
  String get loading_agent_not_found;

  /// No description provided for @property_details_title.
  ///
  /// In en, this message translates to:
  /// **'Property Details'**
  String get property_details_title;

  /// No description provided for @property_details_bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get property_details_bedrooms;

  /// No description provided for @property_details_bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get property_details_bathrooms;

  /// No description provided for @property_details_floor_area.
  ///
  /// In en, this message translates to:
  /// **'Floor Area'**
  String get property_details_floor_area;

  /// No description provided for @property_details_parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get property_details_parking;

  /// No description provided for @property_details_basic_information.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get property_details_basic_information;

  /// No description provided for @property_details_property_type.
  ///
  /// In en, this message translates to:
  /// **'Property Type:'**
  String get property_details_property_type;

  /// No description provided for @property_details_listing_type.
  ///
  /// In en, this message translates to:
  /// **'Listing Type:'**
  String get property_details_listing_type;

  /// No description provided for @property_details_for_sale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get property_details_for_sale;

  /// No description provided for @property_details_for_rent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get property_details_for_rent;

  /// No description provided for @property_details_year_built.
  ///
  /// In en, this message translates to:
  /// **'Year Built:'**
  String get property_details_year_built;

  /// No description provided for @property_details_floor.
  ///
  /// In en, this message translates to:
  /// **'Floor:'**
  String get property_details_floor;

  /// No description provided for @property_details_of.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get property_details_of;

  /// No description provided for @property_details_features_amenities.
  ///
  /// In en, this message translates to:
  /// **'Features & Amenities'**
  String get property_details_features_amenities;

  /// No description provided for @sections_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sections_description;

  /// No description provided for @sections_nearby_amenities.
  ///
  /// In en, this message translates to:
  /// **'Nearby Amenities'**
  String get sections_nearby_amenities;

  /// No description provided for @sections_similar_properties.
  ///
  /// In en, this message translates to:
  /// **'Similar Properties'**
  String get sections_similar_properties;

  /// No description provided for @amenities_metro.
  ///
  /// In en, this message translates to:
  /// **'Metro'**
  String get amenities_metro;

  /// No description provided for @amenities_school.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get amenities_school;

  /// No description provided for @amenities_hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get amenities_hospital;

  /// No description provided for @amenities_shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get amenities_shopping;

  /// No description provided for @amenities_away.
  ///
  /// In en, this message translates to:
  /// **'away'**
  String get amenities_away;

  /// No description provided for @contact_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_title;

  /// No description provided for @contact_professional_listing.
  ///
  /// In en, this message translates to:
  /// **'Professional Listing'**
  String get contact_professional_listing;

  /// No description provided for @contact_listed_by_agent.
  ///
  /// In en, this message translates to:
  /// **'Listed by verified agent'**
  String get contact_listed_by_agent;

  /// No description provided for @contact_by_owner.
  ///
  /// In en, this message translates to:
  /// **'By Owner'**
  String get contact_by_owner;

  /// No description provided for @contact_direct_contact.
  ///
  /// In en, this message translates to:
  /// **'Direct contact with property owner'**
  String get contact_direct_contact;

  /// No description provided for @contact_property_owner.
  ///
  /// In en, this message translates to:
  /// **'Property Owner'**
  String get contact_property_owner;

  /// No description provided for @contact_call_agent.
  ///
  /// In en, this message translates to:
  /// **'Call Agent'**
  String get contact_call_agent;

  /// No description provided for @contact_email_agent.
  ///
  /// In en, this message translates to:
  /// **'Email Agent'**
  String get contact_email_agent;

  /// No description provided for @contact_call_owner.
  ///
  /// In en, this message translates to:
  /// **'Call Owner'**
  String get contact_call_owner;

  /// No description provided for @contact_email_owner.
  ///
  /// In en, this message translates to:
  /// **'Email Owner'**
  String get contact_email_owner;

  /// No description provided for @contact_send_inquiry.
  ///
  /// In en, this message translates to:
  /// **'Send Inquiry'**
  String get contact_send_inquiry;

  /// No description provided for @property_status_title.
  ///
  /// In en, this message translates to:
  /// **'Property Status'**
  String get property_status_title;

  /// No description provided for @property_status_availability.
  ///
  /// In en, this message translates to:
  /// **'Availability:'**
  String get property_status_availability;

  /// No description provided for @property_status_available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get property_status_available;

  /// No description provided for @property_status_not_available.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get property_status_not_available;

  /// No description provided for @property_status_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured:'**
  String get property_status_featured;

  /// No description provided for @property_status_featured_property.
  ///
  /// In en, this message translates to:
  /// **'Featured Property'**
  String get property_status_featured_property;

  /// No description provided for @property_status_property_id.
  ///
  /// In en, this message translates to:
  /// **'Property ID:'**
  String get property_status_property_id;

  /// No description provided for @inquiry_title.
  ///
  /// In en, this message translates to:
  /// **'Send Inquiry'**
  String get inquiry_title;

  /// No description provided for @inquiry_inquiry_type.
  ///
  /// In en, this message translates to:
  /// **'Inquiry Type'**
  String get inquiry_inquiry_type;

  /// No description provided for @inquiry_request_info.
  ///
  /// In en, this message translates to:
  /// **'Request Information'**
  String get inquiry_request_info;

  /// No description provided for @inquiry_schedule_viewing.
  ///
  /// In en, this message translates to:
  /// **'Schedule Viewing'**
  String get inquiry_schedule_viewing;

  /// No description provided for @inquiry_make_offer.
  ///
  /// In en, this message translates to:
  /// **'Make Offer'**
  String get inquiry_make_offer;

  /// No description provided for @inquiry_request_callback.
  ///
  /// In en, this message translates to:
  /// **'Request Callback'**
  String get inquiry_request_callback;

  /// No description provided for @inquiry_message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get inquiry_message;

  /// No description provided for @inquiry_message_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your interest in this property...'**
  String get inquiry_message_placeholder;

  /// No description provided for @inquiry_offered_price.
  ///
  /// In en, this message translates to:
  /// **'Offered Price'**
  String get inquiry_offered_price;

  /// No description provided for @inquiry_enter_offer.
  ///
  /// In en, this message translates to:
  /// **'Enter your offer'**
  String get inquiry_enter_offer;

  /// No description provided for @inquiry_preferred_contact_time.
  ///
  /// In en, this message translates to:
  /// **'Preferred Contact Time (optional)'**
  String get inquiry_preferred_contact_time;

  /// No description provided for @inquiry_contact_time_placeholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Weekdays 9:00 AM - 5:00 PM'**
  String get inquiry_contact_time_placeholder;

  /// No description provided for @inquiry_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get inquiry_cancel;

  /// No description provided for @inquiry_sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get inquiry_sending;

  /// No description provided for @inquiry_send_inquiry.
  ///
  /// In en, this message translates to:
  /// **'Send Inquiry'**
  String get inquiry_send_inquiry;

  /// No description provided for @inquiry_inquiry_sent_success.
  ///
  /// In en, this message translates to:
  /// **'Inquiry sent successfully!'**
  String get inquiry_inquiry_sent_success;

  /// No description provided for @inquiry_inquiry_sent_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to send inquiry. Please try again.'**
  String get inquiry_inquiry_sent_error;

  /// No description provided for @alerts_link_copied.
  ///
  /// In en, this message translates to:
  /// **'Property link copied to clipboard!'**
  String get alerts_link_copied;

  /// No description provided for @alerts_phone_copied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied to clipboard!'**
  String get alerts_phone_copied;

  /// No description provided for @alerts_save_property_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save property:'**
  String get alerts_save_property_failed;

  /// No description provided for @alerts_email_subject.
  ///
  /// In en, this message translates to:
  /// **'Inquiry about:'**
  String get alerts_email_subject;

  /// No description provided for @alerts_email_body.
  ///
  /// In en, this message translates to:
  /// **'Hello,\\n\\nI\'m interested in your property \"{title}\" located at {address}.\\n\\nPlease contact me for more information.\\n\\nBest regards'**
  String alerts_email_body(Object address, Object title);

  /// No description provided for @related_properties_view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get related_properties_view_details;

  /// No description provided for @header_property.
  ///
  /// In en, this message translates to:
  /// **'Find Your Dream Property'**
  String get header_property;

  /// No description provided for @header_sub_property.
  ///
  /// In en, this message translates to:
  /// **'Discover premium real estate opportunities in Tashkent\'s most desirable neighborhoods'**
  String get header_sub_property;

  /// No description provided for @header_title.
  ///
  /// In en, this message translates to:
  /// **'Real Estate Agents'**
  String get header_title;

  /// No description provided for @header_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Find experienced agents to help with your real estate needs'**
  String get header_subtitle;

  /// No description provided for @header_agents_found.
  ///
  /// In en, this message translates to:
  /// **'agents found'**
  String get header_agents_found;

  /// No description provided for @filters_all_specializations.
  ///
  /// In en, this message translates to:
  /// **'All Specializations'**
  String get filters_all_specializations;

  /// No description provided for @filters_residential.
  ///
  /// In en, this message translates to:
  /// **'Residential'**
  String get filters_residential;

  /// No description provided for @filters_commercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get filters_commercial;

  /// No description provided for @filters_luxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get filters_luxury;

  /// No description provided for @filters_investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get filters_investment;

  /// No description provided for @filters_any_rating.
  ///
  /// In en, this message translates to:
  /// **'Any Rating'**
  String get filters_any_rating;

  /// No description provided for @filters_four_stars.
  ///
  /// In en, this message translates to:
  /// **'4+ Stars'**
  String get filters_four_stars;

  /// No description provided for @filters_four_half_stars.
  ///
  /// In en, this message translates to:
  /// **'4.5+ Stars'**
  String get filters_four_half_stars;

  /// No description provided for @filters_five_stars.
  ///
  /// In en, this message translates to:
  /// **'5 Stars'**
  String get filters_five_stars;

  /// No description provided for @filters_highest_rated.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get filters_highest_rated;

  /// No description provided for @filters_lowest_rated.
  ///
  /// In en, this message translates to:
  /// **'Lowest Rated'**
  String get filters_lowest_rated;

  /// No description provided for @filters_most_sales.
  ///
  /// In en, this message translates to:
  /// **'Most Sales'**
  String get filters_most_sales;

  /// No description provided for @filters_most_experience.
  ///
  /// In en, this message translates to:
  /// **'Most Experience'**
  String get filters_most_experience;

  /// No description provided for @agent_card_verified_agent.
  ///
  /// In en, this message translates to:
  /// **'Verified Agent'**
  String get agent_card_verified_agent;

  /// No description provided for @agent_card_years_experience.
  ///
  /// In en, this message translates to:
  /// **'years experience'**
  String get agent_card_years_experience;

  /// No description provided for @agent_card_years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get agent_card_years;

  /// No description provided for @agent_card_license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get agent_card_license;

  /// No description provided for @agent_card_specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get agent_card_specialization;

  /// No description provided for @agent_card_view_profile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get agent_card_view_profile;

  /// No description provided for @agent_card_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get agent_card_contact;

  /// No description provided for @agent_card_verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get agent_card_verified;

  /// No description provided for @no_results_title.
  ///
  /// In en, this message translates to:
  /// **'No Agents Found'**
  String get no_results_title;

  /// No description provided for @no_results_message.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria or filters.'**
  String get no_results_message;

  /// No description provided for @error_title.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Agents'**
  String get error_title;

  /// No description provided for @error_message.
  ///
  /// In en, this message translates to:
  /// **'Failed to load agent list. Please try again.'**
  String get error_message;

  /// No description provided for @error_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get error_retry;

  /// No description provided for @error_default_message.
  ///
  /// In en, this message translates to:
  /// **'Failed to load agent details'**
  String get error_default_message;

  /// No description provided for @error_try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get error_try_again;

  /// No description provided for @notifications_phone_copied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied to clipboard'**
  String get notifications_phone_copied;

  /// No description provided for @notifications_copy_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to copy phone number:'**
  String get notifications_copy_failed;

  /// No description provided for @fallback_agent_name.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get fallback_agent_name;

  /// No description provided for @fallback_default_phone.
  ///
  /// In en, this message translates to:
  /// **'+998 90 123 45 67'**
  String get fallback_default_phone;

  /// No description provided for @navigation_submit_property.
  ///
  /// In en, this message translates to:
  /// **'Submit Property'**
  String get navigation_submit_property;

  /// No description provided for @navigation_submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get navigation_submitting;

  /// No description provided for @navigation_back_to_agents.
  ///
  /// In en, this message translates to:
  /// **'Back to Agents'**
  String get navigation_back_to_agents;

  /// No description provided for @agent_profile_verified_agent.
  ///
  /// In en, this message translates to:
  /// **'Verified Agent'**
  String get agent_profile_verified_agent;

  /// No description provided for @agent_profile_contact_agent.
  ///
  /// In en, this message translates to:
  /// **'Contact Agent'**
  String get agent_profile_contact_agent;

  /// No description provided for @agent_profile_send_message.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get agent_profile_send_message;

  /// No description provided for @agent_profile_years_experience.
  ///
  /// In en, this message translates to:
  /// **'Years Experience'**
  String get agent_profile_years_experience;

  /// No description provided for @agent_profile_properties_sold.
  ///
  /// In en, this message translates to:
  /// **'Properties Sold'**
  String get agent_profile_properties_sold;

  /// No description provided for @agent_profile_active_listings.
  ///
  /// In en, this message translates to:
  /// **'Active Listings'**
  String get agent_profile_active_listings;

  /// No description provided for @agent_profile_total_properties.
  ///
  /// In en, this message translates to:
  /// **'Total Properties'**
  String get agent_profile_total_properties;

  /// No description provided for @tabs_overview.
  ///
  /// In en, this message translates to:
  /// **'overview'**
  String get tabs_overview;

  /// No description provided for @tabs_properties.
  ///
  /// In en, this message translates to:
  /// **'properties'**
  String get tabs_properties;

  /// No description provided for @tabs_reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get tabs_reviews;

  /// No description provided for @about_agent_title.
  ///
  /// In en, this message translates to:
  /// **'About Agent'**
  String get about_agent_title;

  /// No description provided for @about_agent_agency.
  ///
  /// In en, this message translates to:
  /// **'Agency'**
  String get about_agent_agency;

  /// No description provided for @about_agent_license_number.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get about_agent_license_number;

  /// No description provided for @about_agent_specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get about_agent_specialization;

  /// No description provided for @about_agent_member_since.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get about_agent_member_since;

  /// No description provided for @about_agent_verified_since.
  ///
  /// In en, this message translates to:
  /// **'Verified Since'**
  String get about_agent_verified_since;

  /// No description provided for @performance_metrics_title.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performance_metrics_title;

  /// No description provided for @performance_metrics_average_rating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get performance_metrics_average_rating;

  /// No description provided for @performance_metrics_properties_sold.
  ///
  /// In en, this message translates to:
  /// **'Properties Sold'**
  String get performance_metrics_properties_sold;

  /// No description provided for @performance_metrics_active_listings.
  ///
  /// In en, this message translates to:
  /// **'Active Listings'**
  String get performance_metrics_active_listings;

  /// No description provided for @performance_metrics_years_experience.
  ///
  /// In en, this message translates to:
  /// **'Years Experience'**
  String get performance_metrics_years_experience;

  /// No description provided for @contact_info_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_info_title;

  /// No description provided for @contact_info_contact_via_platform.
  ///
  /// In en, this message translates to:
  /// **'Contact via Platform'**
  String get contact_info_contact_via_platform;

  /// No description provided for @verification_status_title.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get verification_status_title;

  /// No description provided for @verification_status_verified_agent.
  ///
  /// In en, this message translates to:
  /// **'Verified Agent'**
  String get verification_status_verified_agent;

  /// No description provided for @verification_status_pending_verification.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get verification_status_pending_verification;

  /// No description provided for @verification_status_licensed_professional.
  ///
  /// In en, this message translates to:
  /// **'Licensed Professional'**
  String get verification_status_licensed_professional;

  /// No description provided for @verification_status_registered_agency.
  ///
  /// In en, this message translates to:
  /// **'Registered Agency'**
  String get verification_status_registered_agency;

  /// No description provided for @quick_actions_title.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions_title;

  /// No description provided for @quick_actions_call_now.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get quick_actions_call_now;

  /// No description provided for @quick_actions_send_message.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get quick_actions_send_message;

  /// No description provided for @quick_actions_view_properties.
  ///
  /// In en, this message translates to:
  /// **'View Properties'**
  String get quick_actions_view_properties;

  /// No description provided for @properties_title.
  ///
  /// In en, this message translates to:
  /// **'Agent Properties'**
  String get properties_title;

  /// No description provided for @properties_loading_properties.
  ///
  /// In en, this message translates to:
  /// **'Loading properties...'**
  String get properties_loading_properties;

  /// No description provided for @properties_no_properties_title.
  ///
  /// In en, this message translates to:
  /// **'No Properties Found'**
  String get properties_no_properties_title;

  /// No description provided for @properties_no_properties_message.
  ///
  /// In en, this message translates to:
  /// **'This agent\'s properties will appear here.'**
  String get properties_no_properties_message;

  /// No description provided for @properties_recent_properties_note.
  ///
  /// In en, this message translates to:
  /// **'Showing recent properties. Check full listings for all agent properties.'**
  String get properties_recent_properties_note;

  /// No description provided for @properties_listed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get properties_listed;

  /// No description provided for @properties_bed.
  ///
  /// In en, this message translates to:
  /// **'bed'**
  String get properties_bed;

  /// No description provided for @properties_bath.
  ///
  /// In en, this message translates to:
  /// **'bath'**
  String get properties_bath;

  /// No description provided for @properties_for_sale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get properties_for_sale;

  /// No description provided for @properties_for_rent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get properties_for_rent;

  /// No description provided for @reviews_title.
  ///
  /// In en, this message translates to:
  /// **'Client Reviews'**
  String get reviews_title;

  /// No description provided for @reviews_no_reviews_title.
  ///
  /// In en, this message translates to:
  /// **'No Reviews Yet'**
  String get reviews_no_reviews_title;

  /// No description provided for @reviews_no_reviews_message.
  ///
  /// In en, this message translates to:
  /// **'Client reviews and recommendations will appear here.'**
  String get reviews_no_reviews_message;

  /// No description provided for @fallbacks_agent_name.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get fallbacks_agent_name;

  /// No description provided for @fallbacks_default_profile_image.
  ///
  /// In en, this message translates to:
  /// **'/default-avatar.png'**
  String get fallbacks_default_profile_image;

  /// No description provided for @saved_properties_title.
  ///
  /// In en, this message translates to:
  /// **'Saved Properties'**
  String get saved_properties_title;

  /// No description provided for @saved_properties_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your favorite properties in one place'**
  String get saved_properties_subtitle;

  /// No description provided for @saved_properties_no_saved_properties.
  ///
  /// In en, this message translates to:
  /// **'No saved properties yet'**
  String get saved_properties_no_saved_properties;

  /// No description provided for @saved_properties_start_saving.
  ///
  /// In en, this message translates to:
  /// **'Start exploring and save properties you like'**
  String get saved_properties_start_saving;

  /// No description provided for @saved_properties_browse_properties.
  ///
  /// In en, this message translates to:
  /// **'Browse Properties'**
  String get saved_properties_browse_properties;

  /// No description provided for @saved_properties_saved_on.
  ///
  /// In en, this message translates to:
  /// **'Saved on'**
  String get saved_properties_saved_on;

  /// No description provided for @auth_login_required.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view saved properties'**
  String get auth_login_required;

  /// No description provided for @auth_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login;

  /// No description provided for @success_property_unsaved.
  ///
  /// In en, this message translates to:
  /// **'Property removed from saved list'**
  String get success_property_unsaved;

  /// No description provided for @success_property_saved.
  ///
  /// In en, this message translates to:
  /// **'Property saved successfully'**
  String get success_property_saved;

  /// No description provided for @success_phone_copied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied!'**
  String get success_phone_copied;

  /// No description provided for @success_property_created_success.
  ///
  /// In en, this message translates to:
  /// **'Property created successfully!'**
  String get success_property_created_success;

  /// No description provided for @success_agent_approved.
  ///
  /// In en, this message translates to:
  /// **'Agent approved successfully'**
  String get success_agent_approved;

  /// No description provided for @success_agent_rejected.
  ///
  /// In en, this message translates to:
  /// **'Agent rejected successfully'**
  String get success_agent_rejected;

  /// No description provided for @steps_step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get steps_step;

  /// No description provided for @steps_basic_information.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get steps_basic_information;

  /// No description provided for @steps_location_details.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get steps_location_details;

  /// No description provided for @steps_property_details.
  ///
  /// In en, this message translates to:
  /// **'Property Details'**
  String get steps_property_details;

  /// No description provided for @steps_property_images.
  ///
  /// In en, this message translates to:
  /// **'Property Images'**
  String get steps_property_images;

  /// No description provided for @basic_info_tell_us_about_property.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your property'**
  String get basic_info_tell_us_about_property;

  /// No description provided for @basic_info_property_type.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get basic_info_property_type;

  /// No description provided for @basic_info_listing_type.
  ///
  /// In en, this message translates to:
  /// **'Listing Type'**
  String get basic_info_listing_type;

  /// No description provided for @basic_info_property_title.
  ///
  /// In en, this message translates to:
  /// **'Property Title'**
  String get basic_info_property_title;

  /// No description provided for @basic_info_title_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Enter a descriptive title for your property'**
  String get basic_info_title_placeholder;

  /// No description provided for @basic_info_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get basic_info_description;

  /// No description provided for @basic_info_description_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Describe your property in detail...'**
  String get basic_info_description_placeholder;

  /// No description provided for @property_types_apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get property_types_apartment;

  /// No description provided for @property_types_house.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get property_types_house;

  /// No description provided for @property_types_townhouse.
  ///
  /// In en, this message translates to:
  /// **'Townhouse'**
  String get property_types_townhouse;

  /// No description provided for @property_types_villa.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get property_types_villa;

  /// No description provided for @property_types_commercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get property_types_commercial;

  /// No description provided for @property_types_office.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get property_types_office;

  /// No description provided for @property_types_land.
  ///
  /// In en, this message translates to:
  /// **'Land'**
  String get property_types_land;

  /// No description provided for @property_types_warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get property_types_warehouse;

  /// No description provided for @listing_types_for_sale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get listing_types_for_sale;

  /// No description provided for @listing_types_for_rent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get listing_types_for_rent;

  /// No description provided for @location_where_is_property.
  ///
  /// In en, this message translates to:
  /// **'Where is your property located?'**
  String get location_where_is_property;

  /// No description provided for @location_full_address.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get location_full_address;

  /// No description provided for @location_address_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Enter full address'**
  String get location_address_placeholder;

  /// No description provided for @location_region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get location_region;

  /// No description provided for @location_select_region.
  ///
  /// In en, this message translates to:
  /// **'Select region'**
  String get location_select_region;

  /// No description provided for @location_district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get location_district;

  /// No description provided for @location_select_district.
  ///
  /// In en, this message translates to:
  /// **'Select district'**
  String get location_select_district;

  /// No description provided for @location_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get location_city;

  /// No description provided for @location_city_placeholder.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get location_city_placeholder;

  /// No description provided for @location_loading_regions.
  ///
  /// In en, this message translates to:
  /// **'Loading regions...'**
  String get location_loading_regions;

  /// No description provided for @location_loading_districts.
  ///
  /// In en, this message translates to:
  /// **'Loading districts...'**
  String get location_loading_districts;

  /// No description provided for @location_map_coordinates.
  ///
  /// In en, this message translates to:
  /// **'Map Coordinates'**
  String get location_map_coordinates;

  /// No description provided for @location_get_coordinates.
  ///
  /// In en, this message translates to:
  /// **'Get Coordinates'**
  String get location_get_coordinates;

  /// No description provided for @location_latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get location_latitude;

  /// No description provided for @location_longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get location_longitude;

  /// No description provided for @location_coordinates_set.
  ///
  /// In en, this message translates to:
  /// **'Coordinates set'**
  String get location_coordinates_set;

  /// No description provided for @location_location_tips.
  ///
  /// In en, this message translates to:
  /// **'Location Tips'**
  String get location_location_tips;

  /// No description provided for @location_location_tip_1.
  ///
  /// In en, this message translates to:
  /// **'• Fill in the address first, then click \'Get Coordinates\' to automatically get the map location'**
  String get location_location_tip_1;

  /// No description provided for @location_location_tip_2.
  ///
  /// In en, this message translates to:
  /// **'• You can also manually enter coordinates if you know the exact location'**
  String get location_location_tip_2;

  /// No description provided for @location_location_tip_3.
  ///
  /// In en, this message translates to:
  /// **'• Accurate coordinates help buyers find your property on the map'**
  String get location_location_tip_3;

  /// No description provided for @property_details_provide_detailed_info.
  ///
  /// In en, this message translates to:
  /// **'Provide detailed information about your property'**
  String get property_details_provide_detailed_info;

  /// No description provided for @property_details_total_floors.
  ///
  /// In en, this message translates to:
  /// **'Total Floors'**
  String get property_details_total_floors;

  /// No description provided for @property_details_area_m2.
  ///
  /// In en, this message translates to:
  /// **'Area (m²)'**
  String get property_details_area_m2;

  /// No description provided for @property_details_parking_spaces.
  ///
  /// In en, this message translates to:
  /// **'Parking Spaces'**
  String get property_details_parking_spaces;

  /// No description provided for @property_details_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get property_details_price;

  /// No description provided for @property_details_features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get property_details_features;

  /// No description provided for @images_add_photos_showcase.
  ///
  /// In en, this message translates to:
  /// **'Add photos to showcase your property'**
  String get images_add_photos_showcase;

  /// No description provided for @images_click_to_upload.
  ///
  /// In en, this message translates to:
  /// **'Click to upload images'**
  String get images_click_to_upload;

  /// No description provided for @images_max_images_info.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 images, JPG, PNG or WEBP'**
  String get images_max_images_info;

  /// No description provided for @images_main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get images_main;

  /// No description provided for @images_maximum_images_allowed.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 images allowed'**
  String get images_maximum_images_allowed;

  /// No description provided for @admin_dashboard_title.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get admin_dashboard_title;

  /// No description provided for @admin_dashboard_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time overview of your real estate platform'**
  String get admin_dashboard_subtitle;

  /// No description provided for @admin_last_update.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get admin_last_update;

  /// No description provided for @admin_total_properties.
  ///
  /// In en, this message translates to:
  /// **'Total Properties'**
  String get admin_total_properties;

  /// No description provided for @admin_total_agents.
  ///
  /// In en, this message translates to:
  /// **'Total Agents'**
  String get admin_total_agents;

  /// No description provided for @admin_total_users.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get admin_total_users;

  /// No description provided for @admin_total_views.
  ///
  /// In en, this message translates to:
  /// **'Total Views'**
  String get admin_total_views;

  /// No description provided for @admin_error_loading_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Error loading dashboard'**
  String get admin_error_loading_dashboard;

  /// No description provided for @admin_failed_to_load_data.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard data'**
  String get admin_failed_to_load_data;

  /// No description provided for @admin_avg_sale_price.
  ///
  /// In en, this message translates to:
  /// **'Avg Sale Price'**
  String get admin_avg_sale_price;

  /// No description provided for @admin_avg_sale_price_subtitle.
  ///
  /// In en, this message translates to:
  /// **'All active listings'**
  String get admin_avg_sale_price_subtitle;

  /// No description provided for @admin_total_portfolio_value.
  ///
  /// In en, this message translates to:
  /// **'Total Portfolio Value'**
  String get admin_total_portfolio_value;

  /// No description provided for @admin_total_portfolio_value_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Combined property value'**
  String get admin_total_portfolio_value_subtitle;

  /// No description provided for @admin_avg_price_per_sqm.
  ///
  /// In en, this message translates to:
  /// **'Avg Price per sqm'**
  String get admin_avg_price_per_sqm;

  /// No description provided for @admin_avg_price_per_sqm_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Market rate indicator'**
  String get admin_avg_price_per_sqm_subtitle;

  /// No description provided for @admin_property_types_distribution.
  ///
  /// In en, this message translates to:
  /// **'Property Types Distribution'**
  String get admin_property_types_distribution;

  /// No description provided for @admin_properties_by_city.
  ///
  /// In en, this message translates to:
  /// **'Properties by City'**
  String get admin_properties_by_city;

  /// No description provided for @admin_properties_by_district.
  ///
  /// In en, this message translates to:
  /// **'Properties by District'**
  String get admin_properties_by_district;

  /// No description provided for @admin_inquiry_types_distribution.
  ///
  /// In en, this message translates to:
  /// **'Inquiry Types Distribution'**
  String get admin_inquiry_types_distribution;

  /// No description provided for @admin_agent_verification_rate.
  ///
  /// In en, this message translates to:
  /// **'Agent Verification Rate'**
  String get admin_agent_verification_rate;

  /// No description provided for @admin_agent_verification_rate_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Quality control'**
  String get admin_agent_verification_rate_subtitle;

  /// No description provided for @admin_inquiry_response_rate.
  ///
  /// In en, this message translates to:
  /// **'Inquiry Response Rate'**
  String get admin_inquiry_response_rate;

  /// No description provided for @admin_inquiry_response_rate_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer service'**
  String get admin_inquiry_response_rate_subtitle;

  /// No description provided for @admin_avg_views_per_property.
  ///
  /// In en, this message translates to:
  /// **'Avg Views per Property'**
  String get admin_avg_views_per_property;

  /// No description provided for @admin_avg_views_per_property_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Property popularity'**
  String get admin_avg_views_per_property_subtitle;

  /// No description provided for @admin_featured_properties.
  ///
  /// In en, this message translates to:
  /// **'Featured Properties'**
  String get admin_featured_properties;

  /// No description provided for @admin_featured_properties_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Premium listings'**
  String get admin_featured_properties_subtitle;

  /// No description provided for @admin_most_viewed_properties.
  ///
  /// In en, this message translates to:
  /// **'Most Viewed Properties'**
  String get admin_most_viewed_properties;

  /// No description provided for @admin_top_performing_agents.
  ///
  /// In en, this message translates to:
  /// **'Top Performing Agents'**
  String get admin_top_performing_agents;

  /// No description provided for @admin_system_health.
  ///
  /// In en, this message translates to:
  /// **'System Health'**
  String get admin_system_health;

  /// No description provided for @admin_properties_without_images.
  ///
  /// In en, this message translates to:
  /// **'Properties without images'**
  String get admin_properties_without_images;

  /// No description provided for @admin_missing_location_data.
  ///
  /// In en, this message translates to:
  /// **'Missing location data'**
  String get admin_missing_location_data;

  /// No description provided for @admin_pending_agent_verification.
  ///
  /// In en, this message translates to:
  /// **'Pending agent verification'**
  String get admin_pending_agent_verification;

  /// No description provided for @admin_active.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get admin_active;

  /// No description provided for @admin_verified.
  ///
  /// In en, this message translates to:
  /// **'verified'**
  String get admin_verified;

  /// No description provided for @admin_active_7d.
  ///
  /// In en, this message translates to:
  /// **'active (7d)'**
  String get admin_active_7d;

  /// No description provided for @admin_this_month.
  ///
  /// In en, this message translates to:
  /// **'this month'**
  String get admin_this_month;

  /// No description provided for @agents_loading_pending_applications.
  ///
  /// In en, this message translates to:
  /// **'Loading pending applications...'**
  String get agents_loading_pending_applications;

  /// No description provided for @agents_error_loading_applications.
  ///
  /// In en, this message translates to:
  /// **'Error loading applications'**
  String get agents_error_loading_applications;

  /// No description provided for @agents_pending_agents.
  ///
  /// In en, this message translates to:
  /// **'Pending Agents'**
  String get agents_pending_agents;

  /// No description provided for @agents_total_pending_applications.
  ///
  /// In en, this message translates to:
  /// **'Total pending applications: '**
  String get agents_total_pending_applications;

  /// No description provided for @agents_pending_verification.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get agents_pending_verification;

  /// No description provided for @agents_applied_date.
  ///
  /// In en, this message translates to:
  /// **'Applied: '**
  String get agents_applied_date;

  /// No description provided for @agents_contact_info.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get agents_contact_info;

  /// No description provided for @agents_license_number.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get agents_license_number;

  /// No description provided for @agents_years_experience.
  ///
  /// In en, this message translates to:
  /// **'Years Experience'**
  String get agents_years_experience;

  /// No description provided for @agents_years_suffix.
  ///
  /// In en, this message translates to:
  /// **' years'**
  String get agents_years_suffix;

  /// No description provided for @agents_total_sales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get agents_total_sales;

  /// No description provided for @agents_specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get agents_specialization;

  /// No description provided for @agents_approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get agents_approve;

  /// No description provided for @agents_reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get agents_reject;

  /// No description provided for @agents_no_pending_applications.
  ///
  /// In en, this message translates to:
  /// **'No pending applications'**
  String get agents_no_pending_applications;

  /// No description provided for @agents_all_applications_processed.
  ///
  /// In en, this message translates to:
  /// **'All agent applications have been processed'**
  String get agents_all_applications_processed;

  /// No description provided for @general_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get general_previous;

  /// No description provided for @general_page.
  ///
  /// In en, this message translates to:
  /// **'Page '**
  String get general_page;

  /// No description provided for @general_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get general_next;

  /// No description provided for @general_views.
  ///
  /// In en, this message translates to:
  /// **'views'**
  String get general_views;

  /// No description provided for @general_sales.
  ///
  /// In en, this message translates to:
  /// **'sales'**
  String get general_sales;

  /// No description provided for @general_language_uz.
  ///
  /// In en, this message translates to:
  /// **'O\'zbekcha'**
  String get general_language_uz;

  /// No description provided for @general_language_ru.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get general_language_ru;

  /// No description provided for @general_language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get general_language_en;

  /// No description provided for @general_super_admin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get general_super_admin;

  /// No description provided for @general_staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get general_staff;

  /// No description provided for @general_verified_agent.
  ///
  /// In en, this message translates to:
  /// **'Verified Agent'**
  String get general_verified_agent;

  /// No description provided for @general_pending_agent.
  ///
  /// In en, this message translates to:
  /// **'Pending Agent'**
  String get general_pending_agent;

  /// No description provided for @general_regular_user.
  ///
  /// In en, this message translates to:
  /// **'Regular User'**
  String get general_regular_user;

  /// No description provided for @general_admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get general_admin;

  /// No description provided for @general_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get general_dashboard;

  /// No description provided for @general_manage_users.
  ///
  /// In en, this message translates to:
  /// **'Manage Users'**
  String get general_manage_users;

  /// No description provided for @general_verified_agents.
  ///
  /// In en, this message translates to:
  /// **'Verified Agents'**
  String get general_verified_agents;

  /// No description provided for @general_agent_panel.
  ///
  /// In en, this message translates to:
  /// **'Agent Panel'**
  String get general_agent_panel;

  /// No description provided for @general_create_property.
  ///
  /// In en, this message translates to:
  /// **'Create Property'**
  String get general_create_property;

  /// No description provided for @general_my_properties.
  ///
  /// In en, this message translates to:
  /// **'My Properties'**
  String get general_my_properties;

  /// No description provided for @general_inquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get general_inquiries;

  /// No description provided for @general_agent_profile.
  ///
  /// In en, this message translates to:
  /// **'Agent Profile'**
  String get general_agent_profile;

  /// No description provided for @general_live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get general_live;

  /// No description provided for @general_logged_out_successfully.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get general_logged_out_successfully;

  /// No description provided for @general_logout_completed_with_errors.
  ///
  /// In en, this message translates to:
  /// **'Logout completed (with errors)'**
  String get general_logout_completed_with_errors;

  /// No description provided for @general_application_under_review.
  ///
  /// In en, this message translates to:
  /// **'Application under review'**
  String get general_application_under_review;

  /// No description provided for @general_check_status.
  ///
  /// In en, this message translates to:
  /// **'Check status →'**
  String get general_check_status;

  /// No description provided for @general_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last updated:'**
  String get general_last_updated;

  /// No description provided for @general_permissions_may_be_outdated.
  ///
  /// In en, this message translates to:
  /// **'Permissions may be outdated'**
  String get general_permissions_may_be_outdated;

  /// No description provided for @general_permissions_up_to_date.
  ///
  /// In en, this message translates to:
  /// **'Permissions up to date'**
  String get general_permissions_up_to_date;

  /// No description provided for @general_never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get general_never;

  /// No description provided for @general_properties_found.
  ///
  /// In en, this message translates to:
  /// **'Properties Found'**
  String get general_properties_found;

  /// No description provided for @general_properties_saved.
  ///
  /// In en, this message translates to:
  /// **'properties saved'**
  String get general_properties_saved;

  /// No description provided for @general_saved.
  ///
  /// In en, this message translates to:
  /// **'saved'**
  String get general_saved;

  /// No description provided for @general_loading_properties.
  ///
  /// In en, this message translates to:
  /// **'Loading properties...'**
  String get general_loading_properties;

  /// No description provided for @general_failed_to_load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load properties. Please try again.'**
  String get general_failed_to_load;

  /// No description provided for @general_no_properties_found.
  ///
  /// In en, this message translates to:
  /// **'No properties found'**
  String get general_no_properties_found;

  /// No description provided for @general_try_adjusting.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get general_try_adjusting;

  /// No description provided for @select_category.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get select_category;

  /// No description provided for @service_description.
  ///
  /// In en, this message translates to:
  /// **'Service Description'**
  String get service_description;

  /// No description provided for @product_search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Enter a search term to find products'**
  String get product_search_placeholder;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @terms_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy and terms'**
  String get terms_subtitle;

  /// No description provided for @last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get last_updated;

  /// No description provided for @contact_information.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_information;

  /// No description provided for @accept_terms.
  ///
  /// In en, this message translates to:
  /// **'I Accept Terms and Conditions'**
  String get accept_terms;

  /// No description provided for @read_terms.
  ///
  /// In en, this message translates to:
  /// **'Please read our terms and conditions'**
  String get read_terms;

  /// No description provided for @inquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries & Support'**
  String get inquiries;

  /// No description provided for @inquiries_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us for help'**
  String get inquiries_subtitle;

  /// No description provided for @help_center.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get help_center;

  /// No description provided for @help_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to assist you with any questions'**
  String get help_subtitle;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @email_support.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get email_support;

  /// No description provided for @call_support.
  ///
  /// In en, this message translates to:
  /// **'Call Support'**
  String get call_support;

  /// No description provided for @send_message.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get send_message;

  /// No description provided for @fill_contact_form.
  ///
  /// In en, this message translates to:
  /// **'Fill out contact form'**
  String get fill_contact_form;

  /// No description provided for @contact_form.
  ///
  /// In en, this message translates to:
  /// **'Contact Form'**
  String get contact_form;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get name;

  /// No description provided for @name_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get name_required;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get email_required;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get email_invalid;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @subject_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subject'**
  String get subject_required;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @message_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter your message'**
  String get message_required;

  /// No description provided for @message_too_short.
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters'**
  String get message_too_short;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// No description provided for @follow_us.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get follow_us;

  /// No description provided for @faq_how_to_sell.
  ///
  /// In en, this message translates to:
  /// **'How do I sell items on Tezsell?'**
  String get faq_how_to_sell;

  /// No description provided for @faq_how_to_sell_answer.
  ///
  /// In en, this message translates to:
  /// **'To sell items: 1) Create an account, 2) Tap the \'+\' button, 3) Choose category (Products/Services/Real Estate), 4) Add photos and description, 5) Set your price, 6) Publish! Your listing will be visible to buyers in your area.'**
  String get faq_how_to_sell_answer;

  /// No description provided for @faq_is_free.
  ///
  /// In en, this message translates to:
  /// **'Is Tezsell free to use?'**
  String get faq_is_free;

  /// No description provided for @faq_is_free_answer.
  ///
  /// In en, this message translates to:
  /// **'Yes! Tezsell is currently 100% free. No listing fees, no commission on sales, no subscription charges. We may introduce premium features in the future, but will notify users 30 days in advance.'**
  String get faq_is_free_answer;

  /// No description provided for @faq_safety.
  ///
  /// In en, this message translates to:
  /// **'How can I stay safe when buying/selling?'**
  String get faq_safety;

  /// No description provided for @faq_safety_answer.
  ///
  /// In en, this message translates to:
  /// **'Safety tips: 1) Meet in public places, 2) Inspect items before paying, 3) Never send money to strangers, 4) Trust your instincts, 5) Report suspicious users, 6) Don\'t share personal information too early, 7) Bring a friend for high-value transactions.'**
  String get faq_safety_answer;

  /// No description provided for @faq_payment.
  ///
  /// In en, this message translates to:
  /// **'How do payments work?'**
  String get faq_payment;

  /// No description provided for @faq_payment_answer.
  ///
  /// In en, this message translates to:
  /// **'Tezsell does not process payments. Buyers and sellers arrange payment directly (cash, bank transfer, etc.). We are just a platform to connect people - you handle the transaction yourselves.'**
  String get faq_payment_answer;

  /// No description provided for @faq_prohibited.
  ///
  /// In en, this message translates to:
  /// **'What items are prohibited?'**
  String get faq_prohibited;

  /// No description provided for @faq_prohibited_answer.
  ///
  /// In en, this message translates to:
  /// **'Prohibited items include: weapons, drugs, stolen goods, counterfeit items, adult content, live animals (without permits), government IDs, and hazardous materials. See our Terms & Conditions for the complete list.'**
  String get faq_prohibited_answer;

  /// No description provided for @faq_account_delete.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account?'**
  String get faq_account_delete;

  /// No description provided for @faq_account_delete_answer.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Settings → Account Settings → Delete Account. Note: This is permanent and cannot be undone. All your listings will be removed.'**
  String get faq_account_delete_answer;

  /// No description provided for @faq_report_user.
  ///
  /// In en, this message translates to:
  /// **'How do I report a user or listing?'**
  String get faq_report_user;

  /// No description provided for @faq_report_user_answer.
  ///
  /// In en, this message translates to:
  /// **'Tap the three dots (•••) on any listing or user profile, then select \'Report\'. Choose the reason and submit. We review all reports within 24-48 hours.'**
  String get faq_report_user_answer;

  /// No description provided for @faq_change_location.
  ///
  /// In en, this message translates to:
  /// **'How do I change my location?'**
  String get faq_change_location;

  /// No description provided for @faq_change_location_answer.
  ///
  /// In en, this message translates to:
  /// **'Tap the location button in the top-left corner of the home screen. You can select your region and district to see listings in your area.'**
  String get faq_change_location_answer;

  /// No description provided for @welcome_customer_center.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Customer Center'**
  String get welcome_customer_center;

  /// No description provided for @customer_center_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help you 24/7'**
  String get customer_center_subtitle;

  /// No description provided for @quick_actions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions;

  /// No description provided for @live_chat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get live_chat;

  /// No description provided for @chat_with_us.
  ///
  /// In en, this message translates to:
  /// **'Chat with us'**
  String get chat_with_us;

  /// No description provided for @find_answers.
  ///
  /// In en, this message translates to:
  /// **'Find answers'**
  String get find_answers;

  /// No description provided for @my_tickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get my_tickets;

  /// No description provided for @view_tickets.
  ///
  /// In en, this message translates to:
  /// **'View tickets'**
  String get view_tickets;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @share_feedback.
  ///
  /// In en, this message translates to:
  /// **'Share feedback'**
  String get share_feedback;

  /// No description provided for @contact_methods.
  ///
  /// In en, this message translates to:
  /// **'Contact Methods'**
  String get contact_methods;

  /// No description provided for @phone_support.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get phone_support;

  /// No description provided for @available_247.
  ///
  /// In en, this message translates to:
  /// **'Available 24/7'**
  String get available_247;

  /// No description provided for @response_24h.
  ///
  /// In en, this message translates to:
  /// **'Response within 24 hours'**
  String get response_24h;

  /// No description provided for @telegram_support.
  ///
  /// In en, this message translates to:
  /// **'Telegram Support'**
  String get telegram_support;

  /// No description provided for @instant_replies.
  ///
  /// In en, this message translates to:
  /// **'Instant replies'**
  String get instant_replies;

  /// No description provided for @whatsapp_support.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Support'**
  String get whatsapp_support;

  /// No description provided for @quick_response.
  ///
  /// In en, this message translates to:
  /// **'Quick response'**
  String get quick_response;

  /// No description provided for @popular_topics.
  ///
  /// In en, this message translates to:
  /// **'Popular Topics'**
  String get popular_topics;

  /// No description provided for @account_management.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get account_management;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @update_profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update_profile;

  /// No description provided for @verify_account.
  ///
  /// In en, this message translates to:
  /// **'Verify Account'**
  String get verify_account;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @buying_selling.
  ///
  /// In en, this message translates to:
  /// **'Buying & Selling'**
  String get buying_selling;

  /// No description provided for @how_to_post.
  ///
  /// In en, this message translates to:
  /// **'How to Post Ads'**
  String get how_to_post;

  /// No description provided for @payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get payment_methods;

  /// No description provided for @shipping_delivery.
  ///
  /// In en, this message translates to:
  /// **'Shipping & Delivery'**
  String get shipping_delivery;

  /// No description provided for @return_policy.
  ///
  /// In en, this message translates to:
  /// **'Return Policy'**
  String get return_policy;

  /// No description provided for @safety_security.
  ///
  /// In en, this message translates to:
  /// **'Safety & Security'**
  String get safety_security;

  /// No description provided for @report_scam.
  ///
  /// In en, this message translates to:
  /// **'Report Scam'**
  String get report_scam;

  /// No description provided for @safe_trading.
  ///
  /// In en, this message translates to:
  /// **'Safe Trading Tips'**
  String get safe_trading;

  /// No description provided for @privacy_settings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacy_settings;

  /// No description provided for @blocked_users.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get blocked_users;

  /// No description provided for @technical_issues.
  ///
  /// In en, this message translates to:
  /// **'Technical Issues'**
  String get technical_issues;

  /// No description provided for @app_not_working.
  ///
  /// In en, this message translates to:
  /// **'App Not Working'**
  String get app_not_working;

  /// No description provided for @upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Upload Failed'**
  String get upload_failed;

  /// No description provided for @login_problems.
  ///
  /// In en, this message translates to:
  /// **'Login Problems'**
  String get login_problems;

  /// No description provided for @support_hours.
  ///
  /// In en, this message translates to:
  /// **'Support Hours'**
  String get support_hours;

  /// No description provided for @mon_fri_9_6.
  ///
  /// In en, this message translates to:
  /// **'Mon-Fri: 9:00 AM - 6:00 PM'**
  String get mon_fri_9_6;

  /// No description provided for @how_are_we_doing.
  ///
  /// In en, this message translates to:
  /// **'How are we doing?'**
  String get how_are_we_doing;

  /// No description provided for @rate_experience.
  ///
  /// In en, this message translates to:
  /// **'Rate your customer service experience'**
  String get rate_experience;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @account_secure.
  ///
  /// In en, this message translates to:
  /// **'Your Account is Secure'**
  String get account_secure;

  /// No description provided for @password_security.
  ///
  /// In en, this message translates to:
  /// **'Password & Authentication'**
  String get password_security;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @two_factor_auth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get two_factor_auth;

  /// No description provided for @biometric_login.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometric_login;

  /// No description provided for @login_activity.
  ///
  /// In en, this message translates to:
  /// **'Login Activity'**
  String get login_activity;

  /// No description provided for @active_sessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get active_sessions;

  /// No description provided for @login_alerts.
  ///
  /// In en, this message translates to:
  /// **'Login Alerts'**
  String get login_alerts;

  /// No description provided for @account_protection.
  ///
  /// In en, this message translates to:
  /// **'Account Protection'**
  String get account_protection;

  /// No description provided for @recovery_email.
  ///
  /// In en, this message translates to:
  /// **'Recovery Email'**
  String get recovery_email;

  /// No description provided for @backup_codes.
  ///
  /// In en, this message translates to:
  /// **'Backup Codes'**
  String get backup_codes;

  /// No description provided for @danger_zone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get danger_zone;

  /// No description provided for @improve_security.
  ///
  /// In en, this message translates to:
  /// **'Improve Security'**
  String get improve_security;

  /// No description provided for @security_score.
  ///
  /// In en, this message translates to:
  /// **'Security Score'**
  String get security_score;

  /// No description provided for @last_changed_days.
  ///
  /// In en, this message translates to:
  /// **'Last changed 30 days ago'**
  String get last_changed_days;

  /// No description provided for @logout_all_devices.
  ///
  /// In en, this message translates to:
  /// **'Logout All Devices'**
  String get logout_all_devices;

  /// No description provided for @end_all_sessions.
  ///
  /// In en, this message translates to:
  /// **'End all sessions'**
  String get end_all_sessions;

  /// No description provided for @permanently_delete.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete'**
  String get permanently_delete;

  /// No description provided for @verification_code_message.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a verification code to confirm it\'s you.'**
  String get verification_code_message;

  /// No description provided for @send_code.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get send_code;

  /// No description provided for @enter_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enter_verification_code;

  /// No description provided for @verification_code.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verification_code;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend_code;

  /// No description provided for @code_sent_to.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to'**
  String get code_sent_to;

  /// No description provided for @enter_code.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enter_code;

  /// No description provided for @code_must_be_6_digits.
  ///
  /// In en, this message translates to:
  /// **'Code must be 6 digits'**
  String get code_must_be_6_digits;

  /// No description provided for @enter_new_password.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enter_new_password;

  /// No description provided for @minimum_8_characters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get minimum_8_characters;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @session_ended.
  ///
  /// In en, this message translates to:
  /// **'Session ended'**
  String get session_ended;

  /// No description provided for @update_recovery_email.
  ///
  /// In en, this message translates to:
  /// **'Update Recovery Email'**
  String get update_recovery_email;

  /// No description provided for @new_email.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get new_email;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @verification_email_sent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent'**
  String get verification_email_sent;

  /// No description provided for @generate_emergency_codes.
  ///
  /// In en, this message translates to:
  /// **'Generate emergency codes'**
  String get generate_emergency_codes;

  /// No description provided for @copy_all.
  ///
  /// In en, this message translates to:
  /// **'Copy All'**
  String get copy_all;

  /// No description provided for @code_copied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get code_copied;

  /// No description provided for @all_codes_copied.
  ///
  /// In en, this message translates to:
  /// **'All codes copied'**
  String get all_codes_copied;

  /// No description provided for @logout_all_devices_confirm.
  ///
  /// In en, this message translates to:
  /// **'Logout All Devices?'**
  String get logout_all_devices_confirm;

  /// No description provided for @logout_all_devices_message.
  ///
  /// In en, this message translates to:
  /// **'This will end all active sessions on all devices.'**
  String get logout_all_devices_message;

  /// No description provided for @logout_all.
  ///
  /// In en, this message translates to:
  /// **'Logout All'**
  String get logout_all;

  /// No description provided for @delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get delete_account_confirm;

  /// No description provided for @delete_account_warning.
  ///
  /// In en, this message translates to:
  /// **'This action is PERMANENT and cannot be undone. All your data will be permanently deleted.'**
  String get delete_account_warning;

  /// No description provided for @what_will_be_deleted.
  ///
  /// In en, this message translates to:
  /// **'What will be deleted:'**
  String get what_will_be_deleted;

  /// No description provided for @profile_and_account_info.
  ///
  /// In en, this message translates to:
  /// **'• Your profile and account information'**
  String get profile_and_account_info;

  /// No description provided for @all_listings_and_posts.
  ///
  /// In en, this message translates to:
  /// **'• All your listings and posts'**
  String get all_listings_and_posts;

  /// No description provided for @messages_and_conversations.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages_and_conversations;

  /// No description provided for @saved_items_and_preferences.
  ///
  /// In en, this message translates to:
  /// **'• Saved items and preferences'**
  String get saved_items_and_preferences;

  /// No description provided for @enter_password_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to continue'**
  String get enter_password_to_continue;

  /// No description provided for @continue_val.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_val;

  /// No description provided for @please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get please_enter_password;

  /// No description provided for @enter_confirmation_code.
  ///
  /// In en, this message translates to:
  /// **'Enter Confirmation Code'**
  String get enter_confirmation_code;

  /// No description provided for @deletion_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation code to your phone. Enter it below to permanently delete your account.'**
  String get deletion_confirmation_message;

  /// No description provided for @confirmation_code.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Code'**
  String get confirmation_code;

  /// No description provided for @please_enter_6_digit_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit code'**
  String get please_enter_6_digit_code;

  /// No description provided for @account_deleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get account_deleted;

  /// No description provided for @deletion_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Deletion cancelled'**
  String get deletion_cancelled;

  /// No description provided for @failed_to_load_user_info.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user information'**
  String get failed_to_load_user_info;

  /// No description provided for @auth_login_to_view_saved.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your saved properties'**
  String get auth_login_to_view_saved;

  /// No description provided for @authLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get authLoginRequired;

  /// No description provided for @authLoginToViewSaved.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view your saved properties'**
  String get authLoginToViewSaved;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLogin;

  /// No description provided for @savedPropertiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Properties'**
  String get savedPropertiesTitle;

  /// No description provided for @loadingSavedProperties.
  ///
  /// In en, this message translates to:
  /// **'Loading saved properties...'**
  String get loadingSavedProperties;

  /// No description provided for @errorsFailedToLoadSaved.
  ///
  /// In en, this message translates to:
  /// **'Failed to load saved properties'**
  String get errorsFailedToLoadSaved;

  /// No description provided for @actionsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionsRetry;

  /// No description provided for @savedPropertiesNoSaved.
  ///
  /// In en, this message translates to:
  /// **'No Saved Properties'**
  String get savedPropertiesNoSaved;

  /// No description provided for @savedPropertiesStartSaving.
  ///
  /// In en, this message translates to:
  /// **'Start exploring and save properties you like'**
  String get savedPropertiesStartSaving;

  /// No description provided for @savedPropertiesBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse Properties'**
  String get savedPropertiesBrowse;

  /// No description provided for @resultsSavedProperties.
  ///
  /// In en, this message translates to:
  /// **'saved properties'**
  String get resultsSavedProperties;

  /// No description provided for @actionsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionsRefresh;

  /// No description provided for @resultsNoMoreProperties.
  ///
  /// In en, this message translates to:
  /// **'No more properties'**
  String get resultsNoMoreProperties;

  /// No description provided for @propertyCardFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get propertyCardFeatured;

  /// No description provided for @successPropertyUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Property removed from saved list'**
  String get successPropertyUnsaved;

  /// No description provided for @alertsUnsavePropertyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove property'**
  String get alertsUnsavePropertyFailed;

  /// No description provided for @propertyCardBed.
  ///
  /// In en, this message translates to:
  /// **'bed'**
  String get propertyCardBed;

  /// No description provided for @propertyCardBath.
  ///
  /// In en, this message translates to:
  /// **'bath'**
  String get propertyCardBath;

  /// No description provided for @savedPropertiesSavedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved on'**
  String get savedPropertiesSavedOn;

  /// No description provided for @propertyCardViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get propertyCardViewDetails;

  /// No description provided for @serviceDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Detail'**
  String get serviceDetailTitle;

  /// No description provided for @errorLoadingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Error loading favorite items'**
  String get errorLoadingFavorites;

  /// No description provided for @noFavoritesFound.
  ///
  /// In en, this message translates to:
  /// **'No favorite items found.'**
  String get noFavoritesFound;

  /// No description provided for @commentUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Comment updated successfully!'**
  String get commentUpdatedSuccess;

  /// No description provided for @errorUpdatingComment.
  ///
  /// In en, this message translates to:
  /// **'Error updating comment'**
  String get errorUpdatingComment;

  /// No description provided for @replyAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reply added successfully!'**
  String get replyAddedSuccess;

  /// No description provided for @errorAddingReply.
  ///
  /// In en, this message translates to:
  /// **'Error adding reply'**
  String get errorAddingReply;

  /// No description provided for @commentDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Comment deleted successfully!'**
  String get commentDeletedSuccess;

  /// No description provided for @errorDeletingComment.
  ///
  /// In en, this message translates to:
  /// **'Error deleting comment'**
  String get errorDeletingComment;

  /// No description provided for @serviceLikedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service liked successfully!'**
  String get serviceLikedSuccess;

  /// No description provided for @errorLikingService.
  ///
  /// In en, this message translates to:
  /// **'Error liking service'**
  String get errorLikingService;

  /// No description provided for @serviceDislikedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service disliked successfully!'**
  String get serviceDislikedSuccess;

  /// No description provided for @errorDislikingService.
  ///
  /// In en, this message translates to:
  /// **'Error disliking service'**
  String get errorDislikingService;

  /// No description provided for @writeYourReply.
  ///
  /// In en, this message translates to:
  /// **'Write your reply...'**
  String get writeYourReply;

  /// No description provided for @postReply.
  ///
  /// In en, this message translates to:
  /// **'Post Reply'**
  String get postReply;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @editComment.
  ///
  /// In en, this message translates to:
  /// **'Edit Comment'**
  String get editComment;

  /// No description provided for @editYourComment.
  ///
  /// In en, this message translates to:
  /// **'Edit your comment...'**
  String get editYourComment;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @propertyOwner.
  ///
  /// In en, this message translates to:
  /// **'Property Owner'**
  String get propertyOwner;

  /// No description provided for @errorLoadingServices.
  ///
  /// In en, this message translates to:
  /// **'Error loading services'**
  String get errorLoadingServices;

  /// No description provided for @noRecommendedServicesFound.
  ///
  /// In en, this message translates to:
  /// **'No recommended services found.'**
  String get noRecommendedServicesFound;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password must contain letters and numbers'**
  String get passwordRequirements;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameTooShort;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordHelp.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters, letters and numbers'**
  String get passwordHelp;

  /// No description provided for @usernameExists.
  ///
  /// In en, this message translates to:
  /// **'This username already exists'**
  String get usernameExists;

  /// No description provided for @phoneExists.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already registered'**
  String get phoneExists;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network connection error. Please check your connection'**
  String get networkError;

  /// No description provided for @contactSeller.
  ///
  /// In en, this message translates to:
  /// **'Contact Seller'**
  String get contactSeller;

  /// No description provided for @callToReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Call\" to reveal'**
  String get callToReveal;

  /// Camera option for image selection
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Gallery option for image selection
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Title for image source selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// Uploading state text
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// Error message when user hasn't accepted terms
  ///
  /// In en, this message translates to:
  /// **'You must accept the Terms and Conditions to continue'**
  String get acceptTermsRequired;

  /// Terms acceptance checkbox text prefix
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeToTerms;

  /// Terms and Conditions text
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// Zero tolerance statement for terms acceptance
  ///
  /// In en, this message translates to:
  /// **' and understand that there is zero tolerance for objectionable content or abusive users.'**
  String get zeroToleranceStatement;

  /// Button to view terms
  ///
  /// In en, this message translates to:
  /// **'View Terms and Conditions'**
  String get viewTerms;

  /// Title for report content dialog
  ///
  /// In en, this message translates to:
  /// **'Report Content'**
  String get reportContent;

  /// Prompt to select report reason
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for reporting:'**
  String get selectReportReason;

  /// Label for additional details field in report dialog
  ///
  /// In en, this message translates to:
  /// **'Additional details (optional)'**
  String get additionalDetails;

  /// Hint text for report details field
  ///
  /// In en, this message translates to:
  /// **'Provide any additional information...'**
  String get reportDetailsHint;

  /// Success message after submitting report
  ///
  /// In en, this message translates to:
  /// **'Thank you for your report. We will review it within 24 hours.'**
  String get reportSubmitted;

  /// Menu option to report a product
  ///
  /// In en, this message translates to:
  /// **'Report Product'**
  String get reportProduct;

  /// Menu option to report a service
  ///
  /// In en, this message translates to:
  /// **'Report Service'**
  String get reportService;

  /// Menu option to report a message
  ///
  /// In en, this message translates to:
  /// **'Report Message'**
  String get reportMessage;

  /// Menu option to report a user
  ///
  /// In en, this message translates to:
  /// **'Report User'**
  String get reportUser;

  /// Error message when reporting endpoint is not implemented
  ///
  /// In en, this message translates to:
  /// **'The reporting feature is not yet available. Please contact support or try again later.'**
  String get reportErrorNotImplemented;

  /// Message shown when user tries to report content they've already reported
  ///
  /// In en, this message translates to:
  /// **'You have already reported this content. We are reviewing your previous report.'**
  String get reportAlreadySubmitted;

  /// Generic error message when report submission fails
  ///
  /// In en, this message translates to:
  /// **'Failed to submit report. Please try again.'**
  String get reportFailedGeneric;

  /// Error message when network error occurs during report submission
  ///
  /// In en, this message translates to:
  /// **'Network error occurred. Please check your connection and try again.'**
  String get reportFailedNetwork;

  /// Title for become agent page
  ///
  /// In en, this message translates to:
  /// **'Join as a Real Estate Agent'**
  String get becomeAgentTitle;

  /// Subtitle for become agent page
  ///
  /// In en, this message translates to:
  /// **'List properties and help clients find their dream homes'**
  String get becomeAgentSubtitle;

  /// Label for agent benefits section
  ///
  /// In en, this message translates to:
  /// **'Benefits:'**
  String get agentBenefits;

  /// Agent benefit - verified badge
  ///
  /// In en, this message translates to:
  /// **'Verified agent badge'**
  String get agentBenefitVerified;

  /// Agent benefit - analytics
  ///
  /// In en, this message translates to:
  /// **'Access to analytics and insights'**
  String get agentBenefitAnalytics;

  /// Agent benefit - client contact
  ///
  /// In en, this message translates to:
  /// **'Direct contact with potential clients'**
  String get agentBenefitClients;

  /// Agent benefit - reputation
  ///
  /// In en, this message translates to:
  /// **'Build your professional reputation'**
  String get agentBenefitReputation;

  /// Title for agent application form
  ///
  /// In en, this message translates to:
  /// **'Application Form'**
  String get agentApplicationForm;

  /// Label for agency name field
  ///
  /// In en, this message translates to:
  /// **'Agency Name'**
  String get agentAgencyName;

  /// Hint for agency name field
  ///
  /// In en, this message translates to:
  /// **'Enter your real estate agency name'**
  String get agentAgencyNameHint;

  /// Error message for required agency name
  ///
  /// In en, this message translates to:
  /// **'Agency name is required'**
  String get agentAgencyNameRequired;

  /// Label for license number field
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get agentLicenceNumber;

  /// Hint for license number field
  ///
  /// In en, this message translates to:
  /// **'Enter your real estate license number'**
  String get agentLicenceNumberHint;

  /// Error message for required license number
  ///
  /// In en, this message translates to:
  /// **'License number is required'**
  String get agentLicenceNumberRequired;

  /// Label for years of experience field
  ///
  /// In en, this message translates to:
  /// **'Years of Experience'**
  String get agentYearsExperience;

  /// Hint for years of experience field
  ///
  /// In en, this message translates to:
  /// **'Enter number of years'**
  String get agentYearsExperienceHint;

  /// Error message for required years of experience
  ///
  /// In en, this message translates to:
  /// **'Years of experience is required'**
  String get agentYearsExperienceRequired;

  /// Error message for invalid years of experience
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get agentYearsExperienceInvalid;

  /// Label for specialization field
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get agentSpecialization;

  /// Note about application review process
  ///
  /// In en, this message translates to:
  /// **'Your application will be reviewed by our team. You will be notified once your application is approved.'**
  String get agentApplicationNote;

  /// Button text to submit agent application
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get agentSubmitApplication;

  /// Success message after submitting agent application
  ///
  /// In en, this message translates to:
  /// **'Application submitted successfully! We will review it soon.'**
  String get agentApplicationSubmitted;

  /// Title for application status dialog
  ///
  /// In en, this message translates to:
  /// **'Application Status'**
  String get agentApplicationStatus;

  /// Subtitle for verified agent menu item
  ///
  /// In en, this message translates to:
  /// **'View your agent profile'**
  String get agentViewProfile;

  /// Message when agent dashboard is not yet implemented
  ///
  /// In en, this message translates to:
  /// **'Agent dashboard coming soon!'**
  String get agentDashboardComingSoon;

  /// Section title for basic information in property creation
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get property_create_basic_information;

  /// Label for property title field
  ///
  /// In en, this message translates to:
  /// **'Property Title *'**
  String get property_create_property_title;

  /// Hint text for property title field
  ///
  /// In en, this message translates to:
  /// **'e.g., Modern 3BR Apartment in City Center'**
  String get property_create_property_title_hint;

  /// Validation error for property title
  ///
  /// In en, this message translates to:
  /// **'Please enter property title'**
  String get property_create_property_title_required;

  /// Label for description field
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get property_create_description;

  /// Hint text for description field
  ///
  /// In en, this message translates to:
  /// **'Describe your property in detail...'**
  String get property_create_description_hint;

  /// Validation error for description
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get property_create_description_required;

  /// Label for property type field
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get property_create_property_type;

  /// Label for required property type field
  ///
  /// In en, this message translates to:
  /// **'Property Type *'**
  String get property_create_property_type_required;

  /// Label for required listing type field
  ///
  /// In en, this message translates to:
  /// **'Listing Type *'**
  String get property_create_listing_type_required;

  /// Section title for pricing
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get property_create_pricing;

  /// Label for price field
  ///
  /// In en, this message translates to:
  /// **'Price *'**
  String get property_create_price;

  /// Hint text for price field
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get property_create_price_hint;

  /// Validation error for price
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get property_create_price_required;

  /// Label for currency field
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get property_create_currency;

  /// Section title for property details
  ///
  /// In en, this message translates to:
  /// **'Property Details'**
  String get property_create_property_details;

  /// Label for square meters field
  ///
  /// In en, this message translates to:
  /// **'Sq. Meters *'**
  String get property_create_square_meters;

  /// Label for bedrooms field
  ///
  /// In en, this message translates to:
  /// **'Bedrooms *'**
  String get property_create_bedrooms;

  /// Label for bathrooms field
  ///
  /// In en, this message translates to:
  /// **'Bathrooms *'**
  String get property_create_bathrooms;

  /// Label for floor field
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get property_create_floor;

  /// Label for total floors field
  ///
  /// In en, this message translates to:
  /// **'Total Floors'**
  String get property_create_total_floors;

  /// Label for parking spaces field
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get property_create_parking;

  /// Label for year built field
  ///
  /// In en, this message translates to:
  /// **'Year Built'**
  String get property_create_year_built;

  /// Section title for location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get property_create_location;

  /// Label for address field
  ///
  /// In en, this message translates to:
  /// **'Address *'**
  String get property_create_address;

  /// Hint text for address field
  ///
  /// In en, this message translates to:
  /// **'Enter property address'**
  String get property_create_address_hint;

  /// Validation error for address
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get property_create_address_required;

  /// Text shown when location is detected
  ///
  /// In en, this message translates to:
  /// **'Location Detected'**
  String get property_create_location_detected;

  /// Button text to get current location
  ///
  /// In en, this message translates to:
  /// **'Get Current Location'**
  String get property_create_get_location;

  /// Section title for features
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get property_create_features;

  /// Feature name: Balcony
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get property_create_feature_balcony;

  /// Feature name: Garage
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get property_create_feature_garage;

  /// Feature name: Garden
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get property_create_feature_garden;

  /// Feature name: Pool
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get property_create_feature_pool;

  /// Feature name: Elevator
  ///
  /// In en, this message translates to:
  /// **'Elevator'**
  String get property_create_feature_elevator;

  /// Feature name: Furnished
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get property_create_feature_furnished;

  /// Section title for property images
  ///
  /// In en, this message translates to:
  /// **'Property Images'**
  String get property_create_images;

  /// Text shown in empty image picker
  ///
  /// In en, this message translates to:
  /// **'Tap to add images'**
  String get property_create_tap_to_add_images;

  /// Text shown below image picker
  ///
  /// In en, this message translates to:
  /// **'At least 1 image required'**
  String get property_create_at_least_one_image;

  /// Button text to add more images
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get property_create_add_more;

  /// Generic required field validation message
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get property_create_required;

  /// Error message when location is not available
  ///
  /// In en, this message translates to:
  /// **'Please enable location services to create a property'**
  String get property_create_location_required;

  /// Error message when no images are selected
  ///
  /// In en, this message translates to:
  /// **'At least one property image is required'**
  String get property_create_image_required;

  /// Title for email verification screen
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerification;

  /// Instruction text for email input
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterYourEmailAddress;

  /// Placeholder text for email input field
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get enterEmailAddress;

  /// Title for password reset screen
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetYourPassword;

  /// Description text for password reset
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a verification code to reset your password.'**
  String get resetPasswordDescription;

  /// Button text to send verification code
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// Link text to go back to login screen
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// Title for reset password dialog and button
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Instruction for entering OTP
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to {email}'**
  String enterVerificationCodeSentTo(String email);

  /// Validation error for OTP length
  ///
  /// In en, this message translates to:
  /// **'Code must be 6 digits'**
  String get codeMustBe6Digits;

  /// Validation error for empty new password
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// Validation error for password minimum length
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get minimum8Characters;

  /// Loading text for sending code
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// Loading text for verifying code
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// Tooltip text for new message
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get new_message;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @please_log_in.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view messages'**
  String get please_log_in;

  /// No description provided for @delete_chat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get delete_chat;

  /// Delete chat confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the chat with {name}? This action cannot be undone.'**
  String delete_chat_confirm(String name);

  /// Chat deleted success message
  ///
  /// In en, this message translates to:
  /// **'Chat with {name} deleted'**
  String chat_deleted(String name);

  /// No description provided for @delete_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete chat'**
  String get delete_failed;

  /// No description provided for @no_conversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get no_conversations;

  /// No description provided for @start_conversation_hint.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation by tapping the + button'**
  String get start_conversation_hint;

  /// No description provided for @start_conversation.
  ///
  /// In en, this message translates to:
  /// **'Start a Conversation'**
  String get start_conversation;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @no_messages_yet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get no_messages_yet;

  /// No description provided for @unblock_user.
  ///
  /// In en, this message translates to:
  /// **'Unblock User'**
  String get unblock_user;

  /// No description provided for @block_user.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get block_user;

  /// No description provided for @no_blocked_users.
  ///
  /// In en, this message translates to:
  /// **'No blocked users'**
  String get no_blocked_users;

  /// No description provided for @blocked_users_hint.
  ///
  /// In en, this message translates to:
  /// **'Users you block will appear here'**
  String get blocked_users_hint;

  /// Unblock user confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unblock {username}? You will be able to receive messages from them again.'**
  String unblock_user_confirm(String username);

  /// User unblocked success message
  ///
  /// In en, this message translates to:
  /// **'{username} has been unblocked'**
  String user_unblocked(String username);

  /// User blocked success message
  ///
  /// In en, this message translates to:
  /// **'{username} has been blocked'**
  String user_blocked(String username);

  /// No description provided for @failed_to_unblock.
  ///
  /// In en, this message translates to:
  /// **'Failed to unblock user'**
  String get failed_to_unblock;

  /// No description provided for @failed_to_block.
  ///
  /// In en, this message translates to:
  /// **'Failed to block user'**
  String get failed_to_block;

  /// No description provided for @chat_info.
  ///
  /// In en, this message translates to:
  /// **'Chat Info'**
  String get chat_info;

  /// No description provided for @delete_message.
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get delete_message;

  /// No description provided for @delete_message_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get delete_message_confirm;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'typing...'**
  String get typing;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get online;

  /// Number of participants in group chat
  ///
  /// In en, this message translates to:
  /// **'{count} participants'**
  String participants(int count);

  /// No description provided for @you_are_blocked.
  ///
  /// In en, this message translates to:
  /// **'You are blocked'**
  String get you_are_blocked;

  /// Message when user is blocked by another user
  ///
  /// In en, this message translates to:
  /// **'{username} has blocked you. You cannot send messages.'**
  String user_blocked_you(String username);

  /// Message when current user has blocked another user
  ///
  /// In en, this message translates to:
  /// **'You have blocked {username}'**
  String you_blocked_user(String username);

  /// No description provided for @cannot_send_messages_blocked.
  ///
  /// In en, this message translates to:
  /// **'You cannot send messages. You have been blocked.'**
  String get cannot_send_messages_blocked;

  /// No description provided for @this_message_was_deleted.
  ///
  /// In en, this message translates to:
  /// **'This message was deleted'**
  String get this_message_was_deleted;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @add_reaction.
  ///
  /// In en, this message translates to:
  /// **'Add Reaction'**
  String get add_reaction;

  /// No description provided for @editing_message.
  ///
  /// In en, this message translates to:
  /// **'Editing message'**
  String get editing_message;

  /// Reply header text
  ///
  /// In en, this message translates to:
  /// **'Replying to {username}'**
  String replying_to(String username);

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @emoji.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get emoji;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'📷 Photo'**
  String get photo;

  /// No description provided for @voice_message.
  ///
  /// In en, this message translates to:
  /// **'🎤 Voice message'**
  String get voice_message;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @loading_users.
  ///
  /// In en, this message translates to:
  /// **'Loading users...'**
  String get loading_users;

  /// Search error message
  ///
  /// In en, this message translates to:
  /// **'Search failed: {error}'**
  String search_failed(String error);

  /// No description provided for @invalid_user_data.
  ///
  /// In en, this message translates to:
  /// **'Invalid user data'**
  String get invalid_user_data;

  /// Failed to start chat error
  ///
  /// In en, this message translates to:
  /// **'Failed to start chat: {error}'**
  String failed_to_start_chat(String error);

  /// No description provided for @audio_file_not_available.
  ///
  /// In en, this message translates to:
  /// **'Audio file not available'**
  String get audio_file_not_available;

  /// Failed to play audio error
  ///
  /// In en, this message translates to:
  /// **'Failed to play audio: {error}'**
  String failed_to_play_audio(String error);

  /// No description provided for @image_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get image_unavailable;

  /// No description provided for @image_too_large.
  ///
  /// In en, this message translates to:
  /// **'❌ Image is too large. Maximum size is 10MB'**
  String get image_too_large;

  /// No description provided for @image_file_not_found.
  ///
  /// In en, this message translates to:
  /// **'❌ Image file not found'**
  String get image_file_not_found;

  /// No description provided for @uploading_image.
  ///
  /// In en, this message translates to:
  /// **'Uploading image...'**
  String get uploading_image;

  /// No description provided for @image_sent.
  ///
  /// In en, this message translates to:
  /// **'✅ Image sent!'**
  String get image_sent;

  /// No description provided for @failed_to_send_image.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to send image'**
  String get failed_to_send_image;

  /// No description provided for @uploading_voice_message.
  ///
  /// In en, this message translates to:
  /// **'Uploading voice message...'**
  String get uploading_voice_message;

  /// No description provided for @voice_message_sent.
  ///
  /// In en, this message translates to:
  /// **'✅ Voice message sent!'**
  String get voice_message_sent;

  /// No description provided for @failed_to_send_voice_message.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to send voice message'**
  String get failed_to_send_voice_message;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'🎙️ Recording...'**
  String get recording;

  /// No description provided for @microphone_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get microphone_permission_denied;

  /// No description provided for @starting_chat.
  ///
  /// In en, this message translates to:
  /// **'Starting chat...'**
  String get starting_chat;

  /// No description provided for @refresh_users.
  ///
  /// In en, this message translates to:
  /// **'Refresh users'**
  String get refresh_users;

  /// No description provided for @search_by_username_or_phone.
  ///
  /// In en, this message translates to:
  /// **'Search by username or phone number'**
  String get search_by_username_or_phone;

  /// No description provided for @no_users_found.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get no_users_found;

  /// No description provided for @try_different_search_term.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get try_different_search_term;

  /// No description provided for @no_users_available.
  ///
  /// In en, this message translates to:
  /// **'No users available'**
  String get no_users_available;

  /// No description provided for @chat_exists.
  ///
  /// In en, this message translates to:
  /// **'Chat exists'**
  String get chat_exists;

  /// Block user confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block {username}? You will not receive messages from them and they will be removed from your chat list.'**
  String block_user_confirm(String username);

  /// Chat room label with name
  ///
  /// In en, this message translates to:
  /// **'Chat Room: {name}'**
  String chat_room_label(String name);

  /// ID label with value
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String id_label(int id);

  /// No description provided for @participants_label.
  ///
  /// In en, this message translates to:
  /// **'Participants:'**
  String get participants_label;

  /// No description provided for @type_a_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_a_message;

  /// No description provided for @edit_message_hint.
  ///
  /// In en, this message translates to:
  /// **'Edit message...'**
  String get edit_message_hint;

  /// Error label with error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error_label(String error);

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Comments section title with count
  ///
  /// In en, this message translates to:
  /// **'Comments ({count})'**
  String comments_title(int count);

  /// Reply button text
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply_button;

  /// Replies count text
  ///
  /// In en, this message translates to:
  /// **'{count} replies'**
  String replies_count(int count);

  /// You label for current user
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you_label;

  /// Delete reply dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Reply'**
  String get delete_reply_title;

  /// Delete comment dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Comment'**
  String get delete_comment_title;

  /// Unknown date text
  ///
  /// In en, this message translates to:
  /// **'Unknown Date'**
  String get unknown_date;

  /// Hint text for sending comment
  ///
  /// In en, this message translates to:
  /// **'Press Enter to send'**
  String get press_enter_to_send;

  /// Error message when comment creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to add comment'**
  String get comment_add_error;

  /// Service provider label
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get service_provider;

  /// Opening chat message
  ///
  /// In en, this message translates to:
  /// **'Opening chat...'**
  String get opening_chat;

  /// Failed to refresh error message
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh'**
  String get failed_to_refresh;

  /// Error message when trying to chat with yourself
  ///
  /// In en, this message translates to:
  /// **'You cannot chat with yourself'**
  String get cannot_chat_with_yourself;

  /// Opening chat message with username
  ///
  /// In en, this message translates to:
  /// **'Opening chat with {username}...'**
  String opening_chat_with(String username);

  /// Loading message for chat
  ///
  /// In en, this message translates to:
  /// **'This will only take a moment'**
  String get this_will_only_take_a_moment;

  /// Error message when chat fails to start
  ///
  /// In en, this message translates to:
  /// **'Unable to start chat. Please try again.'**
  String get unable_to_start_chat;

  /// Listings count label on profile
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get profile_listings;

  /// Followers count label on profile
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profile_followers;

  /// Following count label on profile
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profile_following;

  /// Empty state title for products
  ///
  /// In en, this message translates to:
  /// **'No products'**
  String get profile_no_products;

  /// Empty state title for services
  ///
  /// In en, this message translates to:
  /// **'No services'**
  String get profile_no_services;

  /// Empty state title for properties
  ///
  /// In en, this message translates to:
  /// **'No properties'**
  String get profile_no_properties;

  /// Empty state subtitle for products
  ///
  /// In en, this message translates to:
  /// **'This user hasn\'t posted any products yet'**
  String get profile_user_no_products;

  /// Empty state subtitle for services
  ///
  /// In en, this message translates to:
  /// **'This user hasn\'t posted any services yet'**
  String get profile_user_no_services;

  /// Empty state subtitle for properties
  ///
  /// In en, this message translates to:
  /// **'This user hasn\'t posted any properties yet'**
  String get profile_user_no_properties;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get profile_error_occurred;

  /// Error loading products message
  ///
  /// In en, this message translates to:
  /// **'Error loading products'**
  String get profile_error_loading_products;

  /// Error loading services message
  ///
  /// In en, this message translates to:
  /// **'Error loading services'**
  String get profile_error_loading_services;

  /// Empty state for followers list
  ///
  /// In en, this message translates to:
  /// **'No followers yet'**
  String get profile_no_followers_yet;

  /// Empty state for following list
  ///
  /// In en, this message translates to:
  /// **'Not following anyone yet'**
  String get profile_no_following_yet;

  /// Follow button text
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get profile_follow;

  /// Following button text (already following)
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profile_following_btn;

  /// Message button text
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get profile_message;

  /// Member since label
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get profile_member_since;

  /// Profile loading error message
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get profile_loading_error;

  /// Retry button for profile
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get profile_retry;

  /// Share profile option
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get profile_share;

  /// Copy profile link option
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get profile_copy_link;

  /// Report user option
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get profile_report;

  /// Message shown when a link is copied
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get linkCopied;

  /// Share text prefix for profile
  ///
  /// In en, this message translates to:
  /// **'Check out'**
  String get checkOutProfile;

  /// Share text suffix for profile
  ///
  /// In en, this message translates to:
  /// **'on TezSell'**
  String get onTezsell;
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
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
