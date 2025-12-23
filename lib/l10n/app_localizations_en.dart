// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get loginToYourAccount => 'Login to continue';

  @override
  String get or => 'OR';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get chooseLanguage => 'Choose Your Language';

  @override
  String get selectPreferredLanguage =>
      'Select your preferred language for the app';

  @override
  String get continueButton => 'Continue';

  @override
  String get sellAndBuyProducts =>
      'Sell and buy any of your products only with us';

  @override
  String get usedProductsMarket => 'Used products or second-hand market';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account';

  @override
  String get login => 'Login';

  @override
  String get loginToAccount => 'Login to Account';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get registerNow => 'Register Now';

  @override
  String get loading => 'Loading...';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get unexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get forgotPasswordComingSoon => 'Forgot password feature coming soon';

  @override
  String get selectedCountryLabel => 'Selected:';

  @override
  String get fullPhoneLabel => 'Full:';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search';

  @override
  String get notifications => 'Notifications';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Please select your region';

  @override
  String get searchHint => 'Search district or city';

  @override
  String get apiError => 'A problem occurred while calling the API';

  @override
  String get ok => 'OK';

  @override
  String get emptyList => 'Empty List';

  @override
  String get dataLoadingError => 'There is an error while loading data';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String confirmRegionSelection(Object regionName) {
    return 'Do you want to select $regionName region?';
  }

  @override
  String get selectDistrictOrCity => 'Please select your district or city';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return 'Do you want to select $regionName region - $districtName?';
  }

  @override
  String get noResultsFound => 'No results found.';

  @override
  String errorWithCode(String errorCode) {
    return 'Error: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'Failed to load data. Error: $error';
  }

  @override
  String get phoneVerification => 'Phone Number Verification';

  @override
  String get enterPhonePrompt => 'Please enter your phone number';

  @override
  String get enterPhoneNumberHint => 'Enter phone number';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Selected: $countryName ($countryCode)';
  }

  @override
  String fullNumber(String phoneNumber) {
    return 'Full number: $phoneNumber';
  }

  @override
  String get sendCode => 'Send Code';

  @override
  String get enterVerificationCode => 'Enter verification code';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Resend Code';

  @override
  String expires(String time) {
    return 'Expires: $time';
  }

  @override
  String get verifyAndContinue => 'Verify and Continue';

  @override
  String get invalidVerificationCode => 'Invalid verification code';

  @override
  String get verificationCodeSent => 'Verification code sent successfully';

  @override
  String get failedToSendCode => 'Failed to send verification code';

  @override
  String get verificationCodeResent => 'Verification code resent successfully';

  @override
  String get failedToResendCode => 'Failed to resend verification code';

  @override
  String get passwordVerification => 'Password Verification';

  @override
  String get completeRegistrationPrompt =>
      'Enter username and password to complete registration';

  @override
  String get username => 'Username';

  @override
  String get username_required => 'Username is required';

  @override
  String get username_min_length => 'Username must be at least 2 characters';

  @override
  String get usernameHint => 'Username123';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get profileImage => 'Profile Image';

  @override
  String get imageInstructions =>
      'Images will appear here, please press profile image';

  @override
  String get finish => 'Finish';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get registrationError => 'Registration error';

  @override
  String get about => 'About Us';

  @override
  String get chat => 'Chat';

  @override
  String get realEstate => 'Real Estate';

  @override
  String get language => 'ENG';

  @override
  String get languageEn => 'English';

  @override
  String get languageRu => 'Russian';

  @override
  String get languageUz => 'Uzbek';

  @override
  String get serviceLiked => 'Service liked';

  @override
  String get support => 'Support';

  @override
  String get service => 'Business Services';

  @override
  String get aboutContent =>
      'TezSell is a fast and easy marketplace for buying and selling new and used products. Our mission is to create the most convenient and efficient platform for every user, ensuring smooth transactions and a user-friendly experience. Whether you\'re looking to sell or buy, TezSell makes it easy to connect and complete transactions in just a few steps.We prioritize the security and privacy of our users. All transactions are carefully monitored to ensure safety and compliance, providing peace of mind to both buyers and sellers. Our simple and intuitive interface allows users to quickly list products and find what they need. We also facilitate real-time communication through Telegram, making the buying and selling process even smoother.';

  @override
  String get errorMessage => 'Error occurred, please check the server';

  @override
  String get searchLocation => 'Location';

  @override
  String get searchCategory => 'Categories';

  @override
  String get searchProductPlaceholder => 'Search for products';

  @override
  String get searchServicePlaceholder => 'Search for services';

  @override
  String get searchText => 'Search';

  @override
  String get selectedCategory => 'Selected Category: ';

  @override
  String get selectedLocation => 'Selected Location: ';

  @override
  String get productError => 'No products available';

  @override
  String get serviceError => 'No services available';

  @override
  String get locationHeader => 'Select a location';

  @override
  String get locationPlaceholder => 'Search region here';

  @override
  String get categoryHeader => 'Select a Category';

  @override
  String get categoryPlaceholder => 'Search Categories';

  @override
  String get categoryError => 'No categories available';

  @override
  String get paginationFirst => 'First';

  @override
  String get paginationPrevious => 'Previous';

  @override
  String get pageInfo => 'Page of';

  @override
  String get pageNext => 'Next';

  @override
  String get pageLast => 'Last';

  @override
  String get loadingMessageProduct => 'Loading products ...';

  @override
  String get loadingMessageError => 'Error while loading';

  @override
  String get likeProductError => 'Error occurred while liking product';

  @override
  String get dislikeProductError => 'Error occurred while disliking product';

  @override
  String get loadingMessageLocation => 'Loading location ...';

  @override
  String get loadingLocationError => 'Error while loading location';

  @override
  String get loadingMessageCategory => 'Loading categories ...';

  @override
  String get loadingCategoryError => 'Error loading categories:';

  @override
  String get profileUpdateSuccessMessage => 'Profile updated successfully';

  @override
  String get profileUpdateFailMessage => 'Failed to update profile';

  @override
  String get seeMoreBtn => 'See More';

  @override
  String get profilePageTitle => 'Profile Page';

  @override
  String get editProfileModalTitle => 'Edit Profile';

  @override
  String get usernameLabel => 'Username';

  @override
  String get locationLabel => 'Current Location';

  @override
  String get profileImageLabel => 'Profile Image';

  @override
  String get chooseFileLabel => 'Choose a file';

  @override
  String get uploadBtnLabel => 'Update';

  @override
  String get uploadingBtnLabel => 'Updating ...';

  @override
  String get cancelBtnLabel => 'Cancel';

  @override
  String get productsTitle => 'Products';

  @override
  String get servicesTitle => 'Services';

  @override
  String get myProductsTitle => 'My Products';

  @override
  String get myServicesTitle => 'My Services';

  @override
  String get favoriteProductsTitle => 'Favorite Products';

  @override
  String get favoriteServicesTitle => 'Favorite Services';

  @override
  String get noFavorites => 'No Favorites';

  @override
  String get addNewProductBtn => 'Add New Product';

  @override
  String get addNew => 'New';

  @override
  String get addNewServiceBtn => 'Add New Service';

  @override
  String get downloadMobileApp => 'Download the mobile app';

  @override
  String get registerPhoneNumberSuccess =>
      'Phone number verified! You can proceed to the next step.';

  @override
  String get regionSelectedMessage => 'Region selected:';

  @override
  String get districtSelectMessage => 'District selected:';

  @override
  String get phoneNumberEmptyMessage =>
      'Please verify your phone number before proceeding';

  @override
  String get regionEmptyMessage => 'Please select the region first';

  @override
  String get districtEmptyMessage => ' Please select the district';

  @override
  String get usernamePasswordEmptyMessage =>
      'Please input username and password';

  @override
  String get registerTitle => 'Register';

  @override
  String get previousButton => 'Previous';

  @override
  String get nextButton => 'Next';

  @override
  String get completeButton => 'Complete';

  @override
  String stepIndicator(int currentStep) {
    return 'Step $currentStep out of 4';
  }

  @override
  String get districtSelectTitle => 'District List';

  @override
  String get districtSelectParagraph => 'Select a district:';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get sendAgain => 'Send again';

  @override
  String get verify => 'Verify';

  @override
  String get failedToSendOtp => 'Failed to send OTP. Server returned false.';

  @override
  String get errorSendingOtp => 'An error occurred while sending OTP.';

  @override
  String get invalidPhoneNumber => 'Please enter a valid phone number.';

  @override
  String get verificationSuccess => 'Successfully verified';

  @override
  String get verificationError => 'An error occurred. Please try again later.';

  @override
  String get regionsList => 'Regions List';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get welcomeMessage =>
      'Welcome to Tezsell, log in with your phone number';

  @override
  String get noAccount => 'No account yet? Register here';

  @override
  String get successLogin => 'Successfully logged';

  @override
  String get myProfile => 'My Profile';

  @override
  String get logout => 'logout';

  @override
  String get newProductTitle => 'Title';

  @override
  String get newProductDescription => 'Description';

  @override
  String get newProductPrice => 'Price';

  @override
  String get newProductCondition => 'Condition';

  @override
  String get newProductCategory => 'Category';

  @override
  String get newProductImages => 'Images';

  @override
  String get addNewService => 'Add New Service';

  @override
  String get creating => 'Creating...';

  @override
  String get serviceName => 'Service Name ';

  @override
  String get serviceNamePlaceholder => 'Enter service title';

  @override
  String get serviceDescription => 'Service Description ';

  @override
  String get serviceDescriptionPlaceholder => 'Enter service description';

  @override
  String get serviceCategory => 'Service Category ';

  @override
  String get selectCategory => 'Select category';

  @override
  String get loadingCategories => 'Loading...';

  @override
  String get errorLoadingCategories => 'Error loading categories';

  @override
  String get serviceImages => 'Service Images';

  @override
  String get imageUploadHelper => 'Click the + icon to add images (maximum 10)';

  @override
  String get maxImagesError => 'You can upload a maximum of 10 images';

  @override
  String get categoryNotFound => 'Category not found';

  @override
  String get productCreatedSuccess => 'Product created successfully';

  @override
  String get productLikeSuccess => 'Product liked successfully';

  @override
  String get productDislikeSuccess => 'Product disliked successfully';

  @override
  String get errorCreatingService => 'Error while creating service';

  @override
  String get errorCreatingProduct => 'Error while creating product';

  @override
  String get unknownError =>
      'An unknown error occurred while creating the service';

  @override
  String get submit => 'Submit';

  @override
  String get selectCategoryAction => 'Select Category';

  @override
  String get selectCondition => 'Select Condition';

  @override
  String get sum => 'Sum';

  @override
  String get noComments => ' No comments yet. Be the first to comment!';

  @override
  String get commentLikeSuccess => 'Comment liked successfully';

  @override
  String get commentLikeError => 'Error while liking comment';

  @override
  String get unknownErrorMessage => 'An unknown error occurred';

  @override
  String get commentDislikeSuccess => 'Comment disliked successfully';

  @override
  String get commentDislikeError => 'Error while disliking comment';

  @override
  String get replyInfo => 'Please enter a reply first';

  @override
  String get replySuccessMessage => 'Reply added successfully';

  @override
  String get replyErrorMessage =>
      'Error occurred during the creation of the reply';

  @override
  String get commentUpdateSuccess => 'Comment updated successfully';

  @override
  String get commentUpdateError => 'Error updating comment item';

  @override
  String get deleteConfirmationMessage =>
      'Are you sure you want to delete this comment?';

  @override
  String get commentDeleteSuccess => 'Comment deleted successfully';

  @override
  String get commentDeleteError => 'Error deleting comment';

  @override
  String get editLabel => 'Edit';

  @override
  String get deleteLabel => 'Delete';

  @override
  String get saveLabel => 'Save';

  @override
  String get replyLabel => 'Reply';

  @override
  String get replyTitle => 'replies';

  @override
  String get replyPlaceholder => 'Write a reply...';

  @override
  String get chatLoginMessage => 'You must be logged in to start a chat';

  @override
  String get chatYourselfMessage => 'You can\'t chat with yourself.';

  @override
  String get chatRoomMessage => 'Chat room created!';

  @override
  String get chatRoomError => 'Failed to create chat!';

  @override
  String get chatCreationError => 'Chat creation failed!';

  @override
  String get productsTotal => 'Products total';

  @override
  String get perPage => 'items';

  @override
  String get clearAllFilters => 'Clear all filters';

  @override
  String get clickToUpload => 'Click to upload';

  @override
  String get productInStock => 'In Stock';

  @override
  String get productOutStock => 'Out of stock';

  @override
  String get productBack => 'Back to products';

  @override
  String get messageSeller => 'Chat';

  @override
  String get recommendedProducts => 'Recommended Products';

  @override
  String get deleteConfirmationProduct =>
      'Are you sure you want to delete this product?';

  @override
  String get productDeleteSuccess => 'Product deleted successfully';

  @override
  String get productDeleteError => 'Error deleting product';

  @override
  String get newCondition => 'New';

  @override
  String get used => 'Used';

  @override
  String get imageValidType =>
      'Some files were not added. Please use JPG, PNG, GIF or WebP files under 5MB.';

  @override
  String get imageConfirmMessage =>
      'Are you sure you want to remove this image?';

  @override
  String get titleRequiredMessage => 'Title is required';

  @override
  String get descRequiredMessage => 'Description is required';

  @override
  String get priceRequiredMessage => 'Price is required';

  @override
  String get conditionRequiredMessage => 'Condition is required';

  @override
  String get pleaseFillAllRequired => 'Please fill the required fields';

  @override
  String get oneImageConfirmMessage => 'At least one product image is required';

  @override
  String get categoryRequiredMessage => 'Category is required';

  @override
  String get locationInfoError => 'User location information is missing';

  @override
  String get editProductTitle => 'Edit Product';

  @override
  String get imageUploadRequirements =>
      'At least one image is required. You can upload up to 10 images (JPG, PNG, GIF, WebP under 5MB each).';

  @override
  String get productUpdatedSuccess => 'Product updated successfully';

  @override
  String get productUpdateFailed => 'Product update failed';

  @override
  String get errorUpdatingProduct =>
      'Error occurred while updating the product';

  @override
  String get serviceBack => 'Back to services';

  @override
  String get likeLabel => 'Like';

  @override
  String get commentsLabel => 'Comments';

  @override
  String get writeComment => 'Write a comment ...';

  @override
  String get postingLabel => 'Posting...';

  @override
  String get commentCreated => 'Comment created';

  @override
  String get postCommentLabel => 'Post Comment';

  @override
  String get loginPrompt => 'Please log in to view and post comments.';

  @override
  String get recommendedServices => 'Recommended Services';

  @override
  String get commentsVisibilityNotice =>
      'Comments are only visible to logged-in users.';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get serviceUpdateSuccess => 'Service updated successfully';

  @override
  String get serviceUpdateError => 'Error updating service item';

  @override
  String get editServiceModalTitle => 'Edit Service';

  @override
  String get enterPhoneNumberWithoutCode => 'Enter phone number without code';

  @override
  String get heroTitle => 'TezSell';

  @override
  String get heroSubtitle => 'Your Fast & Easy Marketplace for Uzbekistan';

  @override
  String get startSelling => 'Start Selling';

  @override
  String get browseProducts => 'Browse Products';

  @override
  String get featuresTitle => 'Why Choose TezSell?';

  @override
  String get listingTitle => 'Simple Product Listing';

  @override
  String get listingDescription =>
      'List your items with just a few clicks. Add photos, set your price, and connect with buyers instantly.';

  @override
  String get locationTitle => 'Location-Based Browsing';

  @override
  String get locationDescription =>
      'Find deals near you. Our location-based system helps you discover items in your neighborhood.';

  @override
  String get categoryTitle => 'Category Filtering';

  @override
  String get categoryDescription =>
      'Easily navigate through different categories to find exactly what you\'re looking for.';

  @override
  String get inspirationTitle => 'Inspired by Korea\'s Carrot Market';

  @override
  String get inspirationDescription1 =>
      'We\'ve built TezSell with inspiration from Korea\'s successful Carrot Market (당근마켓), but tailored it specifically to meet the unique needs of Uzbekistan\'s local communities.';

  @override
  String get inspirationDescription2 =>
      'Our mission is to create a trustworthy platform where neighbors can buy, sell, and connect with each other easily.';

  @override
  String get comingSoonTitle => 'Coming Soon to TezSell';

  @override
  String get inAppChat => 'In-App Chat';

  @override
  String get secureTransactions => 'Secure Transactions';

  @override
  String get realEstateListings => 'Real Estate Listings';

  @override
  String get stayUpdated => 'Stay Updated';

  @override
  String get comingSoonBadge => 'Coming Soon';

  @override
  String get ctaTitle => 'Join the TezSell Community Today!';

  @override
  String get ctaDescription =>
      'Be part of building a better marketplace experience for Uzbekistan. Share your feedback and help us grow!';

  @override
  String get createAccount => 'Create Account';

  @override
  String get learnMore => 'Learn More';

  @override
  String get replyUpdateSuccess => 'Reply updated successfully';

  @override
  String get replyUpdateError => 'Failed to update reply';

  @override
  String get replyDeleteSuccess => 'Reply deleted successfully';

  @override
  String get replyDeleteError => 'Failed to delete reply';

  @override
  String get replyDeleteConfirmation =>
      'Are you sure you want to delete this reply?';

  @override
  String get authenticationRequired => 'Authentication required';

  @override
  String get enterValidReply => 'Please enter a valid reply text';

  @override
  String get saving => 'Saving...';

  @override
  String get deleting => 'Deleting...';

  @override
  String get properties => 'Properties';

  @override
  String get agents => 'Agents';

  @override
  String get becomeAgent => 'Become an Agent';

  @override
  String get main => 'Main';

  @override
  String get upload => 'Upload';

  @override
  String get filtered_products => 'Filtered Products';

  @override
  String get productDetail => 'Product Detail';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get locationNotAvailable => 'Location not available';

  @override
  String get noTitle => 'No Title';

  @override
  String get noCategory => 'No Category';

  @override
  String get noDescription => 'No Description';

  @override
  String get som => 'Som';

  @override
  String get about_me => 'About Me';

  @override
  String get my_name => 'My Name';

  @override
  String get customer_support => 'Customer Support';

  @override
  String get customer_center => 'Customer Center';

  @override
  String get customer_inquiries => 'Inquiries';

  @override
  String get customer_terms => 'Terms and Conditions';

  @override
  String get region => 'Region';

  @override
  String get district => 'District';

  @override
  String get tap_change_profile => 'Tap to change photo';

  @override
  String get language_settings => 'Language Settings';

  @override
  String get selectLanguage => 'Select a language';

  @override
  String get select_theme => 'Select Theme';

  @override
  String get theme => 'Theme';

  @override
  String get location_settings => 'Location Settings';

  @override
  String get security => 'Security';

  @override
  String get data_storage => 'Data & Storage';

  @override
  String get accessibility => 'Accessibilty';

  @override
  String get privacy => 'Privacy';

  @override
  String get light_theme => 'Light';

  @override
  String get dark_theme => 'Dark';

  @override
  String get system_theme => 'System Default';

  @override
  String get my_products => 'My Products';

  @override
  String get refresh => 'Refresh';

  @override
  String get delete_product => 'Delete Product';

  @override
  String get delete_confirmation =>
      'Are you sure you want to delete this product?';

  @override
  String get delete => 'Delete';

  @override
  String error_loading_products(String error) {
    return 'Error loading products: $error';
  }

  @override
  String get product_deleted_success => 'Product deleted successfully';

  @override
  String error_deleting_product(String error) {
    return 'Error deleting product: $error';
  }

  @override
  String get no_products_found => 'No products found';

  @override
  String get add_first_product => 'Start by adding your first product';

  @override
  String get no_title => 'No title';

  @override
  String get no_description => 'No description';

  @override
  String get in_stock => 'In Stock';

  @override
  String get out_of_stock => 'Out of Stock';

  @override
  String get new_condition => 'NEW';

  @override
  String get edit_product => 'Edit Product';

  @override
  String get delete_product_tooltip => 'Delete Product';

  @override
  String get sum_currency => 'Sum';

  @override
  String get edit_product_title => 'Edit Product';

  @override
  String get product_name => 'Product Name';

  @override
  String get product_description => 'Product Description';

  @override
  String get price => 'Price';

  @override
  String get condition => 'Condition';

  @override
  String get condition_new => 'New';

  @override
  String get condition_used => 'Used';

  @override
  String get condition_refurbished => 'Refurbished';

  @override
  String get currency => 'Currency';

  @override
  String get category => 'Category';

  @override
  String get images => 'Images';

  @override
  String get existing_images => 'Existing Images';

  @override
  String get new_images => 'New Images';

  @override
  String get image_instructions =>
      'Images will appear here. Please press the upload icon above.';

  @override
  String get update_button => 'Update';

  @override
  String loading_category_error(String error) {
    return 'Error loading categories: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Error picking images: $error';
  }

  @override
  String get please_fill_all_required => 'Please fill all the fields';

  @override
  String get invalid_price_message =>
      'Invalid price entered. Please enter a valid number.';

  @override
  String get category_required_message => 'Please select a valid category.';

  @override
  String get one_image_required_message =>
      'At least one product image is required';

  @override
  String get product_updated_success => 'Product successfully updated';

  @override
  String error_updating_product(String error) {
    return 'Error while updating product: $error';
  }

  @override
  String get my_services => 'My Services';

  @override
  String get delete_service => 'Delete Service';

  @override
  String get delete_service_confirmation =>
      'Are you sure you want to delete this service?';

  @override
  String get no_services_found => 'No services found';

  @override
  String get add_first_service => 'Start by adding your first service';

  @override
  String get edit_service => 'Edit Service';

  @override
  String get delete_service_tooltip => 'Delete Service';

  @override
  String get service_deleted_successfully => 'Service deleted successfully';

  @override
  String get error_deleting_service => 'Error deleting service';

  @override
  String get error_loading_services => 'Error loading services';

  @override
  String get service_name => 'Service Name';

  @override
  String get enter_service_name => 'Enter service name';

  @override
  String get service_name_required => 'Service name is required';

  @override
  String get service_name_min_length =>
      'Service name must be at least 3 characters';

  @override
  String get enter_service_description => 'Enter service description';

  @override
  String get service_description_required => 'Service description is required';

  @override
  String get service_description_min_length =>
      'Description must be at least 10 characters';

  @override
  String get category_required => 'Please select a category';

  @override
  String get no_categories_available => 'No categories available';

  @override
  String get location => 'Location';

  @override
  String get select_location => 'Select location';

  @override
  String get location_required => 'Please select a location';

  @override
  String get no_locations_available => 'No locations available';

  @override
  String get add_images => 'Add Images';

  @override
  String get current_images => 'Current Images';

  @override
  String get no_images_selected => 'No images selected';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get map_main => 'Map & Properties';

  @override
  String get agent_status => 'Agent Status';

  @override
  String get admin_panel => 'Admin Panel';

  @override
  String get propertiesFound => 'Properties Found';

  @override
  String get propertiesSaved => 'properties saved';

  @override
  String get saved => 'saved';

  @override
  String get loadingProperties => 'Loading properties...';

  @override
  String get failedToLoad => 'Failed to load properties. Please try again.';

  @override
  String get noPropertiesFound => 'No properties found';

  @override
  String get tryAdjusting => 'Try adjusting your search criteria';

  @override
  String get search_placeholder => 'Search by title or location...';

  @override
  String get search_filters => 'Filters';

  @override
  String get search_button => 'Search';

  @override
  String get search_clear_filters => 'Clear Filters';

  @override
  String get filter_options_sale_and_rent => 'Sale and Rent';

  @override
  String get filter_options_for_sale => 'For Sale';

  @override
  String get filter_options_for_rent => 'For Rent';

  @override
  String get filter_options_all_types => 'All Types';

  @override
  String get filter_options_apartment => 'Apartment';

  @override
  String get filter_options_house => 'House';

  @override
  String get filter_options_townhouse => 'Townhouse';

  @override
  String get filter_options_villa => 'Villa';

  @override
  String get filter_options_commercial => 'Commercial';

  @override
  String get filter_options_office => 'Office';

  @override
  String get property_card_featured => 'Featured';

  @override
  String get property_card_bed => 'bedroom';

  @override
  String get property_card_bath => 'bathroom';

  @override
  String get property_card_parking => 'parking';

  @override
  String get property_card_view_details => 'View Details';

  @override
  String get property_card_contact => 'Contact';

  @override
  String get property_card_balcony => 'Balcony';

  @override
  String get property_card_garage => 'Garage';

  @override
  String get property_card_garden => 'Garden';

  @override
  String get property_card_pool => 'Pool';

  @override
  String get property_card_elevator => 'Elevator';

  @override
  String get property_card_furnished => 'Furnished';

  @override
  String get property_card_sales => 'sales';

  @override
  String get pricing_month => '/month';

  @override
  String get results_properties_found => 'Properties Found';

  @override
  String get results_properties_saved => 'properties saved';

  @override
  String get results_saved => 'saved';

  @override
  String get results_loading_properties => 'Loading properties...';

  @override
  String get results_failed_to_load =>
      'Failed to load properties. Please try again.';

  @override
  String get results_no_properties_found => 'No properties found';

  @override
  String get results_try_adjusting => 'Try adjusting your search criteria';

  @override
  String get no_properties_found => 'No properties found';

  @override
  String get no_category_properties => 'No properties in this category';

  @override
  String get properties_loading => 'Loading properties...';

  @override
  String get all_properties_loaded => 'All properties loaded';

  @override
  String get pagination_previous => 'Previous';

  @override
  String get pagination_next => 'Next';

  @override
  String get pagination_page => 'Page';

  @override
  String get pagination_page_of => 'Page 1 of';

  @override
  String get contact_modal_title => 'Contact Information';

  @override
  String get contact_modal_agent_contact => 'Agent Contact';

  @override
  String get contact_modal_property_owner => 'Property Owner';

  @override
  String get contact_modal_agent_phone_number => 'Agent Phone Number';

  @override
  String get contact_modal_owner_phone_number => 'Owner Phone Number';

  @override
  String get contact_modal_license => 'License';

  @override
  String get contact_modal_rating => 'Rating';

  @override
  String get contact_modal_call_now => 'Call Now';

  @override
  String get contact_modal_copy_number => 'Copy Number';

  @override
  String get contact_modal_close => 'Close';

  @override
  String get contact_modal_contact_hours => 'Contact Hours: 9:00 AM - 8:00 PM';

  @override
  String get contact_modal_agent => 'Agent';

  @override
  String get errors_toggle_save_failed => 'Failed to toggle property save:';

  @override
  String get errors_copy_failed => 'Failed to copy phone number:';

  @override
  String get errors_phone_copied => 'Phone number copied to clipboard';

  @override
  String get errors_error_occurred_regions => 'An error occurred with regions';

  @override
  String get errors_error_occurred_districts =>
      'An error occurred with districts';

  @override
  String get errors_please_fill_all_required_fields =>
      'Please fill all required fields';

  @override
  String get errors_authentication_required => 'Authentication required';

  @override
  String get errors_user_info_missing => 'User information missing';

  @override
  String get errors_validation_error => 'Please check your input data';

  @override
  String get errors_permission_denied => 'Permission denied';

  @override
  String get errors_server_error => 'Server error occurred';

  @override
  String get errors_network_error => 'Network connection error';

  @override
  String get errors_timeout_error => 'Request timeout exceeded';

  @override
  String get errors_custom_error => 'An error occurred';

  @override
  String get errors_error_creating_property => 'Error creating property';

  @override
  String get errors_unknown_error_message => 'An unknown error occurred';

  @override
  String get errors_coordinates_not_found =>
      'Could not find coordinates for this address. Please enter them manually.';

  @override
  String get errors_coordinates_error =>
      'Error getting coordinates. Please enter them manually.';

  @override
  String get property_info_views => 'views';

  @override
  String get property_info_listed => 'Listed';

  @override
  String get property_info_price_per_sqm => '/sqm';

  @override
  String get property_info_saved => 'Saved';

  @override
  String get property_info_save => 'Save';

  @override
  String get property_info_share => 'Share';

  @override
  String get loading_loading => 'Loading...';

  @override
  String get loading_loading_details => 'Loading property details...';

  @override
  String get loading_property_not_found => 'Property not found';

  @override
  String get loading_property_not_found_message =>
      'The property you\'re looking for doesn\'t exist or has been removed.';

  @override
  String get loading_back_to_properties => 'Back to Properties';

  @override
  String get loading_title => 'Loading agents...';

  @override
  String get loading_message => 'Please wait while we load the list of agents.';

  @override
  String get loading_agent_not_found => 'Agent not found';

  @override
  String get property_details_title => 'Property Details';

  @override
  String get property_details_bedrooms => 'Bedrooms';

  @override
  String get property_details_bathrooms => 'Bathrooms';

  @override
  String get property_details_floor_area => 'Floor Area';

  @override
  String get property_details_parking => 'Parking';

  @override
  String get property_details_basic_information => 'Basic Information';

  @override
  String get property_details_property_type => 'Property Type:';

  @override
  String get property_details_listing_type => 'Listing Type:';

  @override
  String get property_details_for_sale => 'For Sale';

  @override
  String get property_details_for_rent => 'For Rent';

  @override
  String get property_details_year_built => 'Year Built:';

  @override
  String get property_details_floor => 'Floor:';

  @override
  String get property_details_of => 'of';

  @override
  String get property_details_features_amenities => 'Features & Amenities';

  @override
  String get sections_description => 'Description';

  @override
  String get sections_nearby_amenities => 'Nearby Amenities';

  @override
  String get sections_similar_properties => 'Similar Properties';

  @override
  String get amenities_metro => 'Metro';

  @override
  String get amenities_school => 'School';

  @override
  String get amenities_hospital => 'Hospital';

  @override
  String get amenities_shopping => 'Shopping';

  @override
  String get amenities_away => 'away';

  @override
  String get contact_title => 'Contact Information';

  @override
  String get contact_professional_listing => 'Professional Listing';

  @override
  String get contact_listed_by_agent => 'Listed by verified agent';

  @override
  String get contact_by_owner => 'By Owner';

  @override
  String get contact_direct_contact => 'Direct contact with property owner';

  @override
  String get contact_property_owner => 'Property Owner';

  @override
  String get contact_call_agent => 'Call Agent';

  @override
  String get contact_email_agent => 'Email Agent';

  @override
  String get contact_call_owner => 'Call Owner';

  @override
  String get contact_email_owner => 'Email Owner';

  @override
  String get contact_send_inquiry => 'Send Inquiry';

  @override
  String get property_status_title => 'Property Status';

  @override
  String get property_status_availability => 'Availability:';

  @override
  String get property_status_available => 'Available';

  @override
  String get property_status_not_available => 'Not Available';

  @override
  String get property_status_featured => 'Featured:';

  @override
  String get property_status_featured_property => 'Featured Property';

  @override
  String get property_status_property_id => 'Property ID:';

  @override
  String get inquiry_title => 'Send Inquiry';

  @override
  String get inquiry_inquiry_type => 'Inquiry Type';

  @override
  String get inquiry_request_info => 'Request Information';

  @override
  String get inquiry_schedule_viewing => 'Schedule Viewing';

  @override
  String get inquiry_make_offer => 'Make Offer';

  @override
  String get inquiry_request_callback => 'Request Callback';

  @override
  String get inquiry_message => 'Message';

  @override
  String get inquiry_message_placeholder =>
      'Tell us about your interest in this property...';

  @override
  String get inquiry_offered_price => 'Offered Price';

  @override
  String get inquiry_enter_offer => 'Enter your offer';

  @override
  String get inquiry_preferred_contact_time =>
      'Preferred Contact Time (optional)';

  @override
  String get inquiry_contact_time_placeholder =>
      'e.g., Weekdays 9:00 AM - 5:00 PM';

  @override
  String get inquiry_cancel => 'Cancel';

  @override
  String get inquiry_sending => 'Sending...';

  @override
  String get inquiry_send_inquiry => 'Send Inquiry';

  @override
  String get inquiry_inquiry_sent_success => 'Inquiry sent successfully!';

  @override
  String get inquiry_inquiry_sent_error =>
      'Failed to send inquiry. Please try again.';

  @override
  String get alerts_link_copied => 'Property link copied to clipboard!';

  @override
  String get alerts_phone_copied => 'Phone number copied to clipboard!';

  @override
  String get alerts_save_property_failed => 'Failed to save property:';

  @override
  String get alerts_email_subject => 'Inquiry about:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Hello,\\n\\nI\'m interested in your property \"$title\" located at $address.\\n\\nPlease contact me for more information.\\n\\nBest regards';
  }

  @override
  String get related_properties_view_details => 'View Details';

  @override
  String get header_property => 'Find Your Dream Property';

  @override
  String get header_sub_property =>
      'Discover premium real estate opportunities in Tashkent\'s most desirable neighborhoods';

  @override
  String get header_title => 'Real Estate Agents';

  @override
  String get header_subtitle =>
      'Find experienced agents to help with your real estate needs';

  @override
  String get header_agents_found => 'agents found';

  @override
  String get filters_all_specializations => 'All Specializations';

  @override
  String get filters_residential => 'Residential';

  @override
  String get filters_commercial => 'Commercial';

  @override
  String get filters_luxury => 'Luxury';

  @override
  String get filters_investment => 'Investment';

  @override
  String get filters_any_rating => 'Any Rating';

  @override
  String get filters_four_stars => '4+ Stars';

  @override
  String get filters_four_half_stars => '4.5+ Stars';

  @override
  String get filters_five_stars => '5 Stars';

  @override
  String get filters_highest_rated => 'Highest Rated';

  @override
  String get filters_lowest_rated => 'Lowest Rated';

  @override
  String get filters_most_sales => 'Most Sales';

  @override
  String get filters_most_experience => 'Most Experience';

  @override
  String get agent_card_verified_agent => 'Verified Agent';

  @override
  String get agent_card_years_experience => 'years experience';

  @override
  String get agent_card_years => 'years';

  @override
  String get agent_card_license => 'License';

  @override
  String get agent_card_specialization => 'Specialization';

  @override
  String get agent_card_view_profile => 'View Profile';

  @override
  String get agent_card_contact => 'Contact';

  @override
  String get agent_card_verified => 'Verified';

  @override
  String get no_results_title => 'No Agents Found';

  @override
  String get no_results_message =>
      'Try adjusting your search criteria or filters.';

  @override
  String get error_title => 'Error Loading Agents';

  @override
  String get error_message => 'Failed to load agent list. Please try again.';

  @override
  String get error_retry => 'Retry';

  @override
  String get error_default_message => 'Failed to load agent details';

  @override
  String get error_try_again => 'Try Again';

  @override
  String get notifications_phone_copied => 'Phone number copied to clipboard';

  @override
  String get notifications_copy_failed => 'Failed to copy phone number:';

  @override
  String get fallback_agent_name => 'Agent';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Submit Property';

  @override
  String get navigation_submitting => 'Submitting...';

  @override
  String get navigation_back_to_agents => 'Back to Agents';

  @override
  String get agent_profile_verified_agent => 'Verified Agent';

  @override
  String get agent_profile_contact_agent => 'Contact Agent';

  @override
  String get agent_profile_send_message => 'Send Message';

  @override
  String get agent_profile_years_experience => 'Years Experience';

  @override
  String get agent_profile_properties_sold => 'Properties Sold';

  @override
  String get agent_profile_active_listings => 'Active Listings';

  @override
  String get agent_profile_total_properties => 'Total Properties';

  @override
  String get tabs_overview => 'overview';

  @override
  String get tabs_properties => 'properties';

  @override
  String get tabs_reviews => 'reviews';

  @override
  String get about_agent_title => 'About Agent';

  @override
  String get about_agent_agency => 'Agency';

  @override
  String get about_agent_license_number => 'License Number';

  @override
  String get about_agent_specialization => 'Specialization';

  @override
  String get about_agent_member_since => 'Member Since';

  @override
  String get about_agent_verified_since => 'Verified Since';

  @override
  String get performance_metrics_title => 'Performance Metrics';

  @override
  String get performance_metrics_average_rating => 'Average Rating';

  @override
  String get performance_metrics_properties_sold => 'Properties Sold';

  @override
  String get performance_metrics_active_listings => 'Active Listings';

  @override
  String get performance_metrics_years_experience => 'Years Experience';

  @override
  String get contact_info_title => 'Contact Information';

  @override
  String get contact_info_contact_via_platform => 'Contact via Platform';

  @override
  String get verification_status_title => 'Verification Status';

  @override
  String get verification_status_verified_agent => 'Verified Agent';

  @override
  String get verification_status_pending_verification => 'Pending Verification';

  @override
  String get verification_status_licensed_professional =>
      'Licensed Professional';

  @override
  String get verification_status_registered_agency => 'Registered Agency';

  @override
  String get quick_actions_title => 'Quick Actions';

  @override
  String get quick_actions_call_now => 'Call Now';

  @override
  String get quick_actions_send_message => 'Send Message';

  @override
  String get quick_actions_view_properties => 'View Properties';

  @override
  String get properties_title => 'Agent Properties';

  @override
  String get properties_loading_properties => 'Loading properties...';

  @override
  String get properties_no_properties_title => 'No Properties Found';

  @override
  String get properties_no_properties_message =>
      'This agent\'s properties will appear here.';

  @override
  String get properties_recent_properties_note =>
      'Showing recent properties. Check full listings for all agent properties.';

  @override
  String get properties_listed => 'Listed';

  @override
  String get properties_bed => 'bed';

  @override
  String get properties_bath => 'bath';

  @override
  String get properties_for_sale => 'For Sale';

  @override
  String get properties_for_rent => 'For Rent';

  @override
  String get reviews_title => 'Client Reviews';

  @override
  String get reviews_no_reviews_title => 'No Reviews Yet';

  @override
  String get reviews_no_reviews_message =>
      'Client reviews and recommendations will appear here.';

  @override
  String get fallbacks_agent_name => 'Agent';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => 'Saved Properties';

  @override
  String get saved_properties_subtitle =>
      'Your favorite properties in one place';

  @override
  String get saved_properties_no_saved_properties => 'No saved properties yet';

  @override
  String get saved_properties_start_saving =>
      'Start exploring and save properties you like';

  @override
  String get saved_properties_browse_properties => 'Browse Properties';

  @override
  String get saved_properties_saved_on => 'Saved on';

  @override
  String get auth_login_required => 'Please log in to view saved properties';

  @override
  String get auth_login => 'Login';

  @override
  String get success_property_unsaved => 'Property removed from saved list';

  @override
  String get success_property_saved => 'Property saved successfully';

  @override
  String get success_phone_copied => 'Phone number copied!';

  @override
  String get success_property_created_success =>
      'Property created successfully!';

  @override
  String get success_agent_approved => 'Agent approved successfully';

  @override
  String get success_agent_rejected => 'Agent rejected successfully';

  @override
  String get steps_step => 'Step';

  @override
  String get steps_basic_information => 'Basic Information';

  @override
  String get steps_location_details => 'Location Details';

  @override
  String get steps_property_details => 'Property Details';

  @override
  String get steps_property_images => 'Property Images';

  @override
  String get basic_info_tell_us_about_property => 'Tell us about your property';

  @override
  String get basic_info_property_type => 'Property Type';

  @override
  String get basic_info_listing_type => 'Listing Type';

  @override
  String get basic_info_property_title => 'Property Title';

  @override
  String get basic_info_title_placeholder =>
      'Enter a descriptive title for your property';

  @override
  String get basic_info_description => 'Description';

  @override
  String get basic_info_description_placeholder =>
      'Describe your property in detail...';

  @override
  String get property_types_apartment => 'Apartment';

  @override
  String get property_types_house => 'House';

  @override
  String get property_types_townhouse => 'Townhouse';

  @override
  String get property_types_villa => 'Villa';

  @override
  String get property_types_commercial => 'Commercial';

  @override
  String get property_types_office => 'Office';

  @override
  String get property_types_land => 'Land';

  @override
  String get property_types_warehouse => 'Warehouse';

  @override
  String get listing_types_for_sale => 'For Sale';

  @override
  String get listing_types_for_rent => 'For Rent';

  @override
  String get location_where_is_property => 'Where is your property located?';

  @override
  String get location_full_address => 'Full Address';

  @override
  String get location_address_placeholder => 'Enter full address';

  @override
  String get location_region => 'Region';

  @override
  String get location_select_region => 'Select region';

  @override
  String get location_district => 'District';

  @override
  String get location_select_district => 'Select district';

  @override
  String get location_city => 'City';

  @override
  String get location_city_placeholder => 'City';

  @override
  String get location_loading_regions => 'Loading regions...';

  @override
  String get location_loading_districts => 'Loading districts...';

  @override
  String get location_map_coordinates => 'Map Coordinates';

  @override
  String get location_get_coordinates => 'Get Coordinates';

  @override
  String get location_latitude => 'Latitude';

  @override
  String get location_longitude => 'Longitude';

  @override
  String get location_coordinates_set => 'Coordinates set';

  @override
  String get location_location_tips => 'Location Tips';

  @override
  String get location_location_tip_1 =>
      '• Fill in the address first, then click \'Get Coordinates\' to automatically get the map location';

  @override
  String get location_location_tip_2 =>
      '• You can also manually enter coordinates if you know the exact location';

  @override
  String get location_location_tip_3 =>
      '• Accurate coordinates help buyers find your property on the map';

  @override
  String get property_details_provide_detailed_info =>
      'Provide detailed information about your property';

  @override
  String get property_details_total_floors => 'Total Floors';

  @override
  String get property_details_area_m2 => 'Area (m²)';

  @override
  String get property_details_parking_spaces => 'Parking Spaces';

  @override
  String get property_details_price => 'Price';

  @override
  String get property_details_features => 'Features';

  @override
  String get images_add_photos_showcase =>
      'Add photos to showcase your property';

  @override
  String get images_click_to_upload => 'Click to upload images';

  @override
  String get images_max_images_info => 'Maximum 10 images, JPG, PNG or WEBP';

  @override
  String get images_main => 'Main';

  @override
  String get images_maximum_images_allowed => 'Maximum 10 images allowed';

  @override
  String get admin_dashboard_title => 'Admin Dashboard';

  @override
  String get admin_dashboard_subtitle =>
      'Real-time overview of your real estate platform';

  @override
  String get admin_last_update => 'Last update';

  @override
  String get admin_total_properties => 'Total Properties';

  @override
  String get admin_total_agents => 'Total Agents';

  @override
  String get admin_total_users => 'Total Users';

  @override
  String get admin_total_views => 'Total Views';

  @override
  String get admin_error_loading_dashboard => 'Error loading dashboard';

  @override
  String get admin_failed_to_load_data => 'Failed to load dashboard data';

  @override
  String get admin_avg_sale_price => 'Avg Sale Price';

  @override
  String get admin_avg_sale_price_subtitle => 'All active listings';

  @override
  String get admin_total_portfolio_value => 'Total Portfolio Value';

  @override
  String get admin_total_portfolio_value_subtitle => 'Combined property value';

  @override
  String get admin_avg_price_per_sqm => 'Avg Price per sqm';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Market rate indicator';

  @override
  String get admin_property_types_distribution => 'Property Types Distribution';

  @override
  String get admin_properties_by_city => 'Properties by City';

  @override
  String get admin_properties_by_district => 'Properties by District';

  @override
  String get admin_inquiry_types_distribution => 'Inquiry Types Distribution';

  @override
  String get admin_agent_verification_rate => 'Agent Verification Rate';

  @override
  String get admin_agent_verification_rate_subtitle => 'Quality control';

  @override
  String get admin_inquiry_response_rate => 'Inquiry Response Rate';

  @override
  String get admin_inquiry_response_rate_subtitle => 'Customer service';

  @override
  String get admin_avg_views_per_property => 'Avg Views per Property';

  @override
  String get admin_avg_views_per_property_subtitle => 'Property popularity';

  @override
  String get admin_featured_properties => 'Featured Properties';

  @override
  String get admin_featured_properties_subtitle => 'Premium listings';

  @override
  String get admin_most_viewed_properties => 'Most Viewed Properties';

  @override
  String get admin_top_performing_agents => 'Top Performing Agents';

  @override
  String get admin_system_health => 'System Health';

  @override
  String get admin_properties_without_images => 'Properties without images';

  @override
  String get admin_missing_location_data => 'Missing location data';

  @override
  String get admin_pending_agent_verification => 'Pending agent verification';

  @override
  String get admin_active => 'active';

  @override
  String get admin_verified => 'verified';

  @override
  String get admin_active_7d => 'active (7d)';

  @override
  String get admin_this_month => 'this month';

  @override
  String get agents_loading_pending_applications =>
      'Loading pending applications...';

  @override
  String get agents_error_loading_applications => 'Error loading applications';

  @override
  String get agents_pending_agents => 'Pending Agents';

  @override
  String get agents_total_pending_applications =>
      'Total pending applications: ';

  @override
  String get agents_pending_verification => 'Pending Verification';

  @override
  String get agents_applied_date => 'Applied: ';

  @override
  String get agents_contact_info => 'Contact Information';

  @override
  String get agents_license_number => 'License Number';

  @override
  String get agents_years_experience => 'Years Experience';

  @override
  String get agents_years_suffix => ' years';

  @override
  String get agents_total_sales => 'Total Sales';

  @override
  String get agents_specialization => 'Specialization';

  @override
  String get agents_approve => 'Approve';

  @override
  String get agents_reject => 'Reject';

  @override
  String get agents_no_pending_applications => 'No pending applications';

  @override
  String get agents_all_applications_processed =>
      'All agent applications have been processed';

  @override
  String get general_previous => 'Previous';

  @override
  String get general_page => 'Page ';

  @override
  String get general_next => 'Next';

  @override
  String get general_views => 'views';

  @override
  String get general_sales => 'sales';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'Русский';

  @override
  String get general_language_en => 'English';

  @override
  String get general_super_admin => 'Super Admin';

  @override
  String get general_staff => 'Staff';

  @override
  String get general_verified_agent => 'Verified Agent';

  @override
  String get general_pending_agent => 'Pending Agent';

  @override
  String get general_regular_user => 'Regular User';

  @override
  String get general_admin => 'Admin';

  @override
  String get general_dashboard => 'Dashboard';

  @override
  String get general_manage_users => 'Manage Users';

  @override
  String get general_verified_agents => 'Verified Agents';

  @override
  String get general_agent_panel => 'Agent Panel';

  @override
  String get general_create_property => 'Create Property';

  @override
  String get general_my_properties => 'My Properties';

  @override
  String get general_inquiries => 'Inquiries';

  @override
  String get general_agent_profile => 'Agent Profile';

  @override
  String get general_live => 'Live';

  @override
  String get general_logged_out_successfully => 'Logged out successfully';

  @override
  String get general_logout_completed_with_errors =>
      'Logout completed (with errors)';

  @override
  String get general_application_under_review => 'Application under review';

  @override
  String get general_check_status => 'Check status →';

  @override
  String get general_last_updated => 'Last updated:';

  @override
  String get general_permissions_may_be_outdated =>
      'Permissions may be outdated';

  @override
  String get general_permissions_up_to_date => 'Permissions up to date';

  @override
  String get general_never => 'Never';

  @override
  String get general_properties_found => 'Properties Found';

  @override
  String get general_properties_saved => 'properties saved';

  @override
  String get general_saved => 'saved';

  @override
  String get general_loading_properties => 'Loading properties...';

  @override
  String get general_failed_to_load =>
      'Failed to load properties. Please try again.';

  @override
  String get general_no_properties_found => 'No properties found';

  @override
  String get general_try_adjusting => 'Try adjusting your search criteria';

  @override
  String get select_category => 'Select category';

  @override
  String get service_description => 'Service Description';

  @override
  String get product_search_placeholder =>
      'Enter a search term to find products';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get terms_subtitle => 'Privacy policy and terms';

  @override
  String get last_updated => 'Last Updated';

  @override
  String get contact_information => 'Contact Information';

  @override
  String get accept_terms => 'I Accept Terms and Conditions';

  @override
  String get read_terms => 'Please read our terms and conditions';

  @override
  String get inquiries => 'Inquiries & Support';

  @override
  String get inquiries_subtitle => 'Contact us for help';

  @override
  String get help_center => 'How can we help you?';

  @override
  String get help_subtitle => 'We\'re here to assist you with any questions';

  @override
  String get contact_us => 'Contact Us';

  @override
  String get email_support => 'Email Support';

  @override
  String get call_support => 'Call Support';

  @override
  String get send_message => 'Send Message';

  @override
  String get fill_contact_form => 'Fill out contact form';

  @override
  String get contact_form => 'Contact Form';

  @override
  String get name => 'Your Name';

  @override
  String get name_required => 'Please enter your name';

  @override
  String get email => 'Email Address';

  @override
  String get email_required => 'Please enter your email';

  @override
  String get email_invalid => 'Please enter a valid email';

  @override
  String get subject => 'Subject';

  @override
  String get subject_required => 'Please enter a subject';

  @override
  String get message => 'Your Message';

  @override
  String get message_required => 'Please enter your message';

  @override
  String get message_too_short => 'Message must be at least 10 characters';

  @override
  String get faq => 'Frequently Asked Questions';

  @override
  String get follow_us => 'Follow Us';

  @override
  String get faq_how_to_sell => 'How do I sell items on Tezsell?';

  @override
  String get faq_how_to_sell_answer =>
      'To sell items: 1) Create an account, 2) Tap the \'+\' button, 3) Choose category (Products/Services/Real Estate), 4) Add photos and description, 5) Set your price, 6) Publish! Your listing will be visible to buyers in your area.';

  @override
  String get faq_is_free => 'Is Tezsell free to use?';

  @override
  String get faq_is_free_answer =>
      'Yes! Tezsell is currently 100% free. No listing fees, no commission on sales, no subscription charges. We may introduce premium features in the future, but will notify users 30 days in advance.';

  @override
  String get faq_safety => 'How can I stay safe when buying/selling?';

  @override
  String get faq_safety_answer =>
      'Safety tips: 1) Meet in public places, 2) Inspect items before paying, 3) Never send money to strangers, 4) Trust your instincts, 5) Report suspicious users, 6) Don\'t share personal information too early, 7) Bring a friend for high-value transactions.';

  @override
  String get faq_payment => 'How do payments work?';

  @override
  String get faq_payment_answer =>
      'Tezsell does not process payments. Buyers and sellers arrange payment directly (cash, bank transfer, etc.). We are just a platform to connect people - you handle the transaction yourselves.';

  @override
  String get faq_prohibited => 'What items are prohibited?';

  @override
  String get faq_prohibited_answer =>
      'Prohibited items include: weapons, drugs, stolen goods, counterfeit items, adult content, live animals (without permits), government IDs, and hazardous materials. See our Terms & Conditions for the complete list.';

  @override
  String get faq_account_delete => 'How do I delete my account?';

  @override
  String get faq_account_delete_answer =>
      'Go to Profile → Settings → Account Settings → Delete Account. Note: This is permanent and cannot be undone. All your listings will be removed.';

  @override
  String get faq_report_user => 'How do I report a user or listing?';

  @override
  String get faq_report_user_answer =>
      'Tap the three dots (•••) on any listing or user profile, then select \'Report\'. Choose the reason and submit. We review all reports within 24-48 hours.';

  @override
  String get faq_change_location => 'How do I change my location?';

  @override
  String get faq_change_location_answer =>
      'Tap the location button in the top-left corner of the home screen. You can select your region and district to see listings in your area.';

  @override
  String get welcome_customer_center => 'Welcome to Customer Center';

  @override
  String get customer_center_subtitle => 'We\'re here to help you 24/7';

  @override
  String get quick_actions => 'Quick Actions';

  @override
  String get live_chat => 'Live Chat';

  @override
  String get chat_with_us => 'Chat with us';

  @override
  String get find_answers => 'Find answers';

  @override
  String get my_tickets => 'My Tickets';

  @override
  String get view_tickets => 'View tickets';

  @override
  String get feedback => 'Feedback';

  @override
  String get share_feedback => 'Share feedback';

  @override
  String get contact_methods => 'Contact Methods';

  @override
  String get phone_support => 'Phone Support';

  @override
  String get available_247 => 'Available 24/7';

  @override
  String get response_24h => 'Response within 24 hours';

  @override
  String get telegram_support => 'Telegram Support';

  @override
  String get instant_replies => 'Instant replies';

  @override
  String get whatsapp_support => 'WhatsApp Support';

  @override
  String get quick_response => 'Quick response';

  @override
  String get popular_topics => 'Popular Topics';

  @override
  String get account_management => 'Account Management';

  @override
  String get reset_password => 'Reset Password';

  @override
  String get update_profile => 'Update Profile';

  @override
  String get verify_account => 'Verify Account';

  @override
  String get delete_account => 'Delete Account';

  @override
  String get buying_selling => 'Buying & Selling';

  @override
  String get how_to_post => 'How to Post Ads';

  @override
  String get payment_methods => 'Payment Methods';

  @override
  String get shipping_delivery => 'Shipping & Delivery';

  @override
  String get return_policy => 'Return Policy';

  @override
  String get safety_security => 'Safety & Security';

  @override
  String get report_scam => 'Report Scam';

  @override
  String get safe_trading => 'Safe Trading Tips';

  @override
  String get privacy_settings => 'Privacy Settings';

  @override
  String get blocked_users => 'Blocked Users';

  @override
  String get technical_issues => 'Technical Issues';

  @override
  String get app_not_working => 'App Not Working';

  @override
  String get upload_failed => 'Upload Failed';

  @override
  String get login_problems => 'Login Problems';

  @override
  String get support_hours => 'Support Hours';

  @override
  String get mon_fri_9_6 => 'Mon-Fri: 9:00 AM - 6:00 PM';

  @override
  String get how_are_we_doing => 'How are we doing?';

  @override
  String get rate_experience => 'Rate your customer service experience';

  @override
  String get poor => 'Poor';

  @override
  String get okay => 'Okay';

  @override
  String get good => 'Good';

  @override
  String get excellent => 'Excellent';

  @override
  String get account_secure => 'Your Account is Secure';

  @override
  String get password_security => 'Password & Authentication';

  @override
  String get change_password => 'Change Password';

  @override
  String get two_factor_auth => 'Two-Factor Authentication';

  @override
  String get biometric_login => 'Biometric Login';

  @override
  String get login_activity => 'Login Activity';

  @override
  String get active_sessions => 'Active Sessions';

  @override
  String get login_alerts => 'Login Alerts';

  @override
  String get account_protection => 'Account Protection';

  @override
  String get recovery_email => 'Recovery Email';

  @override
  String get backup_codes => 'Backup Codes';

  @override
  String get danger_zone => 'Danger Zone';

  @override
  String get improve_security => 'Improve Security';

  @override
  String get security_score => 'Security Score';

  @override
  String get last_changed_days => 'Last changed 30 days ago';

  @override
  String get logout_all_devices => 'Logout All Devices';

  @override
  String get end_all_sessions => 'End all sessions';

  @override
  String get permanently_delete => 'Permanently delete';

  @override
  String get verification_code_message =>
      'We\'ll send a verification code to confirm it\'s you.';

  @override
  String get send_code => 'Send Code';

  @override
  String get enter_verification_code => 'Enter Verification Code';

  @override
  String get verification_code => 'Verification Code';

  @override
  String get new_password => 'New Password';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get resend_code => 'Resend Code';

  @override
  String get code_sent_to => 'Enter the verification code sent to';

  @override
  String get enter_code => 'Enter verification code';

  @override
  String get code_must_be_6_digits => 'Code must be 6 digits';

  @override
  String get enter_new_password => 'Enter new password';

  @override
  String get minimum_8_characters => 'Minimum 8 characters';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get close => 'Close';

  @override
  String get current => 'Current';

  @override
  String get session_ended => 'Session ended';

  @override
  String get update_recovery_email => 'Update Recovery Email';

  @override
  String get new_email => 'New Email';

  @override
  String get update => 'Update';

  @override
  String get verification_email_sent => 'Verification email sent';

  @override
  String get generate_emergency_codes => 'Generate emergency codes';

  @override
  String get copy_all => 'Copy All';

  @override
  String get code_copied => 'Code copied';

  @override
  String get all_codes_copied => 'All codes copied';

  @override
  String get logout_all_devices_confirm => 'Logout All Devices?';

  @override
  String get logout_all_devices_message =>
      'This will end all active sessions on all devices.';

  @override
  String get logout_all => 'Logout All';

  @override
  String get delete_account_confirm => 'Delete Account?';

  @override
  String get delete_account_warning =>
      'This action is PERMANENT and cannot be undone. All your data will be permanently deleted.';

  @override
  String get what_will_be_deleted => 'What will be deleted:';

  @override
  String get profile_and_account_info =>
      '• Your profile and account information';

  @override
  String get all_listings_and_posts => '• All your listings and posts';

  @override
  String get messages_and_conversations => '• Your messages and conversations';

  @override
  String get saved_items_and_preferences => '• Saved items and preferences';

  @override
  String get enter_password_to_continue => 'Enter your password to continue';

  @override
  String get continue_val => 'Continue';

  @override
  String get please_enter_password => 'Please enter your password';

  @override
  String get enter_confirmation_code => 'Enter Confirmation Code';

  @override
  String get deletion_confirmation_message =>
      'We sent a confirmation code to your phone. Enter it below to permanently delete your account.';

  @override
  String get confirmation_code => 'Confirmation Code';

  @override
  String get please_enter_6_digit_code => 'Please enter the 6-digit code';

  @override
  String get account_deleted => 'Your account has been deleted';

  @override
  String get deletion_cancelled => 'Deletion cancelled';

  @override
  String get failed_to_load_user_info => 'Failed to load user information';

  @override
  String get auth_login_to_view_saved =>
      'Please log in to view your saved properties';

  @override
  String get authLoginRequired => 'Login Required';

  @override
  String get authLoginToViewSaved =>
      'Please log in to view your saved properties';

  @override
  String get authLogin => 'Log In';

  @override
  String get savedPropertiesTitle => 'Saved Properties';

  @override
  String get loadingSavedProperties => 'Loading saved properties...';

  @override
  String get errorsFailedToLoadSaved => 'Failed to load saved properties';

  @override
  String get actionsRetry => 'Retry';

  @override
  String get savedPropertiesNoSaved => 'No Saved Properties';

  @override
  String get savedPropertiesStartSaving =>
      'Start exploring and save properties you like';

  @override
  String get savedPropertiesBrowse => 'Browse Properties';

  @override
  String get resultsSavedProperties => 'saved properties';

  @override
  String get actionsRefresh => 'Refresh';

  @override
  String get resultsNoMoreProperties => 'No more properties';

  @override
  String get propertyCardFeatured => 'Featured';

  @override
  String get successPropertyUnsaved => 'Property removed from saved list';

  @override
  String get alertsUnsavePropertyFailed => 'Failed to remove property';

  @override
  String get propertyCardBed => 'bed';

  @override
  String get propertyCardBath => 'bath';

  @override
  String get savedPropertiesSavedOn => 'Saved on';

  @override
  String get propertyCardViewDetails => 'View Details';

  @override
  String get serviceDetailTitle => 'Service Detail';

  @override
  String get errorLoadingFavorites => 'Error loading favorite items';

  @override
  String get noFavoritesFound => 'No favorite items found.';

  @override
  String get commentUpdatedSuccess => 'Comment updated successfully!';

  @override
  String get errorUpdatingComment => 'Error updating comment';

  @override
  String get replyAddedSuccess => 'Reply added successfully!';

  @override
  String get errorAddingReply => 'Error adding reply';

  @override
  String get commentDeletedSuccess => 'Comment deleted successfully!';

  @override
  String get errorDeletingComment => 'Error deleting comment';

  @override
  String get serviceLikedSuccess => 'Service liked successfully!';

  @override
  String get errorLikingService => 'Error liking service';

  @override
  String get serviceDislikedSuccess => 'Service disliked successfully!';

  @override
  String get errorDislikingService => 'Error disliking service';

  @override
  String get replyingTo => 'Replying to';

  @override
  String get writeYourReply => 'Write your reply...';

  @override
  String get postReply => 'Post Reply';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get editComment => 'Edit Comment';

  @override
  String get editYourComment => 'Edit your comment...';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get propertyOwner => 'Property Owner';

  @override
  String get errorLoadingServices => 'Error loading services';

  @override
  String get noRecommendedServicesFound => 'No recommended services found.';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordRequirements =>
      'Password must contain letters and numbers';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get usernameTooShort => 'Username must be at least 3 characters';

  @override
  String get confirmPasswordRequired => 'Password confirmation is required';

  @override
  String get passwordHelp => 'At least 8 characters, letters and numbers';

  @override
  String get usernameExists => 'This username already exists';

  @override
  String get phoneExists => 'This phone number is already registered';

  @override
  String get networkError =>
      'Network connection error. Please check your connection';

  @override
  String get contactSeller => 'Contact Seller';

  @override
  String get callToReveal => 'Tap \"Call\" to reveal';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get selectImageSource => 'Select Image Source';

  @override
  String get uploading => 'Uploading...';

  @override
  String get acceptTermsRequired =>
      'You must accept the Terms and Conditions to continue';

  @override
  String get iAgreeToTerms => 'I agree to the ';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get zeroToleranceStatement =>
      ' and understand that there is zero tolerance for objectionable content or abusive users.';

  @override
  String get viewTerms => 'View Terms and Conditions';

  @override
  String get reportContent => 'Report Content';

  @override
  String get selectReportReason => 'Please select a reason for reporting:';

  @override
  String get additionalDetails => 'Additional details (optional)';

  @override
  String get reportDetailsHint => 'Provide any additional information...';

  @override
  String get reportSubmitted =>
      'Thank you for your report. We will review it within 24 hours.';

  @override
  String get reportProduct => 'Report Product';

  @override
  String get reportService => 'Report Service';

  @override
  String get reportMessage => 'Report Message';

  @override
  String get reportUser => 'Report User';

  @override
  String get reportErrorNotImplemented =>
      'The reporting feature is not yet available. Please contact support or try again later.';

  @override
  String get reportAlreadySubmitted =>
      'You have already reported this content. We are reviewing your previous report.';

  @override
  String get reportFailedGeneric =>
      'Failed to submit report. Please try again.';

  @override
  String get reportFailedNetwork =>
      'Network error occurred. Please check your connection and try again.';

  @override
  String get becomeAgentTitle => 'Join as a Real Estate Agent';

  @override
  String get becomeAgentSubtitle =>
      'List properties and help clients find their dream homes';

  @override
  String get agentBenefits => 'Benefits:';

  @override
  String get agentBenefitVerified => 'Verified agent badge';

  @override
  String get agentBenefitAnalytics => 'Access to analytics and insights';

  @override
  String get agentBenefitClients => 'Direct contact with potential clients';

  @override
  String get agentBenefitReputation => 'Build your professional reputation';

  @override
  String get agentApplicationForm => 'Application Form';

  @override
  String get agentAgencyName => 'Agency Name';

  @override
  String get agentAgencyNameHint => 'Enter your real estate agency name';

  @override
  String get agentAgencyNameRequired => 'Agency name is required';

  @override
  String get agentLicenceNumber => 'License Number';

  @override
  String get agentLicenceNumberHint => 'Enter your real estate license number';

  @override
  String get agentLicenceNumberRequired => 'License number is required';

  @override
  String get agentYearsExperience => 'Years of Experience';

  @override
  String get agentYearsExperienceHint => 'Enter number of years';

  @override
  String get agentYearsExperienceRequired => 'Years of experience is required';

  @override
  String get agentYearsExperienceInvalid => 'Please enter a valid number';

  @override
  String get agentSpecialization => 'Specialization';

  @override
  String get agentApplicationNote =>
      'Your application will be reviewed by our team. You will be notified once your application is approved.';

  @override
  String get agentSubmitApplication => 'Submit Application';

  @override
  String get agentApplicationSubmitted =>
      'Application submitted successfully! We will review it soon.';

  @override
  String get agentApplicationStatus => 'Application Status';

  @override
  String get agentViewProfile => 'View your agent profile';

  @override
  String get agentDashboardComingSoon => 'Agent dashboard coming soon!';

  @override
  String get property_create_basic_information => 'Basic Information';

  @override
  String get property_create_property_title => 'Property Title *';

  @override
  String get property_create_property_title_hint =>
      'e.g., Modern 3BR Apartment in City Center';

  @override
  String get property_create_property_title_required =>
      'Please enter property title';

  @override
  String get property_create_description => 'Description *';

  @override
  String get property_create_description_hint =>
      'Describe your property in detail...';

  @override
  String get property_create_description_required => 'Please enter description';

  @override
  String get property_create_property_type => 'Property Type';

  @override
  String get property_create_property_type_required => 'Property Type *';

  @override
  String get property_create_listing_type_required => 'Listing Type *';

  @override
  String get property_create_pricing => 'Pricing';

  @override
  String get property_create_price => 'Price *';

  @override
  String get property_create_price_hint => 'Enter price';

  @override
  String get property_create_price_required => 'Please enter price';

  @override
  String get property_create_currency => 'Currency';

  @override
  String get property_create_property_details => 'Property Details';

  @override
  String get property_create_square_meters => 'Sq. Meters *';

  @override
  String get property_create_bedrooms => 'Bedrooms *';

  @override
  String get property_create_bathrooms => 'Bathrooms *';

  @override
  String get property_create_floor => 'Floor';

  @override
  String get property_create_total_floors => 'Total Floors';

  @override
  String get property_create_parking => 'Parking';

  @override
  String get property_create_year_built => 'Year Built';

  @override
  String get property_create_location => 'Location';

  @override
  String get property_create_address => 'Address *';

  @override
  String get property_create_address_hint => 'Enter property address';

  @override
  String get property_create_address_required => 'Please enter address';

  @override
  String get property_create_location_detected => 'Location Detected';

  @override
  String get property_create_get_location => 'Get Current Location';

  @override
  String get property_create_features => 'Features';

  @override
  String get property_create_feature_balcony => 'Balcony';

  @override
  String get property_create_feature_garage => 'Garage';

  @override
  String get property_create_feature_garden => 'Garden';

  @override
  String get property_create_feature_pool => 'Pool';

  @override
  String get property_create_feature_elevator => 'Elevator';

  @override
  String get property_create_feature_furnished => 'Furnished';

  @override
  String get property_create_images => 'Property Images';

  @override
  String get property_create_tap_to_add_images => 'Tap to add images';

  @override
  String get property_create_at_least_one_image => 'At least 1 image required';

  @override
  String get property_create_add_more => 'Add More';

  @override
  String get property_create_required => 'Required';

  @override
  String get property_create_location_required =>
      'Please enable location services to create a property';

  @override
  String get property_create_image_required =>
      'At least one property image is required';
}
