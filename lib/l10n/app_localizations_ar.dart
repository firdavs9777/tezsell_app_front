// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcome => 'مرحباً';

  @override
  String get welcomeBack => 'مرحبًا بعودتك!';

  @override
  String get loginToYourAccount => 'تسجيل الدخول للمتابعة';

  @override
  String get or => 'أو';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get chooseLanguage => 'اختر لغتك';

  @override
  String get selectPreferredLanguage => 'اختر لغتك المفضلة للتطبيق';

  @override
  String get continueButton => 'يكمل';

  @override
  String get continueWithGoogle => 'تواصل مع جوجل';

  @override
  String get continueWithApple => 'تواصل مع أبل';

  @override
  String get continueWithEmail => 'تواصل مع البريد الإلكتروني';

  @override
  String get sellAndBuyProducts => 'بيع وشراء أي من منتجاتك معنا فقط';

  @override
  String get usedProductsMarket => 'المنتجات المستعملة أو السوق المستعملة';

  @override
  String get home_welcome_title => 'السوق الحي الخاص بك';

  @override
  String get home_welcome_subtitle =>
      'شراء وبيع مع الناس في مكان قريب.\nآمنة وبسيطة ومحلية.';

  @override
  String get home_get_started => 'ابدأ';

  @override
  String get home_sign_in => 'لدي حساب بالفعل';

  @override
  String get home_terms_notice =>
      'من خلال المتابعة، فإنك توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا';

  @override
  String get register => 'يسجل';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginToAccount => 'تسجيل الدخول إلى الحساب';

  @override
  String get enterPhoneNumber => 'أدخل رقم الهاتف';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة السر؟';

  @override
  String get registerNow => 'سجل الآن';

  @override
  String get loading => 'تحميل...';

  @override
  String get pleaseEnterPhoneNumber => 'الرجاء إدخال رقم هاتفك';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور الخاصة بك';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get forgotPasswordComingSoon => 'ميزة نسيت كلمة المرور قريبا';

  @override
  String get selectedCountryLabel => 'المحدد:';

  @override
  String get fullPhoneLabel => 'ممتلىء:';

  @override
  String get home => 'بيت';

  @override
  String get settings => 'إعدادات';

  @override
  String get profile => 'حساب تعريفي';

  @override
  String get search => 'يبحث';

  @override
  String get notifications => 'إشعارات';

  @override
  String get error => 'خطأ';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get cancel => 'يلغي';

  @override
  String get save => 'يحفظ';

  @override
  String get appTitle => 'تيسيل';

  @override
  String get selectRegion => 'الرجاء تحديد منطقتك';

  @override
  String get searchHint => 'بحث المنطقة أو المدينة';

  @override
  String get apiError =>
      'حدثت مشكلة أثناء الاتصال بواجهة برمجة التطبيقات (API).';

  @override
  String get ok => 'نعم';

  @override
  String get emptyList => 'قائمة فارغة';

  @override
  String get dataLoadingError => 'هناك خطأ أثناء تحميل البيانات';

  @override
  String get confirm => 'يتأكد';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String confirmRegionSelection(Object regionName) {
    return 'هل تريد تحديد منطقة $regionName؟';
  }

  @override
  String get selectDistrictOrCity => 'الرجاء تحديد منطقتك أو مدينتك';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return 'هل تريد تحديد منطقة $regionName - $districtName؟';
  }

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج.';

  @override
  String errorWithCode(String errorCode) {
    return 'خطأ: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'فشل تحميل البيانات. خطأ: $error';
  }

  @override
  String get phoneVerification => 'التحقق من رقم الهاتف';

  @override
  String get enterPhonePrompt => 'الرجاء إدخال رقم هاتفك';

  @override
  String get enterPhoneNumberHint => 'أدخل رقم الهاتف';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'المحدد: $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'اختر بلدك';

  @override
  String get changeCountry => 'تغيير البلد';

  @override
  String get country => 'دولة';

  @override
  String get allCountries => 'جميع البلدان';

  @override
  String get currencyRUB => 'الروبل الروسي';

  @override
  String get currencyUAH => 'الهريفنيا الأوكرانية';

  @override
  String get currencyBYN => 'الروبل البيلاروسي';

  @override
  String get currencyMDL => 'ليو المولدوفي';

  @override
  String get currencyGEL => 'لاري جورجي';

  @override
  String get currencyAMD => 'الدراما الأرمنية';

  @override
  String get currencyAZN => 'مانات الأذربيجانية';

  @override
  String get currencyKZT => 'تنغي الكازاخستاني';

  @override
  String get currencyTMT => 'تركمان مانات';

  @override
  String get currencyKGS => 'السوم القرغيزستاني';

  @override
  String get currencyTJS => 'السوموني الطاجيكستاني';

  @override
  String get currencyUZS => 'السوم الأوزبكي';

  @override
  String get currencyUSD => 'الدولار الأمريكي';

  @override
  String get currencyEUR => 'اليورو';

  @override
  String fullNumber(String phoneNumber) {
    return 'العدد الكامل: $phoneNumber';
  }

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get enterVerificationCode => 'أدخل رمز التحقق';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String expires(String time) {
    return 'تنتهي: $time';
  }

  @override
  String get verifyAndContinue => 'التحقق والمتابعة';

  @override
  String get invalidVerificationCode => 'رمز التحقق غير صالح';

  @override
  String get verificationCodeSent => 'تم إرسال رمز التحقق بنجاح';

  @override
  String get failedToSendCode => 'فشل في إرسال رمز التحقق';

  @override
  String get verificationCodeResent => 'تمت إعادة إرسال رمز التحقق بنجاح';

  @override
  String get failedToResendCode => 'فشل في إعادة إرسال رمز التحقق';

  @override
  String get passwordVerification => 'التحقق من كلمة المرور';

  @override
  String get completeRegistrationPrompt =>
      'أدخل اسم المستخدم وكلمة المرور لإكمال التسجيل';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get username_required => 'اسم المستخدم مطلوب';

  @override
  String get username_min_length =>
      'يجب أن يتكون اسم المستخدم من حرفين على الأقل';

  @override
  String get usernameHint => 'اسم المستخدم123';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get profileImage => 'صورة الملف الشخصي';

  @override
  String get imageInstructions =>
      'سوف تظهر الصور هنا، الرجاء الضغط على صورة الملف الشخصي';

  @override
  String get finish => 'ينهي';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get registrationError => 'خطأ في التسجيل';

  @override
  String get about => 'معلومات عنا';

  @override
  String get chat => 'محادثة';

  @override
  String get realEstate => 'العقارات';

  @override
  String get language => 'المهندس';

  @override
  String get languageEn => 'إنجليزي';

  @override
  String get languageRu => 'الروسية';

  @override
  String get languageUz => 'الأوزبكية';

  @override
  String get serviceLiked => 'أحببت الخدمة';

  @override
  String get support => 'يدعم';

  @override
  String get service => 'خدمات الأعمال';

  @override
  String get aboutContent =>
      'TezSell هو سوق سريع وسهل لبيع وشراء المنتجات الجديدة والمستعملة. مهمتنا هي إنشاء النظام الأساسي الأكثر ملاءمة وكفاءة لكل مستخدم، مما يضمن المعاملات السلسة وتجربة سهلة الاستخدام. سواء كنت تتطلع إلى البيع أو الشراء، فإن TezSell تسهل عليك الاتصال وإكمال المعاملات في بضع خطوات فقط. نحن نعطي الأولوية لأمان وخصوصية مستخدمينا. تتم مراقبة جميع المعاملات بعناية لضمان السلامة والامتثال، مما يوفر راحة البال لكل من المشترين والبائعين. تتيح واجهتنا البسيطة والبديهية للمستخدمين إدراج المنتجات بسرعة والعثور على ما يحتاجون إليه. نقوم أيضًا بتسهيل الاتصال في الوقت الفعلي من خلال Telegram، مما يجعل عملية البيع والشراء أكثر سلاسة.';

  @override
  String get errorMessage => 'حدث خطأ، يرجى التحقق من الخادم';

  @override
  String get searchLocation => 'موقع';

  @override
  String get searchCategory => 'فئات';

  @override
  String get searchProductPlaceholder => 'البحث عن المنتجات';

  @override
  String get searchServicePlaceholder => 'البحث عن الخدمات';

  @override
  String get search_products_subtitle => 'العثور على صفقات كبيرة في منطقتك';

  @override
  String get search_services_subtitle => 'البحث عن المهنيين في منطقتك';

  @override
  String get search_products_error => 'خطأ في البحث عن المنتجات';

  @override
  String get search_services_error => 'خطأ في البحث عن الخدمات';

  @override
  String get load_more_products_error =>
      'حدث خطأ أثناء تحميل المزيد من المنتجات';

  @override
  String get load_more_services_error =>
      'حدث خطأ أثناء تحميل المزيد من الخدمات';

  @override
  String get try_different_keywords => 'جرب كلمات رئيسية مختلفة';

  @override
  String get searchText => 'يبحث';

  @override
  String get selectedCategory => 'الفئة المختارة:';

  @override
  String get selectedLocation => 'الموقع المحدد:';

  @override
  String get productError => 'لا توجد منتجات متاحة';

  @override
  String get serviceError => 'لا توجد خدمات متاحة';

  @override
  String get locationHeader => 'حدد الموقع';

  @override
  String get locationPlaceholder => 'منطقة البحث هنا';

  @override
  String get categoryHeader => 'اختر فئة';

  @override
  String get categoryPlaceholder => 'فئات البحث';

  @override
  String get categoryError => 'لا توجد فئات متاحة';

  @override
  String get paginationFirst => 'أولاً';

  @override
  String get paginationPrevious => 'سابق';

  @override
  String get pageInfo => 'صفحة من';

  @override
  String get pageNext => 'التالي';

  @override
  String get pageLast => 'آخر';

  @override
  String get loadingMessageProduct => 'جارٍ تحميل المنتجات...';

  @override
  String get loadingMessageError => 'حدث خطأ أثناء التحميل';

  @override
  String get likeProductError => 'حدث خطأ أثناء الإعجاب بالمنتج';

  @override
  String get dislikeProductError => 'حدث خطأ أثناء عدم الإعجاب بالمنتج';

  @override
  String get loadingMessageLocation => 'جارٍ تحميل الموقع...';

  @override
  String get loadingLocationError => 'حدث خطأ أثناء تحميل الموقع';

  @override
  String get loadingMessageCategory => 'جارٍ تحميل الفئات...';

  @override
  String get loadingCategoryError => 'حدث خطأ أثناء تحميل الفئات:';

  @override
  String get profileUpdateSuccessMessage => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get profileUpdateFailMessage => 'فشل في تحديث الملف الشخصي';

  @override
  String get seeMoreBtn => 'شاهد المزيد';

  @override
  String get profilePageTitle => 'صفحة الملف الشخصي';

  @override
  String get editProfileModalTitle => 'تحرير الملف الشخصي';

  @override
  String get usernameLabel => 'اسم المستخدم';

  @override
  String get locationLabel => 'الموقع الحالي';

  @override
  String get profileImageLabel => 'صورة الملف الشخصي';

  @override
  String get chooseFileLabel => 'اختر ملفًا';

  @override
  String get uploadBtnLabel => 'تحديث';

  @override
  String get uploadingBtnLabel => 'جارٍ التحديث...';

  @override
  String get cancelBtnLabel => 'يلغي';

  @override
  String get productsTitle => 'منتجات';

  @override
  String get servicesTitle => 'خدمات';

  @override
  String get myProductsTitle => 'منتجاتي';

  @override
  String get myServicesTitle => 'خدماتي';

  @override
  String get favoriteProductsTitle => 'المنتجات المفضلة';

  @override
  String get favoriteServicesTitle => 'الخدمات المفضلة';

  @override
  String get noFavorites => 'لا المفضلة';

  @override
  String get addNewProductBtn => 'إضافة منتج جديد';

  @override
  String get addNew => 'جديد';

  @override
  String get addNewServiceBtn => 'إضافة خدمة جديدة';

  @override
  String get downloadMobileApp => 'قم بتنزيل تطبيق الهاتف المحمول';

  @override
  String get registerPhoneNumberSuccess =>
      'تم التحقق من رقم الهاتف! يمكنك المتابعة إلى الخطوة التالية.';

  @override
  String get regionSelectedMessage => 'المنطقة المحددة:';

  @override
  String get districtSelectMessage => 'المنطقة المختارة:';

  @override
  String get phoneNumberEmptyMessage => 'يرجى التحقق من رقم هاتفك قبل المتابعة';

  @override
  String get regionEmptyMessage => 'الرجاء تحديد المنطقة أولا';

  @override
  String get districtEmptyMessage => 'الرجاء تحديد المنطقة';

  @override
  String get usernamePasswordEmptyMessage =>
      'الرجاء إدخال اسم المستخدم وكلمة المرور';

  @override
  String get registerTitle => 'يسجل';

  @override
  String get previousButton => 'سابق';

  @override
  String get nextButton => 'التالي';

  @override
  String get completeButton => 'مكتمل';

  @override
  String stepIndicator(int currentStep) {
    return 'الخطوة $currentStep من أصل 4';
  }

  @override
  String get districtSelectTitle => 'قائمة المنطقة';

  @override
  String get districtSelectParagraph => 'اختر المنطقة:';

  @override
  String get phoneNumber => 'رقم التليفون';

  @override
  String get sendOtp => 'أرسل كلمة مرور لمرة واحدة';

  @override
  String get sendAgain => 'أرسل مرة أخرى';

  @override
  String get verify => 'يؤكد';

  @override
  String get failedToSendOtp => 'فشل إرسال OTP. عاد الخادم كاذبة.';

  @override
  String get errorSendingOtp => 'حدث خطأ أثناء إرسال OTP.';

  @override
  String get invalidPhoneNumber => 'الرجاء إدخال رقم هاتف صالح.';

  @override
  String get verificationSuccess => 'تم التحقق بنجاح';

  @override
  String get verificationError =>
      'حدث خطأ. يرجى المحاولة مرة أخرى في وقت لاحق.';

  @override
  String get regionsList => 'قائمة المناطق';

  @override
  String get enterUsername => 'أدخل اسم المستخدم الخاص بك';

  @override
  String get welcomeMessage =>
      'مرحبًا بك في Tezsell، قم بتسجيل الدخول باستخدام رقم هاتفك';

  @override
  String get noAccount => 'ليس لديك حساب بعد؟ سجل هنا';

  @override
  String get successLogin => 'تم تسجيل الدخول بنجاح';

  @override
  String get myProfile => 'ملفي الشخصي';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get newProductTitle => 'عنوان';

  @override
  String get newProductDescription => 'وصف';

  @override
  String get newProductPrice => 'سعر';

  @override
  String get newProductCondition => 'حالة';

  @override
  String get newProductCategory => 'فئة';

  @override
  String get newProductImages => 'الصور';

  @override
  String get addNewService => 'إضافة خدمة جديدة';

  @override
  String get creating => 'جارٍ الإنشاء...';

  @override
  String get serviceName => 'اسم الخدمة';

  @override
  String get serviceNamePlaceholder => 'أدخل عنوان الخدمة';

  @override
  String get serviceDescription => 'وصف الخدمة';

  @override
  String get serviceDescriptionPlaceholder => 'أدخل وصف الخدمة';

  @override
  String get serviceCategory => 'فئة الخدمة';

  @override
  String get selectCategory => 'اختر الفئة';

  @override
  String get loadingCategories => 'تحميل...';

  @override
  String get errorLoadingCategories => 'حدث خطأ أثناء تحميل الفئات';

  @override
  String get serviceImages => 'صور الخدمة';

  @override
  String get imageUploadHelper =>
      'انقر على أيقونة + لإضافة صور (الحد الأقصى 10)';

  @override
  String get maxImagesError => 'يمكنك تحميل 10 صور كحد أقصى';

  @override
  String get categoryNotFound => 'لم يتم العثور على الفئة';

  @override
  String get productCreatedSuccess => 'تم إنشاء المنتج بنجاح';

  @override
  String get productLikeSuccess => 'المنتج أحب بنجاح';

  @override
  String get productDislikeSuccess => 'تم عدم إعجاب المنتج بنجاح';

  @override
  String get errorCreatingService => 'حدث خطأ أثناء إنشاء الخدمة';

  @override
  String get errorCreatingProduct => 'حدث خطأ أثناء إنشاء المنتج';

  @override
  String get unknownError => 'حدث خطأ غير معروف أثناء إنشاء الخدمة';

  @override
  String get submit => 'يُقدِّم';

  @override
  String get selectCategoryAction => 'حدد الفئة';

  @override
  String get selectCondition => 'حدد الحالة';

  @override
  String get sum => 'مجموع';

  @override
  String get noComments => 'لا توجد تعليقات حتى الآن. كن أول من يعلق!';

  @override
  String get commentLikeSuccess => 'تم الإعجاب بالتعليق بنجاح';

  @override
  String get commentLikeError => 'حدث خطأ أثناء الإعجاب بالتعليق';

  @override
  String get unknownErrorMessage => 'حدث خطأ غير معروف';

  @override
  String get commentDislikeSuccess => 'تم عدم الإعجاب بالتعليق بنجاح';

  @override
  String get commentDislikeError => 'حدث خطأ أثناء عدم الإعجاب بالتعليق';

  @override
  String get replyInfo => 'الرجاء إدخال الرد أولا';

  @override
  String get replySuccessMessage => 'تمت إضافة الرد بنجاح';

  @override
  String get replyErrorMessage => 'حدث خطأ أثناء إنشاء الرد';

  @override
  String get commentUpdateSuccess => 'تم تحديث التعليق بنجاح';

  @override
  String get commentUpdateError => 'حدث خطأ أثناء تحديث عنصر التعليق';

  @override
  String get deleteConfirmationMessage =>
      'هل أنت متأكد أنك تريد حذف هذا التعليق؟';

  @override
  String get commentDeleteSuccess => 'تم حذف التعليق بنجاح';

  @override
  String get commentDeleteError => 'حدث خطأ أثناء حذف التعليق';

  @override
  String get editLabel => 'يحرر';

  @override
  String get deleteLabel => 'يمسح';

  @override
  String get saveLabel => 'يحفظ';

  @override
  String get replyLabel => 'رد';

  @override
  String get replyTitle => 'الردود';

  @override
  String get replyPlaceholder => 'أكتب الرد...';

  @override
  String get chatLoginMessage => 'يجب عليك تسجيل الدخول لبدء الدردشة';

  @override
  String get chatYourselfMessage => 'لا يمكنك الدردشة مع نفسك.';

  @override
  String get chatRoomMessage => 'تم إنشاء غرفة الدردشة!';

  @override
  String get chatRoomError => 'فشل في إنشاء الدردشة!';

  @override
  String get chatCreationError => 'فشل إنشاء الدردشة!';

  @override
  String get productsTotal => 'إجمالي المنتجات';

  @override
  String get perPage => 'أغراض';

  @override
  String get clearAllFilters => 'مسح كافة عوامل التصفية';

  @override
  String get clickToUpload => 'انقر للتحميل';

  @override
  String get productInStock => 'في الأوراق المالية';

  @override
  String get productOutStock => 'إنتهى من المخزن';

  @override
  String get productBack => 'العودة إلى المنتجات';

  @override
  String get messageSeller => 'محادثة';

  @override
  String get recommendedProducts => 'المنتجات الموصى بها';

  @override
  String get deleteConfirmationProduct =>
      'هل أنت متأكد أنك تريد حذف هذا المنتج؟';

  @override
  String get productDeleteSuccess => 'تم حذف المنتج بنجاح';

  @override
  String get productDeleteError => 'حدث خطأ أثناء حذف المنتج';

  @override
  String get newCondition => 'جديد';

  @override
  String get used => 'مستخدم';

  @override
  String get imageValidType =>
      'لم تتم إضافة بعض الملفات. يرجى استخدام ملفات JPG أو PNG أو GIF أو WebP التي يقل حجمها عن 5 ميجابايت.';

  @override
  String get imageConfirmMessage => 'هل أنت متأكد أنك تريد إزالة هذه الصورة؟';

  @override
  String get titleRequiredMessage => 'العنوان مطلوب';

  @override
  String get descRequiredMessage => 'الوصف مطلوب';

  @override
  String get priceRequiredMessage => 'السعر مطلوب';

  @override
  String get conditionRequiredMessage => 'الشرط مطلوب';

  @override
  String get pleaseFillAllRequired => 'يرجى ملء الحقول المطلوبة';

  @override
  String get oneImageConfirmMessage => 'مطلوب صورة منتج واحدة على الأقل';

  @override
  String get categoryRequiredMessage => 'الفئة مطلوبة';

  @override
  String get locationInfoError => 'معلومات موقع المستخدم مفقودة';

  @override
  String get editProductTitle => 'تحرير المنتج';

  @override
  String get imageUploadRequirements =>
      'مطلوب صورة واحدة على الأقل. يمكنك تحميل ما يصل إلى 10 صور (JPG وPNG وGIF وWebP يقل حجم كل منها عن 5 ميجابايت).';

  @override
  String get productUpdatedSuccess => 'تم تحديث المنتج بنجاح';

  @override
  String get productUpdateFailed => 'فشل تحديث المنتج';

  @override
  String get errorUpdatingProduct => 'حدث خطأ أثناء تحديث المنتج';

  @override
  String get serviceBack => 'العودة إلى الخدمات';

  @override
  String get likeLabel => 'يحب';

  @override
  String get commentsLabel => 'تعليقات';

  @override
  String get writeComment => 'أكتب تعليق...';

  @override
  String get postingLabel => 'إرسال...';

  @override
  String get commentCreated => 'تم إنشاء التعليق';

  @override
  String get postCommentLabel => 'أضف تعليق';

  @override
  String get loginPrompt => 'الرجاء تسجيل الدخول لعرض وإضافة التعليقات.';

  @override
  String get recommendedServices => 'الخدمات الموصى بها';

  @override
  String get commentsVisibilityNotice =>
      'التعليقات مرئية فقط للمستخدمين الذين قاموا بتسجيل الدخول.';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get serviceUpdateSuccess => 'تم تحديث الخدمة بنجاح';

  @override
  String get serviceUpdateError => 'حدث خطأ أثناء تحديث عنصر الخدمة';

  @override
  String get editServiceModalTitle => 'تحرير الخدمة';

  @override
  String get enterPhoneNumberWithoutCode => 'أدخل رقم الهاتف بدون رمز';

  @override
  String get heroTitle => 'TezSell';

  @override
  String get heroSubtitle => 'سوقك السريع والسهل لأوزبكستان';

  @override
  String get startSelling => 'ابدأ البيع';

  @override
  String get browseProducts => 'تصفح المنتجات';

  @override
  String get featuresTitle => 'لماذا تختار TezSell؟';

  @override
  String get listingTitle => 'قائمة المنتجات البسيطة';

  @override
  String get listingDescription =>
      'قم بإدراج العناصر الخاصة بك ببضع نقرات فقط. أضف الصور وحدد السعر الخاص بك وتواصل مع المشترين على الفور.';

  @override
  String get locationTitle => 'التصفح على أساس الموقع';

  @override
  String get locationDescription =>
      'البحث عن صفقات بالقرب منك. يساعدك نظامنا المعتمد على الموقع على اكتشاف العناصر الموجودة في منطقتك.';

  @override
  String get location_subtitle => 'اختر منطقتك ومنطقتك لرؤية القوائم القريبة';

  @override
  String get categoryTitle => 'تصفية الفئة';

  @override
  String get categoryDescription =>
      'يمكنك التنقل بسهولة عبر الفئات المختلفة للعثور على ما تبحث عنه بالضبط.';

  @override
  String get inspirationTitle => 'مستوحاة من سوق الجزر في كوريا';

  @override
  String get inspirationDescription1 =>
      'لقد بنينا TezSell بإلهام من سوق الجزر الناجح في كوريا (당근마켓)، ولكننا قمنا بتصميمه خصيصًا لتلبية الاحتياجات الفريدة للمجتمعات المحلية في أوزبكستان.';

  @override
  String get inspirationDescription2 =>
      'مهمتنا هي إنشاء منصة جديرة بالثقة حيث يمكن للجيران الشراء والبيع والتواصل مع بعضهم البعض بسهولة.';

  @override
  String get comingSoonTitle => 'قريبا في TezSell';

  @override
  String get inAppChat => 'الدردشة داخل التطبيق';

  @override
  String get secureTransactions => 'المعاملات الآمنة';

  @override
  String get realEstateListings => 'قوائم العقارات';

  @override
  String get stayUpdated => 'ابق على اطلاع';

  @override
  String get comingSoonBadge => 'قريباً';

  @override
  String get ctaTitle => 'انضم إلى مجتمع TezSell اليوم!';

  @override
  String get ctaDescription =>
      'كن جزءًا من بناء تجربة سوق أفضل لأوزبكستان. شارك بتعليقاتك وساعدنا على النمو!';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get learnMore => 'يتعلم أكثر';

  @override
  String get replyUpdateSuccess => 'تم تحديث الرد بنجاح';

  @override
  String get replyUpdateError => 'فشل تحديث الرد';

  @override
  String get replyDeleteSuccess => 'تم حذف الرد بنجاح';

  @override
  String get replyDeleteError => 'فشل في حذف الرد';

  @override
  String get replyDeleteConfirmation => 'هل أنت متأكد أنك تريد حذف هذا الرد؟';

  @override
  String get authenticationRequired => 'المصادقة مطلوبة';

  @override
  String get enterValidReply => 'الرجاء إدخال نص رد صالح';

  @override
  String get saving => 'توفير...';

  @override
  String get deleting => 'جارٍ الحذف...';

  @override
  String get properties => 'ملكيات';

  @override
  String get agents => 'الوكلاء';

  @override
  String get becomeAgent => 'كن وكيلاً';

  @override
  String get main => 'رئيسي';

  @override
  String get upload => 'رفع';

  @override
  String get filtered_products => 'المنتجات التي تمت تصفيتها';

  @override
  String get filtered_services => 'الخدمات التي تمت تصفيتها';

  @override
  String get productDetail => 'تفاصيل المنتج';

  @override
  String get unknownUser => 'مستخدم غير معروف';

  @override
  String get locationNotAvailable => 'الموقع غير متوفر';

  @override
  String get noTitle => 'لا يوجد عنوان';

  @override
  String get noCategory => 'لا يوجد فئة';

  @override
  String get noDescription => 'لا يوجد وصف';

  @override
  String get som => 'سوم';

  @override
  String get about_me => 'ْعَنِّي';

  @override
  String get my_name => 'اسمي';

  @override
  String get customer_support => 'دعم العملاء';

  @override
  String get customer_center => 'مركز العملاء';

  @override
  String get customer_inquiries => 'الاستفسارات';

  @override
  String get customer_terms => 'الشروط والأحكام';

  @override
  String get region => 'منطقة';

  @override
  String get district => 'يصرف';

  @override
  String get tap_change_profile => 'انقر لتغيير الصورة';

  @override
  String get language_settings => 'إعدادات اللغة';

  @override
  String get selectLanguage => 'اختر لغة';

  @override
  String get select_theme => 'حدد الموضوع';

  @override
  String get theme => 'سمة';

  @override
  String get location_settings => 'إعدادات الموقع';

  @override
  String get security => 'حماية';

  @override
  String get data_storage => 'البيانات والتخزين';

  @override
  String get accessibility => 'إمكانية الوصول';

  @override
  String get privacy => 'خصوصية';

  @override
  String get light_theme => 'ضوء';

  @override
  String get dark_theme => 'مظلم';

  @override
  String get system_theme => 'النظام الافتراضي';

  @override
  String get my_products => 'منتجاتي';

  @override
  String get refresh => 'ينعش';

  @override
  String get delete_product => 'حذف المنتج';

  @override
  String get delete_confirmation => 'هل أنت متأكد أنك تريد حذف هذا المنتج؟';

  @override
  String get delete => 'يمسح';

  @override
  String error_loading_products(String error) {
    return 'خطأ في تحميل المنتجات: $error';
  }

  @override
  String get product_deleted_success => 'تم حذف المنتج بنجاح';

  @override
  String error_deleting_product(String error) {
    return 'حدث خطأ أثناء حذف المنتج: $error';
  }

  @override
  String get no_products_found => 'لم يتم العثور على منتجات';

  @override
  String get add_first_product => 'ابدأ بإضافة منتجك الأول';

  @override
  String get no_title => 'لا يوجد عنوان';

  @override
  String get no_description => 'لا يوجد وصف';

  @override
  String get in_stock => 'في الأوراق المالية';

  @override
  String get out_of_stock => 'إنتهى من المخزن';

  @override
  String get new_condition => 'جديد';

  @override
  String get edit_product => 'تحرير المنتج';

  @override
  String get delete_product_tooltip => 'حذف المنتج';

  @override
  String get sum_currency => 'مجموع';

  @override
  String get edit_product_title => 'تحرير المنتج';

  @override
  String get product_name => 'اسم المنتج';

  @override
  String get product_description => 'وصف المنتج';

  @override
  String get price => 'سعر';

  @override
  String get condition => 'حالة';

  @override
  String get condition_new => 'جديد';

  @override
  String get condition_used => 'مستخدم';

  @override
  String get condition_refurbished => 'مجدد';

  @override
  String get currency => 'عملة';

  @override
  String get category => 'فئة';

  @override
  String get images => 'الصور';

  @override
  String get existing_images => 'الصور الموجودة';

  @override
  String get new_images => 'صور جديدة';

  @override
  String get image_instructions =>
      'سوف تظهر الصور هنا. الرجاء الضغط على أيقونة التحميل أعلاه.';

  @override
  String get update_button => 'تحديث';

  @override
  String loading_category_error(String error) {
    return 'حدث خطأ أثناء تحميل الفئات: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'خطأ في اختيار الصور: $error';
  }

  @override
  String get please_fill_all_required => 'يرجى ملء جميع الحقول';

  @override
  String get invalid_price_message =>
      'تم إدخال سعر غير صالح. الرجاء إدخال رقم صالح.';

  @override
  String get category_required_message => 'الرجاء تحديد فئة صالحة.';

  @override
  String get one_image_required_message => 'مطلوب صورة منتج واحدة على الأقل';

  @override
  String get product_updated_success => 'تم تحديث المنتج بنجاح';

  @override
  String error_updating_product(String error) {
    return 'خطأ أثناء تحديث المنتج: $error';
  }

  @override
  String get my_services => 'خدماتي';

  @override
  String get delete_service => 'حذف الخدمة';

  @override
  String get delete_service_confirmation =>
      'هل أنت متأكد أنك تريد حذف هذه الخدمة؟';

  @override
  String get no_services_found => 'لم يتم العثور على الخدمات';

  @override
  String get add_first_service => 'ابدأ بإضافة خدمتك الأولى';

  @override
  String get edit_service => 'تحرير الخدمة';

  @override
  String get delete_service_tooltip => 'حذف الخدمة';

  @override
  String get service_deleted_successfully => 'تم حذف الخدمة بنجاح';

  @override
  String get error_deleting_service => 'حدث خطأ أثناء حذف الخدمة';

  @override
  String get error_loading_services => 'خطأ في تحميل الخدمات';

  @override
  String get service_name => 'اسم الخدمة';

  @override
  String get enter_service_name => 'أدخل اسم الخدمة';

  @override
  String get service_name_required => 'اسم الخدمة مطلوب';

  @override
  String get service_name_min_length =>
      'يجب أن يتكون اسم الخدمة من 3 أحرف على الأقل';

  @override
  String get enter_service_description => 'أدخل وصف الخدمة';

  @override
  String get service_description_required => 'وصف الخدمة مطلوب';

  @override
  String get service_description_min_length =>
      'يجب أن يكون الوصف 10 أحرف على الأقل';

  @override
  String get category_required => 'الرجاء تحديد فئة';

  @override
  String get no_categories_available => 'لا توجد فئات متاحة';

  @override
  String get location => 'موقع';

  @override
  String get select_location => 'حدد الموقع';

  @override
  String get location_required => 'الرجاء تحديد الموقع';

  @override
  String get no_locations_available => 'لا توجد مواقع متاحة';

  @override
  String get add_images => 'إضافة الصور';

  @override
  String get current_images => 'الصور الحالية';

  @override
  String get no_images_selected => 'لم يتم اختيار أي صور';

  @override
  String get save_changes => 'حفظ التغييرات';

  @override
  String get map_main => 'الخريطة والخصائص';

  @override
  String get agent_status => 'حالة الوكيل';

  @override
  String get admin_panel => 'لوحة الإدارة';

  @override
  String get propertiesFound => 'تم العثور على خصائص';

  @override
  String get propertiesSaved => 'الخصائص المحفوظة';

  @override
  String get saved => 'أنقذ';

  @override
  String get loadingProperties => 'جارٍ تحميل الخصائص...';

  @override
  String get failedToLoad => 'فشل في تحميل الخصائص. يرجى المحاولة مرة أخرى.';

  @override
  String get noPropertiesFound => 'لم يتم العثور على خصائص';

  @override
  String get tryAdjusting => 'حاول تعديل معايير البحث الخاصة بك';

  @override
  String get search_placeholder => 'البحث حسب العنوان أو الموقع...';

  @override
  String get search_filters => 'المرشحات';

  @override
  String get search_button => 'يبحث';

  @override
  String get search_clear_filters => 'مسح المرشحات';

  @override
  String get filter_options_sale_and_rent => 'البيع والإيجار';

  @override
  String get filter_options_for_sale => 'للبيع';

  @override
  String get filter_options_for_rent => 'للإيجار';

  @override
  String get filter_options_all_types => 'جميع الأنواع';

  @override
  String get filter_options_apartment => 'شقة';

  @override
  String get filter_options_house => 'منزل';

  @override
  String get filter_options_townhouse => 'تاون هاوس';

  @override
  String get filter_options_villa => 'فيلا';

  @override
  String get filter_options_commercial => 'تجاري';

  @override
  String get filter_options_office => 'مكتب';

  @override
  String get property_card_featured => 'مميز';

  @override
  String get property_card_bed => 'غرفة نوم';

  @override
  String get property_card_bath => 'حمام';

  @override
  String get property_card_parking => 'وقوف السيارات';

  @override
  String get property_card_view_details => 'عرض التفاصيل';

  @override
  String get property_card_contact => 'اتصال';

  @override
  String get property_card_balcony => 'شرفة';

  @override
  String get property_card_garage => 'المرآب';

  @override
  String get property_card_garden => 'حديقة';

  @override
  String get property_card_pool => 'حمام سباحة';

  @override
  String get property_card_elevator => 'مصعد';

  @override
  String get property_card_furnished => 'مفروشة';

  @override
  String get property_card_sales => 'مبيعات';

  @override
  String get pricing_month => '/شهر';

  @override
  String get results_properties_found => 'تم العثور على خصائص';

  @override
  String get results_properties_saved => 'الخصائص المحفوظة';

  @override
  String get results_saved => 'أنقذ';

  @override
  String get results_loading_properties => 'جارٍ تحميل الخصائص...';

  @override
  String get results_failed_to_load =>
      'فشل في تحميل الخصائص. يرجى المحاولة مرة أخرى.';

  @override
  String get results_no_properties_found => 'لم يتم العثور على خصائص';

  @override
  String get results_try_adjusting => 'حاول تعديل معايير البحث الخاصة بك';

  @override
  String get no_properties_found => 'لم يتم العثور على خصائص';

  @override
  String get no_category_properties => 'لا توجد خصائص في هذه الفئة';

  @override
  String get properties_loading => 'جارٍ تحميل الخصائص...';

  @override
  String get all_properties_loaded => 'تم تحميل جميع الخصائص';

  @override
  String n_properties(int count) {
    return 'خصائص $count';
  }

  @override
  String get in_area => 'في المنطقة';

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
  String get pagination_previous => 'سابق';

  @override
  String get pagination_next => 'التالي';

  @override
  String get pagination_page => 'صفحة';

  @override
  String get pagination_page_of => 'صفحة 1 من';

  @override
  String get contact_modal_title => 'معلومات الاتصال';

  @override
  String get contact_modal_agent_contact => 'جهة اتصال الوكيل';

  @override
  String get contact_modal_property_owner => 'مالك العقار';

  @override
  String get contact_modal_agent_phone_number => 'رقم هاتف الوكيل';

  @override
  String get contact_modal_owner_phone_number => 'رقم هاتف المالك';

  @override
  String get contact_modal_license => 'رخصة';

  @override
  String get contact_modal_rating => 'تصنيف';

  @override
  String get contact_modal_call_now => 'اتصل الآن';

  @override
  String get contact_modal_copy_number => 'رقم النسخ';

  @override
  String get contact_modal_close => 'يغلق';

  @override
  String get contact_modal_contact_hours =>
      'ساعات الاتصال: 9:00 صباحًا - 8:00 مساءً';

  @override
  String get contact_modal_agent => 'عامل';

  @override
  String get errors_toggle_save_failed => 'فشل تبديل خاصية الحفظ:';

  @override
  String get errors_copy_failed => 'فشل في نسخ رقم الهاتف:';

  @override
  String get errors_phone_copied => 'تم نسخ رقم الهاتف إلى الحافظة';

  @override
  String get errors_error_occurred_regions => 'حدث خطأ في المناطق';

  @override
  String get errors_error_occurred_districts => 'حدث خطأ مع المناطق';

  @override
  String get errors_please_fill_all_required_fields =>
      'يرجى ملء جميع الحقول المطلوبة';

  @override
  String get errors_authentication_required => 'المصادقة مطلوبة';

  @override
  String get errors_user_info_missing => 'معلومات المستخدم مفقودة';

  @override
  String get errors_validation_error =>
      'يرجى التحقق من بيانات الإدخال الخاصة بك';

  @override
  String get errors_permission_denied => 'تم رفض الإذن';

  @override
  String get errors_server_error => 'حدث خطأ في الخادم';

  @override
  String get errors_network_error => 'خطأ في الاتصال بالشبكة';

  @override
  String get errors_timeout_error => 'تم تجاوز مهلة الطلب';

  @override
  String get errors_custom_error => 'حدث خطأ';

  @override
  String get errors_error_creating_property => 'حدث خطأ أثناء إنشاء الخاصية';

  @override
  String get errors_unknown_error_message => 'حدث خطأ غير معروف';

  @override
  String get errors_coordinates_not_found =>
      'تعذر العثور على إحداثيات لهذا العنوان. الرجاء إدخالها يدويا.';

  @override
  String get errors_coordinates_error =>
      'حدث خطأ أثناء الحصول على الإحداثيات. الرجاء إدخالها يدويا.';

  @override
  String get property_info_views => 'وجهات النظر';

  @override
  String get property_info_listed => 'مدرج';

  @override
  String get property_info_price_per_sqm => '/sqm';

  @override
  String get property_info_saved => 'أنقذ';

  @override
  String get property_info_save => 'يحفظ';

  @override
  String get property_info_share => 'يشارك';

  @override
  String get loading_loading => 'تحميل...';

  @override
  String get loading_loading_details => 'جارٍ تحميل تفاصيل العقار...';

  @override
  String get loading_property_not_found => 'لم يتم العثور على العقار';

  @override
  String get loading_property_not_found_message =>
      'الخاصية التي تبحث عنها غير موجودة أو تمت إزالتها.';

  @override
  String get loading_back_to_properties => 'العودة إلى الخصائص';

  @override
  String get loading_title => 'جارٍ التحميل...';

  @override
  String get loading_message =>
      'يرجى الانتظار بينما نقوم بتحميل قائمة الوكلاء.';

  @override
  String get loading_agent_not_found => 'لم يتم العثور على الوكيل';

  @override
  String get property_details_title => 'تفاصيل العقار';

  @override
  String get property_details_bedrooms => 'غرف نوم';

  @override
  String get property_details_bathrooms => 'الحمامات';

  @override
  String get property_details_floor_area => 'مساحة الأرضية';

  @override
  String get property_details_parking => 'وقوف السيارات';

  @override
  String get property_details_basic_information => 'المعلومات الأساسية';

  @override
  String get property_details_property_type => 'نوع العقار:';

  @override
  String get property_details_listing_type => 'نوع القائمة:';

  @override
  String get property_details_for_sale => 'للبيع';

  @override
  String get property_details_for_rent => 'للإيجار';

  @override
  String get property_details_year_built => 'سنة البناء:';

  @override
  String get property_details_floor => 'أرضية:';

  @override
  String get property_details_of => 'ل';

  @override
  String get property_details_features_amenities => 'الميزات ووسائل الراحة';

  @override
  String get sections_description => 'وصف';

  @override
  String get sections_nearby_amenities => 'وسائل الراحة القريبة';

  @override
  String get sections_similar_properties => 'خصائص مماثلة';

  @override
  String get amenities_metro => 'مترو';

  @override
  String get amenities_school => 'مدرسة';

  @override
  String get amenities_hospital => 'مستشفى';

  @override
  String get amenities_shopping => 'التسوق';

  @override
  String get amenities_away => 'بعيد';

  @override
  String get contact_title => 'معلومات الاتصال';

  @override
  String get contact_professional_listing => 'القائمة المهنية';

  @override
  String get contact_listed_by_agent => 'تم إدراجه بواسطة وكيل تم التحقق منه';

  @override
  String get contact_by_owner => 'بواسطة المالك';

  @override
  String get contact_direct_contact => 'الاتصال المباشر مع مالك العقار';

  @override
  String get contact_property_owner => 'مالك العقار';

  @override
  String get contact_call_agent => 'وكيل الاتصال';

  @override
  String get contact_email_agent => 'وكيل البريد الإلكتروني';

  @override
  String get contact_call_owner => 'اتصل بالمالك';

  @override
  String get contact_email_owner => 'مالك البريد الإلكتروني';

  @override
  String get contact_send_inquiry => 'إرسال الاستفسار';

  @override
  String get property_status_title => 'حالة العقار';

  @override
  String get property_status_availability => 'التوفر:';

  @override
  String get property_status_available => 'متاح';

  @override
  String get property_status_not_available => 'غير متوفر';

  @override
  String get property_status_featured => 'مميز:';

  @override
  String get property_status_featured_property => 'عقارات مميزة';

  @override
  String get property_status_property_id => 'معرف الخاصية:';

  @override
  String get inquiry_title => 'إرسال الاستفسار';

  @override
  String get inquiry_inquiry_type => 'نوع الاستفسار';

  @override
  String get inquiry_request_info => 'طلب المعلومات';

  @override
  String get inquiry_schedule_viewing => 'عرض الجدول الزمني';

  @override
  String get inquiry_make_offer => 'تقديم العرض';

  @override
  String get inquiry_request_callback => 'طلب رد الاتصال';

  @override
  String get inquiry_message => 'رسالة';

  @override
  String get inquiry_message_placeholder => 'أخبرنا عن اهتمامك بهذا العقار...';

  @override
  String get inquiry_offered_price => 'السعر المعروض';

  @override
  String get inquiry_enter_offer => 'أدخل العرض الخاص بك';

  @override
  String get inquiry_preferred_contact_time => 'وقت الاتصال المفضل (اختياري)';

  @override
  String get inquiry_contact_time_placeholder =>
      'على سبيل المثال، أيام الأسبوع من 9:00 صباحًا إلى 5:00 مساءً';

  @override
  String get inquiry_cancel => 'يلغي';

  @override
  String get inquiry_sending => 'إرسال...';

  @override
  String get inquiry_send_inquiry => 'إرسال الاستفسار';

  @override
  String get inquiry_inquiry_sent_success => 'تم إرسال الاستفسار بنجاح!';

  @override
  String get inquiry_inquiry_sent_error =>
      'فشل في إرسال الاستفسار. يرجى المحاولة مرة أخرى.';

  @override
  String get alerts_link_copied => 'تم نسخ رابط الخاصية إلى الحافظة!';

  @override
  String get alerts_phone_copied => 'تم نسخ رقم الهاتف إلى الحافظة!';

  @override
  String get alerts_save_property_failed => 'فشل حفظ الممتلكات:';

  @override
  String get alerts_email_subject => 'استفسار عن:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'مرحبًا،\\n\\nأنا مهتم بالعقار الخاص بك \"$title\" الموجود في $address.\\n\\nالرجاء الاتصال بي للحصول على مزيد من المعلومات.\\n\\nأطيب التحيات';
  }

  @override
  String get related_properties_view_details => 'عرض التفاصيل';

  @override
  String get header_property => 'ابحث عن عقار أحلامك';

  @override
  String get header_sub_property =>
      'اكتشف الفرص العقارية المتميزة في أكثر الأحياء المرغوبة في طشقند';

  @override
  String get header_title => 'وكلاء العقارات';

  @override
  String get header_subtitle =>
      'ابحث عن وكلاء ذوي خبرة للمساعدة في تلبية احتياجاتك العقارية';

  @override
  String get header_agents_found => 'تم العثور على وكلاء';

  @override
  String get filters_all_specializations => 'جميع التخصصات';

  @override
  String get filters_residential => 'سكني';

  @override
  String get filters_commercial => 'تجاري';

  @override
  String get filters_luxury => 'رفاهية';

  @override
  String get filters_investment => 'استثمار';

  @override
  String get filters_any_rating => 'أي تصنيف';

  @override
  String get filters_four_stars => '4+ نجوم';

  @override
  String get filters_four_half_stars => '4.5+ نجوم';

  @override
  String get filters_five_stars => '5 نجوم';

  @override
  String get filters_highest_rated => 'الأعلى تقييمًا';

  @override
  String get filters_lowest_rated => 'أدنى تصنيف';

  @override
  String get filters_most_sales => 'معظم المبيعات';

  @override
  String get filters_most_experience => 'معظم الخبرة';

  @override
  String get agent_card_verified_agent => 'وكيل معتمد';

  @override
  String get agent_card_years_experience => 'سنوات الخبرة';

  @override
  String get agent_card_years => 'سنين';

  @override
  String get agent_card_license => 'رخصة';

  @override
  String get agent_card_specialization => 'التخصص';

  @override
  String get agent_card_view_profile => 'عرض الملف الشخصي';

  @override
  String get agent_card_contact => 'اتصال';

  @override
  String get agent_card_verified => 'تم التحقق منه';

  @override
  String get no_results_title => 'لم يتم العثور على وكلاء';

  @override
  String get no_results_message => 'حاول تعديل معايير البحث أو عوامل التصفية.';

  @override
  String get error_title => 'حدث خطأ أثناء تحميل الوكلاء';

  @override
  String get error_message =>
      'فشل تحميل قائمة الوكلاء. يرجى المحاولة مرة أخرى.';

  @override
  String get error_retry => 'أعد المحاولة';

  @override
  String get error_default_message => 'فشل في تحميل تفاصيل الوكيل';

  @override
  String get error_try_again => 'حاول ثانية';

  @override
  String get notifications_phone_copied => 'تم نسخ رقم الهاتف إلى الحافظة';

  @override
  String get notifications_copy_failed => 'فشل في نسخ رقم الهاتف:';

  @override
  String get fallback_agent_name => 'عامل';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'إرسال الملكية';

  @override
  String get navigation_submitting => 'تقديم...';

  @override
  String get navigation_back_to_agents => 'العودة إلى الوكلاء';

  @override
  String get agent_profile_verified_agent => 'وكيل معتمد';

  @override
  String get agent_profile_contact_agent => 'وكيل الاتصال';

  @override
  String get agent_profile_send_message => 'أرسل رسالة';

  @override
  String get agent_profile_years_experience => 'سنوات الخبرة';

  @override
  String get agent_profile_properties_sold => 'العقارات المباعة';

  @override
  String get agent_profile_active_listings => 'القوائم النشطة';

  @override
  String get agent_profile_total_properties => 'إجمالي الخصائص';

  @override
  String get tabs_overview => 'ملخص';

  @override
  String get tabs_properties => 'ملكيات';

  @override
  String get tabs_reviews => 'المراجعات';

  @override
  String get about_agent_title => 'حول الوكيل';

  @override
  String get about_agent_agency => 'وكالة';

  @override
  String get about_agent_license_number => 'رقم الترخيص';

  @override
  String get about_agent_specialization => 'التخصص';

  @override
  String get about_agent_member_since => 'عضو منذ';

  @override
  String get about_agent_verified_since => 'تم التحقق منه منذ';

  @override
  String get performance_metrics_title => 'مقاييس الأداء';

  @override
  String get performance_metrics_average_rating => 'متوسط ​​التقييم';

  @override
  String get performance_metrics_properties_sold => 'العقارات المباعة';

  @override
  String get performance_metrics_active_listings => 'القوائم النشطة';

  @override
  String get performance_metrics_years_experience => 'سنوات الخبرة';

  @override
  String get contact_info_title => 'معلومات الاتصال';

  @override
  String get contact_info_contact_via_platform => 'التواصل عبر المنصة';

  @override
  String get verification_status_title => 'حالة التحقق';

  @override
  String get verification_status_verified_agent => 'وكيل معتمد';

  @override
  String get verification_status_pending_verification => 'في انتظار التحقق';

  @override
  String get verification_status_licensed_professional => 'محترف مرخص';

  @override
  String get verification_status_registered_agency => 'وكالة مسجلة';

  @override
  String get quick_actions_title => 'إجراءات سريعة';

  @override
  String get quick_actions_call_now => 'اتصل الآن';

  @override
  String get quick_actions_send_message => 'أرسل رسالة';

  @override
  String get quick_actions_view_properties => 'عرض الخصائص';

  @override
  String get properties_title => 'خصائص الوكيل';

  @override
  String get properties_loading_properties => 'جارٍ تحميل الخصائص...';

  @override
  String get properties_no_properties_title => 'لم يتم العثور على خصائص';

  @override
  String get properties_no_properties_message =>
      'سوف تظهر خصائص هذا الوكيل هنا.';

  @override
  String get properties_recent_properties_note =>
      'عرض العقارات الحديثة. تحقق من القوائم الكاملة لجميع خصائص الوكيل.';

  @override
  String get properties_listed => 'مدرج';

  @override
  String get properties_bed => 'سرير';

  @override
  String get properties_bath => 'حمام';

  @override
  String get properties_for_sale => 'للبيع';

  @override
  String get properties_for_rent => 'للإيجار';

  @override
  String get reviews_title => 'مراجعات العملاء';

  @override
  String get reviews_no_reviews_title => 'لا توجد تعليقات حتى الآن';

  @override
  String get reviews_no_reviews_message =>
      'ستظهر مراجعات العملاء وتوصياتهم هنا.';

  @override
  String get fallbacks_agent_name => 'عامل';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => 'الخصائص المحفوظة';

  @override
  String get saved_properties_subtitle => 'عقاراتك المفضلة في مكان واحد';

  @override
  String get saved_properties_no_saved_properties => 'لا توجد خصائص محفوظة بعد';

  @override
  String get saved_properties_start_saving =>
      'ابدأ في استكشاف وحفظ الخصائص التي تريدها';

  @override
  String get saved_properties_browse_properties => 'تصفح الخصائص';

  @override
  String get saved_properties_saved_on => 'تم الحفظ في';

  @override
  String get auth_login_required =>
      'الرجاء تسجيل الدخول لعرض العقارات المحفوظة';

  @override
  String get auth_login => 'تسجيل الدخول';

  @override
  String get success_property_unsaved =>
      'تمت إزالة الخاصية من القائمة المحفوظة';

  @override
  String get success_property_saved => 'تم حفظ الخاصية بنجاح';

  @override
  String get success_phone_copied => 'تم نسخ رقم الهاتف!';

  @override
  String get success_property_created_success => 'تم إنشاء الخاصية بنجاح!';

  @override
  String get success_agent_approved => 'تمت الموافقة على الوكيل بنجاح';

  @override
  String get success_agent_rejected => 'تم رفض الوكيل بنجاح';

  @override
  String get steps_step => 'خطوة';

  @override
  String get steps_basic_information => 'المعلومات الأساسية';

  @override
  String get steps_location_details => 'تفاصيل الموقع';

  @override
  String get steps_property_details => 'تفاصيل العقار';

  @override
  String get steps_property_images => 'صور الملكية';

  @override
  String get basic_info_tell_us_about_property =>
      'أخبرنا عن الممتلكات الخاصة بك';

  @override
  String get basic_info_property_type => 'نوع العقار';

  @override
  String get basic_info_listing_type => 'نوع القائمة';

  @override
  String get basic_info_property_title => 'عنوان العقار';

  @override
  String get basic_info_title_placeholder => 'أدخل عنوانًا وصفيًا لممتلكاتك';

  @override
  String get basic_info_description => 'وصف';

  @override
  String get basic_info_description_placeholder => 'وصف عقارك بالتفصيل...';

  @override
  String get property_types_apartment => 'شقة';

  @override
  String get property_types_house => 'منزل';

  @override
  String get property_types_townhouse => 'تاون هاوس';

  @override
  String get property_types_villa => 'فيلا';

  @override
  String get property_types_commercial => 'تجاري';

  @override
  String get property_types_office => 'مكتب';

  @override
  String get property_types_land => 'أرض';

  @override
  String get property_types_warehouse => 'مستودع';

  @override
  String get listing_types_for_sale => 'للبيع';

  @override
  String get listing_types_for_rent => 'للإيجار';

  @override
  String get location_where_is_property => 'أين تقع الممتلكات الخاصة بك؟';

  @override
  String get location_full_address => 'العنوان الكامل';

  @override
  String get location_address_placeholder => 'أدخل العنوان الكامل';

  @override
  String get location_region => 'منطقة';

  @override
  String get location_select_region => 'اختر المنطقة';

  @override
  String get location_district => 'يصرف';

  @override
  String get location_select_district => 'اختر المنطقة';

  @override
  String get location_city => 'مدينة';

  @override
  String get location_city_placeholder => 'مدينة';

  @override
  String get location_loading_regions => 'جارٍ تحميل المناطق...';

  @override
  String get location_loading_districts => 'جارٍ تحميل المناطق...';

  @override
  String get location_map_coordinates => 'إحداثيات الخريطة';

  @override
  String get location_get_coordinates => 'الحصول على الإحداثيات';

  @override
  String get location_latitude => 'خط العرض';

  @override
  String get location_longitude => 'خط الطول';

  @override
  String get location_coordinates_set => 'مجموعة الإحداثيات';

  @override
  String get location_location_tips => 'نصائح الموقع';

  @override
  String get location_location_tip_1 =>
      '• املأ العنوان أولاً، ثم انقر فوق \"الحصول على الإحداثيات\" للحصول على موقع الخريطة تلقائيًا';

  @override
  String get location_location_tip_2 =>
      '• يمكنك أيضًا إدخال الإحداثيات يدويًا إذا كنت تعرف الموقع الدقيق';

  @override
  String get location_location_tip_3 =>
      '• الإحداثيات الدقيقة تساعد المشترين في العثور على الممتلكات الخاصة بك على الخريطة';

  @override
  String get property_details_provide_detailed_info =>
      'تقديم معلومات مفصلة عن الممتلكات الخاصة بك';

  @override
  String get property_details_total_floors => 'إجمالي الطوابق';

  @override
  String get property_details_area_m2 => 'المساحة (م²)';

  @override
  String get property_details_parking_spaces => 'أماكن وقوف السيارات';

  @override
  String get property_details_price => 'سعر';

  @override
  String get property_details_features => 'سمات';

  @override
  String get images_add_photos_showcase => 'أضف الصور لعرض الممتلكات الخاصة بك';

  @override
  String get images_click_to_upload => 'انقر لتحميل الصور';

  @override
  String get images_max_images_info => 'الحد الأقصى 10 صور، JPG، PNG أو WEBP';

  @override
  String get images_main => 'رئيسي';

  @override
  String get images_maximum_images_allowed =>
      'الحد الأقصى المسموح به هو 10 صور';

  @override
  String get admin_dashboard_title => 'لوحة تحكم المشرف';

  @override
  String get admin_dashboard_subtitle =>
      'نظرة عامة في الوقت الحقيقي على منصة العقارات الخاصة بك';

  @override
  String get admin_last_update => 'التحديث الأخير';

  @override
  String get admin_total_properties => 'إجمالي الخصائص';

  @override
  String get admin_total_agents => 'مجموع الوكلاء';

  @override
  String get admin_total_users => 'إجمالي المستخدمين';

  @override
  String get admin_total_views => 'إجمالي المشاهدات';

  @override
  String get admin_error_loading_dashboard => 'خطأ في تحميل لوحة القيادة';

  @override
  String get admin_failed_to_load_data => 'فشل تحميل بيانات لوحة القيادة';

  @override
  String get admin_avg_sale_price => 'متوسط ​​سعر البيع';

  @override
  String get admin_avg_sale_price_subtitle => 'جميع القوائم النشطة';

  @override
  String get admin_total_portfolio_value => 'إجمالي قيمة المحفظة';

  @override
  String get admin_total_portfolio_value_subtitle => 'قيمة الممتلكات مجتمعة';

  @override
  String get admin_avg_price_per_sqm => 'متوسط ​​السعر للمتر المربع';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'مؤشر سعر السوق';

  @override
  String get admin_property_types_distribution => 'توزيع أنواع العقارات';

  @override
  String get admin_properties_by_city => 'العقارات حسب المدينة';

  @override
  String get admin_properties_by_district => 'العقارات حسب المنطقة';

  @override
  String get admin_inquiry_types_distribution => 'توزيع أنواع الاستفسار';

  @override
  String get admin_agent_verification_rate => 'معدل التحقق من الوكيل';

  @override
  String get admin_agent_verification_rate_subtitle => 'ضبط الجودة';

  @override
  String get admin_inquiry_response_rate => 'معدل الاستجابة للاستفسار';

  @override
  String get admin_inquiry_response_rate_subtitle => 'خدمة العملاء';

  @override
  String get admin_avg_views_per_property => 'متوسط ​​المشاهدات لكل عقار';

  @override
  String get admin_avg_views_per_property_subtitle => 'شعبية العقار';

  @override
  String get admin_featured_properties => 'خصائص مميزة';

  @override
  String get admin_featured_properties_subtitle => 'قوائم مميزة';

  @override
  String get admin_most_viewed_properties => 'العقارات الأكثر مشاهدة';

  @override
  String get admin_top_performing_agents => 'الوكلاء الأفضل أداءً';

  @override
  String get admin_system_health => 'صحة النظام';

  @override
  String get admin_properties_without_images => 'خصائص بدون صور';

  @override
  String get admin_missing_location_data => 'بيانات الموقع مفقودة';

  @override
  String get admin_pending_agent_verification => 'في انتظار التحقق من الوكيل';

  @override
  String get admin_active => 'نشيط';

  @override
  String get admin_verified => 'تم التحقق منها';

  @override
  String get admin_active_7d => 'نشط (7د)';

  @override
  String get admin_this_month => 'هذا الشهر';

  @override
  String get agents_loading_pending_applications =>
      'جارٍ تحميل التطبيقات المعلقة...';

  @override
  String get agents_error_loading_applications => 'خطأ في تحميل التطبيقات';

  @override
  String get agents_pending_agents => 'وكلاء في انتظار';

  @override
  String get agents_total_pending_applications => 'إجمالي الطلبات المعلقة:';

  @override
  String get agents_pending_verification => 'في انتظار التحقق';

  @override
  String get agents_applied_date => 'مُطبَّق:';

  @override
  String get agents_contact_info => 'معلومات الاتصال';

  @override
  String get agents_license_number => 'رقم الترخيص';

  @override
  String get agents_years_experience => 'سنوات الخبرة';

  @override
  String get agents_years_suffix => 'سنين';

  @override
  String get agents_total_sales => 'إجمالي المبيعات';

  @override
  String get agents_specialization => 'التخصص';

  @override
  String get agents_approve => 'يعتمد';

  @override
  String get agents_reject => 'يرفض';

  @override
  String get agents_no_pending_applications => 'لا توجد طلبات معلقة';

  @override
  String get agents_all_applications_processed =>
      'تمت معالجة جميع طلبات الوكيل';

  @override
  String get general_previous => 'سابق';

  @override
  String get general_page => 'صفحة';

  @override
  String get general_next => 'التالي';

  @override
  String get general_views => 'وجهات النظر';

  @override
  String get general_sales => 'مبيعات';

  @override
  String get general_language_uz => 'أوزبكشا';

  @override
  String get general_language_ru => 'الروسية';

  @override
  String get general_language_en => 'إنجليزي';

  @override
  String get general_super_admin => 'المشرف الفائق';

  @override
  String get general_staff => 'طاقم عمل';

  @override
  String get general_verified_agent => 'وكيل معتمد';

  @override
  String get general_pending_agent => 'وكيل معلق';

  @override
  String get general_regular_user => 'مستخدم عادي';

  @override
  String get general_admin => 'مسؤل';

  @override
  String get general_dashboard => 'لوحة القيادة';

  @override
  String get general_manage_users => 'إدارة المستخدمين';

  @override
  String get general_verified_agents => 'الوكلاء المعتمدون';

  @override
  String get general_agent_panel => 'لوحة الوكيل';

  @override
  String get general_create_property => 'إنشاء خاصية';

  @override
  String get general_my_properties => 'خصائصي';

  @override
  String get general_inquiries => 'الاستفسارات';

  @override
  String get general_agent_profile => 'الملف الشخصي للوكيل';

  @override
  String get general_live => 'يعيش';

  @override
  String get general_logged_out_successfully => 'تم تسجيل الخروج بنجاح';

  @override
  String get general_logout_completed_with_errors =>
      'اكتمل تسجيل الخروج (مع وجود أخطاء)';

  @override
  String get general_application_under_review => 'التطبيق قيد المراجعة';

  @override
  String get general_check_status => 'التحقق من الحالة →';

  @override
  String get general_last_updated => 'آخر تحديث:';

  @override
  String get general_permissions_may_be_outdated => 'قد تكون الأذونات قديمة';

  @override
  String get general_permissions_up_to_date => 'الأذونات محدثة';

  @override
  String get general_never => 'أبداً';

  @override
  String get general_properties_found => 'تم العثور على خصائص';

  @override
  String get general_properties_saved => 'الخصائص المحفوظة';

  @override
  String get general_saved => 'أنقذ';

  @override
  String get general_loading_properties => 'جارٍ تحميل الخصائص...';

  @override
  String get general_failed_to_load =>
      'فشل في تحميل الخصائص. يرجى المحاولة مرة أخرى.';

  @override
  String get general_no_properties_found => 'لم يتم العثور على خصائص';

  @override
  String get general_try_adjusting => 'حاول تعديل معايير البحث الخاصة بك';

  @override
  String get select_category => 'اختر فئة';

  @override
  String get service_description => 'وصف الخدمة';

  @override
  String get product_search_placeholder =>
      'أدخل مصطلح البحث للعثور على المنتجات';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get terms_subtitle => 'سياسة الخصوصية والشروط';

  @override
  String get last_updated => 'آخر تحديث';

  @override
  String get contact_information => 'معلومات الاتصال';

  @override
  String get accept_terms => 'أوافق على الشروط والأحكام';

  @override
  String get read_terms => 'يرجى قراءة الشروط والأحكام لدينا';

  @override
  String get inquiries => 'الاستفسارات والدعم';

  @override
  String get inquiries_subtitle => 'اتصل بنا للحصول على المساعدة';

  @override
  String get help_center => 'كيف يمكننا مساعدتك؟';

  @override
  String get help_subtitle => 'نحن هنا لمساعدتك في أي أسئلة';

  @override
  String get contact_us => 'اتصل بنا';

  @override
  String get email_support => 'دعم البريد الإلكتروني';

  @override
  String get call_support => 'اتصل بالدعم';

  @override
  String get send_message => 'أرسل رسالة';

  @override
  String get fill_contact_form => 'املأ نموذج الاتصال';

  @override
  String get contact_form => 'نموذج الاتصال';

  @override
  String get name => 'اسمك';

  @override
  String get name_required => 'الرجاء إدخال اسمك';

  @override
  String get email => 'عنوان البريد الإلكتروني';

  @override
  String get email_required => 'الرجاء إدخال البريد الإلكتروني الخاص بك';

  @override
  String get email_invalid => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get subject => 'موضوع';

  @override
  String get subject_required => 'الرجاء إدخال الموضوع';

  @override
  String get message => 'رسالة';

  @override
  String get message_required => 'الرجاء إدخال رسالتك';

  @override
  String get message_too_short => 'يجب أن تكون الرسالة 10 أحرف على الأقل';

  @override
  String get faq => 'الأسئلة المتداولة';

  @override
  String get follow_us => 'تابعنا';

  @override
  String get faq_how_to_sell => 'كيف أبيع العناصر على Tezsell؟';

  @override
  String get faq_how_to_sell_answer =>
      'لبيع العناصر: 1) قم بإنشاء حساب، 2) اضغط على الزر \"+\"، 3) اختر الفئة (المنتجات/الخدمات/العقارات)، 4) أضف الصور والوصف، 5) حدد السعر، 6) انشر! ستكون قائمتك مرئية للمشترين في منطقتك.';

  @override
  String get faq_is_free => 'هل Tezsell مجاني للاستخدام؟';

  @override
  String get faq_is_free_answer =>
      'نعم! Tezsell حاليا مجاني 100%. لا توجد رسوم إدراج، ولا عمولة على المبيعات، ولا رسوم اشتراك. قد نقدم ميزات مميزة في المستقبل، ولكننا سنخطر المستخدمين قبل 30 يومًا.';

  @override
  String get faq_safety => 'كيف يمكنني البقاء آمنًا عند الشراء/البيع؟';

  @override
  String get faq_safety_answer =>
      'نصائح للسلامة: 1) اجتمع في الأماكن العامة، 2) افحص العناصر قبل الدفع، 3) لا ترسل أموالًا أبدًا إلى الغرباء، 4) ثق بحدسك، 5) أبلغ عن المستخدمين المشبوهين، 6) لا تشارك المعلومات الشخصية في وقت مبكر جدًا، 7) أحضر صديقًا لإجراء معاملات عالية القيمة.';

  @override
  String get faq_payment => 'كيف تعمل المدفوعات؟';

  @override
  String get faq_payment_answer =>
      'لا تقوم Tezsell بمعالجة المدفوعات. يقوم المشترون والبائعون بترتيب الدفع مباشرة (نقدًا، أو تحويلًا مصرفيًا، أو ما إلى ذلك). نحن مجرد منصة لربط الأشخاص - أنت تتعامل مع المعاملة بأنفسكم.';

  @override
  String get faq_prohibited => 'ما هي العناصر المحظورة؟';

  @override
  String get faq_prohibited_answer =>
      'تشمل العناصر المحظورة: الأسلحة والمخدرات والسلع المسروقة والمواد المقلدة والمحتوى المخصص للبالغين والحيوانات الحية (بدون تصاريح) والهويات الحكومية والمواد الخطرة. راجع الشروط والأحكام الخاصة بنا للحصول على القائمة الكاملة.';

  @override
  String get faq_account_delete => 'كيف يمكنني حذف حسابي؟';

  @override
  String get faq_account_delete_answer =>
      'انتقل إلى ملف التعريف → الإعدادات → إعدادات الحساب → حذف الحساب. ملاحظة: هذا أمر دائم ولا يمكن التراجع عنه. ستتم إزالة كافة القوائم الخاصة بك.';

  @override
  String get faq_report_user => 'كيف يمكنني الإبلاغ عن مستخدم أو قائمة؟';

  @override
  String get faq_report_user_answer =>
      'اضغط على النقاط الثلاث (•••) في أي قائمة أو ملف شخصي للمستخدم، ثم حدد \"إبلاغ\". اختر السبب وأرسل. نقوم بمراجعة جميع التقارير خلال 24-48 ساعة.';

  @override
  String get faq_change_location => 'كيف يمكنني تغيير موقعي؟';

  @override
  String get faq_change_location_answer =>
      'اضغط على زر الموقع في الزاوية العلوية اليسرى من الشاشة الرئيسية. يمكنك تحديد منطقتك ومنطقتك لرؤية القوائم في منطقتك.';

  @override
  String get welcome_customer_center => 'مرحبا بكم في مركز العملاء';

  @override
  String get customer_center_subtitle => 'نحن هنا لمساعدتك 24/7';

  @override
  String get quick_actions => 'إجراءات سريعة';

  @override
  String get live_chat => 'الدردشة الحية';

  @override
  String get chat_with_us => 'الدردشة معنا';

  @override
  String get find_answers => 'العثور على إجابات';

  @override
  String get my_tickets => 'التذاكر الخاصة بي';

  @override
  String get view_tickets => 'عرض التذاكر';

  @override
  String get feedback => 'تعليق';

  @override
  String get share_feedback => 'مشاركة التعليقات';

  @override
  String get contact_methods => 'طرق الاتصال';

  @override
  String get phone_support => 'الدعم عبر الهاتف';

  @override
  String get available_247 => 'متاح 24/7';

  @override
  String get response_24h => 'الرد خلال 24 ساعة';

  @override
  String get telegram_support => 'دعم برقية';

  @override
  String get instant_replies => 'ردود فورية';

  @override
  String get whatsapp_support => 'دعم الواتساب';

  @override
  String get quick_response => 'استجابة سريعة';

  @override
  String get popular_topics => 'موضوعات شعبية';

  @override
  String get account_management => 'إدارة الحساب';

  @override
  String get reset_password => 'إعادة تعيين كلمة المرور';

  @override
  String get update_profile => 'تحديث الملف الشخصي';

  @override
  String get verify_account => 'التحقق من الحساب';

  @override
  String get delete_account => 'حذف الحساب';

  @override
  String get buying_selling => 'بيع وشراء';

  @override
  String get how_to_post => 'كيفية نشر الإعلانات';

  @override
  String get payment_methods => 'طرق الدفع';

  @override
  String get shipping_delivery => 'الشحن والتسليم';

  @override
  String get return_policy => 'سياسة العائدات';

  @override
  String get safety_security => 'السلامة والأمن';

  @override
  String get report_scam => 'الإبلاغ عن عملية احتيال';

  @override
  String get safe_trading => 'نصائح التداول الآمن';

  @override
  String get privacy_settings => 'إعدادات الخصوصية';

  @override
  String get blocked_users => 'المستخدمون المحظورون';

  @override
  String get technical_issues => 'القضايا الفنية';

  @override
  String get app_not_working => 'التطبيق لا يعمل';

  @override
  String get upload_failed => 'فشل التحميل';

  @override
  String get login_problems => 'مشاكل تسجيل الدخول';

  @override
  String get support_hours => 'ساعات الدعم';

  @override
  String get mon_fri_9_6 => 'الإثنين-الجمعة: 9:00 صباحًا - 6:00 مساءً';

  @override
  String get how_are_we_doing => 'كيف حالنا؟';

  @override
  String get rate_experience => 'قيم تجربة خدمة العملاء الخاصة بك';

  @override
  String get poor => 'فقير';

  @override
  String get okay => 'تمام';

  @override
  String get good => 'جيد';

  @override
  String get excellent => 'ممتاز';

  @override
  String get account_secure => 'حسابك آمن';

  @override
  String get password_security => 'كلمة المرور والمصادقة';

  @override
  String get change_password => 'تغيير كلمة المرور';

  @override
  String get two_factor_auth => 'المصادقة الثنائية';

  @override
  String get biometric_login => 'تسجيل الدخول البيومتري';

  @override
  String get login_activity => 'نشاط تسجيل الدخول';

  @override
  String get active_sessions => 'الجلسات النشطة';

  @override
  String get login_alerts => 'تنبيهات تسجيل الدخول';

  @override
  String get account_protection => 'حماية الحساب';

  @override
  String get recovery_email => 'البريد الإلكتروني للاسترداد';

  @override
  String get backup_codes => 'رموز النسخ الاحتياطي';

  @override
  String get danger_zone => 'منطقة الخطر';

  @override
  String get improve_security => 'تحسين الأمن';

  @override
  String get security_score => 'نقاط الأمان';

  @override
  String get last_changed_days => 'تم آخر تغيير منذ 30 يومًا';

  @override
  String get logout_all_devices => 'تسجيل الخروج من جميع الأجهزة';

  @override
  String get end_all_sessions => 'إنهاء كافة الجلسات';

  @override
  String get permanently_delete => 'حذف نهائيا';

  @override
  String get verification_code_message => 'سنرسل رمز التحقق لتأكيد هويتك.';

  @override
  String get send_code => 'إرسال الرمز';

  @override
  String get enter_verification_code => 'أدخل رمز التحقق';

  @override
  String get verification_code => 'رمز التحقق';

  @override
  String get new_password => 'كلمة المرور الجديدة';

  @override
  String get confirm_password => 'تأكيد كلمة المرور';

  @override
  String get resend_code => 'إعادة إرسال الرمز';

  @override
  String get code_sent_to => 'أدخل رمز التحقق المرسل إليه';

  @override
  String get enter_code => 'أدخل رمز التحقق';

  @override
  String get code_must_be_6_digits => 'يجب أن يتكون الرمز من 6 أرقام';

  @override
  String get enter_new_password => 'أدخل كلمة المرور الجديدة';

  @override
  String get minimum_8_characters => 'الحد الأدنى 8 أحرف';

  @override
  String get passwords_do_not_match => 'كلمات المرور غير متطابقة';

  @override
  String get close => 'يغلق';

  @override
  String get current => 'حاضِر';

  @override
  String get session_ended => 'انتهت الجلسة';

  @override
  String get update_recovery_email => 'تحديث البريد الإلكتروني للاسترداد';

  @override
  String get new_email => 'البريد الإلكتروني الجديد';

  @override
  String get update => 'تحديث';

  @override
  String get verification_email_sent => 'تم إرسال بريد إلكتروني للتحقق';

  @override
  String get generate_emergency_codes => 'توليد رموز الطوارئ';

  @override
  String get copy_all => 'نسخ الكل';

  @override
  String get code_copied => 'تم نسخ الكود';

  @override
  String get all_codes_copied => 'تم نسخ كافة الرموز';

  @override
  String get logout_all_devices_confirm => 'تسجيل الخروج من جميع الأجهزة؟';

  @override
  String get logout_all_devices_message =>
      'سيؤدي هذا إلى إنهاء جميع الجلسات النشطة على جميع الأجهزة.';

  @override
  String get logout_all => 'تسجيل الخروج الكل';

  @override
  String get delete_account_confirm => 'هل تريد حذف الحساب؟';

  @override
  String get delete_account_warning =>
      'هذا الإجراء دائم ولا يمكن التراجع عنه. سيتم حذف جميع بياناتك نهائيًا.';

  @override
  String get what_will_be_deleted => 'ما سيتم حذفه:';

  @override
  String get profile_and_account_info => '• ملفك الشخصي ومعلومات الحساب';

  @override
  String get all_listings_and_posts => '• جميع القوائم والمشاركات الخاصة بك';

  @override
  String get messages_and_conversations => 'رسائل';

  @override
  String get saved_items_and_preferences => '• العناصر المحفوظة والتفضيلات';

  @override
  String get enter_password_to_continue =>
      'أدخل كلمة المرور الخاصة بك للمتابعة';

  @override
  String get continue_val => 'يكمل';

  @override
  String get please_enter_password => 'الرجاء إدخال كلمة المرور الخاصة بك';

  @override
  String get enter_confirmation_code => 'أدخل رمز التأكيد';

  @override
  String get deletion_confirmation_message =>
      'لقد أرسلنا رمز التأكيد إلى هاتفك. أدخله أدناه لحذف حسابك نهائيًا.';

  @override
  String get confirmation_code => 'رمز التأكيد';

  @override
  String get please_enter_6_digit_code =>
      'الرجاء إدخال الرمز المكون من 6 أرقام';

  @override
  String get account_deleted => 'لقد تم حذف حسابك';

  @override
  String get deletion_cancelled => 'تم إلغاء الحذف';

  @override
  String get failed_to_load_user_info => 'فشل تحميل معلومات المستخدم';

  @override
  String get auth_login_to_view_saved =>
      'الرجاء تسجيل الدخول لعرض العقارات المحفوظة الخاصة بك';

  @override
  String get authLoginRequired => 'تسجيل الدخول مطلوب';

  @override
  String get authLoginToViewSaved =>
      'الرجاء تسجيل الدخول لعرض العقارات المحفوظة الخاصة بك';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get savedPropertiesTitle => 'الخصائص المحفوظة';

  @override
  String get loadingSavedProperties => 'جارٍ تحميل الخصائص المحفوظة...';

  @override
  String get errorsFailedToLoadSaved => 'فشل تحميل الخصائص المحفوظة';

  @override
  String get actionsRetry => 'أعد المحاولة';

  @override
  String get savedPropertiesNoSaved => 'لا توجد خصائص محفوظة';

  @override
  String get savedPropertiesStartSaving =>
      'ابدأ في استكشاف وحفظ الخصائص التي تريدها';

  @override
  String get savedPropertiesBrowse => 'تصفح الخصائص';

  @override
  String get resultsSavedProperties => 'الخصائص المحفوظة';

  @override
  String get actionsRefresh => 'ينعش';

  @override
  String get resultsNoMoreProperties => 'لا مزيد من الخصائص';

  @override
  String get propertyCardFeatured => 'مميز';

  @override
  String get successPropertyUnsaved => 'تمت إزالة الخاصية من القائمة المحفوظة';

  @override
  String get alertsUnsavePropertyFailed => 'فشلت إزالة الخاصية';

  @override
  String get propertyCardBed => 'سرير';

  @override
  String get propertyCardBath => 'حمام';

  @override
  String get savedPropertiesSavedOn => 'تم الحفظ في';

  @override
  String get propertyCardViewDetails => 'عرض التفاصيل';

  @override
  String get serviceDetailTitle => 'تفاصيل الخدمة';

  @override
  String get errorLoadingFavorites => 'حدث خطأ أثناء تحميل العناصر المفضلة';

  @override
  String get noFavoritesFound => 'لم يتم العثور على العناصر المفضلة.';

  @override
  String get commentUpdatedSuccess => 'تم تحديث التعليق بنجاح!';

  @override
  String get errorUpdatingComment => 'حدث خطأ أثناء تحديث التعليق';

  @override
  String get replyAddedSuccess => 'تمت إضافة الرد بنجاح!';

  @override
  String get errorAddingReply => 'حدث خطأ أثناء إضافة الرد';

  @override
  String get commentDeletedSuccess => 'تم حذف التعليق بنجاح!';

  @override
  String get errorDeletingComment => 'حدث خطأ أثناء حذف التعليق';

  @override
  String get serviceLikedSuccess => 'الخدمة أعجبتك بنجاح!';

  @override
  String get errorLikingService => 'خطأ في الإعجاب بالخدمة';

  @override
  String get serviceDislikedSuccess => 'تم رفض الخدمة بنجاح!';

  @override
  String get errorDislikingService => 'خطأ في عدم الإعجاب بالخدمة';

  @override
  String get writeYourReply => 'أكتب ردك...';

  @override
  String get postReply => 'الرد على الرد';

  @override
  String get anonymous => 'مجهول';

  @override
  String get editComment => 'تحرير التعليق';

  @override
  String get editYourComment => 'عدل تعليقك...';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get propertyOwner => 'مالك العقار';

  @override
  String get errorLoadingServices => 'خطأ في تحميل الخدمات';

  @override
  String get noRecommendedServicesFound =>
      'لم يتم العثور على الخدمات الموصى بها.';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get passwordRequirements => 'كلمة المرور يجب أن تحتوي على حروف وأرقام';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get usernameTooShort => 'يجب أن يكون اسم المستخدم 3 أحرف على الأقل';

  @override
  String get confirmPasswordRequired => 'مطلوب تأكيد كلمة المرور';

  @override
  String get passwordHelp => 'ما لا يقل عن 8 أحرف وحروف وأرقام';

  @override
  String get usernameExists => 'اسم المستخدم هذا موجود بالفعل';

  @override
  String get phoneExists => 'رقم الهاتف هذا مسجل بالفعل';

  @override
  String get networkError =>
      'خطأ في الاتصال بالشبكة. يرجى التحقق من الاتصال الخاص بك';

  @override
  String get contactSeller => 'اتصل بالبائع';

  @override
  String get callToReveal => 'اضغط على \"اتصال\" للكشف';

  @override
  String get camera => 'آلة تصوير';

  @override
  String get gallery => 'معرض';

  @override
  String get selectImageSource => 'حدد مصدر الصورة';

  @override
  String get uploading => 'جارٍ التحميل...';

  @override
  String get acceptTermsRequired => 'يجب عليك قبول الشروط والأحكام للمتابعة';

  @override
  String get iAgreeToTerms => 'أنا أوافق على';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get zeroToleranceStatement =>
      'وندرك أنه لا يوجد أي تسامح مطلقًا مع المحتوى غير المرغوب فيه أو المستخدمين المسيئين.';

  @override
  String get viewTerms => 'عرض الشروط والأحكام';

  @override
  String get reportContent => 'الإبلاغ عن المحتوى';

  @override
  String get selectReportReason => 'الرجاء تحديد سبب للإبلاغ:';

  @override
  String get additionalDetails => 'تفاصيل إضافية (اختياري)';

  @override
  String get reportDetailsHint => 'تقديم أية معلومات إضافية...';

  @override
  String get reportSubmitted =>
      'شكرا لك على تقريرك. سوف نقوم بمراجعته في غضون 24 ساعة.';

  @override
  String get reportProduct => 'الإبلاغ عن المنتج';

  @override
  String get reportService => 'خدمة التقارير';

  @override
  String get reportMessage => 'تقرير الرسالة';

  @override
  String get reportUser => 'الإبلاغ عن المستخدم';

  @override
  String get reportErrorNotImplemented =>
      'ميزة الإبلاغ غير متاحة بعد. يرجى الاتصال بالدعم أو المحاولة مرة أخرى لاحقًا.';

  @override
  String get reportAlreadySubmitted =>
      'لقد قمت بالفعل بالإبلاغ عن هذا المحتوى. نحن نراجع تقريرك السابق.';

  @override
  String get reportFailedGeneric =>
      'فشل في تقديم التقرير. يرجى المحاولة مرة أخرى.';

  @override
  String get reportFailedNetwork =>
      'حدث خطأ في الشبكة. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';

  @override
  String get becomeAgentTitle => 'انضم كوكيل عقاري';

  @override
  String get becomeAgentSubtitle =>
      'قائمة العقارات ومساعدة العملاء في العثور على منازل أحلامهم';

  @override
  String get agentBenefits => 'فوائد:';

  @override
  String get agentBenefitVerified => 'شارة الوكيل المعتمد';

  @override
  String get agentBenefitAnalytics => 'الوصول إلى التحليلات والرؤى';

  @override
  String get agentBenefitClients => 'الاتصال المباشر مع العملاء المحتملين';

  @override
  String get agentBenefitReputation => 'بناء سمعتك المهنية';

  @override
  String get agentApplicationForm => 'نموذج الطلب';

  @override
  String get agentAgencyName => 'اسم الوكالة';

  @override
  String get agentAgencyNameHint => 'أدخل اسم الوكالة العقارية الخاصة بك';

  @override
  String get agentAgencyNameRequired => 'اسم الوكالة مطلوب';

  @override
  String get agentLicenceNumber => 'رقم الترخيص';

  @override
  String get agentLicenceNumberHint => 'أدخل رقم الترخيص العقاري الخاص بك';

  @override
  String get agentLicenceNumberRequired => 'رقم الترخيص مطلوب';

  @override
  String get agentYearsExperience => 'سنوات من الخبرة';

  @override
  String get agentYearsExperienceHint => 'أدخل عدد السنوات';

  @override
  String get agentYearsExperienceRequired => 'سنوات الخبرة مطلوبة';

  @override
  String get agentYearsExperienceInvalid => 'الرجاء إدخال رقم صالح';

  @override
  String get agentSpecialization => 'التخصص';

  @override
  String get agentApplicationNote =>
      'سيتم مراجعة طلبك من قبل فريقنا. سيتم إعلامك بمجرد الموافقة على طلبك.';

  @override
  String get agentSubmitApplication => 'تقديم الطلب';

  @override
  String get agentApplicationSubmitted =>
      'تم تقديم الطلب بنجاح! سوف نقوم بمراجعته قريبا.';

  @override
  String get agentApplicationStatus => 'حالة التطبيق';

  @override
  String get agentViewProfile => 'عرض ملف تعريف الوكيل الخاص بك';

  @override
  String get agentDashboardComingSoon => 'لوحة تحكم الوكيل قريبا!';

  @override
  String get property_create_basic_information => 'المعلومات الأساسية';

  @override
  String get property_create_property_title => 'عنوان العقار *';

  @override
  String get property_create_property_title_hint =>
      'على سبيل المثال، شقة حديثة مكونة من 3 غرف نوم في وسط المدينة';

  @override
  String get property_create_property_title_required =>
      'الرجاء إدخال عنوان العقار';

  @override
  String get property_create_description => 'وصف *';

  @override
  String get property_create_description_hint => 'وصف عقارك بالتفصيل...';

  @override
  String get property_create_description_required => 'الرجاء إدخال الوصف';

  @override
  String get property_create_property_type => 'نوع العقار';

  @override
  String get property_create_property_type_required => 'نوع العقار *';

  @override
  String get property_create_listing_type_required => 'نوع القائمة *';

  @override
  String get property_create_pricing => 'التسعير';

  @override
  String get property_create_price => 'سعر *';

  @override
  String get property_create_price_hint => 'أدخل السعر';

  @override
  String get property_create_price_required => 'الرجاء إدخال السعر';

  @override
  String get property_create_currency => 'عملة';

  @override
  String get property_create_property_details => 'تفاصيل العقار';

  @override
  String get property_create_square_meters => 'مربع. العدادات *';

  @override
  String get property_create_bedrooms => 'غرف النوم *';

  @override
  String get property_create_bathrooms => 'الحمامات *';

  @override
  String get property_create_floor => 'أرضية';

  @override
  String get property_create_total_floors => 'إجمالي الطوابق';

  @override
  String get property_create_parking => 'وقوف السيارات';

  @override
  String get property_create_year_built => 'سنة البناء';

  @override
  String get property_create_location => 'موقع';

  @override
  String get property_create_address => 'عنوان *';

  @override
  String get property_create_address_hint => 'أدخل عنوان العقار';

  @override
  String get property_create_address_required => 'الرجاء إدخال العنوان';

  @override
  String get property_create_location_detected => 'تم الكشف عن الموقع';

  @override
  String get property_create_get_location => 'احصل على الموقع الحالي';

  @override
  String get property_create_features => 'سمات';

  @override
  String get property_create_feature_balcony => 'شرفة';

  @override
  String get property_create_feature_garage => 'المرآب';

  @override
  String get property_create_feature_garden => 'حديقة';

  @override
  String get property_create_feature_pool => 'حمام سباحة';

  @override
  String get property_create_feature_elevator => 'مصعد';

  @override
  String get property_create_feature_furnished => 'مفروشة';

  @override
  String get property_create_images => 'صور الملكية';

  @override
  String get property_create_tap_to_add_images => 'انقر لإضافة الصور';

  @override
  String get property_create_at_least_one_image => 'مطلوب صورة واحدة على الأقل';

  @override
  String get property_create_add_more => 'أضف المزيد';

  @override
  String get property_create_required => 'مطلوب';

  @override
  String get property_create_location_required =>
      'يرجى تفعيل خدمات الموقع لإنشاء عقار';

  @override
  String get property_create_image_required =>
      'مطلوب صورة ملكية واحدة على الأقل';

  @override
  String get emailVerification => 'التحقق من البريد الإلكتروني';

  @override
  String get pleaseEnterYourEmailAddress =>
      'الرجاء إدخال عنوان البريد الإلكتروني الخاص بك';

  @override
  String get enterEmailAddress => 'أدخل عنوان البريد الإلكتروني';

  @override
  String get resetYourPassword => 'إعادة تعيين كلمة المرور الخاصة بك';

  @override
  String get resetPasswordDescription =>
      'أدخل عنوان بريدك الإلكتروني وسنرسل لك رمز التحقق لإعادة تعيين كلمة المرور الخاصة بك.';

  @override
  String get sendVerificationCode => 'إرسال رمز التحقق';

  @override
  String get backToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String enterVerificationCodeSentTo(String email) {
    return 'أدخل رمز التحقق المرسل إلى $email';
  }

  @override
  String get codeMustBe6Digits => 'يجب أن يتكون الرمز من 6 أرقام';

  @override
  String get enterNewPassword => 'أدخل كلمة المرور الجديدة';

  @override
  String get minimum8Characters => 'الحد الأدنى 8 أحرف';

  @override
  String get sending => 'إرسال...';

  @override
  String get verifying => 'جارٍ التحقق...';

  @override
  String get new_message => 'رسالة جديدة';

  @override
  String get messages => 'رسائل';

  @override
  String get please_log_in => 'الرجاء تسجيل الدخول لمشاهدة الرسائل';

  @override
  String get pin => 'دبوس';

  @override
  String get unpin => 'إزالة التثبيت';

  @override
  String get delete_chat => 'حذف الدردشة';

  @override
  String delete_chat_confirm(String name) {
    return 'هل أنت متأكد أنك تريد حذف الدردشة مع $name؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String chat_deleted(String name) {
    return 'تم حذف الدردشة مع $name';
  }

  @override
  String get delete_failed => 'فشل حذف الدردشة';

  @override
  String get no_conversations => 'لا توجد محادثات حتى الآن';

  @override
  String get start_conversation_hint => 'ابدأ محادثة بالضغط على الزر +';

  @override
  String get start_conversation => 'ابدأ محادثة';

  @override
  String get yesterday => 'أمس';

  @override
  String get unknown => 'مجهول';

  @override
  String get no_messages_yet => 'لا توجد رسائل حتى الآن';

  @override
  String get unblock_user => 'إلغاء حظر المستخدم';

  @override
  String get block_user => 'حظر المستخدم';

  @override
  String get no_blocked_users => 'لا يوجد مستخدمين محظورين';

  @override
  String get blocked_users_hint => 'سيظهر هنا المستخدمون الذين قمت بحظرهم';

  @override
  String unblock_user_confirm(String username) {
    return 'هل أنت متأكد أنك تريد إلغاء حظر $username؟ ستتمكن من تلقي الرسائل منهم مرة أخرى.';
  }

  @override
  String user_unblocked(String username) {
    return 'تم رفع الحظر عن $username';
  }

  @override
  String user_blocked(String username) {
    return 'تم حظر $username';
  }

  @override
  String get failed_to_unblock => 'فشل في إلغاء حظر المستخدم';

  @override
  String get failed_to_block => 'فشل في حظر المستخدم';

  @override
  String get chat_info => 'معلومات الدردشة';

  @override
  String get delete_message => 'حذف الرسالة';

  @override
  String get delete_message_confirm => 'هل أنت متأكد أنك تريد حذف هذه الرسالة؟';

  @override
  String get typing => 'الكتابة...';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String last_seen_at(String time) {
    return 'آخر ظهور $time';
  }

  @override
  String participants(int count) {
    return '$count المشاركون';
  }

  @override
  String get you_are_blocked => 'أنت محظور';

  @override
  String user_blocked_you(String username) {
    return 'لقد قام $username بحظرك. لا يمكنك إرسال الرسائل.';
  }

  @override
  String you_blocked_user(String username) {
    return 'لقد قمت بحظر $username';
  }

  @override
  String get cannot_send_messages_blocked =>
      'لا يمكنك إرسال الرسائل. لقد تم حظرك.';

  @override
  String get this_message_was_deleted => 'تم حذف هذه الرسالة';

  @override
  String get edit => 'يحرر';

  @override
  String get reply => 'رد';

  @override
  String get editing_message => 'تحرير الرسالة';

  @override
  String replying_to(String username) {
    return 'الرد على $username';
  }

  @override
  String get voice => 'صوت';

  @override
  String get emoji => 'الرموز التعبيرية';

  @override
  String get photo => '📷 صورة';

  @override
  String get voice_message => '🎤 رسالة صوتية';

  @override
  String get searching => 'جارٍ البحث...';

  @override
  String get loading_users => 'جارٍ تحميل المستخدمين...';

  @override
  String search_failed(String error) {
    return 'فشل البحث: $error';
  }

  @override
  String get invalid_user_data => 'بيانات المستخدم غير صالحة';

  @override
  String failed_to_start_chat(String error) {
    return 'فشل بدء الدردشة: $error';
  }

  @override
  String get audio_file_not_available => 'الملف الصوتي غير متوفر';

  @override
  String failed_to_play_audio(String error) {
    return 'فشل تشغيل الصوت: $error';
  }

  @override
  String get image_unavailable => 'الصورة غير متاحة';

  @override
  String get image_too_large =>
      '❌ الصورة كبيرة جدًا. الحد الأقصى للحجم هو 10 ميغابايت';

  @override
  String get image_file_not_found => '❌ ملف الصورة غير موجود';

  @override
  String get uploading_image => 'جارٍ تحميل الصورة...';

  @override
  String get image_sent => '✅ تم إرسال الصورة!';

  @override
  String get failed_to_send_image => '❌ فشل إرسال الصورة';

  @override
  String get uploading_voice_message => 'جارٍ تحميل الرسالة الصوتية...';

  @override
  String get voice_message_sent => '✅ تم إرسال رسالة صوتية!';

  @override
  String get failed_to_send_voice_message => '❌ فشل إرسال الرسالة الصوتية';

  @override
  String get recording => '🎙️ تسجيل...';

  @override
  String get microphone_permission_denied => 'تم رفض إذن الميكروفون';

  @override
  String get starting_chat => 'جارٍ بدء الدردشة...';

  @override
  String get refresh_users => 'تحديث المستخدمين';

  @override
  String get search_by_username_or_phone =>
      'البحث حسب اسم المستخدم أو رقم الهاتف';

  @override
  String get no_users_found => 'لم يتم العثور على مستخدمين';

  @override
  String get try_different_search_term => 'حاول استخدام مصطلح بحث مختلف';

  @override
  String get no_users_available => 'لا يوجد مستخدمين متاحين';

  @override
  String get chat_exists => 'الدردشة موجودة';

  @override
  String block_user_confirm(String username) {
    return 'هل أنت متأكد أنك تريد حظر $username؟ لن تتلقى رسائل منهم وستتم إزالتهم من قائمة الدردشة الخاصة بك.';
  }

  @override
  String chat_room_label(String name) {
    return 'غرفة الدردشة: $name';
  }

  @override
  String id_label(int id) {
    return 'المعرف: $id';
  }

  @override
  String get participants_label => 'مشاركون:';

  @override
  String get type_a_message => 'اكتب رسالة...';

  @override
  String get edit_message_hint => 'تعديل الرسالة...';

  @override
  String error_label(String error) {
    return 'خطأ: $error';
  }

  @override
  String get copy => 'ينسخ';

  @override
  String comments_title(int count) {
    return 'التعليقات ($count)';
  }

  @override
  String get reply_button => 'رد';

  @override
  String replies_count(int count) {
    return 'ردود $count';
  }

  @override
  String get you_label => 'أنت';

  @override
  String get delete_reply_title => 'حذف الرد';

  @override
  String get delete_comment_title => 'حذف التعليق';

  @override
  String get unknown_date => 'تاريخ غير معروف';

  @override
  String get press_enter_to_send => 'اضغط على Enter للإرسال';

  @override
  String get comment_add_error => 'فشل في إضافة تعليق';

  @override
  String get service_provider => 'مزود الخدمة';

  @override
  String get opening_chat => 'جارٍ فتح الدردشة...';

  @override
  String get failed_to_refresh => 'فشل التحديث';

  @override
  String get cannot_chat_with_yourself => 'لا يمكنك الدردشة مع نفسك';

  @override
  String opening_chat_with(String username) {
    return 'جارٍ فتح الدردشة مع $username...';
  }

  @override
  String get this_will_only_take_a_moment => 'هذا سوف يستغرق لحظة واحدة فقط';

  @override
  String get unable_to_start_chat =>
      'غير قادر على بدء الدردشة. يرجى المحاولة مرة أخرى.';

  @override
  String get profile_listings => 'القوائم';

  @override
  String get profile_followers => 'المتابعون';

  @override
  String get profile_following => 'التالي';

  @override
  String get profile_no_products => 'لا توجد منتجات';

  @override
  String get profile_no_services => 'لا توجد خدمات';

  @override
  String get profile_no_properties => 'لا توجد خصائص';

  @override
  String get profile_user_no_products => 'هذا المستخدم لم ينشر أي منتجات بعد';

  @override
  String get profile_user_no_services => 'هذا المستخدم لم ينشر أي خدمات بعد';

  @override
  String get profile_user_no_properties => 'هذا المستخدم لم ينشر أي عقارات بعد';

  @override
  String get profile_error_occurred => 'حدث خطأ';

  @override
  String get profile_error_loading_products => 'حدث خطأ أثناء تحميل المنتجات';

  @override
  String get profile_error_loading_services => 'خطأ في تحميل الخدمات';

  @override
  String get profile_no_followers_yet => 'لا يوجد متابعين بعد';

  @override
  String get profile_no_following_yet => 'لا أتابع أحداً بعد';

  @override
  String get profile_follow => 'يتبع';

  @override
  String get profile_following_btn => 'التالي';

  @override
  String get profile_message => 'رسالة';

  @override
  String get profile_member_since => 'عضو منذ';

  @override
  String get profile_loading_error => 'حدث خطأ أثناء تحميل الملف الشخصي';

  @override
  String get profile_retry => 'حاول ثانية';

  @override
  String get profile_share => 'يشارك';

  @override
  String get profile_copy_link => 'نسخ الوصلة';

  @override
  String get profile_report => 'تقرير';

  @override
  String get linkCopied => 'تم نسخ الرابط إلى الحافظة';

  @override
  String get checkOutProfile => 'الدفع';

  @override
  String get onTezsell => 'على تيزسيل';

  @override
  String get selectCountryFirst => 'اختر البلد أولا';

  @override
  String get countrySelectionHint => 'ثم يمكنك اختيار منطقتك';

  @override
  String get something_went_wrong => 'حدث خطأ ما';

  @override
  String get check_connection_and_retry =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';

  @override
  String get sold_badge => 'مُباع';

  @override
  String get more_categories => 'أكثر';

  @override
  String no_products_in_location(String location) {
    return 'لم يتم العثور على منتجات في $location';
  }

  @override
  String get no_more_products => 'لا مزيد من المنتجات للتحميل';

  @override
  String time_days_ago(int count) {
    return '${count}d منذ';
  }

  @override
  String time_hours_ago(int count) {
    return '${count}h منذ';
  }

  @override
  String time_minutes_ago(int count) {
    return '$countم مضت';
  }

  @override
  String get time_just_now => 'الآن';

  @override
  String no_services_in_location(String location) {
    return 'لم يتم العثور على خدمات في $location';
  }

  @override
  String get no_more_services => 'لا مزيد من الخدمات للتحميل';

  @override
  String get error_loading_more_services =>
      'حدث خطأ أثناء تحميل المزيد من الخدمات';

  @override
  String get verification_code_length => 'يجب أن يتكون رمز التحقق من 6 أرقام';

  @override
  String get map_register_title => 'أين تعيش؟';

  @override
  String get map_register_headline => 'اختر الحي الخاص بك على الخريطة';

  @override
  String get map_register_subtitle =>
      'نستخدمها لتظهر لك المشترين والبائعين القريبين. يمكنك ضبط نصف القطر الخاص بك لاحقًا.';

  @override
  String get pick_on_map => 'اختر على الخريطة';

  @override
  String get pick_again => 'اختر مرة أخرى';

  @override
  String get resolving_location => 'جارٍ حل الموقع…';

  @override
  String get use_dropdown_instead => 'استخدم القائمة المنسدلة بدلاً من ذلك';

  @override
  String country_not_supported(String country) {
    return 'نحن لا ندعم $country حتى الآن.';
  }

  @override
  String get region_not_auto_detected =>
      'تعذر اكتشاف منطقتك تلقائيًا — اخترها يدويًا.';

  @override
  String get district_not_auto_detected =>
      'تعذر اكتشاف منطقتك تلقائيًا — اخترها يدويًا.';

  @override
  String get browse_no_items_with_location =>
      'لا توجد عناصر تحتوي على بيانات الموقع في هذه المنطقة حتى الآن.';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => 'تحديد الموقع';

  @override
  String get location_picker_confirm => 'تأكيد الموقع';

  @override
  String get location_picker_resolve_failed =>
      'تعذر حل العنوان — اختر مرة أخرى أو أكد باستخدام الإحداثيات فقط';

  @override
  String get location_picker_selected_fallback => 'الموقع المحدد';

  @override
  String get location_permission_denied => 'تم رفض إذن تحديد الموقع';

  @override
  String get location_permission_denied_settings =>
      'تم رفض إذن الموقع - يرجى تمكينه في الإعدادات';

  @override
  String get location_permission_permanent =>
      'تم رفض الموقع نهائيًا - افتح الإعدادات للتمكين';

  @override
  String gps_error(String error) {
    return 'خطأ نظام تحديد المواقع العالمي (GPS): $error';
  }

  @override
  String get verify_neighborhood_title => 'التحقق من منطقتك';

  @override
  String get verify_neighborhood_subtitle =>
      'قف في حيك. سوف نتحقق من نظام تحديد المواقع العالمي (GPS) الخاص بك ونطلب منك التأكيد.';

  @override
  String get verify_neighborhood_button => 'التحقق من الحي';

  @override
  String get verify_neighborhood_low_confidence => 'استمر بثقة منخفضة';

  @override
  String get verify_neighborhood_retry => 'أعد المحاولة';

  @override
  String get verify_neighborhood_youre_in => 'أنت في:';

  @override
  String verify_neighborhood_done(String name) {
    return 'تم التحقق! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'دقة نظام تحديد المواقع العالمي (GPS) هي ${meters}m (تحتاج إلى ≥100m). انتقل إلى منطقة مفتوحة وحاول مرة أخرى.';
  }

  @override
  String get neighborhood_not_identified => 'لا يمكن تحديد الحي لموقعك.';

  @override
  String get unknown_error => 'خطأ غير معروف';

  @override
  String get place_search_hint => 'ابحث عن عنوان أو مكان';

  @override
  String get place_search_unavailable =>
      'البحث غير متاح — أسقط دبوسًا بدلاً من ذلك';

  @override
  String get radius_slider_city => 'مدينة';

  @override
  String radius_slider_km(String value) {
    return '$value كم';
  }

  @override
  String get my_neighborhoods => 'أحيائي';

  @override
  String get manage_on_map => 'إدارة على الخريطة';

  @override
  String get no_neighborhoods_yet =>
      'لا توجد أحياء موثقة بعد. افتح الخريطة للتحقق من مكان وجودك.';

  @override
  String get open_map_to_verify => 'فتح الخريطة للتحقق من موقع جديد';

  @override
  String get verify_here => 'التحقق هنا';

  @override
  String get verify_new_location => 'التحقق من موقع جديد';

  @override
  String eviction_warning(String name) {
    return 'سيؤدي إضافة هذا الموقع إلى إزالة $name (الأقدم). لا يمكن التراجع عن ذلك.';
  }

  @override
  String get verified_today => 'تم التحقق اليوم';

  @override
  String get verified_yesterday => 'تم التحقق أمس';

  @override
  String verified_n_days_ago(int days) {
    return 'تم التحقق منذ $days أيام';
  }

  @override
  String get active_neighborhood => 'نشط';

  @override
  String switch_neighborhood_success(String name) {
    return 'تم التبديل إلى $name';
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
  String get communityMaxImages => 'Up to 5 photos';

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
}
