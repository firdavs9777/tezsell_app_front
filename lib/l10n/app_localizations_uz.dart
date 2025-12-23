// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get welcome => 'Xush kelibsiz';

  @override
  String get welcomeBack => 'Xush kelibsiz!';

  @override
  String get loginToYourAccount => 'Davom etish uchun kiring';

  @override
  String get or => 'YOKI';

  @override
  String get dontHaveAccount => 'Hisobingiz yo\'qmi?';

  @override
  String get chooseLanguage => 'Tilingizni tanlang';

  @override
  String get selectPreferredLanguage =>
      'Ilova uchun kerakli tilingizni tanlang';

  @override
  String get continueButton => 'Davom etish';

  @override
  String get sellAndBuyProducts =>
      'Mahsulotlaringizni faqat bizda soting  va sotib oling';

  @override
  String get usedProductsMarket =>
      'Ishlatilgan mahsulotlar yohud ikkinchi qo\'l bozori';

  @override
  String get register => 'Ro\'yxatdan o\'tish';

  @override
  String get alreadyHaveAccount => 'Hisobingiz bormi?';

  @override
  String get login => 'Kirish';

  @override
  String get loginToAccount => 'Hisobga kirish';

  @override
  String get enterPhoneNumber => 'Telefon raqamini kiriting';

  @override
  String get password => 'Parol';

  @override
  String get enterPassword => 'Parolni kiriting';

  @override
  String get forgotPassword => 'Parolni unutdingizmi?';

  @override
  String get registerNow => 'Ro\'yhatdan o\'tish';

  @override
  String get loading => 'Yuklanmoqda...';

  @override
  String get pleaseEnterPhoneNumber => 'Iltimos, telefon raqamingizni kiriting';

  @override
  String get pleaseEnterPassword => 'Iltimos, parolingizni kiriting';

  @override
  String get unexpectedError =>
      'Kutilmagan xatolik yuz berdi. Qaytadan urinib ko\'ring.';

  @override
  String get forgotPasswordComingSoon => 'Parolni tiklash funksiyasi tez orada';

  @override
  String get selectedCountryLabel => 'Tanlandi:';

  @override
  String get fullPhoneLabel => 'To\'liq:';

  @override
  String get home => 'Bosh sahifa';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Qidiruv';

  @override
  String get notifications => 'Bildirishnomalar';

  @override
  String get error => 'Xatolik';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get save => 'Saqlash';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Iltimos, hududingizni tanlang';

  @override
  String get searchHint => 'Tuman yoki shaharni qidiring';

  @override
  String get apiError => 'API chaqirishda muammo yuz berdi';

  @override
  String get ok => 'OK';

  @override
  String get emptyList => 'Bo\'sh ro\'yxat';

  @override
  String get dataLoadingError => 'Ma\'lumotlarni yuklashda xatolik';

  @override
  String get confirm => 'Tasdiqlash';

  @override
  String get yes => 'Ha';

  @override
  String get no => 'Yo\'q';

  @override
  String confirmRegionSelection(Object regionName) {
    return '$regionName hududini tanlashni xohlaysizmi?';
  }

  @override
  String get selectDistrictOrCity => 'Iltimos, tuman yoki shahringizni tanlang';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return '$regionName hududi - ${districtName}ni tanlashni xohlaysizmi?';
  }

  @override
  String get noResultsFound => 'Natijalar topilmadi.';

  @override
  String errorWithCode(String errorCode) {
    return 'Xatolik: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'Ma\'lumotlarni yuklashda muvaffaqiyatsizlik. Xatolik: $error';
  }

  @override
  String get phoneVerification => 'Telefon raqamini tasdiqlash';

  @override
  String get enterPhonePrompt => 'Iltimos, telefon raqamingizni kiriting';

  @override
  String get enterPhoneNumberHint => 'Telefon raqamini kiriting';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Tanlandi: $countryName ($countryCode)';
  }

  @override
  String fullNumber(String phoneNumber) {
    return 'To\'liq raqam: $phoneNumber';
  }

  @override
  String get sendCode => 'Kod yuborish';

  @override
  String get enterVerificationCode => 'Tasdiqlash kodini kiriting';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Kodni qayta yuborish';

  @override
  String expires(String time) {
    return 'Tugaydi: $time';
  }

  @override
  String get verifyAndContinue => 'Tasdiqlash va davom etish';

  @override
  String get invalidVerificationCode => 'Noto\'g\'ri tasdiqlash kodi';

  @override
  String get verificationCodeSent => 'Tasdiqlash kodi muvaffaqiyatli yuborildi';

  @override
  String get failedToSendCode =>
      'Tasdiqlash kodini yuborishda muvaffaqiyatsizlik';

  @override
  String get verificationCodeResent => 'Tasdiqlash kodi qayta yuborildi';

  @override
  String get failedToResendCode => 'Kodni qayta yuborishda muvaffaqiyatsizlik';

  @override
  String get passwordVerification => 'Parolni tasdiqlash';

  @override
  String get completeRegistrationPrompt =>
      'Ro\'yxatdan o\'tishni yakunlash uchun foydalanuvchi nomi va parolni kiriting';

  @override
  String get username => 'Foydalanuvchi nomi';

  @override
  String get username_required => 'Foydalanuvchi nomi majburiy';

  @override
  String get username_min_length =>
      'Foydalanuvchi nomi kamida 2 ta belgidan iborat bo\'lishi kerak';

  @override
  String get usernameHint => 'Foydalanuvchi123';

  @override
  String get confirmPassword => 'Parolni tasdiqlang';

  @override
  String get profileImage => 'Profil rasmi';

  @override
  String get imageInstructions =>
      'Rasmlar shu yerda paydo bo\'ladi, iltimos profil rasmiga bosing';

  @override
  String get finish => 'Yakunlash';

  @override
  String get passwordsDoNotMatch => 'Parollar mos kelmaydi';

  @override
  String get registrationError => 'Ro\'yxatdan o\'tishda xatolik';

  @override
  String get about => 'Biz haqimizda';

  @override
  String get chat => 'Chat';

  @override
  String get realEstate => 'Ko\'chmas mulk';

  @override
  String get language => 'O\'ZB';

  @override
  String get languageEn => 'Inglizcha';

  @override
  String get languageRu => 'Ruscha';

  @override
  String get languageUz => 'O\'zbekcha';

  @override
  String get serviceLiked => 'Xizmat yoqdi';

  @override
  String get support => 'Qo\'llab-quvvatlash';

  @override
  String get service => 'Biznes xizmatlari';

  @override
  String get aboutContent =>
      'TezSell - yangi va ishlatilgan mahsulotlarni sotib olish va sotish uchun tez va oson bozor. Bizning maqsadimiz har bir foydalanuvchi uchun eng qulay va samarali platformani yaratish, silliq tranzaksiyalarni ta\'minlash va foydalanuvchi uchun qulay tajribani ta\'minlashdir. Sotmoqchi yoki sotib olmoqchi bo\'lishingizdan qat\'i nazar, TezSell ulashish va tranzaksiyalarni bir necha qadamda yakunlashni osonlashtiradi. Biz foydalanuvchilarimizning xavfsizligi va maxfiyligiga ustuvorlik beramiz. Barcha tranzaksiyalar xavfsizlik va muvofiqlikni ta\'minlash uchun diqqat bilan kuzatiladi, bu xaridorlar va sotuvchilarga xotirjamlik beradi. Bizning oddiy va intuitiv interfeys foydalanuvchilarga mahsulotlarni tezda ro\'yxatga olish va kerak bo\'lgan narsalarni topish imkonini beradi. Shuningdek, biz Telegram orqali real vaqtda aloqani osonlashtiramiz, bu sotib olish va sotish jarayonini yanada silliqroq qiladi.';

  @override
  String get errorMessage => 'Xatolik yuz berdi, serverni tekshiring';

  @override
  String get searchLocation => 'Joylashuv';

  @override
  String get searchCategory => 'Kategoriyalar';

  @override
  String get searchProductPlaceholder => 'Mahsulotlarni qidiring';

  @override
  String get searchServicePlaceholder => 'Xizmatlarni qidiring';

  @override
  String get searchText => 'Qidiruv';

  @override
  String get selectedCategory => 'Tanlangan kategoriya: ';

  @override
  String get selectedLocation => 'Tanlangan joylashuv: ';

  @override
  String get productError => 'Mahsulotlar mavjud emas';

  @override
  String get serviceError => 'Xizmatlar mavjud emas';

  @override
  String get locationHeader => 'Joylashuvni tanlang';

  @override
  String get locationPlaceholder => 'Hududni shu yerda qidiring';

  @override
  String get categoryHeader => 'Kategoriyani tanlang';

  @override
  String get categoryPlaceholder => 'Kategoriyalarni qidiring';

  @override
  String get categoryError => 'Kategoriyalar mavjud emas';

  @override
  String get paginationFirst => 'Birinchi';

  @override
  String get paginationPrevious => 'Oldingi';

  @override
  String get pageInfo => 'Sahifa';

  @override
  String get pageNext => 'Keyingi';

  @override
  String get pageLast => 'Oxirgi';

  @override
  String get loadingMessageProduct => 'Mahsulotlar yuklanmoqda...';

  @override
  String get loadingMessageError => 'Yuklashda xatolik';

  @override
  String get likeProductError => 'Mahsulotni yoqtirishda xatolik';

  @override
  String get dislikeProductError => 'Mahsulotni yoqtirmaslikda xatolik';

  @override
  String get loadingMessageLocation => 'Joylashuv yuklanmoqda...';

  @override
  String get loadingLocationError => 'Joylashuvni yuklashda xatolik';

  @override
  String get loadingMessageCategory => 'Kategoriyalar yuklanmoqda...';

  @override
  String get loadingCategoryError => 'Kategoriyalarni yuklashda xatolik:';

  @override
  String get profileUpdateSuccessMessage => 'Profil muvaffaqiyatli yangilandi';

  @override
  String get profileUpdateFailMessage =>
      'Profilni yangilashda muvaffaqiyatsizlik';

  @override
  String get seeMoreBtn => 'Ko\'proq ko\'rish';

  @override
  String get profilePageTitle => 'Profil sahifasi';

  @override
  String get editProfileModalTitle => 'Profilni tahrirlash';

  @override
  String get usernameLabel => 'Foydalanuvchi nomi';

  @override
  String get locationLabel => 'Joriy joylashuv';

  @override
  String get profileImageLabel => 'Profil rasmi';

  @override
  String get chooseFileLabel => 'Fayl tanlang';

  @override
  String get uploadBtnLabel => 'Yangilash';

  @override
  String get uploadingBtnLabel => 'Yangilanmoqda...';

  @override
  String get cancelBtnLabel => 'Bekor qilish';

  @override
  String get productsTitle => 'Mahsulotlar';

  @override
  String get servicesTitle => 'Xizmatlar';

  @override
  String get myProductsTitle => 'Mening mahsulotlarim';

  @override
  String get myServicesTitle => 'Mening xizmatlarim';

  @override
  String get favoriteProductsTitle => 'Sevimli mahsulotlar';

  @override
  String get favoriteServicesTitle => 'Sevimli xizmatlar';

  @override
  String get noFavorites => 'Sevimlilar yo\'q';

  @override
  String get addNewProductBtn => 'Yangi mahsulot qo\'shish';

  @override
  String get addNew => 'Yangi';

  @override
  String get addNewServiceBtn => 'Yangi xizmat qo\'shish';

  @override
  String get downloadMobileApp => 'Mobil ilovani yuklab oling';

  @override
  String get registerPhoneNumberSuccess =>
      'Telefon raqami tasdiqlandi! Keyingi bosqichga o\'tishingiz mumkin.';

  @override
  String get regionSelectedMessage => 'Hudud tanlandi:';

  @override
  String get districtSelectMessage => 'Tuman tanlandi:';

  @override
  String get phoneNumberEmptyMessage =>
      'Davom etishdan oldin telefon raqamingizni tasdiqlang';

  @override
  String get regionEmptyMessage => 'Iltimos, avval hududni tanlang';

  @override
  String get districtEmptyMessage => 'Iltimos, tumanni tanlang';

  @override
  String get usernamePasswordEmptyMessage =>
      'Iltimos, foydalanuvchi nomi va parolni kiriting';

  @override
  String get registerTitle => 'Ro\'yxatdan o\'tish';

  @override
  String get previousButton => 'Oldingi';

  @override
  String get nextButton => 'Keyingi';

  @override
  String get completeButton => 'Yakunlash';

  @override
  String stepIndicator(int currentStep) {
    return '$currentStep-qadam 4 tadan';
  }

  @override
  String get districtSelectTitle => 'Tumanlar ro\'yxati';

  @override
  String get districtSelectParagraph => 'Tumanni tanlang:';

  @override
  String get phoneNumber => 'Telefon raqami';

  @override
  String get sendOtp => 'OTP yuborish';

  @override
  String get sendAgain => 'Qayta yuborish';

  @override
  String get verify => 'Tasdiqlash';

  @override
  String get failedToSendOtp =>
      'OTP yuborishda muvaffaqiyatsizlik. Server false qaytardi.';

  @override
  String get errorSendingOtp => 'OTP yuborishda xatolik yuz berdi.';

  @override
  String get invalidPhoneNumber =>
      'Iltimos, to\'g\'ri telefon raqamini kiriting.';

  @override
  String get verificationSuccess => 'Muvaffaqiyatli tasdiqlandi';

  @override
  String get verificationError =>
      'Xatolik yuz berdi. Keyinroq qayta urinib ko\'ring.';

  @override
  String get regionsList => 'Hududlar ro\'yxati';

  @override
  String get enterUsername => 'Foydalanuvchi nomingizni kiriting';

  @override
  String get welcomeMessage =>
      'Tezsell-ga xush kelibsiz, telefon raqamingiz bilan kiring';

  @override
  String get noAccount =>
      'Hali hisobingiz yo\'qmi? Bu yerda ro\'yxatdan o\'ting';

  @override
  String get successLogin => 'Muvaffaqiyatli kirildi';

  @override
  String get myProfile => 'Mening profilim';

  @override
  String get logout => 'chiqish';

  @override
  String get newProductTitle => 'Sarlavha';

  @override
  String get newProductDescription => 'Tavsif';

  @override
  String get newProductPrice => 'Narx';

  @override
  String get newProductCondition => 'Holat';

  @override
  String get newProductCategory => 'Kategoriya';

  @override
  String get newProductImages => 'Rasmlar';

  @override
  String get addNewService => 'Yangi xizmat qo\'shish';

  @override
  String get creating => 'Yaratilmoqda...';

  @override
  String get serviceName => 'Xizmat nomi';

  @override
  String get serviceNamePlaceholder => 'Xizmat nomini kiriting';

  @override
  String get serviceDescription => 'Xizmat tavsifi';

  @override
  String get serviceDescriptionPlaceholder => 'Xizmat tavsifini kiriting';

  @override
  String get serviceCategory => 'Xizmat kategoriyasi';

  @override
  String get selectCategory => 'Kategoriyani tanlang';

  @override
  String get loadingCategories => 'Yuklanmoqda...';

  @override
  String get errorLoadingCategories => 'Kategoriyalarni yuklashda xatolik';

  @override
  String get serviceImages => 'Xizmat rasmlari';

  @override
  String get imageUploadHelper =>
      'Rasmlar qo\'shish uchun + belgisini bosing (maksimal 10 ta)';

  @override
  String get maxImagesError => 'Siz maksimal 10 ta rasm yuklashingiz mumkin';

  @override
  String get categoryNotFound => 'Kategoriya topilmadi';

  @override
  String get productCreatedSuccess => 'Mahsulot muvaffaqiyatli yaratildi';

  @override
  String get productLikeSuccess => 'Mahsulot muvaffaqiyatli yoqtirildi';

  @override
  String get productDislikeSuccess => 'Mahsulot yoqtirilmadi';

  @override
  String get errorCreatingService => 'Xizmat yaratishda xatolik';

  @override
  String get errorCreatingProduct => 'Mahsulot yaratishda xatolik';

  @override
  String get unknownError => 'Xizmat yaratishda noma\'lum xatolik yuz berdi';

  @override
  String get submit => 'Yuborish';

  @override
  String get selectCategoryAction => 'Kategoriyani tanlang';

  @override
  String get selectCondition => 'Holatni tanlang';

  @override
  String get sum => 'Jami';

  @override
  String get noComments =>
      'Hali sharhlar yo\'q. Birinchi bo\'lib sharh yozing!';

  @override
  String get commentLikeSuccess => 'Sharh muvaffaqiyatli yoqtirildi';

  @override
  String get commentLikeError => 'Sharhni yoqtirishda xatolik';

  @override
  String get unknownErrorMessage => 'Noma\'lum xatolik yuz berdi';

  @override
  String get commentDislikeSuccess => 'Sharh yoqtirilmadi';

  @override
  String get commentDislikeError => 'Sharhni yoqtirmaslikda xatolik';

  @override
  String get replyInfo => 'Iltimos, avval javob kiriting';

  @override
  String get replySuccessMessage => 'Javob muvaffaqiyatli qo\'shildi';

  @override
  String get replyErrorMessage => 'Javob yaratishda xatolik yuz berdi';

  @override
  String get commentUpdateSuccess => 'Sharh muvaffaqiyatli yangilandi';

  @override
  String get commentUpdateError => 'Sharhni yangilashda xatolik';

  @override
  String get deleteConfirmationMessage =>
      'Bu sharhni o\'chirishni xohlaysizmi?';

  @override
  String get commentDeleteSuccess => 'Sharh muvaffaqiyatli o\'chirildi';

  @override
  String get commentDeleteError => 'Sharhni o\'chirishda xatolik';

  @override
  String get editLabel => 'Tahrirlash';

  @override
  String get deleteLabel => 'O\'chirish';

  @override
  String get saveLabel => 'Saqlash';

  @override
  String get replyLabel => 'Javob berish';

  @override
  String get replyTitle => 'javoblar';

  @override
  String get replyPlaceholder => 'Javob yozing...';

  @override
  String get chatLoginMessage =>
      'Chat boshlash uchun tizimga kirishingiz kerak';

  @override
  String get chatYourselfMessage => 'O\'zingiz bilan chat qila olmaysiz.';

  @override
  String get chatRoomMessage => 'Chat xonasi yaratildi!';

  @override
  String get chatRoomError => 'Chat yaratishda muvaffaqiyatsizlik!';

  @override
  String get chatCreationError => 'Chat yaratish muvaffaqiyatsiz!';

  @override
  String get productsTotal => 'Jami mahsulotlar';

  @override
  String get perPage => 'element';

  @override
  String get clearAllFilters => 'Barcha filtrlarni tozalash';

  @override
  String get clickToUpload => 'Yuklash uchun bosing';

  @override
  String get productInStock => 'Mavjud';

  @override
  String get productOutStock => 'Mavjud emas';

  @override
  String get productBack => 'Mahsulotlarga qaytish';

  @override
  String get messageSeller => 'Chat';

  @override
  String get recommendedProducts => 'Tavsiya etilgan mahsulotlar';

  @override
  String get deleteConfirmationProduct =>
      'Bu mahsulotni o\'chirishni xohlaysizmi?';

  @override
  String get productDeleteSuccess => 'Mahsulot muvaffaqiyatli o\'chirildi';

  @override
  String get productDeleteError => 'Mahsulotni o\'chirishda xatolik';

  @override
  String get newCondition => 'Yangi';

  @override
  String get used => 'Ishlatilgan';

  @override
  String get imageValidType =>
      'Ba\'zi fayllar qo\'shilmadi. 5MB dan kichik JPG, PNG, GIF yoki WebP fayllarini ishlating.';

  @override
  String get imageConfirmMessage => 'Bu rasmni o\'chirishni xohlaysizmi?';

  @override
  String get titleRequiredMessage => 'Sarlavha majburiy';

  @override
  String get descRequiredMessage => 'Tavsif majburiy';

  @override
  String get priceRequiredMessage => 'Narx majburiy';

  @override
  String get conditionRequiredMessage => 'Holat majburiy';

  @override
  String get pleaseFillAllRequired =>
      'Iltimos, majburiy maydonlarni to\'ldiring';

  @override
  String get oneImageConfirmMessage => 'Kamida bitta mahsulot rasmi kerak';

  @override
  String get categoryRequiredMessage => 'Kategoriya majburiy';

  @override
  String get locationInfoError => 'Foydalanuvchi joylashuv ma\'lumotlari yo\'q';

  @override
  String get editProductTitle => 'Mahsulotni tahrirlash';

  @override
  String get imageUploadRequirements =>
      'Kamida bitta rasm kerak. Siz 10 tagacha rasm yuklashingiz mumkin (har biri 5MB dan kichik JPG, PNG, GIF, WebP).';

  @override
  String get productUpdatedSuccess => 'Mahsulot muvaffaqiyatli yangilandi';

  @override
  String get productUpdateFailed => 'Mahsulotni yangilash muvaffaqiyatsiz';

  @override
  String get errorUpdatingProduct => 'Mahsulotni yangilashda xatolik yuz berdi';

  @override
  String get serviceBack => 'Xizmatlarga qaytish';

  @override
  String get likeLabel => 'Yoqtirish';

  @override
  String get commentsLabel => 'Sharhlar';

  @override
  String get writeComment => 'Sharh yozing...';

  @override
  String get postingLabel => 'Joylashtirilmoqda...';

  @override
  String get commentCreated => 'Sharh yaratildi';

  @override
  String get postCommentLabel => 'Sharh joylashtirish';

  @override
  String get loginPrompt =>
      'Sharhlarni ko\'rish va joylashtirish uchun tizimga kiring.';

  @override
  String get recommendedServices => 'Tavsiya etilgan xizmatlar';

  @override
  String get commentsVisibilityNotice =>
      'Sharhlar faqat tizimga kirgan foydalanuvchilarga ko\'rinadi.';

  @override
  String get comingSoon => 'Tez orada';

  @override
  String get serviceUpdateSuccess => 'Xizmat muvaffaqiyatli yangilandi';

  @override
  String get serviceUpdateError => 'Xizmatni yangilashda xatolik';

  @override
  String get editServiceModalTitle => 'Xizmatni tahrirlash';

  @override
  String get enterPhoneNumberWithoutCode => 'Kodsiz telefon raqamini kiriting';

  @override
  String get heroTitle => 'TezSell';

  @override
  String get heroSubtitle => 'O\'zbekiston uchun tez va oson bozoringiz';

  @override
  String get startSelling => 'Sotishni boshlash';

  @override
  String get browseProducts => 'Mahsulotlarni ko\'rish';

  @override
  String get featuresTitle => 'Nega TezSell ni tanlash kerak?';

  @override
  String get listingTitle => 'Oddiy mahsulot ro\'yxati';

  @override
  String get listingDescription =>
      'Mahsulotlaringizni bir necha marta bosish bilan ro\'yxatga oling. Rasmlar qo\'shing, narx belgilang va xaridorlar bilan darhol bog\'laning.';

  @override
  String get locationTitle => 'Joylashuvga asoslangan ko\'rish';

  @override
  String get locationDescription =>
      'Yaqin atrofdagi takliflarni toping. Bizning joylashuvga asoslangan tizimimiz sizga mahallangizda mahsulotlarni topishga yordam beradi.';

  @override
  String get categoryTitle => 'Kategoriyalar bo\'yicha filtrlash';

  @override
  String get categoryDescription =>
      'Aynan qidirayotgan narsangizni topish uchun turli kategoriyalar orasida oson harakat qiling.';

  @override
  String get inspirationTitle => 'Koreya Carrot Market dan ilhomlanib';

  @override
  String get inspirationDescription1 =>
      'Biz TezSell ni Koreyaning muvaffaqiyatli Carrot Market (당근마켓) dan ilhomlanib qurdik, lekin uni O\'zbekistonning mahalliy jamiyatlarining o\'ziga xos ehtiyojlariga moslashtirib oldik.';

  @override
  String get inspirationDescription2 =>
      'Bizning maqsadimiz qo\'shnilar bir-biri bilan oson sotib olish, sotish va muloqot qilishlari mumkin bo\'lgan ishonchli platforma yaratishdir.';

  @override
  String get comingSoonTitle => 'TezSell da tez orada';

  @override
  String get inAppChat => 'Ilova ichidagi chat';

  @override
  String get secureTransactions => 'Xavfsiz tranzaksiyalar';

  @override
  String get realEstateListings => 'Ko\'chmas mulk e\'lonlari';

  @override
  String get stayUpdated => 'Yangiliklar bilan';

  @override
  String get comingSoonBadge => 'Tez orada';

  @override
  String get ctaTitle => 'Bugun TezSell jamoasiga qo\'shiling!';

  @override
  String get ctaDescription =>
      'O\'zbekiston uchun yaxshiroq bozor tajribasi yaratishning bir qismi bo\'ling. Fikr-mulohazalaringizni baham ko\'ring va o\'sishimizga yordam bering!';

  @override
  String get createAccount => 'Hisob yaratish';

  @override
  String get learnMore => 'Ko\'proq o\'rganish';

  @override
  String get replyUpdateSuccess => 'Javob muvaffaqiyatli yangilandi';

  @override
  String get replyUpdateError => 'Javobni yangilashda muvaffaqiyatsizlik';

  @override
  String get replyDeleteSuccess => 'Javob muvaffaqiyatli o\'chirildi';

  @override
  String get replyDeleteError => 'Javobni o\'chirishda muvaffaqiyatsizlik';

  @override
  String get replyDeleteConfirmation => 'Bu javobni o\'chirishni xohlaysizmi?';

  @override
  String get authenticationRequired => 'Autentifikatsiya talab qilinadi';

  @override
  String get enterValidReply => 'Iltimos, to\'g\'ri javob matnini kiriting';

  @override
  String get saving => 'Saqlanmoqda...';

  @override
  String get deleting => 'O\'chirilmoqda...';

  @override
  String get properties => 'Mulklar';

  @override
  String get agents => 'Agentlar';

  @override
  String get becomeAgent => 'Agent bo\'lish';

  @override
  String get main => 'Asosiy';

  @override
  String get upload => 'Yuklash';

  @override
  String get filtered_products => 'Filtrlangan mahsulotlar';

  @override
  String get productDetail => 'Mahsulot tafsilotlari';

  @override
  String get unknownUser => 'Noma\'lum foydalanuvchi';

  @override
  String get locationNotAvailable => 'Joylashuv mavjud emas';

  @override
  String get noTitle => 'Sarlavha yo\'q';

  @override
  String get noCategory => 'Kategoriya yo\'q';

  @override
  String get noDescription => 'Tavsif yo\'q';

  @override
  String get som => 'So\'m';

  @override
  String get about_me => 'Men haqimda';

  @override
  String get my_name => 'Mening ismim';

  @override
  String get customer_support => 'Mijozlarni qo\'llab-quvvatlash';

  @override
  String get customer_center => 'Mijozlar markazi';

  @override
  String get customer_inquiries => 'So\'rovlar';

  @override
  String get customer_terms => 'Foydalanish shartlari';

  @override
  String get region => 'Hudud';

  @override
  String get district => 'Tuman';

  @override
  String get tap_change_profile => 'Rasmni o\'zgartirish uchun bosing';

  @override
  String get language_settings => 'Til sozlamalari';

  @override
  String get selectLanguage => 'Tilni tanlang';

  @override
  String get select_theme => 'Mavzuni tanlang';

  @override
  String get theme => 'Mavzu';

  @override
  String get location_settings => 'Joylashuv sozlamalari';

  @override
  String get security => 'Xavfsizlik';

  @override
  String get data_storage => 'Ma\'lumotlar va saqlash';

  @override
  String get accessibility => 'Foydalanish qulayligi';

  @override
  String get privacy => 'Maxfiylik';

  @override
  String get light_theme => 'Yorqin';

  @override
  String get dark_theme => 'Qorong\'i';

  @override
  String get system_theme => 'Tizim standart';

  @override
  String get my_products => 'Mening mahsulotlarim';

  @override
  String get refresh => 'Yangilash';

  @override
  String get delete_product => 'Mahsulotni o\'chirish';

  @override
  String get delete_confirmation => 'Bu mahsulotni o\'chirishni xohlaysizmi?';

  @override
  String get delete => 'O\'chirish';

  @override
  String error_loading_products(String error) {
    return 'Mahsulotlarni yuklashda xatolik: $error';
  }

  @override
  String get product_deleted_success => 'Mahsulot muvaffaqiyatli o\'chirildi';

  @override
  String error_deleting_product(String error) {
    return 'Mahsulotni o\'chirishda xatolik: $error';
  }

  @override
  String get no_products_found => 'Mahsulotlar topilmadi';

  @override
  String get add_first_product =>
      'Birinchi mahsulotingizni qo\'shishdan boshlang';

  @override
  String get no_title => 'Sarlavha yo\'q';

  @override
  String get no_description => 'Tavsif yo\'q';

  @override
  String get in_stock => 'Mavjud';

  @override
  String get out_of_stock => 'Mavjud emas';

  @override
  String get new_condition => 'YANGI';

  @override
  String get edit_product => 'Mahsulotni tahrirlash';

  @override
  String get delete_product_tooltip => 'Mahsulotni o\'chirish';

  @override
  String get sum_currency => 'So\'m';

  @override
  String get edit_product_title => 'Mahsulotni tahrirlash';

  @override
  String get product_name => 'Mahsulot nomi';

  @override
  String get product_description => 'Mahsulot tavsifi';

  @override
  String get price => 'Narx';

  @override
  String get condition => 'Holat';

  @override
  String get condition_new => 'Yangi';

  @override
  String get condition_used => 'Ishlatilgan';

  @override
  String get condition_refurbished => 'Qayta tiklangan';

  @override
  String get currency => 'Valyuta';

  @override
  String get category => 'Kategoriya';

  @override
  String get images => 'Rasmlar';

  @override
  String get existing_images => 'Mavjud rasmlar';

  @override
  String get new_images => 'Yangi rasmlar';

  @override
  String get image_instructions =>
      'Rasmlar shu yerda paydo bo\'ladi. Yuqoridagi yuklash belgisini bosing.';

  @override
  String get update_button => 'Yangilash';

  @override
  String loading_category_error(String error) {
    return 'Kategoriyalarni yuklashda xatolik: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Rasmlarni tanlashda xatolik: $error';
  }

  @override
  String get please_fill_all_required =>
      'Iltimos, barcha maydonlarni to\'ldiring';

  @override
  String get invalid_price_message =>
      'Noto\'g\'ri narx kiritildi. Iltimos, to\'g\'ri raqam kiriting.';

  @override
  String get category_required_message =>
      'Iltimos, to\'g\'ri kategoriyani tanlang.';

  @override
  String get one_image_required_message => 'Kamida bitta mahsulot rasmi kerak';

  @override
  String get product_updated_success => 'Mahsulot muvaffaqiyatli yangilandi';

  @override
  String error_updating_product(String error) {
    return 'Mahsulotni yangilashda xatolik: $error';
  }

  @override
  String get my_services => 'Mening xizmatlarim';

  @override
  String get delete_service => 'Xizmatni o\'chirish';

  @override
  String get delete_service_confirmation =>
      'Bu xizmatni o\'chirishni xohlaysizmi?';

  @override
  String get no_services_found => 'Xizmatlar topilmadi';

  @override
  String get add_first_service =>
      'Birinchi xizmatingizni qo\'shishdan boshlang';

  @override
  String get edit_service => 'Xizmatni tahrirlash';

  @override
  String get delete_service_tooltip => 'Xizmatni o\'chirish';

  @override
  String get service_deleted_successfully =>
      'Xizmat muvaffaqiyatli o\'chirildi';

  @override
  String get error_deleting_service => 'Xizmatni o\'chirishda xatolik';

  @override
  String get error_loading_services => 'Xizmatlarni yuklashda xatolik';

  @override
  String get service_name => 'Xizmat nomi';

  @override
  String get enter_service_name => 'Xizmat nomini kiriting';

  @override
  String get service_name_required => 'Xizmat nomi majburiy';

  @override
  String get service_name_min_length =>
      'Xizmat nomi kamida 3 ta belgidan iborat bo\'lishi kerak';

  @override
  String get enter_service_description => 'Xizmat tavsifini kiriting';

  @override
  String get service_description_required => 'Xizmat tavsifi majburiy';

  @override
  String get service_description_min_length =>
      'Tavsif kamida 10 ta belgidan iborat bo\'lishi kerak';

  @override
  String get category_required => 'Iltimos, kategoriyani tanlang';

  @override
  String get no_categories_available => 'Kategoriyalar mavjud emas';

  @override
  String get location => 'Joylashuv';

  @override
  String get select_location => 'Joylashuvni tanlang';

  @override
  String get location_required => 'Iltimos, joylashuvni tanlang';

  @override
  String get no_locations_available => 'Joylashuvlar mavjud emas';

  @override
  String get add_images => 'Rasmlar qo\'shish';

  @override
  String get current_images => 'Joriy rasmlar';

  @override
  String get no_images_selected => 'Rasmlar tanlanmagan';

  @override
  String get save_changes => 'O\'zgarishlarni saqlash';

  @override
  String get map_main => 'Xarita va mulklar';

  @override
  String get agent_status => 'Agent holati';

  @override
  String get admin_panel => 'Admin paneli';

  @override
  String get propertiesFound => 'Mulklar topildi';

  @override
  String get propertiesSaved => 'mulklar saqlandi';

  @override
  String get saved => 'saqlandi';

  @override
  String get loadingProperties => 'Mulklar yuklanmoqda...';

  @override
  String get failedToLoad =>
      'Mulklarni yuklashda muvaffaqiyatsizlik. Qayta urinib ko\'ring.';

  @override
  String get noPropertiesFound => 'Mulklar topilmadi';

  @override
  String get tryAdjusting => 'Qidiruv mezonlarini o\'zgartirib ko\'ring';

  @override
  String get search_placeholder => 'Nom yoki joylashuv bo\'yicha qidirish...';

  @override
  String get search_filters => 'Filtrlar';

  @override
  String get search_button => 'Qidirish';

  @override
  String get search_clear_filters => 'Filtrlarni tozalash';

  @override
  String get filter_options_sale_and_rent => 'Sotuv va ijara';

  @override
  String get filter_options_for_sale => 'Sotuvga';

  @override
  String get filter_options_for_rent => 'Ijaraga';

  @override
  String get filter_options_all_types => 'Barcha turlar';

  @override
  String get filter_options_apartment => 'Kvartira';

  @override
  String get filter_options_house => 'Uy';

  @override
  String get filter_options_townhouse => 'Taunhaus';

  @override
  String get filter_options_villa => 'Villa';

  @override
  String get filter_options_commercial => 'Tijorat';

  @override
  String get filter_options_office => 'Ofis';

  @override
  String get property_card_featured => 'Tavsiya etilgan';

  @override
  String get property_card_bed => 'yotoq xona';

  @override
  String get property_card_bath => 'hammom';

  @override
  String get property_card_parking => 'avtoturargoh';

  @override
  String get property_card_view_details => 'Batafsil';

  @override
  String get property_card_contact => 'Aloqa';

  @override
  String get property_card_balcony => 'Balkon';

  @override
  String get property_card_garage => 'Garaj';

  @override
  String get property_card_garden => 'Bog\'';

  @override
  String get property_card_pool => 'Hovuz';

  @override
  String get property_card_elevator => 'Lift';

  @override
  String get property_card_furnished => 'Jihozlangan';

  @override
  String get property_card_sales => 'sotuvlar';

  @override
  String get pricing_month => '/oy';

  @override
  String get results_properties_found => 'Ko\'chmas mulk topildi';

  @override
  String get results_properties_saved => 'ko\'chmas mulk saqlandi';

  @override
  String get results_saved => 'saqlandi';

  @override
  String get results_loading_properties => 'Ko\'chmas mulklar yuklanmoqda...';

  @override
  String get results_failed_to_load =>
      'Ko\'chmas mulkni yuklashda xatolik. Qaytadan urinib ko\'ring.';

  @override
  String get results_no_properties_found => 'Ko\'chmas mulk topilmadi';

  @override
  String get results_try_adjusting =>
      'Qidiruv mezonlarini o\'zgartirib ko\'ring';

  @override
  String get no_properties_found => 'Hech qanday mulk topilmadi';

  @override
  String get no_category_properties => 'Bu kategoriyada mulklar mavjud emas';

  @override
  String get properties_loading => 'Mulklar yuklanmoqda...';

  @override
  String get all_properties_loaded => 'Barcha mulklar yuklandi';

  @override
  String get pagination_previous => 'Oldingi';

  @override
  String get pagination_next => 'Keyingi';

  @override
  String get pagination_page => 'Sahifa';

  @override
  String get pagination_page_of => '1-sahifa';

  @override
  String get contact_modal_title => 'Aloqa ma\'lumotlari';

  @override
  String get contact_modal_agent_contact => 'Agent aloqasi';

  @override
  String get contact_modal_property_owner => 'Mulk egasi';

  @override
  String get contact_modal_agent_phone_number => 'Agent telefon raqami';

  @override
  String get contact_modal_owner_phone_number => 'Egasi telefon raqami';

  @override
  String get contact_modal_license => 'Litsenziya';

  @override
  String get contact_modal_rating => 'Reyting';

  @override
  String get contact_modal_call_now => 'Hozir qo\'ng\'iroq qiling';

  @override
  String get contact_modal_copy_number => 'Raqamni nusxalash';

  @override
  String get contact_modal_close => 'Yopish';

  @override
  String get contact_modal_contact_hours => 'Aloqa vaqti: 9:00 - 20:00';

  @override
  String get contact_modal_agent => 'Agent';

  @override
  String get errors_toggle_save_failed => 'Mulkni saqlashda xatolik:';

  @override
  String get errors_copy_failed => 'Telefon raqamini nusxalashda xatolik:';

  @override
  String get errors_phone_copied => 'Telefon raqami buferga nusxalandi';

  @override
  String get errors_error_occurred_regions => 'Viloyatlarda xatolik yuz berdi';

  @override
  String get errors_error_occurred_districts => 'Tumanlarda xatolik yuz berdi';

  @override
  String get errors_please_fill_all_required_fields =>
      'Iltimos, barcha majburiy maydonlarni to\'ldiring';

  @override
  String get errors_authentication_required =>
      'Autentifikatsiya talab qilinadi';

  @override
  String get errors_user_info_missing =>
      'Foydalanuvchi ma\'lumotlari mavjud emas';

  @override
  String get errors_validation_error =>
      'Iltimos, kiritilgan ma\'lumotlarni tekshiring';

  @override
  String get errors_permission_denied => 'Ruxsat rad etildi';

  @override
  String get errors_server_error => 'Server xatoligi yuz berdi';

  @override
  String get errors_network_error => 'Tarmoq aloqasi xatoligi';

  @override
  String get errors_timeout_error => 'So\'rov vaqti tugadi';

  @override
  String get errors_custom_error => 'Xatolik yuz berdi';

  @override
  String get errors_error_creating_property => 'Mulk yaratishda xatolik';

  @override
  String get errors_unknown_error_message => 'Noma\'lum xatolik yuz berdi';

  @override
  String get errors_coordinates_not_found =>
      'Ushbu manzil uchun koordinatalar topilmadi. Iltimos, qo\'lda kiriting.';

  @override
  String get errors_coordinates_error =>
      'Koordinatalarni olishda xatolik. Iltimos, qo\'lda kiriting.';

  @override
  String get property_info_views => 'ko\'rishlar';

  @override
  String get property_info_listed => 'Joylashtirilgan';

  @override
  String get property_info_price_per_sqm => '/m²';

  @override
  String get property_info_saved => 'Saqlandi';

  @override
  String get property_info_save => 'Saqlash';

  @override
  String get property_info_share => 'Ulashish';

  @override
  String get loading_loading => 'Yuklanmoqda...';

  @override
  String get loading_loading_details => 'Mulk tafsilotlari yuklanmoqda...';

  @override
  String get loading_property_not_found => 'Mulk topilmadi';

  @override
  String get loading_property_not_found_message =>
      'Siz qidirayotgan mulk mavjud emas yoki o\'chirilgan.';

  @override
  String get loading_back_to_properties => 'Mulklarga qaytish';

  @override
  String get loading_title => 'Agentlar yuklanmoqda...';

  @override
  String get loading_message =>
      'Iltimos, agentlar ro\'yxati yuklanguncha kuting.';

  @override
  String get loading_agent_not_found => 'Agent topilmadi';

  @override
  String get property_details_title => 'Mulk tafsilotlari';

  @override
  String get property_details_bedrooms => 'Yotoq xonalar';

  @override
  String get property_details_bathrooms => 'Hammomlar';

  @override
  String get property_details_floor_area => 'Qavat maydoni';

  @override
  String get property_details_parking => 'Avtoturargoh';

  @override
  String get property_details_basic_information => 'Asosiy ma\'lumotlar';

  @override
  String get property_details_property_type => 'Mulk turi:';

  @override
  String get property_details_listing_type => 'E\'lon turi:';

  @override
  String get property_details_for_sale => 'Sotuvga';

  @override
  String get property_details_for_rent => 'Ijaraga';

  @override
  String get property_details_year_built => 'Qurilgan yil:';

  @override
  String get property_details_floor => 'Qavat:';

  @override
  String get property_details_of => 'dan';

  @override
  String get property_details_features_amenities =>
      'Xususiyatlar va qulayliklar';

  @override
  String get sections_description => 'Tavsif';

  @override
  String get sections_nearby_amenities => 'Yaqin atrofdagi qulayliklar';

  @override
  String get sections_similar_properties => 'O\'xshash mulklar';

  @override
  String get amenities_metro => 'Metro';

  @override
  String get amenities_school => 'Maktab';

  @override
  String get amenities_hospital => 'Shifoxona';

  @override
  String get amenities_shopping => 'Do\'konlar';

  @override
  String get amenities_away => 'masofa';

  @override
  String get contact_title => 'Aloqa ma\'lumotlari';

  @override
  String get contact_professional_listing => 'Professional e\'lon';

  @override
  String get contact_listed_by_agent =>
      'Tasdiqlangan agent tomonidan joylashtirilgan';

  @override
  String get contact_by_owner => 'Egasi tomonidan';

  @override
  String get contact_direct_contact =>
      'Mulk egasi bilan to\'g\'ridan-to\'g\'ri aloqa';

  @override
  String get contact_property_owner => 'Mulk egasi';

  @override
  String get contact_call_agent => 'Agentga qo\'ng\'iroq qiling';

  @override
  String get contact_email_agent => 'Agentga email yuboring';

  @override
  String get contact_call_owner => 'Egasiga qo\'ng\'iroq qiling';

  @override
  String get contact_email_owner => 'Egasiga email yuboring';

  @override
  String get contact_send_inquiry => 'So\'rov yuborish';

  @override
  String get property_status_title => 'Mulk holati';

  @override
  String get property_status_availability => 'Mavjudlik:';

  @override
  String get property_status_available => 'Mavjud';

  @override
  String get property_status_not_available => 'Mavjud emas';

  @override
  String get property_status_featured => 'Tavsiya etilgan:';

  @override
  String get property_status_featured_property => 'Tavsiya etilgan mulk';

  @override
  String get property_status_property_id => 'Mulk ID:';

  @override
  String get inquiry_title => 'So\'rov yuborish';

  @override
  String get inquiry_inquiry_type => 'So\'rov turi';

  @override
  String get inquiry_request_info => 'Ma\'lumot so\'rash';

  @override
  String get inquiry_schedule_viewing => 'Ko\'rishni rejalashtirish';

  @override
  String get inquiry_make_offer => 'Taklif berish';

  @override
  String get inquiry_request_callback => 'Qayta qo\'ng\'iroq so\'rash';

  @override
  String get inquiry_message => 'Xabar';

  @override
  String get inquiry_message_placeholder =>
      'Ushbu mulkga qiziqishingiz haqida bizga ayting...';

  @override
  String get inquiry_offered_price => 'Taklif qilingan narx';

  @override
  String get inquiry_enter_offer => 'Taklifingizni kiriting';

  @override
  String get inquiry_preferred_contact_time =>
      'Afzal ko\'rilgan aloqa vaqti (ixtiyoriy)';

  @override
  String get inquiry_contact_time_placeholder =>
      'masalan, Ish kunlari 9:00 - 17:00';

  @override
  String get inquiry_cancel => 'Bekor qilish';

  @override
  String get inquiry_sending => 'Yuborilmoqda...';

  @override
  String get inquiry_send_inquiry => 'So\'rov yuborish';

  @override
  String get inquiry_inquiry_sent_success =>
      'So\'rov muvaffaqiyatli yuborildi!';

  @override
  String get inquiry_inquiry_sent_error =>
      'So\'rovni yuborishda xatolik. Qaytadan urinib ko\'ring.';

  @override
  String get alerts_link_copied => 'Mulk havolasi buferga nusxalandi!';

  @override
  String get alerts_phone_copied => 'Telefon raqami buferga nusxalandi!';

  @override
  String get alerts_save_property_failed => 'Mulkni saqlashda xatolik:';

  @override
  String get alerts_email_subject => 'So\'rov haqida:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Salom,\\n\\nMeni sizning \"$title\" mulkingiz qiziqtirmoqda, $address manzilida joylashgan.\\n\\nIltimos, qo\'shimcha ma\'lumot olish uchun men bilan bog\'laning.\\n\\nEng yaxshi tilaklarim bilan';
  }

  @override
  String get related_properties_view_details => 'Batafsil';

  @override
  String get header_property => 'Orzuingizdagi mulkni toping';

  @override
  String get header_sub_property =>
      'Toshkentning eng mashhur hududlaridagi premium ko\'chmas mulk imkoniyatlarini kashf eting';

  @override
  String get header_title => 'Ko\'chmas mulk agentlari';

  @override
  String get header_subtitle =>
      'Ko\'chmas mulk ehtiyojlaringiz uchun tajribali agentlarni toping';

  @override
  String get header_agents_found => 'agentlar topildi';

  @override
  String get filters_all_specializations => 'Barcha mutaxassisliklar';

  @override
  String get filters_residential => 'Turar joy';

  @override
  String get filters_commercial => 'Tijorat';

  @override
  String get filters_luxury => 'Hashamatli ko\'chmas mulk';

  @override
  String get filters_investment => 'Investitsiya';

  @override
  String get filters_any_rating => 'Har qanday reyting';

  @override
  String get filters_four_stars => '4+ yulduz';

  @override
  String get filters_four_half_stars => '4.5+ yulduz';

  @override
  String get filters_five_stars => '5 yulduz';

  @override
  String get filters_highest_rated => 'Eng yuqori reyting';

  @override
  String get filters_lowest_rated => 'Eng past reyting';

  @override
  String get filters_most_sales => 'Eng ko\'p sotuvlar';

  @override
  String get filters_most_experience => 'Eng ko\'p tajriba';

  @override
  String get agent_card_verified_agent => 'Tasdiqlangan agent';

  @override
  String get agent_card_years_experience => 'yillik tajriba';

  @override
  String get agent_card_years => 'yil';

  @override
  String get agent_card_license => 'Litsenziya';

  @override
  String get agent_card_specialization => 'Mutaxassislik';

  @override
  String get agent_card_view_profile => 'Profilni ko\'rish';

  @override
  String get agent_card_contact => 'Aloqa';

  @override
  String get agent_card_verified => 'Tasdiqlangan';

  @override
  String get no_results_title => 'Agentlar topilmadi';

  @override
  String get no_results_message =>
      'Qidiruv mezonlari yoki filtrlarni o\'zgartirib ko\'ring.';

  @override
  String get error_title => 'Agentlarni yuklashda xatolik';

  @override
  String get error_message =>
      'Agentlar ro\'yxatini yuklashda xatolik. Qaytadan urinib ko\'ring.';

  @override
  String get error_retry => 'Qaytadan urining';

  @override
  String get error_default_message => 'Agent tafsilotlarini yuklashda xatolik';

  @override
  String get error_try_again => 'Qaytadan urinib ko\'ring';

  @override
  String get notifications_phone_copied => 'Telefon raqami buferga nusxalandi';

  @override
  String get notifications_copy_failed =>
      'Telefon raqamini nusxalashda xatolik:';

  @override
  String get fallback_agent_name => 'Agent';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Mulk taqdim etish';

  @override
  String get navigation_submitting => 'Yuborilmoqda...';

  @override
  String get navigation_back_to_agents => 'Agentlarga qaytish';

  @override
  String get agent_profile_verified_agent => 'Tasdiqlangan agent';

  @override
  String get agent_profile_contact_agent => 'Agent bilan bog\'lanish';

  @override
  String get agent_profile_send_message => 'Xabar yuborish';

  @override
  String get agent_profile_years_experience => 'Yillik tajriba';

  @override
  String get agent_profile_properties_sold => 'Sotilgan mulklar';

  @override
  String get agent_profile_active_listings => 'Faol e\'lonlar';

  @override
  String get agent_profile_total_properties => 'Jami mulklar';

  @override
  String get tabs_overview => 'umumiy ko\'rinish';

  @override
  String get tabs_properties => 'mulklar';

  @override
  String get tabs_reviews => 'sharhlar';

  @override
  String get about_agent_title => 'Agent haqida';

  @override
  String get about_agent_agency => 'Agentlik';

  @override
  String get about_agent_license_number => 'Litsenziya raqami';

  @override
  String get about_agent_specialization => 'Mutaxassislik';

  @override
  String get about_agent_member_since => 'A\'zo bo\'lgan vaqtdan beri';

  @override
  String get about_agent_verified_since => 'Tasdiqlangan vaqtdan beri';

  @override
  String get performance_metrics_title => 'Samaradorlik ko\'rsatkichlari';

  @override
  String get performance_metrics_average_rating => 'O\'rtacha reyting';

  @override
  String get performance_metrics_properties_sold => 'Sotilgan mulklar';

  @override
  String get performance_metrics_active_listings => 'Faol e\'lonlar';

  @override
  String get performance_metrics_years_experience => 'Yillik tajriba';

  @override
  String get contact_info_title => 'Aloqa ma\'lumotlari';

  @override
  String get contact_info_contact_via_platform =>
      'Platforma orqali bog\'lanish';

  @override
  String get verification_status_title => 'Tasdiqlash holati';

  @override
  String get verification_status_verified_agent => 'Tasdiqlangan agent';

  @override
  String get verification_status_pending_verification =>
      'Tasdiqlash kutilmoqda';

  @override
  String get verification_status_licensed_professional =>
      'Litsenziyalangan mutaxassis';

  @override
  String get verification_status_registered_agency =>
      'Ro\'yxatdan o\'tgan agentlik';

  @override
  String get quick_actions_title => 'Tezkor harakatlar';

  @override
  String get quick_actions_call_now => 'Hozir qo\'ng\'iroq qiling';

  @override
  String get quick_actions_send_message => 'Xabar yuborish';

  @override
  String get quick_actions_view_properties => 'Mulklarni ko\'rish';

  @override
  String get properties_title => 'Agent mulklari';

  @override
  String get properties_loading_properties => 'Mulklar yuklanmoqda...';

  @override
  String get properties_no_properties_title => 'Mulklar topilmadi';

  @override
  String get properties_no_properties_message =>
      'Ushbu agentning mulklari bu yerda paydo bo\'ladi.';

  @override
  String get properties_recent_properties_note =>
      'So\'nggi mulklar ko\'rsatilgan. Agent barcha mulklari uchun to\'liq ro\'yxatlarni tekshiring.';

  @override
  String get properties_listed => 'Joylashtirilgan';

  @override
  String get properties_bed => 'yotoq xona';

  @override
  String get properties_bath => 'hammom';

  @override
  String get properties_for_sale => 'Sotuvga';

  @override
  String get properties_for_rent => 'Ijaraga';

  @override
  String get reviews_title => 'Mijozlar sharhlari';

  @override
  String get reviews_no_reviews_title => 'Hozircha sharhlar yo\'q';

  @override
  String get reviews_no_reviews_message =>
      'Mijozlar sharhlari va tavsiyalari bu yerda paydo bo\'ladi.';

  @override
  String get fallbacks_agent_name => 'Agent';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => 'Saqlangan mulklar';

  @override
  String get saved_properties_subtitle =>
      'Sizning sevimli mulklaringiz bir joyda';

  @override
  String get saved_properties_no_saved_properties =>
      'Hozircha saqlangan mulklar yo\'q';

  @override
  String get saved_properties_start_saving =>
      'O\'rganishni boshlang va yoqtirgan mulklaringizni saqlang';

  @override
  String get saved_properties_browse_properties => 'Mulklarni ko\'rish';

  @override
  String get saved_properties_saved_on => 'Saqlangan';

  @override
  String get auth_login_required =>
      'Saqlangan mulklarni ko\'rish uchun tizimga kiring';

  @override
  String get auth_login => 'Kirish';

  @override
  String get success_property_unsaved =>
      'Mulk saqlangan ro\'yxatdan o\'chirildi';

  @override
  String get success_property_saved => 'Mulk muvaffaqiyatli saqlandi';

  @override
  String get success_phone_copied => 'Telefon raqami nusxalandi!';

  @override
  String get success_property_created_success =>
      'Mulk muvaffaqiyatli yaratildi!';

  @override
  String get success_agent_approved => 'Agent muvaffaqiyatli tasdiqlandi';

  @override
  String get success_agent_rejected => 'Agent muvaffaqiyatli rad etildi';

  @override
  String get steps_step => 'Qadam';

  @override
  String get steps_basic_information => 'Asosiy ma\'lumotlar';

  @override
  String get steps_location_details => 'Joylashuv tafsilotlari';

  @override
  String get steps_property_details => 'Mulk tafsilotlari';

  @override
  String get steps_property_images => 'Mulk rasmlari';

  @override
  String get basic_info_tell_us_about_property =>
      'Mulkingiz haqida bizga ayting';

  @override
  String get basic_info_property_type => 'Mulk turi';

  @override
  String get basic_info_listing_type => 'E\'lon turi';

  @override
  String get basic_info_property_title => 'Mulk nomi';

  @override
  String get basic_info_title_placeholder =>
      'Mulkingiz uchun tavsifiy nom kiriting';

  @override
  String get basic_info_description => 'Tavsif';

  @override
  String get basic_info_description_placeholder =>
      'Mulkingizni batafsil tavsiflang...';

  @override
  String get property_types_apartment => 'Kvartira';

  @override
  String get property_types_house => 'Uy';

  @override
  String get property_types_townhouse => 'Taunhaus';

  @override
  String get property_types_villa => 'Villa';

  @override
  String get property_types_commercial => 'Tijorat';

  @override
  String get property_types_office => 'Ofis';

  @override
  String get property_types_land => 'Yer';

  @override
  String get property_types_warehouse => 'Ombor';

  @override
  String get listing_types_for_sale => 'Sotuvga';

  @override
  String get listing_types_for_rent => 'Ijaraga';

  @override
  String get location_where_is_property => 'Mulkingiz qayerda joylashgan?';

  @override
  String get location_full_address => 'To\'liq manzil';

  @override
  String get location_address_placeholder => 'To\'liq manzilni kiriting';

  @override
  String get location_region => 'Viloyat';

  @override
  String get location_select_region => 'Viloyatni tanlang';

  @override
  String get location_district => 'Tuman';

  @override
  String get location_select_district => 'Tumanni tanlang';

  @override
  String get location_city => 'Shahar';

  @override
  String get location_city_placeholder => 'Shahar';

  @override
  String get location_loading_regions => 'Viloyatlar yuklanmoqda...';

  @override
  String get location_loading_districts => 'Tumanlar yuklanmoqda...';

  @override
  String get location_map_coordinates => 'Xarita koordinatalari';

  @override
  String get location_get_coordinates => 'Koordinatalarni olish';

  @override
  String get location_latitude => 'Kenglik';

  @override
  String get location_longitude => 'Uzunlik';

  @override
  String get location_coordinates_set => 'Koordinatalar o\'rnatildi';

  @override
  String get location_location_tips => 'Joylashuv bo\'yicha maslahatlar';

  @override
  String get location_location_tip_1 =>
      '• Avval manzilni to\'ldiring, keyin xaritada joylashuvni avtomatik olish uchun \"Koordinatalarni olish\"ni bosing';

  @override
  String get location_location_tip_2 =>
      '• Agar aniq joylashuvni bilsangiz, koordinatalarni qo\'lda ham kirita olasiz';

  @override
  String get location_location_tip_3 =>
      '• Aniq koordinatalar xaridorlarga mulkingizni xaritada topishda yordam beradi';

  @override
  String get property_details_provide_detailed_info =>
      'Mulk haqida batafsil ma\'lumot bering';

  @override
  String get property_details_total_floors => 'Jami qavatlar';

  @override
  String get property_details_area_m2 => 'Maydon (m²)';

  @override
  String get property_details_parking_spaces => 'Avtomobil turash joylari';

  @override
  String get property_details_price => 'Narx';

  @override
  String get property_details_features => 'Xususiyatlar';

  @override
  String get images_add_photos_showcase =>
      'Mulkingizni ko\'rsatish uchun rasmlar qo\'shing';

  @override
  String get images_click_to_upload => 'Rasmlarni yuklash uchun bosing';

  @override
  String get images_max_images_info =>
      'Maksimal 10 ta rasm, JPG, PNG yoki WEBP';

  @override
  String get images_main => 'Asosiy';

  @override
  String get images_maximum_images_allowed =>
      'Maksimal 10 ta rasm ruxsat etilgan';

  @override
  String get admin_dashboard_title => 'Administrator paneli';

  @override
  String get admin_dashboard_subtitle =>
      'Ko\'chmas mulk platformangizning real vaqt sharhi';

  @override
  String get admin_last_update => 'So\'nggi yangilanish';

  @override
  String get admin_total_properties => 'Jami mulklar';

  @override
  String get admin_total_agents => 'Jami agentlar';

  @override
  String get admin_total_users => 'Jami foydalanuvchilar';

  @override
  String get admin_total_views => 'Jami ko\'rishlar';

  @override
  String get admin_error_loading_dashboard => 'Panelni yuklashda xatolik';

  @override
  String get admin_failed_to_load_data =>
      'Panel ma\'lumotlarini yuklashda xatolik';

  @override
  String get admin_avg_sale_price => 'O\'rtacha sotuv narxi';

  @override
  String get admin_avg_sale_price_subtitle => 'Barcha faol obyektlar';

  @override
  String get admin_total_portfolio_value => 'Jami portfel qiymati';

  @override
  String get admin_total_portfolio_value_subtitle =>
      'Mulklarning umumiy qiymati';

  @override
  String get admin_avg_price_per_sqm => 'Kvadrat metr uchun o\'rtacha narx';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Bozor stavkasi ko\'rsatkichi';

  @override
  String get admin_property_types_distribution => 'Mulk turlari taqsimoti';

  @override
  String get admin_properties_by_city => 'Shaharlar bo\'yicha mulklar';

  @override
  String get admin_properties_by_district => 'Tumanlar bo\'yicha mulklar';

  @override
  String get admin_inquiry_types_distribution => 'So\'rov turlari taqsimoti';

  @override
  String get admin_agent_verification_rate => 'Agentlarni tasdiqlash darajasi';

  @override
  String get admin_agent_verification_rate_subtitle => 'Sifat nazorati';

  @override
  String get admin_inquiry_response_rate =>
      'So\'rovlarga javob berish darajasi';

  @override
  String get admin_inquiry_response_rate_subtitle =>
      'Mijozlarga xizmat ko\'rsatish';

  @override
  String get admin_avg_views_per_property =>
      'Har bir mulk uchun o\'rtacha ko\'rishlar';

  @override
  String get admin_avg_views_per_property_subtitle => 'Mulk mashhurligi';

  @override
  String get admin_featured_properties => 'Tavsiya etilgan mulklar';

  @override
  String get admin_featured_properties_subtitle => 'Premium e\'lonlar';

  @override
  String get admin_most_viewed_properties => 'Eng ko\'p ko\'rilgan mulklar';

  @override
  String get admin_top_performing_agents => 'Eng yaxshi agentlar';

  @override
  String get admin_system_health => 'Tizim holati';

  @override
  String get admin_properties_without_images => 'Rasmsiz mulklar';

  @override
  String get admin_missing_location_data => 'Joylashuv ma\'lumotlari yo\'q';

  @override
  String get admin_pending_agent_verification =>
      'Tasdiqlash kutilayotgan agentlar';

  @override
  String get admin_active => 'faol';

  @override
  String get admin_verified => 'tasdiqlangan';

  @override
  String get admin_active_7d => 'faol (7k)';

  @override
  String get admin_this_month => 'bu oy';

  @override
  String get agents_loading_pending_applications =>
      'Kutilayotgan arizalar yuklanmoqda...';

  @override
  String get agents_error_loading_applications =>
      'Arizalarni yuklashda xatolik';

  @override
  String get agents_pending_agents => 'Kutilayotgan agentlar';

  @override
  String get agents_total_pending_applications =>
      'Jami kutilayotgan arizalar: ';

  @override
  String get agents_pending_verification => 'Tasdiqlash kutilmoqda';

  @override
  String get agents_applied_date => 'Topshirilgan: ';

  @override
  String get agents_contact_info => 'Aloqa ma\'lumotlari';

  @override
  String get agents_license_number => 'Litsenziya raqami';

  @override
  String get agents_years_experience => 'Yillik tajriba';

  @override
  String get agents_years_suffix => ' yil';

  @override
  String get agents_total_sales => 'Jami sotuvlar';

  @override
  String get agents_specialization => 'Mutaxassislik';

  @override
  String get agents_approve => 'Tasdiqlash';

  @override
  String get agents_reject => 'Rad etish';

  @override
  String get agents_no_pending_applications => 'Kutilayotgan arizalar yo\'q';

  @override
  String get agents_all_applications_processed =>
      'Barcha agent arizalari ko\'rib chiqildi';

  @override
  String get general_previous => 'Oldingi';

  @override
  String get general_page => 'Sahifa ';

  @override
  String get general_next => 'Keyingi';

  @override
  String get general_views => 'ko\'rishlar';

  @override
  String get general_sales => 'sotuvlar';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'Русский';

  @override
  String get general_language_en => 'English';

  @override
  String get general_super_admin => 'Super administrator';

  @override
  String get general_staff => 'Xodim';

  @override
  String get general_verified_agent => 'Tasdiqlangan agent';

  @override
  String get general_pending_agent => 'Kutilayotgan agent';

  @override
  String get general_regular_user => 'Foydalanuvchi';

  @override
  String get general_admin => 'Administrator';

  @override
  String get general_dashboard => 'Panel';

  @override
  String get general_manage_users => 'Foydalanuvchilarni boshqarish';

  @override
  String get general_verified_agents => 'Tasdiqlangan agentlar';

  @override
  String get general_agent_panel => 'Agent paneli';

  @override
  String get general_create_property => 'Mulk yaratish';

  @override
  String get general_my_properties => 'Mening mulklarim';

  @override
  String get general_inquiries => 'So\'rovlar';

  @override
  String get general_agent_profile => 'Agent profili';

  @override
  String get general_live => 'Onlayn';

  @override
  String get general_logged_out_successfully => 'Muvaffaqiyatli chiqish';

  @override
  String get general_logout_completed_with_errors =>
      'Chiqish bajarildi (xatolar bilan)';

  @override
  String get general_application_under_review => 'Ariza ko\'rib chiqilmoqda';

  @override
  String get general_check_status => 'Holatni tekshirish →';

  @override
  String get general_last_updated => 'So\'nggi yangilanish:';

  @override
  String get general_permissions_may_be_outdated =>
      'Ruxsatlar eskirgan bo\'lishi mumkin';

  @override
  String get general_permissions_up_to_date => 'Ruxsatlar dolzarb';

  @override
  String get general_never => 'Hech qachon';

  @override
  String get general_properties_found => 'Obyektlar topildi';

  @override
  String get general_properties_saved => 'obyektlar saqlandi';

  @override
  String get general_saved => 'saqlandi';

  @override
  String get general_loading_properties => 'Obyektlar yuklanmoqda...';

  @override
  String get general_failed_to_load =>
      'Obyektlarni yuklashda xatolik. Qaytadan urinib ko\'ring.';

  @override
  String get general_no_properties_found => 'Obyektlar topilmadi';

  @override
  String get general_try_adjusting =>
      'Qidiruv mezonlarini o\'zgartirib ko\'ring';

  @override
  String get select_category => 'Kategoriya tanlang';

  @override
  String get service_description => 'Xizmat tavsifi';

  @override
  String get product_search_placeholder =>
      'Mahsulotlarni topish uchun qidiruv so‘zini kiriting';

  @override
  String get privacy_policy => 'Maxfiylik siyosati';

  @override
  String get terms_subtitle => 'Maxfiylik va shartlar';

  @override
  String get last_updated => 'Oxirgi yangilanish';

  @override
  String get contact_information => 'Aloqa ma\'lumotlari';

  @override
  String get accept_terms => 'Foydalanish shartlarini qabul qilaman';

  @override
  String get read_terms => 'Iltimos, shartlarimizni o\'qing';

  @override
  String get inquiries => 'Savollar va yordam';

  @override
  String get inquiries_subtitle => 'Biz bilan bog\'laning';

  @override
  String get help_center => 'Sizga qanday yordam beramiz?';

  @override
  String get help_subtitle =>
      'Har qanday savollaringizga javob berishga tayyormiz';

  @override
  String get contact_us => 'Biz bilan bog\'laning';

  @override
  String get email_support => 'Email orqali yordam';

  @override
  String get call_support => 'Qo\'ng\'iroq qiling';

  @override
  String get send_message => 'Xabar yuborish';

  @override
  String get fill_contact_form => 'Formani to\'ldiring';

  @override
  String get contact_form => 'Aloqa formasi';

  @override
  String get name => 'Ismingiz';

  @override
  String get name_required => 'Iltimos, ismingizni kiriting';

  @override
  String get email => 'Email manzil';

  @override
  String get email_required => 'Iltimos, emailni kiriting';

  @override
  String get email_invalid => 'To\'g\'ri email kiriting';

  @override
  String get subject => 'Mavzu';

  @override
  String get subject_required => 'Iltimos, mavzuni kiriting';

  @override
  String get message => 'Xabaringiz';

  @override
  String get message_required => 'Iltimos, xabar kiriting';

  @override
  String get message_too_short =>
      'Xabar kamida 10 belgidan iborat bo\'lishi kerak';

  @override
  String get faq => 'Ko\'p beriladigan savollar';

  @override
  String get follow_us => 'Bizni kuzatib boring';

  @override
  String get faq_how_to_sell => 'Tezsell\'da mahsulot qanday sotiladi?';

  @override
  String get faq_how_to_sell_answer =>
      'Mahsulot sotish uchun: 1) Hisob yarating, 2) \'+\' tugmasini bosing, 3) Kategoriyani tanlang (Mahsulotlar/Xizmatlar/Ko\'chmas mulk), 4) Rasm va tavsif qo\'shing, 5) Narxni belgilang, 6) Nashr qiling! E\'loningiz sizning hududingizdagi xaridorlarga ko\'rinadi.';

  @override
  String get faq_is_free => 'Tezsell bepulmi?';

  @override
  String get faq_is_free_answer =>
      'Ha! Tezsell hozirda 100% bepul. E\'lon joylashtirish uchun to\'lov yo\'q, sotishdan komissiya yo\'q, obuna to\'lovi yo\'q. Kelajakda premium xususiyatlar kiritishimiz mumkin, ammo foydalanuvchilarni 30 kun oldin xabardor qilamiz.';

  @override
  String get faq_safety => 'Xarid/sotishda xavfsiz qanday bo\'lish mumkin?';

  @override
  String get faq_safety_answer =>
      'Xavfsizlik maslahatlari: 1) Jamoat joylarida uchrashing, 2) To\'lashdan oldin mahsulotni tekshiring, 3) Notanish odamlarga pul yubormang, 4) Sezgilaringizga ishoning, 5) Shubhali foydalanuvchilar haqida xabar bering, 6) Shaxsiy ma\'lumotlarni erta bo\'lishmang, 7) Qimmat bitimlar uchun do\'st olib boring.';

  @override
  String get faq_payment => 'To\'lovlar qanday ishlaydi?';

  @override
  String get faq_payment_answer =>
      'Tezsell to\'lovlarni qayta ishlamaydi. Xaridorlar va sotuvchilar to\'lovni to\'g\'ridan-to\'g\'ri kelishadilar (naqd, bank o\'tkazmasi va h.k.). Biz faqat odamlarni bog\'lovchi platformamiz - bitimni o\'zingiz amalga oshirasiz.';

  @override
  String get faq_prohibited => 'Qanday mahsulotlar taqiqlangan?';

  @override
  String get faq_prohibited_answer =>
      'Taqiqlangan mahsulotlar: qurol, giyohvand moddalar, o\'g\'irlangan mol-mulk, qalbaki mahsulotlar, kattalar uchun kontent, tirik hayvonlar (ruxsatsiz), davlat guvohnomalari, xavfli materiallar. To\'liq ro\'yxat Foydalanish shartlarida.';

  @override
  String get faq_account_delete => 'Hisobni qanday o\'chirish mumkin?';

  @override
  String get faq_account_delete_answer =>
      'Profil → Sozlamalar → Hisob sozlamalari → Hisobni o\'chirish. Diqqat: bu qaytarilmas. Barcha e\'lonlaringiz o\'chiriladi.';

  @override
  String get faq_report_user =>
      'Foydalanuvchi yoki e\'lon haqida qanday shikoyat qilish mumkin?';

  @override
  String get faq_report_user_answer =>
      'Har qanday e\'lon yoki foydalanuvchi profilida uch nuqtani (•••) bosing, so\'ng \'Shikoyat\' tanlang. Sababni tanlang va yuboring. Biz barcha shikoyatlarni 24-48 soat ichida ko\'rib chiqamiz.';

  @override
  String get faq_change_location => 'Joylashuvni qanday o\'zgartirish mumkin?';

  @override
  String get faq_change_location_answer =>
      'Bosh ekranning yuqori chap burchagidagi joylashuv tugmasini bosing. Siz hududingizdagi e\'lonlarni ko\'rish uchun viloyat va tumanni tanlashingiz mumkin.';

  @override
  String get welcome_customer_center => 'Mijozlar markaziga xush kelibsiz';

  @override
  String get customer_center_subtitle => 'Biz sizga 24/7 yordam beramiz';

  @override
  String get quick_actions => 'Tez harakatlar';

  @override
  String get live_chat => 'Jonli chat';

  @override
  String get chat_with_us => 'Biz bilan yozing';

  @override
  String get find_answers => 'Javoblarni toping';

  @override
  String get my_tickets => 'Murojaatlarim';

  @override
  String get view_tickets => 'Murojaatlarni ko\'rish';

  @override
  String get feedback => 'Fikr-mulohaza';

  @override
  String get share_feedback => 'Fikr bildirish';

  @override
  String get contact_methods => 'Aloqa usullari';

  @override
  String get phone_support => 'Telefon qo\'llab-quvvatlash';

  @override
  String get available_247 => '24/7 mavjud';

  @override
  String get response_24h => '24 soat ichida javob';

  @override
  String get telegram_support => 'Telegram qo\'llab-quvvatlash';

  @override
  String get instant_replies => 'Tezkor javoblar';

  @override
  String get whatsapp_support => 'WhatsApp qo\'llab-quvvatlash';

  @override
  String get quick_response => 'Tez javob';

  @override
  String get popular_topics => 'Mashhur mavzular';

  @override
  String get account_management => 'Hisob boshqaruvi';

  @override
  String get reset_password => 'Parolni tiklash';

  @override
  String get update_profile => 'Profilni yangilash';

  @override
  String get verify_account => 'Hisobni tasdiqlash';

  @override
  String get delete_account => 'Hisobni o\'chirish';

  @override
  String get buying_selling => 'Sotib olish va sotish';

  @override
  String get how_to_post => 'E\'lon qanday joylashtirish';

  @override
  String get payment_methods => 'To\'lov usullari';

  @override
  String get shipping_delivery => 'Yetkazib berish';

  @override
  String get return_policy => 'Qaytarish siyosati';

  @override
  String get safety_security => 'Xavfsizlik';

  @override
  String get report_scam => 'Firibgarlik haqida xabar berish';

  @override
  String get safe_trading => 'Xavfsiz savdo maslahatlari';

  @override
  String get privacy_settings => 'Maxfiylik sozlamalari';

  @override
  String get blocked_users => 'Bloklangan foydalanuvchilar';

  @override
  String get technical_issues => 'Texnik muammolar';

  @override
  String get app_not_working => 'Ilova ishlamayapti';

  @override
  String get upload_failed => 'Yuklash xatosi';

  @override
  String get login_problems => 'Kirish muammolari';

  @override
  String get support_hours => 'Qo\'llab-quvvatlash soatlari';

  @override
  String get mon_fri_9_6 => 'Dush-Juma: 9:00 - 18:00';

  @override
  String get how_are_we_doing => 'Bizning xizmatimiz qanday?';

  @override
  String get rate_experience => 'Xizmat sifatini baholang';

  @override
  String get poor => 'Yomon';

  @override
  String get okay => 'Yaxshi';

  @override
  String get good => 'Juda yaxshi';

  @override
  String get excellent => 'A\'lo';

  @override
  String get account_secure => 'Hisobingiz himoyalangan';

  @override
  String get password_security => 'Parol va autentifikatsiya';

  @override
  String get change_password => 'Parolni o\'zgartirish';

  @override
  String get two_factor_auth => 'Ikki faktorli autentifikatsiya';

  @override
  String get biometric_login => 'Biometrik kirish';

  @override
  String get login_activity => 'Kirish faolligi';

  @override
  String get active_sessions => 'Faol seanslar';

  @override
  String get login_alerts => 'Kirish haqida bildirishnomalar';

  @override
  String get account_protection => 'Hisob himoyasi';

  @override
  String get recovery_email => 'Tiklash uchun email';

  @override
  String get backup_codes => 'Zaxira kodlar';

  @override
  String get danger_zone => 'Xavfli zona';

  @override
  String get improve_security => 'Xavfsizlikni oshirish';

  @override
  String get security_score => 'Xavfsizlik darajasi';

  @override
  String get last_changed_days => '30 kun oldin o\'zgartirilgan';

  @override
  String get logout_all_devices => 'Barcha qurilmalardan chiqish';

  @override
  String get end_all_sessions => 'Barcha seanslarni tugatish';

  @override
  String get permanently_delete => 'Butunlay o\'chirish';

  @override
  String get verification_code_message =>
      'Siz ekanligingizni tasdiqlash uchun tasdiqlash kodini yuboramiz.';

  @override
  String get send_code => 'Kod yuborish';

  @override
  String get enter_verification_code => 'Tasdiqlash kodini kiriting';

  @override
  String get verification_code => 'Tasdiqlash kodi';

  @override
  String get new_password => 'Yangi parol';

  @override
  String get confirm_password => 'Parolni tasdiqlang';

  @override
  String get resend_code => 'Qayta yuborish';

  @override
  String get code_sent_to => 'Tasdiqlash kodini kiriting, yuborildi';

  @override
  String get enter_code => 'Tasdiqlash kodini kiriting';

  @override
  String get code_must_be_6_digits =>
      'Kod 6 ta raqamdan iborat bo\'lishi kerak';

  @override
  String get enter_new_password => 'Yangi parolni kiriting';

  @override
  String get minimum_8_characters => 'Kamida 8 ta belgi';

  @override
  String get passwords_do_not_match => 'Parollar mos kelmaydi';

  @override
  String get close => 'Yopish';

  @override
  String get current => 'Joriy';

  @override
  String get session_ended => 'Seans tugatildi';

  @override
  String get update_recovery_email => 'Qayta tiklash pochtasini yangilash';

  @override
  String get new_email => 'Yangi pochta';

  @override
  String get update => 'Yangilash';

  @override
  String get verification_email_sent => 'Tasdiqlash xati yuborildi';

  @override
  String get generate_emergency_codes => 'Favqulodda kodlar yaratish';

  @override
  String get copy_all => 'Hammasini nusxalash';

  @override
  String get code_copied => 'Kod nusxalandi';

  @override
  String get all_codes_copied => 'Barcha kodlar nusxalandi';

  @override
  String get logout_all_devices_confirm => 'Barcha qurilmalardan chiqasizmi?';

  @override
  String get logout_all_devices_message =>
      'Bu barcha qurilmalardagi faol seanslarni tugatadi.';

  @override
  String get logout_all => 'Barchasidan chiqish';

  @override
  String get delete_account_confirm => 'Hisobni o\'chirasizmi?';

  @override
  String get delete_account_warning =>
      'Bu harakat QAYTARILMAS. Barcha ma\'lumotlaringiz butunlay o\'chiriladi.';

  @override
  String get what_will_be_deleted => 'Nima o\'chiriladi:';

  @override
  String get profile_and_account_info => '• Profilingiz va hisob ma\'lumotlari';

  @override
  String get all_listings_and_posts => '• Barcha e\'lonlar va xabarlaringiz';

  @override
  String get messages_and_conversations => '• Xabarlar va suhbatlaringiz';

  @override
  String get saved_items_and_preferences =>
      '• Saqlangan elementlar va sozlamalar';

  @override
  String get enter_password_to_continue =>
      'Davom ettirish uchun parolni kiriting';

  @override
  String get continue_val => 'Davom etish';

  @override
  String get please_enter_password => 'Iltimos, parolingizni kiriting';

  @override
  String get enter_confirmation_code => 'Tasdiqlash kodini kiriting';

  @override
  String get deletion_confirmation_message =>
      'Biz telefoningizga tasdiqlash kodini yubordik. Hisobni butunlay o\'chirish uchun uni quyida kiriting.';

  @override
  String get confirmation_code => 'Tasdiqlash kodi';

  @override
  String get please_enter_6_digit_code => 'Iltimos, 6 raqamli kodni kiriting';

  @override
  String get account_deleted => 'Hisobingiz o\'chirildi';

  @override
  String get deletion_cancelled => 'O\'chirish bekor qilindi';

  @override
  String get failed_to_load_user_info =>
      'Foydalanuvchi ma\'lumotlarini yuklab bo\'lmadi';

  @override
  String get auth_login_to_view_saved =>
      'Saqlangan ko\'chmas mulklarni ko\'rish uchun tizimga kiring';

  @override
  String get authLoginRequired => 'Tizimga kirish talab qilinadi';

  @override
  String get authLoginToViewSaved =>
      'Saqlangan ko\'chmas mulklarni ko\'rish uchun tizimga kiring';

  @override
  String get authLogin => 'Kirish';

  @override
  String get savedPropertiesTitle => 'Saqlangan Ko\'chmas Mulklar';

  @override
  String get loadingSavedProperties =>
      'Saqlangan ko\'chmas mulklar yuklanmoqda...';

  @override
  String get errorsFailedToLoadSaved =>
      'Saqlangan ko\'chmas mulklarni yuklashda xatolik';

  @override
  String get actionsRetry => 'Qayta urinish';

  @override
  String get savedPropertiesNoSaved => 'Saqlangan Ko\'chmas Mulklar Yo\'q';

  @override
  String get savedPropertiesStartSaving =>
      'Ko\'chmas mulklarni ko\'rib chiqing va yoqtirganlaringizni saqlang';

  @override
  String get savedPropertiesBrowse => 'Ko\'chmas Mulklarni Ko\'rish';

  @override
  String get resultsSavedProperties => 'saqlangan ko\'chmas mulklar';

  @override
  String get actionsRefresh => 'Yangilash';

  @override
  String get resultsNoMoreProperties => 'Boshqa ko\'chmas mulklar yo\'q';

  @override
  String get propertyCardFeatured => 'Tavsiya etilgan';

  @override
  String get successPropertyUnsaved =>
      'Ko\'chmas mulk saqlanganlar ro\'yxatidan o\'chirildi';

  @override
  String get alertsUnsavePropertyFailed =>
      'Ko\'chmas mulkni o\'chirishda xatolik';

  @override
  String get propertyCardBed => 'yotoq xona';

  @override
  String get propertyCardBath => 'hammom';

  @override
  String get savedPropertiesSavedOn => 'Saqlangan sana';

  @override
  String get propertyCardViewDetails => 'Batafsil Ko\'rish';

  @override
  String get serviceDetailTitle => 'Xizmat tafsilotlari';

  @override
  String get errorLoadingFavorites => 'Sevimlilar yuklanishida xatolik';

  @override
  String get noFavoritesFound => 'Sevimli elementlar topilmadi.';

  @override
  String get commentUpdatedSuccess => 'Izoh muvaffaqiyatli yangilandi!';

  @override
  String get errorUpdatingComment => 'Izohni yangilashda xatolik';

  @override
  String get replyAddedSuccess => 'Javob muvaffaqiyatli qo\'shildi!';

  @override
  String get errorAddingReply => 'Javob qo\'shishda xatolik';

  @override
  String get commentDeletedSuccess => 'Izoh muvaffaqiyatli o\'chirildi!';

  @override
  String get errorDeletingComment => 'Izohni o\'chirishda xatolik';

  @override
  String get serviceLikedSuccess => 'Xizmat sevimlilarga qo\'shildi!';

  @override
  String get errorLikingService => 'Sevimliga qo\'shishda xatolik';

  @override
  String get serviceDislikedSuccess => 'Xizmat sevimlilardan o\'chirildi!';

  @override
  String get errorDislikingService => 'Sevimlilardan o\'chirishda xatolik';

  @override
  String get replyingTo => 'Javob berish';

  @override
  String get writeYourReply => 'Javobingizni yozing...';

  @override
  String get postReply => 'Javobni yuborish';

  @override
  String get anonymous => 'Anonim';

  @override
  String get editComment => 'Izohni tahrirlash';

  @override
  String get editYourComment => 'Izohingizni tahrirlang...';

  @override
  String get saveChanges => 'O\'zgarishlarni saqlash';

  @override
  String get propertyOwner => 'Egasi';

  @override
  String get errorLoadingServices => 'Xizmatlar yuklanishida xatolik';

  @override
  String get noRecommendedServicesFound =>
      'Tavsiya etilgan xizmatlar topilmadi.';

  @override
  String get passwordRequired => 'Parol kiritish majburiy';

  @override
  String get passwordTooShort =>
      'Parol kamida 8 belgidan iborat bo\'lishi kerak';

  @override
  String get passwordRequirements =>
      'Parol harf va raqamdan iborat bo\'lishi kerak';

  @override
  String get usernameRequired => 'Foydalanuvchi ismi majburiy';

  @override
  String get usernameTooShort =>
      'Foydalanuvchi ismi kamida 3 belgidan iborat bo\'lishi kerak';

  @override
  String get confirmPasswordRequired => 'Parolni tasdiqlash majburiy';

  @override
  String get passwordHelp => 'Kamida 8 belgi, harf va raqam';

  @override
  String get usernameExists => 'Bu foydalanuvchi ismi allaqachon mavjud';

  @override
  String get phoneExists => 'Bu telefon raqami allaqachon ro\'yxatdan o\'tgan';

  @override
  String get networkError =>
      'Internetga ulanishda xatolik. Iltimos, ulanishni tekshiring';

  @override
  String get contactSeller => 'Sotuvchi bilan bog\'lanish';

  @override
  String get callToReveal => 'Ko\'rish uchun \"Qo\'ng\'iroq\" bosing';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galereya';

  @override
  String get selectImageSource => 'Rasm manbasini tanlang';

  @override
  String get uploading => 'Yuklanmoqda...';

  @override
  String get acceptTermsRequired =>
      'Davom etish uchun Foydalanish shartlarini qabul qilishingiz kerak';

  @override
  String get iAgreeToTerms => 'Men ';

  @override
  String get termsAndConditions => 'Foydalanish shartlari';

  @override
  String get zeroToleranceStatement =>
      ' bilan tanishdim va noqonuniy kontent yoki haqoratli foydalanuvchilarga nol bardosh ekanligini tushunaman.';

  @override
  String get viewTerms => 'Foydalanish shartlarini ko\'rish';

  @override
  String get reportContent => 'Kontent haqida xabar berish';

  @override
  String get selectReportReason => 'Iltimos, xabar berish sababini tanlang:';

  @override
  String get additionalDetails => 'Qo\'shimcha ma\'lumotlar (ixtiyoriy)';

  @override
  String get reportDetailsHint => 'Qo\'shimcha ma\'lumot bering...';

  @override
  String get reportSubmitted =>
      'Xabaringiz uchun rahmat. Biz uni 24 soat ichida ko\'rib chiqamiz.';

  @override
  String get reportProduct => 'Mahsulot haqida xabar berish';

  @override
  String get reportService => 'Xizmat haqida xabar berish';

  @override
  String get reportMessage => 'Xabar haqida xabar berish';

  @override
  String get reportUser => 'Foydalanuvchi haqida xabar berish';

  @override
  String get reportErrorNotImplemented =>
      'Xabar berish funksiyasi hali mavjud emas. Iltimos, qo\'llab-quvvatlash bilan bog\'laning yoki keyinroq qayta urinib ko\'ring.';

  @override
  String get reportAlreadySubmitted =>
      'Siz bu kontent haqida allaqachon xabar bergansiz. Biz oldingi xabaringizni ko\'rib chiqmoqdamiz.';

  @override
  String get reportFailedGeneric =>
      'Xabar yuborib bo\'lmadi. Iltimos, qayta urinib ko\'ring.';

  @override
  String get reportFailedNetwork =>
      'Tarmoq xatosi yuz berdi. Iltimos, ulanishni tekshiring va qayta urinib ko\'ring.';

  @override
  String get becomeAgentTitle => 'Ko\'chmas mulk agenti bo\'lish';

  @override
  String get becomeAgentSubtitle =>
      'Mulk ro\'yxatga oling va mijozlarga orzu qilgan uylarini topishda yordam bering';

  @override
  String get agentBenefits => 'Afzalliklar:';

  @override
  String get agentBenefitVerified => 'Tasdiqlangan agent nishoni';

  @override
  String get agentBenefitAnalytics => 'Analitika va statistikaga kirish';

  @override
  String get agentBenefitClients =>
      'Potentsial mijozlar bilan to\'g\'ridan-to\'g\'ri aloqa';

  @override
  String get agentBenefitReputation => 'Professional obro\'ingizni yarating';

  @override
  String get agentApplicationForm => 'Ariza formasi';

  @override
  String get agentAgencyName => 'Agentlik nomi';

  @override
  String get agentAgencyNameHint =>
      'Ko\'chmas mulk agentligingiz nomini kiriting';

  @override
  String get agentAgencyNameRequired => 'Agentlik nomi majburiy';

  @override
  String get agentLicenceNumber => 'Litsenziya raqami';

  @override
  String get agentLicenceNumberHint =>
      'Ko\'chmas mulk litsenziya raqamingizni kiriting';

  @override
  String get agentLicenceNumberRequired => 'Litsenziya raqami majburiy';

  @override
  String get agentYearsExperience => 'Ish tajribasi (yil)';

  @override
  String get agentYearsExperienceHint => 'Yillar sonini kiriting';

  @override
  String get agentYearsExperienceRequired => 'Ish tajribasi majburiy';

  @override
  String get agentYearsExperienceInvalid => 'Iltimos, to\'g\'ri raqam kiriting';

  @override
  String get agentSpecialization => 'Mutaxassislik';

  @override
  String get agentApplicationNote =>
      'Arizangiz jamoamiz tomonidan ko\'rib chiqiladi. Arizangiz tasdiqlangandan so\'ng sizga xabar beriladi.';

  @override
  String get agentSubmitApplication => 'Arizani yuborish';

  @override
  String get agentApplicationSubmitted =>
      'Ariza muvaffaqiyatli yuborildi! Tez orada ko\'rib chiqamiz.';

  @override
  String get agentApplicationStatus => 'Ariza holati';

  @override
  String get agentViewProfile => 'Agent profilini ko\'rish';

  @override
  String get agentDashboardComingSoon => 'Agent boshqaruv paneli tez orada!';

  @override
  String get property_create_basic_information => 'Asosiy ma\'lumotlar';

  @override
  String get property_create_property_title => 'Mulk nomi *';

  @override
  String get property_create_property_title_hint =>
      'masalan, Shahar markazidagi zamonaviy 3 xonali kvartira';

  @override
  String get property_create_property_title_required =>
      'Iltimos, mulk nomini kiriting';

  @override
  String get property_create_description => 'Tavsif *';

  @override
  String get property_create_description_hint =>
      'Mulk haqida batafsil ma\'lumot bering...';

  @override
  String get property_create_description_required =>
      'Iltimos, tavsifni kiriting';

  @override
  String get property_create_property_type => 'Mulk turi';

  @override
  String get property_create_property_type_required => 'Mulk turi *';

  @override
  String get property_create_listing_type_required => 'E\'lon turi *';

  @override
  String get property_create_pricing => 'Narx';

  @override
  String get property_create_price => 'Narx *';

  @override
  String get property_create_price_hint => 'Narxni kiriting';

  @override
  String get property_create_price_required => 'Iltimos, narxni kiriting';

  @override
  String get property_create_currency => 'Valyuta';

  @override
  String get property_create_property_details => 'Mulk tafsilotlari';

  @override
  String get property_create_square_meters => 'Kv. metr *';

  @override
  String get property_create_bedrooms => 'Yotoqxonalar *';

  @override
  String get property_create_bathrooms => 'Hammomlar *';

  @override
  String get property_create_floor => 'Qavat';

  @override
  String get property_create_total_floors => 'Jami qavatlar';

  @override
  String get property_create_parking => 'Parkovka';

  @override
  String get property_create_year_built => 'Qurilgan yil';

  @override
  String get property_create_location => 'Manzil';

  @override
  String get property_create_address => 'Manzil *';

  @override
  String get property_create_address_hint => 'Mulk manzilini kiriting';

  @override
  String get property_create_address_required => 'Iltimos, manzilni kiriting';

  @override
  String get property_create_location_detected => 'Manzil aniqlandi';

  @override
  String get property_create_get_location => 'Joriy manzilni olish';

  @override
  String get property_create_features => 'Xususiyatlar';

  @override
  String get property_create_feature_balcony => 'Balkon';

  @override
  String get property_create_feature_garage => 'Garaj';

  @override
  String get property_create_feature_garden => 'Bog\'';

  @override
  String get property_create_feature_pool => 'Basseyn';

  @override
  String get property_create_feature_elevator => 'Lift';

  @override
  String get property_create_feature_furnished => 'Mebellangan';

  @override
  String get property_create_images => 'Mulk rasmlari';

  @override
  String get property_create_tap_to_add_images => 'Rasm qo\'shish uchun bosing';

  @override
  String get property_create_at_least_one_image =>
      'Kamida 1 rasm talab qilinadi';

  @override
  String get property_create_add_more => 'Yana qo\'shish';

  @override
  String get property_create_required => 'Majburiy';

  @override
  String get property_create_location_required =>
      'Mulk yaratish uchun iltimos, geolokatsiya xizmatlarini yoqing';

  @override
  String get property_create_image_required =>
      'Kamida bitta mulk rasmi talab qilinadi';
}
