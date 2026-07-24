// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get sessionExpired => 'Sesi Anda telah berakhir. Silakan masuk lagi.';

  @override
  String get welcome => 'Selamat datang';

  @override
  String get welcomeBack => 'Selamat Datang kembali!';

  @override
  String get loginToYourAccount => 'Masuk untuk melanjutkan';

  @override
  String get or => 'ATAU';

  @override
  String get dontHaveAccount => 'Belum punya akun?';

  @override
  String get chooseLanguage => 'Pilih Bahasa Anda';

  @override
  String get selectPreferredLanguage =>
      'Pilih bahasa pilihan Anda untuk aplikasi';

  @override
  String get continueButton => 'Melanjutkan';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get continueWithApple => 'Lanjutkan dengan Apple';

  @override
  String get continueWithEmail => 'Lanjutkan dengan Email';

  @override
  String get sellAndBuyProducts => 'Jual dan beli produk Anda hanya di kami';

  @override
  String get usedProductsMarket => 'Produk bekas atau pasar bekas';

  @override
  String get home_welcome_title => 'Pasar lingkungan Anda';

  @override
  String get home_welcome_subtitle =>
      'Beli dan jual dengan orang terdekat.\nAman, sederhana, dan lokal.';

  @override
  String get home_get_started => 'Memulai';

  @override
  String get home_sign_in => 'Saya sudah memiliki akun';

  @override
  String get home_terms_notice =>
      'Dengan melanjutkan, Anda menyetujui Ketentuan Layanan dan Kebijakan Privasi kami';

  @override
  String get register => 'Daftar';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun';

  @override
  String get login => 'Login';

  @override
  String get loginToAccount => 'Masuk ke Akun';

  @override
  String get enterPhoneNumber => 'Masukkan nomor telepon';

  @override
  String get password => 'Kata sandi';

  @override
  String get enterPassword => 'Masukkan kata sandi';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get registerNow => 'Daftar Sekarang';

  @override
  String get loading => 'Memuat...';

  @override
  String get pleaseEnterPhoneNumber => 'Silakan masukkan nomor telepon Anda';

  @override
  String get pleaseEnterPassword => 'Silakan masukkan kata sandi Anda';

  @override
  String get unexpectedError =>
      'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';

  @override
  String get forgotPasswordComingSoon => 'Fitur lupa kata sandi segera hadir';

  @override
  String get selectedCountryLabel => 'Terpilih:';

  @override
  String get fullPhoneLabel => 'Penuh:';

  @override
  String get home => 'Rumah';

  @override
  String get settings => 'Pengaturan';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Mencari';

  @override
  String get notifications => 'Pemberitahuan';

  @override
  String get error => 'Kesalahan';

  @override
  String get retry => 'Mencoba kembali';

  @override
  String get cancel => 'Membatalkan';

  @override
  String get save => 'Menyimpan';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Silakan pilih wilayah Anda';

  @override
  String get searchHint => 'Cari kabupaten atau kota';

  @override
  String get apiError => 'Terjadi masalah saat memanggil API';

  @override
  String get ok => 'OKE';

  @override
  String get emptyList => 'Daftar Kosong';

  @override
  String get dataLoadingError => 'Ada kesalahan saat memuat data';

  @override
  String get confirm => 'Mengonfirmasi';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'TIDAK';

  @override
  String confirmRegionSelection(Object regionName) {
    return 'Apakah Anda ingin memilih wilayah $regionName?';
  }

  @override
  String get selectDistrictOrCity => 'Silakan pilih kabupaten atau kota Anda';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return 'Apakah Anda ingin memilih wilayah $regionName - $districtName?';
  }

  @override
  String get noResultsFound => 'Tidak ada hasil yang ditemukan.';

  @override
  String errorWithCode(String errorCode) {
    return 'Kesalahan: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'Gagal memuat data. Kesalahan: $error';
  }

  @override
  String get phoneVerification => 'Verifikasi Nomor Telepon';

  @override
  String get enterPhonePrompt => 'Silakan masukkan nomor telepon Anda';

  @override
  String get enterPhoneNumberHint => 'Masukkan nomor telepon';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Dipilih: $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'Pilih negara Anda';

  @override
  String get changeCountry => 'Ganti negara';

  @override
  String get country => 'Negara';

  @override
  String get allCountries => 'Semua negara';

  @override
  String get currencyRUB => 'Rubel Rusia';

  @override
  String get currencyUAH => 'Hryvnia Ukraina';

  @override
  String get currencyBYN => 'Rubel Belarusia';

  @override
  String get currencyMDL => 'Leu Moldova';

  @override
  String get currencyGEL => 'Lari Georgia';

  @override
  String get currencyAMD => 'Drama Armenia';

  @override
  String get currencyAZN => 'Manat Azerbaijan';

  @override
  String get currencyKZT => 'Tenge Kazakstan';

  @override
  String get currencyTMT => 'Manat Turkmenistan';

  @override
  String get currencyKGS => 'Som Kirgistan';

  @override
  String get currencyTJS => 'Somoni Tajikistan';

  @override
  String get currencyUZS => 'Som Uzbekistan';

  @override
  String get currencyUSD => 'Dolar AS';

  @override
  String get currencyEUR => 'Euro';

  @override
  String fullNumber(String phoneNumber) {
    return 'Nomor lengkap: $phoneNumber';
  }

  @override
  String get sendCode => 'Kirim Kode';

  @override
  String get enterVerificationCode => 'Masukkan kode verifikasi';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Kirim Ulang Kode';

  @override
  String expires(String time) {
    return 'Kedaluwarsa: $time';
  }

  @override
  String get verifyAndContinue => 'Verifikasi dan Lanjutkan';

  @override
  String get invalidVerificationCode => 'Kode verifikasi tidak valid';

  @override
  String get verificationCodeSent => 'Kode verifikasi berhasil dikirim';

  @override
  String get failedToSendCode => 'Gagal mengirim kode verifikasi';

  @override
  String get verificationCodeResent => 'Kode verifikasi berhasil dikirim ulang';

  @override
  String get failedToResendCode => 'Gagal mengirim ulang kode verifikasi';

  @override
  String get passwordVerification => 'Verifikasi Kata Sandi';

  @override
  String get completeRegistrationPrompt =>
      'Masukkan nama pengguna dan kata sandi untuk menyelesaikan pendaftaran';

  @override
  String get username => 'Nama belakang';

  @override
  String get username_required => 'Nama pengguna diperlukan';

  @override
  String get username_min_length => 'Nama pengguna minimal harus 2 karakter';

  @override
  String get usernameHint => 'Nama pengguna123';

  @override
  String get confirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get profileImage => 'Gambar Profil';

  @override
  String get imageInstructions =>
      'Gambar akan muncul di sini, silakan tekan gambar profil';

  @override
  String get finish => 'Menyelesaikan';

  @override
  String get passwordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get registrationError => 'Kesalahan pendaftaran';

  @override
  String get about => 'Tentang Kami';

  @override
  String get chat => 'Mengobrol';

  @override
  String get realEstate => 'Real Estat';

  @override
  String get language => 'Bahasa Inggris';

  @override
  String get languageEn => 'Bahasa inggris';

  @override
  String get languageRu => 'Rusia';

  @override
  String get languageUz => 'Uzbekistan';

  @override
  String get serviceLiked => 'Layanan disukai';

  @override
  String get support => 'Mendukung';

  @override
  String get service => 'Layanan Bisnis';

  @override
  String get aboutContent =>
      'TezSell adalah pasar yang cepat dan mudah untuk membeli dan menjual produk baru dan bekas. Misi kami adalah menciptakan platform yang paling nyaman dan efisien bagi setiap pengguna, memastikan kelancaran transaksi dan pengalaman yang ramah pengguna. Baik Anda ingin menjual atau membeli, TezSell memudahkan Anda terhubung dan menyelesaikan transaksi hanya dalam beberapa langkah. Kami memprioritaskan keamanan dan privasi pengguna kami. Semua transaksi dipantau secara cermat untuk memastikan keamanan dan kepatuhan, memberikan ketenangan pikiran bagi pembeli dan penjual. Antarmuka kami yang sederhana dan intuitif memungkinkan pengguna membuat daftar produk dengan cepat dan menemukan apa yang mereka butuhkan. Kami juga memfasilitasi komunikasi real-time melalui Telegram sehingga proses jual beli semakin lancar.';

  @override
  String get errorMessage => 'Terjadi kesalahan, silakan periksa server';

  @override
  String get searchLocation => 'Lokasi';

  @override
  String get searchCategory => 'Kategori';

  @override
  String get searchProductPlaceholder => 'Cari produk';

  @override
  String get searchServicePlaceholder => 'Cari layanan';

  @override
  String get search_products_subtitle =>
      'Temukan penawaran menarik di lingkungan Anda';

  @override
  String get search_services_subtitle =>
      'Temukan profesional di lingkungan Anda';

  @override
  String get search_products_error => 'Kesalahan saat mencari produk';

  @override
  String get search_services_error => 'Kesalahan mencari layanan';

  @override
  String get load_more_products_error =>
      'Terjadi error saat memuat lebih banyak produk';

  @override
  String get load_more_services_error =>
      'Terjadi kesalahan saat memuat layanan lainnya';

  @override
  String get try_different_keywords => 'Coba kata kunci yang berbeda';

  @override
  String get searchText => 'Mencari';

  @override
  String get selectedCategory => 'Kategori yang Dipilih:';

  @override
  String get selectedLocation => 'Lokasi yang Dipilih:';

  @override
  String get productError => 'Tidak ada produk yang tersedia';

  @override
  String get serviceError => 'Tidak ada layanan yang tersedia';

  @override
  String get locationHeader => 'Pilih lokasi';

  @override
  String get locationPlaceholder => 'Cari wilayah di sini';

  @override
  String get categoryHeader => 'Pilih Kategori';

  @override
  String get categoryPlaceholder => 'Kategori Pencarian';

  @override
  String get categoryError => 'Tidak ada kategori yang tersedia';

  @override
  String get paginationFirst => 'Pertama';

  @override
  String get paginationPrevious => 'Sebelumnya';

  @override
  String get pageInfo => 'Halaman dari';

  @override
  String get pageNext => 'Berikutnya';

  @override
  String get pageLast => 'Terakhir';

  @override
  String get loadingMessageProduct => 'Memuat produk...';

  @override
  String get loadingMessageError => 'Kesalahan saat memuat';

  @override
  String get likeProductError => 'Terjadi kesalahan saat menyukai produk';

  @override
  String get dislikeProductError =>
      'Terjadi kesalahan saat tidak menyukai produk';

  @override
  String get loadingMessageLocation => 'Memuat lokasi ...';

  @override
  String get loadingLocationError => 'Terjadi kesalahan saat memuat lokasi';

  @override
  String get loadingMessageCategory => 'Memuat kategori ...';

  @override
  String get loadingCategoryError => 'Kesalahan saat memuat kategori:';

  @override
  String get profileUpdateSuccessMessage => 'Profil berhasil diperbarui';

  @override
  String get profileUpdateFailMessage => 'Gagal memperbarui profil';

  @override
  String get seeMoreBtn => 'Lihat Lebih Banyak';

  @override
  String get profilePageTitle => 'Halaman Profil';

  @override
  String get editProfileModalTitle => 'Sunting Profil';

  @override
  String get usernameLabel => 'Nama belakang';

  @override
  String get locationLabel => 'Lokasi Saat Ini';

  @override
  String get profileImageLabel => 'Gambar Profil';

  @override
  String get chooseFileLabel => 'Pilih file';

  @override
  String get uploadBtnLabel => 'Memperbarui';

  @override
  String get uploadingBtnLabel => 'Memperbarui ...';

  @override
  String get cancelBtnLabel => 'Membatalkan';

  @override
  String get productsTitle => 'Produk';

  @override
  String get servicesTitle => 'Layanan';

  @override
  String get myProductsTitle => 'Produk Saya';

  @override
  String get myServicesTitle => 'Layanan Saya';

  @override
  String get favoriteProductsTitle => 'Produk Favorit';

  @override
  String get favoriteServicesTitle => 'Layanan Favorit';

  @override
  String get noFavorites => 'Tidak Ada Favorit';

  @override
  String get addNewProductBtn => 'Tambahkan Produk Baru';

  @override
  String get addNew => 'Baru';

  @override
  String get addNewServiceBtn => 'Tambahkan Layanan Baru';

  @override
  String get downloadMobileApp => 'Unduh aplikasi seluler';

  @override
  String get registerPhoneNumberSuccess =>
      'Nomor telepon terverifikasi! Anda dapat melanjutkan ke langkah berikutnya.';

  @override
  String get regionSelectedMessage => 'Wilayah yang dipilih:';

  @override
  String get districtSelectMessage => 'Distrik yang dipilih:';

  @override
  String get phoneNumberEmptyMessage =>
      'Harap verifikasi nomor telepon Anda sebelum melanjutkan';

  @override
  String get regionEmptyMessage => 'Silakan pilih wilayahnya terlebih dahulu';

  @override
  String get districtEmptyMessage => 'Silakan pilih distrik';

  @override
  String get usernamePasswordEmptyMessage =>
      'Silakan masukkan nama pengguna dan kata sandi';

  @override
  String get registerTitle => 'Daftar';

  @override
  String get previousButton => 'Sebelumnya';

  @override
  String get nextButton => 'Berikutnya';

  @override
  String get completeButton => 'Menyelesaikan';

  @override
  String stepIndicator(int currentStep) {
    return 'Langkah $currentStep dari 4';
  }

  @override
  String get districtSelectTitle => 'Daftar Distrik';

  @override
  String get districtSelectParagraph => 'Pilih distrik:';

  @override
  String get phoneNumber => 'Nomor telepon';

  @override
  String get sendOtp => 'Kirim OTP';

  @override
  String get sendAgain => 'Kirim lagi';

  @override
  String get verify => 'Memeriksa';

  @override
  String get failedToSendOtp => 'Gagal mengirim OTP. Server kembali salah.';

  @override
  String get errorSendingOtp => 'Terjadi kesalahan saat mengirim OTP.';

  @override
  String get invalidPhoneNumber => 'Silakan masukkan nomor telepon yang valid.';

  @override
  String get verificationSuccess => 'Berhasil diverifikasi';

  @override
  String get verificationError => 'Terjadi kesalahan. Silakan coba lagi nanti.';

  @override
  String get regionsList => 'Daftar Wilayah';

  @override
  String get enterUsername => 'Masukkan nama pengguna Anda';

  @override
  String get welcomeMessage =>
      'Selamat datang di Tezsell, masuk dengan nomor telepon Anda';

  @override
  String get noAccount => 'Belum punya akun? Daftar di sini';

  @override
  String get successLogin => 'Berhasil login';

  @override
  String get myProfile => 'Profil Saya';

  @override
  String get logout => 'keluar';

  @override
  String get newProductTitle => 'Judul';

  @override
  String get newProductDescription => 'Keterangan';

  @override
  String get newProductPrice => 'Harga';

  @override
  String get newProductCondition => 'Kondisi';

  @override
  String get newProductCategory => 'Kategori';

  @override
  String get newProductImages => 'Gambar';

  @override
  String get addNewService => 'Tambahkan Layanan Baru';

  @override
  String get creating => 'Membuat...';

  @override
  String get serviceName => 'Nama Layanan';

  @override
  String get serviceNamePlaceholder => 'Masukkan judul layanan';

  @override
  String get serviceDescription => 'Deskripsi Layanan';

  @override
  String get serviceDescriptionPlaceholder => 'Masukkan deskripsi layanan';

  @override
  String get serviceCategory => 'Kategori Layanan';

  @override
  String get selectCategory => 'Pilih kategori';

  @override
  String get loadingCategories => 'Memuat...';

  @override
  String get errorLoadingCategories => 'Terjadi kesalahan saat memuat kategori';

  @override
  String get serviceImages => 'Gambar Layanan';

  @override
  String get imageUploadHelper =>
      'Klik ikon + untuk menambahkan gambar (maksimum 10)';

  @override
  String get maxImagesError => 'Anda dapat mengunggah maksimal 10 gambar';

  @override
  String get categoryNotFound => 'Kategori tidak ditemukan';

  @override
  String get productCreatedSuccess => 'Produk berhasil dibuat';

  @override
  String get productLikeSuccess => 'Produk berhasil disukai';

  @override
  String get productDislikeSuccess => 'Produk berhasil tidak disukai';

  @override
  String get errorCreatingService => 'Terjadi kesalahan saat membuat layanan';

  @override
  String get errorCreatingProduct => 'Terjadi kesalahan saat membuat produk';

  @override
  String get unknownError =>
      'Terjadi kesalahan yang tidak diketahui saat membuat layanan';

  @override
  String get submit => 'Kirim';

  @override
  String get selectCategoryAction => 'Pilih Kategori';

  @override
  String get selectCondition => 'Pilih Kondisi';

  @override
  String get sum => 'Jumlah';

  @override
  String get noComments =>
      'Belum ada komentar. Jadilah yang pertama berkomentar!';

  @override
  String get commentLikeSuccess => 'Komentar berhasil disukai';

  @override
  String get commentLikeError => 'Kesalahan saat menyukai komentar';

  @override
  String get unknownErrorMessage => 'Terjadi kesalahan yang tidak diketahui';

  @override
  String get commentDislikeSuccess => 'Komentar berhasil tidak disukai';

  @override
  String get commentDislikeError =>
      'Terjadi kesalahan saat tidak menyukai komentar';

  @override
  String get replyInfo => 'Silakan masukkan balasan terlebih dahulu';

  @override
  String get replySuccessMessage => 'Balasan berhasil ditambahkan';

  @override
  String get replyErrorMessage => 'Terjadi kesalahan saat pembuatan balasan';

  @override
  String get commentUpdateSuccess => 'Komentar berhasil diperbarui';

  @override
  String get commentUpdateError =>
      'Terjadi kesalahan saat memperbarui item komentar';

  @override
  String get deleteConfirmationMessage =>
      'Apakah Anda yakin ingin menghapus komentar ini?';

  @override
  String get commentDeleteSuccess => 'Komentar berhasil dihapus';

  @override
  String get commentDeleteError => 'Terjadi kesalahan saat menghapus komentar';

  @override
  String get editLabel => 'Sunting';

  @override
  String get deleteLabel => 'Menghapus';

  @override
  String get saveLabel => 'Menyimpan';

  @override
  String get replyLabel => 'Membalas';

  @override
  String get replyTitle => 'balasan';

  @override
  String get replyPlaceholder => 'Tulis balasan...';

  @override
  String get chatLoginMessage => 'Anda harus masuk untuk memulai obrolan';

  @override
  String get chatYourselfMessage =>
      'Anda tidak dapat mengobrol dengan diri sendiri.';

  @override
  String get chatRoomMessage => 'Ruang obrolan dibuat!';

  @override
  String get chatRoomError => 'Gagal membuat obrolan!';

  @override
  String get chatCreationError => 'Pembuatan obrolan gagal!';

  @override
  String get productsTotal => 'Jumlah produk';

  @override
  String get perPage => 'item';

  @override
  String get clearAllFilters => 'Hapus semua filter';

  @override
  String get clickToUpload => 'Klik untuk mengunggah';

  @override
  String get productInStock => 'Tersedia';

  @override
  String get productOutStock => 'Stok Habis';

  @override
  String get productBack => 'Kembali ke produk';

  @override
  String get messageSeller => 'Mengobrol';

  @override
  String get recommendedProducts => 'Produk yang Direkomendasikan';

  @override
  String get deleteConfirmationProduct =>
      'Apakah Anda yakin ingin menghapus produk ini?';

  @override
  String get productDeleteSuccess => 'Produk berhasil dihapus';

  @override
  String get productDeleteError => 'Terjadi kesalahan saat menghapus produk';

  @override
  String get newCondition => 'Baru';

  @override
  String get used => 'Digunakan';

  @override
  String get imageValidType =>
      'Beberapa file tidak ditambahkan. Silakan gunakan file JPG, PNG, GIF atau WebP di bawah 5MB.';

  @override
  String get imageConfirmMessage =>
      'Apakah Anda yakin ingin menghapus gambar ini?';

  @override
  String get titleRequiredMessage => 'Judul diperlukan';

  @override
  String get descRequiredMessage => 'Deskripsi diperlukan';

  @override
  String get priceRequiredMessage => 'Harga diperlukan';

  @override
  String get conditionRequiredMessage => 'Kondisi diperlukan';

  @override
  String get pleaseFillAllRequired => 'Silakan isi kolom yang wajib diisi';

  @override
  String get oneImageConfirmMessage =>
      'Setidaknya satu gambar produk diperlukan';

  @override
  String get categoryRequiredMessage => 'Kategori wajib diisi';

  @override
  String get locationInfoError => 'Informasi lokasi pengguna tidak ada';

  @override
  String get editProductTitle => 'Sunting Produk';

  @override
  String get imageUploadRequirements =>
      'Setidaknya satu gambar diperlukan. Anda dapat mengunggah hingga 10 gambar (JPG, PNG, GIF, WebP masing-masing kurang dari 5 MB).';

  @override
  String get productUpdatedSuccess => 'Produk berhasil diperbarui';

  @override
  String get productUpdateFailed => 'Pembaruan produk gagal';

  @override
  String get errorUpdatingProduct =>
      'Terjadi kesalahan saat memperbarui produk';

  @override
  String get serviceBack => 'Kembali ke layanan';

  @override
  String get likeLabel => 'Menyukai';

  @override
  String get commentsLabel => 'Komentar';

  @override
  String get writeComment => 'Tulis komentar...';

  @override
  String get postingLabel => 'Memposting...';

  @override
  String get commentCreated => 'Komentar dibuat';

  @override
  String get postCommentLabel => 'Posting Komentar';

  @override
  String get loginPrompt =>
      'Silakan masuk untuk melihat dan mengirim komentar.';

  @override
  String get recommendedServices => 'Layanan yang Direkomendasikan';

  @override
  String get commentsVisibilityNotice =>
      'Komentar hanya dapat dilihat oleh pengguna yang login.';

  @override
  String get comingSoon => 'Segera hadir';

  @override
  String get serviceUpdateSuccess => 'Layanan berhasil diperbarui';

  @override
  String get serviceUpdateError =>
      'Terjadi kesalahan saat memperbarui item layanan';

  @override
  String get editServiceModalTitle => 'Sunting Layanan';

  @override
  String get enterPhoneNumberWithoutCode => 'Masukkan nomor telepon tanpa kode';

  @override
  String get heroTitle => 'TezJual';

  @override
  String get heroSubtitle => 'Pasar Cepat & Mudah Anda untuk Uzbekistan';

  @override
  String get startSelling => 'Mulai Menjual';

  @override
  String get browseProducts => 'Jelajahi Produk';

  @override
  String get featuresTitle => 'Mengapa Memilih TezSell?';

  @override
  String get listingTitle => 'Daftar Produk Sederhana';

  @override
  String get listingDescription =>
      'Daftarkan item Anda hanya dengan beberapa klik. Tambahkan foto, tetapkan harga, dan terhubung dengan pembeli secara instan.';

  @override
  String get locationTitle => 'Penjelajahan Berbasis Lokasi';

  @override
  String get locationDescription =>
      'Temukan penawaran di dekat Anda. Sistem berbasis lokasi kami membantu Anda menemukan item di lingkungan Anda.';

  @override
  String get location_subtitle =>
      'Pilih wilayah dan distrik Anda untuk melihat daftar terdekat';

  @override
  String get categoryTitle => 'Pemfilteran Kategori';

  @override
  String get categoryDescription =>
      'Navigasi dengan mudah melalui berbagai kategori untuk menemukan apa yang Anda cari.';

  @override
  String get inspirationTitle => 'Terinspirasi oleh Pasar Wortel Korea';

  @override
  String get inspirationDescription1 =>
      'Kami membangun TezSell dengan inspirasi dari Pasar Wortel (당근마켓) yang sukses di Korea, namun merancangnya secara khusus untuk memenuhi kebutuhan unik komunitas lokal Uzbekistan.';

  @override
  String get inspirationDescription2 =>
      'Misi kami adalah menciptakan platform tepercaya di mana tetangga dapat membeli, menjual, dan terhubung satu sama lain dengan mudah.';

  @override
  String get comingSoonTitle => 'Segera Hadir di TezSell';

  @override
  String get inAppChat => 'Obrolan Dalam Aplikasi';

  @override
  String get secureTransactions => 'Transaksi Aman';

  @override
  String get realEstateListings => 'Daftar Real Estat';

  @override
  String get stayUpdated => 'Tetap Diperbarui';

  @override
  String get comingSoonBadge => 'Segera hadir';

  @override
  String get ctaTitle => 'Bergabunglah dengan Komunitas TezSell Sekarang!';

  @override
  String get ctaDescription =>
      'Jadilah bagian dari membangun pengalaman pasar yang lebih baik untuk Uzbekistan. Bagikan tanggapan Anda dan bantu kami berkembang!';

  @override
  String get createAccount => 'Buat Akun';

  @override
  String get learnMore => 'Pelajari Lebih Lanjut';

  @override
  String get replyUpdateSuccess => 'Balasan berhasil diperbarui';

  @override
  String get replyUpdateError => 'Gagal memperbarui balasan';

  @override
  String get replyDeleteSuccess => 'Balasan berhasil dihapus';

  @override
  String get replyDeleteError => 'Gagal menghapus balasan';

  @override
  String get replyDeleteConfirmation =>
      'Apakah Anda yakin ingin menghapus balasan ini?';

  @override
  String get authenticationRequired => 'Diperlukan otentikasi';

  @override
  String get enterValidReply => 'Silakan masukkan teks balasan yang valid';

  @override
  String get saving => 'Penghematan...';

  @override
  String get deleting => 'Menghapus...';

  @override
  String get properties => 'Properti';

  @override
  String get agents => 'Agen';

  @override
  String get becomeAgent => 'Menjadi Agen';

  @override
  String get main => 'Utama';

  @override
  String get upload => 'Mengunggah';

  @override
  String get filtered_products => 'Produk yang Difilter';

  @override
  String get filtered_services => 'Layanan yang Difilter';

  @override
  String get productDetail => 'Detil Produk';

  @override
  String get unknownUser => 'Pengguna Tidak Dikenal';

  @override
  String get locationNotAvailable => 'Lokasi tidak tersedia';

  @override
  String get noTitle => 'Tanpa Judul';

  @override
  String get noCategory => 'Tidak Ada Kategori';

  @override
  String get noDescription => 'Tidak Ada Deskripsi';

  @override
  String get som => 'Som';

  @override
  String get about_me => 'Tentang Saya';

  @override
  String get my_name => 'Nama saya';

  @override
  String get customer_support => 'Dukungan Pelanggan';

  @override
  String get customer_center => 'Pusat Pelanggan';

  @override
  String get customer_inquiries => 'Pertanyaan';

  @override
  String get customer_terms => 'syarat dan Ketentuan';

  @override
  String get region => 'Wilayah';

  @override
  String get district => 'Daerah';

  @override
  String get tap_change_profile => 'Ketuk untuk mengubah foto';

  @override
  String get language_settings => 'Pengaturan Bahasa';

  @override
  String get selectLanguage => 'Pilih bahasa';

  @override
  String get select_theme => 'Pilih Tema';

  @override
  String get theme => 'Tema';

  @override
  String get location_settings => 'Pengaturan Lokasi';

  @override
  String get security => 'Keamanan';

  @override
  String get data_storage => 'Data & Penyimpanan';

  @override
  String get accessibility => 'Aksesibilitas';

  @override
  String get privacy => 'Pribadi';

  @override
  String get light_theme => 'Lampu';

  @override
  String get dark_theme => 'Gelap';

  @override
  String get system_theme => 'Bawaan Sistem';

  @override
  String get my_products => 'Produk Saya';

  @override
  String get refresh => 'Menyegarkan';

  @override
  String get delete_product => 'Hapus Produk';

  @override
  String get delete_confirmation =>
      'Apakah Anda yakin ingin menghapus produk ini?';

  @override
  String get delete => 'Menghapus';

  @override
  String error_loading_products(String error) {
    return 'Kesalahan saat memuat produk: $error';
  }

  @override
  String get product_deleted_success => 'Produk berhasil dihapus';

  @override
  String error_deleting_product(String error) {
    return 'Kesalahan saat menghapus produk: $error';
  }

  @override
  String get no_products_found => 'Tidak ada produk yang ditemukan';

  @override
  String get add_first_product =>
      'Mulailah dengan menambahkan produk pertama Anda';

  @override
  String get no_title => 'Tidak ada judul';

  @override
  String get no_description => 'Tidak ada deskripsi';

  @override
  String get in_stock => 'Tersedia';

  @override
  String get out_of_stock => 'Stok Habis';

  @override
  String get new_condition => 'BARU';

  @override
  String get edit_product => 'Sunting Produk';

  @override
  String get delete_product_tooltip => 'Hapus Produk';

  @override
  String get sum_currency => 'Jumlah';

  @override
  String get edit_product_title => 'Sunting Produk';

  @override
  String get product_name => 'Nama Produk';

  @override
  String get product_description => 'Deskripsi Produk';

  @override
  String get price => 'Harga';

  @override
  String get condition => 'Kondisi';

  @override
  String get condition_new => 'Baru';

  @override
  String get condition_like_new => 'Seperti baru';

  @override
  String get condition_used => 'Digunakan';

  @override
  String get condition_refurbished => 'Diperbaharui';

  @override
  String get currency => 'Mata uang';

  @override
  String get category => 'Kategori';

  @override
  String get images => 'Gambar';

  @override
  String get existing_images => 'Gambar yang Ada';

  @override
  String get new_images => 'Gambar Baru';

  @override
  String get image_instructions =>
      'Gambar akan muncul di sini. Silakan tekan ikon unggah di atas.';

  @override
  String get update_button => 'Memperbarui';

  @override
  String loading_category_error(String error) {
    return 'Kesalahan saat memuat kategori: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Kesalahan saat memilih gambar: $error';
  }

  @override
  String get please_fill_all_required => 'Silakan isi semua kolom';

  @override
  String get invalid_price_message =>
      'Harga yang dimasukkan tidak valid. Silakan masukkan nomor yang valid.';

  @override
  String get category_required_message => 'Silakan pilih kategori yang valid.';

  @override
  String get one_image_required_message =>
      'Setidaknya satu gambar produk diperlukan';

  @override
  String get product_updated_success => 'Produk berhasil diperbarui';

  @override
  String error_updating_product(String error) {
    return 'Kesalahan saat memperbarui produk: $error';
  }

  @override
  String get my_services => 'Layanan Saya';

  @override
  String get delete_service => 'Hapus Layanan';

  @override
  String get delete_service_confirmation =>
      'Apakah Anda yakin ingin menghapus layanan ini?';

  @override
  String get no_services_found => 'Tidak ada layanan yang ditemukan';

  @override
  String get add_first_service =>
      'Mulailah dengan menambahkan layanan pertama Anda';

  @override
  String get edit_service => 'Sunting Layanan';

  @override
  String get delete_service_tooltip => 'Hapus Layanan';

  @override
  String get service_deleted_successfully => 'Layanan berhasil dihapus';

  @override
  String get error_deleting_service =>
      'Terjadi kesalahan saat menghapus layanan';

  @override
  String get error_loading_services => 'Terjadi kesalahan saat memuat layanan';

  @override
  String get service_name => 'Nama Layanan';

  @override
  String get enter_service_name => 'Masukkan nama layanan';

  @override
  String get service_name_required => 'Nama layanan wajib diisi';

  @override
  String get service_name_min_length => 'Nama layanan minimal harus 3 karakter';

  @override
  String get enter_service_description => 'Masukkan deskripsi layanan';

  @override
  String get service_description_required => 'Deskripsi layanan diperlukan';

  @override
  String get service_description_min_length =>
      'Deskripsi minimal harus 10 karakter';

  @override
  String get category_required => 'Silakan pilih kategori';

  @override
  String get no_categories_available => 'Tidak ada kategori yang tersedia';

  @override
  String get location => 'Lokasi';

  @override
  String get select_location => 'Pilih lokasi';

  @override
  String get location_required => 'Silakan pilih lokasi';

  @override
  String get no_locations_available => 'Tidak ada lokasi yang tersedia';

  @override
  String get add_images => 'Tambahkan Gambar';

  @override
  String get current_images => 'Gambar Saat Ini';

  @override
  String get no_images_selected => 'Tidak ada gambar yang dipilih';

  @override
  String get save_changes => 'Simpan Perubahan';

  @override
  String get map_main => 'Peta & Properti';

  @override
  String get agent_status => 'Status Agen';

  @override
  String get admin_panel => 'Panel Admin';

  @override
  String get propertiesFound => 'Properti Ditemukan';

  @override
  String get propertiesSaved => 'properti disimpan';

  @override
  String get saved => 'disimpan';

  @override
  String get loadingProperties => 'Memuat properti...';

  @override
  String get failedToLoad => 'Gagal memuat properti. Silakan coba lagi.';

  @override
  String get noPropertiesFound => 'Tidak ada properti yang ditemukan';

  @override
  String get tryAdjusting => 'Coba sesuaikan kriteria pencarian Anda';

  @override
  String get search_placeholder => 'Cari berdasarkan judul atau lokasi...';

  @override
  String get search_filters => 'Filter';

  @override
  String get search_button => 'Mencari';

  @override
  String get search_clear_filters => 'Hapus Filter';

  @override
  String get filter_options_sale_and_rent => 'Jual dan Sewa';

  @override
  String get filter_options_for_sale => 'Untuk dijual';

  @override
  String get filter_options_for_rent => 'Untuk Disewakan';

  @override
  String get filter_options_all_types => 'Semua Jenis';

  @override
  String get filter_options_apartment => 'Apartemen';

  @override
  String get filter_options_house => 'Rumah';

  @override
  String get filter_options_townhouse => 'rumah kota';

  @override
  String get filter_options_villa => 'Vila';

  @override
  String get filter_options_commercial => 'Komersial';

  @override
  String get filter_options_office => 'Kantor';

  @override
  String get property_card_featured => 'Unggulan';

  @override
  String get property_card_bed => 'kamar tidur';

  @override
  String get property_card_bath => 'kamar mandi';

  @override
  String get property_card_parking => 'parkir';

  @override
  String get property_card_view_details => 'Lihat Detail';

  @override
  String get property_card_contact => 'Kontak';

  @override
  String get property_card_balcony => 'Balkon';

  @override
  String get property_card_garage => 'Garasi';

  @override
  String get property_card_garden => 'Kebun';

  @override
  String get property_card_pool => 'Kolam';

  @override
  String get property_card_elevator => 'Lift';

  @override
  String get property_card_furnished => 'Berperabot';

  @override
  String get property_card_sales => 'penjualan';

  @override
  String get pricing_month => '/bulan';

  @override
  String get results_properties_found => 'Properti Ditemukan';

  @override
  String get results_properties_saved => 'properti disimpan';

  @override
  String get results_saved => 'disimpan';

  @override
  String get results_loading_properties => 'Memuat properti...';

  @override
  String get results_failed_to_load =>
      'Gagal memuat properti. Silakan coba lagi.';

  @override
  String get results_no_properties_found => 'Tidak ada properti yang ditemukan';

  @override
  String get results_try_adjusting => 'Coba sesuaikan kriteria pencarian Anda';

  @override
  String get no_properties_found => 'Tidak ada properti yang ditemukan';

  @override
  String get no_category_properties => 'Tidak ada properti dalam kategori ini';

  @override
  String get properties_loading => 'Memuat properti...';

  @override
  String get all_properties_loaded => 'Semua properti dimuat';

  @override
  String n_properties(int count) {
    return '$count properti';
  }

  @override
  String get in_area => 'di daerah';

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
  String get pagination_previous => 'Sebelumnya';

  @override
  String get pagination_next => 'Berikutnya';

  @override
  String get pagination_page => 'Halaman';

  @override
  String get pagination_page_of => 'Halaman 1 dari';

  @override
  String get contact_modal_title => 'Informasi Kontak';

  @override
  String get contact_modal_agent_contact => 'Kontak Agen';

  @override
  String get contact_modal_property_owner => 'Pemilik Properti';

  @override
  String get contact_modal_agent_phone_number => 'Nomor Telepon Agen';

  @override
  String get contact_modal_owner_phone_number => 'Nomor Telepon Pemilik';

  @override
  String get contact_modal_license => 'Lisensi';

  @override
  String get contact_modal_rating => 'Peringkat';

  @override
  String get contact_modal_call_now => 'Telepon Sekarang';

  @override
  String get contact_modal_copy_number => 'Salin Nomor';

  @override
  String get contact_modal_close => 'Menutup';

  @override
  String get contact_modal_contact_hours => 'Jam Kontak: 09.00 - 20.00';

  @override
  String get contact_modal_agent => 'Agen';

  @override
  String get errors_toggle_save_failed =>
      'Gagal mengalihkan penyimpanan properti:';

  @override
  String get errors_copy_failed => 'Gagal menyalin nomor telepon:';

  @override
  String get errors_phone_copied => 'Nomor telepon disalin ke papan klip';

  @override
  String get errors_error_occurred_regions => 'Terjadi kesalahan pada wilayah';

  @override
  String get errors_error_occurred_districts =>
      'Terjadi kesalahan pada distrik';

  @override
  String get errors_please_fill_all_required_fields =>
      'Silakan isi semua bidang yang wajib diisi';

  @override
  String get errors_authentication_required => 'Diperlukan otentikasi';

  @override
  String get errors_user_info_missing => 'Informasi pengguna hilang';

  @override
  String get errors_validation_error => 'Silakan periksa data masukan Anda';

  @override
  String get errors_permission_denied => 'Izin ditolak';

  @override
  String get errors_server_error => 'Terjadi kesalahan server';

  @override
  String get errors_network_error => 'Kesalahan koneksi jaringan';

  @override
  String get errors_timeout_error => 'Batas waktu permintaan terlampaui';

  @override
  String get errors_custom_error => 'Terjadi kesalahan';

  @override
  String get errors_error_creating_property =>
      'Terjadi kesalahan saat membuat properti';

  @override
  String get errors_unknown_error_message =>
      'Terjadi kesalahan yang tidak diketahui';

  @override
  String get errors_coordinates_not_found =>
      'Tidak dapat menemukan koordinat untuk alamat ini. Silakan masukkan secara manual.';

  @override
  String get errors_coordinates_error =>
      'Terjadi kesalahan saat mendapatkan koordinat. Silakan masukkan secara manual.';

  @override
  String get property_info_views => 'pandangan';

  @override
  String get property_info_listed => 'Terdaftar';

  @override
  String get property_info_price_per_sqm => '/sqm';

  @override
  String get property_info_saved => 'Disimpan';

  @override
  String get property_info_save => 'Menyimpan';

  @override
  String get property_info_share => 'Membagikan';

  @override
  String get loading_loading => 'Memuat...';

  @override
  String get loading_loading_details => 'Memuat detail properti...';

  @override
  String get loading_property_not_found => 'Properti tidak ditemukan';

  @override
  String get loading_property_not_found_message =>
      'Properti yang Anda cari tidak ada atau telah dihapus.';

  @override
  String get loading_back_to_properties => 'Kembali ke Properti';

  @override
  String get loading_title => 'Memuat agen...';

  @override
  String get loading_message =>
      'Harap tunggu sementara kami memuat daftar agen.';

  @override
  String get loading_agent_not_found => 'Agen tidak ditemukan';

  @override
  String get property_details_title => 'Detail Properti';

  @override
  String get property_details_bedrooms => 'Kamar tidur';

  @override
  String get property_details_bathrooms => 'Kamar mandi';

  @override
  String get property_details_floor_area => 'Luas Lantai';

  @override
  String get property_details_parking => 'Parkir';

  @override
  String get property_details_basic_information => 'Informasi Dasar';

  @override
  String get property_details_property_type => 'Tipe Properti:';

  @override
  String get property_details_listing_type => 'Jenis Daftar:';

  @override
  String get property_details_for_sale => 'Untuk dijual';

  @override
  String get property_details_for_rent => 'Untuk Disewakan';

  @override
  String get property_details_year_built => 'Tahun Dibangun:';

  @override
  String get property_details_floor => 'Lantai:';

  @override
  String get property_details_of => 'dari';

  @override
  String get property_details_features_amenities => 'Fitur & Fasilitas';

  @override
  String get sections_description => 'Keterangan';

  @override
  String get sections_nearby_amenities => 'Fasilitas Terdekat';

  @override
  String get sections_similar_properties => 'Properti Serupa';

  @override
  String get amenities_metro => 'Metro';

  @override
  String get amenities_school => 'Sekolah';

  @override
  String get amenities_hospital => 'RSUD';

  @override
  String get amenities_shopping => 'Belanja';

  @override
  String get amenities_away => 'jauh';

  @override
  String get contact_title => 'Informasi Kontak';

  @override
  String get contact_professional_listing => 'Daftar Profesional';

  @override
  String get contact_listed_by_agent => 'Terdaftar oleh agen terverifikasi';

  @override
  String get contact_by_owner => 'Oleh Pemilik';

  @override
  String get contact_direct_contact =>
      'Kontak langsung dengan pemilik properti';

  @override
  String get contact_property_owner => 'Pemilik Properti';

  @override
  String get contact_call_agent => 'Agen Panggilan';

  @override
  String get contact_email_agent => 'Agen Email';

  @override
  String get contact_call_owner => 'Hubungi Pemilik';

  @override
  String get contact_email_owner => 'Pemilik Email';

  @override
  String get contact_send_inquiry => 'Kirim Pertanyaan';

  @override
  String get property_status_title => 'Status Properti';

  @override
  String get property_status_availability => 'Tersedianya:';

  @override
  String get property_status_available => 'Tersedia';

  @override
  String get property_status_not_available => 'Tidak Tersedia';

  @override
  String get property_status_featured => 'Unggulan:';

  @override
  String get property_status_featured_property => 'Properti Unggulan';

  @override
  String get property_status_property_id => 'ID Properti:';

  @override
  String get inquiry_title => 'Kirim Pertanyaan';

  @override
  String get inquiry_inquiry_type => 'Jenis Permintaan';

  @override
  String get inquiry_request_info => 'Minta Informasi';

  @override
  String get inquiry_schedule_viewing => 'Jadwal Menonton';

  @override
  String get inquiry_make_offer => 'Buat Penawaran';

  @override
  String get inquiry_request_callback => 'Minta Panggilan Balik';

  @override
  String get inquiry_message => 'Pesan';

  @override
  String get inquiry_message_placeholder =>
      'Beritahu kami tentang minat Anda pada properti ini...';

  @override
  String get inquiry_offered_price => 'Harga yang Ditawarkan';

  @override
  String get inquiry_enter_offer => 'Masukkan penawaran Anda';

  @override
  String get inquiry_preferred_contact_time =>
      'Waktu Kontak Pilihan (opsional)';

  @override
  String get inquiry_contact_time_placeholder =>
      'misalnya, Hari Kerja pukul 09.00 - 17.00';

  @override
  String get inquiry_cancel => 'Membatalkan';

  @override
  String get inquiry_sending => 'Mengirim...';

  @override
  String get inquiry_send_inquiry => 'Kirim Pertanyaan';

  @override
  String get inquiry_inquiry_sent_success => 'Permintaan berhasil dikirim!';

  @override
  String get inquiry_inquiry_sent_error =>
      'Gagal mengirim pertanyaan. Silakan coba lagi.';

  @override
  String get alerts_link_copied => 'Tautan properti disalin ke papan klip!';

  @override
  String get alerts_phone_copied => 'Nomor telepon disalin ke papan klip!';

  @override
  String get alerts_save_property_failed => 'Gagal menyimpan properti:';

  @override
  String get alerts_email_subject => 'Pertanyaan tentang:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Halo,\\n\\nSaya tertarik dengan properti Anda \"$title\" yang berlokasi di $address.\\n\\nSilakan hubungi saya untuk informasi lebih lanjut.\\n\\nSalam';
  }

  @override
  String get related_properties_view_details => 'Lihat Detail';

  @override
  String get header_property => 'Temukan Properti Impian Anda';

  @override
  String get header_sub_property =>
      'Temukan peluang real estate premium di lingkungan yang paling diinginkan di Tashkent';

  @override
  String get header_title => 'Agen Real Estat';

  @override
  String get header_subtitle =>
      'Temukan agen berpengalaman untuk membantu kebutuhan real estat Anda';

  @override
  String get header_agents_found => 'agen ditemukan';

  @override
  String get filters_all_specializations => 'Semua Spesialisasi';

  @override
  String get filters_residential => 'Perumahan';

  @override
  String get filters_commercial => 'Komersial';

  @override
  String get filters_luxury => 'Kemewahan';

  @override
  String get filters_investment => 'Investasi';

  @override
  String get filters_any_rating => 'Peringkat Apa Pun';

  @override
  String get filters_four_stars => '4+ Bintang';

  @override
  String get filters_four_half_stars => '4,5+ Bintang';

  @override
  String get filters_five_stars => '5 Bintang';

  @override
  String get filters_highest_rated => 'Nilai Tertinggi';

  @override
  String get filters_lowest_rated => 'Nilai Terendah';

  @override
  String get filters_most_sales => 'Penjualan Terbanyak';

  @override
  String get filters_most_experience => 'Pengalaman Terbanyak';

  @override
  String get agent_card_verified_agent => 'Agen Terverifikasi';

  @override
  String get agent_card_years_experience => 'pengalaman bertahun-tahun';

  @override
  String get agent_card_years => 'bertahun-tahun';

  @override
  String get agent_card_license => 'Lisensi';

  @override
  String get agent_card_specialization => 'Spesialisasi';

  @override
  String get agent_card_view_profile => 'Lihat Profil';

  @override
  String get agent_card_contact => 'Kontak';

  @override
  String get agent_card_verified => 'Terverifikasi';

  @override
  String get no_results_title => 'Tidak Ada Agen yang Ditemukan';

  @override
  String get no_results_message =>
      'Coba sesuaikan kriteria atau filter pencarian Anda.';

  @override
  String get error_title => 'Kesalahan Memuat Agen';

  @override
  String get error_message => 'Gagal memuat daftar agen. Silakan coba lagi.';

  @override
  String get error_retry => 'Mencoba kembali';

  @override
  String get error_default_message => 'Gagal memuat detail agen';

  @override
  String get error_try_again => 'Coba Lagi';

  @override
  String get notifications_phone_copied =>
      'Nomor telepon disalin ke papan klip';

  @override
  String get notifications_copy_failed => 'Gagal menyalin nomor telepon:';

  @override
  String get fallback_agent_name => 'Agen';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Kirim Properti';

  @override
  String get navigation_submitting => 'Mengirimkan...';

  @override
  String get navigation_back_to_agents => 'Kembali ke Agen';

  @override
  String get agent_profile_verified_agent => 'Agen Terverifikasi';

  @override
  String get agent_profile_contact_agent => 'Hubungi Agen';

  @override
  String get agent_profile_send_message => 'Kirim Pesan';

  @override
  String get agent_profile_years_experience => 'Pengalaman Bertahun-tahun';

  @override
  String get agent_profile_properties_sold => 'Properti Terjual';

  @override
  String get agent_profile_active_listings => 'Daftar Aktif';

  @override
  String get agent_profile_total_properties => 'Jumlah Properti';

  @override
  String get tabs_overview => 'ringkasan';

  @override
  String get tabs_properties => 'properti';

  @override
  String get tabs_reviews => 'ulasan';

  @override
  String get about_agent_title => 'Tentang Agen';

  @override
  String get about_agent_agency => 'Agen';

  @override
  String get about_agent_license_number => 'Nomor Lisensi';

  @override
  String get about_agent_specialization => 'Spesialisasi';

  @override
  String get about_agent_member_since => 'Anggota Sejak';

  @override
  String get about_agent_verified_since => 'Diverifikasi Sejak';

  @override
  String get performance_metrics_title => 'Metrik Kinerja';

  @override
  String get performance_metrics_average_rating => 'Peringkat Rata-Rata';

  @override
  String get performance_metrics_properties_sold => 'Properti Terjual';

  @override
  String get performance_metrics_active_listings => 'Daftar Aktif';

  @override
  String get performance_metrics_years_experience =>
      'Pengalaman Bertahun-tahun';

  @override
  String get contact_info_title => 'Informasi Kontak';

  @override
  String get contact_info_contact_via_platform => 'Kontak melalui Platform';

  @override
  String get verification_status_title => 'Status Verifikasi';

  @override
  String get verification_status_verified_agent => 'Agen Terverifikasi';

  @override
  String get verification_status_pending_verification => 'Verifikasi Tertunda';

  @override
  String get verification_status_licensed_professional =>
      'Profesional Berlisensi';

  @override
  String get verification_status_registered_agency => 'Agen Terdaftar';

  @override
  String get quick_actions_title => 'Tindakan Cepat';

  @override
  String get quick_actions_call_now => 'Telepon Sekarang';

  @override
  String get quick_actions_send_message => 'Kirim Pesan';

  @override
  String get quick_actions_view_properties => 'Lihat Properti';

  @override
  String get properties_title => 'Properti Agen';

  @override
  String get properties_loading_properties => 'Memuat properti...';

  @override
  String get properties_no_properties_title =>
      'Tidak Ada Properti yang Ditemukan';

  @override
  String get properties_no_properties_message =>
      'Properti agen ini akan muncul di sini.';

  @override
  String get properties_recent_properties_note =>
      'Menampilkan properti terkini. Periksa daftar lengkap untuk semua properti agen.';

  @override
  String get properties_listed => 'Terdaftar';

  @override
  String get properties_bed => 'tempat tidur';

  @override
  String get properties_bath => 'mandi';

  @override
  String get properties_for_sale => 'Untuk dijual';

  @override
  String get properties_for_rent => 'Untuk Disewakan';

  @override
  String get reviews_title => 'Ulasan Klien';

  @override
  String get reviews_no_reviews_title => 'Belum Ada Ulasan';

  @override
  String get reviews_no_reviews_message =>
      'Ulasan dan rekomendasi klien akan muncul di sini.';

  @override
  String get fallbacks_agent_name => 'Agen';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => 'Properti Tersimpan';

  @override
  String get saved_properties_subtitle =>
      'Properti favorit Anda di satu tempat';

  @override
  String get saved_properties_no_saved_properties =>
      'Belum ada properti yang disimpan';

  @override
  String get saved_properties_start_saving =>
      'Mulailah menjelajahi dan menyimpan properti yang Anda suka';

  @override
  String get saved_properties_browse_properties => 'Telusuri Properti';

  @override
  String get saved_properties_saved_on => 'Disimpan';

  @override
  String get auth_login_required =>
      'Silakan masuk untuk melihat properti yang disimpan';

  @override
  String get auth_login => 'Login';

  @override
  String get success_property_unsaved =>
      'Properti dihapus dari daftar tersimpan';

  @override
  String get success_property_saved => 'Properti berhasil disimpan';

  @override
  String get success_phone_copied => 'Nomor telepon disalin!';

  @override
  String get success_property_created_success => 'Properti berhasil dibuat!';

  @override
  String get success_agent_approved => 'Agen berhasil disetujui';

  @override
  String get success_agent_rejected => 'Agen berhasil ditolak';

  @override
  String get steps_step => 'Melangkah';

  @override
  String get steps_basic_information => 'Informasi Dasar';

  @override
  String get steps_location_details => 'Detail Lokasi';

  @override
  String get steps_property_details => 'Detail Properti';

  @override
  String get steps_property_images => 'Gambar Properti';

  @override
  String get basic_info_tell_us_about_property =>
      'Beritahu kami tentang properti Anda';

  @override
  String get basic_info_property_type => 'Tipe Properti';

  @override
  String get basic_info_listing_type => 'Jenis Daftar';

  @override
  String get basic_info_property_title => 'Judul Properti';

  @override
  String get basic_info_title_placeholder =>
      'Masukkan judul deskriptif untuk properti Anda';

  @override
  String get basic_info_description => 'Keterangan';

  @override
  String get basic_info_description_placeholder =>
      'Jelaskan properti Anda secara detail...';

  @override
  String get property_types_apartment => 'Apartemen';

  @override
  String get property_types_house => 'Rumah';

  @override
  String get property_types_townhouse => 'rumah kota';

  @override
  String get property_types_villa => 'Vila';

  @override
  String get property_types_commercial => 'Komersial';

  @override
  String get property_types_office => 'Kantor';

  @override
  String get property_types_land => 'Tanah';

  @override
  String get property_types_warehouse => 'Gudang';

  @override
  String get listing_types_for_sale => 'Untuk dijual';

  @override
  String get listing_types_for_rent => 'Untuk Disewakan';

  @override
  String get location_where_is_property => 'Di manakah lokasi properti Anda?';

  @override
  String get location_full_address => 'Alamat Lengkap';

  @override
  String get location_address_placeholder => 'Masukkan alamat lengkap';

  @override
  String get location_region => 'Wilayah';

  @override
  String get location_select_region => 'Pilih wilayah';

  @override
  String get location_district => 'Daerah';

  @override
  String get location_select_district => 'Pilih distrik';

  @override
  String get location_city => 'Kota';

  @override
  String get location_city_placeholder => 'Kota';

  @override
  String get location_loading_regions => 'Memuat wilayah...';

  @override
  String get location_loading_districts => 'Memuat distrik...';

  @override
  String get location_map_coordinates => 'Koordinat Peta';

  @override
  String get location_get_coordinates => 'Dapatkan Koordinat';

  @override
  String get location_latitude => 'Lintang';

  @override
  String get location_longitude => 'Garis bujur';

  @override
  String get location_coordinates_set => 'Koordinat ditetapkan';

  @override
  String get location_location_tips => 'Tip Lokasi';

  @override
  String get location_location_tip_1 =>
      '• Isi alamat terlebih dahulu, lalu klik \'Dapatkan Koordinat\' untuk mendapatkan lokasi peta secara otomatis';

  @override
  String get location_location_tip_2 =>
      '• Anda juga dapat memasukkan koordinat secara manual jika Anda mengetahui lokasi tepatnya';

  @override
  String get location_location_tip_3 =>
      '• Koordinat yang akurat membantu pembeli menemukan properti Anda di peta';

  @override
  String get property_details_provide_detailed_info =>
      'Berikan informasi detail tentang properti Anda';

  @override
  String get property_details_total_floors => 'Jumlah Lantai';

  @override
  String get property_details_area_m2 => 'Luas (m²)';

  @override
  String get property_details_parking_spaces => 'Tempat Parkir';

  @override
  String get property_details_price => 'Harga';

  @override
  String get property_details_features => 'Fitur';

  @override
  String get images_add_photos_showcase =>
      'Tambahkan foto untuk memamerkan properti Anda';

  @override
  String get images_click_to_upload => 'Klik untuk mengunggah gambar';

  @override
  String get images_max_images_info => 'Maksimal 10 gambar, JPG, PNG atau WEBP';

  @override
  String get images_main => 'Utama';

  @override
  String get images_maximum_images_allowed =>
      'Maksimum 10 gambar diperbolehkan';

  @override
  String get admin_dashboard_title => 'Dasbor Admin';

  @override
  String get admin_dashboard_subtitle =>
      'Ikhtisar real-time dari platform real estate Anda';

  @override
  String get admin_last_update => 'Pembaruan terakhir';

  @override
  String get admin_total_properties => 'Jumlah Properti';

  @override
  String get admin_total_agents => 'Jumlah Agen';

  @override
  String get admin_total_users => 'Jumlah Pengguna';

  @override
  String get admin_total_views => 'Jumlah Tayangan';

  @override
  String get admin_error_loading_dashboard =>
      'Terjadi kesalahan saat memuat dasbor';

  @override
  String get admin_failed_to_load_data => 'Gagal memuat data dasbor';

  @override
  String get admin_avg_sale_price => 'Harga Jual Rata-rata';

  @override
  String get admin_avg_sale_price_subtitle => 'Semua listing aktif';

  @override
  String get admin_total_portfolio_value => 'Total Nilai Portofolio';

  @override
  String get admin_total_portfolio_value_subtitle => 'Nilai properti gabungan';

  @override
  String get admin_avg_price_per_sqm => 'Harga Rata-rata per meter persegi';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Indikator harga pasar';

  @override
  String get admin_property_types_distribution => 'Distribusi Jenis Properti';

  @override
  String get admin_properties_by_city => 'Properti menurut Kota';

  @override
  String get admin_properties_by_district => 'Properti menurut Distrik';

  @override
  String get admin_inquiry_types_distribution => 'Distribusi Jenis Permintaan';

  @override
  String get admin_agent_verification_rate => 'Tingkat Verifikasi Agen';

  @override
  String get admin_agent_verification_rate_subtitle => 'Kontrol kualitas';

  @override
  String get admin_inquiry_response_rate => 'Tingkat Respon Permintaan';

  @override
  String get admin_inquiry_response_rate_subtitle => 'Pelayanan pelanggan';

  @override
  String get admin_avg_views_per_property =>
      'Rata-rata Penayangan per Properti';

  @override
  String get admin_avg_views_per_property_subtitle => 'Popularitas properti';

  @override
  String get admin_featured_properties => 'Properti Unggulan';

  @override
  String get admin_featured_properties_subtitle => 'Daftar premium';

  @override
  String get admin_most_viewed_properties => 'Properti Paling Banyak Dilihat';

  @override
  String get admin_top_performing_agents => 'Agen Berkinerja Terbaik';

  @override
  String get admin_system_health => 'Kesehatan Sistem';

  @override
  String get admin_properties_without_images => 'Properti tanpa gambar';

  @override
  String get admin_missing_location_data => 'Data lokasi tidak ada';

  @override
  String get admin_pending_agent_verification => 'Verifikasi agen tertunda';

  @override
  String get admin_active => 'aktif';

  @override
  String get admin_verified => 'diverifikasi';

  @override
  String get admin_active_7d => 'aktif (7 hari)';

  @override
  String get admin_this_month => 'bulan ini';

  @override
  String get agents_loading_pending_applications =>
      'Memuat aplikasi yang tertunda...';

  @override
  String get agents_error_loading_applications =>
      'Terjadi kesalahan saat memuat aplikasi';

  @override
  String get agents_pending_agents => 'Agen yang Tertunda';

  @override
  String get agents_total_pending_applications =>
      'Total permohonan yang tertunda:';

  @override
  String get agents_pending_verification => 'Verifikasi Tertunda';

  @override
  String get agents_applied_date => 'Terapan:';

  @override
  String get agents_contact_info => 'Informasi Kontak';

  @override
  String get agents_license_number => 'Nomor Lisensi';

  @override
  String get agents_years_experience => 'Pengalaman Bertahun-tahun';

  @override
  String get agents_years_suffix => 'bertahun-tahun';

  @override
  String get agents_total_sales => 'Jumlah Penjualan';

  @override
  String get agents_specialization => 'Spesialisasi';

  @override
  String get agents_approve => 'Menyetujui';

  @override
  String get agents_reject => 'Menolak';

  @override
  String get agents_no_pending_applications =>
      'Tidak ada aplikasi yang tertunda';

  @override
  String get agents_all_applications_processed =>
      'Semua aplikasi agen telah diproses';

  @override
  String get general_previous => 'Sebelumnya';

  @override
  String get general_page => 'Halaman';

  @override
  String get general_next => 'Berikutnya';

  @override
  String get general_views => 'pandangan';

  @override
  String get general_sales => 'penjualan';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'Русский';

  @override
  String get general_language_en => 'Bahasa inggris';

  @override
  String get general_super_admin => 'Admin Super';

  @override
  String get general_staff => 'Staf';

  @override
  String get general_verified_agent => 'Agen Terverifikasi';

  @override
  String get general_pending_agent => 'Agen Tertunda';

  @override
  String get general_regular_user => 'Pengguna Biasa';

  @override
  String get general_admin => 'Admin';

  @override
  String get general_dashboard => 'Dasbor';

  @override
  String get general_manage_users => 'Kelola Pengguna';

  @override
  String get general_verified_agents => 'Agen Terverifikasi';

  @override
  String get general_agent_panel => 'Panel Agen';

  @override
  String get general_create_property => 'Buat Properti';

  @override
  String get general_my_properties => 'Properti Saya';

  @override
  String get general_inquiries => 'Pertanyaan';

  @override
  String get general_agent_profile => 'Profil Agen';

  @override
  String get general_live => 'Hidup';

  @override
  String get general_logged_out_successfully => 'Berhasil logout';

  @override
  String get general_logout_completed_with_errors =>
      'Logout selesai (dengan kesalahan)';

  @override
  String get general_application_under_review => 'Permohonan sedang ditinjau';

  @override
  String get general_check_status => 'Periksa status →';

  @override
  String get general_last_updated => 'Terakhir diperbarui:';

  @override
  String get general_permissions_may_be_outdated =>
      'Izin mungkin sudah ketinggalan jaman';

  @override
  String get general_permissions_up_to_date => 'Izin terkini';

  @override
  String get general_never => 'Tidak pernah';

  @override
  String get general_properties_found => 'Properti Ditemukan';

  @override
  String get general_properties_saved => 'properti disimpan';

  @override
  String get general_saved => 'disimpan';

  @override
  String get general_loading_properties => 'Memuat properti...';

  @override
  String get general_failed_to_load =>
      'Gagal memuat properti. Silakan coba lagi.';

  @override
  String get general_no_properties_found => 'Tidak ada properti yang ditemukan';

  @override
  String get general_try_adjusting => 'Coba sesuaikan kriteria pencarian Anda';

  @override
  String get select_category => 'Pilih kategori';

  @override
  String get service_description => 'Deskripsi Layanan';

  @override
  String get product_search_placeholder =>
      'Masukkan istilah pencarian untuk menemukan produk';

  @override
  String get privacy_policy => 'Kebijakan Privasi';

  @override
  String get terms_subtitle => 'Kebijakan dan ketentuan privasi';

  @override
  String get last_updated => 'Terakhir Diperbarui';

  @override
  String get contact_information => 'Informasi Kontak';

  @override
  String get accept_terms => 'Saya Menerima Syarat dan Ketentuan';

  @override
  String get read_terms => 'Silakan baca syarat dan ketentuan kami';

  @override
  String get inquiries => 'Pertanyaan & Dukungan';

  @override
  String get inquiries_subtitle => 'Hubungi kami untuk bantuan';

  @override
  String get help_center => 'Apa yang bisa kami bantu?';

  @override
  String get help_subtitle =>
      'Kami di sini untuk membantu Anda dengan pertanyaan apa pun';

  @override
  String get contact_us => 'Hubungi kami';

  @override
  String get email_support => 'Dukungan Email';

  @override
  String get call_support => 'Hubungi Dukungan';

  @override
  String get send_message => 'Kirim Pesan';

  @override
  String get fill_contact_form => 'Isi formulir kontak';

  @override
  String get contact_form => 'Formulir Kontak';

  @override
  String get name => 'Nama Anda';

  @override
  String get name_required => 'Silakan masukkan nama Anda';

  @override
  String get email => 'Alamat Surel';

  @override
  String get email_required => 'Silakan masukkan email Anda';

  @override
  String get email_invalid => 'Silakan masukkan email yang valid';

  @override
  String get subject => 'Subjek';

  @override
  String get subject_required => 'Silakan masukkan subjek';

  @override
  String get message => 'Pesan';

  @override
  String get message_required => 'Silakan masukkan pesan Anda';

  @override
  String get message_too_short => 'Pesan minimal harus 10 karakter';

  @override
  String get faq => 'Pertanyaan yang Sering Diajukan';

  @override
  String get follow_us => 'Ikuti Kami';

  @override
  String get faq_how_to_sell => 'Bagaimana cara menjual barang di Tezsell?';

  @override
  String get faq_how_to_sell_answer =>
      'Untuk menjual barang: 1) Buat akun, 2) Ketuk tombol \'+\', 3) Pilih kategori (Produk/Layanan/Real Estat), 4) Tambahkan foto dan deskripsi, 5) Tetapkan harga Anda, 6) Publikasikan! Listingan Anda akan terlihat oleh pembeli di wilayah Anda.';

  @override
  String get faq_is_free => 'Apakah Tezsell gratis untuk digunakan?';

  @override
  String get faq_is_free_answer =>
      'Ya! Tezsell saat ini 100% gratis. Tanpa biaya pencatatan, tanpa komisi penjualan, tanpa biaya berlangganan. Kami mungkin memperkenalkan fitur premium di masa mendatang, namun akan memberi tahu pengguna 30 hari sebelumnya.';

  @override
  String get faq_safety =>
      'Bagaimana saya bisa tetap aman saat membeli/menjual?';

  @override
  String get faq_safety_answer =>
      'Kiat keamanan: 1) Bertemu di tempat umum, 2) Periksa barang sebelum membayar, 3) Jangan pernah mengirim uang kepada orang asing, 4) Percayai naluri Anda, 5) Laporkan pengguna yang mencurigakan, 6) Jangan membagikan informasi pribadi terlalu dini, 7) Ajaklah teman untuk transaksi bernilai tinggi.';

  @override
  String get faq_payment => 'Bagaimana cara kerja pembayaran?';

  @override
  String get faq_payment_answer =>
      'Tezsell tidak memproses pembayaran. Pembeli dan penjual mengatur pembayaran secara langsung (tunai, transfer bank, dll.). Kami hanyalah sebuah platform untuk menghubungkan orang-orang - Anda sendiri yang menangani transaksinya.';

  @override
  String get faq_prohibited => 'Barang apa saja yang dilarang?';

  @override
  String get faq_prohibited_answer =>
      'Barang yang dilarang antara lain: senjata, obat-obatan, barang curian, barang palsu, konten dewasa, hewan hidup (tanpa izin), tanda pengenal pemerintah, dan bahan berbahaya. Lihat Syarat & Ketentuan kami untuk daftar lengkap.';

  @override
  String get faq_account_delete => 'Bagaimana cara menghapus akun saya?';

  @override
  String get faq_account_delete_answer =>
      'Buka Profil → Pengaturan → Pengaturan Akun → Hapus Akun. Catatan: Ini bersifat permanen dan tidak dapat dibatalkan. Semua listingan Anda akan dihapus.';

  @override
  String get faq_report_user =>
      'Bagaimana cara melaporkan pengguna atau listingan?';

  @override
  String get faq_report_user_answer =>
      'Ketuk tiga titik (•••) pada listingan atau profil pengguna mana pun, lalu pilih \'Laporkan\'. Pilih alasannya dan kirimkan. Kami meninjau semua laporan dalam waktu 24-48 jam.';

  @override
  String get faq_change_location => 'Bagaimana cara mengubah lokasi saya?';

  @override
  String get faq_change_location_answer =>
      'Ketuk tombol lokasi di sudut kiri atas layar beranda. Anda dapat memilih wilayah dan distrik Anda untuk melihat daftar di wilayah Anda.';

  @override
  String get welcome_customer_center => 'Selamat datang di Pusat Pelanggan';

  @override
  String get customer_center_subtitle =>
      'Kami di sini untuk membantu Anda 24/7';

  @override
  String get quick_actions => 'Tindakan Cepat';

  @override
  String get live_chat => 'Obrolan Langsung';

  @override
  String get chat_with_us => 'Ngobrol dengan kami';

  @override
  String get find_answers => 'Temukan jawaban';

  @override
  String get my_tickets => 'Tiket Saya';

  @override
  String get view_tickets => 'Lihat tiket';

  @override
  String get feedback => 'Masukan';

  @override
  String get share_feedback => 'Bagikan masukan';

  @override
  String get contact_methods => 'Metode Kontak';

  @override
  String get phone_support => 'Dukungan Telepon';

  @override
  String get available_247 => 'Tersedia 24/7';

  @override
  String get response_24h => 'Respon dalam waktu 24 jam';

  @override
  String get telegram_support => 'Dukungan Telegram';

  @override
  String get instant_replies => 'Balasan instan';

  @override
  String get whatsapp_support => 'Dukungan WhatsApp';

  @override
  String get quick_response => 'Respon cepat';

  @override
  String get popular_topics => 'Topik Populer';

  @override
  String get account_management => 'Manajemen Akun';

  @override
  String get reset_password => 'Atur Ulang Kata Sandi';

  @override
  String get update_profile => 'Perbarui Profil';

  @override
  String get verify_account => 'Verifikasi Akun';

  @override
  String get delete_account => 'Hapus Akun';

  @override
  String get buying_selling => 'Membeli & Menjual';

  @override
  String get how_to_post => 'Cara Memasang Iklan';

  @override
  String get payment_methods => 'Metode Pembayaran';

  @override
  String get shipping_delivery => 'Pengiriman & Pengiriman';

  @override
  String get return_policy => 'Kebijakan Pengembalian';

  @override
  String get safety_security => 'Keselamatan & Keamanan';

  @override
  String get report_scam => 'Laporkan Penipuan';

  @override
  String get safe_trading => 'Tip Perdagangan yang Aman';

  @override
  String get privacy_settings => 'Pengaturan Privasi';

  @override
  String get blocked_users => 'Pengguna yang Diblokir';

  @override
  String get technical_issues => 'Masalah Teknis';

  @override
  String get app_not_working => 'Aplikasi Tidak Berfungsi';

  @override
  String get upload_failed => 'Pengunggahan Gagal';

  @override
  String get login_problems => 'Masalah Masuk';

  @override
  String get support_hours => 'Jam Dukungan';

  @override
  String get mon_fri_9_6 => 'Senin-Jumat: 09.00 - 18.00';

  @override
  String get how_are_we_doing => 'Bagaimana kabar kita?';

  @override
  String get rate_experience => 'Nilai pengalaman layanan pelanggan Anda';

  @override
  String get poor => 'Miskin';

  @override
  String get okay => 'Oke';

  @override
  String get good => 'Bagus';

  @override
  String get excellent => 'Bagus sekali';

  @override
  String get account_secure => 'Akun Anda Aman';

  @override
  String get password_security => 'Kata Sandi & Otentikasi';

  @override
  String get change_password => 'Ubah Kata Sandi';

  @override
  String get two_factor_auth => 'Otentikasi Dua Faktor';

  @override
  String get biometric_login => 'Login Biometrik';

  @override
  String get login_activity => 'Aktivitas Masuk';

  @override
  String get active_sessions => 'Sesi Aktif';

  @override
  String get login_alerts => 'Peringatan Masuk';

  @override
  String get account_protection => 'Perlindungan Akun';

  @override
  String get recovery_email => 'Email Pemulihan';

  @override
  String get backup_codes => 'Kode Cadangan';

  @override
  String get danger_zone => 'Zona Bahaya';

  @override
  String get improve_security => 'Tingkatkan Keamanan';

  @override
  String get security_score => 'Skor Keamanan';

  @override
  String get last_changed_days => 'Terakhir diubah 30 hari yang lalu';

  @override
  String get logout_all_devices => 'Keluar Semua Perangkat';

  @override
  String get end_all_sessions => 'Akhiri semua sesi';

  @override
  String get permanently_delete => 'Hapus secara permanen';

  @override
  String get verification_code_message =>
      'Kami akan mengirimkan kode verifikasi untuk mengonfirmasi bahwa ini memang Anda.';

  @override
  String get send_code => 'Kirim Kode';

  @override
  String get enter_verification_code => 'Masukkan Kode Verifikasi';

  @override
  String get verification_code => 'Kode Verifikasi';

  @override
  String get new_password => 'Kata Sandi Baru';

  @override
  String get confirm_password => 'Konfirmasi Kata Sandi';

  @override
  String get resend_code => 'Kirim Ulang Kode';

  @override
  String get code_sent_to => 'Masukkan kode verifikasi yang dikirimkan ke';

  @override
  String get enter_code => 'Masukkan kode verifikasi';

  @override
  String get code_must_be_6_digits => 'Kode harus 6 digit';

  @override
  String get enter_new_password => 'Masukkan kata sandi baru';

  @override
  String get minimum_8_characters => 'Minimal 8 karakter';

  @override
  String get passwords_do_not_match => 'Kata sandi tidak cocok';

  @override
  String get close => 'Menutup';

  @override
  String get current => 'Saat ini';

  @override
  String get session_ended => 'Sesi berakhir';

  @override
  String get update_recovery_email => 'Perbarui Email Pemulihan';

  @override
  String get new_email => 'Surel Baru';

  @override
  String get update => 'Memperbarui';

  @override
  String get verification_email_sent => 'Email verifikasi terkirim';

  @override
  String get generate_emergency_codes => 'Hasilkan kode darurat';

  @override
  String get copy_all => 'Salin Semua';

  @override
  String get code_copied => 'Kode disalin';

  @override
  String get all_codes_copied => 'Semua kode disalin';

  @override
  String get logout_all_devices_confirm => 'Logout Semua Perangkat?';

  @override
  String get logout_all_devices_message =>
      'Ini akan mengakhiri semua sesi aktif di semua perangkat.';

  @override
  String get logout_all => 'Keluar Semua';

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
  String get delete_account_confirm => 'Hapus Akun?';

  @override
  String get delete_account_warning =>
      'Tindakan ini PERMANEN dan tidak dapat dibatalkan. Semua data Anda akan dihapus secara permanen.';

  @override
  String get what_will_be_deleted => 'Yang akan dihapus:';

  @override
  String get profile_and_account_info => '• Informasi profil dan akun Anda';

  @override
  String get all_listings_and_posts => '• Semua listingan dan postingan Anda';

  @override
  String get messages_and_conversations => 'Pesan';

  @override
  String get saved_items_and_preferences => '• Item dan preferensi tersimpan';

  @override
  String get enter_password_to_continue =>
      'Masukkan kata sandi Anda untuk melanjutkan';

  @override
  String get continue_val => 'Melanjutkan';

  @override
  String get please_enter_password => 'Silakan masukkan kata sandi Anda';

  @override
  String get enter_confirmation_code => 'Masukkan Kode Konfirmasi';

  @override
  String get deletion_confirmation_message =>
      'Kami mengirimkan kode konfirmasi ke ponsel Anda. Masukkan di bawah untuk menghapus akun Anda secara permanen.';

  @override
  String get confirmation_code => 'Kode Konfirmasi';

  @override
  String get please_enter_6_digit_code => 'Silakan masukkan kode 6 digit';

  @override
  String get account_deleted => 'Akun Anda telah dihapus';

  @override
  String get deletion_cancelled => 'Penghapusan dibatalkan';

  @override
  String get failed_to_load_user_info => 'Gagal memuat informasi pengguna';

  @override
  String get auth_login_to_view_saved =>
      'Silakan masuk untuk melihat properti yang Anda simpan';

  @override
  String get authLoginRequired => 'Diperlukan Masuk';

  @override
  String get authLoginToViewSaved =>
      'Silakan masuk untuk melihat properti yang Anda simpan';

  @override
  String get authLogin => 'Masuk';

  @override
  String get savedPropertiesTitle => 'Properti Tersimpan';

  @override
  String get loadingSavedProperties => 'Memuat properti yang disimpan...';

  @override
  String get errorsFailedToLoadSaved => 'Gagal memuat properti tersimpan';

  @override
  String get actionsRetry => 'Mencoba kembali';

  @override
  String get savedPropertiesNoSaved => 'Tidak Ada Properti Tersimpan';

  @override
  String get savedPropertiesStartSaving =>
      'Mulailah menjelajahi dan menyimpan properti yang Anda suka';

  @override
  String get savedPropertiesBrowse => 'Telusuri Properti';

  @override
  String get resultsSavedProperties => 'properti yang disimpan';

  @override
  String get actionsRefresh => 'Menyegarkan';

  @override
  String get resultsNoMoreProperties => 'Tidak ada lagi properti';

  @override
  String get propertyCardFeatured => 'Unggulan';

  @override
  String get successPropertyUnsaved => 'Properti dihapus dari daftar tersimpan';

  @override
  String get alertsUnsavePropertyFailed => 'Gagal menghapus properti';

  @override
  String get propertyCardBed => 'tempat tidur';

  @override
  String get propertyCardBath => 'mandi';

  @override
  String get savedPropertiesSavedOn => 'Disimpan';

  @override
  String get propertyCardViewDetails => 'Lihat Detail';

  @override
  String get serviceDetailTitle => 'Detil Layanan';

  @override
  String get errorLoadingFavorites =>
      'Terjadi kesalahan saat memuat item favorit';

  @override
  String get noFavoritesFound => 'Tidak ada item favorit yang ditemukan.';

  @override
  String get commentUpdatedSuccess => 'Komentar berhasil diperbarui!';

  @override
  String get errorUpdatingComment =>
      'Terjadi kesalahan saat memperbarui komentar';

  @override
  String get replyAddedSuccess => 'Balasan berhasil ditambahkan!';

  @override
  String get errorAddingReply => 'Terjadi kesalahan saat menambahkan balasan';

  @override
  String get commentDeletedSuccess => 'Komentar berhasil dihapus!';

  @override
  String get errorDeletingComment =>
      'Terjadi kesalahan saat menghapus komentar';

  @override
  String get serviceLikedSuccess => 'Layanan berhasil disukai!';

  @override
  String get errorLikingService => 'Kesalahan menyukai layanan';

  @override
  String get serviceDislikedSuccess => 'Layanan berhasil tidak disukai!';

  @override
  String get errorDislikingService => 'Kesalahan tidak menyukai layanan';

  @override
  String get writeYourReply => 'Tulis balasan Anda...';

  @override
  String get postReply => 'Posting Balasan';

  @override
  String get anonymous => 'Anonim';

  @override
  String get editComment => 'Sunting Komentar';

  @override
  String get editYourComment => 'Edit komentar Anda...';

  @override
  String get saveChanges => 'Simpan Perubahan';

  @override
  String get propertyOwner => 'Pemilik Properti';

  @override
  String get errorLoadingServices => 'Terjadi kesalahan saat memuat layanan';

  @override
  String get noRecommendedServicesFound =>
      'Tidak ditemukan layanan yang direkomendasikan.';

  @override
  String get passwordRequired => 'Kata sandi diperlukan';

  @override
  String get passwordTooShort => 'Kata sandi minimal harus 8 karakter';

  @override
  String get passwordRequirements =>
      'Kata sandi harus mengandung huruf dan angka';

  @override
  String get usernameRequired => 'Nama pengguna diperlukan';

  @override
  String get usernameTooShort => 'Nama pengguna minimal harus 3 karakter';

  @override
  String get confirmPasswordRequired => 'Konfirmasi kata sandi diperlukan';

  @override
  String get passwordHelp => 'Minimal 8 karakter, huruf dan angka';

  @override
  String get usernameExists => 'Nama pengguna ini sudah ada';

  @override
  String get phoneExists => 'Nomor telepon ini sudah terdaftar';

  @override
  String get networkError =>
      'Kesalahan koneksi jaringan. Silakan periksa koneksi Anda';

  @override
  String get contactSeller => 'Hubungi Penjual';

  @override
  String get callToReveal => 'Ketuk \"Panggil\" untuk mengungkapkannya';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get selectImageSource => 'Pilih Sumber Gambar';

  @override
  String get uploading => 'Mengunggah...';

  @override
  String get acceptTermsRequired =>
      'Anda harus menerima Syarat dan Ketentuan untuk melanjutkan';

  @override
  String get iAgreeToTerms => 'Saya setuju dengan';

  @override
  String get termsAndConditions => 'syarat dan Ketentuan';

  @override
  String get zeroToleranceStatement =>
      'dan memahami bahwa tidak ada toleransi terhadap konten yang tidak pantas atau pengguna yang melakukan kekerasan.';

  @override
  String get viewTerms => 'Lihat Syarat dan Ketentuan';

  @override
  String get reportContent => 'Laporkan Konten';

  @override
  String get selectReportReason => 'Silakan pilih alasan pelaporan:';

  @override
  String get additionalDetails => 'Detail tambahan (opsional)';

  @override
  String get reportDetailsHint => 'Berikan informasi tambahan...';

  @override
  String get reportSubmitted =>
      'Terima kasih atas laporan Anda. Kami akan meninjaunya dalam waktu 24 jam.';

  @override
  String get reportProduct => 'Laporkan Produk';

  @override
  String get reportService => 'Layanan Laporan';

  @override
  String get reportMessage => 'Pesan Laporan';

  @override
  String get reportUser => 'Laporkan Pengguna';

  @override
  String get reportErrorNotImplemented =>
      'Fitur pelaporan belum tersedia. Silakan hubungi dukungan atau coba lagi nanti.';

  @override
  String get reportAlreadySubmitted =>
      'Anda telah melaporkan konten ini. Kami sedang meninjau laporan Anda sebelumnya.';

  @override
  String get reportFailedGeneric =>
      'Gagal mengirimkan laporan. Silakan coba lagi.';

  @override
  String get reportFailedNetwork =>
      'Terjadi kesalahan jaringan. Silakan periksa koneksi Anda dan coba lagi.';

  @override
  String get becomeAgentTitle => 'Bergabunglah sebagai Agen Real Estat';

  @override
  String get becomeAgentSubtitle =>
      'Buat daftar properti dan bantu klien menemukan rumah impian mereka';

  @override
  String get agentBenefits => 'Manfaat:';

  @override
  String get agentBenefitVerified => 'Lencana agen terverifikasi';

  @override
  String get agentBenefitAnalytics => 'Akses ke analitik dan wawasan';

  @override
  String get agentBenefitClients => 'Kontak langsung dengan klien potensial';

  @override
  String get agentBenefitReputation => 'Bangun reputasi profesional Anda';

  @override
  String get agentApplicationForm => 'Formulir Aplikasi';

  @override
  String get agentAgencyName => 'Nama Agensi';

  @override
  String get agentAgencyNameHint => 'Masukkan nama agen real estat Anda';

  @override
  String get agentAgencyNameRequired => 'Nama agensi wajib diisi';

  @override
  String get agentLicenceNumber => 'Nomor Lisensi';

  @override
  String get agentLicenceNumberHint => 'Masukkan nomor lisensi real estat Anda';

  @override
  String get agentLicenceNumberRequired => 'Nomor lisensi diperlukan';

  @override
  String get agentYearsExperience => 'Pengalaman Bertahun-tahun';

  @override
  String get agentYearsExperienceHint => 'Masukkan jumlah tahun';

  @override
  String get agentYearsExperienceRequired =>
      'Diperlukan pengalaman bertahun-tahun';

  @override
  String get agentYearsExperienceInvalid => 'Silakan masukkan nomor yang valid';

  @override
  String get agentSpecialization => 'Spesialisasi';

  @override
  String get agentApplicationNote =>
      'Permohonan Anda akan ditinjau oleh tim kami. Anda akan diberitahu setelah permohonan Anda disetujui.';

  @override
  String get agentSubmitApplication => 'Kirim Lamaran';

  @override
  String get agentApplicationSubmitted =>
      'Lamaran berhasil dikirimkan! Kami akan segera meninjaunya.';

  @override
  String get agentApplicationStatus => 'Status Aplikasi';

  @override
  String get agentViewProfile => 'Lihat profil agen Anda';

  @override
  String get agentDashboardComingSoon => 'Dasbor agen segera hadir!';

  @override
  String get property_create_basic_information => 'Informasi Dasar';

  @override
  String get property_create_property_title => 'Judul Properti *';

  @override
  String get property_create_property_title_hint =>
      'misalnya, Apartemen Modern 3KT di Pusat Kota';

  @override
  String get property_create_property_title_required =>
      'Silakan masukkan judul properti';

  @override
  String get property_create_description => 'Keterangan *';

  @override
  String get property_create_description_hint =>
      'Jelaskan properti Anda secara detail...';

  @override
  String get property_create_description_required =>
      'Silakan masukkan deskripsi';

  @override
  String get property_create_property_type => 'Tipe Properti';

  @override
  String get property_create_property_type_required => 'Tipe Properti *';

  @override
  String get property_create_listing_type_required => 'Jenis Daftar *';

  @override
  String get property_create_pricing => 'Harga';

  @override
  String get property_create_price => 'Harga *';

  @override
  String get property_create_price_hint => 'Masukkan harga';

  @override
  String get property_create_price_required => 'Silakan masukkan harga';

  @override
  String get property_create_currency => 'Mata uang';

  @override
  String get property_create_property_details => 'Detail Properti';

  @override
  String get property_create_square_meters => 'persegi. Meter *';

  @override
  String get property_create_bedrooms => 'Kamar tidur *';

  @override
  String get property_create_bathrooms => 'Kamar mandi *';

  @override
  String get property_create_floor => 'Lantai';

  @override
  String get property_create_total_floors => 'Jumlah Lantai';

  @override
  String get property_create_parking => 'Parkir';

  @override
  String get property_create_year_built => 'Tahun Dibangun';

  @override
  String get property_create_location => 'Lokasi';

  @override
  String get property_create_address => 'Alamat *';

  @override
  String get property_create_address_hint => 'Masukkan alamat properti';

  @override
  String get property_create_address_required => 'Silakan masukkan alamat';

  @override
  String get property_create_location_detected => 'Lokasi Terdeteksi';

  @override
  String get property_create_get_location => 'Dapatkan Lokasi Saat Ini';

  @override
  String get property_create_features => 'Fitur';

  @override
  String get property_create_feature_balcony => 'Balkon';

  @override
  String get property_create_feature_garage => 'Garasi';

  @override
  String get property_create_feature_garden => 'Kebun';

  @override
  String get property_create_feature_pool => 'Kolam';

  @override
  String get property_create_feature_elevator => 'Lift';

  @override
  String get property_create_feature_furnished => 'Berperabot';

  @override
  String get property_create_images => 'Gambar Properti';

  @override
  String get property_create_tap_to_add_images =>
      'Ketuk untuk menambahkan gambar';

  @override
  String get property_create_at_least_one_image =>
      'Setidaknya diperlukan 1 gambar';

  @override
  String get property_create_add_more => 'Tambahkan Lebih Banyak';

  @override
  String get property_create_required => 'Diperlukan';

  @override
  String get property_create_location_required =>
      'Harap aktifkan layanan lokasi untuk membuat properti';

  @override
  String get property_create_image_required =>
      'Setidaknya satu gambar properti diperlukan';

  @override
  String get emailVerification => 'Verifikasi Email';

  @override
  String get pleaseEnterYourEmailAddress =>
      'Silakan masukkan alamat email Anda';

  @override
  String get enterEmailAddress => 'Masukkan alamat email';

  @override
  String get resetYourPassword => 'Atur Ulang Kata Sandi Anda';

  @override
  String get resetPasswordDescription =>
      'Masukkan alamat email Anda dan kami akan mengirimkan kode verifikasi untuk mengatur ulang kata sandi Anda.';

  @override
  String get sendVerificationCode => 'Kirim Kode Verifikasi';

  @override
  String get backToLogin => 'Kembali ke Masuk';

  @override
  String get resetPassword => 'Atur Ulang Kata Sandi';

  @override
  String enterVerificationCodeSentTo(String email) {
    return 'Masukkan kode verifikasi yang dikirimkan ke $email';
  }

  @override
  String get codeMustBe6Digits => 'Kode harus 6 digit';

  @override
  String get enterNewPassword => 'Masukkan kata sandi baru';

  @override
  String get minimum8Characters => 'Minimal 8 karakter';

  @override
  String get sending => 'Mengirim...';

  @override
  String get verifying => 'Memverifikasi...';

  @override
  String get new_message => 'Pesan Baru';

  @override
  String get messages => 'Pesan';

  @override
  String get please_log_in => 'Silakan masuk untuk melihat pesan';

  @override
  String get pin => 'Pin';

  @override
  String get unpin => 'Membuka peniti';

  @override
  String get delete_chat => 'Hapus Obrolan';

  @override
  String delete_chat_confirm(String name) {
    return 'Apakah Anda yakin ingin menghapus obrolan dengan $name? Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String chat_deleted(String name) {
    return 'Obrolan dengan $name dihapus';
  }

  @override
  String get delete_failed => 'Gagal menghapus obrolan';

  @override
  String get no_conversations => 'Belum ada percakapan';

  @override
  String get start_conversation_hint =>
      'Mulailah percakapan dengan mengetuk tombol +';

  @override
  String get start_conversation => 'Mulailah Percakapan';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get unknown => 'Tidak dikenal';

  @override
  String get no_messages_yet => 'Belum ada pesan';

  @override
  String get unblock_user => 'Buka blokir Pengguna';

  @override
  String get block_user => 'Blokir Pengguna';

  @override
  String get no_blocked_users => 'Tidak ada pengguna yang diblokir';

  @override
  String get blocked_users_hint =>
      'Pengguna yang Anda blokir akan muncul di sini';

  @override
  String unblock_user_confirm(String username) {
    return 'Apakah Anda yakin ingin membuka blokir $username? Anda akan dapat menerima pesan dari mereka lagi.';
  }

  @override
  String user_unblocked(String username) {
    return '$username telah dibuka blokirnya';
  }

  @override
  String user_blocked(String username) {
    return '$username telah diblokir';
  }

  @override
  String get failed_to_unblock => 'Gagal membuka blokir pengguna';

  @override
  String get failed_to_block => 'Gagal memblokir pengguna';

  @override
  String get chat_info => 'Info Obrolan';

  @override
  String get delete_message => 'Hapus Pesan';

  @override
  String get delete_message_confirm =>
      'Apakah Anda yakin ingin menghapus pesan ini?';

  @override
  String get typing => 'mengetik...';

  @override
  String get online => 'on line';

  @override
  String get offline => 'luring';

  @override
  String last_seen_at(String time) {
    return 'terakhir terlihat $time';
  }

  @override
  String participants(int count) {
    return '$count peserta';
  }

  @override
  String get you_are_blocked => 'Anda diblokir';

  @override
  String user_blocked_you(String username) {
    return '$username telah memblokir Anda. Anda tidak dapat mengirim pesan.';
  }

  @override
  String you_blocked_user(String username) {
    return 'Anda telah memblokir $username';
  }

  @override
  String get cannot_send_messages_blocked =>
      'Anda tidak dapat mengirim pesan. Anda telah diblokir.';

  @override
  String get this_message_was_deleted => 'Pesan ini telah dihapus';

  @override
  String get edit => 'Sunting';

  @override
  String get reply => 'Membalas';

  @override
  String get editing_message => 'Mengedit pesan';

  @override
  String replying_to(String username) {
    return 'Membalas ke $username';
  }

  @override
  String get voice => 'Suara';

  @override
  String get emoji => 'emoji';

  @override
  String get photo => '📷 Foto';

  @override
  String get voice_message => '🎤 Pesan suara';

  @override
  String get searching => 'Mencari...';

  @override
  String get loading_users => 'Memuat pengguna...';

  @override
  String search_failed(String error) {
    return 'Pencarian gagal: $error';
  }

  @override
  String get invalid_user_data => 'Data pengguna tidak valid';

  @override
  String failed_to_start_chat(String error) {
    return 'Gagal memulai obrolan: $error';
  }

  @override
  String get audio_file_not_available => 'Berkas audio tidak tersedia';

  @override
  String failed_to_play_audio(String error) {
    return 'Gagal memutar audio: $error';
  }

  @override
  String get image_unavailable => 'Gambar tidak tersedia';

  @override
  String get image_too_large =>
      '❌ Gambar terlalu besar. Ukuran maksimalnya adalah 10MB';

  @override
  String get image_file_not_found => '❌ File gambar tidak ditemukan';

  @override
  String get uploading_image => 'Mengunggah gambar...';

  @override
  String get image_sent => '✅ Gambar terkirim!';

  @override
  String get failed_to_send_image => '❌ Gagal mengirim gambar';

  @override
  String get uploading_voice_message => 'Mengunggah pesan suara...';

  @override
  String get voice_message_sent => '✅ Pesan suara terkirim!';

  @override
  String get failed_to_send_voice_message => '❌ Gagal mengirim pesan suara';

  @override
  String get recording => '🎙️ Merekam...';

  @override
  String get microphone_permission_denied => 'Izin mikrofon ditolak';

  @override
  String get starting_chat => 'Memulai obrolan...';

  @override
  String get refresh_users => 'Segarkan pengguna';

  @override
  String get search_by_username_or_phone =>
      'Cari berdasarkan nama pengguna atau nomor telepon';

  @override
  String get no_users_found => 'Tidak ada pengguna yang ditemukan';

  @override
  String get try_different_search_term => 'Coba istilah pencarian lain';

  @override
  String get no_users_available => 'Tidak ada pengguna yang tersedia';

  @override
  String get chat_exists => 'Obrolan ada';

  @override
  String block_user_confirm(String username) {
    return 'Apakah Anda yakin ingin memblokir $username? Anda tidak akan menerima pesan dari mereka dan mereka akan dihapus dari daftar obrolan Anda.';
  }

  @override
  String chat_room_label(String name) {
    return 'Ruang Obrolan: $name';
  }

  @override
  String id_label(int id) {
    return 'ID: $id';
  }

  @override
  String get participants_label => 'Peserta:';

  @override
  String get type_a_message => 'Ketik pesan...';

  @override
  String get edit_message_hint => 'Sunting pesan...';

  @override
  String error_label(String error) {
    return 'Kesalahan: $error';
  }

  @override
  String get copy => 'Menyalin';

  @override
  String comments_title(int count) {
    return 'Komentar ($count)';
  }

  @override
  String get reply_button => 'Membalas';

  @override
  String replies_count(int count) {
    return '$count balasan';
  }

  @override
  String get you_label => 'Anda';

  @override
  String get delete_reply_title => 'Hapus Balasan';

  @override
  String get delete_comment_title => 'Hapus Komentar';

  @override
  String get unknown_date => 'Tanggal Tidak Diketahui';

  @override
  String get press_enter_to_send => 'Tekan Enter untuk mengirim';

  @override
  String get comment_add_error => 'Gagal menambahkan komentar';

  @override
  String get service_provider => 'Penyedia Layanan';

  @override
  String get opening_chat => 'Membuka obrolan...';

  @override
  String get failed_to_refresh => 'Gagal menyegarkan';

  @override
  String get cannot_chat_with_yourself =>
      'Anda tidak dapat mengobrol dengan diri sendiri';

  @override
  String opening_chat_with(String username) {
    return 'Membuka obrolan dengan $username...';
  }

  @override
  String get this_will_only_take_a_moment =>
      'Ini hanya akan memakan waktu sebentar';

  @override
  String get unable_to_start_chat =>
      'Tidak dapat memulai obrolan. Silakan coba lagi.';

  @override
  String get profile_listings => 'Daftar';

  @override
  String get profile_followers => 'Pengikut';

  @override
  String get profile_following => 'Mengikuti';

  @override
  String get profile_no_products => 'Tidak ada produk';

  @override
  String get profile_no_services => 'Tidak ada layanan';

  @override
  String get profile_no_properties => 'Tidak ada properti';

  @override
  String get profile_user_no_products =>
      'Pengguna ini belum memposting produk apa pun';

  @override
  String get profile_user_no_services =>
      'Pengguna ini belum memposting layanan apa pun';

  @override
  String get profile_user_no_properties =>
      'Pengguna ini belum memposting properti apa pun';

  @override
  String get profile_error_occurred => 'Terjadi kesalahan';

  @override
  String get profile_error_loading_products =>
      'Terjadi kesalahan saat memuat produk';

  @override
  String get profile_error_loading_services =>
      'Terjadi kesalahan saat memuat layanan';

  @override
  String get profile_no_followers_yet => 'Belum ada pengikut';

  @override
  String get profile_no_following_yet => 'Belum mengikuti siapa pun';

  @override
  String get profile_follow => 'Mengikuti';

  @override
  String get profile_following_btn => 'Mengikuti';

  @override
  String get profile_message => 'Pesan';

  @override
  String get profile_member_since => 'Anggota sejak itu';

  @override
  String get profile_loading_error => 'Terjadi kesalahan saat memuat profil';

  @override
  String get profile_retry => 'Coba lagi';

  @override
  String get profile_share => 'Membagikan';

  @override
  String get profile_copy_link => 'Salin tautan';

  @override
  String get profile_report => 'Laporan';

  @override
  String get linkCopied => 'Tautan disalin ke papan klip';

  @override
  String get checkOutProfile => 'Memeriksa';

  @override
  String get onTezsell => 'di TezSell';

  @override
  String get selectCountryFirst => 'Pilih negara terlebih dahulu';

  @override
  String get countrySelectionHint => 'Kemudian Anda dapat memilih wilayah Anda';

  @override
  String get something_went_wrong => 'Ada yang tidak beres';

  @override
  String get check_connection_and_retry =>
      'Silakan periksa koneksi internet Anda dan coba lagi';

  @override
  String get sold_badge => 'TERJUAL';

  @override
  String get more_categories => 'Lagi';

  @override
  String no_products_in_location(String location) {
    return 'Tidak ada produk yang ditemukan di $location';
  }

  @override
  String get no_more_products => 'Tidak ada lagi produk yang perlu dimuat';

  @override
  String time_days_ago(int count) {
    return '${count}d yang lalu';
  }

  @override
  String time_hours_ago(int count) {
    return '${count}jam yang lalu';
  }

  @override
  String time_minutes_ago(int count) {
    return '${count}m yang lalu';
  }

  @override
  String get time_just_now => 'Baru saja';

  @override
  String no_services_in_location(String location) {
    return 'Tidak ada layanan yang ditemukan di $location';
  }

  @override
  String get no_more_services => 'Tidak ada lagi layanan yang perlu dimuat';

  @override
  String get error_loading_more_services =>
      'Terjadi kesalahan saat memuat layanan lainnya';

  @override
  String get verification_code_length => 'Kode verifikasi harus 6 digit';

  @override
  String get map_register_title => 'Kamu tinggal di mana?';

  @override
  String get map_register_headline => 'Pilih lingkungan Anda di peta';

  @override
  String get map_register_subtitle =>
      'Kami menggunakannya untuk menunjukkan kepada Anda pembeli dan penjual terdekat. Anda dapat menyesuaikan radius Anda nanti.';

  @override
  String get pick_on_map => 'Pilih di peta';

  @override
  String get pick_again => 'Pilih lagi';

  @override
  String get resolving_location => 'Menyelesaikan lokasi…';

  @override
  String get use_dropdown_instead => 'Gunakan tarik-turun sebagai gantinya';

  @override
  String country_not_supported(String country) {
    return 'Kami belum mendukung $country.';
  }

  @override
  String get region_not_auto_detected =>
      'Tidak dapat mendeteksi wilayah Anda secara otomatis — pilih secara manual.';

  @override
  String get district_not_auto_detected =>
      'Tidak dapat mendeteksi distrik Anda secara otomatis — pilih secara manual.';

  @override
  String get browse_no_items_with_location =>
      'Belum ada item dengan data lokasi di area ini.';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => 'Tetapkan lokasi';

  @override
  String get location_picker_confirm => 'Konfirmasikan lokasi';

  @override
  String get location_picker_resolve_failed =>
      'Tidak dapat menentukan alamat — pilih lagi atau konfirmasi dengan koordinat saja';

  @override
  String get location_picker_selected_fallback => 'Lokasi yang dipilih';

  @override
  String get location_permission_denied => 'Izin lokasi ditolak';

  @override
  String get location_permission_denied_settings =>
      'Izin lokasi ditolak — harap aktifkan di Pengaturan';

  @override
  String get location_permission_permanent =>
      'Lokasi ditolak secara permanen — buka Pengaturan untuk mengaktifkan';

  @override
  String gps_error(String error) {
    return 'Kesalahan GPS: $error';
  }

  @override
  String get verify_neighborhood_title => 'Verifikasi lingkungan Anda';

  @override
  String get verify_neighborhood_subtitle =>
      'Berdirilah di lingkungan Anda. Kami akan memeriksa GPS Anda dan meminta Anda untuk mengonfirmasi.';

  @override
  String get verify_neighborhood_button => 'Verifikasi Lingkungan';

  @override
  String get verify_neighborhood_low_confidence =>
      'Lanjutkan dengan rasa percaya diri yang rendah';

  @override
  String get verify_neighborhood_retry => 'Mencoba kembali';

  @override
  String get verify_neighborhood_youre_in => 'Anda berada di:';

  @override
  String verify_neighborhood_done(String name) {
    return 'Terverifikasi! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'Akurasi GPS adalah ${meters}m (membutuhkan ≤100m). Pindah ke area terbuka dan coba lagi.';
  }

  @override
  String get neighborhood_not_identified =>
      'Tidak dapat mengidentifikasi lingkungan untuk lokasi Anda.';

  @override
  String get unknown_error => 'Kesalahan tidak diketahui';

  @override
  String get place_search_hint => 'Cari alamat atau tempat';

  @override
  String get place_search_unavailable => 'Pencarian tidak tersedia — ganti pin';

  @override
  String get radius_slider_city => 'Kota';

  @override
  String radius_slider_km(String value) {
    return '$value km';
  }

  @override
  String get my_neighborhoods => 'Lingkungan Saya';

  @override
  String get manage_on_map => 'Kelola di peta';

  @override
  String get no_neighborhoods_yet =>
      'Belum ada lingkungan yang terverifikasi. Buka peta untuk memverifikasi lokasi Anda.';

  @override
  String get open_map_to_verify => 'Buka peta untuk memverifikasi lokasi baru';

  @override
  String get verify_here => 'Verifikasi di sini';

  @override
  String get verify_new_location => 'Verifikasi lokasi baru';

  @override
  String eviction_warning(String name) {
    return 'Menambahkan lokasi ini akan menghapus $name (yang terlama). Ini tidak dapat dibatalkan.';
  }

  @override
  String get verified_today => 'Diverifikasi hari ini';

  @override
  String get verified_yesterday => 'Diverifikasi kemarin';

  @override
  String verified_n_days_ago(int days) {
    return 'Diverifikasi $days hari yang lalu';
  }

  @override
  String get active_neighborhood => 'Aktif';

  @override
  String switch_neighborhood_success(String name) {
    return 'Beralih ke $name';
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
}
