// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get sessionExpired =>
      'Oturumunuz sona erdi. Lütfen tekrar giriş yapın.';

  @override
  String get welcome => 'Hoş geldin';

  @override
  String get welcomeBack => 'Tekrar hoşgeldiniz!';

  @override
  String get loginToYourAccount => 'Devam etmek için giriş yapın';

  @override
  String get or => 'VEYA';

  @override
  String get dontHaveAccount => 'Hesabınız yok mu?';

  @override
  String get chooseLanguage => 'Dilinizi Seçin';

  @override
  String get selectPreferredLanguage =>
      'Uygulama için tercih ettiğiniz dili seçin';

  @override
  String get continueButton => 'Devam etmek';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get continueWithApple => 'Apple\'la devam et';

  @override
  String get continueWithEmail => 'E-posta ile devam et';

  @override
  String get sellAndBuyProducts =>
      'Herhangi bir ürününüzü yalnızca bizimle satın ve satın alın';

  @override
  String get usedProductsMarket => 'Kullanılmış ürünler veya ikinci el pazarı';

  @override
  String get home_welcome_title => 'Mahallenizin pazarı';

  @override
  String get home_welcome_subtitle =>
      'Yakınınızdaki kişilerle alım satım yapın.\nGüvenli, basit ve yerel.';

  @override
  String get home_get_started => 'Başlayın';

  @override
  String get home_sign_in => 'Zaten bir hesabım var';

  @override
  String get home_terms_notice =>
      'Devam ederek Hizmet Şartlarımızı ve Gizlilik Politikamızı kabul etmiş olursunuz';

  @override
  String get register => 'Kayıt olmak';

  @override
  String get alreadyHaveAccount => 'Zaten bir hesabınız var';

  @override
  String get login => 'Giriş yapmak';

  @override
  String get loginToAccount => 'Hesaba Giriş Yapın';

  @override
  String get enterPhoneNumber => 'Telefon numarasını girin';

  @override
  String get password => 'Şifre';

  @override
  String get enterPassword => 'Şifreyi girin';

  @override
  String get forgotPassword => 'Parolanızı mı unuttunuz?';

  @override
  String get registerNow => 'Şimdi Kayıt Ol';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get pleaseEnterPhoneNumber => 'Lütfen telefon numaranızı girin';

  @override
  String get pleaseEnterPassword => 'Lütfen şifrenizi girin';

  @override
  String get unexpectedError =>
      'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get forgotPasswordComingSoon =>
      'Şifremi unuttum özelliği yakında geliyor';

  @override
  String get selectedCountryLabel => 'Seçilen:';

  @override
  String get fullPhoneLabel => 'Tam dolu:';

  @override
  String get home => 'Ev';

  @override
  String get settings => 'Ayarlar';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Aramak';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get error => 'Hata';

  @override
  String get retry => 'Yeniden dene';

  @override
  String get cancel => 'İptal etmek';

  @override
  String get save => 'Kaydetmek';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Lütfen bölgenizi seçin';

  @override
  String get searchHint => 'İlçe veya şehir arayın';

  @override
  String get apiError => 'API çağrılırken bir sorun oluştu';

  @override
  String get ok => 'TAMAM';

  @override
  String get emptyList => 'Boş Liste';

  @override
  String get dataLoadingError => 'Veri yüklenirken bir hata oluştu';

  @override
  String get confirm => 'Onaylamak';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'HAYIR';

  @override
  String confirmRegionSelection(Object regionName) {
    return '$regionName bölgesini seçmek istiyor musunuz?';
  }

  @override
  String get selectDistrictOrCity => 'Lütfen ilçenizi veya şehrinizi seçin';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return '$regionName bölgesini - $districtName seçmek istiyor musunuz?';
  }

  @override
  String get noResultsFound => 'Sonuç bulunamadı.';

  @override
  String errorWithCode(String errorCode) {
    return 'Hata: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'Veriler yüklenemedi. Hata: $error';
  }

  @override
  String get phoneVerification => 'Telefon Numarası Doğrulaması';

  @override
  String get enterPhonePrompt => 'Lütfen telefon numaranızı girin';

  @override
  String get enterPhoneNumberHint => 'Telefon numarasını girin';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Seçili: $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'Ülkenizi seçin';

  @override
  String get changeCountry => 'Ülkeyi değiştir';

  @override
  String get country => 'Ülke';

  @override
  String get allCountries => 'Tüm ülkeler';

  @override
  String get currencyRUB => 'Rus Rublesi';

  @override
  String get currencyUAH => 'Ukrayna Grivnası';

  @override
  String get currencyBYN => 'Belarus Rublesi';

  @override
  String get currencyMDL => 'Moldova Leyi';

  @override
  String get currencyGEL => 'Gürcistan Larisi';

  @override
  String get currencyAMD => 'Ermeni Dramı';

  @override
  String get currencyAZN => 'Azerbaycan Manatı';

  @override
  String get currencyKZT => 'Kazakistan Tengesi';

  @override
  String get currencyTMT => 'Türkmen Manatı';

  @override
  String get currencyKGS => 'Kırgız Somu';

  @override
  String get currencyTJS => 'Tacikistan Somonisi';

  @override
  String get currencyUZS => 'Özbek Somu';

  @override
  String get currencyUSD => 'ABD Doları';

  @override
  String get currencyEUR => 'Euro';

  @override
  String fullNumber(String phoneNumber) {
    return 'Tam sayı: $phoneNumber';
  }

  @override
  String get sendCode => 'Kodu Gönder';

  @override
  String get enterVerificationCode => 'Doğrulama kodunu girin';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Kodu Yeniden Gönder';

  @override
  String expires(String time) {
    return 'Sona erme tarihi: $time';
  }

  @override
  String get verifyAndContinue => 'Doğrula ve Devam Et';

  @override
  String get invalidVerificationCode => 'Geçersiz doğrulama kodu';

  @override
  String get verificationCodeSent => 'Doğrulama kodu başarıyla gönderildi';

  @override
  String get failedToSendCode => 'Doğrulama kodu gönderilemedi';

  @override
  String get verificationCodeResent =>
      'Doğrulama kodu başarıyla yeniden gönderildi';

  @override
  String get failedToResendCode => 'Doğrulama kodu yeniden gönderilemedi';

  @override
  String get passwordVerification => 'Şifre Doğrulaması';

  @override
  String get completeRegistrationPrompt =>
      'Kaydı tamamlamak için kullanıcı adınızı ve şifrenizi girin';

  @override
  String get username => 'Kullanıcı adı';

  @override
  String get username_required => 'Kullanıcı adı gerekli';

  @override
  String get username_min_length =>
      'Kullanıcı adı en az 2 karakterden oluşmalıdır';

  @override
  String get usernameHint => 'Kullanıcı adı123';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get profileImage => 'Profil Resmi';

  @override
  String get imageInstructions =>
      'Resimler burada görünecek, lütfen profil resmine basın';

  @override
  String get finish => 'Sona ermek';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get registrationError => 'Kayıt hatası';

  @override
  String get about => 'Hakkımızda';

  @override
  String get chat => 'Sohbet';

  @override
  String get realEstate => 'Gayrimenkul';

  @override
  String get language => 'TR';

  @override
  String get languageEn => 'İngilizce';

  @override
  String get languageRu => 'Rusça';

  @override
  String get languageUz => 'Özbekçe';

  @override
  String get serviceLiked => 'Hizmet beğenildi';

  @override
  String get support => 'Destek';

  @override
  String get service => 'Ticari Hizmetler';

  @override
  String get aboutContent =>
      'TezSell, yeni ve kullanılmış ürünlerin alım satımı için hızlı ve kolay bir pazar yeridir. Misyonumuz, her kullanıcı için en uygun ve verimli platformu yaratarak sorunsuz işlemler ve kullanıcı dostu bir deneyim sağlamaktır. İster satmak ister satın almak istiyor olun, TezSell yalnızca birkaç adımda bağlanmayı ve işlemleri tamamlamayı kolaylaştırır. Kullanıcılarımızın güvenliğine ve gizliliğine öncelik veriyoruz. Güvenliği ve uyumluluğu sağlamak için tüm işlemler dikkatlice izlenir ve hem alıcıların hem de satıcıların gönül rahatlığı sağlanır. Basit ve sezgisel arayüzümüz, kullanıcıların ürünleri hızlı bir şekilde listelemelerine ve ihtiyaç duydukları şeyi bulmalarına olanak tanır. Ayrıca Telegram aracılığıyla gerçek zamanlı iletişimi kolaylaştırarak satın alma ve satış sürecini daha da sorunsuz hale getiriyoruz.';

  @override
  String get errorMessage => 'Hata oluştu, lütfen sunucuyu kontrol edin';

  @override
  String get searchLocation => 'Konum';

  @override
  String get searchCategory => 'Kategoriler';

  @override
  String get searchProductPlaceholder => 'Ürün ara';

  @override
  String get searchServicePlaceholder => 'Hizmetleri arayın';

  @override
  String get search_products_subtitle => 'Mahallenizde harika fırsatlar bulun';

  @override
  String get search_services_subtitle => 'Mahallenizdeki profesyonelleri bulun';

  @override
  String get search_products_error => 'Ürünler aranırken hata oluştu';

  @override
  String get search_services_error => 'Hizmetler aranırken hata oluştu';

  @override
  String get load_more_products_error =>
      'Daha fazla ürün yüklenirken hata oluştu';

  @override
  String get load_more_services_error =>
      'Daha fazla hizmet yüklenirken hata oluştu';

  @override
  String get try_different_keywords => 'Farklı anahtar kelimeler deneyin';

  @override
  String get searchText => 'Aramak';

  @override
  String get selectedCategory => 'Seçilen Kategori:';

  @override
  String get selectedLocation => 'Seçilen Konum:';

  @override
  String get productError => 'Hiçbir ürün mevcut değil';

  @override
  String get serviceError => 'Hizmet yok';

  @override
  String get locationHeader => 'Bir konum seçin';

  @override
  String get locationPlaceholder => 'Bölgeyi burada arayın';

  @override
  String get categoryHeader => 'Bir Kategori Seçin';

  @override
  String get categoryPlaceholder => 'Kategorileri Ara';

  @override
  String get categoryError => 'Kategori yok';

  @override
  String get paginationFirst => 'Birinci';

  @override
  String get paginationPrevious => 'Öncesi';

  @override
  String get pageInfo => 'Sayfası';

  @override
  String get pageNext => 'Sonraki';

  @override
  String get pageLast => 'Son';

  @override
  String get loadingMessageProduct => 'Ürünler yükleniyor...';

  @override
  String get loadingMessageError => 'Yükleme sırasında hata';

  @override
  String get likeProductError => 'Ürün beğenilirken hata oluştu';

  @override
  String get dislikeProductError => 'Ürün beğenilmezken hata oluştu';

  @override
  String get loadingMessageLocation => 'Konum yükleniyor...';

  @override
  String get loadingLocationError => 'Konum yüklenirken hata oluştu';

  @override
  String get loadingMessageCategory => 'Kategoriler yükleniyor...';

  @override
  String get loadingCategoryError => 'Kategoriler yüklenirken hata oluştu:';

  @override
  String get profileUpdateSuccessMessage => 'Profil başarıyla güncellendi';

  @override
  String get profileUpdateFailMessage => 'Profil güncellenemedi';

  @override
  String get seeMoreBtn => 'Daha Fazlasını Gör';

  @override
  String get profilePageTitle => 'Profil Sayfası';

  @override
  String get editProfileModalTitle => 'Profili Düzenle';

  @override
  String get usernameLabel => 'Kullanıcı adı';

  @override
  String get locationLabel => 'Mevcut Konum';

  @override
  String get profileImageLabel => 'Profil Resmi';

  @override
  String get chooseFileLabel => 'Bir dosya seçin';

  @override
  String get uploadBtnLabel => 'Güncelleme';

  @override
  String get uploadingBtnLabel => 'Güncelleniyor...';

  @override
  String get cancelBtnLabel => 'İptal etmek';

  @override
  String get productsTitle => 'Ürünler';

  @override
  String get servicesTitle => 'Hizmetler';

  @override
  String get myProductsTitle => 'Ürünlerim';

  @override
  String get myServicesTitle => 'Hizmetlerim';

  @override
  String get favoriteProductsTitle => 'Favori Ürünler';

  @override
  String get favoriteServicesTitle => 'Favori Hizmetler';

  @override
  String get noFavorites => 'Favori Yok';

  @override
  String get addNewProductBtn => 'Yeni Ürün Ekle';

  @override
  String get addNew => 'Yeni';

  @override
  String get addNewServiceBtn => 'Yeni Hizmet Ekle';

  @override
  String get downloadMobileApp => 'Mobil uygulamayı indirin';

  @override
  String get registerPhoneNumberSuccess =>
      'Telefon numarası doğrulandı! Bir sonraki adıma geçebilirsiniz.';

  @override
  String get regionSelectedMessage => 'Seçilen bölge:';

  @override
  String get districtSelectMessage => 'Seçilen ilçe:';

  @override
  String get phoneNumberEmptyMessage =>
      'Devam etmeden önce lütfen telefon numaranızı doğrulayın';

  @override
  String get regionEmptyMessage => 'Lütfen önce bölgeyi seçin';

  @override
  String get districtEmptyMessage => 'Lütfen ilçeyi seçin';

  @override
  String get usernamePasswordEmptyMessage =>
      'Lütfen kullanıcı adınızı ve şifrenizi girin';

  @override
  String get registerTitle => 'Kayıt olmak';

  @override
  String get previousButton => 'Öncesi';

  @override
  String get nextButton => 'Sonraki';

  @override
  String get completeButton => 'Tamamlamak';

  @override
  String stepIndicator(int currentStep) {
    return '4 üzerinden $currentStep adımı';
  }

  @override
  String get districtSelectTitle => 'Bölge Listesi';

  @override
  String get districtSelectParagraph => 'Bir ilçe seçin:';

  @override
  String get phoneNumber => 'Telefon Numarası';

  @override
  String get sendOtp => 'OTP\'yi gönder';

  @override
  String get sendAgain => 'Tekrar gönder';

  @override
  String get verify => 'Doğrulamak';

  @override
  String get failedToSendOtp => 'OTP gönderilemedi. Sunucu yanlış döndürdü.';

  @override
  String get errorSendingOtp => 'OTP gönderilirken bir hata oluştu.';

  @override
  String get invalidPhoneNumber => 'Lütfen geçerli bir telefon numarası girin.';

  @override
  String get verificationSuccess => 'Başarıyla doğrulandı';

  @override
  String get verificationError =>
      'Bir hata oluştu. Lütfen daha sonra tekrar deneyin.';

  @override
  String get regionsList => 'Bölge Listesi';

  @override
  String get enterUsername => 'Kullanıcı adınızı girin';

  @override
  String get welcomeMessage =>
      'Tezsell\'e hoş geldiniz, telefon numaranızla giriş yapın';

  @override
  String get noAccount => 'Henüz hesabınız yok mu? Buradan kaydolun';

  @override
  String get successLogin => 'Başarıyla giriş yapıldı';

  @override
  String get myProfile => 'Profilim';

  @override
  String get logout => 'oturumu kapat';

  @override
  String get newProductTitle => 'Başlık';

  @override
  String get newProductDescription => 'Tanım';

  @override
  String get newProductPrice => 'Fiyat';

  @override
  String get newProductCondition => 'Durum';

  @override
  String get newProductCategory => 'Kategori';

  @override
  String get newProductImages => 'Görseller';

  @override
  String get addNewService => 'Yeni Hizmet Ekle';

  @override
  String get creating => 'Oluşturuluyor...';

  @override
  String get serviceName => 'Hizmet Adı';

  @override
  String get serviceNamePlaceholder => 'Hizmet başlığını girin';

  @override
  String get serviceDescription => 'Hizmet Açıklaması';

  @override
  String get serviceDescriptionPlaceholder => 'Hizmet açıklamasını girin';

  @override
  String get serviceCategory => 'Hizmet Kategorisi';

  @override
  String get selectCategory => 'Kategori seç';

  @override
  String get loadingCategories => 'Yükleniyor...';

  @override
  String get errorLoadingCategories => 'Kategoriler yüklenirken hata oluştu';

  @override
  String get serviceImages => 'Servis Görselleri';

  @override
  String get imageUploadHelper =>
      'Resim eklemek için + simgesini tıklayın (en fazla 10)';

  @override
  String get maxImagesError => 'En fazla 10 adet resim yükleyebilirsiniz';

  @override
  String get categoryNotFound => 'Kategori bulunamadı';

  @override
  String get productCreatedSuccess => 'Ürün başarıyla oluşturuldu';

  @override
  String get productLikeSuccess => 'Ürün başarıyla beğenildi';

  @override
  String get productDislikeSuccess => 'Ürün başarıyla beğenilmedi';

  @override
  String get errorCreatingService => 'Hizmet oluşturulurken hata oluştu';

  @override
  String get errorCreatingProduct => 'Ürün oluşturulurken hata oluştu';

  @override
  String get unknownError => 'Hizmet oluşturulurken bilinmeyen bir hata oluştu';

  @override
  String get submit => 'Göndermek';

  @override
  String get selectCategoryAction => 'Kategori Seçin';

  @override
  String get selectCondition => 'Koşul Seçin';

  @override
  String get sum => 'Toplam';

  @override
  String get noComments => 'Henüz yorum yok. İlk yorum yapan siz olun!';

  @override
  String get commentLikeSuccess => 'Yorum başarıyla beğenildi';

  @override
  String get commentLikeError => 'Yorumu beğenirken hata oluştu';

  @override
  String get unknownErrorMessage => 'Bilinmeyen bir hata oluştu';

  @override
  String get commentDislikeSuccess => 'Yorum başarıyla beğenilmedi';

  @override
  String get commentDislikeError => 'Yorum beğenilmezken hata oluştu';

  @override
  String get replyInfo => 'Lütfen önce bir yanıt girin';

  @override
  String get replySuccessMessage => 'Yanıt başarıyla eklendi';

  @override
  String get replyErrorMessage => 'Yanıt oluşturulurken hata oluştu';

  @override
  String get commentUpdateSuccess => 'Yorum başarıyla güncellendi';

  @override
  String get commentUpdateError => 'Yorum öğesi güncellenirken hata oluştu';

  @override
  String get deleteConfirmationMessage =>
      'Bu yorumu silmek istediğinizden emin misiniz?';

  @override
  String get commentDeleteSuccess => 'Yorum başarıyla silindi';

  @override
  String get commentDeleteError => 'Yorum silinirken hata oluştu';

  @override
  String get editLabel => 'Düzenlemek';

  @override
  String get deleteLabel => 'Silmek';

  @override
  String get saveLabel => 'Kaydetmek';

  @override
  String get replyLabel => 'Cevap vermek';

  @override
  String get replyTitle => 'cevaplar';

  @override
  String get replyPlaceholder => 'Bir cevap yazın...';

  @override
  String get chatLoginMessage => 'Sohbet başlatmak için giriş yapmalısınız';

  @override
  String get chatYourselfMessage => 'Kendinizle sohbet edemezsiniz.';

  @override
  String get chatRoomMessage => 'Sohbet odası oluşturuldu!';

  @override
  String get chatRoomError => 'Sohbet oluşturulamadı!';

  @override
  String get chatCreationError => 'Sohbet oluşturma başarısız oldu!';

  @override
  String get productsTotal => 'Toplam ürün';

  @override
  String get perPage => 'öğeler';

  @override
  String get clearAllFilters => 'Tüm filtreleri temizle';

  @override
  String get clickToUpload => 'Yüklemek için tıklayın';

  @override
  String get productInStock => 'Stokta var';

  @override
  String get productOutStock => 'Stoklar tükendi';

  @override
  String get productBack => 'Ürünlere geri dön';

  @override
  String get messageSeller => 'Sohbet';

  @override
  String get recommendedProducts => 'Önerilen Ürünler';

  @override
  String get deleteConfirmationProduct =>
      'Bu ürünü silmek istediğinizden emin misiniz?';

  @override
  String get productDeleteSuccess => 'Ürün başarıyla silindi';

  @override
  String get productDeleteError => 'Ürün silinirken hata oluştu';

  @override
  String get newCondition => 'Yeni';

  @override
  String get used => 'Kullanılmış';

  @override
  String get imageValidType =>
      'Bazı dosyalar eklenmedi. Lütfen 5 MB\'ın altındaki JPG, PNG, GIF veya WebP dosyalarını kullanın.';

  @override
  String get imageConfirmMessage =>
      'Bu resmi kaldırmak istediğinizden emin misiniz?';

  @override
  String get titleRequiredMessage => 'Başlık gerekli';

  @override
  String get descRequiredMessage => 'Açıklama gerekli';

  @override
  String get priceRequiredMessage => 'Fiyat gerekli';

  @override
  String get conditionRequiredMessage => 'Koşul gerekli';

  @override
  String get pleaseFillAllRequired => 'Lütfen gerekli alanları doldurun';

  @override
  String get oneImageConfirmMessage => 'En az bir ürün resmi gerekli';

  @override
  String get categoryRequiredMessage => 'Kategori gerekli';

  @override
  String get locationInfoError => 'Kullanıcı konum bilgisi eksik';

  @override
  String get editProductTitle => 'Ürünü Düzenle';

  @override
  String get imageUploadRequirements =>
      'En az bir resim gerekli. En fazla 10 resim (her biri 5 MB\'ın altında JPG, PNG, GIF, WebP) yükleyebilirsiniz.';

  @override
  String get productUpdatedSuccess => 'Ürün başarıyla güncellendi';

  @override
  String get productUpdateFailed => 'Ürün güncellemesi başarısız oldu';

  @override
  String get errorUpdatingProduct => 'Ürün güncellenirken hata oluştu';

  @override
  String get serviceBack => 'Hizmetlere geri dön';

  @override
  String get likeLabel => 'Beğenmek';

  @override
  String get commentsLabel => 'Yorumlar';

  @override
  String get writeComment => 'Bir yorum yazın...';

  @override
  String get postingLabel => 'Yayınlanıyor...';

  @override
  String get commentCreated => 'Yorum oluşturuldu';

  @override
  String get postCommentLabel => 'Yorum Gönder';

  @override
  String get loginPrompt =>
      'Yorumları görüntülemek ve göndermek için lütfen giriş yapın.';

  @override
  String get recommendedServices => 'Önerilen Hizmetler';

  @override
  String get commentsVisibilityNotice =>
      'Yorumlar yalnızca oturum açmış kullanıcılar tarafından görülebilir.';

  @override
  String get comingSoon => 'Yakında gelecek';

  @override
  String get serviceUpdateSuccess => 'Hizmet başarıyla güncellendi';

  @override
  String get serviceUpdateError => 'Hizmet öğesi güncellenirken hata oluştu';

  @override
  String get editServiceModalTitle => 'Hizmeti Düzenle';

  @override
  String get enterPhoneNumberWithoutCode => 'Telefon numarasını kodsuz girin';

  @override
  String get heroTitle => 'TezSat';

  @override
  String get heroSubtitle => 'Özbekistan için Hızlı ve Kolay Pazarınız';

  @override
  String get startSelling => 'Satışa Başla';

  @override
  String get browseProducts => 'Ürünlere Göz Atın';

  @override
  String get featuresTitle => 'Neden TezSell\'i Seçmelisiniz?';

  @override
  String get listingTitle => 'Basit Ürün Listeleme';

  @override
  String get listingDescription =>
      'Yalnızca birkaç tıklamayla öğelerinizi listeleyin. Fotoğraf ekleyin, fiyatınızı belirleyin ve alıcılarla anında bağlantı kurun.';

  @override
  String get locationTitle => 'Konum Tabanlı Tarama';

  @override
  String get locationDescription =>
      'Yakınınızdaki fırsatları bulun. Konum bazlı sistemimiz mahallenizdeki eşyaları keşfetmenize yardımcı olur.';

  @override
  String get location_subtitle =>
      'Yakındaki ilanları görmek için bölgenizi ve ilçenizi seçin';

  @override
  String get categoryTitle => 'Kategori Filtreleme';

  @override
  String get categoryDescription =>
      'Tam olarak aradığınızı bulmak için farklı kategoriler arasında kolayca gezinin.';

  @override
  String get inspirationTitle => 'Kore\'nin Havuç Pazarından Esinlendi';

  @override
  String get inspirationDescription1 =>
      'TezSell\'i Kore\'nin başarılı Havuç Pazarı\'ndan (당근마켓) ilham alarak oluşturduk, ancak Özbekistan\'ın yerel topluluklarının benzersiz ihtiyaçlarını karşılamak için özel olarak uyarladık.';

  @override
  String get inspirationDescription2 =>
      'Misyonumuz, komşuların kolayca satın alabilecekleri, satabilecekleri ve birbirleriyle bağlantı kurabilecekleri güvenilir bir platform oluşturmaktır.';

  @override
  String get comingSoonTitle => 'Yakında TezSell\'de';

  @override
  String get inAppChat => 'Uygulama İçi Sohbet';

  @override
  String get secureTransactions => 'Güvenli İşlemler';

  @override
  String get realEstateListings => 'Emlak İlanları';

  @override
  String get stayUpdated => 'Güncel Kalın';

  @override
  String get comingSoonBadge => 'Yakında gelecek';

  @override
  String get ctaTitle => 'TezSell Topluluğuna Bugün Katılın!';

  @override
  String get ctaDescription =>
      'Özbekistan için daha iyi bir pazar deneyimi oluşturmanın parçası olun. Geri bildiriminizi paylaşın ve büyümemize yardımcı olun!';

  @override
  String get createAccount => 'Hesap oluşturmak';

  @override
  String get learnMore => 'Daha fazla bilgi edin';

  @override
  String get replyUpdateSuccess => 'Yanıt başarıyla güncellendi';

  @override
  String get replyUpdateError => 'Yanıt güncellenemedi';

  @override
  String get replyDeleteSuccess => 'Yanıt başarıyla silindi';

  @override
  String get replyDeleteError => 'Yanıt silinemedi';

  @override
  String get replyDeleteConfirmation =>
      'Bu yanıtı silmek istediğinizden emin misiniz?';

  @override
  String get authenticationRequired => 'Kimlik doğrulama gerekli';

  @override
  String get enterValidReply => 'Lütfen geçerli bir yanıt metni girin';

  @override
  String get saving => 'Kaydediliyor...';

  @override
  String get deleting => 'Siliniyor...';

  @override
  String get properties => 'Özellikler';

  @override
  String get agents => 'Temsilciler';

  @override
  String get becomeAgent => 'Temsilci Olun';

  @override
  String get main => 'Ana';

  @override
  String get upload => 'Yüklemek';

  @override
  String get filtered_products => 'Filtrelenen Ürünler';

  @override
  String get filtered_services => 'Filtrelenen Hizmetler';

  @override
  String get productDetail => 'Ürün Detayı';

  @override
  String get unknownUser => 'Bilinmeyen Kullanıcı';

  @override
  String get locationNotAvailable => 'Konum mevcut değil';

  @override
  String get noTitle => 'Başlık Yok';

  @override
  String get noCategory => 'Kategori Yok';

  @override
  String get noDescription => 'Açıklama Yok';

  @override
  String get som => 'Som';

  @override
  String get about_me => 'Hakkımda';

  @override
  String get my_name => 'Benim adım';

  @override
  String get customer_support => 'Müşteri Desteği';

  @override
  String get customer_center => 'Müşteri Merkezi';

  @override
  String get customer_inquiries => 'Sorular';

  @override
  String get customer_terms => 'Şartlar ve koşullar';

  @override
  String get region => 'Bölge';

  @override
  String get district => 'Semt';

  @override
  String get tap_change_profile => 'Fotoğrafı değiştirmek için dokunun';

  @override
  String get language_settings => 'Dil Ayarları';

  @override
  String get selectLanguage => 'Bir dil seçin';

  @override
  String get select_theme => 'Tema Seç';

  @override
  String get theme => 'Tema';

  @override
  String get location_settings => 'Konum Ayarları';

  @override
  String get security => 'Güvenlik';

  @override
  String get data_storage => 'Veri ve Depolama';

  @override
  String get accessibility => 'Erişilebilirlik';

  @override
  String get privacy => 'Mahremiyet';

  @override
  String get light_theme => 'Işık';

  @override
  String get dark_theme => 'Karanlık';

  @override
  String get system_theme => 'Sistem Varsayılanı';

  @override
  String get my_products => 'Ürünlerim';

  @override
  String get refresh => 'Yenile';

  @override
  String get delete_product => 'Ürünü Sil';

  @override
  String get delete_confirmation =>
      'Bu ürünü silmek istediğinizden emin misiniz?';

  @override
  String get delete => 'Silmek';

  @override
  String error_loading_products(String error) {
    return 'Ürünler yüklenirken hata oluştu: $error';
  }

  @override
  String get product_deleted_success => 'Ürün başarıyla silindi';

  @override
  String error_deleting_product(String error) {
    return 'Ürün silinirken hata oluştu: $error';
  }

  @override
  String get no_products_found => 'Ürün bulunamadı';

  @override
  String get add_first_product => 'İlk ürününüzü ekleyerek başlayın';

  @override
  String get no_title => 'Başlık yok';

  @override
  String get no_description => 'Açıklama yok';

  @override
  String get in_stock => 'Stokta var';

  @override
  String get out_of_stock => 'Stoklar tükendi';

  @override
  String get new_condition => 'YENİ';

  @override
  String get edit_product => 'Ürünü Düzenle';

  @override
  String get delete_product_tooltip => 'Ürünü Sil';

  @override
  String get sum_currency => 'Toplam';

  @override
  String get edit_product_title => 'Ürünü Düzenle';

  @override
  String get product_name => 'Ürün Adı';

  @override
  String get product_description => 'Ürün Açıklaması';

  @override
  String get price => 'Fiyat';

  @override
  String get condition => 'Durum';

  @override
  String get condition_new => 'Yeni';

  @override
  String get condition_like_new => 'Yeni gibi';

  @override
  String get condition_used => 'Kullanılmış';

  @override
  String get condition_refurbished => 'Yenilenmiş';

  @override
  String get currency => 'Para birimi';

  @override
  String get category => 'Kategori';

  @override
  String get images => 'Görseller';

  @override
  String get existing_images => 'Mevcut Görseller';

  @override
  String get new_images => 'Yeni Görseller';

  @override
  String get image_instructions =>
      'Resimler burada görünecek. Lütfen yukarıdaki yükleme simgesine basın.';

  @override
  String get update_button => 'Güncelleme';

  @override
  String loading_category_error(String error) {
    return 'Kategoriler yüklenirken hata oluştu: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Resimler seçilirken hata oluştu: $error';
  }

  @override
  String get please_fill_all_required => 'Lütfen tüm alanları doldurun';

  @override
  String get invalid_price_message =>
      'Geçersiz fiyat girildi. Lütfen geçerli bir numara girin.';

  @override
  String get category_required_message => 'Lütfen geçerli bir kategori seçin.';

  @override
  String get one_image_required_message => 'En az bir ürün resmi gerekli';

  @override
  String get product_updated_success => 'Ürün başarıyla güncellendi';

  @override
  String error_updating_product(String error) {
    return 'Ürün güncellenirken hata oluştu: $error';
  }

  @override
  String get my_services => 'Hizmetlerim';

  @override
  String get delete_service => 'Hizmeti Sil';

  @override
  String get delete_service_confirmation =>
      'Bu hizmeti silmek istediğinizden emin misiniz?';

  @override
  String get no_services_found => 'Hiçbir hizmet bulunamadı';

  @override
  String get add_first_service => 'İlk hizmetinizi ekleyerek başlayın';

  @override
  String get edit_service => 'Hizmeti Düzenle';

  @override
  String get delete_service_tooltip => 'Hizmeti Sil';

  @override
  String get service_deleted_successfully => 'Hizmet başarıyla silindi';

  @override
  String get error_deleting_service => 'Hizmet silinirken hata oluştu';

  @override
  String get error_loading_services => 'Hizmetler yüklenirken hata oluştu';

  @override
  String get service_name => 'Hizmet Adı';

  @override
  String get enter_service_name => 'Hizmet adını girin';

  @override
  String get service_name_required => 'Hizmet adı gerekli';

  @override
  String get service_name_min_length => 'Hizmet adı en az 3 karakter olmalıdır';

  @override
  String get enter_service_description => 'Hizmet açıklamasını girin';

  @override
  String get service_description_required => 'Hizmet açıklaması gerekli';

  @override
  String get service_description_min_length =>
      'Açıklama en az 10 karakter olmalıdır';

  @override
  String get category_required => 'Lütfen bir kategori seçin';

  @override
  String get no_categories_available => 'Kategori yok';

  @override
  String get location => 'Konum';

  @override
  String get select_location => 'Konum seçin';

  @override
  String get location_required => 'Lütfen bir konum seçin';

  @override
  String get no_locations_available => 'Kullanılabilir konum yok';

  @override
  String get add_images => 'Resim Ekle';

  @override
  String get current_images => 'Güncel Görseller';

  @override
  String get no_images_selected => 'Resim seçilmedi';

  @override
  String get save_changes => 'Değişiklikleri Kaydet';

  @override
  String get map_main => 'Harita ve Özellikler';

  @override
  String get agent_status => 'Temsilci Durumu';

  @override
  String get admin_panel => 'Yönetici Paneli';

  @override
  String get propertiesFound => 'Bulunan Özellikler';

  @override
  String get propertiesSaved => 'özellikler kaydedildi';

  @override
  String get saved => 'kaydedildi';

  @override
  String get loadingProperties => 'Özellikler yükleniyor...';

  @override
  String get failedToLoad => 'Özellikler yüklenemedi. Lütfen tekrar deneyin.';

  @override
  String get noPropertiesFound => 'Hiçbir mülk bulunamadı';

  @override
  String get tryAdjusting => 'Arama kriterlerinizi ayarlamayı deneyin';

  @override
  String get search_placeholder => 'Başlığa veya konuma göre arayın...';

  @override
  String get search_filters => 'Filtreler';

  @override
  String get search_button => 'Aramak';

  @override
  String get search_clear_filters => 'Filtreleri Temizle';

  @override
  String get filter_options_sale_and_rent => 'Satılık ve Kiralık';

  @override
  String get filter_options_for_sale => 'Satılık';

  @override
  String get filter_options_for_rent => 'Kiralık';

  @override
  String get filter_options_all_types => 'Tüm Türler';

  @override
  String get filter_options_apartment => 'Daire';

  @override
  String get filter_options_house => 'Ev';

  @override
  String get filter_options_townhouse => 'Şehir evi';

  @override
  String get filter_options_villa => 'Villa';

  @override
  String get filter_options_commercial => 'Reklam';

  @override
  String get filter_options_office => 'Ofis';

  @override
  String get property_card_featured => 'Öne Çıkanlar';

  @override
  String get property_card_bed => 'yatak odası';

  @override
  String get property_card_bath => 'banyo';

  @override
  String get property_card_parking => 'otopark';

  @override
  String get property_card_view_details => 'Ayrıntıları Görüntüle';

  @override
  String get property_card_contact => 'Temas etmek';

  @override
  String get property_card_balcony => 'Balkon';

  @override
  String get property_card_garage => 'Garaj';

  @override
  String get property_card_garden => 'Bahçe';

  @override
  String get property_card_pool => 'Havuz';

  @override
  String get property_card_elevator => 'Asansör';

  @override
  String get property_card_furnished => 'Mobilyalı';

  @override
  String get property_card_sales => 'satış';

  @override
  String get pricing_month => '/ay';

  @override
  String get results_properties_found => 'Bulunan Özellikler';

  @override
  String get results_properties_saved => 'özellikler kaydedildi';

  @override
  String get results_saved => 'kaydedildi';

  @override
  String get results_loading_properties => 'Özellikler yükleniyor...';

  @override
  String get results_failed_to_load =>
      'Özellikler yüklenemedi. Lütfen tekrar deneyin.';

  @override
  String get results_no_properties_found => 'Hiçbir mülk bulunamadı';

  @override
  String get results_try_adjusting => 'Arama kriterlerinizi ayarlamayı deneyin';

  @override
  String get no_properties_found => 'Hiçbir mülk bulunamadı';

  @override
  String get no_category_properties => 'Bu kategoride mülk yok';

  @override
  String get properties_loading => 'Özellikler yükleniyor...';

  @override
  String get all_properties_loaded => 'Tüm özellikler yüklendi';

  @override
  String n_properties(int count) {
    return '$count özellikleri';
  }

  @override
  String get in_area => 'bölgede';

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
  String get pagination_previous => 'Öncesi';

  @override
  String get pagination_next => 'Sonraki';

  @override
  String get pagination_page => 'Sayfa';

  @override
  String get pagination_page_of => 'Sayfa 1 /';

  @override
  String get contact_modal_title => 'İletişim Bilgileri';

  @override
  String get contact_modal_agent_contact => 'Temsilci İletişimi';

  @override
  String get contact_modal_property_owner => 'Mülk Sahibi';

  @override
  String get contact_modal_agent_phone_number => 'Temsilci Telefon Numarası';

  @override
  String get contact_modal_owner_phone_number => 'Sahibinin Telefon Numarası';

  @override
  String get contact_modal_license => 'Lisans';

  @override
  String get contact_modal_rating => 'Derecelendirme';

  @override
  String get contact_modal_call_now => 'Şimdi Ara';

  @override
  String get contact_modal_copy_number => 'Numarayı Kopyala';

  @override
  String get contact_modal_close => 'Kapalı';

  @override
  String get contact_modal_contact_hours => 'İletişim Saatleri: 09:00 - 20:00';

  @override
  String get contact_modal_agent => 'Ajan';

  @override
  String get errors_toggle_save_failed => 'Mülk kaydetmeye geçiş yapılamadı:';

  @override
  String get errors_copy_failed => 'Telefon numarası kopyalanamadı:';

  @override
  String get errors_phone_copied => 'Telefon numarası panoya kopyalandı';

  @override
  String get errors_error_occurred_regions =>
      'Bölgelerle ilgili bir hata oluştu';

  @override
  String get errors_error_occurred_districts =>
      'İlçelerle ilgili bir hata oluştu';

  @override
  String get errors_please_fill_all_required_fields =>
      'Lütfen gerekli tüm alanları doldurun';

  @override
  String get errors_authentication_required => 'Kimlik doğrulama gerekli';

  @override
  String get errors_user_info_missing => 'Kullanıcı bilgileri eksik';

  @override
  String get errors_validation_error =>
      'Lütfen giriş verilerinizi kontrol edin';

  @override
  String get errors_permission_denied => 'İzin reddedildi';

  @override
  String get errors_server_error => 'Sunucu hatası oluştu';

  @override
  String get errors_network_error => 'Ağ bağlantı hatası';

  @override
  String get errors_timeout_error => 'İstek zaman aşımı aşıldı';

  @override
  String get errors_custom_error => 'Bir hata oluştu';

  @override
  String get errors_error_creating_property =>
      'Mülk oluşturulurken hata oluştu';

  @override
  String get errors_unknown_error_message => 'Bilinmeyen bir hata oluştu';

  @override
  String get errors_coordinates_not_found =>
      'Bu adresin koordinatları bulunamadı. Lütfen bunları manuel olarak girin.';

  @override
  String get errors_coordinates_error =>
      'Koordinatlar alınırken hata oluştu. Lütfen bunları manuel olarak girin.';

  @override
  String get property_info_views => 'görünümler';

  @override
  String get property_info_listed => 'Listelendi';

  @override
  String get property_info_price_per_sqm => '/m2';

  @override
  String get property_info_saved => 'Kaydedildi';

  @override
  String get property_info_save => 'Kaydetmek';

  @override
  String get property_info_share => 'Paylaşmak';

  @override
  String get loading_loading => 'Yükleniyor...';

  @override
  String get loading_loading_details => 'Emlak ayrıntıları yükleniyor...';

  @override
  String get loading_property_not_found => 'Mülk bulunamadı';

  @override
  String get loading_property_not_found_message =>
      'Aradığınız mülk mevcut değil veya kaldırılmış.';

  @override
  String get loading_back_to_properties => 'Özelliklere Geri Dön';

  @override
  String get loading_title => 'Aracılar yükleniyor...';

  @override
  String get loading_message => 'Temsilci listesi yüklenirken lütfen bekleyin.';

  @override
  String get loading_agent_not_found => 'Temsilci bulunamadı';

  @override
  String get property_details_title => 'Emlak Detayları';

  @override
  String get property_details_bedrooms => 'Yatak odaları';

  @override
  String get property_details_bathrooms => 'Banyolar';

  @override
  String get property_details_floor_area => 'Kat Alanı';

  @override
  String get property_details_parking => 'Otopark';

  @override
  String get property_details_basic_information => 'Temel Bilgiler';

  @override
  String get property_details_property_type => 'Mülk Türü:';

  @override
  String get property_details_listing_type => 'Listeleme Türü:';

  @override
  String get property_details_for_sale => 'Satılık';

  @override
  String get property_details_for_rent => 'Kiralık';

  @override
  String get property_details_year_built => 'Yapım Yılı:';

  @override
  String get property_details_floor => 'Zemin:';

  @override
  String get property_details_of => 'ile ilgili';

  @override
  String get property_details_features_amenities => 'Özellikler ve Olanaklar';

  @override
  String get sections_description => 'Tanım';

  @override
  String get sections_nearby_amenities => 'Yakındaki Olanaklar';

  @override
  String get sections_similar_properties => 'Benzer Özellikler';

  @override
  String get amenities_metro => 'Metro';

  @override
  String get amenities_school => 'Okul';

  @override
  String get amenities_hospital => 'Hastane';

  @override
  String get amenities_shopping => 'Alışveriş';

  @override
  String get amenities_away => 'uzak';

  @override
  String get contact_title => 'İletişim Bilgileri';

  @override
  String get contact_professional_listing => 'Profesyonel Listeleme';

  @override
  String get contact_listed_by_agent =>
      'Doğrulanmış temsilci tarafından listelendi';

  @override
  String get contact_by_owner => 'Sahibi tarafından';

  @override
  String get contact_direct_contact => 'Mülk sahibiyle doğrudan iletişim';

  @override
  String get contact_property_owner => 'Mülk Sahibi';

  @override
  String get contact_call_agent => 'Temsilciyi Ara';

  @override
  String get contact_email_agent => 'E-posta Aracısı';

  @override
  String get contact_call_owner => 'Sahibini Ara';

  @override
  String get contact_email_owner => 'E-posta Sahibi';

  @override
  String get contact_send_inquiry => 'Talep Gönder';

  @override
  String get property_status_title => 'Mülk Durumu';

  @override
  String get property_status_availability => 'Kullanılabilirlik:';

  @override
  String get property_status_available => 'Mevcut';

  @override
  String get property_status_not_available => 'Müsait değil';

  @override
  String get property_status_featured => 'Öne çıkanlar:';

  @override
  String get property_status_featured_property => 'Öne Çıkan Mülk';

  @override
  String get property_status_property_id => 'Mülk Kimliği:';

  @override
  String get inquiry_title => 'Talep Gönder';

  @override
  String get inquiry_inquiry_type => 'Sorgu Türü';

  @override
  String get inquiry_request_info => 'Bilgi İste';

  @override
  String get inquiry_schedule_viewing => 'Zamanlı Görüntüleme';

  @override
  String get inquiry_make_offer => 'Teklif Yap';

  @override
  String get inquiry_request_callback => 'Geri Arama İste';

  @override
  String get inquiry_message => 'Mesaj';

  @override
  String get inquiry_message_placeholder =>
      'Bize bu mülke olan ilginizden bahsedin...';

  @override
  String get inquiry_offered_price => 'Teklif Edilen Fiyat';

  @override
  String get inquiry_enter_offer => 'Teklifinizi girin';

  @override
  String get inquiry_preferred_contact_time =>
      'Tercih Edilen İletişim Süresi (isteğe bağlı)';

  @override
  String get inquiry_contact_time_placeholder => 'ör. Hafta içi 09:00 - 17:00';

  @override
  String get inquiry_cancel => 'İptal etmek';

  @override
  String get inquiry_sending => 'Gönderiliyor...';

  @override
  String get inquiry_send_inquiry => 'Talep Gönder';

  @override
  String get inquiry_inquiry_sent_success => 'Sorgu başarıyla gönderildi!';

  @override
  String get inquiry_inquiry_sent_error =>
      'Soruşturma gönderilemedi. Lütfen tekrar deneyin.';

  @override
  String get alerts_link_copied => 'Mülk bağlantısı panoya kopyalandı!';

  @override
  String get alerts_phone_copied => 'Telefon numarası panoya kopyalandı!';

  @override
  String get alerts_save_property_failed => 'Mülk kaydedilemedi:';

  @override
  String get alerts_email_subject => 'Hakkında soruşturma:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Merhaba,\\n\\n$address adresinde bulunan \"$title\" mülkünüzle ilgileniyorum.\\n\\nDaha fazla bilgi için lütfen benimle iletişime geçin.\\n\\nSaygılarımla';
  }

  @override
  String get related_properties_view_details => 'Ayrıntıları Görüntüle';

  @override
  String get header_property => 'Hayalinizdeki Gayrimenkulü Bulun';

  @override
  String get header_sub_property =>
      'Taşkent\'in en çok tercih edilen semtlerindeki premium emlak fırsatlarını keşfedin';

  @override
  String get header_title => 'Emlakçılar';

  @override
  String get header_subtitle =>
      'Gayrimenkul ihtiyaçlarınıza yardımcı olacak deneyimli acenteler bulun';

  @override
  String get header_agents_found => 'ajanlar bulundu';

  @override
  String get filters_all_specializations => 'Tüm Uzmanlıklar';

  @override
  String get filters_residential => 'yerleşim';

  @override
  String get filters_commercial => 'Reklam';

  @override
  String get filters_luxury => 'Lüks';

  @override
  String get filters_investment => 'Yatırım';

  @override
  String get filters_any_rating => 'Herhangi Bir Derecelendirme';

  @override
  String get filters_four_stars => '4+ Yıldız';

  @override
  String get filters_four_half_stars => '4,5+ Yıldız';

  @override
  String get filters_five_stars => '5 Yıldız';

  @override
  String get filters_highest_rated => 'En Yüksek Puan Alan';

  @override
  String get filters_lowest_rated => 'En Düşük Puanlı';

  @override
  String get filters_most_sales => 'En Çok Satış';

  @override
  String get filters_most_experience => 'En Fazla Deneyim';

  @override
  String get agent_card_verified_agent => 'Doğrulanmış Temsilci';

  @override
  String get agent_card_years_experience => 'yıllık deneyim';

  @override
  String get agent_card_years => 'yıllar';

  @override
  String get agent_card_license => 'Lisans';

  @override
  String get agent_card_specialization => 'Uzmanlık';

  @override
  String get agent_card_view_profile => 'Profili Görüntüle';

  @override
  String get agent_card_contact => 'Temas etmek';

  @override
  String get agent_card_verified => 'Doğrulandı';

  @override
  String get no_results_title => 'Hiçbir Aracı Bulunamadı';

  @override
  String get no_results_message =>
      'Arama kriterlerinizi veya filtrelerinizi ayarlamayı deneyin.';

  @override
  String get error_title => 'Aracılar Yüklenirken Hata Oluştu';

  @override
  String get error_message =>
      'Temsilci listesi yüklenemedi. Lütfen tekrar deneyin.';

  @override
  String get error_retry => 'Yeniden dene';

  @override
  String get error_default_message => 'Temsilci ayrıntıları yüklenemedi';

  @override
  String get error_try_again => 'Tekrar deneyin';

  @override
  String get notifications_phone_copied => 'Telefon numarası panoya kopyalandı';

  @override
  String get notifications_copy_failed => 'Telefon numarası kopyalanamadı:';

  @override
  String get fallback_agent_name => 'Ajan';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Mülkü Gönder';

  @override
  String get navigation_submitting => 'Gönderiliyor...';

  @override
  String get navigation_back_to_agents => 'Temsilcilere Geri Dön';

  @override
  String get agent_profile_verified_agent => 'Doğrulanmış Temsilci';

  @override
  String get agent_profile_contact_agent => 'Temsilciyle iletişime geçin';

  @override
  String get agent_profile_send_message => 'Mesaj Gönder';

  @override
  String get agent_profile_years_experience => 'Yılların Deneyimi';

  @override
  String get agent_profile_properties_sold => 'Satılan Gayrimenkuller';

  @override
  String get agent_profile_active_listings => 'Aktif Listelemeler';

  @override
  String get agent_profile_total_properties => 'Toplam Özellikler';

  @override
  String get tabs_overview => 'genel bakış';

  @override
  String get tabs_properties => 'özellikler';

  @override
  String get tabs_reviews => 'yorumlar';

  @override
  String get about_agent_title => 'Temsilci Hakkında';

  @override
  String get about_agent_agency => 'Ajans';

  @override
  String get about_agent_license_number => 'Lisans Numarası';

  @override
  String get about_agent_specialization => 'Uzmanlık';

  @override
  String get about_agent_member_since => 'Üyelik Tarihi:';

  @override
  String get about_agent_verified_since => 'Şu tarihten beri doğrulandı:';

  @override
  String get performance_metrics_title => 'Performans Metrikleri';

  @override
  String get performance_metrics_average_rating => 'Ortalama Derecelendirme';

  @override
  String get performance_metrics_properties_sold => 'Satılan Gayrimenkuller';

  @override
  String get performance_metrics_active_listings => 'Aktif Listelemeler';

  @override
  String get performance_metrics_years_experience => 'Yılların Deneyimi';

  @override
  String get contact_info_title => 'İletişim Bilgileri';

  @override
  String get contact_info_contact_via_platform => 'Platform Üzerinden İletişim';

  @override
  String get verification_status_title => 'Doğrulama Durumu';

  @override
  String get verification_status_verified_agent => 'Doğrulanmış Temsilci';

  @override
  String get verification_status_pending_verification => 'Doğrulama Bekleniyor';

  @override
  String get verification_status_licensed_professional =>
      'Lisanslı Profesyonel';

  @override
  String get verification_status_registered_agency => 'Kayıtlı Acente';

  @override
  String get quick_actions_title => 'Hızlı Eylemler';

  @override
  String get quick_actions_call_now => 'Şimdi Ara';

  @override
  String get quick_actions_send_message => 'Mesaj Gönder';

  @override
  String get quick_actions_view_properties => 'Özellikleri Görüntüle';

  @override
  String get properties_title => 'Aracı Özellikleri';

  @override
  String get properties_loading_properties => 'Özellikler yükleniyor...';

  @override
  String get properties_no_properties_title => 'Hiçbir Emlak Bulunamadı';

  @override
  String get properties_no_properties_message =>
      'Bu temsilcinin özellikleri burada görünecek.';

  @override
  String get properties_recent_properties_note =>
      'Son özellikler gösteriliyor. Tüm acente özellikleri için tam listeleri kontrol edin.';

  @override
  String get properties_listed => 'Listelendi';

  @override
  String get properties_bed => 'yatak';

  @override
  String get properties_bath => 'banyo';

  @override
  String get properties_for_sale => 'Satılık';

  @override
  String get properties_for_rent => 'Kiralık';

  @override
  String get reviews_title => 'Müşteri Yorumları';

  @override
  String get reviews_no_reviews_title => 'Henüz İnceleme Yok';

  @override
  String get reviews_no_reviews_message =>
      'Müşteri incelemeleri ve önerileri burada görünecektir.';

  @override
  String get fallbacks_agent_name => 'Ajan';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => 'Kaydedilen Özellikler';

  @override
  String get saved_properties_subtitle => 'Favori mülkleriniz tek bir yerde';

  @override
  String get saved_properties_no_saved_properties => 'Henüz kayıtlı mülk yok';

  @override
  String get saved_properties_start_saving =>
      'Beğendiğiniz mülkleri keşfetmeye ve kaydetmeye başlayın';

  @override
  String get saved_properties_browse_properties => 'Özelliklere Göz Atın';

  @override
  String get saved_properties_saved_on => 'Kayıt tarihi';

  @override
  String get auth_login_required =>
      'Kaydedilen mülkleri görüntülemek için lütfen giriş yapın';

  @override
  String get auth_login => 'Giriş yapmak';

  @override
  String get success_property_unsaved => 'Kaydedilen listeden mülk kaldırıldı';

  @override
  String get success_property_saved => 'Mülk başarıyla kaydedildi';

  @override
  String get success_phone_copied => 'Telefon numarası kopyalandı!';

  @override
  String get success_property_created_success => 'Mülk başarıyla oluşturuldu!';

  @override
  String get success_agent_approved => 'Temsilci başarıyla onaylandı';

  @override
  String get success_agent_rejected => 'Temsilci başarıyla reddedildi';

  @override
  String get steps_step => 'Adım';

  @override
  String get steps_basic_information => 'Temel Bilgiler';

  @override
  String get steps_location_details => 'Konum Detayları';

  @override
  String get steps_property_details => 'Emlak Detayları';

  @override
  String get steps_property_images => 'Emlak Görselleri';

  @override
  String get basic_info_tell_us_about_property =>
      'Bize mülkünüz hakkında bilgi verin';

  @override
  String get basic_info_property_type => 'Emlak Tipi';

  @override
  String get basic_info_listing_type => 'Listeleme Türü';

  @override
  String get basic_info_property_title => 'Mülkiyet Başlığı';

  @override
  String get basic_info_title_placeholder =>
      'Mülkünüz için açıklayıcı bir başlık girin';

  @override
  String get basic_info_description => 'Tanım';

  @override
  String get basic_info_description_placeholder =>
      'Gayrimenkulünüzü ayrıntılı olarak tanımlayın...';

  @override
  String get property_types_apartment => 'Daire';

  @override
  String get property_types_house => 'Ev';

  @override
  String get property_types_townhouse => 'Şehir evi';

  @override
  String get property_types_villa => 'Villa';

  @override
  String get property_types_commercial => 'Reklam';

  @override
  String get property_types_office => 'Ofis';

  @override
  String get property_types_land => 'Kara';

  @override
  String get property_types_warehouse => 'Depo';

  @override
  String get listing_types_for_sale => 'Satılık';

  @override
  String get listing_types_for_rent => 'Kiralık';

  @override
  String get location_where_is_property => 'Mülkünüz nerede bulunuyor?';

  @override
  String get location_full_address => 'Tam Adres';

  @override
  String get location_address_placeholder => 'Tam adresi girin';

  @override
  String get location_region => 'Bölge';

  @override
  String get location_select_region => 'Bölge seçin';

  @override
  String get location_district => 'Semt';

  @override
  String get location_select_district => 'İlçe seçin';

  @override
  String get location_city => 'Şehir';

  @override
  String get location_city_placeholder => 'Şehir';

  @override
  String get location_loading_regions => 'Bölgeler yükleniyor...';

  @override
  String get location_loading_districts => 'İlçeler yükleniyor...';

  @override
  String get location_map_coordinates => 'Harita Koordinatları';

  @override
  String get location_get_coordinates => 'Koordinatları Alın';

  @override
  String get location_latitude => 'Enlem';

  @override
  String get location_longitude => 'Boylam';

  @override
  String get location_coordinates_set => 'Koordinatlar ayarlandı';

  @override
  String get location_location_tips => 'Konum İpuçları';

  @override
  String get location_location_tip_1 =>
      '• Önce adresi girin, ardından harita konumunu otomatik olarak almak için \'Koordinatları Al\'ı tıklayın';

  @override
  String get location_location_tip_2 =>
      '• Tam konumu biliyorsanız koordinatları manuel olarak da girebilirsiniz.';

  @override
  String get location_location_tip_3 =>
      '• Doğru koordinatlar, alıcıların mülkünüzü haritada bulmasına yardımcı olur';

  @override
  String get property_details_provide_detailed_info =>
      'Gayrimenkulünüz hakkında detaylı bilgi verin';

  @override
  String get property_details_total_floors => 'Toplam Kat Sayısı';

  @override
  String get property_details_area_m2 => 'Alan (m²)';

  @override
  String get property_details_parking_spaces => 'Park Alanları';

  @override
  String get property_details_price => 'Fiyat';

  @override
  String get property_details_features => 'Özellikler';

  @override
  String get images_add_photos_showcase =>
      'Mülkünüzü sergilemek için fotoğraf ekleyin';

  @override
  String get images_click_to_upload => 'Resimleri yüklemek için tıklayın';

  @override
  String get images_max_images_info => 'Maksimum 10 resim, JPG, PNG veya WEBP';

  @override
  String get images_main => 'Ana';

  @override
  String get images_maximum_images_allowed =>
      'Maksimum 10 görsele izin veriliyor';

  @override
  String get admin_dashboard_title => 'Yönetici Kontrol Paneli';

  @override
  String get admin_dashboard_subtitle =>
      'Gayrimenkul platformunuza gerçek zamanlı genel bakış';

  @override
  String get admin_last_update => 'Son güncelleme';

  @override
  String get admin_total_properties => 'Toplam Özellikler';

  @override
  String get admin_total_agents => 'Toplam Temsilciler';

  @override
  String get admin_total_users => 'Toplam Kullanıcı Sayısı';

  @override
  String get admin_total_views => 'Toplam Görüntülemeler';

  @override
  String get admin_error_loading_dashboard =>
      'Kontrol paneli yüklenirken hata oluştu';

  @override
  String get admin_failed_to_load_data => 'Kontrol paneli verileri yüklenemedi';

  @override
  String get admin_avg_sale_price => 'Ort. Satış Fiyatı';

  @override
  String get admin_avg_sale_price_subtitle => 'Tüm aktif listeler';

  @override
  String get admin_total_portfolio_value => 'Toplam Portföy Değeri';

  @override
  String get admin_total_portfolio_value_subtitle => 'Birleşik özellik değeri';

  @override
  String get admin_avg_price_per_sqm => 'Ortalama Metrekare Fiyatı';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Piyasa oranı göstergesi';

  @override
  String get admin_property_types_distribution =>
      'Gayrimenkul Tiplerinin Dağılımı';

  @override
  String get admin_properties_by_city => 'Şehirlere Göre Tesisler';

  @override
  String get admin_properties_by_district => 'İlçelere Göre Özellikler';

  @override
  String get admin_inquiry_types_distribution => 'Sorgu Türleri Dağılımı';

  @override
  String get admin_agent_verification_rate => 'Temsilci Doğrulama Oranı';

  @override
  String get admin_agent_verification_rate_subtitle => 'Kalite kontrol';

  @override
  String get admin_inquiry_response_rate => 'Sorgu Yanıt Oranı';

  @override
  String get admin_inquiry_response_rate_subtitle => 'Müşteri hizmetleri';

  @override
  String get admin_avg_views_per_property =>
      'Mülk Başına Ortalama Görüntüleme Sayısı';

  @override
  String get admin_avg_views_per_property_subtitle => 'Mülk popülerliği';

  @override
  String get admin_featured_properties => 'Öne Çıkan Özellikler';

  @override
  String get admin_featured_properties_subtitle => 'Premium listeler';

  @override
  String get admin_most_viewed_properties =>
      'En Çok Görüntülenen Gayrimenkuller';

  @override
  String get admin_top_performing_agents =>
      'En İyi Performans Gösteren Temsilciler';

  @override
  String get admin_system_health => 'Sistem Sağlığı';

  @override
  String get admin_properties_without_images => 'Resim içermeyen özellikler';

  @override
  String get admin_missing_location_data => 'Konum verileri eksik';

  @override
  String get admin_pending_agent_verification =>
      'Temsilci doğrulaması bekleniyor';

  @override
  String get admin_active => 'aktif';

  @override
  String get admin_verified => 'doğrulandı';

  @override
  String get admin_active_7d => 'aktif (7g)';

  @override
  String get admin_this_month => 'bu ay';

  @override
  String get agents_loading_pending_applications =>
      'Bekleyen uygulamalar yükleniyor...';

  @override
  String get agents_error_loading_applications =>
      'Uygulamalar yüklenirken hata oluştu';

  @override
  String get agents_pending_agents => 'Bekleyen Temsilciler';

  @override
  String get agents_total_pending_applications => 'Toplam bekleyen başvurular:';

  @override
  String get agents_pending_verification => 'Doğrulama Bekleniyor';

  @override
  String get agents_applied_date => 'Uygulanan:';

  @override
  String get agents_contact_info => 'İletişim Bilgileri';

  @override
  String get agents_license_number => 'Lisans Numarası';

  @override
  String get agents_years_experience => 'Yılların Deneyimi';

  @override
  String get agents_years_suffix => 'yıllar';

  @override
  String get agents_total_sales => 'Toplam Satışlar';

  @override
  String get agents_specialization => 'Uzmanlık';

  @override
  String get agents_approve => 'Onaylamak';

  @override
  String get agents_reject => 'Reddetmek';

  @override
  String get agents_no_pending_applications => 'Bekleyen başvuru yok';

  @override
  String get agents_all_applications_processed =>
      'Tüm acente başvuruları işleme alındı';

  @override
  String get general_previous => 'Öncesi';

  @override
  String get general_page => 'Sayfa';

  @override
  String get general_next => 'Sonraki';

  @override
  String get general_views => 'görünümler';

  @override
  String get general_sales => 'satış';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'Rusça';

  @override
  String get general_language_en => 'İngilizce';

  @override
  String get general_super_admin => 'Süper Yönetici';

  @override
  String get general_staff => 'Kadro';

  @override
  String get general_verified_agent => 'Doğrulanmış Temsilci';

  @override
  String get general_pending_agent => 'Beklemedeki Temsilci';

  @override
  String get general_regular_user => 'Düzenli Kullanıcı';

  @override
  String get general_admin => 'Yönetici';

  @override
  String get general_dashboard => 'Kontrol Paneli';

  @override
  String get general_manage_users => 'Kullanıcıları Yönet';

  @override
  String get general_verified_agents => 'Doğrulanmış Temsilciler';

  @override
  String get general_agent_panel => 'Temsilci Paneli';

  @override
  String get general_create_property => 'Mülk Oluştur';

  @override
  String get general_my_properties => 'Gayrimenkullerim';

  @override
  String get general_inquiries => 'Sorular';

  @override
  String get general_agent_profile => 'Temsilci Profili';

  @override
  String get general_live => 'Canlı';

  @override
  String get general_logged_out_successfully => 'Başarıyla çıkış yapıldı';

  @override
  String get general_logout_completed_with_errors =>
      'Oturum kapatma tamamlandı (hatalarla)';

  @override
  String get general_application_under_review => 'Başvuru inceleniyor';

  @override
  String get general_check_status => 'Durumu kontrol et →';

  @override
  String get general_last_updated => 'Son güncelleme:';

  @override
  String get general_permissions_may_be_outdated =>
      'İzinler güncelliğini kaybetmiş olabilir';

  @override
  String get general_permissions_up_to_date => 'İzinler güncel';

  @override
  String get general_never => 'Asla';

  @override
  String get general_properties_found => 'Bulunan Özellikler';

  @override
  String get general_properties_saved => 'özellikler kaydedildi';

  @override
  String get general_saved => 'kaydedildi';

  @override
  String get general_loading_properties => 'Özellikler yükleniyor...';

  @override
  String get general_failed_to_load =>
      'Özellikler yüklenemedi. Lütfen tekrar deneyin.';

  @override
  String get general_no_properties_found => 'Hiçbir mülk bulunamadı';

  @override
  String get general_try_adjusting => 'Arama kriterlerinizi ayarlamayı deneyin';

  @override
  String get select_category => 'Kategori seç';

  @override
  String get service_description => 'Hizmet Açıklaması';

  @override
  String get product_search_placeholder =>
      'Ürünleri bulmak için bir arama terimi girin';

  @override
  String get privacy_policy => 'Gizlilik Politikası';

  @override
  String get terms_subtitle => 'Gizlilik politikası ve şartlar';

  @override
  String get last_updated => 'Son Güncelleme';

  @override
  String get contact_information => 'İletişim Bilgileri';

  @override
  String get accept_terms => 'Şartlar ve Koşulları Kabul Ediyorum';

  @override
  String get read_terms => 'Lütfen şartlar ve koşullarımızı okuyun';

  @override
  String get inquiries => 'Sorular ve Destek';

  @override
  String get inquiries_subtitle => 'Yardım için bizimle iletişime geçin';

  @override
  String get help_center => 'Size nasıl yardımcı olabiliriz?';

  @override
  String get help_subtitle =>
      'Her türlü sorunuzda size yardımcı olmak için buradayız';

  @override
  String get contact_us => 'Bize Ulaşın';

  @override
  String get email_support => 'E-posta Desteği';

  @override
  String get call_support => 'Desteği Ara';

  @override
  String get send_message => 'Mesaj Gönder';

  @override
  String get fill_contact_form => 'İletişim formunu doldurun';

  @override
  String get contact_form => 'İletişim Formu';

  @override
  String get name => 'Adınız';

  @override
  String get name_required => 'Lütfen adınızı girin';

  @override
  String get email => 'E-posta Adresi';

  @override
  String get email_required => 'Lütfen e-postanızı girin';

  @override
  String get email_invalid => 'Lütfen geçerli bir e-posta girin';

  @override
  String get subject => 'Ders';

  @override
  String get subject_required => 'Lütfen bir konu girin';

  @override
  String get message => 'Mesaj';

  @override
  String get message_required => 'Lütfen mesajınızı girin';

  @override
  String get message_too_short => 'Mesaj en az 10 karakter olmalıdır';

  @override
  String get faq => 'Sıkça Sorulan Sorular';

  @override
  String get follow_us => 'Bizi takip edin';

  @override
  String get faq_how_to_sell => 'Tezsell\'de nasıl eşya satarım?';

  @override
  String get faq_how_to_sell_answer =>
      'Ürün satmak için: 1) Hesap oluşturun, 2) \'+\' düğmesine dokunun, 3) Kategori seçin (Ürünler/Hizmetler/Emlak), 4) Fotoğraf ve açıklama ekleyin, 5) Fiyatınızı belirleyin, 6) Yayınlayın! Listelemeniz bölgenizdeki alıcılar tarafından görülebilecek.';

  @override
  String get faq_is_free => 'Tezsell\'in kullanımı ücretsiz mi?';

  @override
  String get faq_is_free_answer =>
      'Evet! Tezsell şu anda %100 ücretsizdir. Listeleme ücreti yok, satış komisyonu yok, abonelik ücreti yok. Gelecekte premium özellikler sunabiliriz ancak kullanıcıları 30 gün önceden bilgilendireceğiz.';

  @override
  String get faq_safety => 'Alırken / satarken nasıl güvende kalabilirim?';

  @override
  String get faq_safety_answer =>
      'Güvenlik ipuçları: 1) Halka açık yerlerde buluşun, 2) Ödeme yapmadan önce eşyaları inceleyin, 3) Asla yabancılara para göndermeyin, 4) İçgüdülerinize güvenin, 5) Şüpheli kullanıcıları bildirin, 6) Kişisel bilgilerinizi çok erken paylaşmayın, 7) Yüksek değerli işlemler için bir arkadaşınızı getirin.';

  @override
  String get faq_payment => 'Ödemeler nasıl çalışır?';

  @override
  String get faq_payment_answer =>
      'Tezsell ödemeleri işleme koymaz. Alıcılar ve satıcılar ödemeyi doğrudan (nakit, banka havalesi vb.) düzenlerler. Biz sadece insanları birbirine bağlayan bir platformuz; işlemi kendiniz halledersiniz.';

  @override
  String get faq_prohibited => 'Hangi öğeler yasaktır?';

  @override
  String get faq_prohibited_answer =>
      'Yasaklanan öğeler şunları içerir: silahlar, uyuşturucular, çalıntı ürünler, sahte ürünler, yetişkinlere yönelik içerik, canlı hayvanlar (izinsiz), resmi kimlikler ve tehlikeli malzemeler. Tam liste için Şartlar ve Koşullarımıza bakın.';

  @override
  String get faq_account_delete => 'Hesabımı nasıl silerim?';

  @override
  String get faq_account_delete_answer =>
      'Profil → Ayarlar → Hesap Ayarları → Hesabı Sil seçeneğine gidin. Not: Bu kalıcıdır ve geri alınamaz. Tüm ilanlarınız kaldırılacaktır.';

  @override
  String get faq_report_user =>
      'Bir kullanıcıyı veya girişi nasıl şikayet edebilirim?';

  @override
  String get faq_report_user_answer =>
      'Herhangi bir listede veya kullanıcı profilinde üç noktaya (•••) dokunun ve ardından \'Rapor Et\'i seçin. Nedenini seçin ve gönderin. Tüm raporları 24-48 saat içinde inceliyoruz.';

  @override
  String get faq_change_location => 'Konumumu nasıl değiştiririm?';

  @override
  String get faq_change_location_answer =>
      'Ana ekranın sol üst köşesindeki konum düğmesine dokunun. Bölgenizdeki ilanları görmek için bölgenizi ve ilçenizi seçebilirsiniz.';

  @override
  String get welcome_customer_center => 'Müşteri Merkezine Hoş Geldiniz';

  @override
  String get customer_center_subtitle =>
      '7/24 size yardımcı olmak için buradayız';

  @override
  String get quick_actions => 'Hızlı Eylemler';

  @override
  String get live_chat => 'Canlı Sohbet';

  @override
  String get chat_with_us => 'Bizimle sohbet edin';

  @override
  String get find_answers => 'Yanıtları bulun';

  @override
  String get my_tickets => 'Biletlerim';

  @override
  String get view_tickets => 'Biletleri görüntüle';

  @override
  String get feedback => 'Geri bildirim';

  @override
  String get share_feedback => 'Geri bildirimi paylaşın';

  @override
  String get contact_methods => 'İletişim Yöntemleri';

  @override
  String get phone_support => 'Telefon Desteği';

  @override
  String get available_247 => '7/24 ulaşılabilir';

  @override
  String get response_24h => '24 saat içinde yanıt';

  @override
  String get telegram_support => 'Telgraf Desteği';

  @override
  String get instant_replies => 'Anında yanıtlar';

  @override
  String get whatsapp_support => 'WhatsApp Desteği';

  @override
  String get quick_response => 'Hızlı yanıt';

  @override
  String get popular_topics => 'Popüler Konular';

  @override
  String get account_management => 'Hesap Yönetimi';

  @override
  String get reset_password => 'Şifreyi Sıfırla';

  @override
  String get update_profile => 'Profili Güncelle';

  @override
  String get verify_account => 'Hesabı Doğrula';

  @override
  String get delete_account => 'Hesabı Sil';

  @override
  String get buying_selling => 'Alış ve Satış';

  @override
  String get how_to_post => 'Reklam Nasıl Yayınlanır?';

  @override
  String get payment_methods => 'Ödeme Yöntemleri';

  @override
  String get shipping_delivery => 'Nakliye ve Teslimat';

  @override
  String get return_policy => 'İade politikasi';

  @override
  String get safety_security => 'Emniyet ve Güvenlik';

  @override
  String get report_scam => 'Dolandırıcılığı Bildir';

  @override
  String get safe_trading => 'Güvenli Ticaret İpuçları';

  @override
  String get privacy_settings => 'Gizlilik Ayarları';

  @override
  String get blocked_users => 'Engellenen Kullanıcılar';

  @override
  String get technical_issues => 'Teknik Sorunlar';

  @override
  String get app_not_working => 'Uygulama Çalışmıyor';

  @override
  String get upload_failed => 'Yükleme Başarısız';

  @override
  String get login_problems => 'Giriş Sorunları';

  @override
  String get support_hours => 'Destek Saatleri';

  @override
  String get mon_fri_9_6 => 'Pazartesi-Cuma: 09:00 - 18:00';

  @override
  String get how_are_we_doing => 'Nasılız?';

  @override
  String get rate_experience => 'Müşteri hizmetleri deneyiminizi değerlendirin';

  @override
  String get poor => 'Fakir';

  @override
  String get okay => 'Tamam';

  @override
  String get good => 'İyi';

  @override
  String get excellent => 'Harika';

  @override
  String get account_secure => 'Hesabınız Güvende';

  @override
  String get password_security => 'Şifre ve Kimlik Doğrulama';

  @override
  String get change_password => 'Şifre değiştir';

  @override
  String get two_factor_auth => 'İki Faktörlü Kimlik Doğrulama';

  @override
  String get biometric_login => 'Biyometrik Giriş';

  @override
  String get login_activity => 'Giriş Etkinliği';

  @override
  String get active_sessions => 'Aktif Oturumlar';

  @override
  String get login_alerts => 'Giriş Uyarıları';

  @override
  String get account_protection => 'Hesap Koruması';

  @override
  String get recovery_email => 'Kurtarma E-postası';

  @override
  String get backup_codes => 'Yedekleme Kodları';

  @override
  String get danger_zone => 'Tehlikeli Bölge';

  @override
  String get improve_security => 'Güvenliği Artırın';

  @override
  String get security_score => 'Güvenlik Puanı';

  @override
  String get last_changed_days => 'En son 30 gün önce değiştirildi';

  @override
  String get logout_all_devices => 'Tüm Cihazlardan Çıkış Yapın';

  @override
  String get end_all_sessions => 'Tüm oturumları sonlandır';

  @override
  String get permanently_delete => 'Kalıcı olarak sil';

  @override
  String get verification_code_message =>
      'Bu kişinin siz olduğunuzu doğrulamak için bir doğrulama kodu göndereceğiz.';

  @override
  String get send_code => 'Kodu Gönder';

  @override
  String get enter_verification_code => 'Doğrulama Kodunu Girin';

  @override
  String get verification_code => 'Doğrulama Kodu';

  @override
  String get new_password => 'Yeni Şifre';

  @override
  String get confirm_password => 'Şifreyi Onayla';

  @override
  String get resend_code => 'Kodu Yeniden Gönder';

  @override
  String get code_sent_to => 'adresine gönderilen doğrulama kodunu girin';

  @override
  String get enter_code => 'Doğrulama kodunu girin';

  @override
  String get code_must_be_6_digits => 'Kod 6 haneli olmalıdır';

  @override
  String get enter_new_password => 'Yeni şifreyi girin';

  @override
  String get minimum_8_characters => 'Minimum 8 karakter';

  @override
  String get passwords_do_not_match => 'Şifreler eşleşmiyor';

  @override
  String get close => 'Kapalı';

  @override
  String get current => 'Akım';

  @override
  String get session_ended => 'Oturum sona erdi';

  @override
  String get update_recovery_email => 'Kurtarma E-postasını Güncelle';

  @override
  String get new_email => 'Yeni E-posta';

  @override
  String get update => 'Güncelleme';

  @override
  String get verification_email_sent => 'Doğrulama e-postası gönderildi';

  @override
  String get generate_emergency_codes => 'Acil durum kodları oluşturun';

  @override
  String get copy_all => 'Tümünü Kopyala';

  @override
  String get code_copied => 'Kod kopyalandı';

  @override
  String get all_codes_copied => 'Tüm kodlar kopyalandı';

  @override
  String get logout_all_devices_confirm => 'Tüm Cihazlardan Çıkış Yapılsın mı?';

  @override
  String get logout_all_devices_message =>
      'Bu, tüm cihazlardaki tüm etkin oturumları sonlandıracaktır.';

  @override
  String get logout_all => 'Tümünden çıkış yap';

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
  String get delete_account_confirm => 'Hesap Silinsin mi?';

  @override
  String get delete_account_warning =>
      'Bu işlem KALICIDIR ve geri alınamaz. Tüm verileriniz kalıcı olarak silinecektir.';

  @override
  String get what_will_be_deleted => 'Neler silinecek:';

  @override
  String get profile_and_account_info => '• Profiliniz ve hesap bilgileriniz';

  @override
  String get all_listings_and_posts => '• Tüm ilanlarınız ve yayınlarınız';

  @override
  String get messages_and_conversations => 'Mesajlar';

  @override
  String get saved_items_and_preferences => '• Kaydedilen öğeler ve tercihler';

  @override
  String get enter_password_to_continue => 'Devam etmek için şifrenizi girin';

  @override
  String get continue_val => 'Devam etmek';

  @override
  String get please_enter_password => 'Lütfen şifrenizi girin';

  @override
  String get enter_confirmation_code => 'Onay kodunu girin';

  @override
  String get deletion_confirmation_message =>
      'Telefonunuza bir onay kodu gönderdik. Hesabınızı kalıcı olarak silmek için aşağıya girin.';

  @override
  String get confirmation_code => 'Onay Kodu';

  @override
  String get please_enter_6_digit_code => 'Lütfen 6 haneli kodu giriniz';

  @override
  String get account_deleted => 'Hesabınız silindi';

  @override
  String get deletion_cancelled => 'Silme işlemi iptal edildi';

  @override
  String get failed_to_load_user_info => 'Kullanıcı bilgileri yüklenemedi';

  @override
  String get auth_login_to_view_saved =>
      'Kayıtlı mülklerinizi görüntülemek için lütfen giriş yapın';

  @override
  String get authLoginRequired => 'Giriş Gerekli';

  @override
  String get authLoginToViewSaved =>
      'Kayıtlı mülklerinizi görüntülemek için lütfen giriş yapın';

  @override
  String get authLogin => 'Giriş yapmak';

  @override
  String get savedPropertiesTitle => 'Kaydedilen Özellikler';

  @override
  String get loadingSavedProperties => 'Kaydedilen özellikler yükleniyor...';

  @override
  String get errorsFailedToLoadSaved => 'Kaydedilen özellikler yüklenemedi';

  @override
  String get actionsRetry => 'Yeniden dene';

  @override
  String get savedPropertiesNoSaved => 'Kaydedilmiş Mülk Yok';

  @override
  String get savedPropertiesStartSaving =>
      'Beğendiğiniz mülkleri keşfetmeye ve kaydetmeye başlayın';

  @override
  String get savedPropertiesBrowse => 'Özelliklere Göz Atın';

  @override
  String get resultsSavedProperties => 'kayıtlı özellikler';

  @override
  String get actionsRefresh => 'Yenile';

  @override
  String get resultsNoMoreProperties => 'Başka mülk yok';

  @override
  String get propertyCardFeatured => 'Öne Çıkanlar';

  @override
  String get successPropertyUnsaved => 'Kaydedilen listeden mülk kaldırıldı';

  @override
  String get alertsUnsavePropertyFailed => 'Mülk kaldırılamadı';

  @override
  String get propertyCardBed => 'yatak';

  @override
  String get propertyCardBath => 'banyo';

  @override
  String get savedPropertiesSavedOn => 'Kayıt tarihi';

  @override
  String get propertyCardViewDetails => 'Ayrıntıları Görüntüle';

  @override
  String get serviceDetailTitle => 'Hizmet Detayı';

  @override
  String get errorLoadingFavorites => 'Favori öğeler yüklenirken hata oluştu';

  @override
  String get noFavoritesFound => 'Favori öğe bulunamadı.';

  @override
  String get commentUpdatedSuccess => 'Yorum başarıyla güncellendi!';

  @override
  String get errorUpdatingComment => 'Yorum güncellenirken hata oluştu';

  @override
  String get replyAddedSuccess => 'Yanıt başarıyla eklendi!';

  @override
  String get errorAddingReply => 'Yanıt eklenirken hata oluştu';

  @override
  String get commentDeletedSuccess => 'Yorum başarıyla silindi!';

  @override
  String get errorDeletingComment => 'Yorum silinirken hata oluştu';

  @override
  String get serviceLikedSuccess => 'Hizmet başarıyla beğenildi!';

  @override
  String get errorLikingService => 'Hizmet beğenilirken hata oluştu';

  @override
  String get serviceDislikedSuccess => 'Hizmet başarıyla beğenilmedi!';

  @override
  String get errorDislikingService => 'Hizmet beğenilmezken hata oluştu';

  @override
  String get writeYourReply => 'Cevabınızı yazın...';

  @override
  String get postReply => 'Yanıt Gönder';

  @override
  String get anonymous => 'Anonim';

  @override
  String get editComment => 'Yorumu Düzenle';

  @override
  String get editYourComment => 'Yorumunuzu düzenleyin...';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get propertyOwner => 'Mülk Sahibi';

  @override
  String get errorLoadingServices => 'Hizmetler yüklenirken hata oluştu';

  @override
  String get noRecommendedServicesFound => 'Önerilen hizmet bulunamadı.';

  @override
  String get passwordRequired => 'Şifre gerekli';

  @override
  String get passwordTooShort => 'Şifre en az 8 karakter olmalıdır';

  @override
  String get passwordRequirements => 'Şifre harf ve rakamlardan oluşmalıdır';

  @override
  String get usernameRequired => 'Kullanıcı adı gerekli';

  @override
  String get usernameTooShort =>
      'Kullanıcı adı en az 3 karakterden oluşmalıdır';

  @override
  String get confirmPasswordRequired => 'Şifre onayı gerekli';

  @override
  String get passwordHelp => 'En az 8 karakter, harf ve rakam';

  @override
  String get usernameExists => 'Bu kullanıcı adı zaten mevcut';

  @override
  String get phoneExists => 'Bu telefon numarası zaten kayıtlı';

  @override
  String get networkError =>
      'Ağ bağlantısı hatası. Lütfen bağlantınızı kontrol edin';

  @override
  String get contactSeller => 'Satıcıyla İletişime Geçin';

  @override
  String get callToReveal => 'Ortaya çıkarmak için \"Ara\"ya dokunun';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get selectImageSource => 'Görüntü Kaynağını Seçin';

  @override
  String get uploading => 'Yükleniyor...';

  @override
  String get acceptTermsRequired =>
      'Devam etmek için Şartlar ve Koşulları kabul etmelisiniz';

  @override
  String get iAgreeToTerms => 'katılıyorum';

  @override
  String get termsAndConditions => 'Şartlar ve koşullar';

  @override
  String get zeroToleranceStatement =>
      've sakıncalı içeriğe veya kötü niyetli kullanıcılara karşı sıfır tolerans olduğunu anlayın.';

  @override
  String get viewTerms => 'Şartlar ve Koşulları Görüntüle';

  @override
  String get reportContent => 'İçeriği Bildir';

  @override
  String get selectReportReason => 'Lütfen raporlama nedenini seçin:';

  @override
  String get additionalDetails => 'Ek ayrıntılar (isteğe bağlı)';

  @override
  String get reportDetailsHint => 'Herhangi bir ek bilgi sağlayın...';

  @override
  String get reportSubmitted =>
      'Raporunuz için teşekkür ederiz. 24 saat içinde inceleyeceğiz.';

  @override
  String get reportProduct => 'Ürünü Bildir';

  @override
  String get reportService => 'Rapor Hizmeti';

  @override
  String get reportMessage => 'Rapor Mesajı';

  @override
  String get reportUser => 'Kullanıcıyı Bildir';

  @override
  String get reportErrorNotImplemented =>
      'Raporlama özelliği henüz mevcut değil. Lütfen destek ekibiyle iletişime geçin veya daha sonra tekrar deneyin.';

  @override
  String get reportAlreadySubmitted =>
      'Bu içeriği zaten bildirmiştiniz. Önceki raporunuzu inceliyoruz.';

  @override
  String get reportFailedGeneric =>
      'Rapor gönderilemedi. Lütfen tekrar deneyin.';

  @override
  String get reportFailedNetwork =>
      'Ağ hatası oluştu. Lütfen bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get becomeAgentTitle => 'Emlakçı olarak katılın';

  @override
  String get becomeAgentSubtitle =>
      'Gayrimenkulleri listeleyin ve müşterilerin hayallerindeki evleri bulmalarına yardımcı olun';

  @override
  String get agentBenefits => 'Faydalar:';

  @override
  String get agentBenefitVerified => 'Doğrulanmış temsilci rozeti';

  @override
  String get agentBenefitAnalytics => 'Analitiklere ve içgörülere erişim';

  @override
  String get agentBenefitClients => 'Potansiyel müşterilerle doğrudan iletişim';

  @override
  String get agentBenefitReputation => 'Mesleki itibarınızı geliştirin';

  @override
  String get agentApplicationForm => 'Başvuru Formu';

  @override
  String get agentAgencyName => 'Ajans Adı';

  @override
  String get agentAgencyNameHint => 'Emlak acentenizin adını girin';

  @override
  String get agentAgencyNameRequired => 'Ajans adı gerekli';

  @override
  String get agentLicenceNumber => 'Lisans Numarası';

  @override
  String get agentLicenceNumberHint => 'Gayrimenkul lisans numaranızı girin';

  @override
  String get agentLicenceNumberRequired => 'Lisans numarası gerekli';

  @override
  String get agentYearsExperience => 'Yılların Deneyimi';

  @override
  String get agentYearsExperienceHint => 'Yıl sayısını girin';

  @override
  String get agentYearsExperienceRequired => 'Yılların tecrübesi gerekiyor';

  @override
  String get agentYearsExperienceInvalid => 'Lütfen geçerli bir numara girin';

  @override
  String get agentSpecialization => 'Uzmanlık';

  @override
  String get agentApplicationNote =>
      'Başvurunuz ekibimiz tarafından incelenecektir. Başvurunuz onaylandığında tarafınıza bilgi verilecektir.';

  @override
  String get agentSubmitApplication => 'Başvuruyu Gönder';

  @override
  String get agentApplicationSubmitted =>
      'Başvuru başarıyla gönderildi! Yakında gözden geçireceğiz.';

  @override
  String get agentApplicationStatus => 'Başvuru Durumu';

  @override
  String get agentViewProfile => 'Temsilci profilinizi görüntüleyin';

  @override
  String get agentDashboardComingSoon => 'Temsilci kontrol paneli çok yakında!';

  @override
  String get property_create_basic_information => 'Temel Bilgiler';

  @override
  String get property_create_property_title => 'Mülkiyet Başlığı *';

  @override
  String get property_create_property_title_hint =>
      'ör. Şehir Merkezinde Modern 3BR Daire';

  @override
  String get property_create_property_title_required =>
      'Lütfen mülkün başlığını girin';

  @override
  String get property_create_description => 'Tanım *';

  @override
  String get property_create_description_hint =>
      'Gayrimenkulünüzü ayrıntılı olarak tanımlayın...';

  @override
  String get property_create_description_required => 'Lütfen açıklamayı girin';

  @override
  String get property_create_property_type => 'Emlak Tipi';

  @override
  String get property_create_property_type_required => 'Gayrimenkul Türü *';

  @override
  String get property_create_listing_type_required => 'İlan Türü *';

  @override
  String get property_create_pricing => 'Fiyatlandırma';

  @override
  String get property_create_price => 'Fiyat *';

  @override
  String get property_create_price_hint => 'Fiyatı girin';

  @override
  String get property_create_price_required => 'Lütfen fiyatı girin';

  @override
  String get property_create_currency => 'Para birimi';

  @override
  String get property_create_property_details => 'Emlak Detayları';

  @override
  String get property_create_square_meters => 'meydan Metre *';

  @override
  String get property_create_bedrooms => 'Yatak odaları *';

  @override
  String get property_create_bathrooms => 'Banyolar *';

  @override
  String get property_create_floor => 'Zemin';

  @override
  String get property_create_total_floors => 'Toplam Kat Sayısı';

  @override
  String get property_create_parking => 'Otopark';

  @override
  String get property_create_year_built => 'Yapım Yılı';

  @override
  String get property_create_location => 'Konum';

  @override
  String get property_create_address => 'Adres *';

  @override
  String get property_create_address_hint => 'Mülk adresini girin';

  @override
  String get property_create_address_required => 'Lütfen adresi girin';

  @override
  String get property_create_location_detected => 'Konum Algılandı';

  @override
  String get property_create_get_location => 'Mevcut Konumu Al';

  @override
  String get property_create_features => 'Özellikler';

  @override
  String get property_create_feature_balcony => 'Balkon';

  @override
  String get property_create_feature_garage => 'Garaj';

  @override
  String get property_create_feature_garden => 'Bahçe';

  @override
  String get property_create_feature_pool => 'Havuz';

  @override
  String get property_create_feature_elevator => 'Asansör';

  @override
  String get property_create_feature_furnished => 'Mobilyalı';

  @override
  String get property_create_images => 'Emlak Görselleri';

  @override
  String get property_create_tap_to_add_images => 'Resim eklemek için dokunun';

  @override
  String get property_create_at_least_one_image => 'En az 1 resim gerekli';

  @override
  String get property_create_add_more => 'Daha Fazla Ekle';

  @override
  String get property_create_required => 'Gerekli';

  @override
  String get property_create_location_required =>
      'Mülk oluşturmak için lütfen konum hizmetlerini etkinleştirin';

  @override
  String get property_create_image_required => 'En az bir mülk resmi gerekli';

  @override
  String get emailVerification => 'E-posta Doğrulaması';

  @override
  String get pleaseEnterYourEmailAddress => 'Lütfen e-posta adresinizi girin';

  @override
  String get enterEmailAddress => 'E-posta adresini girin';

  @override
  String get resetYourPassword => 'Şifrenizi Sıfırlayın';

  @override
  String get resetPasswordDescription =>
      'E-posta adresinizi girin, şifrenizi sıfırlamak için size bir doğrulama kodu göndereceğiz.';

  @override
  String get sendVerificationCode => 'Doğrulama Kodunu Gönder';

  @override
  String get backToLogin => 'Girişe Geri Dön';

  @override
  String get resetPassword => 'Şifreyi Sıfırla';

  @override
  String enterVerificationCodeSentTo(String email) {
    return '$email adresine gönderilen doğrulama kodunu girin';
  }

  @override
  String get codeMustBe6Digits => 'Kod 6 haneli olmalıdır';

  @override
  String get enterNewPassword => 'Yeni şifreyi girin';

  @override
  String get minimum8Characters => 'Minimum 8 karakter';

  @override
  String get sending => 'Gönderiliyor...';

  @override
  String get verifying => 'Doğrulanıyor...';

  @override
  String get new_message => 'Yeni Mesaj';

  @override
  String get messages => 'Mesajlar';

  @override
  String get please_log_in => 'Mesajları görüntülemek için lütfen giriş yapın';

  @override
  String get pin => 'Sabitle';

  @override
  String get unpin => 'Sabitlemeyi kaldır';

  @override
  String get delete_chat => 'Sohbeti Sil';

  @override
  String delete_chat_confirm(String name) {
    return '$name ile olan sohbeti silmek istediğinizden emin misiniz? Bu eylem geri alınamaz.';
  }

  @override
  String chat_deleted(String name) {
    return '$name ile sohbet silindi';
  }

  @override
  String get delete_failed => 'Sohbet silinemedi';

  @override
  String get no_conversations => 'Henüz görüşme yok';

  @override
  String get start_conversation_hint =>
      '+ düğmesine dokunarak bir konuşma başlatın';

  @override
  String get start_conversation => 'Konuşma Başlat';

  @override
  String get yesterday => 'Dün';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get no_messages_yet => 'Henüz mesaj yok';

  @override
  String get unblock_user => 'Kullanıcının Engelini Kaldır';

  @override
  String get block_user => 'Kullanıcıyı Engelle';

  @override
  String get no_blocked_users => 'Engellenen kullanıcı yok';

  @override
  String get blocked_users_hint =>
      'Engellediğiniz kullanıcılar burada görünecek';

  @override
  String unblock_user_confirm(String username) {
    return '$username engellemesini kaldırmak istediğinizden emin misiniz? Onlardan tekrar mesaj alabileceksiniz.';
  }

  @override
  String user_unblocked(String username) {
    return '$username engellemesi kaldırıldı';
  }

  @override
  String user_blocked(String username) {
    return '$username engellendi';
  }

  @override
  String get failed_to_unblock => 'Kullanıcının engellemesi kaldırılamadı';

  @override
  String get failed_to_block => 'Kullanıcı engellenemedi';

  @override
  String get chat_info => 'Sohbet Bilgileri';

  @override
  String get delete_message => 'Mesajı Sil';

  @override
  String get delete_message_confirm =>
      'Bu mesajı silmek istediğinizden emin misiniz?';

  @override
  String get typing => 'yazarak...';

  @override
  String get online => 'çevrimiçi';

  @override
  String get offline => 'çevrimdışı';

  @override
  String last_seen_at(String time) {
    return 'son görülme tarihi $time';
  }

  @override
  String participants(int count) {
    return '$count katılımcılar';
  }

  @override
  String get you_are_blocked => 'Engellendin';

  @override
  String user_blocked_you(String username) {
    return '$username seni engelledi. Mesaj gönderemezsiniz.';
  }

  @override
  String you_blocked_user(String username) {
    return '$username adlı kişiyi engellediniz';
  }

  @override
  String get cannot_send_messages_blocked =>
      'Mesaj gönderemezsiniz. Engellendin.';

  @override
  String get this_message_was_deleted => 'Bu mesaj silindi';

  @override
  String get edit => 'Düzenlemek';

  @override
  String get reply => 'Cevap vermek';

  @override
  String get editing_message => 'Mesaj düzenleniyor';

  @override
  String replying_to(String username) {
    return '$username yanıtlanıyor';
  }

  @override
  String get voice => 'Ses';

  @override
  String get emoji => 'Emoji';

  @override
  String get photo => '📷 Fotoğraf';

  @override
  String get voice_message => '🎤 Sesli mesaj';

  @override
  String get searching => 'Arama...';

  @override
  String get loading_users => 'Kullanıcılar yükleniyor...';

  @override
  String search_failed(String error) {
    return 'Arama başarısız oldu: $error';
  }

  @override
  String get invalid_user_data => 'Geçersiz kullanıcı verileri';

  @override
  String failed_to_start_chat(String error) {
    return 'Sohbet başlatılamadı: $error';
  }

  @override
  String get audio_file_not_available => 'Ses dosyası mevcut değil';

  @override
  String failed_to_play_audio(String error) {
    return 'Ses çalınamadı: $error';
  }

  @override
  String get image_unavailable => 'Resim kullanılamıyor';

  @override
  String get image_too_large => '❌ Resim çok büyük. Maksimum boyut 10MB';

  @override
  String get image_file_not_found => '❌ Resim dosyası bulunamadı';

  @override
  String get uploading_image => 'Resim yükleniyor...';

  @override
  String get image_sent => '✅ Resim gönderildi!';

  @override
  String get failed_to_send_image => '❌ Resim gönderilemedi';

  @override
  String get uploading_voice_message => 'Sesli mesaj yükleniyor...';

  @override
  String get voice_message_sent => '✅ Sesli mesaj gönderildi!';

  @override
  String get failed_to_send_voice_message => '❌ Sesli mesaj gönderilemedi';

  @override
  String get recording => '🎙️ Kaydediliyor...';

  @override
  String get microphone_permission_denied => 'Mikrofon izni reddedildi';

  @override
  String get starting_chat => 'Sohbet başlatılıyor...';

  @override
  String get refresh_users => 'Kullanıcıları yenile';

  @override
  String get search_by_username_or_phone =>
      'Kullanıcı adına veya telefon numarasına göre arayın';

  @override
  String get no_users_found => 'Kullanıcı bulunamadı';

  @override
  String get try_different_search_term => 'Farklı bir arama terimi deneyin';

  @override
  String get no_users_available => 'Kullanılabilir kullanıcı yok';

  @override
  String get chat_exists => 'Sohbet mevcut';

  @override
  String block_user_confirm(String username) {
    return '$username\'yi engellemek istediğinizden emin misiniz? Onlardan mesaj almayacaksınız ve sohbet listenizden kaldırılacaklar.';
  }

  @override
  String chat_room_label(String name) {
    return 'Sohbet Odası: $name';
  }

  @override
  String id_label(int id) {
    return 'Kimlik: $id';
  }

  @override
  String get participants_label => 'Katılımcılar:';

  @override
  String get type_a_message => 'Bir mesaj yazın...';

  @override
  String get edit_message_hint => 'Mesajı düzenle...';

  @override
  String error_label(String error) {
    return 'Hata: $error';
  }

  @override
  String get copy => 'Kopyala';

  @override
  String comments_title(int count) {
    return 'Yorumlar ($count)';
  }

  @override
  String get reply_button => 'Cevap vermek';

  @override
  String replies_count(int count) {
    return '$count yanıtlar';
  }

  @override
  String get you_label => 'Sen';

  @override
  String get delete_reply_title => 'Yanıtı Sil';

  @override
  String get delete_comment_title => 'Yorumu Sil';

  @override
  String get unknown_date => 'Bilinmeyen Tarih';

  @override
  String get press_enter_to_send => 'Göndermek için Enter\'a basın';

  @override
  String get comment_add_error => 'Yorum eklenemedi';

  @override
  String get service_provider => 'Servis Sağlayıcı';

  @override
  String get opening_chat => 'Sohbet açılıyor...';

  @override
  String get failed_to_refresh => 'Yenilenemedi';

  @override
  String get cannot_chat_with_yourself => 'Kendinizle sohbet edemezsiniz';

  @override
  String opening_chat_with(String username) {
    return '$username ile sohbet açılıyor...';
  }

  @override
  String get this_will_only_take_a_moment => 'Bu sadece bir dakikanızı alacak';

  @override
  String get unable_to_start_chat =>
      'Sohbet başlatılamıyor. Lütfen tekrar deneyin.';

  @override
  String get profile_listings => 'İlanlar';

  @override
  String get profile_followers => 'Takipçiler';

  @override
  String get profile_following => 'Takip etme';

  @override
  String get profile_no_products => 'Ürün yok';

  @override
  String get profile_no_services => 'Hizmet yok';

  @override
  String get profile_no_properties => 'Mülk yok';

  @override
  String get profile_user_no_products =>
      'Bu kullanıcı henüz herhangi bir ürün yayınlamadı';

  @override
  String get profile_user_no_services =>
      'Bu kullanıcı henüz herhangi bir hizmet yayınlamadı';

  @override
  String get profile_user_no_properties =>
      'Bu kullanıcı henüz herhangi bir mülk yayınlamadı';

  @override
  String get profile_error_occurred => 'Hata oluştu';

  @override
  String get profile_error_loading_products =>
      'Ürünler yüklenirken hata oluştu';

  @override
  String get profile_error_loading_services =>
      'Hizmetler yüklenirken hata oluştu';

  @override
  String get profile_no_followers_yet => 'Henüz takipçi yok';

  @override
  String get profile_no_following_yet => 'Henüz kimseyi takip etmiyorum';

  @override
  String get profile_follow => 'Takip etmek';

  @override
  String get profile_following_btn => 'Takip etme';

  @override
  String get profile_message => 'Mesaj';

  @override
  String get profile_member_since => 'Şu tarihten beri üye:';

  @override
  String get profile_loading_error => 'Profil yüklenirken hata oluştu';

  @override
  String get profile_retry => 'Tekrar deneyin';

  @override
  String get profile_share => 'Paylaşmak';

  @override
  String get profile_copy_link => 'Bağlantıyı kopyala';

  @override
  String get profile_report => 'Rapor';

  @override
  String profile_reviews_count(int count) {
    return 'Reviews ($count)';
  }

  @override
  String get profile_no_reviews_yet => 'No reviews yet';

  @override
  String get profile_user_no_reviews =>
      'This user hasn\'t received any reviews yet';

  @override
  String get profile_no_given_reviews => 'You haven\'t given any reviews yet';

  @override
  String get no_more_reviews => 'No more reviews to load';

  @override
  String get myReviewsTitle => 'My Reviews';

  @override
  String get myReviewsSubtitle => 'Reviews you\'ve given and received';

  @override
  String get myReviewsReceivedTab => 'Received';

  @override
  String get myReviewsGivenTab => 'Given';

  @override
  String pendingReviewsNudgeTitle(int count) {
    return 'Pending reviews ($count)';
  }

  @override
  String get pendingReviewsNudgeSubtitle => 'Tap to rate your recent trades';

  @override
  String get pendingReviewsSheetTitle => 'Pending Reviews';

  @override
  String get sellerAnalyticsTitle => 'Seller Analytics';

  @override
  String get sellerAnalyticsSubtitle =>
      'Track views, offers, and sales performance';

  @override
  String get linkCopied => 'Bağlantı panoya kopyalandı';

  @override
  String get checkOutProfile => 'Çıkış yapmak';

  @override
  String get onTezsell => 'TezSell\'de';

  @override
  String get selectCountryFirst => 'Önce ülkeyi seçin';

  @override
  String get countrySelectionHint => 'Daha sonra bölgenizi seçebilirsiniz';

  @override
  String get something_went_wrong => 'Bir şeyler ters gitti';

  @override
  String get check_connection_and_retry =>
      'Lütfen internet bağlantınızı kontrol edip tekrar deneyin';

  @override
  String get sold_badge => 'SATILMIŞ';

  @override
  String get reserved_badge => 'RESERVED';

  @override
  String get recently_viewed_title => 'Recently viewed';

  @override
  String get more_categories => 'Daha';

  @override
  String no_products_in_location(String location) {
    return '$location\'da ürün bulunamadı';
  }

  @override
  String get no_more_products => 'Yüklenecek başka ürün yok';

  @override
  String time_days_ago(int count) {
    return '${count}d önce';
  }

  @override
  String time_hours_ago(int count) {
    return '${count}h önce';
  }

  @override
  String time_minutes_ago(int count) {
    return '${count}m önce';
  }

  @override
  String get time_just_now => 'Şu anda';

  @override
  String no_services_in_location(String location) {
    return '$location\'da hizmet bulunamadı';
  }

  @override
  String get no_more_services => 'Yüklenecek başka hizmet yok';

  @override
  String get error_loading_more_services =>
      'Daha fazla hizmet yüklenirken hata oluştu';

  @override
  String get verification_code_length => 'Doğrulama kodu 6 haneli olmalıdır';

  @override
  String get map_register_title => 'Nerede yaşıyorsun';

  @override
  String get map_register_headline => 'Haritadan mahallenizi seçin';

  @override
  String get map_register_subtitle =>
      'Size yakındaki alıcıları ve satıcıları göstermek için kullanıyoruz. Yarıçapınızı daha sonra ayarlayabilirsiniz.';

  @override
  String get pick_on_map => 'Haritada seç';

  @override
  String get pick_again => 'Tekrar seç';

  @override
  String get resolving_location => 'Konum çözümleniyor…';

  @override
  String get use_dropdown_instead => 'Bunun yerine açılır menüyü kullanın';

  @override
  String country_not_supported(String country) {
    return 'Henüz $country\'ı desteklemiyoruz.';
  }

  @override
  String get region_not_auto_detected =>
      'Bölgeniz otomatik olarak algılanamadı; manuel olarak seçin.';

  @override
  String get district_not_auto_detected =>
      'Bölgeniz otomatik olarak algılanamadı; manuel olarak seçin.';

  @override
  String get browse_no_items_with_location =>
      'Bu alanda henüz konum verisi olan öğe yok.';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => 'Konumu ayarla';

  @override
  String get location_picker_confirm => 'Konumu onayla';

  @override
  String get location_picker_resolve_failed =>
      'Adres çözülemedi; tekrar seçin veya yalnızca koordinatlarla onaylayın';

  @override
  String get location_picker_selected_fallback => 'Seçilen konum';

  @override
  String get location_permission_denied => 'Konum izni reddedildi';

  @override
  String get location_permission_denied_settings =>
      'Konum izni reddedildi — lütfen Ayarlar\'dan etkinleştirin';

  @override
  String get location_permission_permanent =>
      'Konum kalıcı olarak reddedildi; etkinleştirmek için Ayarlar\'ı açın';

  @override
  String gps_error(String error) {
    return 'GPS hatası: $error';
  }

  @override
  String get verify_neighborhood_title => 'Mahallenizi doğrulayın';

  @override
  String get verify_neighborhood_subtitle =>
      'Mahallenizde durun. GPS\'inizi kontrol edip onaylamanızı isteyeceğiz.';

  @override
  String get verify_neighborhood_button => 'Mahalleyi Doğrula';

  @override
  String get verify_neighborhood_low_confidence => 'Düşük güvenle devam edin';

  @override
  String get verify_neighborhood_retry => 'Yeniden dene';

  @override
  String get verify_neighborhood_youre_in => 'Şuradasınız:';

  @override
  String verify_neighborhood_done(String name) {
    return 'Doğrulandı! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'GPS doğruluğu ${meters}m\'dir (≤100m gerekir). Açık bir alana geçin ve tekrar deneyin.';
  }

  @override
  String get neighborhood_not_identified =>
      'Bulunduğunuz yerin mahallesi belirlenemedi.';

  @override
  String get unknown_error => 'Bilinmeyen hata';

  @override
  String get place_search_hint => 'Bir adres veya yer arayın';

  @override
  String get place_search_unavailable =>
      'Arama kullanılamıyor; bunun yerine bir raptiye bırakın';

  @override
  String get radius_slider_city => 'Şehir';

  @override
  String radius_slider_km(String value) {
    return '$value km';
  }

  @override
  String get my_neighborhoods => 'Mahallelerim';

  @override
  String get manage_on_map => 'Haritada yönet';

  @override
  String get no_neighborhoods_yet =>
      'Henüz doğrulanmış mahalle yok. Nerede olduğunuzu doğrulamak için haritayı açın.';

  @override
  String get open_map_to_verify => 'Yeni konumu doğrulamak için haritayı açın';

  @override
  String get verify_here => 'Burayı doğrula';

  @override
  String get verify_new_location => 'Yeni konumu doğrula';

  @override
  String eviction_warning(String name) {
    return 'Bu konum eklendiğinde $name (en eskisi) kaldırılacaktır. Bu işlem geri alınamaz.';
  }

  @override
  String get verified_today => 'Bugün doğrulandı';

  @override
  String get verified_yesterday => 'Dün doğrulandı';

  @override
  String verified_n_days_ago(int days) {
    return '$days gün önce doğrulandı';
  }

  @override
  String get active_neighborhood => 'Aktif';

  @override
  String switch_neighborhood_success(String name) {
    return '$name konumuna geçildi';
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

  @override
  String get reviewWriteResolveError =>
      'We couldn\'t load this transaction. Please try again.';

  @override
  String get reviewWriteRetry => 'Retry';
}
