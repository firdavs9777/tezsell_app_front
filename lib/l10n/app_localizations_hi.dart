// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get sessionExpired =>
      'आपका सत्र समाप्त हो गया है। कृपया फिर से साइन इन करें।';

  @override
  String get welcome => 'स्वागत';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है!';

  @override
  String get loginToYourAccount => 'जारी रखने के लिए लॉगिन करें';

  @override
  String get or => 'या';

  @override
  String get dontHaveAccount => 'कोई खाता नहीं है?';

  @override
  String get chooseLanguage => 'अपनी भाषा चुनें';

  @override
  String get selectPreferredLanguage => 'ऐप के लिए अपनी पसंदीदा भाषा चुनें';

  @override
  String get continueButton => 'जारी रखना';

  @override
  String get continueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get continueWithApple => 'एप्पल के साथ जारी रखें';

  @override
  String get continueWithEmail => 'ईमेल जारी रखें';

  @override
  String get sellAndBuyProducts =>
      'अपना कोई भी उत्पाद केवल हमारे साथ ही बेचें और खरीदें';

  @override
  String get usedProductsMarket => 'प्रयुक्त उत्पाद या सेकेंड-हैंड बाज़ार';

  @override
  String get home_welcome_title => 'आपका पड़ोस बाज़ार';

  @override
  String get home_welcome_subtitle =>
      'आस-पास के लोगों के साथ खरीदें और बेचें।\nसुरक्षित, सरल और स्थानीय।';

  @override
  String get home_get_started => 'शुरू हो जाओ';

  @override
  String get home_sign_in => 'मेरा पहले से ही खाता है';

  @override
  String get home_terms_notice =>
      'जारी रखकर, आप हमारी सेवा की शर्तों और गोपनीयता नीति से सहमत हैं';

  @override
  String get register => 'पंजीकरण करवाना';

  @override
  String get alreadyHaveAccount => 'क्या आपके पास पहले से एक खाता मौजूद है';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get loginToAccount => 'खाते में लॉगिन करें';

  @override
  String get enterPhoneNumber => 'फ़ोन नंबर दर्ज करें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get enterPassword => 'पास वर्ड दर्ज करें';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get registerNow => 'अभी पंजीकरण करें';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get pleaseEnterPhoneNumber => 'कृपया अपना फोन नंबर दर्ज करें';

  @override
  String get pleaseEnterPassword => 'अपना पासवर्ड दर्ज करें';

  @override
  String get unexpectedError =>
      'एक अप्रत्याशित त्रुटि हुई। कृपया पुन: प्रयास करें।';

  @override
  String get forgotPasswordComingSoon =>
      'पासवर्ड भूल गए सुविधा जल्द ही आ रही है';

  @override
  String get selectedCountryLabel => 'चयनित:';

  @override
  String get fullPhoneLabel => 'भरा हुआ:';

  @override
  String get home => 'घर';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get search => 'खोज';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get error => 'गलती';

  @override
  String get retry => 'पुन: प्रयास करें';

  @override
  String get cancel => 'रद्द करना';

  @override
  String get save => 'बचाना';

  @override
  String get appTitle => 'तेज़सेल';

  @override
  String get selectRegion => 'कृपया अपना क्षेत्र चुनें';

  @override
  String get searchHint => 'जिला या शहर खोजें';

  @override
  String get apiError => 'एपीआई को कॉल करते समय एक समस्या उत्पन्न हुई';

  @override
  String get ok => 'ठीक है';

  @override
  String get emptyList => 'खाली सूची';

  @override
  String get dataLoadingError => 'डेटा लोड करते समय कोई त्रुटि हुई';

  @override
  String get confirm => 'पुष्टि करना';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String confirmRegionSelection(Object regionName) {
    return 'क्या आप $regionName क्षेत्र का चयन करना चाहते हैं?';
  }

  @override
  String get selectDistrictOrCity => 'कृपया अपना जिला या शहर चुनें';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return 'क्या आप $regionName क्षेत्र - $districtName का चयन करना चाहते हैं?';
  }

  @override
  String get noResultsFound => 'कोई परिणाम नहीं मिला.';

  @override
  String errorWithCode(String errorCode) {
    return 'त्रुटि: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'डेटा लोड करने में विफल. त्रुटि: $error';
  }

  @override
  String get phoneVerification => 'फ़ोन नंबर सत्यापन';

  @override
  String get enterPhonePrompt => 'कृपया अपना फोन नंबर दर्ज करें';

  @override
  String get enterPhoneNumberHint => 'फ़ोन नंबर दर्ज करें';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'चयनित: $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'अपने देश का चयन करॊ';

  @override
  String get changeCountry => 'देश बदलें';

  @override
  String get country => 'देश';

  @override
  String get allCountries => 'सभी देश';

  @override
  String get currencyRUB => 'रूसी रूबल';

  @override
  String get currencyUAH => 'यूक्रेनी रिव्निया';

  @override
  String get currencyBYN => 'बेलारूसी रूबल';

  @override
  String get currencyMDL => 'मोल्दोवन लियू';

  @override
  String get currencyGEL => 'जॉर्जियाई लारी';

  @override
  String get currencyAMD => 'अर्मेनियाई नाटक';

  @override
  String get currencyAZN => 'अज़रबैजानी मनत';

  @override
  String get currencyKZT => 'कजाकिस्तान तेंगे';

  @override
  String get currencyTMT => 'तुर्कमेन मनात';

  @override
  String get currencyKGS => 'किर्गिज़स्तानी सोम';

  @override
  String get currencyTJS => 'ताजिकिस्तानी सोमोनी';

  @override
  String get currencyUZS => 'उज़्बेक सोम';

  @override
  String get currencyUSD => 'अमेरिकी डॉलर';

  @override
  String get currencyEUR => 'यूरो';

  @override
  String fullNumber(String phoneNumber) {
    return 'पूर्ण संख्या: $phoneNumber';
  }

  @override
  String get sendCode => 'कोड भेजें';

  @override
  String get enterVerificationCode => 'सत्यापन कोड दर्ज करें';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'पुन: कोड भेजे';

  @override
  String expires(String time) {
    return 'समाप्ति: $time';
  }

  @override
  String get verifyAndContinue => 'सत्यापित करें और जारी रखें';

  @override
  String get invalidVerificationCode => 'अवैध सत्यापन संकेत';

  @override
  String get verificationCodeSent => 'सत्यापन कोड सफलतापूर्वक भेजा गया';

  @override
  String get failedToSendCode => 'सत्यापन कोड भेजने में विफल';

  @override
  String get verificationCodeResent => 'सत्यापन कोड सफलतापूर्वक पुनः भेजा गया';

  @override
  String get failedToResendCode => 'सत्यापन कोड पुनः भेजने में विफल';

  @override
  String get passwordVerification => 'पासवर्ड सत्यापन';

  @override
  String get completeRegistrationPrompt =>
      'पंजीकरण पूरा करने के लिए उपयोगकर्ता नाम और पासवर्ड दर्ज करें';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get username_required => 'उपयोगकर्ता नाम आवश्यक है';

  @override
  String get username_min_length =>
      'उपयोगकर्ता नाम कम से कम 2 अक्षर का होना चाहिए';

  @override
  String get usernameHint => 'उपयोक्तानाम123';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि कीजिये';

  @override
  String get profileImage => 'प्रोफ़ाइल छवि';

  @override
  String get imageInstructions =>
      'छवियाँ यहाँ दिखाई देंगी, कृपया प्रोफ़ाइल छवि दबाएँ';

  @override
  String get finish => 'खत्म करना';

  @override
  String get passwordsDoNotMatch => 'सांकेतिक शब्द मेल नहीं खाते';

  @override
  String get registrationError => 'त्रुटि का पंजीकरण';

  @override
  String get about => 'हमारे बारे में';

  @override
  String get chat => 'बात करना';

  @override
  String get realEstate => 'रियल एस्टेट';

  @override
  String get language => 'इंग्लैंड';

  @override
  String get languageEn => 'अंग्रेज़ी';

  @override
  String get languageRu => 'रूसी';

  @override
  String get languageUz => 'उज़बेक';

  @override
  String get serviceLiked => 'सेवा पसंद आयी';

  @override
  String get support => 'सहायता';

  @override
  String get service => 'व्यापार सेवाएं';

  @override
  String get aboutContent =>
      'TezSell नए और प्रयुक्त उत्पादों को खरीदने और बेचने के लिए एक तेज़ और आसान बाज़ार है। हमारा मिशन प्रत्येक उपयोगकर्ता के लिए सबसे सुविधाजनक और कुशल मंच बनाना है, जो सुचारू लेनदेन और उपयोगकर्ता के अनुकूल अनुभव सुनिश्चित करता है। चाहे आप बेचना या खरीदना चाह रहे हों, TezSell कुछ ही चरणों में कनेक्ट करना और लेनदेन पूरा करना आसान बनाता है। हम अपने उपयोगकर्ताओं की सुरक्षा और गोपनीयता को प्राथमिकता देते हैं। सुरक्षा और अनुपालन सुनिश्चित करने के लिए सभी लेनदेन की सावधानीपूर्वक निगरानी की जाती है, जिससे खरीदारों और विक्रेताओं दोनों को मानसिक शांति मिलती है। हमारा सरल और सहज ज्ञान युक्त इंटरफ़ेस उपयोगकर्ताओं को उत्पादों को तुरंत सूचीबद्ध करने और उन्हें जो चाहिए वह ढूंढने की अनुमति देता है। हम टेलीग्राम के माध्यम से वास्तविक समय संचार की सुविधा भी देते हैं, जिससे खरीद और बिक्री की प्रक्रिया और भी आसान हो जाती है।';

  @override
  String get errorMessage => 'त्रुटि हुई, कृपया सर्वर की जाँच करें';

  @override
  String get searchLocation => 'जगह';

  @override
  String get searchCategory => 'श्रेणियाँ';

  @override
  String get searchProductPlaceholder => 'उत्पाद खोजें';

  @override
  String get searchServicePlaceholder => 'सेवाएँ खोजें';

  @override
  String get search_products_subtitle => 'अपने पड़ोस में बढ़िया सौदे खोजें';

  @override
  String get search_services_subtitle => 'अपने पड़ोस में पेशेवर खोजें';

  @override
  String get search_products_error => 'उत्पाद खोजने में त्रुटि';

  @override
  String get search_services_error => 'सेवाएँ खोजने में त्रुटि';

  @override
  String get load_more_products_error => 'अधिक उत्पाद लोड करने में त्रुटि';

  @override
  String get load_more_services_error => 'अधिक सेवाएँ लोड करने में त्रुटि';

  @override
  String get try_different_keywords => 'अलग-अलग कीवर्ड आज़माएं';

  @override
  String get searchText => 'खोज';

  @override
  String get selectedCategory => 'चयनित श्रेणी:';

  @override
  String get selectedLocation => 'चयनित स्थान:';

  @override
  String get productError => 'कोई उत्पाद उपलब्ध नहीं';

  @override
  String get serviceError => 'कोई सेवा उपलब्ध नहीं';

  @override
  String get locationHeader => 'एक स्थान चुनें';

  @override
  String get locationPlaceholder => 'यहां क्षेत्र खोजें';

  @override
  String get categoryHeader => 'एक श्रेणी चुनें';

  @override
  String get categoryPlaceholder => 'श्रेणियाँ खोजें';

  @override
  String get categoryError => 'कोई श्रेणियां उपलब्ध नहीं';

  @override
  String get paginationFirst => 'पहला';

  @override
  String get paginationPrevious => 'पहले का';

  @override
  String get pageInfo => 'का पेज';

  @override
  String get pageNext => 'अगला';

  @override
  String get pageLast => 'अंतिम';

  @override
  String get loadingMessageProduct => 'उत्पाद लोड हो रहे हैं...';

  @override
  String get loadingMessageError => 'लोड करते समय त्रुटि';

  @override
  String get likeProductError => 'उत्पाद पसंद करते समय त्रुटि हुई';

  @override
  String get dislikeProductError => 'उत्पाद को नापसंद करते समय त्रुटि हुई';

  @override
  String get loadingMessageLocation => 'स्थान लोड हो रहा है...';

  @override
  String get loadingLocationError => 'स्थान लोड करते समय त्रुटि';

  @override
  String get loadingMessageCategory => 'श्रेणियां लोड हो रही हैं...';

  @override
  String get loadingCategoryError => 'श्रेणियाँ लोड करने में त्रुटि:';

  @override
  String get profileUpdateSuccessMessage => 'प्रोफ़ाइल सफलतापूर्वक अपडेट की गई';

  @override
  String get profileUpdateFailMessage => 'प्रोफ़ाइल अपडेट करने में विफल';

  @override
  String get seeMoreBtn => 'और देखें';

  @override
  String get profilePageTitle => 'प्रोफ़ाइल पृष्ठ';

  @override
  String get editProfileModalTitle => 'प्रोफ़ाइल संपादित करें';

  @override
  String get usernameLabel => 'उपयोगकर्ता नाम';

  @override
  String get locationLabel => 'वर्तमान स्थान';

  @override
  String get profileImageLabel => 'प्रोफ़ाइल छवि';

  @override
  String get chooseFileLabel => 'एक फ़ाइल चुनें';

  @override
  String get uploadBtnLabel => 'अद्यतन';

  @override
  String get uploadingBtnLabel => 'अद्यतन किया जा रहा है...';

  @override
  String get cancelBtnLabel => 'रद्द करना';

  @override
  String get productsTitle => 'उत्पादों';

  @override
  String get servicesTitle => 'सेवाएं';

  @override
  String get myProductsTitle => 'मेरे उत्पाद';

  @override
  String get myServicesTitle => 'मेरी सेवाएँ';

  @override
  String get favoriteProductsTitle => 'पसंदीदा उत्पाद';

  @override
  String get favoriteServicesTitle => 'पसंदीदा सेवाएँ';

  @override
  String get noFavorites => 'कोई पसंदीदा नहीं';

  @override
  String get addNewProductBtn => 'नया उत्पाद जोड़ें';

  @override
  String get addNew => 'नया';

  @override
  String get addNewServiceBtn => 'नई सेवा जोड़ें';

  @override
  String get downloadMobileApp => 'मोबाइल ऐप डाउनलोड करें';

  @override
  String get registerPhoneNumberSuccess =>
      'फ़ोन नंबर सत्यापित! आप अगले चरण पर आगे बढ़ सकते हैं.';

  @override
  String get regionSelectedMessage => 'क्षेत्र चयनित:';

  @override
  String get districtSelectMessage => 'जिला चयनित:';

  @override
  String get phoneNumberEmptyMessage =>
      'कृपया आगे बढ़ने से पहले अपना फ़ोन नंबर सत्यापित करें';

  @override
  String get regionEmptyMessage => 'कृपया पहले क्षेत्र का चयन करें';

  @override
  String get districtEmptyMessage => 'कृपया जिला का चयन करें';

  @override
  String get usernamePasswordEmptyMessage =>
      'कृपया उपयोगकर्ता नाम और पासवर्ड इनपुट करें';

  @override
  String get registerTitle => 'पंजीकरण करवाना';

  @override
  String get previousButton => 'पहले का';

  @override
  String get nextButton => 'अगला';

  @override
  String get completeButton => 'पूरा';

  @override
  String stepIndicator(int currentStep) {
    return '4 में से चरण $currentStep';
  }

  @override
  String get districtSelectTitle => 'जिला सूची';

  @override
  String get districtSelectParagraph => 'एक जिला चुनें:';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get sendOtp => 'ओटीपी भेजें';

  @override
  String get sendAgain => 'पुनः भेजें';

  @override
  String get verify => 'सत्यापित करें';

  @override
  String get failedToSendOtp =>
      'ओटीपी भेजने में विफल. सर्वर ने गलत रिटर्न दिया.';

  @override
  String get errorSendingOtp => 'ओटीपी भेजते समय एक त्रुटि हुई.';

  @override
  String get invalidPhoneNumber => 'एक मान्य दूरभाष क्रमांक दर्ज करे।';

  @override
  String get verificationSuccess => 'सफलतापूर्वक सत्यापित';

  @override
  String get verificationError =>
      'एक त्रुटि पाई गई। कृपया बाद में पुन: प्रयास करें।';

  @override
  String get regionsList => 'क्षेत्र सूची';

  @override
  String get enterUsername => 'अपना उपयोगकर्ता नाम दर्ज करें';

  @override
  String get welcomeMessage =>
      'Tezsell में आपका स्वागत है, अपने फ़ोन नंबर के साथ लॉग इन करें';

  @override
  String get noAccount => 'अभी तक कोई खाता नहीं? यहां रजिस्टर करें';

  @override
  String get successLogin => 'सफलतापूर्वक लॉग इन किया गया';

  @override
  String get myProfile => 'मेरी प्रोफाइल';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get newProductTitle => 'शीर्षक';

  @override
  String get newProductDescription => 'विवरण';

  @override
  String get newProductPrice => 'कीमत';

  @override
  String get newProductCondition => 'स्थिति';

  @override
  String get newProductCategory => 'वर्ग';

  @override
  String get newProductImages => 'इमेजिस';

  @override
  String get addNewService => 'नई सेवा जोड़ें';

  @override
  String get creating => 'बनाया जा रहा है...';

  @override
  String get serviceName => 'सेवा का नाम';

  @override
  String get serviceNamePlaceholder => 'सेवा शीर्षक दर्ज करें';

  @override
  String get serviceDescription => 'सेवा विवरण';

  @override
  String get serviceDescriptionPlaceholder => 'सेवा विवरण दर्ज करें';

  @override
  String get serviceCategory => 'सेवा श्रेणी';

  @override
  String get selectCategory => 'श्रेणी चुनना';

  @override
  String get loadingCategories => 'लोड हो रहा है...';

  @override
  String get errorLoadingCategories => 'श्रेणियां लोड करने में त्रुटि';

  @override
  String get serviceImages => 'सेवा छवियाँ';

  @override
  String get imageUploadHelper =>
      'छवियाँ जोड़ने के लिए + आइकन पर क्लिक करें (अधिकतम 10)';

  @override
  String get maxImagesError => 'आप अधिकतम 10 छवियाँ अपलोड कर सकते हैं';

  @override
  String get categoryNotFound => 'श्रेणी नहीं मिली';

  @override
  String get productCreatedSuccess => 'उत्पाद सफलतापूर्वक बनाया गया';

  @override
  String get productLikeSuccess => 'उत्पाद सफलतापूर्वक पसंद आया';

  @override
  String get productDislikeSuccess => 'उत्पाद सफलतापूर्वक नापसंद किया गया';

  @override
  String get errorCreatingService => 'सेवा बनाते समय त्रुटि';

  @override
  String get errorCreatingProduct => 'उत्पाद बनाते समय त्रुटि';

  @override
  String get unknownError => 'सेवा बनाते समय एक अज्ञात त्रुटि उत्पन्न हुई';

  @override
  String get submit => 'जमा करना';

  @override
  String get selectCategoryAction => 'श्रेणी चुनना';

  @override
  String get selectCondition => 'शर्त का चयन करें';

  @override
  String get sum => 'जोड़';

  @override
  String get noComments =>
      'अब तक कोई टिप्पणी नहीं। टिप्पणी करने वाले पहले बनो!';

  @override
  String get commentLikeSuccess => 'टिप्पणी सफलतापूर्वक पसंद की गई';

  @override
  String get commentLikeError => 'टिप्पणी पसंद करते समय त्रुटि';

  @override
  String get unknownErrorMessage => 'एक अज्ञात त्रुटि हुई';

  @override
  String get commentDislikeSuccess => 'टिप्पणी सफलतापूर्वक नापसंद की गई';

  @override
  String get commentDislikeError => 'टिप्पणी नापसंद करते समय त्रुटि';

  @override
  String get replyInfo => 'कृपया पहले एक उत्तर दर्ज करें';

  @override
  String get replySuccessMessage => 'उत्तर सफलतापूर्वक जोड़ा गया';

  @override
  String get replyErrorMessage => 'उत्तर बनाते समय त्रुटि हुई';

  @override
  String get commentUpdateSuccess => 'टिप्पणी सफलतापूर्वक अपडेट की गई';

  @override
  String get commentUpdateError => 'टिप्पणी आइटम अपडेट करने में त्रुटि';

  @override
  String get deleteConfirmationMessage =>
      'क्या आप इस कमेंट को मिटाने के बारे में पक्के हैं?';

  @override
  String get commentDeleteSuccess => 'टिप्पणी सफलतापूर्वक हटा दी गई';

  @override
  String get commentDeleteError => 'टिप्पणी हटाने में त्रुटि';

  @override
  String get editLabel => 'संपादन करना';

  @override
  String get deleteLabel => 'मिटाना';

  @override
  String get saveLabel => 'बचाना';

  @override
  String get replyLabel => 'जवाब';

  @override
  String get replyTitle => 'जवाब';

  @override
  String get replyPlaceholder => 'उत्तर लिखें...';

  @override
  String get chatLoginMessage => 'चैट शुरू करने के लिए आपको लॉग इन होना होगा';

  @override
  String get chatYourselfMessage => 'आप अपने आप से चैट नहीं कर सकते.';

  @override
  String get chatRoomMessage => 'चैट रूम बनाया गया!';

  @override
  String get chatRoomError => 'चैट बनाने में विफल!';

  @override
  String get chatCreationError => 'चैट निर्माण विफल!';

  @override
  String get productsTotal => 'कुल उत्पाद';

  @override
  String get perPage => 'सामान';

  @override
  String get clearAllFilters => 'सभी फ़िल्टर साफ़ करें';

  @override
  String get clickToUpload => 'अपलोड करने के लिए क्लिक करें';

  @override
  String get productInStock => 'स्टॉक में';

  @override
  String get productOutStock => 'स्टॉक ख़त्म';

  @override
  String get productBack => 'उत्पादों पर वापस जाएँ';

  @override
  String get messageSeller => 'बात करना';

  @override
  String get recommendedProducts => 'अनुशंसित उत्पाद';

  @override
  String get deleteConfirmationProduct =>
      'क्या आप वाकई इस उत्पाद को हटाना चाहते हैं?';

  @override
  String get productDeleteSuccess => 'उत्पाद सफलतापूर्वक हटा दिया गया';

  @override
  String get productDeleteError => 'उत्पाद हटाने में त्रुटि';

  @override
  String get newCondition => 'नया';

  @override
  String get used => 'इस्तेमाल किया गया';

  @override
  String get imageValidType =>
      'कुछ फ़ाइलें नहीं जोड़ी गईं. कृपया 5एमबी से कम की जेपीजी, पीएनजी, जीआईएफ या वेबपी फाइलों का उपयोग करें।';

  @override
  String get imageConfirmMessage => 'क्या आप वाकई इस छवि को हटाना चाहते हैं?';

  @override
  String get titleRequiredMessage => 'शीर्षक आवश्यक है';

  @override
  String get descRequiredMessage => 'विवरण आवश्यक है';

  @override
  String get priceRequiredMessage => 'कीमत आवश्यक है';

  @override
  String get conditionRequiredMessage => 'शर्त आवश्यक है';

  @override
  String get pleaseFillAllRequired => 'कृपया आवश्यक फ़ील्ड भरें';

  @override
  String get oneImageConfirmMessage => 'कम से कम एक उत्पाद छवि आवश्यक है';

  @override
  String get categoryRequiredMessage => 'श्रेणी आवश्यक है';

  @override
  String get locationInfoError => 'उपयोगकर्ता स्थान की जानकारी अनुपलब्ध है';

  @override
  String get editProductTitle => 'उत्पाद संपादित करें';

  @override
  String get imageUploadRequirements =>
      'कम से कम एक छवि आवश्यक है. आप अधिकतम 10 छवियाँ (JPG, PNG, GIF, WebP प्रत्येक 5MB से कम) अपलोड कर सकते हैं।';

  @override
  String get productUpdatedSuccess => 'उत्पाद सफलतापूर्वक अपडेट किया गया';

  @override
  String get productUpdateFailed => 'उत्पाद अद्यतन विफल रहा';

  @override
  String get errorUpdatingProduct =>
      'उत्पाद को अद्यतन करते समय त्रुटि उत्पन्न हुई';

  @override
  String get serviceBack => 'सेवाओं पर वापस जाएँ';

  @override
  String get likeLabel => 'पसंद';

  @override
  String get commentsLabel => 'टिप्पणियाँ';

  @override
  String get writeComment => 'एक टिप्पणी लिखें ...';

  @override
  String get postingLabel => 'पोस्ट किया जा रहा है...';

  @override
  String get commentCreated => 'टिप्पणी बनाई गई';

  @override
  String get postCommentLabel => 'तेज़ी से टिप्पणी करना';

  @override
  String get loginPrompt => 'टिप्पणी देखने और पोस्ट करने के लिए लॉगिन करें।';

  @override
  String get recommendedServices => 'अनुशंसित सेवाएँ';

  @override
  String get commentsVisibilityNotice =>
      'टिप्पणियाँ केवल लॉग-इन उपयोगकर्ताओं को दिखाई देती हैं।';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get serviceUpdateSuccess => 'सेवा सफलतापूर्वक अपडेट की गई';

  @override
  String get serviceUpdateError => 'सेवा आइटम अद्यतन करने में त्रुटि';

  @override
  String get editServiceModalTitle => 'सेवा संपादित करें';

  @override
  String get enterPhoneNumberWithoutCode => 'बिना कोड के फ़ोन नंबर दर्ज करें';

  @override
  String get heroTitle => 'तेज़सेल';

  @override
  String get heroSubtitle => 'उज़्बेकिस्तान के लिए आपका तेज़ और आसान बाज़ार';

  @override
  String get startSelling => 'बेचना शुरू करें';

  @override
  String get browseProducts => 'उत्पाद ब्राउज़ करें';

  @override
  String get featuresTitle => 'TezSell क्यों चुनें?';

  @override
  String get listingTitle => 'सरल उत्पाद सूचीकरण';

  @override
  String get listingDescription =>
      'बस कुछ ही क्लिक में अपने आइटम सूचीबद्ध करें। फ़ोटो जोड़ें, अपनी कीमत निर्धारित करें और खरीदारों से तुरंत जुड़ें।';

  @override
  String get locationTitle => 'स्थान-आधारित ब्राउज़िंग';

  @override
  String get locationDescription =>
      'अपने आस-पास सौदे खोजें। हमारी स्थान-आधारित प्रणाली आपके पड़ोस में वस्तुओं को खोजने में आपकी सहायता करती है।';

  @override
  String get location_subtitle =>
      'आस-पास की सूचियाँ देखने के लिए अपना क्षेत्र और जिला चुनें';

  @override
  String get categoryTitle => 'श्रेणी फ़िल्टरिंग';

  @override
  String get categoryDescription =>
      'आप जो खोज रहे हैं उसे ढूंढने के लिए विभिन्न श्रेणियों में आसानी से नेविगेट करें।';

  @override
  String get inspirationTitle => 'कोरिया के गाजर बाजार से प्रेरित';

  @override
  String get inspirationDescription1 =>
      'हमने कोरिया के सफल गाजर बाजार (당근마켓) से प्रेरणा लेकर TezSell का निर्माण किया है, लेकिन इसे विशेष रूप से उज़्बेकिस्तान के स्थानीय समुदायों की अनूठी जरूरतों को पूरा करने के लिए तैयार किया है।';

  @override
  String get inspirationDescription2 =>
      'हमारा मिशन एक भरोसेमंद मंच बनाना है जहां पड़ोसी आसानी से खरीद, बिक्री और एक-दूसरे से जुड़ सकें।';

  @override
  String get comingSoonTitle => 'TezSell पर जल्द ही आ रहा है';

  @override
  String get inAppChat => 'इन-ऐप चैट';

  @override
  String get secureTransactions => 'सुरक्षित लेनदेन';

  @override
  String get realEstateListings => 'रियल एस्टेट लिस्टिंग';

  @override
  String get stayUpdated => 'अपडेट रहें';

  @override
  String get comingSoonBadge => 'जल्द आ रहा है';

  @override
  String get ctaTitle => 'आज ही TezSell समुदाय से जुड़ें!';

  @override
  String get ctaDescription =>
      'उज़्बेकिस्तान के लिए बेहतर बाज़ार अनुभव के निर्माण का हिस्सा बनें। अपनी प्रतिक्रिया साझा करें और हमें आगे बढ़ने में मदद करें!';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get learnMore => 'और अधिक जानें';

  @override
  String get replyUpdateSuccess => 'उत्तर सफलतापूर्वक अपडेट किया गया';

  @override
  String get replyUpdateError => 'उत्तर अद्यतन करने में विफल';

  @override
  String get replyDeleteSuccess => 'उत्तर सफलतापूर्वक हटा दिया गया';

  @override
  String get replyDeleteError => 'उत्तर हटाने में विफल';

  @override
  String get replyDeleteConfirmation =>
      'क्या आपको निश्चित है की आप यह उत्तर मिटाना चाहतें हैं।';

  @override
  String get authenticationRequired => 'प्रमाणित करना';

  @override
  String get enterValidReply => 'कृपया एक वैध उत्तर पाठ दर्ज करें';

  @override
  String get saving => 'सहेजा जा रहा है...';

  @override
  String get deleting => 'हटाया जा रहा है...';

  @override
  String get properties => 'गुण';

  @override
  String get agents => 'एजेंटों';

  @override
  String get becomeAgent => 'एक एजेंट बनें';

  @override
  String get main => 'मुख्य';

  @override
  String get upload => 'अपलोड करें';

  @override
  String get filtered_products => 'फ़िल्टर किए गए उत्पाद';

  @override
  String get filtered_services => 'फ़िल्टर की गई सेवाएँ';

  @override
  String get productDetail => 'उत्पाद विवरण';

  @override
  String get unknownUser => 'अज्ञात उपयोगकर्ता';

  @override
  String get locationNotAvailable => 'स्थान उपलब्ध नहीं है';

  @override
  String get noTitle => 'कोई शीर्षक नहीं';

  @override
  String get noCategory => 'कोई श्रेणी नहीं';

  @override
  String get noDescription => 'कोई विवरण नहीं';

  @override
  String get som => 'सोम';

  @override
  String get about_me => 'मेरे बारे में';

  @override
  String get my_name => 'मेरा नाम';

  @override
  String get customer_support => 'ग्राहक सहेयता';

  @override
  String get customer_center => 'ग्राहक केंद्र';

  @override
  String get customer_inquiries => 'पूछताछ';

  @override
  String get customer_terms => 'नियम और शर्तें';

  @override
  String get region => 'क्षेत्र';

  @override
  String get district => 'ज़िला';

  @override
  String get tap_change_profile => 'फ़ोटो बदलने के लिए टैप करें';

  @override
  String get language_settings => 'भाषा सेटिंग्स';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get select_theme => 'थीम चुनें';

  @override
  String get theme => 'विषय';

  @override
  String get location_settings => 'स्थान सेटिंग्स';

  @override
  String get security => 'सुरक्षा';

  @override
  String get data_storage => 'आधार सामग्री भंडारण';

  @override
  String get accessibility => 'सरल उपयोग';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get light_theme => 'रोशनी';

  @override
  String get dark_theme => 'अँधेरा';

  @override
  String get system_theme => 'प्रणालीगत चूक';

  @override
  String get my_products => 'मेरे उत्पाद';

  @override
  String get refresh => 'ताज़ा करना';

  @override
  String get delete_product => 'उत्पाद हटाएँ';

  @override
  String get delete_confirmation =>
      'क्या आप वाकई इस उत्पाद को हटाना चाहते हैं?';

  @override
  String get delete => 'मिटाना';

  @override
  String error_loading_products(String error) {
    return 'उत्पाद लोड करने में त्रुटि: $error';
  }

  @override
  String get product_deleted_success => 'उत्पाद सफलतापूर्वक हटा दिया गया';

  @override
  String error_deleting_product(String error) {
    return 'उत्पाद हटाने में त्रुटि: $error';
  }

  @override
  String get no_products_found => 'कोई उत्पाद नहीं मिला';

  @override
  String get add_first_product => 'अपना पहला उत्पाद जोड़कर प्रारंभ करें';

  @override
  String get no_title => 'कोई शीर्षक नहीं';

  @override
  String get no_description => 'कोई विवरण नहीं';

  @override
  String get in_stock => 'स्टॉक में';

  @override
  String get out_of_stock => 'स्टॉक ख़त्म';

  @override
  String get new_condition => 'नया';

  @override
  String get edit_product => 'उत्पाद संपादित करें';

  @override
  String get delete_product_tooltip => 'उत्पाद हटाएँ';

  @override
  String get sum_currency => 'जोड़';

  @override
  String get edit_product_title => 'उत्पाद संपादित करें';

  @override
  String get product_name => 'प्रोडक्ट का नाम';

  @override
  String get product_description => 'उत्पाद वर्णन';

  @override
  String get price => 'कीमत';

  @override
  String get condition => 'स्थिति';

  @override
  String get condition_new => 'नया';

  @override
  String get condition_like_new => 'लगभग नया';

  @override
  String get condition_used => 'इस्तेमाल किया गया';

  @override
  String get condition_refurbished => 'ठीक करके नए जैसा बनाया गया';

  @override
  String get currency => 'मुद्रा';

  @override
  String get category => 'वर्ग';

  @override
  String get images => 'इमेजिस';

  @override
  String get existing_images => 'मौजूदा छवियाँ';

  @override
  String get new_images => 'नई छवियां';

  @override
  String get image_instructions =>
      'छवियां यहां दिखाई देंगी. कृपया ऊपर अपलोड आइकन दबाएं।';

  @override
  String get update_button => 'अद्यतन';

  @override
  String loading_category_error(String error) {
    return 'श्रेणियाँ लोड करने में त्रुटि: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'छवियाँ चुनने में त्रुटि: $error';
  }

  @override
  String get please_fill_all_required => 'कृपया सभी फ़ील्ड भरें';

  @override
  String get invalid_price_message =>
      'अमान्य मूल्य दर्ज किया गया. कृपया सही अंक दर्ज करें।';

  @override
  String get category_required_message => 'कृपया एक मान्य श्रेणी चुनें.';

  @override
  String get one_image_required_message => 'कम से कम एक उत्पाद छवि आवश्यक है';

  @override
  String get product_updated_success => 'उत्पाद सफलतापूर्वक अद्यतन किया गया';

  @override
  String error_updating_product(String error) {
    return 'उत्पाद अद्यतन करते समय त्रुटि: $error';
  }

  @override
  String get my_services => 'मेरी सेवाएँ';

  @override
  String get delete_service => 'सेवा हटाएँ';

  @override
  String get delete_service_confirmation =>
      'क्या आप वाकई इस सेवा को हटाना चाहते हैं?';

  @override
  String get no_services_found => 'कोई सेवा नहीं मिली';

  @override
  String get add_first_service => 'अपनी पहली सेवा जोड़कर प्रारंभ करें';

  @override
  String get edit_service => 'सेवा संपादित करें';

  @override
  String get delete_service_tooltip => 'सेवा हटाएँ';

  @override
  String get service_deleted_successfully => 'सेवा सफलतापूर्वक हटा दी गई';

  @override
  String get error_deleting_service => 'सेवा हटाने में त्रुटि';

  @override
  String get error_loading_services => 'सेवाएँ लोड करने में त्रुटि';

  @override
  String get service_name => 'सेवा का नाम';

  @override
  String get enter_service_name => 'सेवा का नाम दर्ज करें';

  @override
  String get service_name_required => 'सेवा का नाम आवश्यक है';

  @override
  String get service_name_min_length =>
      'सेवा का नाम कम से कम 3 अक्षर का होना चाहिए';

  @override
  String get enter_service_description => 'सेवा विवरण दर्ज करें';

  @override
  String get service_description_required => 'सेवा विवरण आवश्यक है';

  @override
  String get service_description_min_length =>
      'विवरण कम से कम 10 अक्षर का होना चाहिए';

  @override
  String get category_required => 'कृपया एक कैटेगरी चयनित करें';

  @override
  String get no_categories_available => 'कोई श्रेणियां उपलब्ध नहीं';

  @override
  String get location => 'जगह';

  @override
  String get select_location => 'स्थान चुनें';

  @override
  String get location_required => 'कृपया एक स्थान चुनें';

  @override
  String get no_locations_available => 'कोई स्थान उपलब्ध नहीं है';

  @override
  String get add_images => 'छवियां जोड़ें';

  @override
  String get current_images => 'वर्तमान छवियाँ';

  @override
  String get no_images_selected => 'कोई चित्र चयनित नहीं';

  @override
  String get save_changes => 'परिवर्तनों को सुरक्षित करें';

  @override
  String get map_main => 'मानचित्र एवं गुण';

  @override
  String get agent_status => 'एजेंट की स्थिति';

  @override
  String get admin_panel => 'व्यवस्थापक पैनल';

  @override
  String get propertiesFound => 'गुण मिले';

  @override
  String get propertiesSaved => 'गुण सहेजे गए';

  @override
  String get saved => 'बचाया';

  @override
  String get loadingProperties => 'गुण लोड हो रहे हैं...';

  @override
  String get failedToLoad => 'गुण लोड करने में विफल. कृपया पुन: प्रयास करें।';

  @override
  String get noPropertiesFound => 'कोई संपत्ति नहीं मिली';

  @override
  String get tryAdjusting => 'अपने खोज मानदंड को समायोजित करने का प्रयास करें';

  @override
  String get search_placeholder => 'शीर्षक या स्थान के आधार पर खोजें...';

  @override
  String get search_filters => 'फिल्टर';

  @override
  String get search_button => 'खोज';

  @override
  String get search_clear_filters => 'फ़िल्टर साफ़ करें';

  @override
  String get filter_options_sale_and_rent => 'बिक्री और किराया';

  @override
  String get filter_options_for_sale => 'बिक्री के लिए';

  @override
  String get filter_options_for_rent => 'किराए के लिए';

  @override
  String get filter_options_all_types => 'सभी प्रकार';

  @override
  String get filter_options_apartment => 'अपार्टमेंट';

  @override
  String get filter_options_house => 'घर';

  @override
  String get filter_options_townhouse => 'टाउनहाउस';

  @override
  String get filter_options_villa => 'विला';

  @override
  String get filter_options_commercial => 'व्यावसायिक';

  @override
  String get filter_options_office => 'कार्यालय';

  @override
  String get property_card_featured => 'प्रदर्शित';

  @override
  String get property_card_bed => 'सोने का कमरा';

  @override
  String get property_card_bath => 'स्नानघर';

  @override
  String get property_card_parking => 'पार्किंग';

  @override
  String get property_card_view_details => 'विवरण देखें';

  @override
  String get property_card_contact => 'संपर्क';

  @override
  String get property_card_balcony => 'बालकनी';

  @override
  String get property_card_garage => 'गैरेज';

  @override
  String get property_card_garden => 'बगीचा';

  @override
  String get property_card_pool => 'पूल';

  @override
  String get property_card_elevator => 'लिफ़्ट';

  @override
  String get property_card_furnished => 'सुसज्जित';

  @override
  String get property_card_sales => 'बिक्री';

  @override
  String get pricing_month => '/महीना';

  @override
  String get results_properties_found => 'गुण मिले';

  @override
  String get results_properties_saved => 'गुण सहेजे गए';

  @override
  String get results_saved => 'बचाया';

  @override
  String get results_loading_properties => 'गुण लोड हो रहे हैं...';

  @override
  String get results_failed_to_load =>
      'गुण लोड करने में विफल. कृपया पुन: प्रयास करें।';

  @override
  String get results_no_properties_found => 'कोई संपत्ति नहीं मिली';

  @override
  String get results_try_adjusting =>
      'अपने खोज मानदंड को समायोजित करने का प्रयास करें';

  @override
  String get no_properties_found => 'कोई संपत्ति नहीं मिली';

  @override
  String get no_category_properties => 'इस श्रेणी में कोई संपत्ति नहीं है';

  @override
  String get properties_loading => 'गुण लोड हो रहे हैं...';

  @override
  String get all_properties_loaded => 'सभी संपत्तियां लोड हो गईं';

  @override
  String n_properties(int count) {
    return '$count गुण';
  }

  @override
  String get in_area => 'क्षेत्र में';

  @override
  String get realEstateSearchHint => 'Search properties by title, location...';

  @override
  String get realEstateSearchPrompt => 'Search for properties';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearRecentSearches => 'Clear all';

  @override
  String get searchPropertiesError =>
      'Failed to search properties. Please try again.';

  @override
  String get pagination_previous => 'पहले का';

  @override
  String get pagination_next => 'अगला';

  @override
  String get pagination_page => 'पेज';

  @override
  String get pagination_page_of => 'का पृष्ठ 1';

  @override
  String get contact_modal_title => 'संपर्क जानकारी';

  @override
  String get contact_modal_agent_contact => 'एजेंट संपर्क';

  @override
  String get contact_modal_property_owner => 'संपत्ति का स्वामी';

  @override
  String get contact_modal_agent_phone_number => 'एजेंट का फ़ोन नंबर';

  @override
  String get contact_modal_owner_phone_number => 'मालिक का फ़ोन नंबर';

  @override
  String get contact_modal_license => 'लाइसेंस';

  @override
  String get contact_modal_rating => 'रेटिंग';

  @override
  String get contact_modal_call_now => 'अब कॉल करें';

  @override
  String get contact_modal_copy_number => 'नंबर कॉपी करें';

  @override
  String get contact_modal_close => 'बंद करना';

  @override
  String get contact_modal_contact_hours =>
      'संपर्क का समय: सुबह 9:00 बजे से रात 8:00 बजे तक';

  @override
  String get contact_modal_agent => 'प्रतिनिधि';

  @override
  String get errors_toggle_save_failed =>
      'संपत्ति सहेजने का टॉगल करने में विफल:';

  @override
  String get errors_copy_failed => 'फ़ोन नंबर कॉपी करने में विफल:';

  @override
  String get errors_phone_copied => 'फ़ोन नंबर क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get errors_error_occurred_regions =>
      'क्षेत्रों के साथ एक त्रुटि उत्पन्न हुई';

  @override
  String get errors_error_occurred_districts =>
      'जिलों के साथ एक त्रुटि उत्पन्न हुई';

  @override
  String get errors_please_fill_all_required_fields =>
      'कृपया सभी आवश्यक फ़ील्ड भरें';

  @override
  String get errors_authentication_required => 'प्रमाणित करना';

  @override
  String get errors_user_info_missing => 'उपयोगकर्ता की जानकारी अनुपलब्ध है';

  @override
  String get errors_validation_error => 'कृपया अपना इनपुट डेटा जांचें';

  @override
  String get errors_permission_denied => 'अनुमति नहीं मिली';

  @override
  String get errors_server_error => 'सर्वर त्रुटि उत्पन्न हुई';

  @override
  String get errors_network_error => 'नेटवर्क कनेक्शन त्रुटि';

  @override
  String get errors_timeout_error => 'अनुरोध का समय समाप्त हो गया';

  @override
  String get errors_custom_error => 'एक त्रुटि पाई गई';

  @override
  String get errors_error_creating_property => 'संपत्ति बनाने में त्रुटि';

  @override
  String get errors_unknown_error_message => 'एक अज्ञात त्रुटि हुई';

  @override
  String get errors_coordinates_not_found =>
      'इस पते के लिए निर्देशांक नहीं मिल सके. कृपया उन्हें मैन्युअल रूप से दर्ज करें.';

  @override
  String get errors_coordinates_error =>
      'निर्देशांक प्राप्त करने में त्रुटि. कृपया उन्हें मैन्युअल रूप से दर्ज करें.';

  @override
  String get property_info_views => 'दृश्य';

  @override
  String get property_info_listed => 'सूचीबद्ध';

  @override
  String get property_info_price_per_sqm => '/वर्गमीटर';

  @override
  String get property_info_saved => 'सहेजा गया';

  @override
  String get property_info_save => 'बचाना';

  @override
  String get property_info_share => 'शेयर करना';

  @override
  String get loading_loading => 'लोड हो रहा है...';

  @override
  String get loading_loading_details => 'संपत्ति विवरण लोड हो रहा है...';

  @override
  String get loading_property_not_found => 'संपत्ति नहीं मिली';

  @override
  String get loading_property_not_found_message =>
      'आप जिस संपत्ति की तलाश कर रहे हैं वह मौजूद नहीं है या हटा दी गई है।';

  @override
  String get loading_back_to_properties => 'गुण पर वापस जाएँ';

  @override
  String get loading_title => 'एजेंट लोड हो रहे हैं...';

  @override
  String get loading_message =>
      'कृपया तब तक प्रतीक्षा करें जब तक हम एजेंटों की सूची लोड नहीं कर देते।';

  @override
  String get loading_agent_not_found => 'एजेंट नहीं मिला';

  @override
  String get property_details_title => 'संपत्ति ब्यौरा';

  @override
  String get property_details_bedrooms => 'बेडरूम';

  @override
  String get property_details_bathrooms => 'बाथरूम';

  @override
  String get property_details_floor_area => 'फर्श क्षेत्र';

  @override
  String get property_details_parking => 'पार्किंग';

  @override
  String get property_details_basic_information => 'मूल जानकारी';

  @override
  String get property_details_property_type => 'सम्पत्ती के प्रकार:';

  @override
  String get property_details_listing_type => 'लिस्टिंग प्रकार:';

  @override
  String get property_details_for_sale => 'बिक्री के लिए';

  @override
  String get property_details_for_rent => 'किराए के लिए';

  @override
  String get property_details_year_built => 'निर्माण वर्ष:';

  @override
  String get property_details_floor => 'ज़मीन:';

  @override
  String get property_details_of => 'का';

  @override
  String get property_details_features_amenities => 'सुविधाएँ एवं सुविधाएँ';

  @override
  String get sections_description => 'विवरण';

  @override
  String get sections_nearby_amenities => 'आस-पास की सुविधाएं';

  @override
  String get sections_similar_properties => 'समान गुण';

  @override
  String get amenities_metro => 'मेट्रो';

  @override
  String get amenities_school => 'विद्यालय';

  @override
  String get amenities_hospital => 'अस्पताल';

  @override
  String get amenities_shopping => 'खरीदारी';

  @override
  String get amenities_away => 'दूर';

  @override
  String get contact_title => 'संपर्क जानकारी';

  @override
  String get contact_professional_listing => 'व्यावसायिक सूचीकरण';

  @override
  String get contact_listed_by_agent => 'सत्यापित एजेंट द्वारा सूचीबद्ध';

  @override
  String get contact_by_owner => 'स्वामी द्वारा';

  @override
  String get contact_direct_contact => 'संपत्ति के मालिक से सीधा संपर्क';

  @override
  String get contact_property_owner => 'संपत्ति का स्वामी';

  @override
  String get contact_call_agent => 'एजेंट को बुलाओ';

  @override
  String get contact_email_agent => 'ईमेल एजेंट';

  @override
  String get contact_call_owner => 'मालिक को बुलाओ';

  @override
  String get contact_email_owner => 'ईमेल स्वामी';

  @override
  String get contact_send_inquiry => 'जांच भेजें';

  @override
  String get property_status_title => 'संपत्ति की स्थिति';

  @override
  String get property_status_availability => 'उपलब्धता:';

  @override
  String get property_status_available => 'उपलब्ध';

  @override
  String get property_status_not_available => 'उपलब्ध नहीं है';

  @override
  String get property_status_featured => 'विशेष रुप से प्रदर्शित:';

  @override
  String get property_status_featured_property => 'प्रदर्शित संपत्ति';

  @override
  String get property_status_property_id => 'संपत्ति आईडी:';

  @override
  String get inquiry_title => 'जांच भेजें';

  @override
  String get inquiry_inquiry_type => 'पूछताछ का प्रकार';

  @override
  String get inquiry_request_info => 'जानकारी के लिए अनुरोध करे';

  @override
  String get inquiry_schedule_viewing => 'शेड्यूल देखना';

  @override
  String get inquiry_make_offer => 'प्रस्ताव देना';

  @override
  String get inquiry_request_callback => 'कॉलबैक का अनुरोध करें';

  @override
  String get inquiry_message => 'संदेश';

  @override
  String get inquiry_message_placeholder =>
      'हमें इस संपत्ति में अपनी रुचि के बारे में बताएं...';

  @override
  String get inquiry_offered_price => 'प्रस्तावित मूल्य';

  @override
  String get inquiry_enter_offer => 'अपना प्रस्ताव दर्ज करें';

  @override
  String get inquiry_preferred_contact_time => 'पसंदीदा संपर्क समय (वैकल्पिक)';

  @override
  String get inquiry_contact_time_placeholder =>
      'उदाहरण के लिए, सप्ताह के दिनों में सुबह 9:00 बजे से शाम 5:00 बजे तक';

  @override
  String get inquiry_cancel => 'रद्द करना';

  @override
  String get inquiry_sending => 'भेजा जा रहा है...';

  @override
  String get inquiry_send_inquiry => 'जांच भेजें';

  @override
  String get inquiry_inquiry_sent_success => 'जांच सफलतापूर्वक भेजी गई!';

  @override
  String get inquiry_inquiry_sent_error =>
      'पूछताछ भेजने में विफल. कृपया पुन: प्रयास करें।';

  @override
  String get alerts_link_copied =>
      'प्रॉपर्टी लिंक को क्लिपबोर्ड पर कॉपी किया गया!';

  @override
  String get alerts_phone_copied => 'फ़ोन नंबर क्लिपबोर्ड पर कॉपी किया गया!';

  @override
  String get alerts_save_property_failed => 'संपत्ति बचाने में विफल:';

  @override
  String get alerts_email_subject => 'इसके बारे में पूछताछ:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'नमस्ते,\\n\\nमुझे $address पर स्थित आपकी संपत्ति \"$title\" में दिलचस्पी है।\\n\\nअधिक जानकारी के लिए कृपया मुझसे संपर्क करें।\\n\\nसादर';
  }

  @override
  String get related_properties_view_details => 'विवरण देखें';

  @override
  String get header_property => 'अपने सपनों की संपत्ति खोजें';

  @override
  String get header_sub_property =>
      'ताशकंद के सबसे वांछनीय पड़ोस में प्रीमियम रियल एस्टेट के अवसरों की खोज करें';

  @override
  String get header_title => 'रियल एस्टेट एजेंट';

  @override
  String get header_subtitle =>
      'अपनी रियल एस्टेट जरूरतों में मदद के लिए अनुभवी एजेंट खोजें';

  @override
  String get header_agents_found => 'एजेंट मिल गए';

  @override
  String get filters_all_specializations => 'सभी विशेषज्ञता';

  @override
  String get filters_residential => 'आवासीय';

  @override
  String get filters_commercial => 'व्यावसायिक';

  @override
  String get filters_luxury => 'विलासिता';

  @override
  String get filters_investment => 'निवेश';

  @override
  String get filters_any_rating => 'कोई भी रेटिंग';

  @override
  String get filters_four_stars => '4+ सितारे';

  @override
  String get filters_four_half_stars => '4.5+ सितारे';

  @override
  String get filters_five_stars => '5 सितारे';

  @override
  String get filters_highest_rated => 'उच्चतम रेटेड';

  @override
  String get filters_lowest_rated => 'सबसे कम रेटिंग';

  @override
  String get filters_most_sales => 'सर्वाधिक बिक्री';

  @override
  String get filters_most_experience => 'सर्वाधिक अनुभव';

  @override
  String get agent_card_verified_agent => 'सत्यापित एजेंट';

  @override
  String get agent_card_years_experience => 'वर्षों का अनुभव';

  @override
  String get agent_card_years => 'साल';

  @override
  String get agent_card_license => 'लाइसेंस';

  @override
  String get agent_card_specialization => 'विशेषज्ञता';

  @override
  String get agent_card_view_profile => 'प्रोफ़ाइल देखें';

  @override
  String get agent_card_contact => 'संपर्क';

  @override
  String get agent_card_verified => 'सत्यापित';

  @override
  String get no_results_title => 'कोई एजेंट नहीं मिला';

  @override
  String get no_results_message =>
      'अपने खोज मानदंड या फ़िल्टर को समायोजित करने का प्रयास करें।';

  @override
  String get error_title => 'एजेंट लोड करने में त्रुटि';

  @override
  String get error_message =>
      'एजेंट सूची लोड करने में विफल. कृपया पुन: प्रयास करें।';

  @override
  String get error_retry => 'पुन: प्रयास करें';

  @override
  String get error_default_message => 'एजेंट विवरण लोड करने में विफल';

  @override
  String get error_try_again => 'पुनः प्रयास करें';

  @override
  String get notifications_phone_copied =>
      'फ़ोन नंबर क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get notifications_copy_failed => 'फ़ोन नंबर कॉपी करने में विफल:';

  @override
  String get fallback_agent_name => 'प्रतिनिधि';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'संपत्ति जमा करें';

  @override
  String get navigation_submitting => 'सबमिट किया जा रहा है...';

  @override
  String get navigation_back_to_agents => 'एजेंटों के पास वापस जाएँ';

  @override
  String get agent_profile_verified_agent => 'सत्यापित एजेंट';

  @override
  String get agent_profile_contact_agent => 'एजेंट से संपर्क करें';

  @override
  String get agent_profile_send_message => 'मेसेज भेजें';

  @override
  String get agent_profile_years_experience => 'वर्षों का अनुभव';

  @override
  String get agent_profile_properties_sold => 'संपत्तियां बिक गईं';

  @override
  String get agent_profile_active_listings => 'सक्रिय सूचियाँ';

  @override
  String get agent_profile_total_properties => 'कुल गुण';

  @override
  String get tabs_overview => 'सिंहावलोकन';

  @override
  String get tabs_properties => 'गुण';

  @override
  String get tabs_reviews => 'समीक्षा';

  @override
  String get about_agent_title => 'एजेंट के बारे में';

  @override
  String get about_agent_agency => 'एजेंसी';

  @override
  String get about_agent_license_number => 'लाइसेंस संख्या';

  @override
  String get about_agent_specialization => 'विशेषज्ञता';

  @override
  String get about_agent_member_since => 'से सदस्य';

  @override
  String get about_agent_verified_since => 'तब से सत्यापित';

  @override
  String get performance_metrics_title => 'प्रदर्शन मेट्रिक्स';

  @override
  String get performance_metrics_average_rating => 'औसत श्रेणी';

  @override
  String get performance_metrics_properties_sold => 'संपत्तियां बिक गईं';

  @override
  String get performance_metrics_active_listings => 'सक्रिय सूचियाँ';

  @override
  String get performance_metrics_years_experience => 'वर्षों का अनुभव';

  @override
  String get contact_info_title => 'संपर्क जानकारी';

  @override
  String get contact_info_contact_via_platform =>
      'प्लेटफ़ॉर्म के माध्यम से संपर्क करें';

  @override
  String get verification_status_title => 'सत्यापन स्थिति';

  @override
  String get verification_status_verified_agent => 'सत्यापित एजेंट';

  @override
  String get verification_status_pending_verification => 'सत्यापन लंबित है';

  @override
  String get verification_status_licensed_professional =>
      'लाइसेंस प्राप्त पेशेवर';

  @override
  String get verification_status_registered_agency => 'पंजीकृत एजेंसी';

  @override
  String get quick_actions_title => 'त्वरित कार्रवाई';

  @override
  String get quick_actions_call_now => 'अब कॉल करें';

  @override
  String get quick_actions_send_message => 'मेसेज भेजें';

  @override
  String get quick_actions_view_properties => 'गुण देखें';

  @override
  String get properties_title => 'एजेंट गुण';

  @override
  String get properties_loading_properties => 'गुण लोड हो रहे हैं...';

  @override
  String get properties_no_properties_title => 'कोई गुण नहीं मिला';

  @override
  String get properties_no_properties_message =>
      'इस एजेंट की संपत्तियां यहां दिखाई देंगी.';

  @override
  String get properties_recent_properties_note =>
      'हाल की संपत्तियाँ दिखा रहा हूँ. सभी एजेंट संपत्तियों की पूरी सूची देखें।';

  @override
  String get properties_listed => 'सूचीबद्ध';

  @override
  String get properties_bed => 'बिस्तर';

  @override
  String get properties_bath => 'नहाना';

  @override
  String get properties_for_sale => 'बिक्री के लिए';

  @override
  String get properties_for_rent => 'किराए के लिए';

  @override
  String get reviews_title => 'ग्राहक समीक्षाएँ';

  @override
  String get reviews_no_reviews_title => 'अभी तक कोई समीक्षा नहीं';

  @override
  String get reviews_no_reviews_message =>
      'ग्राहकों की समीक्षाएं और अनुशंसाएं यहां दिखाई देंगी.';

  @override
  String get fallbacks_agent_name => 'प्रतिनिधि';

  @override
  String get fallbacks_default_profile_image => '/डिफ़ॉल्ट-अवतार.png';

  @override
  String get saved_properties_title => 'सहेजे गए गुण';

  @override
  String get saved_properties_subtitle =>
      'आपकी पसंदीदा संपत्तियाँ एक ही स्थान पर';

  @override
  String get saved_properties_no_saved_properties =>
      'अभी तक कोई सहेजी गई संपत्ति नहीं';

  @override
  String get saved_properties_start_saving =>
      'अपनी पसंद की संपत्तियों को खोजना और सहेजना शुरू करें';

  @override
  String get saved_properties_browse_properties => 'गुण ब्राउज़ करें';

  @override
  String get saved_properties_saved_on => 'पर सहेजा गया';

  @override
  String get auth_login_required =>
      'कृपया सहेजी गई संपत्तियों को देखने के लिए लॉग इन करें';

  @override
  String get auth_login => 'लॉग इन करें';

  @override
  String get success_property_unsaved =>
      'संपत्ति को सहेजी गई सूची से हटा दिया गया';

  @override
  String get success_property_saved => 'संपत्ति सफलतापूर्वक सहेजी गई';

  @override
  String get success_phone_copied => 'फ़ोन नंबर कॉपी किया गया!';

  @override
  String get success_property_created_success => 'संपत्ति सफलतापूर्वक बनाई गई!';

  @override
  String get success_agent_approved => 'एजेंट सफलतापूर्वक स्वीकृत हुआ';

  @override
  String get success_agent_rejected => 'एजेंट ने सफलतापूर्वक अस्वीकार कर दिया';

  @override
  String get steps_step => 'कदम';

  @override
  String get steps_basic_information => 'मूल जानकारी';

  @override
  String get steps_location_details => 'स्थान विवरण';

  @override
  String get steps_property_details => 'संपत्ति ब्यौरा';

  @override
  String get steps_property_images => 'संपत्ति छवियाँ';

  @override
  String get basic_info_tell_us_about_property =>
      'हमें अपनी संपत्ति के बारे में बताएं';

  @override
  String get basic_info_property_type => 'सम्पत्ती के प्रकार';

  @override
  String get basic_info_listing_type => 'लिस्टिंग प्रकार';

  @override
  String get basic_info_property_title => 'संपत्ति का शीर्षक';

  @override
  String get basic_info_title_placeholder =>
      'अपनी संपत्ति के लिए एक वर्णनात्मक शीर्षक दर्ज करें';

  @override
  String get basic_info_description => 'विवरण';

  @override
  String get basic_info_description_placeholder =>
      'अपनी संपत्ति का विस्तार से वर्णन करें...';

  @override
  String get property_types_apartment => 'अपार्टमेंट';

  @override
  String get property_types_house => 'घर';

  @override
  String get property_types_townhouse => 'टाउनहाउस';

  @override
  String get property_types_villa => 'विला';

  @override
  String get property_types_commercial => 'व्यावसायिक';

  @override
  String get property_types_office => 'कार्यालय';

  @override
  String get property_types_land => 'भूमि';

  @override
  String get property_types_warehouse => 'गोदाम';

  @override
  String get listing_types_for_sale => 'बिक्री के लिए';

  @override
  String get listing_types_for_rent => 'किराए के लिए';

  @override
  String get location_where_is_property => 'आपकी संपत्ति कहाँ स्थित है?';

  @override
  String get location_full_address => 'पूरा पता';

  @override
  String get location_address_placeholder => 'पूरा पता दर्ज करें';

  @override
  String get location_region => 'क्षेत्र';

  @override
  String get location_select_region => 'क्षेत्र का चयन करें';

  @override
  String get location_district => 'ज़िला';

  @override
  String get location_select_district => 'जिला चुनें';

  @override
  String get location_city => 'शहर';

  @override
  String get location_city_placeholder => 'शहर';

  @override
  String get location_loading_regions => 'क्षेत्र लोड हो रहे हैं...';

  @override
  String get location_loading_districts => 'जिले लोड हो रहे हैं...';

  @override
  String get location_map_coordinates => 'मानचित्र निर्देशांक';

  @override
  String get location_get_coordinates => 'निर्देशांक प्राप्त करें';

  @override
  String get location_latitude => 'अक्षांश';

  @override
  String get location_longitude => 'देशान्तर';

  @override
  String get location_coordinates_set => 'निर्देशांक सेट';

  @override
  String get location_location_tips => 'स्थान युक्तियाँ';

  @override
  String get location_location_tip_1 =>
      '• पहले पता भरें, फिर स्वचालित रूप से मानचित्र स्थान प्राप्त करने के लिए \'निर्देशांक प्राप्त करें\' पर क्लिक करें';

  @override
  String get location_location_tip_2 =>
      '• यदि आप सटीक स्थान जानते हैं तो आप मैन्युअल रूप से निर्देशांक भी दर्ज कर सकते हैं';

  @override
  String get location_location_tip_3 =>
      '• सटीक निर्देशांक खरीदारों को मानचित्र पर आपकी संपत्ति ढूंढने में मदद करते हैं';

  @override
  String get property_details_provide_detailed_info =>
      'अपनी संपत्ति के बारे में विस्तृत जानकारी प्रदान करें';

  @override
  String get property_details_total_floors => 'कुल मंजिलें';

  @override
  String get property_details_area_m2 => 'क्षेत्रफल (एम²)';

  @override
  String get property_details_parking_spaces => 'पार्किंग के स्थान';

  @override
  String get property_details_price => 'कीमत';

  @override
  String get property_details_features => 'विशेषताएँ';

  @override
  String get images_add_photos_showcase =>
      'अपनी संपत्ति प्रदर्शित करने के लिए फ़ोटो जोड़ें';

  @override
  String get images_click_to_upload => 'छवियाँ अपलोड करने के लिए क्लिक करें';

  @override
  String get images_max_images_info => 'अधिकतम 10 छवियाँ, JPG, PNG या WEBP';

  @override
  String get images_main => 'मुख्य';

  @override
  String get images_maximum_images_allowed => 'अधिकतम 10 छवियों की अनुमति है';

  @override
  String get admin_dashboard_title => 'व्यवस्थापक डैशबोर्ड';

  @override
  String get admin_dashboard_subtitle =>
      'आपके रियल एस्टेट प्लेटफ़ॉर्म का वास्तविक समय अवलोकन';

  @override
  String get admin_last_update => 'आखिरी अपडेट';

  @override
  String get admin_total_properties => 'कुल गुण';

  @override
  String get admin_total_agents => 'कुल एजेंट';

  @override
  String get admin_total_users => 'कुल उपयोगकर्ता';

  @override
  String get admin_total_views => 'कुल दृश्य';

  @override
  String get admin_error_loading_dashboard => 'डैशबोर्ड लोड करने में त्रुटि';

  @override
  String get admin_failed_to_load_data => 'डैशबोर्ड डेटा लोड करने में विफल';

  @override
  String get admin_avg_sale_price => 'औसत बिक्री मूल्य';

  @override
  String get admin_avg_sale_price_subtitle => 'सभी सक्रिय सूचियाँ';

  @override
  String get admin_total_portfolio_value => 'कुल पोर्टफोलियो मूल्य';

  @override
  String get admin_total_portfolio_value_subtitle => 'संयुक्त संपत्ति मूल्य';

  @override
  String get admin_avg_price_per_sqm => 'औसत मूल्य प्रति वर्गमीटर';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'बाज़ार दर सूचक';

  @override
  String get admin_property_types_distribution => 'संपत्ति प्रकार वितरण';

  @override
  String get admin_properties_by_city => 'शहर के अनुसार संपत्तियाँ';

  @override
  String get admin_properties_by_district => 'जिले के अनुसार संपत्तियां';

  @override
  String get admin_inquiry_types_distribution => 'पूछताछ प्रकार वितरण';

  @override
  String get admin_agent_verification_rate => 'एजेंट सत्यापन दर';

  @override
  String get admin_agent_verification_rate_subtitle => 'गुणवत्ता नियंत्रण';

  @override
  String get admin_inquiry_response_rate => 'पूछताछ प्रतिक्रिया दर';

  @override
  String get admin_inquiry_response_rate_subtitle => 'ग्राहक सेवा';

  @override
  String get admin_avg_views_per_property => 'प्रति संपत्ति औसत दृश्य';

  @override
  String get admin_avg_views_per_property_subtitle => 'संपत्ति की लोकप्रियता';

  @override
  String get admin_featured_properties => 'विशेष गुण';

  @override
  String get admin_featured_properties_subtitle => 'प्रीमियम लिस्टिंग';

  @override
  String get admin_most_viewed_properties => 'सर्वाधिक देखी गई संपत्तियाँ';

  @override
  String get admin_top_performing_agents => 'शीर्ष प्रदर्शन करने वाले एजेंट';

  @override
  String get admin_system_health => 'सिस्टम स्वास्थ्य';

  @override
  String get admin_properties_without_images => 'छवियों के बिना गुण';

  @override
  String get admin_missing_location_data => 'स्थान डेटा अनुपलब्ध';

  @override
  String get admin_pending_agent_verification => 'एजेंट सत्यापन लंबित';

  @override
  String get admin_active => 'सक्रिय';

  @override
  String get admin_verified => 'सत्यापित';

  @override
  String get admin_active_7d => 'सक्रिय (7 दिन)';

  @override
  String get admin_this_month => 'इस महीने';

  @override
  String get agents_loading_pending_applications =>
      'लंबित आवेदन लोड हो रहे हैं...';

  @override
  String get agents_error_loading_applications =>
      'एप्लिकेशन लोड करने में त्रुटि';

  @override
  String get agents_pending_agents => 'लंबित एजेंट';

  @override
  String get agents_total_pending_applications => 'कुल लंबित आवेदन:';

  @override
  String get agents_pending_verification => 'सत्यापन लंबित है';

  @override
  String get agents_applied_date => 'लागू:';

  @override
  String get agents_contact_info => 'संपर्क जानकारी';

  @override
  String get agents_license_number => 'लाइसेंस संख्या';

  @override
  String get agents_years_experience => 'वर्षों का अनुभव';

  @override
  String get agents_years_suffix => 'साल';

  @override
  String get agents_total_sales => 'कुल बिक्री';

  @override
  String get agents_specialization => 'विशेषज्ञता';

  @override
  String get agents_approve => 'मंज़ूरी देना';

  @override
  String get agents_reject => 'अस्वीकार करना';

  @override
  String get agents_no_pending_applications => 'कोई भी आवेदन लंबित नहीं है';

  @override
  String get agents_all_applications_processed =>
      'सभी एजेंट आवेदनों पर कार्रवाई कर दी गई है';

  @override
  String get general_previous => 'पहले का';

  @override
  String get general_page => 'पेज';

  @override
  String get general_next => 'अगला';

  @override
  String get general_views => 'दृश्य';

  @override
  String get general_sales => 'बिक्री';

  @override
  String get general_language_uz => 'ओ\'ज़्बेक्चा';

  @override
  String get general_language_ru => 'Русский';

  @override
  String get general_language_en => 'अंग्रेज़ी';

  @override
  String get general_super_admin => 'सुपर एडमिन';

  @override
  String get general_staff => 'कर्मचारी';

  @override
  String get general_verified_agent => 'सत्यापित एजेंट';

  @override
  String get general_pending_agent => 'लंबित एजेंट';

  @override
  String get general_regular_user => 'नियमित उपयोगकर्ता';

  @override
  String get general_admin => 'व्यवस्थापक';

  @override
  String get general_dashboard => 'डैशबोर्ड';

  @override
  String get general_manage_users => 'उपयोगकर्ताओं को प्रबंधित करें';

  @override
  String get general_verified_agents => 'सत्यापित एजेंट';

  @override
  String get general_agent_panel => 'एजेंट पैनल';

  @override
  String get general_create_property => 'संपत्ति बनाएं';

  @override
  String get general_my_properties => 'मेरी संपत्तियाँ';

  @override
  String get general_inquiries => 'पूछताछ';

  @override
  String get general_agent_profile => 'एजेंट प्रोफ़ाइल';

  @override
  String get general_live => 'रहना';

  @override
  String get general_logged_out_successfully => 'सफलतापूर्वक लॉग आउट हो गया';

  @override
  String get general_logout_completed_with_errors =>
      'लॉगआउट पूरा हुआ (त्रुटियों के साथ)';

  @override
  String get general_application_under_review => 'आवेदन समीक्षाधीन है';

  @override
  String get general_check_status => 'स्थिति जांचें →';

  @override
  String get general_last_updated => 'आखरी अपडेट:';

  @override
  String get general_permissions_may_be_outdated =>
      'अनुमतियाँ पुरानी हो सकती हैं';

  @override
  String get general_permissions_up_to_date => 'अनुमतियाँ अद्यतित हैं';

  @override
  String get general_never => 'कभी नहीं';

  @override
  String get general_properties_found => 'गुण मिले';

  @override
  String get general_properties_saved => 'गुण सहेजे गए';

  @override
  String get general_saved => 'बचाया';

  @override
  String get general_loading_properties => 'गुण लोड हो रहे हैं...';

  @override
  String get general_failed_to_load =>
      'गुण लोड करने में विफल. कृपया पुन: प्रयास करें।';

  @override
  String get general_no_properties_found => 'कोई संपत्ति नहीं मिली';

  @override
  String get general_try_adjusting =>
      'अपने खोज मानदंड को समायोजित करने का प्रयास करें';

  @override
  String get select_category => 'श्रेणी चुनना';

  @override
  String get service_description => 'सेवा विवरण';

  @override
  String get product_search_placeholder =>
      'उत्पाद ढूंढने के लिए एक खोज शब्द दर्ज करें';

  @override
  String get privacy_policy => 'गोपनीयता नीति';

  @override
  String get terms_subtitle => 'गोपनीयता नीति और शर्तें';

  @override
  String get last_updated => 'आखरी अपडेट';

  @override
  String get contact_information => 'संपर्क जानकारी';

  @override
  String get accept_terms => 'मैं नियम एवं शर्तें स्वीकार करता हूं';

  @override
  String get read_terms => 'कृपया हमारे नियम और शर्तें पढ़ें';

  @override
  String get inquiries => 'पूछताछ एवं सहायता';

  @override
  String get inquiries_subtitle => 'सहायता के लिए हमसे संपर्क करें';

  @override
  String get help_center => 'हम आपकी कैसे मदद कर सकते हैं?';

  @override
  String get help_subtitle =>
      'हम किसी भी प्रश्न में आपकी सहायता के लिए यहां हैं';

  @override
  String get contact_us => 'हमसे संपर्क करें';

  @override
  String get email_support => 'ई - मेल समर्थन';

  @override
  String get call_support => 'सहायता को कॉल करें';

  @override
  String get send_message => 'मेसेज भेजें';

  @override
  String get fill_contact_form => 'संपर्क फ़ॉर्म भरें';

  @override
  String get contact_form => 'संपर्क करें प्रपत्र';

  @override
  String get name => 'आपका नाम';

  @override
  String get name_required => 'कृपया अपना नाम दर्ज करें';

  @override
  String get email => 'मेल पता';

  @override
  String get email_required => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get email_invalid => 'कृपया एक मान्य ईमेल दर्ज करें';

  @override
  String get subject => 'विषय';

  @override
  String get subject_required => 'कृपया एक विषय दर्ज करें';

  @override
  String get message => 'संदेश';

  @override
  String get message_required => 'कृपया अपना संदेश दर्ज करें';

  @override
  String get message_too_short => 'संदेश कम से कम 10 अक्षर का होना चाहिए';

  @override
  String get faq => 'अक्सर पूछे जाने वाले प्रश्नों';

  @override
  String get follow_us => 'हमारे पर का पालन करें';

  @override
  String get faq_how_to_sell => 'मैं Tezsell पर आइटम कैसे बेचूं?';

  @override
  String get faq_how_to_sell_answer =>
      'आइटम बेचने के लिए: 1) एक खाता बनाएं, 2) \'+\' बटन पर टैप करें, 3) श्रेणी चुनें (उत्पाद/सेवाएं/रियल एस्टेट), 4) तस्वीरें और विवरण जोड़ें, 5) अपनी कीमत निर्धारित करें, 6) प्रकाशित करें! आपकी सूची आपके क्षेत्र के खरीदारों को दिखाई देगी।';

  @override
  String get faq_is_free => 'क्या Tezsell का उपयोग मुफ़्त है?';

  @override
  String get faq_is_free_answer =>
      'हाँ! Tezsell वर्तमान में 100% मुफ़्त है। कोई लिस्टिंग शुल्क नहीं, बिक्री पर कोई कमीशन नहीं, कोई सदस्यता शुल्क नहीं। हम भविष्य में प्रीमियम सुविधाएँ पेश कर सकते हैं, लेकिन उपयोगकर्ताओं को 30 दिन पहले सूचित करेंगे।';

  @override
  String get faq_safety => 'मैं खरीदते/बेचते समय कैसे सुरक्षित रह सकता हूँ?';

  @override
  String get faq_safety_answer =>
      'सुरक्षा युक्तियाँ: 1) सार्वजनिक स्थानों पर मिलें, 2) भुगतान करने से पहले वस्तुओं का निरीक्षण करें, 3) अजनबियों को कभी पैसे न भेजें, 4) अपनी प्रवृत्ति पर भरोसा रखें, 5) संदिग्ध उपयोगकर्ताओं की रिपोर्ट करें, 6) व्यक्तिगत जानकारी बहुत जल्दी साझा न करें, 7) उच्च मूल्य के लेनदेन के लिए किसी मित्र को साथ लाएँ।';

  @override
  String get faq_payment => 'भुगतान कैसे काम करते हैं?';

  @override
  String get faq_payment_answer =>
      'Tezsell भुगतान संसाधित नहीं करता है. खरीदार और विक्रेता सीधे भुगतान की व्यवस्था करते हैं (नकद, बैंक हस्तांतरण, आदि)। हम लोगों को जोड़ने का एक मंच मात्र हैं - लेन-देन आप स्वयं संभालें।';

  @override
  String get faq_prohibited => 'कौन सी वस्तुएं प्रतिबंधित हैं?';

  @override
  String get faq_prohibited_answer =>
      'प्रतिबंधित वस्तुओं में शामिल हैं: हथियार, दवाएं, चोरी का सामान, नकली वस्तुएं, वयस्क सामग्री, जीवित जानवर (बिना परमिट के), सरकारी आईडी और खतरनाक सामग्री। पूरी सूची के लिए हमारे नियम एवं शर्तें देखें।';

  @override
  String get faq_account_delete => 'मैं अपना खाता कैसे मिटाऊ़?';

  @override
  String get faq_account_delete_answer =>
      'प्रोफ़ाइल → सेटिंग्स → खाता सेटिंग्स → खाता हटाएँ पर जाएँ। नोट: यह स्थायी है और इसे पूर्ववत नहीं किया जा सकता। आपकी सभी सूचियाँ हटा दी जाएंगी.';

  @override
  String get faq_report_user =>
      'मैं किसी उपयोगकर्ता या सूची की रिपोर्ट कैसे करूँ?';

  @override
  String get faq_report_user_answer =>
      'किसी भी लिस्टिंग या उपयोगकर्ता प्रोफ़ाइल पर तीन बिंदुओं (•••) पर टैप करें, फिर \'रिपोर्ट\' चुनें। कारण चुनें और सबमिट करें। हम 24-48 घंटों के भीतर सभी रिपोर्टों की समीक्षा करते हैं।';

  @override
  String get faq_change_location => 'मैं अपना स्थान कैसे बदलूं?';

  @override
  String get faq_change_location_answer =>
      'होम स्क्रीन के ऊपरी-बाएँ कोने में स्थान बटन पर टैप करें। आप अपने क्षेत्र में लिस्टिंग देखने के लिए अपने क्षेत्र और जिले का चयन कर सकते हैं।';

  @override
  String get welcome_customer_center => 'ग्राहक केंद्र में आपका स्वागत है';

  @override
  String get customer_center_subtitle => 'हम 24/7 आपकी सहायता के लिए यहां हैं';

  @override
  String get quick_actions => 'त्वरित कार्रवाई';

  @override
  String get live_chat => 'सीधी बातचीत';

  @override
  String get chat_with_us => 'हमारे साथ चैट करें';

  @override
  String get find_answers => 'उत्तर खोजें';

  @override
  String get my_tickets => 'मेरे टिकट';

  @override
  String get view_tickets => 'टिकट देखें';

  @override
  String get feedback => 'प्रतिक्रिया';

  @override
  String get share_feedback => 'प्रतिक्रिया साझा करें';

  @override
  String get contact_methods => 'संपर्क विधियाँ';

  @override
  String get phone_support => 'फ़ोन सहायता';

  @override
  String get available_247 => '24/7 उपलब्ध';

  @override
  String get response_24h => '24 घंटे के अंदर जवाब';

  @override
  String get telegram_support => 'टेलीग्राम समर्थन';

  @override
  String get instant_replies => 'त्वरित उत्तर';

  @override
  String get whatsapp_support => 'व्हाट्सएप सपोर्ट';

  @override
  String get quick_response => 'त्वरित प्रतिक्रिया';

  @override
  String get popular_topics => 'लोकप्रिय विषय';

  @override
  String get account_management => 'खाता प्रबंधन';

  @override
  String get reset_password => 'पासवर्ड रीसेट';

  @override
  String get update_profile => 'प्रोफ़ाइल अपडेट करें';

  @override
  String get verify_account => 'खाता सत्यापित करें';

  @override
  String get delete_account => 'खाता हटा दो';

  @override
  String get buying_selling => 'खरीदना बेचना';

  @override
  String get how_to_post => 'विज्ञापन कैसे पोस्ट करें';

  @override
  String get payment_methods => 'भुगतान के तरीके';

  @override
  String get shipping_delivery => 'शिपिंग एवं डिलिवरी';

  @override
  String get return_policy => 'वापसी नीति';

  @override
  String get safety_security => 'सुरक्षा';

  @override
  String get report_scam => 'घोटाले की रिपोर्ट करें';

  @override
  String get safe_trading => 'सुरक्षित ट्रेडिंग युक्तियाँ';

  @override
  String get privacy_settings => 'गोपनीय सेटिंग';

  @override
  String get blocked_users => 'अवरुद्ध उपयोगकर्ता';

  @override
  String get technical_issues => 'तकनीकी मुद्दें';

  @override
  String get app_not_working => 'ऐप काम नहीं कर रहा';

  @override
  String get upload_failed => 'अपलोड विफल';

  @override
  String get login_problems => 'लॉगिन समस्याएँ';

  @override
  String get support_hours => 'सहायता के घंटे';

  @override
  String get mon_fri_9_6 => 'सोम-शुक्र: सुबह 9:00 बजे - शाम 6:00 बजे';

  @override
  String get how_are_we_doing => 'हम कैसे हैं?';

  @override
  String get rate_experience => 'अपने ग्राहक सेवा अनुभव को रेटिंग दें';

  @override
  String get poor => 'गरीब';

  @override
  String get okay => 'ठीक है';

  @override
  String get good => 'अच्छा';

  @override
  String get excellent => 'उत्कृष्ट';

  @override
  String get account_secure => 'आपका खाता सुरक्षित है';

  @override
  String get password_security => 'पासवर्ड एवं प्रमाणीकरण';

  @override
  String get change_password => 'पासवर्ड बदलें';

  @override
  String get two_factor_auth => 'दो-कारक प्रमाणीकरण';

  @override
  String get biometric_login => 'बायोमेट्रिक लॉगिन';

  @override
  String get login_activity => 'लॉगिन गतिविधि';

  @override
  String get active_sessions => 'सक्रिय सत्र';

  @override
  String get login_alerts => 'लॉगिन अलर्ट';

  @override
  String get account_protection => 'खाता सुरक्षा';

  @override
  String get recovery_email => 'पुनर्प्राप्ति ईमेल';

  @override
  String get backup_codes => 'बैकअप कोड';

  @override
  String get danger_zone => 'खतरा क्षेत्र';

  @override
  String get improve_security => 'सुरक्षा में सुधार करें';

  @override
  String get security_score => 'सुरक्षा स्कोर';

  @override
  String get last_changed_days => 'आखिरी बार 30 दिन पहले बदला गया';

  @override
  String get logout_all_devices => 'सभी डिवाइस लॉगआउट करें';

  @override
  String get end_all_sessions => 'सभी सत्र समाप्त करें';

  @override
  String get permanently_delete => 'स्थायी रूप से हटाना';

  @override
  String get verification_code_message =>
      'हम यह पुष्टि करने के लिए एक सत्यापन कोड भेजेंगे कि यह आप ही हैं।';

  @override
  String get send_code => 'कोड भेजें';

  @override
  String get enter_verification_code => 'सत्यापन कोड दर्ज करें';

  @override
  String get verification_code => 'सत्यापन कोड';

  @override
  String get new_password => 'नया पासवर्ड';

  @override
  String get confirm_password => 'पासवर्ड की पुष्टि कीजिये';

  @override
  String get resend_code => 'पुन: कोड भेजे';

  @override
  String get code_sent_to => 'भेजे गए सत्यापन कोड को दर्ज करें';

  @override
  String get enter_code => 'सत्यापन कोड दर्ज करें';

  @override
  String get code_must_be_6_digits => 'कोड 6 अंकों का होना चाहिए';

  @override
  String get enter_new_password => 'नया पासवर्ड दर्ज करें';

  @override
  String get minimum_8_characters => 'न्यूनतम 8 अक्षर';

  @override
  String get passwords_do_not_match => 'सांकेतिक शब्द मेल नहीं खाते';

  @override
  String get close => 'बंद करना';

  @override
  String get current => 'मौजूदा';

  @override
  String get session_ended => 'सत्र ख़त्म हुआ';

  @override
  String get update_recovery_email => 'पुनर्प्राप्ति ईमेल अपडेट करें';

  @override
  String get new_email => 'नया ईमेल';

  @override
  String get update => 'अद्यतन';

  @override
  String get verification_email_sent => 'सत्यापन विद्युतडाक भेज दिया गया है';

  @override
  String get generate_emergency_codes => 'आपातकालीन कोड जनरेट करें';

  @override
  String get copy_all => 'सभी को कॉपी करें';

  @override
  String get code_copied => 'कोड कॉपी किया गया';

  @override
  String get all_codes_copied => 'सभी कोड कॉपी किए गए';

  @override
  String get logout_all_devices_confirm => 'सभी डिवाइस लॉगआउट करें?';

  @override
  String get logout_all_devices_message =>
      'इससे सभी डिवाइस पर सभी सक्रिय सत्र समाप्त हो जाएंगे.';

  @override
  String get logout_all => 'सभी को लॉगआउट करें';

  @override
  String get securityLoginHistory => 'Login History';

  @override
  String get securityLogoutAll => 'Logout All Devices';

  @override
  String get securityLogoutAllConfirm =>
      'This will sign you out on every device where you\'re currently logged in, including this one.';

  @override
  String get securityNewDevice => 'New device';

  @override
  String get securityNoHistory => 'No login history yet';

  @override
  String get securityMethodGoogle => 'Google';

  @override
  String get securityMethodApple => 'Apple';

  @override
  String get securityMethodTokenRefresh => 'Token refresh';

  @override
  String get securitySignedOutEverywhere =>
      'You\'ve been signed out of all devices';

  @override
  String get delete_account_confirm => 'खाता हटा दो?';

  @override
  String get delete_account_warning =>
      'यह क्रिया स्थायी है और इसे पूर्ववत नहीं किया जा सकता. आपका सारा डेटा स्थायी रूप से हटा दिया जाएगा.';

  @override
  String get what_will_be_deleted => 'क्या हटाया जाएगा:';

  @override
  String get profile_and_account_info => '• आपकी प्रोफ़ाइल और खाते की जानकारी';

  @override
  String get all_listings_and_posts => '• आपकी सभी सूचियाँ और पोस्ट';

  @override
  String get messages_and_conversations => 'संदेशों';

  @override
  String get saved_items_and_preferences => '• सहेजे गए आइटम और प्राथमिकताएँ';

  @override
  String get enter_password_to_continue =>
      'जारी रखने के लिए अपना पासवर्ड दर्ज करें';

  @override
  String get continue_val => 'जारी रखना';

  @override
  String get please_enter_password => 'अपना पासवर्ड दर्ज करें';

  @override
  String get enter_confirmation_code => 'पुष्टि कोड दर्ज करें';

  @override
  String get deletion_confirmation_message =>
      'हमने आपके फ़ोन पर एक पुष्टिकरण कोड भेजा है. अपना खाता स्थायी रूप से हटाने के लिए इसे नीचे दर्ज करें।';

  @override
  String get confirmation_code => 'पुष्टि कोड';

  @override
  String get please_enter_6_digit_code => 'कृपया 6 अंकीय कोड दर्ज करें';

  @override
  String get account_deleted => 'आपका खाता हटा दिया गया है';

  @override
  String get deletion_cancelled => 'विलोपन रद्द किया गया';

  @override
  String get failed_to_load_user_info => 'उपयोगकर्ता जानकारी लोड करने में विफल';

  @override
  String get auth_login_to_view_saved =>
      'कृपया अपनी सहेजी गई संपत्तियों को देखने के लिए लॉग इन करें';

  @override
  String get authLoginRequired => 'लॉगिन आवश्यक';

  @override
  String get authLoginToViewSaved =>
      'कृपया अपनी सहेजी गई संपत्तियों को देखने के लिए लॉग इन करें';

  @override
  String get authLogin => 'लॉग इन करें';

  @override
  String get savedPropertiesTitle => 'सहेजे गए गुण';

  @override
  String get loadingSavedProperties => 'सहेजी गई संपत्तियाँ लोड हो रही हैं...';

  @override
  String get errorsFailedToLoadSaved =>
      'सहेजी गई संपत्तियों को लोड करने में विफल';

  @override
  String get actionsRetry => 'पुन: प्रयास करें';

  @override
  String get savedPropertiesNoSaved => 'कोई सहेजी गई संपत्ति नहीं';

  @override
  String get savedPropertiesStartSaving =>
      'अपनी पसंद की संपत्तियों को खोजना और सहेजना शुरू करें';

  @override
  String get savedPropertiesBrowse => 'गुण ब्राउज़ करें';

  @override
  String get resultsSavedProperties => 'सहेजी गई संपत्तियाँ';

  @override
  String get actionsRefresh => 'ताज़ा करना';

  @override
  String get resultsNoMoreProperties => 'कोई और संपत्ति नहीं';

  @override
  String get propertyCardFeatured => 'प्रदर्शित';

  @override
  String get successPropertyUnsaved =>
      'संपत्ति को सहेजी गई सूची से हटा दिया गया';

  @override
  String get alertsUnsavePropertyFailed => 'संपत्ति हटाने में विफल';

  @override
  String get propertyCardBed => 'बिस्तर';

  @override
  String get propertyCardBath => 'नहाना';

  @override
  String get savedPropertiesSavedOn => 'पर सहेजा गया';

  @override
  String get propertyCardViewDetails => 'विवरण देखें';

  @override
  String get serviceDetailTitle => 'सेवा विवरण';

  @override
  String get errorLoadingFavorites => 'पसंदीदा आइटम लोड करने में त्रुटि';

  @override
  String get noFavoritesFound => 'कोई पसंदीदा आइटम नहीं मिला.';

  @override
  String get commentUpdatedSuccess => 'टिप्पणी सफलतापूर्वक अपडेट की गई!';

  @override
  String get errorUpdatingComment => 'टिप्पणी अपडेट करने में त्रुटि';

  @override
  String get replyAddedSuccess => 'उत्तर सफलतापूर्वक जोड़ा गया!';

  @override
  String get errorAddingReply => 'उत्तर जोड़ने में त्रुटि';

  @override
  String get commentDeletedSuccess => 'टिप्पणी सफलतापूर्वक हटा दी गई!';

  @override
  String get errorDeletingComment => 'टिप्पणी हटाने में त्रुटि';

  @override
  String get serviceLikedSuccess => 'सेवा सफलतापूर्वक पसंद आई!';

  @override
  String get errorLikingService => 'सेवा पसंद करने में त्रुटि';

  @override
  String get serviceDislikedSuccess => 'सेवा सफलतापूर्वक नापसंद की गई!';

  @override
  String get errorDislikingService => 'सेवा नापसंद करने में त्रुटि';

  @override
  String get writeYourReply => 'अपना उत्तर लिखें...';

  @override
  String get postReply => 'तेज़ी से उत्तर';

  @override
  String get anonymous => 'गुमनाम';

  @override
  String get editComment => 'टिप्पणी संपादित करें';

  @override
  String get editYourComment => 'अपनी टिप्पणी संपादित करें...';

  @override
  String get saveChanges => 'परिवर्तनों को सुरक्षित करें';

  @override
  String get propertyOwner => 'संपत्ति का स्वामी';

  @override
  String get errorLoadingServices => 'सेवाएँ लोड करने में त्रुटि';

  @override
  String get noRecommendedServicesFound => 'कोई अनुशंसित सेवाएँ नहीं मिलीं.';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 8 वर्णों का होना चाहिए';

  @override
  String get passwordRequirements =>
      'पासवर्ड में अक्षर और संख्याएँ अवश्य होनी चाहिए';

  @override
  String get usernameRequired => 'उपयोगकर्ता नाम आवश्यक है';

  @override
  String get usernameTooShort =>
      'उपयोगकर्ता नाम कम से कम 3 अक्षर का होना चाहिए';

  @override
  String get confirmPasswordRequired => 'पासवर्ड पुष्टिकरण आवश्यक है';

  @override
  String get passwordHelp => 'कम से कम 8 अक्षर, अक्षर और संख्याएँ';

  @override
  String get usernameExists => 'उपयोगकर्ता का नाम पहले से मौजूद है';

  @override
  String get phoneExists => 'यह फ़ोन नंबर पहले से पंजीकृत है';

  @override
  String get networkError =>
      'नेटवर्क कनेक्शन त्रुटि. कृपया अपना कनेक्शन जांचें';

  @override
  String get contactSeller => 'विक्रेता से संपर्क कारें';

  @override
  String get callToReveal => 'प्रकट करने के लिए \"कॉल करें\" टैप करें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get selectImageSource => 'छवि स्रोत का चयन करें';

  @override
  String get uploading => 'अपलोड हो रहा है...';

  @override
  String get acceptTermsRequired =>
      'आपको जरी रखने के लिए नियम एवं शर्तें माननी होगी';

  @override
  String get iAgreeToTerms => 'मैं करने के लिए सहमत हूं';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

  @override
  String get zeroToleranceStatement =>
      'और समझें कि आपत्तिजनक सामग्री या अपमानजनक उपयोगकर्ताओं के लिए शून्य सहिष्णुता है।';

  @override
  String get viewTerms => 'नियम एवं शर्तें देखें';

  @override
  String get reportContent => 'रिपोर्ट सामग्री';

  @override
  String get selectReportReason => 'कृपया रिपोर्ट करने का कारण चुनें:';

  @override
  String get additionalDetails => 'अतिरिक्त विवरण (वैकल्पिक)';

  @override
  String get reportDetailsHint => 'कोई अतिरिक्त जानकारी प्रदान करें...';

  @override
  String get reportSubmitted =>
      'अपनी रिपोर्ट के लिए धन्यवाद। हम 24 घंटे के अंदर इसकी समीक्षा करेंगे.';

  @override
  String get reportProduct => 'उत्पाद की रिपोर्ट करें';

  @override
  String get reportService => 'रिपोर्ट सेवा';

  @override
  String get reportMessage => 'रिपोर्ट संदेश';

  @override
  String get reportUser => 'उपयोगकर्ता को रिपोर्ट करें';

  @override
  String get reportErrorNotImplemented =>
      'रिपोर्टिंग सुविधा अभी तक उपलब्ध नहीं है. कृपया सहायता से संपर्क करें या बाद में पुनः प्रयास करें।';

  @override
  String get reportAlreadySubmitted =>
      'आप पहले ही इस सामग्री की रिपोर्ट कर चुके हैं. हम आपकी पिछली रिपोर्ट की समीक्षा कर रहे हैं.';

  @override
  String get reportFailedGeneric =>
      'रिपोर्ट प्रस्तुत करने में विफल. कृपया पुन: प्रयास करें।';

  @override
  String get reportFailedNetwork =>
      'नेटवर्क त्रुटि उत्पन्न हुई. अपने कनेक्शन की जांच करें और पुन: प्रयास करें।';

  @override
  String get becomeAgentTitle => 'एक रियल एस्टेट एजेंट के रूप में शामिल हों';

  @override
  String get becomeAgentSubtitle =>
      'संपत्तियों की सूची बनाएं और ग्राहकों को उनके सपनों का घर ढूंढने में मदद करें';

  @override
  String get agentBenefits => 'फ़ायदे:';

  @override
  String get agentBenefitVerified => 'सत्यापित एजेंट बैज';

  @override
  String get agentBenefitAnalytics => 'विश्लेषण और अंतर्दृष्टि तक पहुंच';

  @override
  String get agentBenefitClients => 'संभावित ग्राहकों से सीधा संपर्क';

  @override
  String get agentBenefitReputation => 'अपनी व्यावसायिक प्रतिष्ठा बनाएँ';

  @override
  String get agentApplicationForm => 'आवेदन फार्म';

  @override
  String get agentAgencyName => 'एजेंसी का नाम';

  @override
  String get agentAgencyNameHint => 'अपनी रियल एस्टेट एजेंसी का नाम दर्ज करें';

  @override
  String get agentAgencyNameRequired => 'एजेंसी का नाम आवश्यक है';

  @override
  String get agentLicenceNumber => 'लाइसेंस संख्या';

  @override
  String get agentLicenceNumberHint =>
      'अपना रियल एस्टेट लाइसेंस नंबर दर्ज करें';

  @override
  String get agentLicenceNumberRequired => 'लाइसेंस संख्या आवश्यक है';

  @override
  String get agentYearsExperience => 'वर्षों का अनुभव';

  @override
  String get agentYearsExperienceHint => 'वर्षों की संख्या दर्ज करें';

  @override
  String get agentYearsExperienceRequired => 'वर्षों का अनुभव आवश्यक है';

  @override
  String get agentYearsExperienceInvalid => 'कृपया सही अंक दर्ज करें';

  @override
  String get agentSpecialization => 'विशेषज्ञता';

  @override
  String get agentApplicationNote =>
      'आपके आवेदन की समीक्षा हमारी टीम द्वारा की जाएगी। आपका आवेदन स्वीकृत होते ही आपको सूचित कर दिया जाएगा।';

  @override
  String get agentSubmitApplication => 'आवेदन जमा करो';

  @override
  String get agentApplicationSubmitted =>
      'आवेदन सफलतापूर्वक सबमिट हो गया! हम जल्द ही इसकी समीक्षा करेंगे.';

  @override
  String get agentApplicationStatus => 'आवेदन की स्थिति';

  @override
  String get agentViewProfile => 'अपना एजेंट प्रोफ़ाइल देखें';

  @override
  String get agentDashboardComingSoon => 'एजेंट डैशबोर्ड जल्द ही आ रहा है!';

  @override
  String get property_create_basic_information => 'मूल जानकारी';

  @override
  String get property_create_property_title => 'संपत्ति का शीर्षक *';

  @override
  String get property_create_property_title_hint =>
      'उदाहरण के लिए, सिटी सेंटर में आधुनिक 3बीआर अपार्टमेंट';

  @override
  String get property_create_property_title_required =>
      'कृपया संपत्ति का शीर्षक दर्ज करें';

  @override
  String get property_create_description => 'विवरण *';

  @override
  String get property_create_description_hint =>
      'अपनी संपत्ति का विस्तार से वर्णन करें...';

  @override
  String get property_create_description_required => 'कृपया विवरण दर्ज करें';

  @override
  String get property_create_property_type => 'सम्पत्ती के प्रकार';

  @override
  String get property_create_property_type_required => 'सम्पत्ती के प्रकार *';

  @override
  String get property_create_listing_type_required => 'लिस्टिंग प्रकार*';

  @override
  String get property_create_pricing => 'मूल्य निर्धारण';

  @override
  String get property_create_price => 'कीमत *';

  @override
  String get property_create_price_hint => 'कीमत दर्ज करें';

  @override
  String get property_create_price_required => 'कृपया कीमत दर्ज करें';

  @override
  String get property_create_currency => 'मुद्रा';

  @override
  String get property_create_property_details => 'संपत्ति ब्यौरा';

  @override
  String get property_create_square_meters => 'वर्ग. मीटर*';

  @override
  String get property_create_bedrooms => 'शयनकक्ष*';

  @override
  String get property_create_bathrooms => 'बाथरूम*';

  @override
  String get property_create_floor => 'ज़मीन';

  @override
  String get property_create_total_floors => 'कुल मंजिलें';

  @override
  String get property_create_parking => 'पार्किंग';

  @override
  String get property_create_year_built => 'निर्माण वर्ष';

  @override
  String get property_create_location => 'जगह';

  @override
  String get property_create_address => 'पता *';

  @override
  String get property_create_address_hint => 'संपत्ति का पता दर्ज करें';

  @override
  String get property_create_address_required => 'कृपया पता दर्ज करें';

  @override
  String get property_create_location_detected => 'स्थान का पता लगाया गया';

  @override
  String get property_create_get_location => 'वर्तमान स्थान प्राप्त करें';

  @override
  String get property_create_features => 'विशेषताएँ';

  @override
  String get property_create_feature_balcony => 'बालकनी';

  @override
  String get property_create_feature_garage => 'गैरेज';

  @override
  String get property_create_feature_garden => 'बगीचा';

  @override
  String get property_create_feature_pool => 'पूल';

  @override
  String get property_create_feature_elevator => 'लिफ़्ट';

  @override
  String get property_create_feature_furnished => 'सुसज्जित';

  @override
  String get property_create_images => 'संपत्ति छवियाँ';

  @override
  String get property_create_tap_to_add_images =>
      'छवियाँ जोड़ने के लिए टैप करें';

  @override
  String get property_create_at_least_one_image => 'कम से कम 1 छवि आवश्यक है';

  @override
  String get property_create_add_more => 'अधिक जोड़ें';

  @override
  String get property_create_required => 'आवश्यक';

  @override
  String get property_create_location_required =>
      'संपत्ति बनाने के लिए कृपया स्थान सेवाएं सक्षम करें';

  @override
  String get property_create_image_required =>
      'कम से कम एक संपत्ति छवि आवश्यक है';

  @override
  String get emailVerification => 'ईमेल सत्यापन';

  @override
  String get pleaseEnterYourEmailAddress => 'कृपया अपना ईमेल एड्रेस इंटर करें';

  @override
  String get enterEmailAddress => 'ईमेल पता दर्ज करें';

  @override
  String get resetYourPassword => 'अपना पासवर्ड रीसेट करें';

  @override
  String get resetPasswordDescription =>
      'अपना ईमेल पता दर्ज करें और हम आपका पासवर्ड रीसेट करने के लिए आपको एक सत्यापन कोड भेजेंगे।';

  @override
  String get sendVerificationCode => 'सत्यापन कोड भेजें';

  @override
  String get backToLogin => 'लॉगिन पर वापस जाएं';

  @override
  String get resetPassword => 'पासवर्ड रीसेट';

  @override
  String enterVerificationCodeSentTo(String email) {
    return '$email पर भेजा गया सत्यापन कोड दर्ज करें';
  }

  @override
  String get codeMustBe6Digits => 'कोड 6 अंकों का होना चाहिए';

  @override
  String get enterNewPassword => 'नया पासवर्ड दर्ज करें';

  @override
  String get minimum8Characters => 'न्यूनतम 8 अक्षर';

  @override
  String get sending => 'भेजा जा रहा है...';

  @override
  String get verifying => 'सत्यापन किया जा रहा है...';

  @override
  String get new_message => 'नया सन्देश';

  @override
  String get messages => 'संदेशों';

  @override
  String get please_log_in => 'संदेश देखने के लिए कृपया लॉग इन करें';

  @override
  String get pin => 'नत्थी करना';

  @override
  String get unpin => 'अनपिन';

  @override
  String get delete_chat => 'चैट हटाएँ';

  @override
  String delete_chat_confirm(String name) {
    return 'क्या आप वाकई $name के साथ चैट को हटाना चाहते हैं? इस एक्शन को वापस नहीं किया जा सकता।';
  }

  @override
  String chat_deleted(String name) {
    return '$name के साथ चैट हटा दी गई';
  }

  @override
  String get delete_failed => 'चैट हटाने में विफल';

  @override
  String get no_conversations => 'अभी तक कोई बातचीत नहीं';

  @override
  String get start_conversation_hint => '+ बटन पर टैप करके बातचीत शुरू करें';

  @override
  String get start_conversation => 'एक बातचीत शुरू';

  @override
  String get yesterday => 'कल';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get no_messages_yet => 'अभी तक कोई संदेश नहीं';

  @override
  String get unblock_user => 'उपयोगकर्ता को अनब्लॉक करें';

  @override
  String get block_user => 'खंड उपयोगकर्ता';

  @override
  String get no_blocked_users => 'कोई अवरुद्ध उपयोगकर्ता नहीं';

  @override
  String get blocked_users_hint =>
      'आपके द्वारा ब्लॉक किए गए उपयोगकर्ता यहां दिखाई देंगे';

  @override
  String unblock_user_confirm(String username) {
    return 'क्या आप वाकई $username को अनब्लॉक करना चाहते हैं? आप उनसे दोबारा संदेश प्राप्त कर सकेंगे.';
  }

  @override
  String user_unblocked(String username) {
    return '$username को अनब्लॉक कर दिया गया है';
  }

  @override
  String user_blocked(String username) {
    return '$username को ब्लॉक कर दिया गया है';
  }

  @override
  String get failed_to_unblock => 'उपयोगकर्ता को अनब्लॉक करने में विफल';

  @override
  String get failed_to_block => 'उपयोगकर्ता को ब्लॉक करने में विफल';

  @override
  String get chat_info => 'चैट जानकारी';

  @override
  String get delete_message => 'संदेश को हटाएं';

  @override
  String get delete_message_confirm =>
      'क्या आप निश्चित रूप से यह संदेश हटाना चाहते हैं?';

  @override
  String get typing => 'टाइपिंग...';

  @override
  String get online => 'ऑनलाइन';

  @override
  String get offline => 'ऑफलाइन';

  @override
  String last_seen_at(String time) {
    return 'अंतिम बार देखा गया $time';
  }

  @override
  String participants(int count) {
    return '$count प्रतिभागी';
  }

  @override
  String get you_are_blocked => 'आपको ब्लॉक कर दिया गया है';

  @override
  String user_blocked_you(String username) {
    return '$username ने आपको ब्लॉक कर दिया है. आप संदेश नहीं भेज सकते.';
  }

  @override
  String you_blocked_user(String username) {
    return 'आपने $username को ब्लॉक कर दिया है';
  }

  @override
  String get cannot_send_messages_blocked =>
      'आप संदेश नहीं भेज सकते. आपको ब्लॉक कर दिया गया है.';

  @override
  String get this_message_was_deleted => 'यह संदेश हटा दिया गया';

  @override
  String get edit => 'संपादन करना';

  @override
  String get reply => 'जवाब';

  @override
  String get editing_message => 'संदेश संपादित करना';

  @override
  String replying_to(String username) {
    return '$username को उत्तर दिया जा रहा है';
  }

  @override
  String get voice => 'आवाज़';

  @override
  String get emoji => 'इमोजी';

  @override
  String get photo => '📷फोटो';

  @override
  String get voice_message => '🎤 ध्वनि संदेश';

  @override
  String get searching => 'खोज रहे हैं...';

  @override
  String get loading_users => 'उपयोगकर्ता लोड हो रहे हैं...';

  @override
  String search_failed(String error) {
    return 'खोज विफल: $error';
  }

  @override
  String get invalid_user_data => 'अमान्य उपयोगकर्ता डेटा';

  @override
  String failed_to_start_chat(String error) {
    return 'चैट प्रारंभ करने में विफल: $error';
  }

  @override
  String get audio_file_not_available => 'ऑडियो फ़ाइल उपलब्ध नहीं है';

  @override
  String failed_to_play_audio(String error) {
    return 'ऑडियो चलाने में विफल: $error';
  }

  @override
  String get image_unavailable => 'छवि अनुपलब्ध';

  @override
  String get image_too_large => '❌ छवि बहुत बड़ी है. अधिकतम आकार 10 एमबी है';

  @override
  String get image_file_not_found => '❌ छवि फ़ाइल नहीं मिली';

  @override
  String get uploading_image => 'छवि अपलोड हो रही है...';

  @override
  String get image_sent => '✅ छवि भेजी गई!';

  @override
  String get failed_to_send_image => '❌ छवि भेजने में विफल';

  @override
  String get uploading_voice_message => 'ध्वनि संदेश अपलोड हो रहा है...';

  @override
  String get voice_message_sent => '✅ ध्वनि संदेश भेजा गया!';

  @override
  String get failed_to_send_voice_message => '❌ ध्वनि संदेश भेजने में विफल';

  @override
  String get recording => '🎙️रिकॉर्डिंग...';

  @override
  String get microphone_permission_denied => 'माइक्रोफ़ोन की अनुमति अस्वीकृत';

  @override
  String get starting_chat => 'चैट प्रारंभ हो रही है...';

  @override
  String get refresh_users => 'उपयोगकर्ताओं को ताज़ा करें';

  @override
  String get search_by_username_or_phone =>
      'उपयोगकर्ता नाम या फ़ोन नंबर से खोजें';

  @override
  String get no_users_found => 'कोई उपयोगकर्ता नहीं मिला';

  @override
  String get try_different_search_term => 'कोई भिन्न खोज शब्द आज़माएँ';

  @override
  String get no_users_available => 'कोई उपयोगकर्ता उपलब्ध नहीं है';

  @override
  String get chat_exists => 'चैट मौजूद है';

  @override
  String block_user_confirm(String username) {
    return 'क्या आप वाकई $username को ब्लॉक करना चाहते हैं? आपको उनसे संदेश प्राप्त नहीं होंगे और उन्हें आपकी चैट सूची से हटा दिया जाएगा।';
  }

  @override
  String chat_room_label(String name) {
    return 'चैट रूम: $name';
  }

  @override
  String id_label(int id) {
    return 'आईडी: $id';
  }

  @override
  String get participants_label => 'प्रतिभागी:';

  @override
  String get type_a_message => 'एक संदेश टाइप करें...';

  @override
  String get edit_message_hint => 'संदेश संपादित करें...';

  @override
  String error_label(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get copy => 'प्रतिलिपि';

  @override
  String comments_title(int count) {
    return 'टिप्पणियाँ ($count)';
  }

  @override
  String get reply_button => 'जवाब';

  @override
  String replies_count(int count) {
    return '$count उत्तर';
  }

  @override
  String get you_label => 'आप';

  @override
  String get delete_reply_title => 'उत्तर हटाएँ';

  @override
  String get delete_comment_title => 'टिप्पणी हटाएँ';

  @override
  String get unknown_date => 'अज्ञात तिथि';

  @override
  String get press_enter_to_send => 'भेजने के लिए Enter दबाएँ';

  @override
  String get comment_add_error => 'टिप्पणी जोड़ने में विफल';

  @override
  String get service_provider => 'सेवा प्रदाता';

  @override
  String get opening_chat => 'चैट खुल रही है...';

  @override
  String get failed_to_refresh => 'ताज़ा करने में विफल';

  @override
  String get cannot_chat_with_yourself => 'आप स्वयं से चैट नहीं कर सकते';

  @override
  String opening_chat_with(String username) {
    return '$username के साथ चैट खुल रही है...';
  }

  @override
  String get this_will_only_take_a_moment => 'इसमें केवल एक क्षण लगेगा';

  @override
  String get unable_to_start_chat =>
      'चैट प्रारंभ करने में असमर्थ. कृपया पुन: प्रयास करें।';

  @override
  String get profile_listings => 'लिस्टिंग';

  @override
  String get profile_followers => 'समर्थक';

  @override
  String get profile_following => 'अगले';

  @override
  String get profile_no_products => 'कोई उत्पाद नहीं';

  @override
  String get profile_no_services => 'कोई सेवा नहीं';

  @override
  String get profile_no_properties => 'कोई गुण नहीं';

  @override
  String get profile_user_no_products =>
      'इस उपयोगकर्ता ने अभी तक कोई उत्पाद पोस्ट नहीं किया है';

  @override
  String get profile_user_no_services =>
      'इस उपयोगकर्ता ने अभी तक कोई सेवा पोस्ट नहीं की है';

  @override
  String get profile_user_no_properties =>
      'इस उपयोगकर्ता ने अभी तक कोई प्रॉपर्टी पोस्ट नहीं की है';

  @override
  String get profile_error_occurred => 'त्रुटि हुई';

  @override
  String get profile_error_loading_products => 'उत्पाद लोड करने में त्रुटि';

  @override
  String get profile_error_loading_services => 'सेवाएँ लोड करने में त्रुटि';

  @override
  String get profile_no_followers_yet => 'अभी तक कोई अनुयायी नहीं';

  @override
  String get profile_no_following_yet => 'अभी तक किसी को फ़ॉलो नहीं कर रहा हूँ';

  @override
  String get profile_follow => 'अनुसरण करना';

  @override
  String get profile_following_btn => 'अगले';

  @override
  String get profile_message => 'संदेश';

  @override
  String get profile_member_since => 'से सदस्य';

  @override
  String get profile_loading_error => 'प्रोफ़ाइल लोड करने में त्रुटि';

  @override
  String get profile_retry => 'पुनः प्रयास करें';

  @override
  String get profile_share => 'शेयर करना';

  @override
  String get profile_copy_link => 'लिंक की प्रतिलिपि करें';

  @override
  String get profile_report => 'प्रतिवेदन';

  @override
  String get linkCopied => 'लिंक को क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get checkOutProfile => 'चेक आउट';

  @override
  String get onTezsell => 'TezSell पर';

  @override
  String get selectCountryFirst => 'सबसे पहले देश चुनें';

  @override
  String get countrySelectionHint => 'फिर आप अपना क्षेत्र चुन सकते हैं';

  @override
  String get something_went_wrong => 'कुछ गलत हो गया';

  @override
  String get check_connection_and_retry =>
      'अपने इंटरनेट कनेक्शन की जाँच करें और पुन: प्रयास करें';

  @override
  String get sold_badge => 'बिका हुआ';

  @override
  String get reserved_badge => 'RESERVED';

  @override
  String get recently_viewed_title => 'Recently viewed';

  @override
  String get more_categories => 'अधिक';

  @override
  String no_products_in_location(String location) {
    return '$location में कोई उत्पाद नहीं मिला';
  }

  @override
  String get no_more_products => 'लोड करने के लिए और कोई उत्पाद नहीं';

  @override
  String time_days_ago(int count) {
    return '${count}d पहले';
  }

  @override
  String time_hours_ago(int count) {
    return '${count}h पहले';
  }

  @override
  String time_minutes_ago(int count) {
    return '${count}m पहले';
  }

  @override
  String get time_just_now => 'बस अब';

  @override
  String no_services_in_location(String location) {
    return '$location में कोई सेवा नहीं मिली';
  }

  @override
  String get no_more_services => 'लोड करने के लिए और कोई सेवाएँ नहीं';

  @override
  String get error_loading_more_services => 'अधिक सेवाएँ लोड करने में त्रुटि';

  @override
  String get verification_code_length => 'सत्यापन कोड 6 अंकों का होना चाहिए';

  @override
  String get map_register_title => 'आप कहाँ रहते हैं?';

  @override
  String get map_register_headline => 'मानचित्र पर अपना पड़ोस चुनें';

  @override
  String get map_register_subtitle =>
      'हम इसका उपयोग आपको आस-पास के खरीदार और विक्रेता दिखाने के लिए करते हैं। आप बाद में अपना दायरा समायोजित कर सकते हैं.';

  @override
  String get pick_on_map => 'मानचित्र पर चुनें';

  @override
  String get pick_again => 'फिर से चुनें';

  @override
  String get resolving_location => 'स्थान का समाधान किया जा रहा है...';

  @override
  String get use_dropdown_instead => 'इसके बजाय ड्रॉपडाउन का उपयोग करें';

  @override
  String country_not_supported(String country) {
    return 'हम अभी तक $country का समर्थन नहीं करते हैं।';
  }

  @override
  String get region_not_auto_detected =>
      'आपके क्षेत्र का स्वत: पता नहीं लगाया जा सका - इसे मैन्युअल रूप से चुनें।';

  @override
  String get district_not_auto_detected =>
      'आपके जिले का स्वत: पता नहीं लगाया जा सका - इसे मैन्युअल रूप से चुनें।';

  @override
  String get browse_no_items_with_location =>
      'इस क्षेत्र में अभी तक स्थान डेटा वाला कोई आइटम नहीं है।';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => 'स्थान निर्धारित करें';

  @override
  String get location_picker_confirm => 'स्थान की पुष्टि करें';

  @override
  String get location_picker_resolve_failed =>
      'पता हल नहीं किया जा सका - दोबारा चुनें या केवल निर्देशांक से पुष्टि करें';

  @override
  String get location_picker_selected_fallback => 'चयनित स्थान';

  @override
  String get location_permission_denied => 'स्थान की अनुमति अस्वीकृत';

  @override
  String get location_permission_denied_settings =>
      'स्थान की अनुमति अस्वीकृत - कृपया सेटिंग्स में सक्षम करें';

  @override
  String get location_permission_permanent =>
      'स्थान स्थायी रूप से अस्वीकृत - सक्षम करने के लिए सेटिंग्स खोलें';

  @override
  String gps_error(String error) {
    return 'जीपीएस त्रुटि: $error';
  }

  @override
  String get verify_neighborhood_title => 'अपने पड़ोस का सत्यापन करें';

  @override
  String get verify_neighborhood_subtitle =>
      'अपने पड़ोस में खड़े हो जाओ. हम आपके जीपीएस की जांच करेंगे और आपसे पुष्टि करने के लिए कहेंगे।';

  @override
  String get verify_neighborhood_button => 'पड़ोस सत्यापित करें';

  @override
  String get verify_neighborhood_low_confidence =>
      'कम आत्मविश्वास के साथ जारी रखें';

  @override
  String get verify_neighborhood_retry => 'पुन: प्रयास करें';

  @override
  String get verify_neighborhood_youre_in => 'आप रहेंगे:';

  @override
  String verify_neighborhood_done(String name) {
    return 'सत्यापित! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'जीपीएस सटीकता ${meters}m है (≤100m की आवश्यकता है)। किसी खुले क्षेत्र में जाएँ और पुनः प्रयास करें।';
  }

  @override
  String get neighborhood_not_identified =>
      'आपके स्थान के लिए पड़ोस की पहचान नहीं की जा सकी.';

  @override
  String get unknown_error => 'अज्ञात त्रुटि';

  @override
  String get place_search_hint => 'कोई पता या स्थान खोजें';

  @override
  String get place_search_unavailable =>
      'खोज अनुपलब्ध है - इसके बजाय एक पिन डालें';

  @override
  String get radius_slider_city => 'शहर';

  @override
  String radius_slider_km(String value) {
    return '$value किमी';
  }

  @override
  String get my_neighborhoods => 'मेरे मोहल्ले';

  @override
  String get manage_on_map => 'मानचित्र पर प्रबंधित करें';

  @override
  String get no_neighborhoods_yet =>
      'अभी तक कोई सत्यापित मोहल्ला नहीं है। जहाँ आप हैं उसे सत्यापित करने के लिए मानचित्र खोलें।';

  @override
  String get open_map_to_verify =>
      'नए स्थान को सत्यापित करने के लिए मानचित्र खोलें';

  @override
  String get verify_here => 'यहाँ सत्यापित करें';

  @override
  String get verify_new_location => 'नया स्थान सत्यापित करें';

  @override
  String eviction_warning(String name) {
    return 'इस स्थान को जोड़ने से $name (सबसे पुराना) हट जाएगा। यह पूर्ववत नहीं किया जा सकता।';
  }

  @override
  String get verified_today => 'आज सत्यापित';

  @override
  String get verified_yesterday => 'कल सत्यापित';

  @override
  String verified_n_days_ago(int days) {
    return '$days दिन पहले सत्यापित';
  }

  @override
  String get active_neighborhood => 'सक्रिय';

  @override
  String switch_neighborhood_success(String name) {
    return '$name पर स्विच किया';
  }

  @override
  String get communityAll => 'All';

  @override
  String get communityQuestion => 'Question';

  @override
  String get communityRecommend => 'Tips';

  @override
  String get communityFree => 'Free';

  @override
  String get communityLostFound => 'Lost & Found';

  @override
  String get communityAlert => 'Alert';

  @override
  String get communityGeneral => 'General';

  @override
  String get communityWrite => 'Write';

  @override
  String get communityEmpty => 'No posts yet. Be the first!';

  @override
  String get communityPostTitle => 'Post';

  @override
  String get communityNoComments => 'No comments yet';

  @override
  String get communityAddComment => 'Add a comment…';

  @override
  String get communityNewPost => 'New post';

  @override
  String get communityPublish => 'Post';

  @override
  String get communityBodyHint => 'Share something with your neighborhood…';

  @override
  String get communityPostFailed => 'Failed to post';

  @override
  String get communityAddPoll => 'Add poll';

  @override
  String get communityPollQuestion => 'Poll question';

  @override
  String communityPollOption(int n) {
    return 'Option $n';
  }

  @override
  String get communityAddOption => 'Add option';

  @override
  String get communityPollValidation => 'Add a question and 2-5 options';

  @override
  String communityPollVotes(int n) {
    return '$n votes';
  }

  @override
  String get communityMaxImages => 'Up to 5 photos';

  @override
  String get communitySearchHint => 'Search posts…';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCommunity => 'Community';

  @override
  String get tabNearby => 'Nearby';

  @override
  String get tabMy => 'My';

  @override
  String get nearbyServices => 'Services';

  @override
  String get nearbyRealEstate => 'Real Estate';

  @override
  String get nearbyJobs => 'Jobs';

  @override
  String get nearbyShops => 'Local shops';

  @override
  String get nearbyComingSoon => 'Coming soon';

  @override
  String get chatWithSeller => 'Chat with seller';

  @override
  String get chatQuickAvailable => 'Is this still available?';

  @override
  String get chatQuickPrice => 'Can you lower the price?';

  @override
  String get chatQuickMeet => 'Where can we meet?';

  @override
  String get chatReserve => 'Reserve';

  @override
  String get chatMarkSold => 'Mark as sold';

  @override
  String get chatMarkAvailable => 'Back to available';

  @override
  String get chatStatusReserved => 'Reserved';

  @override
  String get chatStatusSold => 'Sold';

  @override
  String get chatStatusAvailable => 'Available';

  @override
  String get chatSysReserved => 'Seller marked this item as reserved';

  @override
  String get chatSysSold => 'Seller marked this item as sold';

  @override
  String get chatSysAvailable => 'This item is available again';

  @override
  String get chatLeaveReview => 'Leave a review';

  @override
  String get chatReply => 'Reply';

  @override
  String get chatEdit => 'Edit';

  @override
  String get chatEdited => 'edited';

  @override
  String get chatDelete => 'Delete';

  @override
  String get chatDeleteForMe => 'Delete for me';

  @override
  String get chatDeleteForEveryone => 'Delete for everyone';

  @override
  String get chatMessageDeleted => 'Message deleted';

  @override
  String get chatCopy => 'Copy';

  @override
  String get chatCopied => 'Copied';

  @override
  String get chatForward => 'Forward';

  @override
  String get chatForwarded => 'Forwarded';

  @override
  String get chatForwardTo => 'Forward to…';

  @override
  String get chatPin => 'Pin';

  @override
  String get chatUnpin => 'Unpin';

  @override
  String get chatPinnedMessages => 'Pinned messages';

  @override
  String get chatTranslate => 'Translate';

  @override
  String get chatTranslationFailed => 'Translation unavailable';

  @override
  String get chatShowOriginal => 'Show original';

  @override
  String get chatSearchInChat => 'Search in chat';

  @override
  String get chatNoResults => 'No results';

  @override
  String get chatMute => 'Mute';

  @override
  String get chatUnmute => 'Unmute';

  @override
  String get chatArchive => 'Archive';

  @override
  String get chatUnarchive => 'Unarchive';

  @override
  String get chatArchived => 'Archived';

  @override
  String get chatPinChat => 'Pin chat';

  @override
  String get chatUnpinChat => 'Unpin chat';

  @override
  String get chatTyping => 'typing…';

  @override
  String get chatOnline => 'online';

  @override
  String chatLastSeen(Object time) {
    return 'last seen $time';
  }

  @override
  String get timeJustNow => 'just now';

  @override
  String timeMinutesShort(Object m) {
    return '${m}m ago';
  }

  @override
  String timeHoursShort(Object h) {
    return '${h}h ago';
  }

  @override
  String get chatConnecting => 'Reconnecting…';

  @override
  String get chatSendFailed => 'Not sent. Tap to retry';

  @override
  String get chatVoiceMessage => 'Voice message';

  @override
  String get chatRecordingHint => 'Release to send, slide to cancel';

  @override
  String get chatQuickReplies => 'Quick replies';

  @override
  String get chatAddQuickReply => 'Add quick reply';

  @override
  String get chatMediaGallery => 'Media';

  @override
  String get chatUnreadDivider => 'Unread messages';

  @override
  String get chatDraft => 'Draft';

  @override
  String get chatSelfChatError => 'You can\'t chat about your own listing';

  @override
  String get sortFresh => 'Newest';

  @override
  String get sortNearest => 'Nearest';

  @override
  String get sortPopular => 'Popular';

  @override
  String get sortPriceAsc => 'Price: low to high';

  @override
  String get sortPriceDesc => 'Price: high to low';

  @override
  String get communityDeleteConfirm => 'Delete this post?';

  @override
  String distanceKm(String km) {
    return '$km km';
  }

  @override
  String get nearYouNow => 'Near you now';

  @override
  String get radiusPickerTitle => 'Search radius';

  @override
  String get radiusCityWide => 'City-wide';

  @override
  String get radiusApply => 'Apply';

  @override
  String communityViewReplies(int n) {
    return 'View $n replies';
  }

  @override
  String get communityAuthorBadge => 'Author';

  @override
  String get communityDeleteCommentConfirm => 'Delete this comment?';

  @override
  String get communityLoadMoreComments => 'Load more comments';

  @override
  String get productFiltersTitle => 'Filters';

  @override
  String get productFiltersTooltip => 'Filters';

  @override
  String get productFilterPriceRange => 'Price range';

  @override
  String get productFilterPriceMin => 'Min';

  @override
  String get productFilterPriceMax => 'Max';

  @override
  String get productFilterCondition => 'Condition';

  @override
  String get productFilterApply => 'Apply';

  @override
  String get productFilterReset => 'Reset';

  @override
  String get offersMenuTitle => 'Offers';

  @override
  String get offersMenuSubtitle => 'Track price negotiations';

  @override
  String get offerContinueChat => 'Continue in chat';

  @override
  String get offerSendSuccess => 'Offer sent!';

  @override
  String get offerLoginRequired => 'Please log in to make an offer';

  @override
  String get offerOpenChatError => 'Unable to open chat';

  @override
  String get sellerNoReviews => 'No reviews yet';

  @override
  String get savedSearchSaveTooltip => 'Save search';

  @override
  String get savedSearchesManageTooltip => 'Saved searches';

  @override
  String get savedSearchSheetTitle => 'Save this search';

  @override
  String get savedSearchNotifyToggleTitle => 'Notify me about new matches';

  @override
  String get savedSearchNotifyToggleSubtitle =>
      'We\'ll alert you when new listings match this search';

  @override
  String get savedSearchSavedSuccess => 'Search saved';

  @override
  String get savedSearchSavedWithAlertSuccess =>
      'Search saved. You\'ll be notified about new matches.';

  @override
  String get savedSearchAlreadySaved => 'You already saved this search';

  @override
  String get savedSearchSaveGenericError => 'Failed to save search';

  @override
  String get searchAlertCreateGenericError => 'Failed to enable alert';

  @override
  String get savedSearchesScreenTitle => 'Saved Searches';

  @override
  String get savedSearchesTabLabel => 'Searches';

  @override
  String get searchAlertsTabLabel => 'Alerts';

  @override
  String get savedSearchesEmptyTitle => 'No saved searches yet';

  @override
  String get savedSearchesEmptySubtitle =>
      'Save a search to quickly find it again later';

  @override
  String get searchAlertsEmptyTitle => 'No alerts yet';

  @override
  String get searchAlertsEmptySubtitle =>
      'Save a search and turn on notifications to get alerted about new matches';

  @override
  String savedSearchUseCount(int count) {
    return 'Used $count times';
  }

  @override
  String get savedSearchDeleteTooltip => 'Delete saved search';

  @override
  String get searchAlertDeleteTooltip => 'Delete alert';

  @override
  String get savedSearchDeleteConfirmTitle => 'Delete saved search?';

  @override
  String get savedSearchDeleteConfirmMessage =>
      'This will remove the saved search. This action cannot be undone.';

  @override
  String get searchAlertDeleteConfirmTitle => 'Delete alert?';

  @override
  String get searchAlertDeleteConfirmMessage =>
      'You will no longer be notified about new matches for this keyword.';

  @override
  String get savedSearchDeletedSuccess => 'Saved search deleted';

  @override
  String get searchAlertDeletedSuccess => 'Alert deleted';

  @override
  String get savedSearchDeleteError => 'Failed to delete saved search';

  @override
  String get searchAlertDeleteError => 'Failed to delete alert';

  @override
  String get searchAlertToggleError => 'Failed to update alert';

  @override
  String get savedSearchesLoadError => 'Failed to load saved searches';

  @override
  String get searchAlertsLoadError => 'Failed to load alerts';

  @override
  String get reviewWriteTitle => 'Write a review';

  @override
  String get reviewWriteRatingLabel => 'How was your experience?';

  @override
  String get reviewWriteRatingRequiredHint =>
      'Select at least 1 star to submit';

  @override
  String get reviewWriteTagsLabel => 'What went well? (optional)';

  @override
  String get reviewWriteCommentLabel => 'Additional comments (optional)';

  @override
  String get reviewWriteCommentHint => 'Share more about your experience…';

  @override
  String get reviewWriteSubmitButton => 'Submit review';

  @override
  String get reviewWriteSuccess => 'Review submitted successfully';

  @override
  String get reviewWriteError => 'Failed to submit review. Please try again.';

  @override
  String get reviewWriteLoadingTransaction => 'Loading transaction details…';
}
