// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get sessionExpired => '세션이 만료되었습니다. 다시 로그인해 주세요.';

  @override
  String get welcome => '환영';

  @override
  String get welcomeBack => '돌아온 것을 환영합니다!';

  @override
  String get loginToYourAccount => '계속하려면 로그인하세요';

  @override
  String get or => '또는';

  @override
  String get dontHaveAccount => '계정이 없나요?';

  @override
  String get chooseLanguage => '언어를 선택하세요';

  @override
  String get selectPreferredLanguage => '앱에서 선호하는 언어를 선택하세요.';

  @override
  String get continueButton => '계속하다';

  @override
  String get continueWithGoogle => 'Google로 계속하기';

  @override
  String get continueWithApple => 'Apple과 함께 계속하세요';

  @override
  String get continueWithEmail => '이메일로 계속';

  @override
  String get sellAndBuyProducts => '귀하의 모든 제품을 당사에서만 판매하고 구매하세요';

  @override
  String get usedProductsMarket => '중고품이나 중고시장';

  @override
  String get home_welcome_title => '당신의 동네 시장';

  @override
  String get home_welcome_subtitle => '근처 사람들과 사고 팔아보세요.\n안전하고 간단하며 지역적입니다.';

  @override
  String get home_get_started => '시작하기';

  @override
  String get home_sign_in => '이미 계정이 있습니다';

  @override
  String get home_terms_notice => '계속하면 서비스 약관 및 개인정보 보호정책에 동의하게 됩니다.';

  @override
  String get register => '등록하다';

  @override
  String get alreadyHaveAccount => '이미 계정이 있습니다';

  @override
  String get login => '로그인';

  @override
  String get loginToAccount => '계정에 로그인';

  @override
  String get enterPhoneNumber => '전화번호를 입력하세요';

  @override
  String get password => '비밀번호';

  @override
  String get enterPassword => '비밀번호를 입력하세요';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get registerNow => '지금 등록하세요';

  @override
  String get loading => '로드 중...';

  @override
  String get pleaseEnterPhoneNumber => '전화번호를 입력해주세요';

  @override
  String get pleaseEnterPassword => '비밀번호를 입력해주세요';

  @override
  String get unexpectedError => '예상치 못한 오류가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get forgotPasswordComingSoon => '비밀번호를 잊어버린 기능이 곧 제공될 예정입니다.';

  @override
  String get selectedCountryLabel => '선택된:';

  @override
  String get fullPhoneLabel => '가득한:';

  @override
  String get home => '집';

  @override
  String get settings => '설정';

  @override
  String get profile => '윤곽';

  @override
  String get search => '찾다';

  @override
  String get notifications => '알림';

  @override
  String get error => '오류';

  @override
  String get retry => '다시 해 보다';

  @override
  String get cancel => '취소';

  @override
  String get save => '구하다';

  @override
  String get appTitle => '테젤';

  @override
  String get selectRegion => '지역을 선택하세요.';

  @override
  String get searchHint => '지역 또는 도시 검색';

  @override
  String get apiError => 'API를 호출하는 중에 문제가 발생했습니다.';

  @override
  String get ok => '좋아요';

  @override
  String get emptyList => '빈 목록';

  @override
  String get dataLoadingError => '데이터를 로드하는 중 오류가 발생했습니다.';

  @override
  String get confirm => '확인하다';

  @override
  String get yes => '예';

  @override
  String get no => '아니요';

  @override
  String confirmRegionSelection(Object regionName) {
    return '$regionName 지역을 선택하시겠습니까?';
  }

  @override
  String get selectDistrictOrCity => '지역이나 도시를 선택해주세요.';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return '$regionName 지역 - $districtName을 선택하시겠습니까?';
  }

  @override
  String get noResultsFound => '검색된 결과가 없습니다.';

  @override
  String errorWithCode(String errorCode) {
    return '오류: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return '데이터를 로드하지 못했습니다. 오류: $error';
  }

  @override
  String get phoneVerification => '전화번호 확인';

  @override
  String get enterPhonePrompt => '전화번호를 입력해주세요';

  @override
  String get enterPhoneNumberHint => '전화번호를 입력하세요';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return '선택됨: $countryName($countryCode)';
  }

  @override
  String get selectCountry => '국가를 선택하세요';

  @override
  String get changeCountry => '국가 변경';

  @override
  String get country => '국가';

  @override
  String get allCountries => '제국';

  @override
  String get currencyRUB => '러시아 루블';

  @override
  String get currencyUAH => '우크라이나 흐리브냐';

  @override
  String get currencyBYN => '벨로루시 루블';

  @override
  String get currencyMDL => '몰도바 레우';

  @override
  String get currencyGEL => '조지아 라리';

  @override
  String get currencyAMD => '아르메니아 드라마';

  @override
  String get currencyAZN => '아제르바이잔 마나트';

  @override
  String get currencyKZT => '카자흐스탄 텡게';

  @override
  String get currencyTMT => '투르크멘 마나트';

  @override
  String get currencyKGS => '키르기스스탄 솜';

  @override
  String get currencyTJS => '타지키스탄 소모니어';

  @override
  String get currencyUZS => '우즈벡 솜';

  @override
  String get currencyUSD => '미국 달러';

  @override
  String get currencyEUR => '유로';

  @override
  String fullNumber(String phoneNumber) {
    return '전체 번호: $phoneNumber';
  }

  @override
  String get sendCode => '코드 보내기';

  @override
  String get enterVerificationCode => '인증코드를 입력하세요';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => '코드 재전송';

  @override
  String expires(String time) {
    return '만료: $time';
  }

  @override
  String get verifyAndContinue => '확인하고 계속하세요';

  @override
  String get invalidVerificationCode => '잘못된 인증 코드';

  @override
  String get verificationCodeSent => '인증코드가 성공적으로 전송되었습니다';

  @override
  String get failedToSendCode => '인증코드 전송 실패';

  @override
  String get verificationCodeResent => '인증코드가 성공적으로 재전송되었습니다';

  @override
  String get failedToResendCode => '인증코드 재전송 실패';

  @override
  String get passwordVerification => '비밀번호 확인';

  @override
  String get completeRegistrationPrompt => '사용자 이름과 비밀번호를 입력하여 등록을 완료하세요';

  @override
  String get username => '사용자 이름';

  @override
  String get username_required => '사용자 이름이 필요합니다';

  @override
  String get username_min_length => '사용자 이름은 2자 이상이어야 합니다.';

  @override
  String get usernameHint => '사용자 이름123';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get profileImage => '프로필 이미지';

  @override
  String get imageInstructions => '여기에 이미지가 표시됩니다. 프로필 이미지를 누르세요.';

  @override
  String get finish => '마치다';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get registrationError => '등록 오류';

  @override
  String get about => '회사 소개';

  @override
  String get chat => '채팅';

  @override
  String get realEstate => '부동산';

  @override
  String get language => '영어';

  @override
  String get languageEn => '영어';

  @override
  String get languageRu => '러시아인';

  @override
  String get languageUz => '우즈벡어';

  @override
  String get serviceLiked => '서비스가 마음에 들었습니다';

  @override
  String get support => '지원하다';

  @override
  String get service => '비즈니스 서비스';

  @override
  String get aboutContent =>
      'TezSell은 새 제품과 중고 제품을 사고 파는 빠르고 쉬운 마켓플레이스입니다. 우리의 임무는 모든 사용자에게 가장 편리하고 효율적인 플랫폼을 만들어 원활한 거래와 사용자 친화적인 경험을 보장하는 것입니다. 판매 또는 구매하려는 경우 TezSell을 사용하면 단 몇 단계만으로 쉽게 연결하고 거래를 완료할 수 있습니다. 우리는 사용자의 보안과 개인정보 보호를 최우선으로 생각합니다. 모든 거래는 안전과 규정 준수를 보장하기 위해 주의 깊게 모니터링되어 구매자와 판매자 모두에게 마음의 평화를 제공합니다. 우리의 간단하고 직관적인 인터페이스를 통해 사용자는 제품을 빠르게 나열하고 필요한 것을 찾을 수 있습니다. 또한 텔레그램을 통해 실시간 커뮤니케이션을 촉진하여 구매 및 판매 프로세스를 더욱 원활하게 만듭니다.';

  @override
  String get errorMessage => '오류가 발생했습니다. 서버를 확인하세요.';

  @override
  String get searchLocation => '위치';

  @override
  String get searchCategory => '카테고리';

  @override
  String get searchProductPlaceholder => '제품 검색';

  @override
  String get searchServicePlaceholder => '서비스 검색';

  @override
  String get search_products_subtitle => '당신의 동네에서 좋은 상품을 찾아보세요';

  @override
  String get search_services_subtitle => '우리 동네 전문가를 찾아보세요';

  @override
  String get search_products_error => '제품 검색 오류';

  @override
  String get search_services_error => '서비스 검색 중 오류 발생';

  @override
  String get load_more_products_error => '추가 제품을 로드하는 중에 오류가 발생했습니다.';

  @override
  String get load_more_services_error => '추가 서비스를 로드하는 중에 오류가 발생했습니다.';

  @override
  String get try_different_keywords => '다른 키워드를 사용해 보세요';

  @override
  String get searchText => '찾다';

  @override
  String get selectedCategory => '선택한 카테고리:';

  @override
  String get selectedLocation => '선택한 위치:';

  @override
  String get productError => '사용 가능한 제품이 없습니다.';

  @override
  String get serviceError => '이용 가능한 서비스가 없습니다.';

  @override
  String get locationHeader => '위치를 선택하세요';

  @override
  String get locationPlaceholder => '여기서 지역 검색';

  @override
  String get categoryHeader => '카테고리를 선택하세요';

  @override
  String get categoryPlaceholder => '카테고리 검색';

  @override
  String get categoryError => '사용 가능한 카테고리가 없습니다.';

  @override
  String get paginationFirst => '첫 번째';

  @override
  String get paginationPrevious => '이전의';

  @override
  String get pageInfo => '페이지';

  @override
  String get pageNext => '다음';

  @override
  String get pageLast => '마지막';

  @override
  String get loadingMessageProduct => '제품 로드 중...';

  @override
  String get loadingMessageError => '로드하는 중 오류가 발생했습니다.';

  @override
  String get likeProductError => '제품에 \'좋아요\' 표시를 하는 중 오류가 발생했습니다.';

  @override
  String get dislikeProductError => '제품을 싫어하는 중에 오류가 발생했습니다.';

  @override
  String get loadingMessageLocation => '위치 로드 중...';

  @override
  String get loadingLocationError => '위치를 로드하는 중 오류가 발생했습니다.';

  @override
  String get loadingMessageCategory => '카테고리 로드 중...';

  @override
  String get loadingCategoryError => '카테고리 로드 중 오류 발생:';

  @override
  String get profileUpdateSuccessMessage => '프로필이 업데이트되었습니다.';

  @override
  String get profileUpdateFailMessage => '프로필을 업데이트하지 못했습니다.';

  @override
  String get seeMoreBtn => '자세히 보기';

  @override
  String get profilePageTitle => '프로필 페이지';

  @override
  String get editProfileModalTitle => '프로필 편집';

  @override
  String get usernameLabel => '사용자 이름';

  @override
  String get locationLabel => '현재 위치';

  @override
  String get profileImageLabel => '프로필 이미지';

  @override
  String get chooseFileLabel => '파일을 선택하세요';

  @override
  String get uploadBtnLabel => '업데이트';

  @override
  String get uploadingBtnLabel => '업데이트 중...';

  @override
  String get cancelBtnLabel => '취소';

  @override
  String get productsTitle => '제품';

  @override
  String get servicesTitle => '서비스';

  @override
  String get myProductsTitle => '내 제품';

  @override
  String get myServicesTitle => '내 서비스';

  @override
  String get favoriteProductsTitle => '좋아하는 제품';

  @override
  String get favoriteServicesTitle => '즐겨찾는 서비스';

  @override
  String get noFavorites => '즐겨찾기 없음';

  @override
  String get addNewProductBtn => '새 제품 추가';

  @override
  String get addNew => '새로운';

  @override
  String get addNewServiceBtn => '새로운 서비스 추가';

  @override
  String get downloadMobileApp => '모바일 앱 다운로드';

  @override
  String get registerPhoneNumberSuccess => '전화번호가 확인되었습니다! 다음 단계로 진행할 수 있습니다.';

  @override
  String get regionSelectedMessage => '선택한 지역:';

  @override
  String get districtSelectMessage => '선택한 지구:';

  @override
  String get phoneNumberEmptyMessage => '계속하기 전에 전화번호를 확인하세요.';

  @override
  String get regionEmptyMessage => '지역을 먼저 선택해주세요';

  @override
  String get districtEmptyMessage => '지역을 선택해 주세요';

  @override
  String get usernamePasswordEmptyMessage => '사용자 이름과 비밀번호를 입력해주세요';

  @override
  String get registerTitle => '등록하다';

  @override
  String get previousButton => '이전의';

  @override
  String get nextButton => '다음';

  @override
  String get completeButton => '완벽한';

  @override
  String stepIndicator(int currentStep) {
    return '4단계 중 $currentStep 단계';
  }

  @override
  String get districtSelectTitle => '지구 목록';

  @override
  String get districtSelectParagraph => '지구를 선택하세요:';

  @override
  String get phoneNumber => '전화 번호';

  @override
  String get sendOtp => 'OTP 보내기';

  @override
  String get sendAgain => '다시 보내기';

  @override
  String get verify => '확인하다';

  @override
  String get failedToSendOtp => 'OTP 전송에 실패했습니다. 서버가 false를 반환했습니다.';

  @override
  String get errorSendingOtp => 'OTP 전송 중 오류가 발생했습니다.';

  @override
  String get invalidPhoneNumber => '유효한 전화번호를 입력하세요.';

  @override
  String get verificationSuccess => '성공적으로 확인되었습니다';

  @override
  String get verificationError => '오류가 발생했습니다. 나중에 다시 시도해 주세요.';

  @override
  String get regionsList => '지역 목록';

  @override
  String get enterUsername => '사용자 이름을 입력하세요';

  @override
  String get welcomeMessage => 'Tezsell에 오신 것을 환영합니다. 전화번호로 로그인하세요.';

  @override
  String get noAccount => '아직 계정이 없나요? 여기에서 등록하세요';

  @override
  String get successLogin => '성공적으로 기록되었습니다';

  @override
  String get myProfile => '내 프로필';

  @override
  String get logout => '로그아웃';

  @override
  String get newProductTitle => '제목';

  @override
  String get newProductDescription => '설명';

  @override
  String get newProductPrice => '가격';

  @override
  String get newProductCondition => '상태';

  @override
  String get newProductCategory => '범주';

  @override
  String get newProductImages => '이미지';

  @override
  String get addNewService => '새로운 서비스 추가';

  @override
  String get creating => '만드는 중...';

  @override
  String get serviceName => '서비스 이름';

  @override
  String get serviceNamePlaceholder => '서비스 제목을 입력하세요';

  @override
  String get serviceDescription => '서비스 설명';

  @override
  String get serviceDescriptionPlaceholder => '서비스 설명을 입력하세요';

  @override
  String get serviceCategory => '서비스 카테고리';

  @override
  String get selectCategory => '카테고리 선택';

  @override
  String get loadingCategories => '로드 중...';

  @override
  String get errorLoadingCategories => '카테고리를 로드하는 중에 오류가 발생했습니다.';

  @override
  String get serviceImages => '서비스 이미지';

  @override
  String get imageUploadHelper => '이미지를 추가하려면 + 아이콘을 클릭하세요(최대 10개).';

  @override
  String get maxImagesError => '최대 10개의 이미지를 업로드할 수 있습니다.';

  @override
  String get categoryNotFound => '카테고리를 찾을 수 없습니다';

  @override
  String get productCreatedSuccess => '제품이 성공적으로 생성되었습니다.';

  @override
  String get productLikeSuccess => '제품이 성공적으로 좋아요를 받았습니다.';

  @override
  String get productDislikeSuccess => '제품이 좋아요를 받지 못했습니다.';

  @override
  String get errorCreatingService => '서비스를 생성하는 중 오류가 발생했습니다.';

  @override
  String get errorCreatingProduct => '제품을 생성하는 중 오류가 발생했습니다.';

  @override
  String get unknownError => '서비스를 생성하는 중에 알 수 없는 오류가 발생했습니다.';

  @override
  String get submit => '제출하다';

  @override
  String get selectCategoryAction => '카테고리 선택';

  @override
  String get selectCondition => '조건 선택';

  @override
  String get sum => '합집합';

  @override
  String get noComments => '아직 댓글이 없습니다. 가장 먼저 댓글을 달아주세요!';

  @override
  String get commentLikeSuccess => '댓글에 좋아요를 표시했습니다.';

  @override
  String get commentLikeError => '댓글에 좋아요를 누르는 중 오류가 발생했습니다.';

  @override
  String get unknownErrorMessage => '알 수 없는 오류가 발생했습니다.';

  @override
  String get commentDislikeSuccess => '댓글이 싫어요 표시되었습니다.';

  @override
  String get commentDislikeError => '댓글을 싫어하는 중에 오류가 발생했습니다.';

  @override
  String get replyInfo => '먼저 답장을 입력하세요.';

  @override
  String get replySuccessMessage => '답글이 추가되었습니다.';

  @override
  String get replyErrorMessage => '답글을 작성하는 중 오류가 발생했습니다.';

  @override
  String get commentUpdateSuccess => '댓글이 업데이트되었습니다.';

  @override
  String get commentUpdateError => '댓글 항목을 업데이트하는 중에 오류가 발생했습니다.';

  @override
  String get deleteConfirmationMessage => '이 댓글을 삭제하시겠습니까?';

  @override
  String get commentDeleteSuccess => '댓글이 삭제되었습니다.';

  @override
  String get commentDeleteError => '댓글을 삭제하는 중에 오류가 발생했습니다.';

  @override
  String get editLabel => '편집하다';

  @override
  String get deleteLabel => '삭제';

  @override
  String get saveLabel => '구하다';

  @override
  String get replyLabel => '회신하다';

  @override
  String get replyTitle => '답글';

  @override
  String get replyPlaceholder => '답장을 쓰세요...';

  @override
  String get chatLoginMessage => '채팅을 시작하려면 로그인해야 합니다';

  @override
  String get chatYourselfMessage => '자신과 채팅할 수 없습니다.';

  @override
  String get chatRoomMessage => '채팅방이 생성되었습니다!';

  @override
  String get chatRoomError => '채팅을 생성하지 못했습니다!';

  @override
  String get chatCreationError => '채팅 생성에 실패했습니다!';

  @override
  String get productsTotal => '제품 총계';

  @override
  String get perPage => '아이템';

  @override
  String get clearAllFilters => '모든 필터 지우기';

  @override
  String get clickToUpload => '업로드하려면 클릭하세요.';

  @override
  String get productInStock => '재고 있음';

  @override
  String get productOutStock => '품절';

  @override
  String get productBack => '제품으로 돌아가기';

  @override
  String get messageSeller => '채팅';

  @override
  String get recommendedProducts => '추천상품';

  @override
  String get deleteConfirmationProduct => '이 제품을 삭제하시겠습니까?';

  @override
  String get productDeleteSuccess => '제품이 삭제되었습니다.';

  @override
  String get productDeleteError => '제품 삭제 오류';

  @override
  String get newCondition => '새로운';

  @override
  String get used => '사용된';

  @override
  String get imageValidType =>
      '일부 파일이 추가되지 않았습니다. 5MB 이하의 JPG, PNG, GIF, WebP 파일을 사용해 주세요.';

  @override
  String get imageConfirmMessage => '이 이미지를 삭제하시겠습니까?';

  @override
  String get titleRequiredMessage => '제목은 필수 항목입니다.';

  @override
  String get descRequiredMessage => '설명은 필수입니다';

  @override
  String get priceRequiredMessage => '가격은 필수 항목입니다.';

  @override
  String get conditionRequiredMessage => '조건은 필수입니다';

  @override
  String get pleaseFillAllRequired => '필수 입력란을 작성해주세요.';

  @override
  String get oneImageConfirmMessage => '제품 이미지가 하나 이상 필요합니다.';

  @override
  String get categoryRequiredMessage => '카테고리는 필수 항목입니다.';

  @override
  String get locationInfoError => '사용자 위치 정보가 누락되었습니다';

  @override
  String get editProductTitle => '제품 편집';

  @override
  String get imageUploadRequirements =>
      '이미지가 하나 이상 필요합니다. 최대 10개의 이미지(각각 5MB 이하의 JPG, PNG, GIF, WebP)를 업로드할 수 있습니다.';

  @override
  String get productUpdatedSuccess => '제품이 성공적으로 업데이트되었습니다.';

  @override
  String get productUpdateFailed => '제품 업데이트 실패';

  @override
  String get errorUpdatingProduct => '제품 업데이트 중 오류가 발생했습니다.';

  @override
  String get serviceBack => '서비스로 돌아가기';

  @override
  String get likeLabel => '좋다';

  @override
  String get commentsLabel => '댓글';

  @override
  String get writeComment => '댓글을 쓰세요 ...';

  @override
  String get postingLabel => '전기...';

  @override
  String get commentCreated => '댓글이 생성되었습니다.';

  @override
  String get postCommentLabel => '댓글 게시';

  @override
  String get loginPrompt => '댓글을 확인하고 게시하려면 로그인하세요.';

  @override
  String get recommendedServices => '추천 서비스';

  @override
  String get commentsVisibilityNotice => '댓글은 로그인한 사용자에게만 표시됩니다.';

  @override
  String get comingSoon => '곧 출시 예정';

  @override
  String get serviceUpdateSuccess => '서비스가 업데이트되었습니다.';

  @override
  String get serviceUpdateError => '서비스 항목을 업데이트하는 중에 오류가 발생했습니다.';

  @override
  String get editServiceModalTitle => '서비스 편집';

  @override
  String get enterPhoneNumberWithoutCode => '코드 없이 전화번호를 입력하세요.';

  @override
  String get heroTitle => '테즈셀';

  @override
  String get heroSubtitle => '우즈베키스탄의 빠르고 쉬운 시장';

  @override
  String get startSelling => '판매 시작';

  @override
  String get browseProducts => '제품 찾아보기';

  @override
  String get featuresTitle => 'TezSell을 선택하는 이유는 무엇입니까?';

  @override
  String get listingTitle => '간단한 제품 목록';

  @override
  String get listingDescription =>
      '몇 번의 클릭만으로 항목을 나열할 수 있습니다. 사진을 추가하고, 가격을 설정하고, 구매자와 즉시 연결하세요.';

  @override
  String get locationTitle => '위치 기반 탐색';

  @override
  String get locationDescription =>
      '가까운 상품을 찾아보세요. 우리의 위치 기반 시스템은 당신의 이웃에 있는 물건을 찾는 데 도움이 됩니다.';

  @override
  String get location_subtitle => '인근 목록을 보려면 지역 및 구역을 선택하세요.';

  @override
  String get categoryTitle => '카테고리 필터링';

  @override
  String get categoryDescription => '다양한 카테고리를 쉽게 탐색하여 원하는 것을 정확하게 찾을 수 있습니다.';

  @override
  String get inspirationTitle => '한국 당근마켓에서 영감을 받아';

  @override
  String get inspirationDescription1 =>
      '우리는 한국의 성공적인 당근 마켓(당근마켓)에서 영감을 받아 TezSell을 구축했지만 우즈베키스탄 지역 사회의 독특한 요구 사항을 충족하도록 특별히 맞춤화했습니다.';

  @override
  String get inspirationDescription2 =>
      '우리의 임무는 이웃이 쉽게 사고 팔고 연결할 수 있는 신뢰할 수 있는 플랫폼을 만드는 것입니다.';

  @override
  String get comingSoonTitle => 'TezSell에 곧 출시 예정';

  @override
  String get inAppChat => '인앱 채팅';

  @override
  String get secureTransactions => '안전한 거래';

  @override
  String get realEstateListings => '부동산 목록';

  @override
  String get stayUpdated => '최신 정보 유지';

  @override
  String get comingSoonBadge => '출시 예정';

  @override
  String get ctaTitle => '지금 TezSell 커뮤니티에 가입하세요!';

  @override
  String get ctaDescription =>
      '우즈베키스탄을 위한 더 나은 시장 경험을 구축하는 데 참여하세요. 피드백을 공유하고 우리의 성장을 도와주세요!';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get learnMore => '자세히 알아보기';

  @override
  String get replyUpdateSuccess => '답글이 업데이트되었습니다.';

  @override
  String get replyUpdateError => '답글을 업데이트하지 못했습니다.';

  @override
  String get replyDeleteSuccess => '답글이 삭제되었습니다.';

  @override
  String get replyDeleteError => '답글을 삭제하지 못했습니다.';

  @override
  String get replyDeleteConfirmation => '이 답글을 삭제하시겠습니까?';

  @override
  String get authenticationRequired => '인증 필요';

  @override
  String get enterValidReply => '올바른 답장 텍스트를 입력하세요.';

  @override
  String get saving => '절약...';

  @override
  String get deleting => '삭제 중...';

  @override
  String get properties => '속성';

  @override
  String get agents => '자치령 대표';

  @override
  String get becomeAgent => '에이전트 되기';

  @override
  String get main => '기본';

  @override
  String get upload => '업로드';

  @override
  String get filtered_products => '필터링된 제품';

  @override
  String get filtered_services => '필터링된 서비스';

  @override
  String get productDetail => '제품 세부정보';

  @override
  String get unknownUser => '알 수 없는 사용자';

  @override
  String get locationNotAvailable => '위치를 알 수 없음';

  @override
  String get noTitle => '제목 없음';

  @override
  String get noCategory => '카테고리 없음';

  @override
  String get noDescription => '설명 없음';

  @override
  String get som => '솜';

  @override
  String get about_me => '나에 대해';

  @override
  String get my_name => '내 이름';

  @override
  String get customer_support => '고객 지원';

  @override
  String get customer_center => '고객센터';

  @override
  String get customer_inquiries => '문의사항';

  @override
  String get customer_terms => '이용약관';

  @override
  String get region => '지역';

  @override
  String get district => '구역';

  @override
  String get tap_change_profile => '사진을 변경하려면 탭하세요.';

  @override
  String get language_settings => '언어 설정';

  @override
  String get selectLanguage => '언어를 선택하세요';

  @override
  String get select_theme => '테마 선택';

  @override
  String get theme => '주제';

  @override
  String get location_settings => '위치 설정';

  @override
  String get security => '보안';

  @override
  String get data_storage => '데이터 및 스토리지';

  @override
  String get accessibility => '접근성';

  @override
  String get privacy => '은둔';

  @override
  String get light_theme => '빛';

  @override
  String get dark_theme => '어두운';

  @override
  String get system_theme => '시스템 기본값';

  @override
  String get my_products => '내 제품';

  @override
  String get refresh => '새로 고치다';

  @override
  String get delete_product => '제품 삭제';

  @override
  String get delete_confirmation => '이 제품을 삭제하시겠습니까?';

  @override
  String get delete => '삭제';

  @override
  String error_loading_products(String error) {
    return '제품 로드 오류: $error';
  }

  @override
  String get product_deleted_success => '제품이 삭제되었습니다.';

  @override
  String error_deleting_product(String error) {
    return '제품 삭제 오류: $error';
  }

  @override
  String get no_products_found => '제품을 찾을 수 없습니다';

  @override
  String get add_first_product => '첫 번째 제품을 추가하여 시작하세요.';

  @override
  String get no_title => '제목 없음';

  @override
  String get no_description => '설명 없음';

  @override
  String get in_stock => '재고 있음';

  @override
  String get out_of_stock => '품절';

  @override
  String get new_condition => '새로운';

  @override
  String get edit_product => '제품 편집';

  @override
  String get delete_product_tooltip => '제품 삭제';

  @override
  String get sum_currency => '합집합';

  @override
  String get edit_product_title => '제품 편집';

  @override
  String get product_name => '제품명';

  @override
  String get product_description => '제품 설명';

  @override
  String get price => '가격';

  @override
  String get condition => '상태';

  @override
  String get condition_new => '새로운';

  @override
  String get condition_like_new => '거의 새것';

  @override
  String get condition_used => '사용된';

  @override
  String get condition_refurbished => '리퍼브 상품';

  @override
  String get currency => '통화';

  @override
  String get category => '범주';

  @override
  String get images => '이미지';

  @override
  String get existing_images => '기존 이미지';

  @override
  String get new_images => '새로운 이미지';

  @override
  String get image_instructions => '여기에 이미지가 표시됩니다. 위의 업로드 아이콘을 눌러주세요.';

  @override
  String get update_button => '업데이트';

  @override
  String loading_category_error(String error) {
    return '카테고리 로드 중 오류 발생: $error';
  }

  @override
  String error_picking_images(String error) {
    return '이미지 선택 오류: $error';
  }

  @override
  String get please_fill_all_required => '모든 필드를 작성해 주세요.';

  @override
  String get invalid_price_message => '잘못된 가격이 입력되었습니다. 유효한 숫자를 입력하세요.';

  @override
  String get category_required_message => '유효한 카테고리를 선택하세요.';

  @override
  String get one_image_required_message => '제품 이미지가 하나 이상 필요합니다.';

  @override
  String get product_updated_success => '제품이 업데이트되었습니다.';

  @override
  String error_updating_product(String error) {
    return '제품 업데이트 중 오류 발생: $error';
  }

  @override
  String get my_services => '내 서비스';

  @override
  String get delete_service => '서비스 삭제';

  @override
  String get delete_service_confirmation => '이 서비스를 삭제하시겠습니까?';

  @override
  String get no_services_found => '서비스를 찾을 수 없습니다.';

  @override
  String get add_first_service => '첫 번째 서비스를 추가하여 시작하세요.';

  @override
  String get edit_service => '서비스 편집';

  @override
  String get delete_service_tooltip => '서비스 삭제';

  @override
  String get service_deleted_successfully => '서비스가 삭제되었습니다.';

  @override
  String get error_deleting_service => '서비스 삭제 오류';

  @override
  String get error_loading_services => '서비스를 로드하는 중에 오류가 발생했습니다.';

  @override
  String get service_name => '서비스 이름';

  @override
  String get enter_service_name => '서비스 이름을 입력하세요';

  @override
  String get service_name_required => '서비스 이름은 필수 항목입니다.';

  @override
  String get service_name_min_length => '서비스 이름은 3자 이상이어야 합니다.';

  @override
  String get enter_service_description => '서비스 설명을 입력하세요';

  @override
  String get service_description_required => '서비스 설명이 필요합니다.';

  @override
  String get service_description_min_length => '설명은 10자 이상이어야 합니다.';

  @override
  String get category_required => '카테고리를 선택해주세요';

  @override
  String get no_categories_available => '사용 가능한 카테고리가 없습니다.';

  @override
  String get location => '위치';

  @override
  String get select_location => '위치 선택';

  @override
  String get location_required => '위치를 선택하세요';

  @override
  String get no_locations_available => '사용 가능한 위치가 없습니다.';

  @override
  String get add_images => '이미지 추가';

  @override
  String get current_images => '현재 이미지';

  @override
  String get no_images_selected => '선택한 이미지가 없습니다.';

  @override
  String get save_changes => '변경 사항 저장';

  @override
  String get map_main => '지도 및 부동산';

  @override
  String get agent_status => '에이전트 상태';

  @override
  String get admin_panel => '관리자 패널';

  @override
  String get propertiesFound => '발견된 속성';

  @override
  String get propertiesSaved => '속성이 저장되었습니다';

  @override
  String get saved => '저장됨';

  @override
  String get loadingProperties => '속성 로드 중...';

  @override
  String get failedToLoad => '속성을 로드하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get noPropertiesFound => '속성을 찾을 수 없습니다';

  @override
  String get tryAdjusting => '검색 기준을 조정해 보세요';

  @override
  String get search_placeholder => '제목이나 위치로 검색하세요...';

  @override
  String get search_filters => '필터';

  @override
  String get search_button => '찾다';

  @override
  String get search_clear_filters => '필터 지우기';

  @override
  String get filter_options_sale_and_rent => '판매 및 임대';

  @override
  String get filter_options_for_sale => '판매용';

  @override
  String get filter_options_for_rent => '임대용';

  @override
  String get filter_options_all_types => '모든 유형';

  @override
  String get filter_options_apartment => '아파트';

  @override
  String get filter_options_house => '집';

  @override
  String get filter_options_townhouse => '타운하우스';

  @override
  String get filter_options_villa => '별장';

  @override
  String get filter_options_commercial => '광고';

  @override
  String get filter_options_office => '사무실';

  @override
  String get property_card_featured => '추천';

  @override
  String get property_card_bed => '침실';

  @override
  String get property_card_bath => '화장실';

  @override
  String get property_card_parking => '주차';

  @override
  String get property_card_view_details => '세부정보 보기';

  @override
  String get property_card_contact => '연락하다';

  @override
  String get property_card_balcony => '발코니';

  @override
  String get property_card_garage => '차고';

  @override
  String get property_card_garden => '정원';

  @override
  String get property_card_pool => '수영장';

  @override
  String get property_card_elevator => '엘리베이터';

  @override
  String get property_card_furnished => '가구';

  @override
  String get property_card_sales => '매상';

  @override
  String get pricing_month => '/월';

  @override
  String get results_properties_found => '발견된 속성';

  @override
  String get results_properties_saved => '속성이 저장되었습니다';

  @override
  String get results_saved => '저장됨';

  @override
  String get results_loading_properties => '속성 로드 중...';

  @override
  String get results_failed_to_load => '속성을 로드하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get results_no_properties_found => '속성을 찾을 수 없습니다';

  @override
  String get results_try_adjusting => '검색 기준을 조정해 보세요';

  @override
  String get no_properties_found => '속성을 찾을 수 없습니다';

  @override
  String get no_category_properties => '이 카테고리에는 숙소가 없습니다';

  @override
  String get properties_loading => '속성 로드 중...';

  @override
  String get all_properties_loaded => '모든 속성이 로드되었습니다.';

  @override
  String n_properties(int count) {
    return '$count 속성';
  }

  @override
  String get in_area => '지역에';

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
  String get pagination_previous => '이전의';

  @override
  String get pagination_next => '다음';

  @override
  String get pagination_page => '페이지';

  @override
  String get pagination_page_of => '페이지 1 /';

  @override
  String get contact_modal_title => '연락처 정보';

  @override
  String get contact_modal_agent_contact => '대리인 연락처';

  @override
  String get contact_modal_property_owner => '부동산 소유자';

  @override
  String get contact_modal_agent_phone_number => '대리인 전화번호';

  @override
  String get contact_modal_owner_phone_number => '소유자 전화번호';

  @override
  String get contact_modal_license => '특허';

  @override
  String get contact_modal_rating => '평가';

  @override
  String get contact_modal_call_now => '지금 전화하세요';

  @override
  String get contact_modal_copy_number => '복사 번호';

  @override
  String get contact_modal_close => '닫다';

  @override
  String get contact_modal_contact_hours => '연락시간: 오전 9시 - 오후 8시';

  @override
  String get contact_modal_agent => '대리인';

  @override
  String get errors_toggle_save_failed => '속성 저장을 전환하지 못했습니다.';

  @override
  String get errors_copy_failed => '전화번호를 복사하지 못했습니다:';

  @override
  String get errors_phone_copied => '전화번호가 클립보드에 복사되었습니다.';

  @override
  String get errors_error_occurred_regions => '지역에 오류가 발생했습니다.';

  @override
  String get errors_error_occurred_districts => '구역에 오류가 발생했습니다.';

  @override
  String get errors_please_fill_all_required_fields => '필수 입력란을 모두 작성해 주세요.';

  @override
  String get errors_authentication_required => '인증 필요';

  @override
  String get errors_user_info_missing => '사용자 정보가 누락되었습니다.';

  @override
  String get errors_validation_error => '입력 데이터를 확인하세요.';

  @override
  String get errors_permission_denied => '허가가 거부되었습니다';

  @override
  String get errors_server_error => '서버 오류가 발생했습니다';

  @override
  String get errors_network_error => '네트워크 연결 오류';

  @override
  String get errors_timeout_error => '요청 시간 초과됨';

  @override
  String get errors_custom_error => '오류가 발생했습니다';

  @override
  String get errors_error_creating_property => '속성을 생성하는 중에 오류가 발생했습니다.';

  @override
  String get errors_unknown_error_message => '알 수 없는 오류가 발생했습니다.';

  @override
  String get errors_coordinates_not_found =>
      '이 주소에 대한 좌표를 찾을 수 없습니다. 수동으로 입력해 주세요.';

  @override
  String get errors_coordinates_error =>
      '좌표를 가져오는 중에 오류가 발생했습니다. 수동으로 입력해 주세요.';

  @override
  String get property_info_views => '조회수';

  @override
  String get property_info_listed => '상장됨';

  @override
  String get property_info_price_per_sqm => '/제곱미터';

  @override
  String get property_info_saved => '저장됨';

  @override
  String get property_info_save => '구하다';

  @override
  String get property_info_share => '공유하다';

  @override
  String get loading_loading => '로드 중...';

  @override
  String get loading_loading_details => '속성 세부정보 로드 중...';

  @override
  String get loading_property_not_found => '속성을 찾을 수 없습니다';

  @override
  String get loading_property_not_found_message =>
      '찾고 있는 속성이 존재하지 않거나 삭제되었습니다.';

  @override
  String get loading_back_to_properties => '속성으로 돌아가기';

  @override
  String get loading_title => '에이전트 로드 중...';

  @override
  String get loading_message => '에이전트 목록을 로드하는 동안 잠시 기다려 주십시오.';

  @override
  String get loading_agent_not_found => '에이전트를 찾을 수 없습니다.';

  @override
  String get property_details_title => '부동산 세부정보';

  @override
  String get property_details_bedrooms => '침실';

  @override
  String get property_details_bathrooms => '욕실';

  @override
  String get property_details_floor_area => '바닥면적';

  @override
  String get property_details_parking => '주차';

  @override
  String get property_details_basic_information => '기본정보';

  @override
  String get property_details_property_type => '부동산 유형:';

  @override
  String get property_details_listing_type => '목록 유형:';

  @override
  String get property_details_for_sale => '판매용';

  @override
  String get property_details_for_rent => '임대용';

  @override
  String get property_details_year_built => '건축 연도:';

  @override
  String get property_details_floor => '바닥:';

  @override
  String get property_details_of => '~의';

  @override
  String get property_details_features_amenities => '특징 및 편의시설';

  @override
  String get sections_description => '설명';

  @override
  String get sections_nearby_amenities => '주변 편의시설';

  @override
  String get sections_similar_properties => '유사한 속성';

  @override
  String get amenities_metro => '지하철';

  @override
  String get amenities_school => '학교';

  @override
  String get amenities_hospital => '병원';

  @override
  String get amenities_shopping => '쇼핑';

  @override
  String get amenities_away => '떨어져 있는';

  @override
  String get contact_title => '연락처 정보';

  @override
  String get contact_professional_listing => '전문 목록';

  @override
  String get contact_listed_by_agent => '확인된 에이전트에 의해 나열됨';

  @override
  String get contact_by_owner => '소유자별';

  @override
  String get contact_direct_contact => '집주인과 직접 연락';

  @override
  String get contact_property_owner => '부동산 소유자';

  @override
  String get contact_call_agent => '상담원에게 전화하기';

  @override
  String get contact_email_agent => '이메일 에이전트';

  @override
  String get contact_call_owner => '통화 소유자';

  @override
  String get contact_email_owner => '이메일 소유자';

  @override
  String get contact_send_inquiry => '문의 보내기';

  @override
  String get property_status_title => '부동산 현황';

  @override
  String get property_status_availability => '유효성:';

  @override
  String get property_status_available => '사용 가능';

  @override
  String get property_status_not_available => '사용할 수 없음';

  @override
  String get property_status_featured => '추천:';

  @override
  String get property_status_featured_property => '주요 부동산';

  @override
  String get property_status_property_id => '부동산 ID:';

  @override
  String get inquiry_title => '문의 보내기';

  @override
  String get inquiry_inquiry_type => '문의 유형';

  @override
  String get inquiry_request_info => '정보 요청';

  @override
  String get inquiry_schedule_viewing => '시청 일정';

  @override
  String get inquiry_make_offer => '제안하기';

  @override
  String get inquiry_request_callback => '콜백 요청';

  @override
  String get inquiry_message => '메시지';

  @override
  String get inquiry_message_placeholder => '이 부동산에 대한 관심을 알려주십시오...';

  @override
  String get inquiry_offered_price => '제안 가격';

  @override
  String get inquiry_enter_offer => '제안을 입력하세요';

  @override
  String get inquiry_preferred_contact_time => '선호하는 연락 시간(선택 사항)';

  @override
  String get inquiry_contact_time_placeholder => '예: 평일 오전 9시~오후 5시';

  @override
  String get inquiry_cancel => '취소';

  @override
  String get inquiry_sending => '배상...';

  @override
  String get inquiry_send_inquiry => '문의 보내기';

  @override
  String get inquiry_inquiry_sent_success => '문의가 성공적으로 전송되었습니다!';

  @override
  String get inquiry_inquiry_sent_error => '문의를 보내지 못했습니다. 다시 시도해 주세요.';

  @override
  String get alerts_link_copied => '속성 링크가 클립보드에 복사되었습니다!';

  @override
  String get alerts_phone_copied => '전화번호가 클립보드에 복사되었습니다!';

  @override
  String get alerts_save_property_failed => '속성을 저장하지 못했습니다.';

  @override
  String get alerts_email_subject => '문의사항:';

  @override
  String alerts_email_body(Object address, Object title) {
    return '안녕하세요.\\n\\n저는 $address에 위치한 귀하의 부동산 \"$title\"에 관심이 있습니다.\\n\\n자세한 내용은 저에게 연락해 주세요.\\n\\n감사합니다.';
  }

  @override
  String get related_properties_view_details => '세부정보 보기';

  @override
  String get header_property => '당신의 꿈의 부동산을 찾아보세요';

  @override
  String get header_sub_property => '타슈켄트에서 가장 매력적인 지역에서 프리미엄 부동산 기회를 찾아보세요';

  @override
  String get header_title => '부동산 중개인';

  @override
  String get header_subtitle => '귀하의 부동산 관련 요구 사항에 도움을 줄 수 있는 숙련된 에이전트를 찾아보세요';

  @override
  String get header_agents_found => '에이전트를 찾았습니다';

  @override
  String get filters_all_specializations => '모든 전문화';

  @override
  String get filters_residential => '주거용';

  @override
  String get filters_commercial => '광고';

  @override
  String get filters_luxury => '사치';

  @override
  String get filters_investment => '투자';

  @override
  String get filters_any_rating => '모든 평가';

  @override
  String get filters_four_stars => '별 4개 이상';

  @override
  String get filters_four_half_stars => '별 4.5개 이상';

  @override
  String get filters_five_stars => '별 5개';

  @override
  String get filters_highest_rated => '최고 등급';

  @override
  String get filters_lowest_rated => '최저 등급';

  @override
  String get filters_most_sales => '최다 판매';

  @override
  String get filters_most_experience => '대부분의 경험';

  @override
  String get agent_card_verified_agent => '검증된 에이전트';

  @override
  String get agent_card_years_experience => '년 경험';

  @override
  String get agent_card_years => '연령';

  @override
  String get agent_card_license => '특허';

  @override
  String get agent_card_specialization => '전문화';

  @override
  String get agent_card_view_profile => '프로필 보기';

  @override
  String get agent_card_contact => '연락하다';

  @override
  String get agent_card_verified => '확인됨';

  @override
  String get no_results_title => '에이전트를 찾을 수 없습니다.';

  @override
  String get no_results_message => '검색 기준이나 필터를 조정해 보세요.';

  @override
  String get error_title => '에이전트를 로드하는 중 오류가 발생했습니다.';

  @override
  String get error_message => '에이전트 목록을 로드하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get error_retry => '다시 해 보다';

  @override
  String get error_default_message => '에이전트 세부정보를 로드하지 못했습니다.';

  @override
  String get error_try_again => '다시 시도';

  @override
  String get notifications_phone_copied => '전화번호가 클립보드에 복사되었습니다.';

  @override
  String get notifications_copy_failed => '전화번호를 복사하지 못했습니다:';

  @override
  String get fallback_agent_name => '대리인';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => '부동산 제출';

  @override
  String get navigation_submitting => '제출 중...';

  @override
  String get navigation_back_to_agents => '에이전트로 돌아가기';

  @override
  String get agent_profile_verified_agent => '검증된 에이전트';

  @override
  String get agent_profile_contact_agent => '상담원에게 연락하기';

  @override
  String get agent_profile_send_message => '메시지 보내기';

  @override
  String get agent_profile_years_experience => '수년간의 경험';

  @override
  String get agent_profile_properties_sold => '판매된 부동산';

  @override
  String get agent_profile_active_listings => '활성 목록';

  @override
  String get agent_profile_total_properties => '총 재산';

  @override
  String get tabs_overview => '개요';

  @override
  String get tabs_properties => '속성';

  @override
  String get tabs_reviews => '리뷰';

  @override
  String get about_agent_title => '에이전트 소개';

  @override
  String get about_agent_agency => '대행사';

  @override
  String get about_agent_license_number => '라이센스 번호';

  @override
  String get about_agent_specialization => '전문화';

  @override
  String get about_agent_member_since => '회원가입 이후';

  @override
  String get about_agent_verified_since => '이후부터 확인됨';

  @override
  String get performance_metrics_title => '성능 지표';

  @override
  String get performance_metrics_average_rating => '평균 평점';

  @override
  String get performance_metrics_properties_sold => '판매된 부동산';

  @override
  String get performance_metrics_active_listings => '활성 목록';

  @override
  String get performance_metrics_years_experience => '수년간의 경험';

  @override
  String get contact_info_title => '연락처 정보';

  @override
  String get contact_info_contact_via_platform => '플랫폼을 통한 연락';

  @override
  String get verification_status_title => '확인 상태';

  @override
  String get verification_status_verified_agent => '검증된 에이전트';

  @override
  String get verification_status_pending_verification => '확인 대기 중';

  @override
  String get verification_status_licensed_professional => '라이센스가 있는 전문가';

  @override
  String get verification_status_registered_agency => '등록된 대리점';

  @override
  String get quick_actions_title => '빠른 작업';

  @override
  String get quick_actions_call_now => '지금 전화하세요';

  @override
  String get quick_actions_send_message => '메시지 보내기';

  @override
  String get quick_actions_view_properties => '속성 보기';

  @override
  String get properties_title => '에이전트 속성';

  @override
  String get properties_loading_properties => '속성 로드 중...';

  @override
  String get properties_no_properties_title => '속성을 찾을 수 없습니다';

  @override
  String get properties_no_properties_message => '이 에이전트의 속성이 여기에 표시됩니다.';

  @override
  String get properties_recent_properties_note =>
      '최근 속성을 표시합니다. 모든 에이전트 속성의 전체 목록을 확인하세요.';

  @override
  String get properties_listed => '상장됨';

  @override
  String get properties_bed => '침대';

  @override
  String get properties_bath => '욕조';

  @override
  String get properties_for_sale => '판매용';

  @override
  String get properties_for_rent => '임대용';

  @override
  String get reviews_title => '고객 리뷰';

  @override
  String get reviews_no_reviews_title => '아직 리뷰가 없습니다';

  @override
  String get reviews_no_reviews_message => '고객 리뷰 및 권장 사항이 여기에 표시됩니다.';

  @override
  String get fallbacks_agent_name => '대리인';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => '저장된 속성';

  @override
  String get saved_properties_subtitle => '즐겨찾는 부동산을 한곳에서 만나보세요';

  @override
  String get saved_properties_no_saved_properties => '아직 저장된 속성이 없습니다.';

  @override
  String get saved_properties_start_saving => '탐색을 시작하고 마음에 드는 부동산을 저장하세요';

  @override
  String get saved_properties_browse_properties => '속성 찾아보기';

  @override
  String get saved_properties_saved_on => '저장 날짜';

  @override
  String get auth_login_required => '저장된 속성을 보려면 로그인하세요.';

  @override
  String get auth_login => '로그인';

  @override
  String get success_property_unsaved => '저장된 목록에서 속성이 제거되었습니다.';

  @override
  String get success_property_saved => '속성이 성공적으로 저장되었습니다.';

  @override
  String get success_phone_copied => '전화번호가 복사되었습니다!';

  @override
  String get success_property_created_success => '속성이 성공적으로 생성되었습니다!';

  @override
  String get success_agent_approved => '에이전트가 성공적으로 승인되었습니다.';

  @override
  String get success_agent_rejected => '에이전트가 성공적으로 거부되었습니다.';

  @override
  String get steps_step => '단계';

  @override
  String get steps_basic_information => '기본정보';

  @override
  String get steps_location_details => '위치 세부정보';

  @override
  String get steps_property_details => '부동산 세부정보';

  @override
  String get steps_property_images => '부동산 이미지';

  @override
  String get basic_info_tell_us_about_property => '귀하의 재산에 대해 알려주십시오.';

  @override
  String get basic_info_property_type => '부동산 유형';

  @override
  String get basic_info_listing_type => '목록 유형';

  @override
  String get basic_info_property_title => '부동산 제목';

  @override
  String get basic_info_title_placeholder => '속성을 설명하는 제목을 입력하세요.';

  @override
  String get basic_info_description => '설명';

  @override
  String get basic_info_description_placeholder => '귀하의 재산을 자세히 설명하십시오 ...';

  @override
  String get property_types_apartment => '아파트';

  @override
  String get property_types_house => '집';

  @override
  String get property_types_townhouse => '타운하우스';

  @override
  String get property_types_villa => '별장';

  @override
  String get property_types_commercial => '광고';

  @override
  String get property_types_office => '사무실';

  @override
  String get property_types_land => '땅';

  @override
  String get property_types_warehouse => '창고';

  @override
  String get listing_types_for_sale => '판매용';

  @override
  String get listing_types_for_rent => '임대용';

  @override
  String get location_where_is_property => '귀하의 부동산은 어디에 있습니까?';

  @override
  String get location_full_address => '전체 주소';

  @override
  String get location_address_placeholder => '전체 주소를 입력하세요';

  @override
  String get location_region => '지역';

  @override
  String get location_select_region => '지역 선택';

  @override
  String get location_district => '구역';

  @override
  String get location_select_district => '지구 선택';

  @override
  String get location_city => '도시';

  @override
  String get location_city_placeholder => '도시';

  @override
  String get location_loading_regions => '지역 로드 중...';

  @override
  String get location_loading_districts => '지역 로드 중...';

  @override
  String get location_map_coordinates => '지도 좌표';

  @override
  String get location_get_coordinates => '좌표 얻기';

  @override
  String get location_latitude => '위도';

  @override
  String get location_longitude => '경도';

  @override
  String get location_coordinates_set => '좌표 세트';

  @override
  String get location_location_tips => '위치 팁';

  @override
  String get location_location_tip_1 =>
      '• 먼저 주소를 입력한 후 \'좌표 가져오기\'를 클릭하면 자동으로 지도 위치를 가져옵니다.';

  @override
  String get location_location_tip_2 =>
      '• 정확한 위치를 알고 있는 경우 좌표를 수동으로 입력할 수도 있습니다.';

  @override
  String get location_location_tip_3 =>
      '• 정확한 좌표는 구매자가 지도에서 귀하의 부동산을 찾는 데 도움이 됩니다.';

  @override
  String get property_details_provide_detailed_info =>
      '귀하의 부동산에 대한 자세한 정보를 제공하십시오';

  @override
  String get property_details_total_floors => '총층수';

  @override
  String get property_details_area_m2 => '면적(m²)';

  @override
  String get property_details_parking_spaces => '주차 공간';

  @override
  String get property_details_price => '가격';

  @override
  String get property_details_features => '특징';

  @override
  String get images_add_photos_showcase => '숙소를 소개할 사진을 추가하세요.';

  @override
  String get images_click_to_upload => '이미지를 업로드하려면 클릭하세요.';

  @override
  String get images_max_images_info => '최대 10개의 이미지, JPG, PNG 또는 WEBP';

  @override
  String get images_main => '기본';

  @override
  String get images_maximum_images_allowed => '최대 10개의 이미지가 허용됩니다.';

  @override
  String get admin_dashboard_title => '관리 대시보드';

  @override
  String get admin_dashboard_subtitle => '부동산 플랫폼의 실시간 개요';

  @override
  String get admin_last_update => '마지막 업데이트';

  @override
  String get admin_total_properties => '총 재산';

  @override
  String get admin_total_agents => '총 상담원';

  @override
  String get admin_total_users => '총 사용자';

  @override
  String get admin_total_views => '총 조회수';

  @override
  String get admin_error_loading_dashboard => '대시보드를 로드하는 중에 오류가 발생했습니다.';

  @override
  String get admin_failed_to_load_data => '대시보드 데이터를 로드하지 못했습니다.';

  @override
  String get admin_avg_sale_price => '평균 판매가';

  @override
  String get admin_avg_sale_price_subtitle => '모든 활성 목록';

  @override
  String get admin_total_portfolio_value => '총 포트폴리오 가치';

  @override
  String get admin_total_portfolio_value_subtitle => '결합된 자산 가치';

  @override
  String get admin_avg_price_per_sqm => '평방미터당 평균 가격';

  @override
  String get admin_avg_price_per_sqm_subtitle => '시장 금리 지표';

  @override
  String get admin_property_types_distribution => '부동산 유형 분포';

  @override
  String get admin_properties_by_city => '도시별 부동산';

  @override
  String get admin_properties_by_district => '지구별 부동산';

  @override
  String get admin_inquiry_types_distribution => '문의 유형 분포';

  @override
  String get admin_agent_verification_rate => '에이전트 검증 비율';

  @override
  String get admin_agent_verification_rate_subtitle => '품질 관리';

  @override
  String get admin_inquiry_response_rate => '문의 응답률';

  @override
  String get admin_inquiry_response_rate_subtitle => '고객 서비스';

  @override
  String get admin_avg_views_per_property => '부동산당 평균 조회수';

  @override
  String get admin_avg_views_per_property_subtitle => '부동산 인기';

  @override
  String get admin_featured_properties => '주요 속성';

  @override
  String get admin_featured_properties_subtitle => '프리미엄 목록';

  @override
  String get admin_most_viewed_properties => '가장 많이 본 부동산';

  @override
  String get admin_top_performing_agents => '최고의 성과를 내는 에이전트';

  @override
  String get admin_system_health => '시스템 상태';

  @override
  String get admin_properties_without_images => '이미지가 없는 속성';

  @override
  String get admin_missing_location_data => '위치 데이터 누락';

  @override
  String get admin_pending_agent_verification => '에이전트 확인 대기 중';

  @override
  String get admin_active => '활동적인';

  @override
  String get admin_verified => '검증됨';

  @override
  String get admin_active_7d => '활성(7일)';

  @override
  String get admin_this_month => '이번 달';

  @override
  String get agents_loading_pending_applications => '대기 중인 애플리케이션 로드 중...';

  @override
  String get agents_error_loading_applications => '애플리케이션을 로드하는 중에 오류가 발생했습니다.';

  @override
  String get agents_pending_agents => '보류 중인 에이전트';

  @override
  String get agents_total_pending_applications => '보류 중인 총 신청 수:';

  @override
  String get agents_pending_verification => '확인 대기 중';

  @override
  String get agents_applied_date => '적용된:';

  @override
  String get agents_contact_info => '연락처 정보';

  @override
  String get agents_license_number => '라이센스 번호';

  @override
  String get agents_years_experience => '수년간의 경험';

  @override
  String get agents_years_suffix => '연령';

  @override
  String get agents_total_sales => '총 매출';

  @override
  String get agents_specialization => '전문화';

  @override
  String get agents_approve => '승인하다';

  @override
  String get agents_reject => '거부하다';

  @override
  String get agents_no_pending_applications => '보류 중인 신청이 없습니다.';

  @override
  String get agents_all_applications_processed => '모든 에이전트 신청이 처리되었습니다.';

  @override
  String get general_previous => '이전의';

  @override
  String get general_page => '페이지';

  @override
  String get general_next => '다음';

  @override
  String get general_views => '조회수';

  @override
  String get general_sales => '매상';

  @override
  String get general_language_uz => '오즈벡차';

  @override
  String get general_language_ru => '러시아인';

  @override
  String get general_language_en => '영어';

  @override
  String get general_super_admin => '최고 관리자';

  @override
  String get general_staff => '직원';

  @override
  String get general_verified_agent => '검증된 에이전트';

  @override
  String get general_pending_agent => '보류 중인 에이전트';

  @override
  String get general_regular_user => '일반 사용자';

  @override
  String get general_admin => '관리자';

  @override
  String get general_dashboard => '계기반';

  @override
  String get general_manage_users => '사용자 관리';

  @override
  String get general_verified_agents => '검증된 에이전트';

  @override
  String get general_agent_panel => '에이전트 패널';

  @override
  String get general_create_property => '속성 생성';

  @override
  String get general_my_properties => '내 자산';

  @override
  String get general_inquiries => '문의사항';

  @override
  String get general_agent_profile => '에이전트 프로필';

  @override
  String get general_live => '살다';

  @override
  String get general_logged_out_successfully => '성공적으로 로그아웃되었습니다';

  @override
  String get general_logout_completed_with_errors => '로그아웃 완료(오류 있음)';

  @override
  String get general_application_under_review => '검토 중인 신청서';

  @override
  String get general_check_status => '상태 확인 →';

  @override
  String get general_last_updated => '마지막 업데이트:';

  @override
  String get general_permissions_may_be_outdated => '권한이 오래되었을 수 있습니다.';

  @override
  String get general_permissions_up_to_date => '최신 권한';

  @override
  String get general_never => '절대';

  @override
  String get general_properties_found => '발견된 속성';

  @override
  String get general_properties_saved => '속성이 저장되었습니다';

  @override
  String get general_saved => '저장됨';

  @override
  String get general_loading_properties => '속성 로드 중...';

  @override
  String get general_failed_to_load => '속성을 로드하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get general_no_properties_found => '속성을 찾을 수 없습니다';

  @override
  String get general_try_adjusting => '검색 기준을 조정해 보세요';

  @override
  String get select_category => '카테고리 선택';

  @override
  String get service_description => '서비스 설명';

  @override
  String get product_search_placeholder => '제품을 찾으려면 검색어를 입력하세요.';

  @override
  String get privacy_policy => '개인 정보 보호 정책';

  @override
  String get terms_subtitle => '개인정보 보호정책 및 약관';

  @override
  String get last_updated => '마지막 업데이트';

  @override
  String get contact_information => '연락처 정보';

  @override
  String get accept_terms => '이용약관에 동의합니다.';

  @override
  String get read_terms => '이용약관을 읽어보세요.';

  @override
  String get inquiries => '문의 및 지원';

  @override
  String get inquiries_subtitle => '도움이 필요하면 문의하세요';

  @override
  String get help_center => '어떻게 도와드릴까요?';

  @override
  String get help_subtitle => '궁금한 점이 있으면 도와드리겠습니다.';

  @override
  String get contact_us => '문의하기';

  @override
  String get email_support => '이메일 지원';

  @override
  String get call_support => '지원팀에 전화하세요';

  @override
  String get send_message => '메시지 보내기';

  @override
  String get fill_contact_form => '문의 양식을 작성하세요';

  @override
  String get contact_form => '문의 양식';

  @override
  String get name => '당신의 이름';

  @override
  String get name_required => '이름을 입력해주세요';

  @override
  String get email => '이메일 주소';

  @override
  String get email_required => '이메일을 입력해주세요';

  @override
  String get email_invalid => '유효한 이메일을 입력해주세요';

  @override
  String get subject => '주제';

  @override
  String get subject_required => '제목을 입력해주세요';

  @override
  String get message => '메시지';

  @override
  String get message_required => '메시지를 입력해주세요';

  @override
  String get message_too_short => '메시지는 10자 이상이어야 합니다.';

  @override
  String get faq => '자주 묻는 질문';

  @override
  String get follow_us => '우리를 팔로우하세요';

  @override
  String get faq_how_to_sell => 'Tezsell에서 아이템을 어떻게 판매하나요?';

  @override
  String get faq_how_to_sell_answer =>
      '아이템 판매 방법: 1) 계정 만들기, 2) \'+\' 버튼 누르기, 3) 카테고리 선택(제품/서비스/부동산), 4) 사진 및 설명 추가, 5) 가격 설정, 6) 게시! 귀하의 목록은 해당 지역의 구매자에게 표시됩니다.';

  @override
  String get faq_is_free => 'Tezsell은 무료로 사용할 수 있나요?';

  @override
  String get faq_is_free_answer =>
      '예! Tezsell은 현재 100% 무료입니다. 상장 수수료, 판매 수수료, 구독료가 없습니다. 향후 프리미엄 기능을 도입할 수도 있지만 30일 전에 미리 사용자에게 알릴 것입니다.';

  @override
  String get faq_safety => '구매/판매 시 어떻게 안전하게 지낼 수 있나요?';

  @override
  String get faq_safety_answer =>
      '안전 수칙: 1) 공공장소에서 만나기, 2) 결제 전 물건 검사하기, 3) 모르는 사람에게 절대 돈 보내지 않기, 4) 직감을 믿으세요, 5) 의심스러운 사용자 신고하기, 6) 개인 정보를 너무 일찍 공유하지 않기, 7) 고액 거래에는 친구와 함께 가세요.';

  @override
  String get faq_payment => '결제는 어떻게 이루어지나요?';

  @override
  String get faq_payment_answer =>
      'Tezsell은 결제를 처리하지 않습니다. 구매자와 판매자가 직접 결제를 주선합니다(현금, 은행 송금 등). 우리는 사람들을 연결하는 플랫폼일 뿐입니다. 거래는 귀하가 직접 처리하세요.';

  @override
  String get faq_prohibited => '어떤 품목이 금지되나요?';

  @override
  String get faq_prohibited_answer =>
      '금지된 품목에는 무기, 마약, 도난품, 위조품, 성인용 콘텐츠, 살아있는 동물(허가증 없음), 정부 신분증 및 위험 물질이 포함됩니다. 전체 목록은 이용 약관을 참조하세요.';

  @override
  String get faq_account_delete => '내 계정을 어떻게 삭제하나요?';

  @override
  String get faq_account_delete_answer =>
      '프로필 → 설정 → 계정 설정 → 계정 삭제로 이동하세요. 참고: 이 작업은 영구적이며 취소할 수 없습니다. 모든 목록이 제거됩니다.';

  @override
  String get faq_report_user => '사용자나 목록을 어떻게 신고하나요?';

  @override
  String get faq_report_user_answer =>
      '목록이나 사용자 프로필에서 세 개의 점(•••)을 탭한 다음 \'신고\'를 선택하세요. 이유를 선택하고 제출하세요. 우리는 24~48시간 이내에 모든 보고서를 검토합니다.';

  @override
  String get faq_change_location => '내 위치를 어떻게 변경하나요?';

  @override
  String get faq_change_location_answer =>
      '홈 화면 왼쪽 상단에 있는 위치 버튼을 탭하세요. 지역과 구역을 선택하면 해당 지역의 목록을 볼 수 있습니다.';

  @override
  String get welcome_customer_center => '고객센터에 오신 것을 환영합니다';

  @override
  String get customer_center_subtitle => '우리는 연중무휴로 당신을 도와드립니다.';

  @override
  String get quick_actions => '빠른 작업';

  @override
  String get live_chat => '라이브 채팅';

  @override
  String get chat_with_us => '우리와 채팅';

  @override
  String get find_answers => '답변 찾기';

  @override
  String get my_tickets => '내 티켓';

  @override
  String get view_tickets => '티켓 보기';

  @override
  String get feedback => '피드백';

  @override
  String get share_feedback => '피드백 공유';

  @override
  String get contact_methods => '연락 방법';

  @override
  String get phone_support => '전화 지원';

  @override
  String get available_247 => '연중무휴 24시간 이용 가능';

  @override
  String get response_24h => '24시간 이내 응답';

  @override
  String get telegram_support => '전보 지원';

  @override
  String get instant_replies => '즉시 답장';

  @override
  String get whatsapp_support => 'WhatsApp 지원';

  @override
  String get quick_response => '빠른 응답';

  @override
  String get popular_topics => '인기 주제';

  @override
  String get account_management => '계정 관리';

  @override
  String get reset_password => '비밀번호 재설정';

  @override
  String get update_profile => '프로필 업데이트';

  @override
  String get verify_account => '계정 확인';

  @override
  String get delete_account => '계정 삭제';

  @override
  String get buying_selling => '구매 및 판매';

  @override
  String get how_to_post => '광고 게시 방법';

  @override
  String get payment_methods => '결제 방법';

  @override
  String get shipping_delivery => '배송 및 배송';

  @override
  String get return_policy => '반품 정책';

  @override
  String get safety_security => '안전 및 보안';

  @override
  String get report_scam => '사기 신고';

  @override
  String get safe_trading => '안전한 거래 팁';

  @override
  String get privacy_settings => '개인정보 설정';

  @override
  String get blocked_users => '차단된 사용자';

  @override
  String get technical_issues => '기술적인 문제';

  @override
  String get app_not_working => '앱이 작동하지 않음';

  @override
  String get upload_failed => '업로드 실패';

  @override
  String get login_problems => '로그인 문제';

  @override
  String get support_hours => '지원시간';

  @override
  String get mon_fri_9_6 => '월~금: 오전 9시~오후 6시';

  @override
  String get how_are_we_doing => '우리는 어떻게 지내나요?';

  @override
  String get rate_experience => '고객 서비스 경험을 평가해 주세요';

  @override
  String get poor => '가난한';

  @override
  String get okay => '좋아요';

  @override
  String get good => '좋은';

  @override
  String get excellent => '훌륭한';

  @override
  String get account_secure => '귀하의 계정은 안전합니다';

  @override
  String get password_security => '비밀번호 및 인증';

  @override
  String get change_password => '비밀번호 변경';

  @override
  String get two_factor_auth => '2단계 인증';

  @override
  String get biometric_login => '생체인식 로그인';

  @override
  String get login_activity => '로그인 활동';

  @override
  String get active_sessions => '활성 세션';

  @override
  String get login_alerts => '로그인 알림';

  @override
  String get account_protection => '계정 보호';

  @override
  String get recovery_email => '복구 이메일';

  @override
  String get backup_codes => '백업 코드';

  @override
  String get danger_zone => '위험지대';

  @override
  String get improve_security => '보안 향상';

  @override
  String get security_score => '보안 점수';

  @override
  String get last_changed_days => '30일 전에 마지막으로 변경되었습니다.';

  @override
  String get logout_all_devices => '모든 기기에서 로그아웃';

  @override
  String get end_all_sessions => '모든 세션 종료';

  @override
  String get permanently_delete => '영구 삭제';

  @override
  String get verification_code_message => '본인 확인을 위해 인증 코드를 보내드립니다.';

  @override
  String get send_code => '코드 보내기';

  @override
  String get enter_verification_code => '인증코드를 입력하세요';

  @override
  String get verification_code => '인증코드';

  @override
  String get new_password => '새 비밀번호';

  @override
  String get confirm_password => '비밀번호 확인';

  @override
  String get resend_code => '코드 재전송';

  @override
  String get code_sent_to => '으로 전송된 인증번호를 입력하세요.';

  @override
  String get enter_code => '인증코드를 입력하세요';

  @override
  String get code_must_be_6_digits => '코드는 6자리여야 합니다.';

  @override
  String get enter_new_password => '새 비밀번호를 입력하세요';

  @override
  String get minimum_8_characters => '최소 8자';

  @override
  String get passwords_do_not_match => '비밀번호가 일치하지 않습니다.';

  @override
  String get close => '닫다';

  @override
  String get current => '현재의';

  @override
  String get session_ended => '세션이 종료되었습니다.';

  @override
  String get update_recovery_email => '복구 이메일 업데이트';

  @override
  String get new_email => '새 이메일';

  @override
  String get update => '업데이트';

  @override
  String get verification_email_sent => '확인 이메일이 전송되었습니다.';

  @override
  String get generate_emergency_codes => '긴급 코드 생성';

  @override
  String get copy_all => '모두 복사';

  @override
  String get code_copied => '코드가 복사되었습니다.';

  @override
  String get all_codes_copied => '모든 코드가 복사되었습니다.';

  @override
  String get logout_all_devices_confirm => '모든 기기에서 로그아웃하시겠습니까?';

  @override
  String get logout_all_devices_message => '그러면 모든 장치의 모든 활성 세션이 종료됩니다.';

  @override
  String get logout_all => '모두 로그아웃';

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
  String get delete_account_confirm => '계정을 삭제하시겠습니까?';

  @override
  String get delete_account_warning =>
      '이 작업은 영구적이며 취소할 수 없습니다. 모든 데이터가 영구적으로 삭제됩니다.';

  @override
  String get what_will_be_deleted => '삭제될 내용:';

  @override
  String get profile_and_account_info => '• 귀하의 프로필 및 계정 정보';

  @override
  String get all_listings_and_posts => '• 모든 목록 및 게시물';

  @override
  String get messages_and_conversations => '메시지';

  @override
  String get saved_items_and_preferences => '• 저장된 항목 및 환경설정';

  @override
  String get enter_password_to_continue => '계속하려면 비밀번호를 입력하세요';

  @override
  String get continue_val => '계속하다';

  @override
  String get please_enter_password => '비밀번호를 입력해주세요';

  @override
  String get enter_confirmation_code => '확인 코드를 입력하세요';

  @override
  String get deletion_confirmation_message =>
      '귀하의 휴대폰으로 확인 코드가 전송되었습니다. 계정을 영구적으로 삭제하려면 아래에 입력하세요.';

  @override
  String get confirmation_code => '확인 코드';

  @override
  String get please_enter_6_digit_code => '6자리 코드를 입력해주세요';

  @override
  String get account_deleted => '귀하의 계정이 삭제되었습니다';

  @override
  String get deletion_cancelled => '삭제가 취소되었습니다.';

  @override
  String get failed_to_load_user_info => '사용자 정보를 로드하지 못했습니다.';

  @override
  String get auth_login_to_view_saved => '저장된 속성을 보려면 로그인하세요.';

  @override
  String get authLoginRequired => '로그인 필요';

  @override
  String get authLoginToViewSaved => '저장된 속성을 보려면 로그인하세요.';

  @override
  String get authLogin => '로그인';

  @override
  String get savedPropertiesTitle => '저장된 속성';

  @override
  String get loadingSavedProperties => '저장된 속성 로드 중...';

  @override
  String get errorsFailedToLoadSaved => '저장된 속성을 로드하지 못했습니다.';

  @override
  String get actionsRetry => '다시 해 보다';

  @override
  String get savedPropertiesNoSaved => '저장된 속성 없음';

  @override
  String get savedPropertiesStartSaving => '탐색을 시작하고 마음에 드는 부동산을 저장하세요';

  @override
  String get savedPropertiesBrowse => '속성 찾아보기';

  @override
  String get resultsSavedProperties => '저장된 속성';

  @override
  String get actionsRefresh => '새로 고치다';

  @override
  String get resultsNoMoreProperties => '더 이상 속성이 없습니다.';

  @override
  String get propertyCardFeatured => '추천';

  @override
  String get successPropertyUnsaved => '저장된 목록에서 속성이 제거되었습니다.';

  @override
  String get alertsUnsavePropertyFailed => '속성을 제거하지 못했습니다.';

  @override
  String get propertyCardBed => '침대';

  @override
  String get propertyCardBath => '욕조';

  @override
  String get savedPropertiesSavedOn => '저장 날짜';

  @override
  String get propertyCardViewDetails => '세부정보 보기';

  @override
  String get serviceDetailTitle => '서비스 내용';

  @override
  String get errorLoadingFavorites => '즐겨찾는 항목을 로드하는 중에 오류가 발생했습니다.';

  @override
  String get noFavoritesFound => '즐겨찾는 항목이 없습니다.';

  @override
  String get commentUpdatedSuccess => '댓글이 업데이트되었습니다.';

  @override
  String get errorUpdatingComment => '댓글을 업데이트하는 중에 오류가 발생했습니다.';

  @override
  String get replyAddedSuccess => '답글이 추가되었습니다!';

  @override
  String get errorAddingReply => '답글을 추가하는 중에 오류가 발생했습니다.';

  @override
  String get commentDeletedSuccess => '댓글이 삭제되었습니다.';

  @override
  String get errorDeletingComment => '댓글을 삭제하는 중에 오류가 발생했습니다.';

  @override
  String get serviceLikedSuccess => '서비스가 성공적으로 좋아요를 받았습니다!';

  @override
  String get errorLikingService => '서비스를 좋아하는 중에 오류가 발생했습니다.';

  @override
  String get serviceDislikedSuccess => '서비스가 성공적으로 싫어요되었습니다!';

  @override
  String get errorDislikingService => '서비스를 싫어하는 중에 오류가 발생했습니다.';

  @override
  String get writeYourReply => '답장을 쓰세요...';

  @override
  String get postReply => '답글 게시';

  @override
  String get anonymous => '익명의';

  @override
  String get editComment => '댓글 편집';

  @override
  String get editYourComment => '댓글을 수정하세요...';

  @override
  String get saveChanges => '변경 사항 저장';

  @override
  String get propertyOwner => '부동산 소유자';

  @override
  String get errorLoadingServices => '서비스를 로드하는 중에 오류가 발생했습니다.';

  @override
  String get noRecommendedServicesFound => '추천 서비스를 찾을 수 없습니다.';

  @override
  String get passwordRequired => '비밀번호가 필요합니다';

  @override
  String get passwordTooShort => '비밀번호는 8자 이상이어야 합니다.';

  @override
  String get passwordRequirements => '비밀번호는 문자와 숫자를 포함해야 합니다';

  @override
  String get usernameRequired => '사용자 이름이 필요합니다';

  @override
  String get usernameTooShort => '사용자 이름은 3자 이상이어야 합니다.';

  @override
  String get confirmPasswordRequired => '비밀번호 확인이 필요합니다';

  @override
  String get passwordHelp => '영문, 숫자, 영문 8자 이상';

  @override
  String get usernameExists => '이 사용자 이름은 이미 존재합니다.';

  @override
  String get phoneExists => '이 전화번호는 이미 등록되어 있습니다.';

  @override
  String get networkError => '네트워크 연결 오류입니다. 연결을 확인해주세요';

  @override
  String get contactSeller => '판매자에게 문의';

  @override
  String get callToReveal => '공개하려면 \'통화\'를 탭하세요.';

  @override
  String get camera => '카메라';

  @override
  String get gallery => '갱도';

  @override
  String get selectImageSource => '이미지 소스 선택';

  @override
  String get uploading => '업로드 중...';

  @override
  String get acceptTermsRequired => '계속하려면 이용약관에 동의해야 합니다.';

  @override
  String get iAgreeToTerms => '나는 다음에 동의한다.';

  @override
  String get termsAndConditions => '이용약관';

  @override
  String get zeroToleranceStatement =>
      '불쾌한 콘텐츠나 악의적인 사용자에 대한 무관용 원칙이 있음을 이해합니다.';

  @override
  String get viewTerms => '이용약관 보기';

  @override
  String get reportContent => '신고 내용';

  @override
  String get selectReportReason => '신고 사유를 선택해 주세요.';

  @override
  String get additionalDetails => '추가 세부정보(선택사항)';

  @override
  String get reportDetailsHint => '추가 정보를 제공하세요...';

  @override
  String get reportSubmitted => '신고해 주셔서 감사합니다. 24시간 이내에 검토해 드리겠습니다.';

  @override
  String get reportProduct => '제품신고';

  @override
  String get reportService => '신고 서비스';

  @override
  String get reportMessage => '메시지 신고';

  @override
  String get reportUser => '사용자 신고';

  @override
  String get reportErrorNotImplemented =>
      '보고 기능은 아직 사용할 수 없습니다. 지원팀에 문의하거나 나중에 다시 시도하세요.';

  @override
  String get reportAlreadySubmitted =>
      '이 콘텐츠를 이미 신고하셨습니다. 귀하의 이전 보고서를 검토 중입니다.';

  @override
  String get reportFailedGeneric => '보고서를 제출하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get reportFailedNetwork => '네트워크 오류가 발생했습니다. 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get becomeAgentTitle => '부동산 중개인으로 가입';

  @override
  String get becomeAgentSubtitle =>
      '부동산 목록을 작성하고 고객이 꿈에 그리던 집을 찾을 수 있도록 도와주세요.';

  @override
  String get agentBenefits => '이익:';

  @override
  String get agentBenefitVerified => '인증된 상담원 배지';

  @override
  String get agentBenefitAnalytics => '분석 및 통찰력에 대한 액세스';

  @override
  String get agentBenefitClients => '잠재 고객과 직접 접촉';

  @override
  String get agentBenefitReputation => '전문적인 평판을 구축하세요';

  @override
  String get agentApplicationForm => '신청서';

  @override
  String get agentAgencyName => '대행사 이름';

  @override
  String get agentAgencyNameHint => '부동산 중개소 이름을 입력하세요.';

  @override
  String get agentAgencyNameRequired => '대행사 이름이 필요합니다.';

  @override
  String get agentLicenceNumber => '라이센스 번호';

  @override
  String get agentLicenceNumberHint => '부동산 등록번호를 입력하세요';

  @override
  String get agentLicenceNumberRequired => '라이센스 번호가 필요합니다';

  @override
  String get agentYearsExperience => '수년간의 경험';

  @override
  String get agentYearsExperienceHint => '연수를 입력하세요.';

  @override
  String get agentYearsExperienceRequired => '다년간의 경험이 필요합니다';

  @override
  String get agentYearsExperienceInvalid => '유효한 숫자를 입력하세요.';

  @override
  String get agentSpecialization => '전문화';

  @override
  String get agentApplicationNote =>
      '귀하의 신청서는 우리 팀에서 검토됩니다. 신청서가 승인되면 알림을 받게 됩니다.';

  @override
  String get agentSubmitApplication => '신청서 제출';

  @override
  String get agentApplicationSubmitted => '신청서가 성공적으로 제출되었습니다! 곧 검토하겠습니다.';

  @override
  String get agentApplicationStatus => '신청현황';

  @override
  String get agentViewProfile => '상담원 프로필 보기';

  @override
  String get agentDashboardComingSoon => '에이전트 대시보드가 ​​곧 제공됩니다!';

  @override
  String get property_create_basic_information => '기본정보';

  @override
  String get property_create_property_title => '부동산 제목 *';

  @override
  String get property_create_property_title_hint => '예: 도심에 위치한 현대적인 침실 3개 아파트';

  @override
  String get property_create_property_title_required => '부동산 명칭을 입력해주세요';

  @override
  String get property_create_description => '설명 *';

  @override
  String get property_create_description_hint => '귀하의 재산을 자세히 설명하십시오 ...';

  @override
  String get property_create_description_required => '설명을 입력해주세요';

  @override
  String get property_create_property_type => '부동산 유형';

  @override
  String get property_create_property_type_required => '부동산 유형 *';

  @override
  String get property_create_listing_type_required => '목록 유형 *';

  @override
  String get property_create_pricing => '가격';

  @override
  String get property_create_price => '가격 *';

  @override
  String get property_create_price_hint => '가격을 입력하세요';

  @override
  String get property_create_price_required => '가격을 입력해주세요';

  @override
  String get property_create_currency => '통화';

  @override
  String get property_create_property_details => '부동산 세부정보';

  @override
  String get property_create_square_meters => '평방 미터 *';

  @override
  String get property_create_bedrooms => '침실 *';

  @override
  String get property_create_bathrooms => '욕실 *';

  @override
  String get property_create_floor => '바닥';

  @override
  String get property_create_total_floors => '총층수';

  @override
  String get property_create_parking => '주차';

  @override
  String get property_create_year_built => '건축연도';

  @override
  String get property_create_location => '위치';

  @override
  String get property_create_address => '주소 *';

  @override
  String get property_create_address_hint => '부동산 주소를 입력하세요';

  @override
  String get property_create_address_required => '주소를 입력해주세요';

  @override
  String get property_create_location_detected => '위치 감지됨';

  @override
  String get property_create_get_location => '현재 위치 가져오기';

  @override
  String get property_create_features => '특징';

  @override
  String get property_create_feature_balcony => '발코니';

  @override
  String get property_create_feature_garage => '차고';

  @override
  String get property_create_feature_garden => '정원';

  @override
  String get property_create_feature_pool => '수영장';

  @override
  String get property_create_feature_elevator => '엘리베이터';

  @override
  String get property_create_feature_furnished => '가구';

  @override
  String get property_create_images => '부동산 이미지';

  @override
  String get property_create_tap_to_add_images => '이미지를 추가하려면 탭하세요.';

  @override
  String get property_create_at_least_one_image => '이미지가 1개 이상 필요합니다.';

  @override
  String get property_create_add_more => '더 추가';

  @override
  String get property_create_required => '필수의';

  @override
  String get property_create_location_required => '속성을 만들려면 위치 서비스를 활성화하세요.';

  @override
  String get property_create_image_required => '속성 이미지가 하나 이상 필요합니다.';

  @override
  String get emailVerification => '이메일 확인';

  @override
  String get pleaseEnterYourEmailAddress => '이메일 주소를 입력해주세요';

  @override
  String get enterEmailAddress => '이메일 주소를 입력하세요';

  @override
  String get resetYourPassword => '비밀번호 재설정';

  @override
  String get resetPasswordDescription =>
      '이메일 주소를 입력하시면 비밀번호 재설정을 위한 인증코드를 보내드립니다.';

  @override
  String get sendVerificationCode => '인증코드 보내기';

  @override
  String get backToLogin => '로그인으로 돌아가기';

  @override
  String get resetPassword => '비밀번호 재설정';

  @override
  String enterVerificationCodeSentTo(String email) {
    return '$email으로 전송된 인증 코드를 입력하세요.';
  }

  @override
  String get codeMustBe6Digits => '코드는 6자리여야 합니다.';

  @override
  String get enterNewPassword => '새 비밀번호를 입력하세요';

  @override
  String get minimum8Characters => '최소 8자';

  @override
  String get sending => '배상...';

  @override
  String get verifying => '확인 중...';

  @override
  String get new_message => '새 메시지';

  @override
  String get messages => '메시지';

  @override
  String get please_log_in => '메시지를 보려면 로그인하세요.';

  @override
  String get pin => '핀';

  @override
  String get unpin => '고정 해제';

  @override
  String get delete_chat => '채팅 삭제';

  @override
  String delete_chat_confirm(String name) {
    return '정말로 $name님과의 채팅을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';
  }

  @override
  String chat_deleted(String name) {
    return '$name님과의 채팅이 삭제되었습니다.';
  }

  @override
  String get delete_failed => '채팅을 삭제하지 못했습니다.';

  @override
  String get no_conversations => '아직 대화가 없습니다.';

  @override
  String get start_conversation_hint => '+ 버튼을 눌러 대화를 시작하세요';

  @override
  String get start_conversation => '대화 시작';

  @override
  String get yesterday => '어제';

  @override
  String get unknown => '알려지지 않은';

  @override
  String get no_messages_yet => '아직 메시지가 없습니다';

  @override
  String get unblock_user => '사용자 차단 해제';

  @override
  String get block_user => '사용자 차단';

  @override
  String get no_blocked_users => '차단된 사용자 없음';

  @override
  String get blocked_users_hint => '차단한 사용자가 여기에 표시됩니다.';

  @override
  String unblock_user_confirm(String username) {
    return '$username 차단을 해제하시겠습니까? 해당 사용자로부터 메시지를 다시 받을 수 있습니다.';
  }

  @override
  String user_unblocked(String username) {
    return '$username이(가) 차단 해제되었습니다';
  }

  @override
  String user_blocked(String username) {
    return '$username이(가) 차단되었습니다';
  }

  @override
  String get failed_to_unblock => '사용자 차단을 해제하지 못했습니다.';

  @override
  String get failed_to_block => '사용자를 차단하지 못했습니다.';

  @override
  String get chat_info => '채팅 정보';

  @override
  String get delete_message => '메시지 삭제';

  @override
  String get delete_message_confirm => '이 메시지를 삭제하시겠습니까?';

  @override
  String get typing => '타자...';

  @override
  String get online => '온라인';

  @override
  String get offline => '오프라인';

  @override
  String last_seen_at(String time) {
    return '마지막으로 본 $time';
  }

  @override
  String participants(int count) {
    return '$count 참가자';
  }

  @override
  String get you_are_blocked => '당신은 차단되었습니다';

  @override
  String user_blocked_you(String username) {
    return '$username님이 당신을 차단했습니다. 메시지를 보낼 수 없습니다.';
  }

  @override
  String you_blocked_user(String username) {
    return '$username을(를) 차단했습니다.';
  }

  @override
  String get cannot_send_messages_blocked => '메시지를 보낼 수 없습니다. 당신은 차단되었습니다.';

  @override
  String get this_message_was_deleted => '이 메시지는 삭제되었습니다';

  @override
  String get edit => '편집하다';

  @override
  String get reply => '회신하다';

  @override
  String get editing_message => '메시지 편집 중';

  @override
  String replying_to(String username) {
    return '$username에 답장';
  }

  @override
  String get voice => '목소리';

  @override
  String get emoji => '이모티콘';

  @override
  String get photo => '📷 사진';

  @override
  String get voice_message => '🎤 음성 메시지';

  @override
  String get searching => '수색...';

  @override
  String get loading_users => '사용자 로드 중...';

  @override
  String search_failed(String error) {
    return '검색 실패: $error';
  }

  @override
  String get invalid_user_data => '잘못된 사용자 데이터';

  @override
  String failed_to_start_chat(String error) {
    return '채팅을 시작하지 못했습니다: $error';
  }

  @override
  String get audio_file_not_available => '오디오 파일을 사용할 수 없습니다.';

  @override
  String failed_to_play_audio(String error) {
    return '오디오 재생 실패: $error';
  }

  @override
  String get image_unavailable => '이미지를 사용할 수 없습니다.';

  @override
  String get image_too_large => '❌ 이미지가 너무 큽니다. 최대 크기는 10MB입니다.';

  @override
  String get image_file_not_found => '❌ 이미지 파일을 찾을 수 없습니다';

  @override
  String get uploading_image => '이미지 업로드 중...';

  @override
  String get image_sent => '✅ 이미지가 전송되었습니다!';

  @override
  String get failed_to_send_image => '❌ 이미지 전송 실패';

  @override
  String get uploading_voice_message => '음성 메시지 업로드 중...';

  @override
  String get voice_message_sent => '✅ 음성 메시지가 전송되었습니다!';

  @override
  String get failed_to_send_voice_message => '❌ 음성 메시지 전송 실패';

  @override
  String get recording => '🎙️ 녹음 중...';

  @override
  String get microphone_permission_denied => '마이크 권한이 거부되었습니다.';

  @override
  String get starting_chat => '채팅 시작 중...';

  @override
  String get refresh_users => '사용자 새로 고침';

  @override
  String get search_by_username_or_phone => '사용자 이름 또는 전화번호로 검색';

  @override
  String get no_users_found => '사용자를 찾을 수 없습니다.';

  @override
  String get try_different_search_term => '다른 검색어를 사용해 보세요.';

  @override
  String get no_users_available => '사용 가능한 사용자가 없습니다.';

  @override
  String get chat_exists => '채팅이 존재합니다';

  @override
  String block_user_confirm(String username) {
    return '$username을(를) 차단하시겠습니까? 귀하는 그 사람으로부터 메시지를 받지 않으며 그 사람은 귀하의 채팅 목록에서 제거됩니다.';
  }

  @override
  String chat_room_label(String name) {
    return '채팅방: $name';
  }

  @override
  String id_label(int id) {
    return 'ID: $id';
  }

  @override
  String get participants_label => '참가자들:';

  @override
  String get type_a_message => '메시지를 입력하세요...';

  @override
  String get edit_message_hint => '메시지 수정...';

  @override
  String error_label(String error) {
    return '오류: $error';
  }

  @override
  String get copy => '복사';

  @override
  String comments_title(int count) {
    return '댓글($count)';
  }

  @override
  String get reply_button => '회신하다';

  @override
  String replies_count(int count) {
    return '$count 답글';
  }

  @override
  String get you_label => '너';

  @override
  String get delete_reply_title => '답글 삭제';

  @override
  String get delete_comment_title => '댓글 삭제';

  @override
  String get unknown_date => '알 수 없는 날짜';

  @override
  String get press_enter_to_send => 'Enter를 눌러 보내세요';

  @override
  String get comment_add_error => '댓글을 추가하지 못했습니다.';

  @override
  String get service_provider => '서비스 제공자';

  @override
  String get opening_chat => '채팅을 여는 중...';

  @override
  String get failed_to_refresh => '새로고침하지 못했습니다.';

  @override
  String get cannot_chat_with_yourself => '자신과 채팅할 수 없습니다.';

  @override
  String opening_chat_with(String username) {
    return '$username 님과의 채팅 시작 중...';
  }

  @override
  String get this_will_only_take_a_moment => '이 작업은 잠시만 소요됩니다.';

  @override
  String get unable_to_start_chat => '채팅을 시작할 수 없습니다. 다시 시도해 주세요.';

  @override
  String get profile_listings => '목록';

  @override
  String get profile_followers => '추종자';

  @override
  String get profile_following => '수행원';

  @override
  String get profile_no_products => '제품 없음';

  @override
  String get profile_no_services => '서비스 없음';

  @override
  String get profile_no_properties => '속성 없음';

  @override
  String get profile_user_no_products => '이 사용자는 아직 제품을 게시하지 않았습니다.';

  @override
  String get profile_user_no_services => '이 사용자는 아직 서비스를 게시하지 않았습니다.';

  @override
  String get profile_user_no_properties => '이 사용자는 아직 속성을 게시하지 않았습니다.';

  @override
  String get profile_error_occurred => '오류가 발생했습니다';

  @override
  String get profile_error_loading_products => '제품을 로드하는 중에 오류가 발생했습니다.';

  @override
  String get profile_error_loading_services => '서비스를 로드하는 중에 오류가 발생했습니다.';

  @override
  String get profile_no_followers_yet => '아직 팔로어가 없습니다.';

  @override
  String get profile_no_following_yet => '아직 팔로우하는 사람이 없습니다.';

  @override
  String get profile_follow => '따르다';

  @override
  String get profile_following_btn => '수행원';

  @override
  String get profile_message => '메시지';

  @override
  String get profile_member_since => '이후 회원';

  @override
  String get profile_loading_error => '프로필을 로드하는 중에 오류가 발생했습니다.';

  @override
  String get profile_retry => '다시 시도하세요';

  @override
  String get profile_share => '공유하다';

  @override
  String get profile_copy_link => '링크 복사';

  @override
  String get profile_report => '보고서';

  @override
  String get linkCopied => '링크가 클립보드에 복사되었습니다.';

  @override
  String get checkOutProfile => '확인해 보세요';

  @override
  String get onTezsell => 'TezSell에서';

  @override
  String get selectCountryFirst => '먼저 국가를 선택하세요';

  @override
  String get countrySelectionHint => '그러면 지역을 선택하시면 됩니다';

  @override
  String get something_went_wrong => '문제가 발생했습니다.';

  @override
  String get check_connection_and_retry => '인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get sold_badge => '판매된';

  @override
  String get reserved_badge => 'RESERVED';

  @override
  String get recently_viewed_title => 'Recently viewed';

  @override
  String get more_categories => '더';

  @override
  String no_products_in_location(String location) {
    return '$location에 제품이 없습니다.';
  }

  @override
  String get no_more_products => '더 이상 로드할 제품이 없습니다.';

  @override
  String time_days_ago(int count) {
    return '${count}d 전';
  }

  @override
  String time_hours_ago(int count) {
    return '$count시간 전';
  }

  @override
  String time_minutes_ago(int count) {
    return '$count분 전';
  }

  @override
  String get time_just_now => '방금';

  @override
  String no_services_in_location(String location) {
    return '$location에서 서비스를 찾을 수 없습니다.';
  }

  @override
  String get no_more_services => '더 이상 로드할 서비스가 없습니다.';

  @override
  String get error_loading_more_services => '추가 서비스를 로드하는 중에 오류가 발생했습니다.';

  @override
  String get verification_code_length => '인증 코드는 6자리여야 합니다.';

  @override
  String get map_register_title => '어디 살아요?';

  @override
  String get map_register_headline => '지도에서 당신의 동네를 선택하세요';

  @override
  String get map_register_subtitle =>
      '근처의 구매자와 판매자를 보여주기 위해 사용합니다. 나중에 반경을 조정할 수 있습니다.';

  @override
  String get pick_on_map => '지도에서 선택';

  @override
  String get pick_again => '다시 선택';

  @override
  String get resolving_location => '위치 확인 중…';

  @override
  String get use_dropdown_instead => '대신 드롭다운을 사용하세요';

  @override
  String country_not_supported(String country) {
    return '아직 $country은 지원되지 않습니다.';
  }

  @override
  String get region_not_auto_detected => '지역을 자동 감지할 수 없습니다. 수동으로 선택하세요.';

  @override
  String get district_not_auto_detected => '지역을 자동 감지할 수 없습니다. 수동으로 선택하세요.';

  @override
  String get browse_no_items_with_location => '이 지역에는 아직 위치 데이터가 포함된 항목이 없습니다.';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => '위치 설정';

  @override
  String get location_picker_confirm => '위치 확인';

  @override
  String get location_picker_resolve_failed =>
      '주소를 확인할 수 없습니다. 다시 선택하거나 좌표로만 확인하세요.';

  @override
  String get location_picker_selected_fallback => '선택한 위치';

  @override
  String get location_permission_denied => '위치 권한이 거부되었습니다.';

  @override
  String get location_permission_denied_settings =>
      '위치 권한이 거부되었습니다. 설정에서 활성화하세요.';

  @override
  String get location_permission_permanent =>
      '위치가 영구적으로 거부되었습니다. 설정을 열어 활성화하세요.';

  @override
  String gps_error(String error) {
    return 'GPS 오류: $error';
  }

  @override
  String get verify_neighborhood_title => '주변 지역을 인증하세요';

  @override
  String get verify_neighborhood_subtitle =>
      '당신의 이웃에 서십시오. GPS를 확인하고 확인을 요청하겠습니다.';

  @override
  String get verify_neighborhood_button => '이웃 확인';

  @override
  String get verify_neighborhood_low_confidence => '낮은 신뢰도로 계속';

  @override
  String get verify_neighborhood_retry => '다시 해 보다';

  @override
  String get verify_neighborhood_youre_in => '현재 위치:';

  @override
  String verify_neighborhood_done(String name) {
    return '확인되었습니다! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'GPS 정확도는 ${meters}m입니다(100m 이하 필요). 열린 공간으로 이동한 후 다시 시도하세요.';
  }

  @override
  String get neighborhood_not_identified => '현재 위치에 해당하는 동네를 식별할 수 없습니다.';

  @override
  String get unknown_error => '알 수 없는 오류';

  @override
  String get place_search_hint => '주소 또는 장소 검색';

  @override
  String get place_search_unavailable => '검색할 수 없음 — 대신 핀을 고정하세요';

  @override
  String get radius_slider_city => '도시';

  @override
  String radius_slider_km(String value) {
    return '${value}km';
  }

  @override
  String get my_neighborhoods => '내 동네';

  @override
  String get manage_on_map => '지도에서 관리';

  @override
  String get no_neighborhoods_yet => '아직 인증된 동네가 없습니다. 지도를 열어 현재 위치를 인증하세요.';

  @override
  String get open_map_to_verify => '지도 열어 새 위치 인증';

  @override
  String get verify_here => '여기서 인증';

  @override
  String get verify_new_location => '새 위치 인증';

  @override
  String eviction_warning(String name) {
    return '이 위치를 추가하면 $name(가장 오래된 동네)이 삭제됩니다. 이 작업은 취소할 수 없습니다.';
  }

  @override
  String get verified_today => '오늘 인증됨';

  @override
  String get verified_yesterday => '어제 인증됨';

  @override
  String verified_n_days_ago(int days) {
    return '$days일 전 인증됨';
  }

  @override
  String get active_neighborhood => '활성';

  @override
  String switch_neighborhood_success(String name) {
    return '$name(으)로 전환되었습니다';
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
}
