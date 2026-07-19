// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get welcome => 'Chào mừng';

  @override
  String get welcomeBack => 'Chào mừng trở lại!';

  @override
  String get loginToYourAccount => 'Đăng nhập để tiếp tục';

  @override
  String get or => 'HOẶC';

  @override
  String get dontHaveAccount => 'Bạn chưa có tài khoản?';

  @override
  String get chooseLanguage => 'Chọn ngôn ngữ của bạn';

  @override
  String get selectPreferredLanguage =>
      'Chọn ngôn ngữ ưa thích của bạn cho ứng dụng';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get continueWithApple => 'Tiếp tục với Apple';

  @override
  String get continueWithEmail => 'Tiếp tục với Email';

  @override
  String get sellAndBuyProducts =>
      'Bán và mua bất kỳ sản phẩm nào của bạn chỉ với chúng tôi';

  @override
  String get usedProductsMarket =>
      'Sản phẩm đã qua sử dụng hoặc thị trường đồ cũ';

  @override
  String get home_welcome_title => 'Thị trường lân cận của bạn';

  @override
  String get home_welcome_subtitle =>
      'Mua bán với những người ở gần.\nAn toàn, đơn giản và địa phương.';

  @override
  String get home_get_started => 'Bắt đầu';

  @override
  String get home_sign_in => 'Tôi đã có tài khoản';

  @override
  String get home_terms_notice =>
      'Bằng cách tiếp tục, bạn đồng ý với Điều khoản dịch vụ và Chính sách quyền riêng tư của chúng tôi';

  @override
  String get register => 'Đăng ký';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản';

  @override
  String get login => 'Đăng nhập';

  @override
  String get loginToAccount => 'Đăng nhập vào tài khoản';

  @override
  String get enterPhoneNumber => 'Nhập số điện thoại';

  @override
  String get password => 'Mật khẩu';

  @override
  String get enterPassword => 'Nhập mật khẩu';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get registerNow => 'Đăng ký ngay';

  @override
  String get loading => 'Đang tải...';

  @override
  String get pleaseEnterPhoneNumber => 'Vui lòng nhập số điện thoại của bạn';

  @override
  String get pleaseEnterPassword => 'Vui lòng nhập mật khẩu của bạn';

  @override
  String get unexpectedError =>
      'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.';

  @override
  String get forgotPasswordComingSoon => 'Tính năng quên mật khẩu sắp ra mắt';

  @override
  String get selectedCountryLabel => 'Đã chọn:';

  @override
  String get fullPhoneLabel => 'Đầy:';

  @override
  String get home => 'Trang chủ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get notifications => 'Thông báo';

  @override
  String get error => 'Lỗi';

  @override
  String get retry => 'Thử lại';

  @override
  String get cancel => 'Hủy bỏ';

  @override
  String get save => 'Cứu';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Vui lòng chọn khu vực của bạn';

  @override
  String get searchHint => 'Tìm kiếm quận hoặc thành phố';

  @override
  String get apiError => 'Đã xảy ra sự cố khi gọi API';

  @override
  String get ok => 'ĐƯỢC RỒI';

  @override
  String get emptyList => 'Danh sách trống';

  @override
  String get dataLoadingError => 'Có lỗi khi tải dữ liệu';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get yes => 'Đúng';

  @override
  String get no => 'KHÔNG';

  @override
  String confirmRegionSelection(Object regionName) {
    return 'Bạn có muốn chọn vùng $regionName không?';
  }

  @override
  String get selectDistrictOrCity =>
      'Vui lòng chọn quận hoặc thành phố của bạn';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return 'Bạn có muốn chọn vùng $regionName - $districtName không?';
  }

  @override
  String get noResultsFound => 'Không tìm thấy kết quả nào.';

  @override
  String errorWithCode(String errorCode) {
    return 'Lỗi: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'Không thể tải dữ liệu. Lỗi: $error';
  }

  @override
  String get phoneVerification => 'Xác minh số điện thoại';

  @override
  String get enterPhonePrompt => 'Vui lòng nhập số điện thoại của bạn';

  @override
  String get enterPhoneNumberHint => 'Nhập số điện thoại';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Đã chọn: $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'Chọn quốc gia của bạn';

  @override
  String get changeCountry => 'Thay đổi quốc gia';

  @override
  String get country => 'Quốc gia';

  @override
  String get allCountries => 'Tất cả các nước';

  @override
  String get currencyRUB => 'Đồng Rúp Nga';

  @override
  String get currencyUAH => 'Hryvnia Ucraina';

  @override
  String get currencyBYN => 'Đồng Rúp Belarus';

  @override
  String get currencyMDL => 'Leu Moldova';

  @override
  String get currencyGEL => 'Tiếng Lari Georgia';

  @override
  String get currencyAMD => 'kịch Armenia';

  @override
  String get currencyAZN => 'Manat của Azerbaijan';

  @override
  String get currencyKZT => 'Tenge Kazakhstan';

  @override
  String get currencyTMT => 'Manat của người Thổ Nhĩ Kỳ';

  @override
  String get currencyKGS => 'Som Kyrgyzstan';

  @override
  String get currencyTJS => 'Somoni Tajikistan';

  @override
  String get currencyUZS => 'Som Uzbek';

  @override
  String get currencyUSD => 'đô la Mỹ';

  @override
  String get currencyEUR => 'Euro';

  @override
  String fullNumber(String phoneNumber) {
    return 'Số đầy đủ: $phoneNumber';
  }

  @override
  String get sendCode => 'Gửi mã';

  @override
  String get enterVerificationCode => 'Nhập mã xác minh';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Gửi lại mã';

  @override
  String expires(String time) {
    return 'Hết hạn: $time';
  }

  @override
  String get verifyAndContinue => 'Xác minh và tiếp tục';

  @override
  String get invalidVerificationCode => 'Mã xác minh không hợp lệ';

  @override
  String get verificationCodeSent => 'Mã xác minh đã được gửi thành công';

  @override
  String get failedToSendCode => 'Không gửi được mã xác minh';

  @override
  String get verificationCodeResent => 'Mã xác minh được gửi lại thành công';

  @override
  String get failedToResendCode => 'Không thể gửi lại mã xác minh';

  @override
  String get passwordVerification => 'Xác minh mật khẩu';

  @override
  String get completeRegistrationPrompt =>
      'Nhập tên người dùng và mật khẩu để hoàn tất đăng ký';

  @override
  String get username => 'Tên người dùng';

  @override
  String get username_required => 'Tên người dùng là bắt buộc';

  @override
  String get username_min_length => 'Tên người dùng phải có ít nhất 2 ký tự';

  @override
  String get usernameHint => 'Tên người dùng123';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get profileImage => 'Hình ảnh hồ sơ';

  @override
  String get imageInstructions =>
      'Hình ảnh sẽ hiện ra ở đây, vui lòng nhấn ảnh hồ sơ';

  @override
  String get finish => 'Hoàn thành';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get registrationError => 'Lỗi đăng ký';

  @override
  String get about => 'Về chúng tôi';

  @override
  String get chat => 'Trò chuyện';

  @override
  String get realEstate => 'Bất động sản';

  @override
  String get language => 'ANH';

  @override
  String get languageEn => 'Tiếng Anh';

  @override
  String get languageRu => 'tiếng Nga';

  @override
  String get languageUz => 'tiếng Uzbek';

  @override
  String get serviceLiked => 'Dịch vụ thích';

  @override
  String get support => 'Ủng hộ';

  @override
  String get service => 'Dịch vụ kinh doanh';

  @override
  String get aboutContent =>
      'TezSell là một thị trường nhanh chóng và dễ dàng để mua bán các sản phẩm mới và đã qua sử dụng. Sứ mệnh của chúng tôi là tạo ra nền tảng thuận tiện và hiệu quả nhất cho mọi người dùng, đảm bảo giao dịch suôn sẻ và trải nghiệm thân thiện với người dùng. Cho dù bạn đang muốn bán hay mua, TezSell giúp bạn dễ dàng kết nối và hoàn tất giao dịch chỉ trong vài bước. Chúng tôi ưu tiên bảo mật và quyền riêng tư của người dùng. Tất cả các giao dịch đều được giám sát cẩn thận để đảm bảo an toàn và tuân thủ, mang lại sự an tâm cho cả người mua và người bán. Giao diện đơn giản và trực quan của chúng tôi cho phép người dùng nhanh chóng liệt kê các sản phẩm và tìm thấy những gì họ cần. Chúng tôi cũng tạo điều kiện thuận lợi cho việc liên lạc theo thời gian thực thông qua Telegram, giúp quá trình mua và bán trở nên suôn sẻ hơn.';

  @override
  String get errorMessage => 'Đã xảy ra lỗi, vui lòng kiểm tra máy chủ';

  @override
  String get searchLocation => 'Vị trí';

  @override
  String get searchCategory => 'Thể loại';

  @override
  String get searchProductPlaceholder => 'Tìm kiếm sản phẩm';

  @override
  String get searchServicePlaceholder => 'Tìm kiếm dịch vụ';

  @override
  String get search_products_subtitle =>
      'Tìm những ưu đãi tuyệt vời trong khu vực lân cận của bạn';

  @override
  String get search_services_subtitle =>
      'Tìm các chuyên gia trong khu phố của bạn';

  @override
  String get search_products_error => 'Lỗi tìm kiếm sản phẩm';

  @override
  String get search_services_error => 'Lỗi tìm kiếm dịch vụ';

  @override
  String get load_more_products_error => 'Lỗi tải thêm sản phẩm';

  @override
  String get load_more_services_error => 'Lỗi tải thêm dịch vụ';

  @override
  String get try_different_keywords => 'Hãy thử các từ khóa khác nhau';

  @override
  String get searchText => 'Tìm kiếm';

  @override
  String get selectedCategory => 'Danh mục đã chọn:';

  @override
  String get selectedLocation => 'Vị trí đã chọn:';

  @override
  String get productError => 'Không có sản phẩm nào';

  @override
  String get serviceError => 'Không có dịch vụ nào';

  @override
  String get locationHeader => 'Chọn một vị trí';

  @override
  String get locationPlaceholder => 'Tìm kiếm khu vực ở đây';

  @override
  String get categoryHeader => 'Chọn một danh mục';

  @override
  String get categoryPlaceholder => 'Tìm kiếm danh mục';

  @override
  String get categoryError => 'Không có danh mục nào';

  @override
  String get paginationFirst => 'Đầu tiên';

  @override
  String get paginationPrevious => 'Trước';

  @override
  String get pageInfo => 'Trang của';

  @override
  String get pageNext => 'Kế tiếp';

  @override
  String get pageLast => 'Cuối cùng';

  @override
  String get loadingMessageProduct => 'Đang tải sản phẩm...';

  @override
  String get loadingMessageError => 'Lỗi khi tải';

  @override
  String get likeProductError => 'Đã xảy ra lỗi khi thích sản phẩm';

  @override
  String get dislikeProductError => 'Đã xảy ra lỗi khi không thích sản phẩm';

  @override
  String get loadingMessageLocation => 'Đang tải vị trí ...';

  @override
  String get loadingLocationError => 'Lỗi khi tải vị trí';

  @override
  String get loadingMessageCategory => 'Đang tải danh mục ...';

  @override
  String get loadingCategoryError => 'Lỗi tải danh mục:';

  @override
  String get profileUpdateSuccessMessage => 'Hồ sơ được cập nhật thành công';

  @override
  String get profileUpdateFailMessage => 'Không thể cập nhật hồ sơ';

  @override
  String get seeMoreBtn => 'Xem thêm';

  @override
  String get profilePageTitle => 'Trang hồ sơ';

  @override
  String get editProfileModalTitle => 'Chỉnh sửa hồ sơ';

  @override
  String get usernameLabel => 'Tên người dùng';

  @override
  String get locationLabel => 'Vị trí hiện tại';

  @override
  String get profileImageLabel => 'Hình ảnh hồ sơ';

  @override
  String get chooseFileLabel => 'Chọn một tập tin';

  @override
  String get uploadBtnLabel => 'Cập nhật';

  @override
  String get uploadingBtnLabel => 'Đang cập nhật...';

  @override
  String get cancelBtnLabel => 'Hủy bỏ';

  @override
  String get productsTitle => 'Các sản phẩm';

  @override
  String get servicesTitle => 'Dịch vụ';

  @override
  String get myProductsTitle => 'Sản phẩm của tôi';

  @override
  String get myServicesTitle => 'Dịch vụ của tôi';

  @override
  String get favoriteProductsTitle => 'Sản phẩm yêu thích';

  @override
  String get favoriteServicesTitle => 'Dịch vụ yêu thích';

  @override
  String get noFavorites => 'Không có mục yêu thích';

  @override
  String get addNewProductBtn => 'Thêm sản phẩm mới';

  @override
  String get addNew => 'Mới';

  @override
  String get addNewServiceBtn => 'Thêm dịch vụ mới';

  @override
  String get downloadMobileApp => 'Tải xuống ứng dụng di động';

  @override
  String get registerPhoneNumberSuccess =>
      'Số điện thoại đã được xác minh! Bạn có thể tiến hành bước tiếp theo.';

  @override
  String get regionSelectedMessage => 'Khu vực đã chọn:';

  @override
  String get districtSelectMessage => 'Quận được chọn:';

  @override
  String get phoneNumberEmptyMessage =>
      'Vui lòng xác minh số điện thoại của bạn trước khi tiếp tục';

  @override
  String get regionEmptyMessage => 'Vui lòng chọn khu vực trước';

  @override
  String get districtEmptyMessage => 'Vui lòng chọn quận';

  @override
  String get usernamePasswordEmptyMessage =>
      'Vui lòng nhập tên người dùng và mật khẩu';

  @override
  String get registerTitle => 'Đăng ký';

  @override
  String get previousButton => 'Trước';

  @override
  String get nextButton => 'Kế tiếp';

  @override
  String get completeButton => 'Hoàn thành';

  @override
  String stepIndicator(int currentStep) {
    return 'Bước $currentStep trên 4';
  }

  @override
  String get districtSelectTitle => 'Danh sách quận';

  @override
  String get districtSelectParagraph => 'Chọn quận:';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get sendOtp => 'Gửi OTP';

  @override
  String get sendAgain => 'Gửi lại';

  @override
  String get verify => 'Xác minh';

  @override
  String get failedToSendOtp => 'Không gửi được OTP. Máy chủ trả về sai.';

  @override
  String get errorSendingOtp => 'Đã xảy ra lỗi khi gửi OTP.';

  @override
  String get invalidPhoneNumber => 'Vui lòng nhập số điện thoại hợp lệ.';

  @override
  String get verificationSuccess => 'Đã xác minh thành công';

  @override
  String get verificationError => 'Đã xảy ra lỗi. Vui lòng thử lại sau.';

  @override
  String get regionsList => 'Danh sách khu vực';

  @override
  String get enterUsername => 'Nhập tên người dùng của bạn';

  @override
  String get welcomeMessage =>
      'Chào mừng bạn đến với Tezsell, đăng nhập bằng số điện thoại của bạn';

  @override
  String get noAccount => 'Chưa có tài khoản? Đăng ký tại đây';

  @override
  String get successLogin => 'Đăng nhập thành công';

  @override
  String get myProfile => 'Hồ sơ của tôi';

  @override
  String get logout => 'đăng xuất';

  @override
  String get newProductTitle => 'Tiêu đề';

  @override
  String get newProductDescription => 'Sự miêu tả';

  @override
  String get newProductPrice => 'Giá';

  @override
  String get newProductCondition => 'Tình trạng';

  @override
  String get newProductCategory => 'Loại';

  @override
  String get newProductImages => 'Hình ảnh';

  @override
  String get addNewService => 'Thêm dịch vụ mới';

  @override
  String get creating => 'Đang tạo...';

  @override
  String get serviceName => 'Tên dịch vụ';

  @override
  String get serviceNamePlaceholder => 'Nhập tiêu đề dịch vụ';

  @override
  String get serviceDescription => 'Mô tả dịch vụ';

  @override
  String get serviceDescriptionPlaceholder => 'Nhập mô tả dịch vụ';

  @override
  String get serviceCategory => 'Danh mục dịch vụ';

  @override
  String get selectCategory => 'Chọn danh mục';

  @override
  String get loadingCategories => 'Đang tải...';

  @override
  String get errorLoadingCategories => 'Lỗi tải danh mục';

  @override
  String get serviceImages => 'Hình ảnh dịch vụ';

  @override
  String get imageUploadHelper =>
      'Bấm vào biểu tượng + để thêm hình ảnh (tối đa 10)';

  @override
  String get maxImagesError => 'Bạn có thể tải lên tối đa 10 hình ảnh';

  @override
  String get categoryNotFound => 'Không tìm thấy danh mục';

  @override
  String get productCreatedSuccess => 'Sản phẩm được tạo thành công';

  @override
  String get productLikeSuccess => 'Sản phẩm được yêu thích thành công';

  @override
  String get productDislikeSuccess => 'Sản phẩm không thích thành công';

  @override
  String get errorCreatingService => 'Lỗi khi tạo dịch vụ';

  @override
  String get errorCreatingProduct => 'Lỗi khi tạo sản phẩm';

  @override
  String get unknownError => 'Đã xảy ra lỗi không xác định khi tạo dịch vụ';

  @override
  String get submit => 'Nộp';

  @override
  String get selectCategoryAction => 'Chọn danh mục';

  @override
  String get selectCondition => 'Chọn điều kiện';

  @override
  String get sum => 'Tổng';

  @override
  String get noComments =>
      'Chưa có bình luận nào Hãy là người đầu tiên bình luận!';

  @override
  String get commentLikeSuccess => 'Bình luận đã thích thành công';

  @override
  String get commentLikeError => 'Lỗi khi thích bình luận';

  @override
  String get unknownErrorMessage => 'Đã xảy ra lỗi không xác định';

  @override
  String get commentDislikeSuccess => 'Bình luận không thích thành công';

  @override
  String get commentDislikeError => 'Lỗi khi không thích bình luận';

  @override
  String get replyInfo => 'Vui lòng nhập câu trả lời trước';

  @override
  String get replySuccessMessage => 'Đã thêm câu trả lời thành công';

  @override
  String get replyErrorMessage =>
      'Đã xảy ra lỗi trong quá trình tạo câu trả lời';

  @override
  String get commentUpdateSuccess => 'Đã cập nhật bình luận thành công';

  @override
  String get commentUpdateError => 'Lỗi cập nhật mục bình luận';

  @override
  String get deleteConfirmationMessage =>
      'Bạn có chắc chắn muốn xóa bình luận này?';

  @override
  String get commentDeleteSuccess => 'Đã xóa bình luận thành công';

  @override
  String get commentDeleteError => 'Lỗi xóa bình luận';

  @override
  String get editLabel => 'Biên tập';

  @override
  String get deleteLabel => 'Xóa bỏ';

  @override
  String get saveLabel => 'Cứu';

  @override
  String get replyLabel => 'Hồi đáp';

  @override
  String get replyTitle => 'câu trả lời';

  @override
  String get replyPlaceholder => 'Viết thư trả lời...';

  @override
  String get chatLoginMessage => 'Bạn phải đăng nhập để bắt đầu trò chuyện';

  @override
  String get chatYourselfMessage => 'Bạn không thể trò chuyện với chính mình.';

  @override
  String get chatRoomMessage => 'Phòng trò chuyện đã được tạo!';

  @override
  String get chatRoomError => 'Không tạo được cuộc trò chuyện!';

  @override
  String get chatCreationError => 'Tạo cuộc trò chuyện không thành công!';

  @override
  String get productsTotal => 'Tổng sản phẩm';

  @override
  String get perPage => 'mặt hàng';

  @override
  String get clearAllFilters => 'Xóa tất cả bộ lọc';

  @override
  String get clickToUpload => 'Bấm để tải lên';

  @override
  String get productInStock => 'Còn hàng';

  @override
  String get productOutStock => 'Hết hàng';

  @override
  String get productBack => 'Quay lại sản phẩm';

  @override
  String get messageSeller => 'Trò chuyện';

  @override
  String get recommendedProducts => 'Sản phẩm được đề xuất';

  @override
  String get deleteConfirmationProduct =>
      'Bạn có chắc chắn muốn xóa sản phẩm này?';

  @override
  String get productDeleteSuccess => 'Đã xóa sản phẩm thành công';

  @override
  String get productDeleteError => 'Lỗi xóa sản phẩm';

  @override
  String get newCondition => 'Mới';

  @override
  String get used => 'Đã sử dụng';

  @override
  String get imageValidType =>
      'Một số tập tin chưa được thêm vào. Vui lòng sử dụng các tệp JPG, PNG, GIF hoặc WebP dưới 5 MB.';

  @override
  String get imageConfirmMessage => 'Bạn có chắc chắn muốn xóa hình ảnh này?';

  @override
  String get titleRequiredMessage => 'Tiêu đề là bắt buộc';

  @override
  String get descRequiredMessage => 'Mô tả là bắt buộc';

  @override
  String get priceRequiredMessage => 'Giá là bắt buộc';

  @override
  String get conditionRequiredMessage => 'Điều kiện là bắt buộc';

  @override
  String get pleaseFillAllRequired => 'Vui lòng điền vào các trường bắt buộc';

  @override
  String get oneImageConfirmMessage => 'Cần có ít nhất một hình ảnh sản phẩm';

  @override
  String get categoryRequiredMessage => 'Danh mục là bắt buộc';

  @override
  String get locationInfoError => 'Thiếu thông tin vị trí người dùng';

  @override
  String get editProductTitle => 'Chỉnh sửa sản phẩm';

  @override
  String get imageUploadRequirements =>
      'Ít nhất một hình ảnh là bắt buộc. Bạn có thể tải lên tối đa 10 hình ảnh (JPG, PNG, GIF, WebP mỗi hình có dung lượng dưới 5MB).';

  @override
  String get productUpdatedSuccess => 'Sản phẩm được cập nhật thành công';

  @override
  String get productUpdateFailed => 'Cập nhật sản phẩm không thành công';

  @override
  String get errorUpdatingProduct => 'Đã xảy ra lỗi khi cập nhật sản phẩm';

  @override
  String get serviceBack => 'Quay lại dịch vụ';

  @override
  String get likeLabel => 'Giống';

  @override
  String get commentsLabel => 'Bình luận';

  @override
  String get writeComment => 'Viết bình luận...';

  @override
  String get postingLabel => 'Đang đăng...';

  @override
  String get commentCreated => 'Đã tạo nhận xét';

  @override
  String get postCommentLabel => 'Đăng bình luận';

  @override
  String get loginPrompt => 'Vui lòng đăng nhập để xem và gửi bình luận.';

  @override
  String get recommendedServices => 'Dịch vụ được đề xuất';

  @override
  String get commentsVisibilityNotice =>
      'Bình luận chỉ hiển thị đối với người dùng đã đăng nhập.';

  @override
  String get comingSoon => 'Sắp ra mắt';

  @override
  String get serviceUpdateSuccess => 'Đã cập nhật dịch vụ thành công';

  @override
  String get serviceUpdateError => 'Lỗi cập nhật mục dịch vụ';

  @override
  String get editServiceModalTitle => 'Chỉnh sửa dịch vụ';

  @override
  String get enterPhoneNumberWithoutCode => 'Nhập số điện thoại không cần mã';

  @override
  String get heroTitle => 'TezSell';

  @override
  String get heroSubtitle =>
      'Thị trường nhanh chóng và dễ dàng của bạn cho Uzbekistan';

  @override
  String get startSelling => 'Bắt đầu bán';

  @override
  String get browseProducts => 'Duyệt sản phẩm';

  @override
  String get featuresTitle => 'Tại sao chọn TezSell?';

  @override
  String get listingTitle => 'Danh sách sản phẩm đơn giản';

  @override
  String get listingDescription =>
      'Liệt kê các mục của bạn chỉ với một vài cú nhấp chuột. Thêm ảnh, đặt giá và kết nối với người mua ngay lập tức.';

  @override
  String get locationTitle => 'Duyệt web dựa trên vị trí';

  @override
  String get locationDescription =>
      'Tìm giao dịch gần bạn. Hệ thống dựa trên vị trí của chúng tôi giúp bạn khám phá các vật phẩm trong vùng lân cận của bạn.';

  @override
  String get location_subtitle =>
      'Chọn khu vực và quận của bạn để xem danh sách gần đó';

  @override
  String get categoryTitle => 'Lọc danh mục';

  @override
  String get categoryDescription =>
      'Dễ dàng điều hướng qua các danh mục khác nhau để tìm thấy chính xác những gì bạn đang tìm kiếm.';

  @override
  String get inspirationTitle => 'Lấy cảm hứng từ chợ cà rốt Hàn Quốc';

  @override
  String get inspirationDescription1 =>
      'Chúng tôi đã xây dựng TezSell lấy cảm hứng từ Chợ cà rốt (당근마켓) thành công của Hàn Quốc nhưng đã điều chỉnh nó một cách cụ thể để đáp ứng nhu cầu riêng của cộng đồng địa phương ở Uzbekistan.';

  @override
  String get inspirationDescription2 =>
      'Sứ mệnh của chúng tôi là tạo ra một nền tảng đáng tin cậy nơi những người hàng xóm có thể mua, bán và kết nối với nhau một cách dễ dàng.';

  @override
  String get comingSoonTitle => 'Sắp có trên TezSell';

  @override
  String get inAppChat => 'Trò chuyện trong ứng dụng';

  @override
  String get secureTransactions => 'Giao dịch an toàn';

  @override
  String get realEstateListings => 'Danh sách bất động sản';

  @override
  String get stayUpdated => 'Luôn cập nhật';

  @override
  String get comingSoonBadge => 'Sắp ra mắt';

  @override
  String get ctaTitle => 'Tham gia cộng đồng TezSell ngay hôm nay!';

  @override
  String get ctaDescription =>
      'Hãy tham gia xây dựng trải nghiệm thị trường tốt hơn cho Uzbekistan. Chia sẻ phản hồi của bạn và giúp chúng tôi phát triển!';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get learnMore => 'Tìm hiểu thêm';

  @override
  String get replyUpdateSuccess => 'Đã cập nhật câu trả lời thành công';

  @override
  String get replyUpdateError => 'Không cập nhật được câu trả lời';

  @override
  String get replyDeleteSuccess => 'Đã xóa trả lời thành công';

  @override
  String get replyDeleteError => 'Không thể xóa câu trả lời';

  @override
  String get replyDeleteConfirmation =>
      'Bạn có chắc chắn muốn xóa câu trả lời này?';

  @override
  String get authenticationRequired => 'Yêu cầu xác thực';

  @override
  String get enterValidReply => 'Vui lòng nhập văn bản trả lời hợp lệ';

  @override
  String get saving => 'Đang lưu...';

  @override
  String get deleting => 'Đang xóa...';

  @override
  String get properties => 'Của cải';

  @override
  String get agents => 'Đại lý';

  @override
  String get becomeAgent => 'Trở thành đại lý';

  @override
  String get main => 'Chủ yếu';

  @override
  String get upload => 'Tải lên';

  @override
  String get filtered_products => 'Sản phẩm được lọc';

  @override
  String get filtered_services => 'Dịch vụ được lọc';

  @override
  String get productDetail => 'Chi tiết sản phẩm';

  @override
  String get unknownUser => 'Người dùng không xác định';

  @override
  String get locationNotAvailable => 'Vị trí không có sẵn';

  @override
  String get noTitle => 'Không có tiêu đề';

  @override
  String get noCategory => 'Không có danh mục';

  @override
  String get noDescription => 'Không có mô tả';

  @override
  String get som => 'Som';

  @override
  String get about_me => 'Giới thiệu về tôi';

  @override
  String get my_name => 'Tên tôi';

  @override
  String get customer_support => 'Hỗ trợ khách hàng';

  @override
  String get customer_center => 'Trung tâm khách hàng';

  @override
  String get customer_inquiries => 'Thắc mắc';

  @override
  String get customer_terms => 'Điều khoản và Điều kiện';

  @override
  String get region => 'Vùng đất';

  @override
  String get district => 'Huyện';

  @override
  String get tap_change_profile => 'Nhấn để thay đổi ảnh';

  @override
  String get language_settings => 'Cài đặt ngôn ngữ';

  @override
  String get selectLanguage => 'Chọn một ngôn ngữ';

  @override
  String get select_theme => 'Chọn chủ đề';

  @override
  String get theme => 'chủ đề';

  @override
  String get location_settings => 'Cài đặt vị trí';

  @override
  String get security => 'Bảo vệ';

  @override
  String get data_storage => 'Dữ liệu & Lưu trữ';

  @override
  String get accessibility => 'Khả năng tiếp cận';

  @override
  String get privacy => 'Sự riêng tư';

  @override
  String get light_theme => 'Ánh sáng';

  @override
  String get dark_theme => 'Tối tăm';

  @override
  String get system_theme => 'Mặc định hệ thống';

  @override
  String get my_products => 'Sản phẩm của tôi';

  @override
  String get refresh => 'Làm cho khỏe lại';

  @override
  String get delete_product => 'Xóa sản phẩm';

  @override
  String get delete_confirmation => 'Bạn có chắc chắn muốn xóa sản phẩm này?';

  @override
  String get delete => 'Xóa bỏ';

  @override
  String error_loading_products(String error) {
    return 'Lỗi tải sản phẩm: $error';
  }

  @override
  String get product_deleted_success => 'Đã xóa sản phẩm thành công';

  @override
  String error_deleting_product(String error) {
    return 'Lỗi xóa sản phẩm: $error';
  }

  @override
  String get no_products_found => 'Không tìm thấy sản phẩm nào';

  @override
  String get add_first_product =>
      'Bắt đầu bằng cách thêm sản phẩm đầu tiên của bạn';

  @override
  String get no_title => 'Không có tiêu đề';

  @override
  String get no_description => 'Không có mô tả';

  @override
  String get in_stock => 'Còn hàng';

  @override
  String get out_of_stock => 'Hết hàng';

  @override
  String get new_condition => 'MỚI';

  @override
  String get edit_product => 'Chỉnh sửa sản phẩm';

  @override
  String get delete_product_tooltip => 'Xóa sản phẩm';

  @override
  String get sum_currency => 'Tổng';

  @override
  String get edit_product_title => 'Chỉnh sửa sản phẩm';

  @override
  String get product_name => 'Tên sản phẩm';

  @override
  String get product_description => 'Mô tả sản phẩm';

  @override
  String get price => 'Giá';

  @override
  String get condition => 'Tình trạng';

  @override
  String get condition_new => 'Mới';

  @override
  String get condition_used => 'Đã sử dụng';

  @override
  String get condition_refurbished => 'tân trang lại';

  @override
  String get currency => 'Tiền tệ';

  @override
  String get category => 'Loại';

  @override
  String get images => 'Hình ảnh';

  @override
  String get existing_images => 'Hình ảnh hiện có';

  @override
  String get new_images => 'Hình ảnh mới';

  @override
  String get image_instructions =>
      'Hình ảnh sẽ xuất hiện ở đây. Vui lòng nhấn vào biểu tượng tải lên ở trên.';

  @override
  String get update_button => 'Cập nhật';

  @override
  String loading_category_error(String error) {
    return 'Lỗi tải danh mục: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Lỗi chọn ảnh: $error';
  }

  @override
  String get please_fill_all_required => 'Vui lòng điền vào tất cả các trường';

  @override
  String get invalid_price_message =>
      'Giá đã nhập không hợp lệ. Vui lòng nhập một số hợp lệ.';

  @override
  String get category_required_message => 'Vui lòng chọn một danh mục hợp lệ.';

  @override
  String get one_image_required_message =>
      'Cần có ít nhất một hình ảnh sản phẩm';

  @override
  String get product_updated_success => 'Sản phẩm được cập nhật thành công';

  @override
  String error_updating_product(String error) {
    return 'Lỗi khi cập nhật sản phẩm: $error';
  }

  @override
  String get my_services => 'Dịch vụ của tôi';

  @override
  String get delete_service => 'Xóa dịch vụ';

  @override
  String get delete_service_confirmation =>
      'Bạn có chắc chắn muốn xóa dịch vụ này?';

  @override
  String get no_services_found => 'Không tìm thấy dịch vụ nào';

  @override
  String get add_first_service =>
      'Bắt đầu bằng cách thêm dịch vụ đầu tiên của bạn';

  @override
  String get edit_service => 'Chỉnh sửa dịch vụ';

  @override
  String get delete_service_tooltip => 'Xóa dịch vụ';

  @override
  String get service_deleted_successfully => 'Đã xóa dịch vụ thành công';

  @override
  String get error_deleting_service => 'Lỗi xóa dịch vụ';

  @override
  String get error_loading_services => 'Lỗi tải dịch vụ';

  @override
  String get service_name => 'Tên dịch vụ';

  @override
  String get enter_service_name => 'Nhập tên dịch vụ';

  @override
  String get service_name_required => 'Tên dịch vụ là bắt buộc';

  @override
  String get service_name_min_length => 'Tên dịch vụ phải có ít nhất 3 ký tự';

  @override
  String get enter_service_description => 'Nhập mô tả dịch vụ';

  @override
  String get service_description_required => 'Mô tả dịch vụ là bắt buộc';

  @override
  String get service_description_min_length => 'Mô tả phải có ít nhất 10 ký tự';

  @override
  String get category_required => 'Vui lòng chọn một danh mục';

  @override
  String get no_categories_available => 'Không có danh mục nào';

  @override
  String get location => 'Vị trí';

  @override
  String get select_location => 'Chọn vị trí';

  @override
  String get location_required => 'Vui lòng chọn một vị trí';

  @override
  String get no_locations_available => 'Không có địa điểm nào';

  @override
  String get add_images => 'Thêm hình ảnh';

  @override
  String get current_images => 'Hình ảnh hiện tại';

  @override
  String get no_images_selected => 'Không có hình ảnh nào được chọn';

  @override
  String get save_changes => 'Lưu thay đổi';

  @override
  String get map_main => 'Bản đồ & Thuộc tính';

  @override
  String get agent_status => 'Trạng thái đại lý';

  @override
  String get admin_panel => 'Bảng quản trị';

  @override
  String get propertiesFound => 'Thuộc tính được tìm thấy';

  @override
  String get propertiesSaved => 'thuộc tính đã lưu';

  @override
  String get saved => 'đã lưu';

  @override
  String get loadingProperties => 'Đang tải thuộc tính...';

  @override
  String get failedToLoad => 'Không thể tải thuộc tính. Vui lòng thử lại.';

  @override
  String get noPropertiesFound => 'Không tìm thấy tài sản nào';

  @override
  String get tryAdjusting => 'Hãy thử điều chỉnh tiêu chí tìm kiếm của bạn';

  @override
  String get search_placeholder => 'Tìm kiếm theo tiêu đề hoặc vị trí...';

  @override
  String get search_filters => 'Bộ lọc';

  @override
  String get search_button => 'Tìm kiếm';

  @override
  String get search_clear_filters => 'Xóa bộ lọc';

  @override
  String get filter_options_sale_and_rent => 'Bán và cho thuê';

  @override
  String get filter_options_for_sale => 'Cần bán';

  @override
  String get filter_options_for_rent => 'Cho thuê';

  @override
  String get filter_options_all_types => 'Tất cả các loại';

  @override
  String get filter_options_apartment => 'Căn hộ';

  @override
  String get filter_options_house => 'Căn nhà';

  @override
  String get filter_options_townhouse => 'Nhà phố';

  @override
  String get filter_options_villa => 'biệt thự';

  @override
  String get filter_options_commercial => 'Thuộc về thương mại';

  @override
  String get filter_options_office => 'Văn phòng';

  @override
  String get property_card_featured => 'Nổi bật';

  @override
  String get property_card_bed => 'phòng ngủ';

  @override
  String get property_card_bath => 'phòng tắm';

  @override
  String get property_card_parking => 'bãi đậu xe';

  @override
  String get property_card_view_details => 'Xem chi tiết';

  @override
  String get property_card_contact => 'Liên hệ';

  @override
  String get property_card_balcony => 'Ban công';

  @override
  String get property_card_garage => 'Ga-ra';

  @override
  String get property_card_garden => 'Vườn';

  @override
  String get property_card_pool => 'Hồ bơi';

  @override
  String get property_card_elevator => 'Thang máy';

  @override
  String get property_card_furnished => 'Có nội thất';

  @override
  String get property_card_sales => 'việc bán hàng';

  @override
  String get pricing_month => '/tháng';

  @override
  String get results_properties_found => 'Thuộc tính được tìm thấy';

  @override
  String get results_properties_saved => 'thuộc tính đã lưu';

  @override
  String get results_saved => 'đã lưu';

  @override
  String get results_loading_properties => 'Đang tải thuộc tính...';

  @override
  String get results_failed_to_load =>
      'Không thể tải thuộc tính. Vui lòng thử lại.';

  @override
  String get results_no_properties_found => 'Không tìm thấy tài sản nào';

  @override
  String get results_try_adjusting =>
      'Hãy thử điều chỉnh tiêu chí tìm kiếm của bạn';

  @override
  String get no_properties_found => 'Không tìm thấy tài sản nào';

  @override
  String get no_category_properties =>
      'Không có bất động sản nào trong danh mục này';

  @override
  String get properties_loading => 'Đang tải thuộc tính...';

  @override
  String get all_properties_loaded => 'Đã tải tất cả thuộc tính';

  @override
  String n_properties(int count) {
    return '$count thuộc tính';
  }

  @override
  String get in_area => 'trong khu vực';

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
  String get pagination_previous => 'Trước';

  @override
  String get pagination_next => 'Kế tiếp';

  @override
  String get pagination_page => 'Trang';

  @override
  String get pagination_page_of => 'Trang 1 của';

  @override
  String get contact_modal_title => 'Thông tin liên hệ';

  @override
  String get contact_modal_agent_contact => 'Liên hệ đại lý';

  @override
  String get contact_modal_property_owner => 'Chủ sở hữu tài sản';

  @override
  String get contact_modal_agent_phone_number => 'Số điện thoại đại lý';

  @override
  String get contact_modal_owner_phone_number => 'Số điện thoại của chủ sở hữu';

  @override
  String get contact_modal_license => 'Giấy phép';

  @override
  String get contact_modal_rating => 'Đánh giá';

  @override
  String get contact_modal_call_now => 'Gọi ngay';

  @override
  String get contact_modal_copy_number => 'Sao chép số';

  @override
  String get contact_modal_close => 'Đóng';

  @override
  String get contact_modal_contact_hours => 'Giờ liên hệ: 9:00 sáng - 8:00 tối';

  @override
  String get contact_modal_agent => 'Đại lý';

  @override
  String get errors_toggle_save_failed =>
      'Không thể chuyển đổi lưu thuộc tính:';

  @override
  String get errors_copy_failed => 'Không sao chép được số điện thoại:';

  @override
  String get errors_phone_copied =>
      'Đã sao chép số điện thoại vào bảng nhớ tạm';

  @override
  String get errors_error_occurred_regions => 'Đã xảy ra lỗi với các khu vực';

  @override
  String get errors_error_occurred_districts => 'Đã xảy ra lỗi với các quận';

  @override
  String get errors_please_fill_all_required_fields =>
      'Vui lòng điền vào tất cả các trường bắt buộc';

  @override
  String get errors_authentication_required => 'Yêu cầu xác thực';

  @override
  String get errors_user_info_missing => 'Thiếu thông tin người dùng';

  @override
  String get errors_validation_error =>
      'Vui lòng kiểm tra dữ liệu đầu vào của bạn';

  @override
  String get errors_permission_denied => 'Quyền bị từ chối';

  @override
  String get errors_server_error => 'Đã xảy ra lỗi máy chủ';

  @override
  String get errors_network_error => 'Lỗi kết nối mạng';

  @override
  String get errors_timeout_error => 'Đã vượt quá thời gian chờ yêu cầu';

  @override
  String get errors_custom_error => 'Đã xảy ra lỗi';

  @override
  String get errors_error_creating_property => 'Lỗi khi tạo thuộc tính';

  @override
  String get errors_unknown_error_message => 'Đã xảy ra lỗi không xác định';

  @override
  String get errors_coordinates_not_found =>
      'Không thể tìm thấy tọa độ cho địa chỉ này. Vui lòng nhập chúng theo cách thủ công.';

  @override
  String get errors_coordinates_error =>
      'Lỗi lấy tọa độ. Vui lòng nhập chúng theo cách thủ công.';

  @override
  String get property_info_views => 'lượt xem';

  @override
  String get property_info_listed => 'Đã niêm yết';

  @override
  String get property_info_price_per_sqm => '/m2';

  @override
  String get property_info_saved => 'Đã lưu';

  @override
  String get property_info_save => 'Cứu';

  @override
  String get property_info_share => 'Chia sẻ';

  @override
  String get loading_loading => 'Đang tải...';

  @override
  String get loading_loading_details => 'Đang tải chi tiết thuộc tính...';

  @override
  String get loading_property_not_found => 'Không tìm thấy tài sản';

  @override
  String get loading_property_not_found_message =>
      'Sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.';

  @override
  String get loading_back_to_properties => 'Quay lại Thuộc tính';

  @override
  String get loading_title => 'Đang tải đại lý...';

  @override
  String get loading_message =>
      'Vui lòng đợi trong khi chúng tôi tải danh sách đại lý.';

  @override
  String get loading_agent_not_found => 'Không tìm thấy đại lý';

  @override
  String get property_details_title => 'Chi tiết tài sản';

  @override
  String get property_details_bedrooms => 'Phòng ngủ';

  @override
  String get property_details_bathrooms => 'Phòng tắm';

  @override
  String get property_details_floor_area => 'Diện tích sàn';

  @override
  String get property_details_parking => 'bãi đậu xe';

  @override
  String get property_details_basic_information => 'Thông tin cơ bản';

  @override
  String get property_details_property_type => 'Loại tài sản:';

  @override
  String get property_details_listing_type => 'Loại danh sách:';

  @override
  String get property_details_for_sale => 'Cần bán';

  @override
  String get property_details_for_rent => 'Cho thuê';

  @override
  String get property_details_year_built => 'Năm xây dựng:';

  @override
  String get property_details_floor => 'Sàn nhà:';

  @override
  String get property_details_of => 'của';

  @override
  String get property_details_features_amenities => 'Tính năng & Tiện nghi';

  @override
  String get sections_description => 'Sự miêu tả';

  @override
  String get sections_nearby_amenities => 'Tiện ích lân cận';

  @override
  String get sections_similar_properties => 'Thuộc tính tương tự';

  @override
  String get amenities_metro => 'tàu điện ngầm';

  @override
  String get amenities_school => 'Trường học';

  @override
  String get amenities_hospital => 'Bệnh viện';

  @override
  String get amenities_shopping => 'Mua sắm';

  @override
  String get amenities_away => 'xa';

  @override
  String get contact_title => 'Thông tin liên hệ';

  @override
  String get contact_professional_listing => 'Danh sách chuyên nghiệp';

  @override
  String get contact_listed_by_agent =>
      'Được liệt kê bởi đại lý đã được xác minh';

  @override
  String get contact_by_owner => 'Bởi chủ sở hữu';

  @override
  String get contact_direct_contact =>
      'Liên hệ trực tiếp với chủ sở hữu tài sản';

  @override
  String get contact_property_owner => 'Chủ sở hữu tài sản';

  @override
  String get contact_call_agent => 'Gọi đại lý';

  @override
  String get contact_email_agent => 'Đại lý email';

  @override
  String get contact_call_owner => 'Chủ sở hữu cuộc gọi';

  @override
  String get contact_email_owner => 'Chủ sở hữu email';

  @override
  String get contact_send_inquiry => 'Gửi yêu cầu';

  @override
  String get property_status_title => 'Tình trạng tài sản';

  @override
  String get property_status_availability => 'sẵn có:';

  @override
  String get property_status_available => 'Có sẵn';

  @override
  String get property_status_not_available => 'Không có sẵn';

  @override
  String get property_status_featured => 'Nổi bật:';

  @override
  String get property_status_featured_property => 'Tài sản nổi bật';

  @override
  String get property_status_property_id => 'ID thuộc tính:';

  @override
  String get inquiry_title => 'Gửi yêu cầu';

  @override
  String get inquiry_inquiry_type => 'Loại yêu cầu';

  @override
  String get inquiry_request_info => 'Yêu cầu thông tin';

  @override
  String get inquiry_schedule_viewing => 'Xem lịch biểu';

  @override
  String get inquiry_make_offer => 'đưa ra lời đề nghị';

  @override
  String get inquiry_request_callback => 'Yêu cầu gọi lại';

  @override
  String get inquiry_message => 'Tin nhắn';

  @override
  String get inquiry_message_placeholder =>
      'Hãy cho chúng tôi biết sự quan tâm của bạn đối với bất động sản này...';

  @override
  String get inquiry_offered_price => 'Giá chào bán';

  @override
  String get inquiry_enter_offer => 'Nhập ưu đãi của bạn';

  @override
  String get inquiry_preferred_contact_time =>
      'Thời gian liên hệ ưa thích (tùy chọn)';

  @override
  String get inquiry_contact_time_placeholder =>
      'ví dụ: Các ngày trong tuần 9:00 sáng - 5:00 chiều';

  @override
  String get inquiry_cancel => 'Hủy bỏ';

  @override
  String get inquiry_sending => 'Đang gửi...';

  @override
  String get inquiry_send_inquiry => 'Gửi yêu cầu';

  @override
  String get inquiry_inquiry_sent_success => 'Yêu cầu đã được gửi thành công!';

  @override
  String get inquiry_inquiry_sent_error =>
      'Không thể gửi yêu cầu. Vui lòng thử lại.';

  @override
  String get alerts_link_copied =>
      'Đã sao chép liên kết thuộc tính vào clipboard!';

  @override
  String get alerts_phone_copied =>
      'Số điện thoại đã được sao chép vào clipboard!';

  @override
  String get alerts_save_property_failed => 'Không thể lưu thuộc tính:';

  @override
  String get alerts_email_subject => 'Hỏi về:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Xin chào,\\n\\nTôi quan tâm đến bất động sản của bạn \"$title\" tọa lạc tại $address.\\n\\nVui lòng liên hệ với tôi để biết thêm thông tin.\\n\\nTrân trọng';
  }

  @override
  String get related_properties_view_details => 'Xem chi tiết';

  @override
  String get header_property => 'Tìm tài sản mơ ước của bạn';

  @override
  String get header_sub_property =>
      'Khám phá các cơ hội bất động sản cao cấp tại những khu vực đáng mơ ước nhất của Tashkent';

  @override
  String get header_title => 'Đại lý bất động sản';

  @override
  String get header_subtitle =>
      'Tìm đại lý có kinh nghiệm để giúp đỡ với nhu cầu bất động sản của bạn';

  @override
  String get header_agents_found => 'đại lý được tìm thấy';

  @override
  String get filters_all_specializations => 'Tất cả các chuyên ngành';

  @override
  String get filters_residential => 'Khu dân cư';

  @override
  String get filters_commercial => 'Thuộc về thương mại';

  @override
  String get filters_luxury => 'Sang trọng';

  @override
  String get filters_investment => 'Sự đầu tư';

  @override
  String get filters_any_rating => 'Bất kỳ đánh giá nào';

  @override
  String get filters_four_stars => '4+ Sao';

  @override
  String get filters_four_half_stars => '4,5+ sao';

  @override
  String get filters_five_stars => '5 sao';

  @override
  String get filters_highest_rated => 'Đánh giá cao nhất';

  @override
  String get filters_lowest_rated => 'Xếp hạng thấp nhất';

  @override
  String get filters_most_sales => 'Bán hàng nhiều nhất';

  @override
  String get filters_most_experience => 'Kinh nghiệm nhất';

  @override
  String get agent_card_verified_agent => 'Đại lý đã được xác minh';

  @override
  String get agent_card_years_experience => 'năm kinh nghiệm';

  @override
  String get agent_card_years => 'năm';

  @override
  String get agent_card_license => 'Giấy phép';

  @override
  String get agent_card_specialization => 'Chuyên môn';

  @override
  String get agent_card_view_profile => 'Xem hồ sơ';

  @override
  String get agent_card_contact => 'Liên hệ';

  @override
  String get agent_card_verified => 'Đã xác minh';

  @override
  String get no_results_title => 'Không tìm thấy đại lý';

  @override
  String get no_results_message =>
      'Hãy thử điều chỉnh tiêu chí hoặc bộ lọc tìm kiếm của bạn.';

  @override
  String get error_title => 'Lỗi tải đại lý';

  @override
  String get error_message =>
      'Không thể tải danh sách đại lý. Vui lòng thử lại.';

  @override
  String get error_retry => 'Thử lại';

  @override
  String get error_default_message => 'Không thể tải chi tiết đại lý';

  @override
  String get error_try_again => 'Thử lại';

  @override
  String get notifications_phone_copied =>
      'Đã sao chép số điện thoại vào bảng nhớ tạm';

  @override
  String get notifications_copy_failed => 'Không sao chép được số điện thoại:';

  @override
  String get fallback_agent_name => 'Đại lý';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Gửi tài sản';

  @override
  String get navigation_submitting => 'Đang gửi...';

  @override
  String get navigation_back_to_agents => 'Quay lại Đại lý';

  @override
  String get agent_profile_verified_agent => 'Đại lý đã được xác minh';

  @override
  String get agent_profile_contact_agent => 'Liên hệ đại lý';

  @override
  String get agent_profile_send_message => 'Gửi tin nhắn';

  @override
  String get agent_profile_years_experience => 'Số năm kinh nghiệm';

  @override
  String get agent_profile_properties_sold => 'Bất động sản đã bán';

  @override
  String get agent_profile_active_listings => 'Danh sách đang hoạt động';

  @override
  String get agent_profile_total_properties => 'Tổng tài sản';

  @override
  String get tabs_overview => 'Tổng quan';

  @override
  String get tabs_properties => 'của cải';

  @override
  String get tabs_reviews => 'đánh giá';

  @override
  String get about_agent_title => 'Giới thiệu về đại lý';

  @override
  String get about_agent_agency => 'Hãng';

  @override
  String get about_agent_license_number => 'Số giấy phép';

  @override
  String get about_agent_specialization => 'Chuyên môn';

  @override
  String get about_agent_member_since => 'Thành viên kể từ';

  @override
  String get about_agent_verified_since => 'Đã xác minh kể từ';

  @override
  String get performance_metrics_title => 'Số liệu hiệu suất';

  @override
  String get performance_metrics_average_rating => 'Đánh giá trung bình';

  @override
  String get performance_metrics_properties_sold => 'Bất động sản đã bán';

  @override
  String get performance_metrics_active_listings => 'Danh sách đang hoạt động';

  @override
  String get performance_metrics_years_experience => 'Số năm kinh nghiệm';

  @override
  String get contact_info_title => 'Thông tin liên hệ';

  @override
  String get contact_info_contact_via_platform => 'Liên hệ qua Nền tảng';

  @override
  String get verification_status_title => 'Trạng thái xác minh';

  @override
  String get verification_status_verified_agent => 'Đại lý đã được xác minh';

  @override
  String get verification_status_pending_verification => 'Đang chờ xác minh';

  @override
  String get verification_status_licensed_professional =>
      'Chuyên gia được cấp phép';

  @override
  String get verification_status_registered_agency => 'Đại lý đã đăng ký';

  @override
  String get quick_actions_title => 'Thao tác nhanh';

  @override
  String get quick_actions_call_now => 'Gọi ngay';

  @override
  String get quick_actions_send_message => 'Gửi tin nhắn';

  @override
  String get quick_actions_view_properties => 'Xem thuộc tính';

  @override
  String get properties_title => 'Thuộc tính đại lý';

  @override
  String get properties_loading_properties => 'Đang tải thuộc tính...';

  @override
  String get properties_no_properties_title => 'Không tìm thấy thuộc tính nào';

  @override
  String get properties_no_properties_message =>
      'Thuộc tính của đại lý này sẽ xuất hiện ở đây.';

  @override
  String get properties_recent_properties_note =>
      'Hiển thị các thuộc tính gần đây. Kiểm tra danh sách đầy đủ cho tất cả các tài sản đại lý.';

  @override
  String get properties_listed => 'Đã niêm yết';

  @override
  String get properties_bed => 'giường';

  @override
  String get properties_bath => 'bồn tắm';

  @override
  String get properties_for_sale => 'Cần bán';

  @override
  String get properties_for_rent => 'Cho thuê';

  @override
  String get reviews_title => 'Đánh giá của khách hàng';

  @override
  String get reviews_no_reviews_title => 'Chưa có đánh giá nào';

  @override
  String get reviews_no_reviews_message =>
      'Đánh giá và đề xuất của khách hàng sẽ xuất hiện ở đây.';

  @override
  String get fallbacks_agent_name => 'Đại lý';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => 'Thuộc tính đã lưu';

  @override
  String get saved_properties_subtitle =>
      'Thuộc tính yêu thích của bạn ở một nơi';

  @override
  String get saved_properties_no_saved_properties =>
      'Chưa có thuộc tính nào được lưu';

  @override
  String get saved_properties_start_saving =>
      'Bắt đầu khám phá và lưu các thuộc tính bạn thích';

  @override
  String get saved_properties_browse_properties => 'Duyệt thuộc tính';

  @override
  String get saved_properties_saved_on => 'Đã lưu vào';

  @override
  String get auth_login_required => 'Vui lòng đăng nhập để xem tài sản đã lưu';

  @override
  String get auth_login => 'Đăng nhập';

  @override
  String get success_property_unsaved =>
      'Thuộc tính đã bị xóa khỏi danh sách đã lưu';

  @override
  String get success_property_saved => 'Đã lưu thuộc tính thành công';

  @override
  String get success_phone_copied => 'Đã sao chép số điện thoại!';

  @override
  String get success_property_created_success =>
      'Thuộc tính được tạo thành công!';

  @override
  String get success_agent_approved => 'Đại lý được phê duyệt thành công';

  @override
  String get success_agent_rejected => 'Đại lý đã từ chối thành công';

  @override
  String get steps_step => 'Bước chân';

  @override
  String get steps_basic_information => 'Thông tin cơ bản';

  @override
  String get steps_location_details => 'Chi tiết vị trí';

  @override
  String get steps_property_details => 'Chi tiết tài sản';

  @override
  String get steps_property_images => 'Hình ảnh tài sản';

  @override
  String get basic_info_tell_us_about_property =>
      'Hãy cho chúng tôi biết về tài sản của bạn';

  @override
  String get basic_info_property_type => 'Loại tài sản';

  @override
  String get basic_info_listing_type => 'Loại danh sách';

  @override
  String get basic_info_property_title => 'Tiêu đề tài sản';

  @override
  String get basic_info_title_placeholder =>
      'Nhập tiêu đề mô tả cho thuộc tính của bạn';

  @override
  String get basic_info_description => 'Sự miêu tả';

  @override
  String get basic_info_description_placeholder =>
      'Mô tả chi tiết tài sản của bạn...';

  @override
  String get property_types_apartment => 'Căn hộ';

  @override
  String get property_types_house => 'Căn nhà';

  @override
  String get property_types_townhouse => 'Nhà phố';

  @override
  String get property_types_villa => 'biệt thự';

  @override
  String get property_types_commercial => 'Thuộc về thương mại';

  @override
  String get property_types_office => 'Văn phòng';

  @override
  String get property_types_land => 'Đất';

  @override
  String get property_types_warehouse => 'Kho';

  @override
  String get listing_types_for_sale => 'Cần bán';

  @override
  String get listing_types_for_rent => 'Cho thuê';

  @override
  String get location_where_is_property => 'Tài sản của bạn nằm ở đâu?';

  @override
  String get location_full_address => 'Địa chỉ đầy đủ';

  @override
  String get location_address_placeholder => 'Nhập địa chỉ đầy đủ';

  @override
  String get location_region => 'Vùng đất';

  @override
  String get location_select_region => 'Chọn vùng';

  @override
  String get location_district => 'Huyện';

  @override
  String get location_select_district => 'Chọn quận';

  @override
  String get location_city => 'Thành phố';

  @override
  String get location_city_placeholder => 'Thành phố';

  @override
  String get location_loading_regions => 'Đang tải vùng...';

  @override
  String get location_loading_districts => 'Đang tải các quận...';

  @override
  String get location_map_coordinates => 'Tọa độ bản đồ';

  @override
  String get location_get_coordinates => 'Nhận tọa độ';

  @override
  String get location_latitude => 'Vĩ độ';

  @override
  String get location_longitude => 'Kinh độ';

  @override
  String get location_coordinates_set => 'Đã đặt tọa độ';

  @override
  String get location_location_tips => 'Mẹo về vị trí';

  @override
  String get location_location_tip_1 =>
      '• Điền địa chỉ trước, sau đó nhấp vào \'Nhận tọa độ\' để tự động lấy vị trí trên bản đồ';

  @override
  String get location_location_tip_2 =>
      '• Bạn cũng có thể nhập tọa độ theo cách thủ công nếu biết chính xác vị trí';

  @override
  String get location_location_tip_3 =>
      '• Tọa độ chính xác giúp người mua tìm thấy tài sản của bạn trên bản đồ';

  @override
  String get property_details_provide_detailed_info =>
      'Cung cấp thông tin chi tiết về tài sản của bạn';

  @override
  String get property_details_total_floors => 'Tổng số tầng';

  @override
  String get property_details_area_m2 => 'Diện tích (m2)';

  @override
  String get property_details_parking_spaces => 'Chỗ đỗ xe';

  @override
  String get property_details_price => 'Giá';

  @override
  String get property_details_features => 'Đặc trưng';

  @override
  String get images_add_photos_showcase =>
      'Thêm ảnh để giới thiệu tài sản của bạn';

  @override
  String get images_click_to_upload => 'Bấm để tải hình ảnh lên';

  @override
  String get images_max_images_info => 'Tối đa 10 hình ảnh, JPG, PNG hoặc WEBP';

  @override
  String get images_main => 'Chủ yếu';

  @override
  String get images_maximum_images_allowed => 'Cho phép tối đa 10 hình ảnh';

  @override
  String get admin_dashboard_title => 'Trang tổng quan dành cho quản trị viên';

  @override
  String get admin_dashboard_subtitle =>
      'Tổng quan theo thời gian thực về nền tảng bất động sản của bạn';

  @override
  String get admin_last_update => 'Cập nhật lần cuối';

  @override
  String get admin_total_properties => 'Tổng tài sản';

  @override
  String get admin_total_agents => 'Tổng đại lý';

  @override
  String get admin_total_users => 'Tổng số người dùng';

  @override
  String get admin_total_views => 'Tổng số lượt xem';

  @override
  String get admin_error_loading_dashboard => 'Lỗi tải trang tổng quan';

  @override
  String get admin_failed_to_load_data =>
      'Không tải được dữ liệu trang tổng quan';

  @override
  String get admin_avg_sale_price => 'Giá bán trung bình';

  @override
  String get admin_avg_sale_price_subtitle => 'Tất cả danh sách đang hoạt động';

  @override
  String get admin_total_portfolio_value => 'Tổng giá trị danh mục đầu tư';

  @override
  String get admin_total_portfolio_value_subtitle => 'Giá trị tài sản tổng hợp';

  @override
  String get admin_avg_price_per_sqm => 'Giá trung bình mỗi mét vuông';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Chỉ báo tỷ giá thị trường';

  @override
  String get admin_property_types_distribution => 'Phân bổ loại tài sản';

  @override
  String get admin_properties_by_city => 'Bất động sản theo thành phố';

  @override
  String get admin_properties_by_district => 'Bất động sản theo quận';

  @override
  String get admin_inquiry_types_distribution => 'Phân phối loại yêu cầu';

  @override
  String get admin_agent_verification_rate => 'Tỷ lệ xác minh đại lý';

  @override
  String get admin_agent_verification_rate_subtitle => 'Kiểm soát chất lượng';

  @override
  String get admin_inquiry_response_rate => 'Tỷ lệ phản hồi yêu cầu';

  @override
  String get admin_inquiry_response_rate_subtitle => 'Dịch vụ khách hàng';

  @override
  String get admin_avg_views_per_property =>
      'Lượt xem trung bình trên mỗi thuộc tính';

  @override
  String get admin_avg_views_per_property_subtitle =>
      'Mức độ phổ biến của tài sản';

  @override
  String get admin_featured_properties => 'Thuộc tính nổi bật';

  @override
  String get admin_featured_properties_subtitle => 'Danh sách cao cấp';

  @override
  String get admin_most_viewed_properties => 'Thuộc tính được xem nhiều nhất';

  @override
  String get admin_top_performing_agents => 'Đại lý có hiệu suất hàng đầu';

  @override
  String get admin_system_health => 'Tình trạng hệ thống';

  @override
  String get admin_properties_without_images => 'Thuộc tính không có hình ảnh';

  @override
  String get admin_missing_location_data => 'Thiếu dữ liệu vị trí';

  @override
  String get admin_pending_agent_verification => 'Đang chờ xác minh đại lý';

  @override
  String get admin_active => 'tích cực';

  @override
  String get admin_verified => 'đã xác minh';

  @override
  String get admin_active_7d => 'hoạt động (7ngày)';

  @override
  String get admin_this_month => 'tháng này';

  @override
  String get agents_loading_pending_applications =>
      'Đang tải các ứng dụng đang chờ xử lý...';

  @override
  String get agents_error_loading_applications => 'Lỗi tải ứng dụng';

  @override
  String get agents_pending_agents => 'Đại lý đang chờ xử lý';

  @override
  String get agents_total_pending_applications =>
      'Tổng số hồ sơ đang chờ xử lý:';

  @override
  String get agents_pending_verification => 'Đang chờ xác minh';

  @override
  String get agents_applied_date => 'Đã áp dụng:';

  @override
  String get agents_contact_info => 'Thông tin liên hệ';

  @override
  String get agents_license_number => 'Số giấy phép';

  @override
  String get agents_years_experience => 'Số năm kinh nghiệm';

  @override
  String get agents_years_suffix => 'năm';

  @override
  String get agents_total_sales => 'Tổng doanh thu';

  @override
  String get agents_specialization => 'Chuyên môn';

  @override
  String get agents_approve => 'Chấp thuận';

  @override
  String get agents_reject => 'Từ chối';

  @override
  String get agents_no_pending_applications =>
      'Không có ứng dụng đang chờ xử lý';

  @override
  String get agents_all_applications_processed =>
      'Tất cả các ứng dụng đại lý đã được xử lý';

  @override
  String get general_previous => 'Trước';

  @override
  String get general_page => 'Trang';

  @override
  String get general_next => 'Kế tiếp';

  @override
  String get general_views => 'lượt xem';

  @override
  String get general_sales => 'việc bán hàng';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'Русский';

  @override
  String get general_language_en => 'Tiếng Anh';

  @override
  String get general_super_admin => 'Siêu quản trị viên';

  @override
  String get general_staff => 'Nhân viên';

  @override
  String get general_verified_agent => 'Đại lý đã được xác minh';

  @override
  String get general_pending_agent => 'Đại lý đang chờ xử lý';

  @override
  String get general_regular_user => 'Người dùng thông thường';

  @override
  String get general_admin => 'Quản trị viên';

  @override
  String get general_dashboard => 'Trang tổng quan';

  @override
  String get general_manage_users => 'Quản lý người dùng';

  @override
  String get general_verified_agents => 'Đại lý đã được xác minh';

  @override
  String get general_agent_panel => 'Bảng đại lý';

  @override
  String get general_create_property => 'Tạo thuộc tính';

  @override
  String get general_my_properties => 'Thuộc tính của tôi';

  @override
  String get general_inquiries => 'Thắc mắc';

  @override
  String get general_agent_profile => 'Hồ sơ đại lý';

  @override
  String get general_live => 'Sống';

  @override
  String get general_logged_out_successfully => 'Đăng xuất thành công';

  @override
  String get general_logout_completed_with_errors =>
      'Đăng xuất hoàn tất (có lỗi)';

  @override
  String get general_application_under_review =>
      'Đơn đăng ký đang được xem xét';

  @override
  String get general_check_status => 'Kiểm tra trạng thái →';

  @override
  String get general_last_updated => 'Cập nhật lần cuối:';

  @override
  String get general_permissions_may_be_outdated => 'Quyền có thể đã lỗi thời';

  @override
  String get general_permissions_up_to_date => 'Quyền được cập nhật';

  @override
  String get general_never => 'Không bao giờ';

  @override
  String get general_properties_found => 'Thuộc tính được tìm thấy';

  @override
  String get general_properties_saved => 'thuộc tính đã lưu';

  @override
  String get general_saved => 'đã lưu';

  @override
  String get general_loading_properties => 'Đang tải thuộc tính...';

  @override
  String get general_failed_to_load =>
      'Không thể tải thuộc tính. Vui lòng thử lại.';

  @override
  String get general_no_properties_found => 'Không tìm thấy tài sản nào';

  @override
  String get general_try_adjusting =>
      'Hãy thử điều chỉnh tiêu chí tìm kiếm của bạn';

  @override
  String get select_category => 'Chọn danh mục';

  @override
  String get service_description => 'Mô tả dịch vụ';

  @override
  String get product_search_placeholder => 'Nhập từ khóa để tìm sản phẩm';

  @override
  String get privacy_policy => 'Chính sách bảo mật';

  @override
  String get terms_subtitle => 'Chính sách và điều khoản về quyền riêng tư';

  @override
  String get last_updated => 'Cập nhật lần cuối';

  @override
  String get contact_information => 'Thông tin liên hệ';

  @override
  String get accept_terms => 'Tôi chấp nhận Điều khoản và Điều kiện';

  @override
  String get read_terms =>
      'Vui lòng đọc các điều khoản và điều kiện của chúng tôi';

  @override
  String get inquiries => 'Thắc mắc & Hỗ trợ';

  @override
  String get inquiries_subtitle => 'Liên hệ với chúng tôi để được giúp đỡ';

  @override
  String get help_center => 'Chúng tôi có thể giúp gì cho bạn?';

  @override
  String get help_subtitle =>
      'Chúng tôi ở đây để hỗ trợ bạn với bất kỳ câu hỏi nào';

  @override
  String get contact_us => 'Liên hệ với chúng tôi';

  @override
  String get email_support => 'Hỗ trợ qua email';

  @override
  String get call_support => 'Gọi hỗ trợ';

  @override
  String get send_message => 'Gửi tin nhắn';

  @override
  String get fill_contact_form => 'Điền vào mẫu liên hệ';

  @override
  String get contact_form => 'Mẫu liên hệ';

  @override
  String get name => 'Tên của bạn';

  @override
  String get name_required => 'Vui lòng nhập tên của bạn';

  @override
  String get email => 'Địa chỉ email';

  @override
  String get email_required => 'Vui lòng nhập email của bạn';

  @override
  String get email_invalid => 'Vui lòng nhập email hợp lệ';

  @override
  String get subject => 'Chủ thể';

  @override
  String get subject_required => 'Vui lòng nhập chủ đề';

  @override
  String get message => 'Tin nhắn';

  @override
  String get message_required => 'Vui lòng nhập tin nhắn của bạn';

  @override
  String get message_too_short => 'Tin nhắn phải có ít nhất 10 ký tự';

  @override
  String get faq => 'Câu hỏi thường gặp';

  @override
  String get follow_us => 'Theo dõi chúng tôi';

  @override
  String get faq_how_to_sell =>
      'Làm cách nào để bán các mặt hàng trên Tezsell?';

  @override
  String get faq_how_to_sell_answer =>
      'Để bán các mặt hàng: 1) Tạo tài khoản, 2) Nhấn vào nút \'+\', 3) Chọn danh mục (Sản phẩm/Dịch vụ/Bất động sản), 4) Thêm ảnh và mô tả, 5) Đặt giá của bạn, 6) Xuất bản! Danh sách của bạn sẽ được hiển thị cho người mua trong khu vực của bạn.';

  @override
  String get faq_is_free => 'Tezsell có được sử dụng miễn phí không?';

  @override
  String get faq_is_free_answer =>
      'Đúng! Tezsell hiện miễn phí 100%. Không có phí niêm yết, không có hoa hồng bán hàng, không có phí đăng ký. Chúng tôi có thể giới thiệu các tính năng cao cấp trong tương lai nhưng sẽ thông báo cho người dùng trước 30 ngày.';

  @override
  String get faq_safety => 'Làm thế nào tôi có thể giữ an toàn khi mua/bán?';

  @override
  String get faq_safety_answer =>
      'Mẹo an toàn: 1) Gặp nhau ở nơi công cộng, 2) Kiểm tra đồ vật trước khi thanh toán, 3) Không bao giờ gửi tiền cho người lạ, 4) Hãy tin vào bản năng của bạn, 5) Báo cáo những người dùng đáng ngờ, 6) Không chia sẻ thông tin cá nhân quá sớm, 7) Mang theo bạn bè để giao dịch có giá trị cao.';

  @override
  String get faq_payment => 'Thanh toán hoạt động như thế nào?';

  @override
  String get faq_payment_answer =>
      'Tezsell không xử lý thanh toán. Người mua và người bán thỏa thuận thanh toán trực tiếp (tiền mặt, chuyển khoản…). Chúng tôi chỉ là nền tảng để kết nối mọi người - bạn tự xử lý giao dịch.';

  @override
  String get faq_prohibited => 'Những mặt hàng nào bị cấm?';

  @override
  String get faq_prohibited_answer =>
      'Các mặt hàng bị cấm bao gồm: vũ khí, ma túy, hàng ăn cắp, hàng giả, nội dung người lớn, động vật sống (không có giấy phép), ID chính phủ và vật liệu nguy hiểm. Xem Điều khoản & Điều kiện của chúng tôi để biết danh sách đầy đủ.';

  @override
  String get faq_account_delete => 'Làm cách nào để xóa tài khoản của tôi?';

  @override
  String get faq_account_delete_answer =>
      'Đi tới Hồ sơ → Cài đặt → Cài đặt tài khoản → Xóa tài khoản. Lưu ý: Việc này là vĩnh viễn và không thể hoàn tác. Tất cả danh sách của bạn sẽ bị xóa.';

  @override
  String get faq_report_user =>
      'Làm cách nào để báo cáo người dùng hoặc danh sách?';

  @override
  String get faq_report_user_answer =>
      'Nhấn vào ba dấu chấm (·····) trên bất kỳ danh sách hoặc hồ sơ người dùng nào, sau đó chọn \'Báo cáo\'. Chọn lý do và gửi. Chúng tôi xem xét tất cả các báo cáo trong vòng 24-48 giờ.';

  @override
  String get faq_change_location => 'Làm cách nào để thay đổi vị trí của tôi?';

  @override
  String get faq_change_location_answer =>
      'Nhấn vào nút vị trí ở góc trên bên trái của màn hình chính. Bạn có thể chọn khu vực và quận của mình để xem danh sách trong khu vực của bạn.';

  @override
  String get welcome_customer_center =>
      'Chào mừng đến với Trung tâm khách hàng';

  @override
  String get customer_center_subtitle => 'Chúng tôi ở đây để giúp bạn 24/7';

  @override
  String get quick_actions => 'Thao tác nhanh';

  @override
  String get live_chat => 'Trò chuyện trực tiếp';

  @override
  String get chat_with_us => 'Trò chuyện với chúng tôi';

  @override
  String get find_answers => 'Tìm câu trả lời';

  @override
  String get my_tickets => 'Vé của tôi';

  @override
  String get view_tickets => 'Xem vé';

  @override
  String get feedback => 'Nhận xét';

  @override
  String get share_feedback => 'Chia sẻ phản hồi';

  @override
  String get contact_methods => 'Phương thức liên hệ';

  @override
  String get phone_support => 'Hỗ trợ qua điện thoại';

  @override
  String get available_247 => 'Có sẵn 24/7';

  @override
  String get response_24h => 'Phản hồi trong vòng 24 giờ';

  @override
  String get telegram_support => 'Hỗ trợ Telegram';

  @override
  String get instant_replies => 'Trả lời tức thì';

  @override
  String get whatsapp_support => 'Hỗ trợ WhatsApp';

  @override
  String get quick_response => 'Phản hồi nhanh';

  @override
  String get popular_topics => 'Chủ đề phổ biến';

  @override
  String get account_management => 'Quản lý tài khoản';

  @override
  String get reset_password => 'Đặt lại mật khẩu';

  @override
  String get update_profile => 'Cập nhật hồ sơ';

  @override
  String get verify_account => 'Xác minh tài khoản';

  @override
  String get delete_account => 'Xóa tài khoản';

  @override
  String get buying_selling => 'Mua & Bán';

  @override
  String get how_to_post => 'Cách đăng quảng cáo';

  @override
  String get payment_methods => 'Phương thức thanh toán';

  @override
  String get shipping_delivery => 'Vận chuyển & Giao hàng';

  @override
  String get return_policy => 'Chính sách hoàn trả';

  @override
  String get safety_security => 'An toàn & An ninh';

  @override
  String get report_scam => 'Báo cáo Lừa đảo';

  @override
  String get safe_trading => 'Mẹo giao dịch an toàn';

  @override
  String get privacy_settings => 'Cài đặt quyền riêng tư';

  @override
  String get blocked_users => 'Người dùng bị chặn';

  @override
  String get technical_issues => 'Vấn đề kỹ thuật';

  @override
  String get app_not_working => 'Ứng dụng không hoạt động';

  @override
  String get upload_failed => 'Tải lên không thành công';

  @override
  String get login_problems => 'Sự cố đăng nhập';

  @override
  String get support_hours => 'Giờ hỗ trợ';

  @override
  String get mon_fri_9_6 => 'Thứ Hai-Thứ Sáu: 9:00 sáng - 6:00 chiều';

  @override
  String get how_are_we_doing => 'Chúng ta đang làm việc thế nào?';

  @override
  String get rate_experience =>
      'Đánh giá trải nghiệm dịch vụ khách hàng của bạn';

  @override
  String get poor => 'Nghèo';

  @override
  String get okay => 'Đồng ý';

  @override
  String get good => 'Tốt';

  @override
  String get excellent => 'Xuất sắc';

  @override
  String get account_secure => 'Tài khoản của bạn được bảo mật';

  @override
  String get password_security => 'Mật khẩu & xác thực';

  @override
  String get change_password => 'Thay đổi mật khẩu';

  @override
  String get two_factor_auth => 'Xác thực hai yếu tố';

  @override
  String get biometric_login => 'Đăng nhập sinh trắc học';

  @override
  String get login_activity => 'Hoạt động đăng nhập';

  @override
  String get active_sessions => 'Phiên hoạt động';

  @override
  String get login_alerts => 'Cảnh báo đăng nhập';

  @override
  String get account_protection => 'Bảo vệ tài khoản';

  @override
  String get recovery_email => 'Email khôi phục';

  @override
  String get backup_codes => 'Mã dự phòng';

  @override
  String get danger_zone => 'Vùng nguy hiểm';

  @override
  String get improve_security => 'Cải thiện bảo mật';

  @override
  String get security_score => 'Điểm bảo mật';

  @override
  String get last_changed_days => 'Thay đổi lần cuối 30 ngày trước';

  @override
  String get logout_all_devices => 'Đăng xuất tất cả các thiết bị';

  @override
  String get end_all_sessions => 'Kết thúc tất cả các phiên';

  @override
  String get permanently_delete => 'Xóa vĩnh viễn';

  @override
  String get verification_code_message =>
      'Chúng tôi sẽ gửi mã xác minh để xác nhận đó là bạn.';

  @override
  String get send_code => 'Gửi mã';

  @override
  String get enter_verification_code => 'Nhập mã xác minh';

  @override
  String get verification_code => 'Mã xác minh';

  @override
  String get new_password => 'Mật khẩu mới';

  @override
  String get confirm_password => 'Xác nhận mật khẩu';

  @override
  String get resend_code => 'Gửi lại mã';

  @override
  String get code_sent_to => 'Nhập mã xác minh được gửi tới';

  @override
  String get enter_code => 'Nhập mã xác minh';

  @override
  String get code_must_be_6_digits => 'Mã phải có 6 chữ số';

  @override
  String get enter_new_password => 'Nhập mật khẩu mới';

  @override
  String get minimum_8_characters => 'Tối thiểu 8 ký tự';

  @override
  String get passwords_do_not_match => 'Mật khẩu không khớp';

  @override
  String get close => 'Đóng';

  @override
  String get current => 'Hiện hành';

  @override
  String get session_ended => 'Phiên kết thúc';

  @override
  String get update_recovery_email => 'Cập nhật email khôi phục';

  @override
  String get new_email => 'Email mới';

  @override
  String get update => 'Cập nhật';

  @override
  String get verification_email_sent => 'Đã gửi email xác minh';

  @override
  String get generate_emergency_codes => 'Tạo mã khẩn cấp';

  @override
  String get copy_all => 'Sao chép tất cả';

  @override
  String get code_copied => 'Đã sao chép mã';

  @override
  String get all_codes_copied => 'Tất cả các mã được sao chép';

  @override
  String get logout_all_devices_confirm => 'Đăng xuất tất cả các thiết bị?';

  @override
  String get logout_all_devices_message =>
      'Thao tác này sẽ kết thúc tất cả các phiên hoạt động trên tất cả các thiết bị.';

  @override
  String get logout_all => 'Đăng xuất tất cả';

  @override
  String get delete_account_confirm => 'Xóa tài khoản?';

  @override
  String get delete_account_warning =>
      'Hành động này là VĨNH VIỄN và không thể hoàn tác. Tất cả dữ liệu của bạn sẽ bị xóa vĩnh viễn.';

  @override
  String get what_will_be_deleted => 'Nội dung nào sẽ bị xóa:';

  @override
  String get profile_and_account_info =>
      '• Thông tin hồ sơ và tài khoản của bạn';

  @override
  String get all_listings_and_posts => '• Tất cả danh sách và bài đăng của bạn';

  @override
  String get messages_and_conversations => 'Tin nhắn';

  @override
  String get saved_items_and_preferences => '• Các mục và tùy chọn đã lưu';

  @override
  String get enter_password_to_continue => 'Nhập mật khẩu của bạn để tiếp tục';

  @override
  String get continue_val => 'Tiếp tục';

  @override
  String get please_enter_password => 'Vui lòng nhập mật khẩu của bạn';

  @override
  String get enter_confirmation_code => 'Nhập mã xác nhận';

  @override
  String get deletion_confirmation_message =>
      'Chúng tôi đã gửi mã xác nhận tới điện thoại của bạn. Nhập nó vào bên dưới để xóa vĩnh viễn tài khoản của bạn.';

  @override
  String get confirmation_code => 'Mã xác nhận';

  @override
  String get please_enter_6_digit_code => 'Vui lòng nhập mã gồm 6 chữ số';

  @override
  String get account_deleted => 'Tài khoản của bạn đã bị xóa';

  @override
  String get deletion_cancelled => 'Đã hủy xóa';

  @override
  String get failed_to_load_user_info => 'Không tải được thông tin người dùng';

  @override
  String get auth_login_to_view_saved =>
      'Vui lòng đăng nhập để xem tài sản đã lưu của bạn';

  @override
  String get authLoginRequired => 'Yêu cầu đăng nhập';

  @override
  String get authLoginToViewSaved =>
      'Vui lòng đăng nhập để xem tài sản đã lưu của bạn';

  @override
  String get authLogin => 'Đăng nhập';

  @override
  String get savedPropertiesTitle => 'Thuộc tính đã lưu';

  @override
  String get loadingSavedProperties => 'Đang tải thuộc tính đã lưu...';

  @override
  String get errorsFailedToLoadSaved => 'Không tải được thuộc tính đã lưu';

  @override
  String get actionsRetry => 'Thử lại';

  @override
  String get savedPropertiesNoSaved => 'Không có thuộc tính đã lưu';

  @override
  String get savedPropertiesStartSaving =>
      'Bắt đầu khám phá và lưu các thuộc tính bạn thích';

  @override
  String get savedPropertiesBrowse => 'Duyệt thuộc tính';

  @override
  String get resultsSavedProperties => 'thuộc tính đã lưu';

  @override
  String get actionsRefresh => 'Làm cho khỏe lại';

  @override
  String get resultsNoMoreProperties => 'Không còn tài sản nào nữa';

  @override
  String get propertyCardFeatured => 'Nổi bật';

  @override
  String get successPropertyUnsaved =>
      'Thuộc tính đã bị xóa khỏi danh sách đã lưu';

  @override
  String get alertsUnsavePropertyFailed => 'Không thể xóa thuộc tính';

  @override
  String get propertyCardBed => 'giường';

  @override
  String get propertyCardBath => 'bồn tắm';

  @override
  String get savedPropertiesSavedOn => 'Đã lưu vào';

  @override
  String get propertyCardViewDetails => 'Xem chi tiết';

  @override
  String get serviceDetailTitle => 'Chi tiết dịch vụ';

  @override
  String get errorLoadingFavorites => 'Lỗi tải các mục yêu thích';

  @override
  String get noFavoritesFound => 'Không tìm thấy mục yêu thích.';

  @override
  String get commentUpdatedSuccess => 'Bình luận được cập nhật thành công!';

  @override
  String get errorUpdatingComment => 'Lỗi cập nhật bình luận';

  @override
  String get replyAddedSuccess => 'Đã thêm câu trả lời thành công!';

  @override
  String get errorAddingReply => 'Lỗi khi thêm câu trả lời';

  @override
  String get commentDeletedSuccess => 'Đã xóa bình luận thành công!';

  @override
  String get errorDeletingComment => 'Lỗi xóa bình luận';

  @override
  String get serviceLikedSuccess => 'Dịch vụ thích thành công!';

  @override
  String get errorLikingService => 'Lỗi thích dịch vụ';

  @override
  String get serviceDislikedSuccess => 'Dịch vụ không thích thành công!';

  @override
  String get errorDislikingService => 'Lỗi không thích dịch vụ';

  @override
  String get writeYourReply => 'Viết câu trả lời của bạn...';

  @override
  String get postReply => 'Gửi trả lời';

  @override
  String get anonymous => 'Vô danh';

  @override
  String get editComment => 'Chỉnh sửa nhận xét';

  @override
  String get editYourComment => 'Chỉnh sửa nhận xét của bạn...';

  @override
  String get saveChanges => 'Lưu thay đổi';

  @override
  String get propertyOwner => 'Chủ sở hữu tài sản';

  @override
  String get errorLoadingServices => 'Lỗi tải dịch vụ';

  @override
  String get noRecommendedServicesFound =>
      'Không tìm thấy dịch vụ được đề xuất.';

  @override
  String get passwordRequired => 'Cần có mật khẩu';

  @override
  String get passwordTooShort => 'Mật khẩu phải có ít nhất 8 ký tự';

  @override
  String get passwordRequirements => 'Mật khẩu phải chứa chữ cái và số';

  @override
  String get usernameRequired => 'Tên người dùng là bắt buộc';

  @override
  String get usernameTooShort => 'Tên người dùng phải có ít nhất 3 ký tự';

  @override
  String get confirmPasswordRequired => 'Cần phải xác nhận mật khẩu';

  @override
  String get passwordHelp => 'Ít nhất 8 ký tự, chữ cái và số';

  @override
  String get usernameExists => 'Tên người dùng này đã tồn tại';

  @override
  String get phoneExists => 'Số điện thoại này đã được đăng ký';

  @override
  String get networkError =>
      'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối của bạn';

  @override
  String get contactSeller => 'Liên hệ với người bán';

  @override
  String get callToReveal => 'Nhấn \"Gọi\" để tiết lộ';

  @override
  String get camera => 'Máy ảnh';

  @override
  String get gallery => 'Phòng trưng bày';

  @override
  String get selectImageSource => 'Chọn nguồn hình ảnh';

  @override
  String get uploading => 'Đang tải lên...';

  @override
  String get acceptTermsRequired =>
      'Bạn phải chấp nhận Điều khoản và Điều kiện để tiếp tục';

  @override
  String get iAgreeToTerms => 'Tôi đồng ý với';

  @override
  String get termsAndConditions => 'Điều khoản và Điều kiện';

  @override
  String get zeroToleranceStatement =>
      'và hiểu rằng không có sự khoan dung nào đối với nội dung phản cảm hoặc người dùng lạm dụng.';

  @override
  String get viewTerms => 'Xem Điều khoản và Điều kiện';

  @override
  String get reportContent => 'Nội dung báo cáo';

  @override
  String get selectReportReason => 'Vui lòng chọn lý do báo cáo:';

  @override
  String get additionalDetails => 'Chi tiết bổ sung (tùy chọn)';

  @override
  String get reportDetailsHint => 'Cung cấp thêm thông tin gì...';

  @override
  String get reportSubmitted =>
      'Cảm ơn bạn đã báo cáo của bạn. Chúng tôi sẽ xem xét nó trong vòng 24 giờ.';

  @override
  String get reportProduct => 'Báo cáo sản phẩm';

  @override
  String get reportService => 'Dịch vụ báo cáo';

  @override
  String get reportMessage => 'Tin nhắn báo cáo';

  @override
  String get reportUser => 'Báo cáo người dùng';

  @override
  String get reportErrorNotImplemented =>
      'Tính năng báo cáo vẫn chưa khả dụng. Vui lòng liên hệ với bộ phận hỗ trợ hoặc thử lại sau.';

  @override
  String get reportAlreadySubmitted =>
      'Bạn đã báo cáo nội dung này. Chúng tôi đang xem xét báo cáo trước đó của bạn.';

  @override
  String get reportFailedGeneric => 'Không thể gửi báo cáo. Vui lòng thử lại.';

  @override
  String get reportFailedNetwork =>
      'Đã xảy ra lỗi mạng. Vui lòng kiểm tra kết nối của bạn và thử lại.';

  @override
  String get becomeAgentTitle => 'Tham gia với tư cách là đại lý bất động sản';

  @override
  String get becomeAgentSubtitle =>
      'Liệt kê các tài sản và giúp khách hàng tìm thấy ngôi nhà mơ ước của họ';

  @override
  String get agentBenefits => 'Những lợi ích:';

  @override
  String get agentBenefitVerified => 'Huy hiệu đại lý đã được xác minh';

  @override
  String get agentBenefitAnalytics =>
      'Truy cập vào phân tích và hiểu biết sâu sắc';

  @override
  String get agentBenefitClients =>
      'Tiếp xúc trực tiếp với khách hàng tiềm năng';

  @override
  String get agentBenefitReputation =>
      'Xây dựng danh tiếng chuyên nghiệp của bạn';

  @override
  String get agentApplicationForm => 'Đơn đăng ký';

  @override
  String get agentAgencyName => 'Tên đại lý';

  @override
  String get agentAgencyNameHint => 'Nhập tên đại lý bất động sản của bạn';

  @override
  String get agentAgencyNameRequired => 'Tên đại lý là bắt buộc';

  @override
  String get agentLicenceNumber => 'Số giấy phép';

  @override
  String get agentLicenceNumberHint => 'Nhập số giấy phép bất động sản của bạn';

  @override
  String get agentLicenceNumberRequired => 'Số giấy phép là bắt buộc';

  @override
  String get agentYearsExperience => 'Số năm kinh nghiệm';

  @override
  String get agentYearsExperienceHint => 'Nhập số năm';

  @override
  String get agentYearsExperienceRequired => 'Cần có số năm kinh nghiệm';

  @override
  String get agentYearsExperienceInvalid => 'Vui lòng nhập một số hợp lệ';

  @override
  String get agentSpecialization => 'Chuyên môn';

  @override
  String get agentApplicationNote =>
      'Đơn đăng ký của bạn sẽ được nhóm của chúng tôi xem xét. Bạn sẽ được thông báo khi đơn đăng ký của bạn được chấp thuận.';

  @override
  String get agentSubmitApplication => 'Gửi đơn đăng ký';

  @override
  String get agentApplicationSubmitted =>
      'Đơn đăng ký đã được gửi thành công! Chúng tôi sẽ xem xét nó sớm.';

  @override
  String get agentApplicationStatus => 'Trạng thái đơn đăng ký';

  @override
  String get agentViewProfile => 'Xem hồ sơ đại lý của bạn';

  @override
  String get agentDashboardComingSoon => 'Bảng điều khiển đại lý sắp ra mắt!';

  @override
  String get property_create_basic_information => 'Thông tin cơ bản';

  @override
  String get property_create_property_title => 'Tiêu đề tài sản *';

  @override
  String get property_create_property_title_hint =>
      'ví dụ: Căn hộ 3BR hiện đại ở trung tâm thành phố';

  @override
  String get property_create_property_title_required =>
      'Vui lòng nhập tên tài sản';

  @override
  String get property_create_description => 'Sự miêu tả *';

  @override
  String get property_create_description_hint =>
      'Mô tả chi tiết tài sản của bạn...';

  @override
  String get property_create_description_required => 'Vui lòng nhập mô tả';

  @override
  String get property_create_property_type => 'Loại tài sản';

  @override
  String get property_create_property_type_required => 'Loại tài sản *';

  @override
  String get property_create_listing_type_required => 'Loại danh sách *';

  @override
  String get property_create_pricing => 'Định giá';

  @override
  String get property_create_price => 'Giá *';

  @override
  String get property_create_price_hint => 'Nhập giá';

  @override
  String get property_create_price_required => 'Vui lòng nhập giá';

  @override
  String get property_create_currency => 'Tiền tệ';

  @override
  String get property_create_property_details => 'Chi tiết tài sản';

  @override
  String get property_create_square_meters => 'Sq. Mét *';

  @override
  String get property_create_bedrooms => 'Phòng ngủ *';

  @override
  String get property_create_bathrooms => 'Phòng tắm *';

  @override
  String get property_create_floor => 'Sàn nhà';

  @override
  String get property_create_total_floors => 'Tổng số tầng';

  @override
  String get property_create_parking => 'bãi đậu xe';

  @override
  String get property_create_year_built => 'Năm xây dựng';

  @override
  String get property_create_location => 'Vị trí';

  @override
  String get property_create_address => 'Địa chỉ *';

  @override
  String get property_create_address_hint => 'Nhập địa chỉ tài sản';

  @override
  String get property_create_address_required => 'Vui lòng nhập địa chỉ';

  @override
  String get property_create_location_detected => 'Đã phát hiện vị trí';

  @override
  String get property_create_get_location => 'Nhận vị trí hiện tại';

  @override
  String get property_create_features => 'Đặc trưng';

  @override
  String get property_create_feature_balcony => 'Ban công';

  @override
  String get property_create_feature_garage => 'Ga-ra';

  @override
  String get property_create_feature_garden => 'Vườn';

  @override
  String get property_create_feature_pool => 'Hồ bơi';

  @override
  String get property_create_feature_elevator => 'Thang máy';

  @override
  String get property_create_feature_furnished => 'Có nội thất';

  @override
  String get property_create_images => 'Hình ảnh tài sản';

  @override
  String get property_create_tap_to_add_images => 'Nhấn để thêm hình ảnh';

  @override
  String get property_create_at_least_one_image => 'Cần ít nhất 1 hình ảnh';

  @override
  String get property_create_add_more => 'Thêm nhiều hơn nữa';

  @override
  String get property_create_required => 'Yêu cầu';

  @override
  String get property_create_location_required =>
      'Vui lòng kích hoạt dịch vụ định vị để tạo thuộc tính';

  @override
  String get property_create_image_required =>
      'Cần có ít nhất một hình ảnh thuộc tính';

  @override
  String get emailVerification => 'Xác minh email';

  @override
  String get pleaseEnterYourEmailAddress =>
      'Vui lòng nhập địa chỉ email của bạn';

  @override
  String get enterEmailAddress => 'Nhập địa chỉ email';

  @override
  String get resetYourPassword => 'Đặt lại mật khẩu của bạn';

  @override
  String get resetPasswordDescription =>
      'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi cho bạn mã xác minh để đặt lại mật khẩu của bạn.';

  @override
  String get sendVerificationCode => 'Gửi mã xác minh';

  @override
  String get backToLogin => 'Quay lại đăng nhập';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String enterVerificationCodeSentTo(String email) {
    return 'Nhập mã xác minh được gửi tới $email';
  }

  @override
  String get codeMustBe6Digits => 'Mã phải có 6 chữ số';

  @override
  String get enterNewPassword => 'Nhập mật khẩu mới';

  @override
  String get minimum8Characters => 'Tối thiểu 8 ký tự';

  @override
  String get sending => 'Đang gửi...';

  @override
  String get verifying => 'Đang xác minh...';

  @override
  String get new_message => 'Tin nhắn mới';

  @override
  String get messages => 'Tin nhắn';

  @override
  String get please_log_in => 'Vui lòng đăng nhập để xem tin nhắn';

  @override
  String get pin => 'Ghim';

  @override
  String get unpin => 'Bỏ ghim';

  @override
  String get delete_chat => 'Xóa cuộc trò chuyện';

  @override
  String delete_chat_confirm(String name) {
    return 'Bạn có chắc chắn muốn xóa cuộc trò chuyện với $name không? Không thể hoàn tác hành động này.';
  }

  @override
  String chat_deleted(String name) {
    return 'Trò chuyện với $name đã bị xóa';
  }

  @override
  String get delete_failed => 'Không xóa được cuộc trò chuyện';

  @override
  String get no_conversations => 'Chưa có cuộc trò chuyện nào';

  @override
  String get start_conversation_hint =>
      'Bắt đầu cuộc trò chuyện bằng cách nhấn vào nút +';

  @override
  String get start_conversation => 'Bắt đầu cuộc trò chuyện';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get unknown => 'Không xác định';

  @override
  String get no_messages_yet => 'Chưa có tin nhắn nào';

  @override
  String get unblock_user => 'Bỏ chặn người dùng';

  @override
  String get block_user => 'Chặn người dùng';

  @override
  String get no_blocked_users => 'Không có người dùng bị chặn';

  @override
  String get blocked_users_hint => 'Người dùng bạn chặn sẽ xuất hiện ở đây';

  @override
  String unblock_user_confirm(String username) {
    return 'Bạn có chắc chắn muốn bỏ chặn $username không? Bạn sẽ có thể nhận lại tin nhắn từ họ.';
  }

  @override
  String user_unblocked(String username) {
    return '$username đã được bỏ chặn';
  }

  @override
  String user_blocked(String username) {
    return '$username đã bị chặn';
  }

  @override
  String get failed_to_unblock => 'Không thể bỏ chặn người dùng';

  @override
  String get failed_to_block => 'Không chặn được người dùng';

  @override
  String get chat_info => 'Thông tin trò chuyện';

  @override
  String get delete_message => 'Xóa tin nhắn';

  @override
  String get delete_message_confirm =>
      'Bạn có chắc chắn muốn xóa tin nhắn này?';

  @override
  String get typing => 'đang gõ...';

  @override
  String get online => 'trực tuyến';

  @override
  String get offline => 'ngoại tuyến';

  @override
  String last_seen_at(String time) {
    return 'nhìn thấy lần cuối $time';
  }

  @override
  String participants(int count) {
    return '$count người tham gia';
  }

  @override
  String get you_are_blocked => 'Bạn bị chặn';

  @override
  String user_blocked_you(String username) {
    return '$username đã chặn bạn. Bạn không thể gửi tin nhắn.';
  }

  @override
  String you_blocked_user(String username) {
    return 'Bạn đã chặn $username';
  }

  @override
  String get cannot_send_messages_blocked =>
      'Bạn không thể gửi tin nhắn. Bạn đã bị chặn.';

  @override
  String get this_message_was_deleted => 'Tin nhắn này đã bị xóa';

  @override
  String get edit => 'Biên tập';

  @override
  String get reply => 'Hồi đáp';

  @override
  String get editing_message => 'Chỉnh sửa tin nhắn';

  @override
  String replying_to(String username) {
    return 'Đang trả lời $username';
  }

  @override
  String get voice => 'Tiếng nói';

  @override
  String get emoji => 'Biểu tượng cảm xúc';

  @override
  String get photo => '📷 Ảnh';

  @override
  String get voice_message => '🎤 Tin nhắn thoại';

  @override
  String get searching => 'Đang tìm kiếm...';

  @override
  String get loading_users => 'Đang tải người dùng...';

  @override
  String search_failed(String error) {
    return 'Tìm kiếm không thành công: $error';
  }

  @override
  String get invalid_user_data => 'Dữ liệu người dùng không hợp lệ';

  @override
  String failed_to_start_chat(String error) {
    return 'Không bắt đầu trò chuyện được: $error';
  }

  @override
  String get audio_file_not_available => 'Tập tin âm thanh không có sẵn';

  @override
  String failed_to_play_audio(String error) {
    return 'Không phát được âm thanh: $error';
  }

  @override
  String get image_unavailable => 'Không có hình ảnh';

  @override
  String get image_too_large => '❌ Hình ảnh quá lớn. Kích thước tối đa là 10MB';

  @override
  String get image_file_not_found => '❌ Không tìm thấy file ảnh';

  @override
  String get uploading_image => 'Đang tải hình ảnh lên...';

  @override
  String get image_sent => '✅ Đã gửi hình ảnh!';

  @override
  String get failed_to_send_image => '❌ Không gửi được ảnh';

  @override
  String get uploading_voice_message => 'Đang tải lên tin nhắn thoại...';

  @override
  String get voice_message_sent => '✅ Đã gửi tin nhắn thoại!';

  @override
  String get failed_to_send_voice_message => '❌ Không gửi được tin nhắn thoại';

  @override
  String get recording => '🎙️ Đang ghi âm...';

  @override
  String get microphone_permission_denied => 'Quyền sử dụng micrô bị từ chối';

  @override
  String get starting_chat => 'Đang bắt đầu trò chuyện...';

  @override
  String get refresh_users => 'Làm mới người dùng';

  @override
  String get search_by_username_or_phone =>
      'Tìm kiếm theo tên người dùng hoặc số điện thoại';

  @override
  String get no_users_found => 'Không tìm thấy người dùng nào';

  @override
  String get try_different_search_term => 'Hãy thử một cụm từ tìm kiếm khác';

  @override
  String get no_users_available => 'Không có người dùng nào';

  @override
  String get chat_exists => 'Trò chuyện tồn tại';

  @override
  String block_user_confirm(String username) {
    return 'Bạn có chắc chắn muốn chặn $username không? Bạn sẽ không nhận được tin nhắn từ họ và họ sẽ bị xóa khỏi danh sách trò chuyện của bạn.';
  }

  @override
  String chat_room_label(String name) {
    return 'Phòng trò chuyện: $name';
  }

  @override
  String id_label(int id) {
    return 'Mã số: $id';
  }

  @override
  String get participants_label => 'Người tham gia:';

  @override
  String get type_a_message => 'Nhập tin nhắn...';

  @override
  String get edit_message_hint => 'Chỉnh sửa tin nhắn...';

  @override
  String error_label(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get copy => 'Sao chép';

  @override
  String comments_title(int count) {
    return 'Bình luận ($count)';
  }

  @override
  String get reply_button => 'Hồi đáp';

  @override
  String replies_count(int count) {
    return '$count trả lời';
  }

  @override
  String get you_label => 'Bạn';

  @override
  String get delete_reply_title => 'Xóa câu trả lời';

  @override
  String get delete_comment_title => 'Xóa bình luận';

  @override
  String get unknown_date => 'Ngày không xác định';

  @override
  String get press_enter_to_send => 'Nhấn Enter để gửi';

  @override
  String get comment_add_error => 'Không thể thêm nhận xét';

  @override
  String get service_provider => 'Nhà cung cấp dịch vụ';

  @override
  String get opening_chat => 'Đang mở cuộc trò chuyện...';

  @override
  String get failed_to_refresh => 'Không thể làm mới';

  @override
  String get cannot_chat_with_yourself =>
      'Bạn không thể trò chuyện với chính mình';

  @override
  String opening_chat_with(String username) {
    return 'Đang mở cuộc trò chuyện với $username...';
  }

  @override
  String get this_will_only_take_a_moment =>
      'Việc này sẽ chỉ mất một chút thời gian';

  @override
  String get unable_to_start_chat =>
      'Không thể bắt đầu trò chuyện. Vui lòng thử lại.';

  @override
  String get profile_listings => 'Danh sách';

  @override
  String get profile_followers => 'Người theo dõi';

  @override
  String get profile_following => 'Tiếp theo';

  @override
  String get profile_no_products => 'Không có sản phẩm';

  @override
  String get profile_no_services => 'Không có dịch vụ';

  @override
  String get profile_no_properties => 'Không có thuộc tính';

  @override
  String get profile_user_no_products =>
      'Người dùng này chưa đăng bất kỳ sản phẩm nào';

  @override
  String get profile_user_no_services =>
      'Người dùng này chưa đăng bất kỳ dịch vụ nào';

  @override
  String get profile_user_no_properties =>
      'Người dùng này chưa đăng bất kỳ tài sản nào';

  @override
  String get profile_error_occurred => 'Đã xảy ra lỗi';

  @override
  String get profile_error_loading_products => 'Lỗi tải sản phẩm';

  @override
  String get profile_error_loading_services => 'Lỗi tải dịch vụ';

  @override
  String get profile_no_followers_yet => 'Chưa có người theo dõi';

  @override
  String get profile_no_following_yet => 'Chưa theo dõi ai';

  @override
  String get profile_follow => 'Theo';

  @override
  String get profile_following_btn => 'Tiếp theo';

  @override
  String get profile_message => 'Tin nhắn';

  @override
  String get profile_member_since => 'Thành viên kể từ';

  @override
  String get profile_loading_error => 'Lỗi tải hồ sơ';

  @override
  String get profile_retry => 'Thử lại';

  @override
  String get profile_share => 'Chia sẻ';

  @override
  String get profile_copy_link => 'Sao chép liên kết';

  @override
  String get profile_report => 'Báo cáo';

  @override
  String get linkCopied => 'Đã sao chép liên kết vào bảng nhớ tạm';

  @override
  String get checkOutProfile => 'Kiểm tra';

  @override
  String get onTezsell => 'trên TezSell';

  @override
  String get selectCountryFirst => 'Chọn quốc gia trước';

  @override
  String get countrySelectionHint => 'Sau đó, bạn có thể chọn khu vực của mình';

  @override
  String get something_went_wrong => 'Đã xảy ra lỗi';

  @override
  String get check_connection_and_retry =>
      'Vui lòng kiểm tra kết nối Internet của bạn và thử lại';

  @override
  String get sold_badge => 'ĐÃ BÁN';

  @override
  String get more_categories => 'Hơn';

  @override
  String no_products_in_location(String location) {
    return 'Không tìm thấy sản phẩm nào trong $location';
  }

  @override
  String get no_more_products => 'Không còn sản phẩm nào để tải';

  @override
  String time_days_ago(int count) {
    return '${count}ngày trước';
  }

  @override
  String time_hours_ago(int count) {
    return '${count}giờ trước';
  }

  @override
  String time_minutes_ago(int count) {
    return '${count}phút trước';
  }

  @override
  String get time_just_now => 'Vừa rồi';

  @override
  String no_services_in_location(String location) {
    return 'Không tìm thấy dịch vụ nào trong $location';
  }

  @override
  String get no_more_services => 'Không còn dịch vụ nào để tải';

  @override
  String get error_loading_more_services => 'Lỗi tải thêm dịch vụ';

  @override
  String get verification_code_length => 'Mã xác minh phải có 6 chữ số';

  @override
  String get map_register_title => 'Bạn sống ở đâu?';

  @override
  String get map_register_headline => 'Chọn vùng lân cận của bạn trên bản đồ';

  @override
  String get map_register_subtitle =>
      'Chúng tôi sử dụng nó để hiển thị cho bạn người mua và người bán gần đó. Bạn có thể điều chỉnh bán kính của mình sau.';

  @override
  String get pick_on_map => 'Chọn trên bản đồ';

  @override
  String get pick_again => 'Chọn lại';

  @override
  String get resolving_location => 'Đang giải quyết vị trí…';

  @override
  String get use_dropdown_instead => 'Thay vào đó hãy sử dụng menu thả xuống';

  @override
  String country_not_supported(String country) {
    return 'Chúng tôi chưa hỗ trợ $country.';
  }

  @override
  String get region_not_auto_detected =>
      'Không thể tự động phát hiện khu vực của bạn - hãy chọn khu vực đó theo cách thủ công.';

  @override
  String get district_not_auto_detected =>
      'Không thể tự động phát hiện quận của bạn — hãy chọn quận theo cách thủ công.';

  @override
  String get browse_no_items_with_location =>
      'Chưa có mục nào có dữ liệu vị trí trong khu vực này.';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => 'Đặt vị trí';

  @override
  String get location_picker_confirm => 'Xác nhận vị trí';

  @override
  String get location_picker_resolve_failed =>
      'Không thể giải quyết địa chỉ — chỉ chọn lại hoặc xác nhận bằng tọa độ';

  @override
  String get location_picker_selected_fallback => 'Vị trí đã chọn';

  @override
  String get location_permission_denied => 'Quyền vị trí bị từ chối';

  @override
  String get location_permission_denied_settings =>
      'Quyền vị trí bị từ chối - vui lòng bật trong Cài đặt';

  @override
  String get location_permission_permanent =>
      'Vị trí bị từ chối vĩnh viễn — mở Cài đặt để bật';

  @override
  String gps_error(String error) {
    return 'Lỗi GPS: $error';
  }

  @override
  String get verify_neighborhood_title => 'Xác minh vùng lân cận của bạn';

  @override
  String get verify_neighborhood_subtitle =>
      'Đứng trong khu phố của bạn. Chúng tôi sẽ kiểm tra GPS của bạn và yêu cầu bạn xác nhận.';

  @override
  String get verify_neighborhood_button => 'Xác minh vùng lân cận';

  @override
  String get verify_neighborhood_low_confidence =>
      'Tiếp tục với độ tin cậy thấp';

  @override
  String get verify_neighborhood_retry => 'Thử lại';

  @override
  String get verify_neighborhood_youre_in => 'Bạn đang ở:';

  @override
  String verify_neighborhood_done(String name) {
    return 'Đã xác minh! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'Độ chính xác của GPS là ${meters}m (cần 100m). Di chuyển đến một khu vực mở và thử lại.';
  }

  @override
  String get neighborhood_not_identified =>
      'Không thể xác định vùng lân cận cho vị trí của bạn.';

  @override
  String get unknown_error => 'Lỗi không xác định';

  @override
  String get place_search_hint => 'Tìm kiếm địa chỉ hoặc địa điểm';

  @override
  String get place_search_unavailable =>
      'Tìm kiếm không có sẵn — thay vào đó hãy ghim';

  @override
  String get radius_slider_city => 'Thành phố';

  @override
  String radius_slider_km(String value) {
    return '$value km';
  }

  @override
  String get my_neighborhoods => 'Khu phố của tôi';

  @override
  String get manage_on_map => 'Quản lý trên bản đồ';

  @override
  String get no_neighborhoods_yet =>
      'Chưa có khu phố nào được xác minh. Mở bản đồ để xác minh vị trí của bạn.';

  @override
  String get open_map_to_verify => 'Mở bản đồ để xác minh vị trí mới';

  @override
  String get verify_here => 'Xác minh tại đây';

  @override
  String get verify_new_location => 'Xác minh vị trí mới';

  @override
  String eviction_warning(String name) {
    return 'Thêm vị trí này sẽ xóa $name (cũ nhất của bạn). Không thể hoàn tác.';
  }

  @override
  String get verified_today => 'Đã xác minh hôm nay';

  @override
  String get verified_yesterday => 'Đã xác minh hôm qua';

  @override
  String verified_n_days_ago(int days) {
    return 'Đã xác minh $days ngày trước';
  }

  @override
  String get active_neighborhood => 'Đang hoạt động';

  @override
  String switch_neighborhood_success(String name) {
    return 'Đã chuyển sang $name';
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
}
