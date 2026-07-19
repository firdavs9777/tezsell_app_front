// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get welcome => '欢迎';

  @override
  String get welcomeBack => '欢迎回来！';

  @override
  String get loginToYourAccount => '登录以继续';

  @override
  String get or => '或者';

  @override
  String get dontHaveAccount => '没有帐户？';

  @override
  String get chooseLanguage => '选择您的语言';

  @override
  String get selectPreferredLanguage => '选择您的应用程序首选语言';

  @override
  String get continueButton => '继续';

  @override
  String get continueWithGoogle => '继续使用谷歌';

  @override
  String get continueWithApple => '继续使用苹果';

  @override
  String get continueWithEmail => '继续使用电子邮件';

  @override
  String get sellAndBuyProducts => '仅通过我们销售和购买您的任何产品';

  @override
  String get usedProductsMarket => '二手产品或二手市场';

  @override
  String get home_welcome_title => '您附近的市场';

  @override
  String get home_welcome_subtitle => '与附近的人一起买卖。\n安全、简单、本地化。';

  @override
  String get home_get_started => '开始使用';

  @override
  String get home_sign_in => '我已经有一个帐户';

  @override
  String get home_terms_notice => '继续即表示您同意我们的服务条款和隐私政策';

  @override
  String get register => '登记';

  @override
  String get alreadyHaveAccount => '已有账户';

  @override
  String get login => '登录';

  @override
  String get loginToAccount => '登录帐户';

  @override
  String get enterPhoneNumber => '输入电话号码';

  @override
  String get password => '密码';

  @override
  String get enterPassword => '输入密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get registerNow => '立即注册';

  @override
  String get loading => '加载中...';

  @override
  String get pleaseEnterPhoneNumber => '请输入您的电话号码';

  @override
  String get pleaseEnterPassword => '请输入您的密码';

  @override
  String get unexpectedError => '发生意外错误。请再试一次。';

  @override
  String get forgotPasswordComingSoon => '忘记密码功能即将推出';

  @override
  String get selectedCountryLabel => '已选择：';

  @override
  String get fullPhoneLabel => '满的：';

  @override
  String get home => '家';

  @override
  String get settings => '设置';

  @override
  String get profile => '轮廓';

  @override
  String get search => '搜索';

  @override
  String get notifications => '通知';

  @override
  String get error => '错误';

  @override
  String get retry => '重试';

  @override
  String get cancel => '取消';

  @override
  String get save => '节省';

  @override
  String get appTitle => '特泽尔';

  @override
  String get selectRegion => '请选择您所在的地区';

  @override
  String get searchHint => '搜索地区或城市';

  @override
  String get apiError => '调用API时出现问题';

  @override
  String get ok => '好的';

  @override
  String get emptyList => '空列表';

  @override
  String get dataLoadingError => '加载数据时出错';

  @override
  String get confirm => '确认';

  @override
  String get yes => '是的';

  @override
  String get no => '不';

  @override
  String confirmRegionSelection(Object regionName) {
    return '您要选择$regionName区域吗？';
  }

  @override
  String get selectDistrictOrCity => '请选择您所在的地区或城市';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return '您要选择 $regionName 区域 - $districtName 吗？';
  }

  @override
  String get noResultsFound => '没有找到结果。';

  @override
  String errorWithCode(String errorCode) {
    return '错误：$errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return '加载数据失败。错误：$error';
  }

  @override
  String get phoneVerification => '电话号码验证';

  @override
  String get enterPhonePrompt => '请输入您的电话号码';

  @override
  String get enterPhoneNumberHint => '输入电话号码';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return '已选择：$countryName ($countryCode)';
  }

  @override
  String get selectCountry => '选择您所在的国家/地区';

  @override
  String get changeCountry => '更改国家/地区';

  @override
  String get country => '国家';

  @override
  String get allCountries => '所有国家';

  @override
  String get currencyRUB => '俄罗斯卢布';

  @override
  String get currencyUAH => '乌克兰格里夫纳';

  @override
  String get currencyBYN => '白俄罗斯卢布';

  @override
  String get currencyMDL => '摩尔多瓦列伊';

  @override
  String get currencyGEL => '格鲁吉亚拉里';

  @override
  String get currencyAMD => '亚美尼亚德拉姆';

  @override
  String get currencyAZN => '阿塞拜疆马纳特';

  @override
  String get currencyKZT => '哈萨克斯坦坚戈';

  @override
  String get currencyTMT => '土库曼马纳特';

  @override
  String get currencyKGS => '吉尔吉斯斯坦索姆';

  @override
  String get currencyTJS => '塔吉克斯坦索莫尼';

  @override
  String get currencyUZS => '乌兹别克索姆';

  @override
  String get currencyUSD => '美元';

  @override
  String get currencyEUR => '欧元';

  @override
  String fullNumber(String phoneNumber) {
    return '完整号码：$phoneNumber';
  }

  @override
  String get sendCode => '发送代码';

  @override
  String get enterVerificationCode => '输入验证码';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => '重新发送代码';

  @override
  String expires(String time) {
    return '过期时间：$time';
  }

  @override
  String get verifyAndContinue => '验证并继续';

  @override
  String get invalidVerificationCode => '验证码无效';

  @override
  String get verificationCodeSent => '验证码发送成功';

  @override
  String get failedToSendCode => '发送验证码失败';

  @override
  String get verificationCodeResent => '验证码重新发送成功';

  @override
  String get failedToResendCode => '重新发送验证码失败';

  @override
  String get passwordVerification => '密码验证';

  @override
  String get completeRegistrationPrompt => '输入用户名和密码完成注册';

  @override
  String get username => '用户名';

  @override
  String get username_required => '用户名是必需的';

  @override
  String get username_min_length => '用户名必须至少有 2 个字符';

  @override
  String get usernameHint => '用户名123';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get profileImage => '个人资料图片';

  @override
  String get imageInstructions => '图片将出现在这里，请按个人资料图片';

  @override
  String get finish => '结束';

  @override
  String get passwordsDoNotMatch => '密码不匹配';

  @override
  String get registrationError => '注册错误';

  @override
  String get about => '关于我们';

  @override
  String get chat => '聊天';

  @override
  String get realEstate => '房地产';

  @override
  String get language => '英语';

  @override
  String get languageEn => '英语';

  @override
  String get languageRu => '俄语';

  @override
  String get languageUz => '乌兹别克语';

  @override
  String get serviceLiked => '服务很喜欢';

  @override
  String get support => '支持';

  @override
  String get service => '商业服务';

  @override
  String get aboutContent =>
      'TezSell 是一个快速、简单的市场，用于购买和销售新产品和二手产品。我们的使命是为每个用户创建最便捷、最高效的平台，确保交易顺畅和用户友好的体验。无论您是想出售还是购买，TezSell 都可以让您只需几个步骤即可轻松连接并完成交易。我们优先考虑用户的安全和隐私。所有交易都经过仔细监控，以确保安全性和合规性，让买家和卖家都安心。我们简单直观的界面允许用户快速列出产品并找到他们需要的东西。我们还通过 Telegram 促进实时沟通，使买卖过程更加顺畅。';

  @override
  String get errorMessage => '发生错误，请检查服务器';

  @override
  String get searchLocation => '地点';

  @override
  String get searchCategory => '类别';

  @override
  String get searchProductPlaceholder => '搜索产品';

  @override
  String get searchServicePlaceholder => '搜索服务';

  @override
  String get search_products_subtitle => '寻找您附近的超值优惠';

  @override
  String get search_services_subtitle => '寻找您附近的专业人士';

  @override
  String get search_products_error => '搜索产品时出错';

  @override
  String get search_services_error => '搜索服务时出错';

  @override
  String get load_more_products_error => '加载更多产品时出错';

  @override
  String get load_more_services_error => '加载更多服务时出错';

  @override
  String get try_different_keywords => '尝试不同的关键词';

  @override
  String get searchText => '搜索';

  @override
  String get selectedCategory => '所选类别：';

  @override
  String get selectedLocation => '选定地点：';

  @override
  String get productError => '没有可用的产品';

  @override
  String get serviceError => '无可用服务';

  @override
  String get locationHeader => '选择地点';

  @override
  String get locationPlaceholder => '在这里搜索区域';

  @override
  String get categoryHeader => '选择类别';

  @override
  String get categoryPlaceholder => '搜索类别';

  @override
  String get categoryError => '没有可用的类别';

  @override
  String get paginationFirst => '第一的';

  @override
  String get paginationPrevious => '以前的';

  @override
  String get pageInfo => '页数';

  @override
  String get pageNext => '下一个';

  @override
  String get pageLast => '最后的';

  @override
  String get loadingMessageProduct => '正在加载产品...';

  @override
  String get loadingMessageError => '加载时出错';

  @override
  String get likeProductError => '喜欢产品时发生错误';

  @override
  String get dislikeProductError => '不喜欢产品时发生错误';

  @override
  String get loadingMessageLocation => '加载位置...';

  @override
  String get loadingLocationError => '加载位置时出错';

  @override
  String get loadingMessageCategory => '正在加载类别...';

  @override
  String get loadingCategoryError => '加载类别时出错：';

  @override
  String get profileUpdateSuccessMessage => '个人资料更新成功';

  @override
  String get profileUpdateFailMessage => '更新个人资料失败';

  @override
  String get seeMoreBtn => '查看更多';

  @override
  String get profilePageTitle => '个人资料页';

  @override
  String get editProfileModalTitle => '编辑个人资料';

  @override
  String get usernameLabel => '用户名';

  @override
  String get locationLabel => '当前位置';

  @override
  String get profileImageLabel => '个人资料图片';

  @override
  String get chooseFileLabel => '选择一个文件';

  @override
  String get uploadBtnLabel => '更新';

  @override
  String get uploadingBtnLabel => '正在更新...';

  @override
  String get cancelBtnLabel => '取消';

  @override
  String get productsTitle => '产品';

  @override
  String get servicesTitle => '服务';

  @override
  String get myProductsTitle => '我的产品';

  @override
  String get myServicesTitle => '我的服务';

  @override
  String get favoriteProductsTitle => '最喜欢的产品';

  @override
  String get favoriteServicesTitle => '最喜欢的服务';

  @override
  String get noFavorites => '没有收藏夹';

  @override
  String get addNewProductBtn => '添加新产品';

  @override
  String get addNew => '新的';

  @override
  String get addNewServiceBtn => '添加新服务';

  @override
  String get downloadMobileApp => '下载移动应用程序';

  @override
  String get registerPhoneNumberSuccess => '电话号码已验证！您可以继续下一步。';

  @override
  String get regionSelectedMessage => '所选地区：';

  @override
  String get districtSelectMessage => '所选地区：';

  @override
  String get phoneNumberEmptyMessage => '请先验证您的电话号码，然后再继续';

  @override
  String get regionEmptyMessage => '请先选择地区';

  @override
  String get districtEmptyMessage => '请选择地区';

  @override
  String get usernamePasswordEmptyMessage => '请输入用户名和密码';

  @override
  String get registerTitle => '登记';

  @override
  String get previousButton => '以前的';

  @override
  String get nextButton => '下一个';

  @override
  String get completeButton => '完全的';

  @override
  String stepIndicator(int currentStep) {
    return '第 $currentStep 步（共 4 步）';
  }

  @override
  String get districtSelectTitle => '地区列表';

  @override
  String get districtSelectParagraph => '选择一个地区：';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get sendOtp => '发送一次性密码';

  @override
  String get sendAgain => '再次发送';

  @override
  String get verify => '核实';

  @override
  String get failedToSendOtp => '发送 OTP 失败。服务器返回错误。';

  @override
  String get errorSendingOtp => '发送 OTP 时发生错误。';

  @override
  String get invalidPhoneNumber => '请输入有效的电话号码。';

  @override
  String get verificationSuccess => '验证成功';

  @override
  String get verificationError => '发生错误。请稍后重试。';

  @override
  String get regionsList => '地区列表';

  @override
  String get enterUsername => '输入您的用户名';

  @override
  String get welcomeMessage => '欢迎来到 Tezsell，使用您的电话号码登录';

  @override
  String get noAccount => '还没有帐户？在此注册';

  @override
  String get successLogin => '登录成功';

  @override
  String get myProfile => '我的个人资料';

  @override
  String get logout => '注销';

  @override
  String get newProductTitle => '标题';

  @override
  String get newProductDescription => '描述';

  @override
  String get newProductPrice => '价格';

  @override
  String get newProductCondition => '健康）状况';

  @override
  String get newProductCategory => '类别';

  @override
  String get newProductImages => '图片';

  @override
  String get addNewService => '添加新服务';

  @override
  String get creating => '创造...';

  @override
  String get serviceName => '服务名称';

  @override
  String get serviceNamePlaceholder => '输入服务名称';

  @override
  String get serviceDescription => '服务说明';

  @override
  String get serviceDescriptionPlaceholder => '输入服务描述';

  @override
  String get serviceCategory => '服务类别';

  @override
  String get selectCategory => '选择类别';

  @override
  String get loadingCategories => '加载中...';

  @override
  String get errorLoadingCategories => '加载类别时出错';

  @override
  String get serviceImages => '服务图片';

  @override
  String get imageUploadHelper => '单击 + 图标添加图像（最多 10 个）';

  @override
  String get maxImagesError => '您最多可以上传 10 张图片';

  @override
  String get categoryNotFound => '未找到类别';

  @override
  String get productCreatedSuccess => '产品创建成功';

  @override
  String get productLikeSuccess => '产品喜欢成功';

  @override
  String get productDislikeSuccess => '产品成功被拒';

  @override
  String get errorCreatingService => '创建服务时出错';

  @override
  String get errorCreatingProduct => '创建产品时出错';

  @override
  String get unknownError => '创建服务时发生未知错误';

  @override
  String get submit => '提交';

  @override
  String get selectCategoryAction => '选择类别';

  @override
  String get selectCondition => '选择条件';

  @override
  String get sum => '和';

  @override
  String get noComments => '还没有评论。成为第一个发表评论的人！';

  @override
  String get commentLikeSuccess => '评论点赞成功';

  @override
  String get commentLikeError => '点赞评论时出错';

  @override
  String get unknownErrorMessage => '发生未知错误';

  @override
  String get commentDislikeSuccess => '评论点赞成功';

  @override
  String get commentDislikeError => '不喜欢评论时出错';

  @override
  String get replyInfo => '请先输入回复';

  @override
  String get replySuccessMessage => '回复添加成功';

  @override
  String get replyErrorMessage => '创建回复期间发生错误';

  @override
  String get commentUpdateSuccess => '评论更新成功';

  @override
  String get commentUpdateError => '更新评论项时出错';

  @override
  String get deleteConfirmationMessage => '您确定要删除此评论吗？';

  @override
  String get commentDeleteSuccess => '评论删除成功';

  @override
  String get commentDeleteError => '删除评论时出错';

  @override
  String get editLabel => '编辑';

  @override
  String get deleteLabel => '删除';

  @override
  String get saveLabel => '节省';

  @override
  String get replyLabel => '回复';

  @override
  String get replyTitle => '回复';

  @override
  String get replyPlaceholder => '写一个回复...';

  @override
  String get chatLoginMessage => '您必须登录才能开始聊天';

  @override
  String get chatYourselfMessage => '你无法与自己聊天。';

  @override
  String get chatRoomMessage => '聊天室创建！';

  @override
  String get chatRoomError => '创建聊天失败！';

  @override
  String get chatCreationError => '聊天创建失败！';

  @override
  String get productsTotal => '产品总数';

  @override
  String get perPage => '项目';

  @override
  String get clearAllFilters => '清除所有过滤器';

  @override
  String get clickToUpload => '点击上传';

  @override
  String get productInStock => '有存货';

  @override
  String get productOutStock => '缺货';

  @override
  String get productBack => '返回产品';

  @override
  String get messageSeller => '聊天';

  @override
  String get recommendedProducts => '推荐产品';

  @override
  String get deleteConfirmationProduct => '您确定要删除该产品吗？';

  @override
  String get productDeleteSuccess => '产品删除成功';

  @override
  String get productDeleteError => '删除产品时出错';

  @override
  String get newCondition => '新的';

  @override
  String get used => '用过的';

  @override
  String get imageValidType => '有些文件没有添加。请使用 5MB 以下的 JPG、PNG、GIF 或 WebP 文件。';

  @override
  String get imageConfirmMessage => '您确定要删除该图像吗？';

  @override
  String get titleRequiredMessage => '标题为必填项';

  @override
  String get descRequiredMessage => '描述为必填项';

  @override
  String get priceRequiredMessage => '价格为必填项';

  @override
  String get conditionRequiredMessage => '需要条件';

  @override
  String get pleaseFillAllRequired => '请填写必填字段';

  @override
  String get oneImageConfirmMessage => '至少需要一张产品图片';

  @override
  String get categoryRequiredMessage => '类别为必填项';

  @override
  String get locationInfoError => '用户位置信息缺失';

  @override
  String get editProductTitle => '编辑产品';

  @override
  String get imageUploadRequirements =>
      '至少需要一张图像。您最多可以上传 10 张图片（JPG、PNG、GIF、WebP，每张小于 5MB）。';

  @override
  String get productUpdatedSuccess => '产品更新成功';

  @override
  String get productUpdateFailed => '产品更新失败';

  @override
  String get errorUpdatingProduct => '更新产品时出错';

  @override
  String get serviceBack => '返回服务';

  @override
  String get likeLabel => '喜欢';

  @override
  String get commentsLabel => '评论';

  @override
  String get writeComment => '写评论...';

  @override
  String get postingLabel => '发布...';

  @override
  String get commentCreated => '评论已创建';

  @override
  String get postCommentLabel => '发表评论';

  @override
  String get loginPrompt => '请登录查看并发表评论。';

  @override
  String get recommendedServices => '推荐服务';

  @override
  String get commentsVisibilityNotice => '评论仅对登录用户可见。';

  @override
  String get comingSoon => '即将推出';

  @override
  String get serviceUpdateSuccess => '服务更新成功';

  @override
  String get serviceUpdateError => '更新服务项目时出错';

  @override
  String get editServiceModalTitle => '编辑服务';

  @override
  String get enterPhoneNumberWithoutCode => '输入不带密码的电话号码';

  @override
  String get heroTitle => '特兹塞尔';

  @override
  String get heroSubtitle => '您的乌兹别克斯坦快速便捷的市场';

  @override
  String get startSelling => '开始销售';

  @override
  String get browseProducts => '浏览产品';

  @override
  String get featuresTitle => '为什么选择 TezSell？';

  @override
  String get listingTitle => '简单的产品列表';

  @override
  String get listingDescription => '只需点击几下即可列出您的物品。添加照片、设置价格并立即与买家联系。';

  @override
  String get locationTitle => '基于位置的浏览';

  @override
  String get locationDescription => '查找您附近的优惠。我们的基于位置的系统可以帮助您发现附近的物品。';

  @override
  String get location_subtitle => '选择您所在的地区和地区以查看附近的列表';

  @override
  String get categoryTitle => '类别过滤';

  @override
  String get categoryDescription => '轻松浏览不同的类别，准确找到您想要的内容。';

  @override
  String get inspirationTitle => '受到韩国胡萝卜市场的启发';

  @override
  String get inspirationDescription1 =>
      '我们从韩国成功的胡萝卜市场 (당근마켓) 中汲取灵感，打造了 TezSell，但专门针对乌兹别克斯坦当地社区的独特需求进行了定制。';

  @override
  String get inspirationDescription2 => '我们的使命是创建一个值得信赖的平台，让邻居可以轻松地进行买卖和相互联系。';

  @override
  String get comingSoonTitle => '即将推出 TezSell';

  @override
  String get inAppChat => '应用内聊天';

  @override
  String get secureTransactions => '安全交易';

  @override
  String get realEstateListings => '房地产清单';

  @override
  String get stayUpdated => '保持更新';

  @override
  String get comingSoonBadge => '即将推出';

  @override
  String get ctaTitle => '立即加入 TezSell 社区！';

  @override
  String get ctaDescription => '参与为乌兹别克斯坦打造更好的市场体验。分享您的反馈并帮助我们成长！';

  @override
  String get createAccount => '创建账户';

  @override
  String get learnMore => '了解更多';

  @override
  String get replyUpdateSuccess => '回复更新成功';

  @override
  String get replyUpdateError => '无法更新回复';

  @override
  String get replyDeleteSuccess => '回复删除成功';

  @override
  String get replyDeleteError => '删除回复失败';

  @override
  String get replyDeleteConfirmation => '您确定要删除此回复吗？';

  @override
  String get authenticationRequired => '需要身份验证';

  @override
  String get enterValidReply => '请输入有效的回复文字';

  @override
  String get saving => '保存...';

  @override
  String get deleting => '正在删除...';

  @override
  String get properties => '特性';

  @override
  String get agents => '代理商';

  @override
  String get becomeAgent => '成为代理';

  @override
  String get main => '主要的';

  @override
  String get upload => '上传';

  @override
  String get filtered_products => '过滤产品';

  @override
  String get filtered_services => '过滤服务';

  @override
  String get productDetail => '产品详情';

  @override
  String get unknownUser => '未知用户';

  @override
  String get locationNotAvailable => '位置不可用';

  @override
  String get noTitle => '无标题';

  @override
  String get noCategory => '没有类别';

  @override
  String get noDescription => '无描述';

  @override
  String get som => '索姆';

  @override
  String get about_me => '关于我';

  @override
  String get my_name => '我的名字';

  @override
  String get customer_support => '客户支持';

  @override
  String get customer_center => '客户中心';

  @override
  String get customer_inquiries => '查询';

  @override
  String get customer_terms => '条款和条件';

  @override
  String get region => '地区';

  @override
  String get district => '区';

  @override
  String get tap_change_profile => '点击即可更改照片';

  @override
  String get language_settings => '语言设置';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get select_theme => '选择主题';

  @override
  String get theme => '主题';

  @override
  String get location_settings => '位置设置';

  @override
  String get security => '安全';

  @override
  String get data_storage => '数据与存储';

  @override
  String get accessibility => '无障碍';

  @override
  String get privacy => '隐私';

  @override
  String get light_theme => '光';

  @override
  String get dark_theme => '黑暗的';

  @override
  String get system_theme => '系统默认值';

  @override
  String get my_products => '我的产品';

  @override
  String get refresh => '刷新';

  @override
  String get delete_product => '删除产品';

  @override
  String get delete_confirmation => '您确定要删除该产品吗？';

  @override
  String get delete => '删除';

  @override
  String error_loading_products(String error) {
    return '加载产品时出错：$error';
  }

  @override
  String get product_deleted_success => '产品删除成功';

  @override
  String error_deleting_product(String error) {
    return '删除产品时出错：$error';
  }

  @override
  String get no_products_found => '没有找到产品';

  @override
  String get add_first_product => '首先添加您的第一个产品';

  @override
  String get no_title => '无标题';

  @override
  String get no_description => '无描述';

  @override
  String get in_stock => '有存货';

  @override
  String get out_of_stock => '缺货';

  @override
  String get new_condition => '新的';

  @override
  String get edit_product => '编辑产品';

  @override
  String get delete_product_tooltip => '删除产品';

  @override
  String get sum_currency => '和';

  @override
  String get edit_product_title => '编辑产品';

  @override
  String get product_name => '产品名称';

  @override
  String get product_description => '产品描述';

  @override
  String get price => '价格';

  @override
  String get condition => '健康）状况';

  @override
  String get condition_new => '新的';

  @override
  String get condition_used => '用过的';

  @override
  String get condition_refurbished => '翻新';

  @override
  String get currency => '货币';

  @override
  String get category => '类别';

  @override
  String get images => '图片';

  @override
  String get existing_images => '现有图像';

  @override
  String get new_images => '新图像';

  @override
  String get image_instructions => '图像将出现在这里。请按上面的上传图标。';

  @override
  String get update_button => '更新';

  @override
  String loading_category_error(String error) {
    return '加载类别时出错：$error';
  }

  @override
  String error_picking_images(String error) {
    return '选取图像时出错：$error';
  }

  @override
  String get please_fill_all_required => '请填写所有字段';

  @override
  String get invalid_price_message => '输入的价格无效。请输入有效的号码。';

  @override
  String get category_required_message => '请选择一个有效的类别。';

  @override
  String get one_image_required_message => '至少需要一张产品图片';

  @override
  String get product_updated_success => '产品更新成功';

  @override
  String error_updating_product(String error) {
    return '更新产品时出错：$error';
  }

  @override
  String get my_services => '我的服务';

  @override
  String get delete_service => '删除服务';

  @override
  String get delete_service_confirmation => '您确定要删除此服务吗？';

  @override
  String get no_services_found => '没有找到服务';

  @override
  String get add_first_service => '首先添加您的第一个服务';

  @override
  String get edit_service => '编辑服务';

  @override
  String get delete_service_tooltip => '删除服务';

  @override
  String get service_deleted_successfully => '服务删除成功';

  @override
  String get error_deleting_service => '删除服务时出错';

  @override
  String get error_loading_services => '加载服务时出错';

  @override
  String get service_name => '服务名称';

  @override
  String get enter_service_name => '输入服务名称';

  @override
  String get service_name_required => '服务名称为必填项';

  @override
  String get service_name_min_length => '服务名称必须至少 3 个字符';

  @override
  String get enter_service_description => '输入服务描述';

  @override
  String get service_description_required => '需要提供服务描述';

  @override
  String get service_description_min_length => '描述必须至少 10 个字符';

  @override
  String get category_required => '请选择一个类别';

  @override
  String get no_categories_available => '没有可用的类别';

  @override
  String get location => '地点';

  @override
  String get select_location => '选择地点';

  @override
  String get location_required => '请选择地点';

  @override
  String get no_locations_available => '没有可用的位置';

  @override
  String get add_images => '添加图片';

  @override
  String get current_images => '当前图像';

  @override
  String get no_images_selected => '未选择图像';

  @override
  String get save_changes => '保存更改';

  @override
  String get map_main => '地图和属性';

  @override
  String get agent_status => '代理状态';

  @override
  String get admin_panel => '管理面板';

  @override
  String get propertiesFound => '找到的属性';

  @override
  String get propertiesSaved => '属性已保存';

  @override
  String get saved => '已保存';

  @override
  String get loadingProperties => '正在加载属性...';

  @override
  String get failedToLoad => '无法加载属性。请再试一次。';

  @override
  String get noPropertiesFound => '未找到属性';

  @override
  String get tryAdjusting => '尝试调整您的搜索条件';

  @override
  String get search_placeholder => '按标题或位置搜索...';

  @override
  String get search_filters => '过滤器';

  @override
  String get search_button => '搜索';

  @override
  String get search_clear_filters => '清除过滤器';

  @override
  String get filter_options_sale_and_rent => '出售和出租';

  @override
  String get filter_options_for_sale => '出售';

  @override
  String get filter_options_for_rent => '出租';

  @override
  String get filter_options_all_types => '所有类型';

  @override
  String get filter_options_apartment => '公寓';

  @override
  String get filter_options_house => '房子';

  @override
  String get filter_options_townhouse => '联排别墅';

  @override
  String get filter_options_villa => '别墅';

  @override
  String get filter_options_commercial => '商业的';

  @override
  String get filter_options_office => '办公室';

  @override
  String get property_card_featured => '精选';

  @override
  String get property_card_bed => '卧室';

  @override
  String get property_card_bath => '浴室';

  @override
  String get property_card_parking => '停車處';

  @override
  String get property_card_view_details => '查看详情';

  @override
  String get property_card_contact => '接触';

  @override
  String get property_card_balcony => '阳台';

  @override
  String get property_card_garage => '车库';

  @override
  String get property_card_garden => '花园';

  @override
  String get property_card_pool => '水池';

  @override
  String get property_card_elevator => '电梯';

  @override
  String get property_card_furnished => '家具齐全';

  @override
  String get property_card_sales => '销售量';

  @override
  String get pricing_month => '/月';

  @override
  String get results_properties_found => '找到的属性';

  @override
  String get results_properties_saved => '属性已保存';

  @override
  String get results_saved => '已保存';

  @override
  String get results_loading_properties => '正在加载属性...';

  @override
  String get results_failed_to_load => '无法加载属性。请再试一次。';

  @override
  String get results_no_properties_found => '未找到属性';

  @override
  String get results_try_adjusting => '尝试调整您的搜索条件';

  @override
  String get no_properties_found => '未找到属性';

  @override
  String get no_category_properties => '该类别中没有房产';

  @override
  String get properties_loading => '正在加载属性...';

  @override
  String get all_properties_loaded => '已加载所有属性';

  @override
  String n_properties(int count) {
    return '$count 属性';
  }

  @override
  String get in_area => '在地区';

  @override
  String get pagination_previous => '以前的';

  @override
  String get pagination_next => '下一个';

  @override
  String get pagination_page => '页';

  @override
  String get pagination_page_of => '第 1 页';

  @override
  String get contact_modal_title => '联系信息';

  @override
  String get contact_modal_agent_contact => '代理联系方式';

  @override
  String get contact_modal_property_owner => '业主';

  @override
  String get contact_modal_agent_phone_number => '代理电话号码';

  @override
  String get contact_modal_owner_phone_number => '业主电话号码';

  @override
  String get contact_modal_license => '执照';

  @override
  String get contact_modal_rating => '等级';

  @override
  String get contact_modal_call_now => '立即致电';

  @override
  String get contact_modal_copy_number => '拷贝数';

  @override
  String get contact_modal_close => '关闭';

  @override
  String get contact_modal_contact_hours => '联系时间：上午 9:00 - 晚上 8:00';

  @override
  String get contact_modal_agent => '代理人';

  @override
  String get errors_toggle_save_failed => '无法切换属性保存：';

  @override
  String get errors_copy_failed => '复制电话号码失败：';

  @override
  String get errors_phone_copied => '电话号码已复制到剪贴板';

  @override
  String get errors_error_occurred_regions => '区域发生错误';

  @override
  String get errors_error_occurred_districts => '地区发生错误';

  @override
  String get errors_please_fill_all_required_fields => '请填写所有必填字段';

  @override
  String get errors_authentication_required => '需要身份验证';

  @override
  String get errors_user_info_missing => '用户信息缺失';

  @override
  String get errors_validation_error => '请检查您输入的数据';

  @override
  String get errors_permission_denied => '没有权限';

  @override
  String get errors_server_error => '服务器发生错误';

  @override
  String get errors_network_error => '网络连接错误';

  @override
  String get errors_timeout_error => '请求超时';

  @override
  String get errors_custom_error => '发生错误';

  @override
  String get errors_error_creating_property => '创建属性时出错';

  @override
  String get errors_unknown_error_message => '发生未知错误';

  @override
  String get errors_coordinates_not_found => '找不到该地址的坐标。请手动输入。';

  @override
  String get errors_coordinates_error => '获取坐标时出错。请手动输入。';

  @override
  String get property_info_views => '意见';

  @override
  String get property_info_listed => '上市';

  @override
  String get property_info_price_per_sqm => '/平方米';

  @override
  String get property_info_saved => '已保存';

  @override
  String get property_info_save => '节省';

  @override
  String get property_info_share => '分享';

  @override
  String get loading_loading => '加载中...';

  @override
  String get loading_loading_details => '正在加载属性详细信息...';

  @override
  String get loading_property_not_found => '未找到财产';

  @override
  String get loading_property_not_found_message => '您要查找的资源不存在或已被删除。';

  @override
  String get loading_back_to_properties => '返回属性';

  @override
  String get loading_title => '正在加载代理...';

  @override
  String get loading_message => '我们正在加载代理列表，请稍候。';

  @override
  String get loading_agent_not_found => '未找到代理';

  @override
  String get property_details_title => '物业详情';

  @override
  String get property_details_bedrooms => '卧室';

  @override
  String get property_details_bathrooms => '浴室';

  @override
  String get property_details_floor_area => '建筑面积';

  @override
  String get property_details_parking => '停車處';

  @override
  String get property_details_basic_information => '基本信息';

  @override
  String get property_details_property_type => '房产类型：';

  @override
  String get property_details_listing_type => '列表类型：';

  @override
  String get property_details_for_sale => '出售';

  @override
  String get property_details_for_rent => '出租';

  @override
  String get property_details_year_built => '建成年份：';

  @override
  String get property_details_floor => '地面：';

  @override
  String get property_details_of => '的';

  @override
  String get property_details_features_amenities => '特色与便利设施';

  @override
  String get sections_description => '描述';

  @override
  String get sections_nearby_amenities => '附近设施';

  @override
  String get sections_similar_properties => '类似的属性';

  @override
  String get amenities_metro => '地铁';

  @override
  String get amenities_school => '学校';

  @override
  String get amenities_hospital => '医院';

  @override
  String get amenities_shopping => '购物';

  @override
  String get amenities_away => '离开';

  @override
  String get contact_title => '联系信息';

  @override
  String get contact_professional_listing => '专业列表';

  @override
  String get contact_listed_by_agent => '由经过验证的代理列出';

  @override
  String get contact_by_owner => '按业主';

  @override
  String get contact_direct_contact => '直接联系业主';

  @override
  String get contact_property_owner => '业主';

  @override
  String get contact_call_agent => '呼叫代理';

  @override
  String get contact_email_agent => '邮件代理';

  @override
  String get contact_call_owner => '致电业主';

  @override
  String get contact_email_owner => '电子邮件所有者';

  @override
  String get contact_send_inquiry => '发送询问';

  @override
  String get property_status_title => '物业状况';

  @override
  String get property_status_availability => '可用性：';

  @override
  String get property_status_available => '可用的';

  @override
  String get property_status_not_available => '无法使用';

  @override
  String get property_status_featured => '特色：';

  @override
  String get property_status_featured_property => '特色物业';

  @override
  String get property_status_property_id => '物业编号：';

  @override
  String get inquiry_title => '发送询问';

  @override
  String get inquiry_inquiry_type => '查询类型';

  @override
  String get inquiry_request_info => '索取信息';

  @override
  String get inquiry_schedule_viewing => '预约观看';

  @override
  String get inquiry_make_offer => '提出报价';

  @override
  String get inquiry_request_callback => '请求回电';

  @override
  String get inquiry_message => '信息';

  @override
  String get inquiry_message_placeholder => '告诉我们您对此房产的兴趣...';

  @override
  String get inquiry_offered_price => '报价';

  @override
  String get inquiry_enter_offer => '输入您的报价';

  @override
  String get inquiry_preferred_contact_time => '首选联系时间（可选）';

  @override
  String get inquiry_contact_time_placeholder => '例如，工作日上午 9:00 - 下午 5:00';

  @override
  String get inquiry_cancel => '取消';

  @override
  String get inquiry_sending => '正在发送...';

  @override
  String get inquiry_send_inquiry => '发送询问';

  @override
  String get inquiry_inquiry_sent_success => '询盘发送成功！';

  @override
  String get inquiry_inquiry_sent_error => '发送询问失败。请再试一次。';

  @override
  String get alerts_link_copied => '属性链接已复制到剪贴板！';

  @override
  String get alerts_phone_copied => '电话号码已复制到剪贴板！';

  @override
  String get alerts_save_property_failed => '保存财产失败：';

  @override
  String get alerts_email_subject => '查询：';

  @override
  String alerts_email_body(Object address, Object title) {
    return '您好，\\n\\n我对您位于 $address 的房产“$title”感兴趣。\\n\\n请与我联系以获取更多信息。\\n\\n此致';
  }

  @override
  String get related_properties_view_details => '查看详情';

  @override
  String get header_property => '寻找您梦想的房产';

  @override
  String get header_sub_property => '在塔什干最令人向往的社区发现优质房地产机会';

  @override
  String get header_title => '房地产经纪人';

  @override
  String get header_subtitle => '寻找经验丰富的经纪人来帮助满足您的房地产需求';

  @override
  String get header_agents_found => '找到代理';

  @override
  String get filters_all_specializations => '所有专业';

  @override
  String get filters_residential => '住宅';

  @override
  String get filters_commercial => '商业的';

  @override
  String get filters_luxury => '奢华';

  @override
  String get filters_investment => '投资';

  @override
  String get filters_any_rating => '任意评级';

  @override
  String get filters_four_stars => '4+ 星';

  @override
  String get filters_four_half_stars => '4.5+ 星';

  @override
  String get filters_five_stars => '5 星';

  @override
  String get filters_highest_rated => '最高评价';

  @override
  String get filters_lowest_rated => '最低评分';

  @override
  String get filters_most_sales => '销量最多';

  @override
  String get filters_most_experience => '最有经验';

  @override
  String get agent_card_verified_agent => '已验证代理';

  @override
  String get agent_card_years_experience => '年经验';

  @override
  String get agent_card_years => '年';

  @override
  String get agent_card_license => '执照';

  @override
  String get agent_card_specialization => '专业化';

  @override
  String get agent_card_view_profile => '查看资料';

  @override
  String get agent_card_contact => '接触';

  @override
  String get agent_card_verified => '已验证';

  @override
  String get no_results_title => '没有找到代理';

  @override
  String get no_results_message => '尝试调整您的搜索条件或过滤器。';

  @override
  String get error_title => '加载代理时出错';

  @override
  String get error_message => '无法加载代理列表。请再试一次。';

  @override
  String get error_retry => '重试';

  @override
  String get error_default_message => '无法加载代理详细信息';

  @override
  String get error_try_again => '再试一次';

  @override
  String get notifications_phone_copied => '电话号码已复制到剪贴板';

  @override
  String get notifications_copy_failed => '复制电话号码失败：';

  @override
  String get fallback_agent_name => '代理人';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => '提交财产';

  @override
  String get navigation_submitting => '正在提交...';

  @override
  String get navigation_back_to_agents => '返回代理';

  @override
  String get agent_profile_verified_agent => '已验证代理';

  @override
  String get agent_profile_contact_agent => '联系代理';

  @override
  String get agent_profile_send_message => '发送消息';

  @override
  String get agent_profile_years_experience => '年经验';

  @override
  String get agent_profile_properties_sold => '已售物业';

  @override
  String get agent_profile_active_listings => '活跃列表';

  @override
  String get agent_profile_total_properties => '总资产';

  @override
  String get tabs_overview => '概述';

  @override
  String get tabs_properties => '特性';

  @override
  String get tabs_reviews => '评论';

  @override
  String get about_agent_title => '关于代理';

  @override
  String get about_agent_agency => '机构';

  @override
  String get about_agent_license_number => '执照号码';

  @override
  String get about_agent_specialization => '专业化';

  @override
  String get about_agent_member_since => '会员自';

  @override
  String get about_agent_verified_since => '验证时间自';

  @override
  String get performance_metrics_title => '绩效指标';

  @override
  String get performance_metrics_average_rating => '平均评分';

  @override
  String get performance_metrics_properties_sold => '已售物业';

  @override
  String get performance_metrics_active_listings => '活跃列表';

  @override
  String get performance_metrics_years_experience => '年经验';

  @override
  String get contact_info_title => '联系信息';

  @override
  String get contact_info_contact_via_platform => '通过平台联系';

  @override
  String get verification_status_title => '验证状态';

  @override
  String get verification_status_verified_agent => '已验证代理';

  @override
  String get verification_status_pending_verification => '待验证';

  @override
  String get verification_status_licensed_professional => '持证专业人士';

  @override
  String get verification_status_registered_agency => '注册代理机构';

  @override
  String get quick_actions_title => '快速行动';

  @override
  String get quick_actions_call_now => '立即致电';

  @override
  String get quick_actions_send_message => '发送消息';

  @override
  String get quick_actions_view_properties => '查看属性';

  @override
  String get properties_title => '代理属性';

  @override
  String get properties_loading_properties => '正在加载属性...';

  @override
  String get properties_no_properties_title => '未找到房产';

  @override
  String get properties_no_properties_message => '该代理的属性将出现在此处。';

  @override
  String get properties_recent_properties_note => '显示最近的属性。检查所有代理属性的完整列表。';

  @override
  String get properties_listed => '上市';

  @override
  String get properties_bed => '床';

  @override
  String get properties_bath => '洗澡';

  @override
  String get properties_for_sale => '出售';

  @override
  String get properties_for_rent => '出租';

  @override
  String get reviews_title => '客户评价';

  @override
  String get reviews_no_reviews_title => '还没有评论';

  @override
  String get reviews_no_reviews_message => '客户的评论和建议将出现在这里。';

  @override
  String get fallbacks_agent_name => '代理人';

  @override
  String get fallbacks_default_profile_image => '/默认头像.png';

  @override
  String get saved_properties_title => '已保存的属性';

  @override
  String get saved_properties_subtitle => '您最喜欢的房产集中在一处';

  @override
  String get saved_properties_no_saved_properties => '尚未保存属性';

  @override
  String get saved_properties_start_saving => '开始探索并保存您喜欢的房产';

  @override
  String get saved_properties_browse_properties => '浏览房产';

  @override
  String get saved_properties_saved_on => '保存于';

  @override
  String get auth_login_required => '请登录查看已保存的属性';

  @override
  String get auth_login => '登录';

  @override
  String get success_property_unsaved => '属性已从保存的列表中删除';

  @override
  String get success_property_saved => '属性保存成功';

  @override
  String get success_phone_copied => '电话号码已复制！';

  @override
  String get success_property_created_success => '属性创建成功！';

  @override
  String get success_agent_approved => '代理审核成功';

  @override
  String get success_agent_rejected => '代理拒绝成功';

  @override
  String get steps_step => '步';

  @override
  String get steps_basic_information => '基本信息';

  @override
  String get steps_location_details => '地点详情';

  @override
  String get steps_property_details => '物业详情';

  @override
  String get steps_property_images => '财产图片';

  @override
  String get basic_info_tell_us_about_property => '告诉我们您的财产';

  @override
  String get basic_info_property_type => '物业类型';

  @override
  String get basic_info_listing_type => '列表类型';

  @override
  String get basic_info_property_title => '产权';

  @override
  String get basic_info_title_placeholder => '输入您的财产的描述性标题';

  @override
  String get basic_info_description => '描述';

  @override
  String get basic_info_description_placeholder => '详细描述您的财产...';

  @override
  String get property_types_apartment => '公寓';

  @override
  String get property_types_house => '房子';

  @override
  String get property_types_townhouse => '联排别墅';

  @override
  String get property_types_villa => '别墅';

  @override
  String get property_types_commercial => '商业的';

  @override
  String get property_types_office => '办公室';

  @override
  String get property_types_land => '土地';

  @override
  String get property_types_warehouse => '仓库';

  @override
  String get listing_types_for_sale => '出售';

  @override
  String get listing_types_for_rent => '出租';

  @override
  String get location_where_is_property => '您的房产位于哪里？';

  @override
  String get location_full_address => '完整地址';

  @override
  String get location_address_placeholder => '输入完整地址';

  @override
  String get location_region => '地区';

  @override
  String get location_select_region => '选择地区';

  @override
  String get location_district => '区';

  @override
  String get location_select_district => '选择地区';

  @override
  String get location_city => '城市';

  @override
  String get location_city_placeholder => '城市';

  @override
  String get location_loading_regions => '加载区域...';

  @override
  String get location_loading_districts => '正在加载地区...';

  @override
  String get location_map_coordinates => '地图坐标';

  @override
  String get location_get_coordinates => '获取坐标';

  @override
  String get location_latitude => '纬度';

  @override
  String get location_longitude => '经度';

  @override
  String get location_coordinates_set => '坐标设定';

  @override
  String get location_location_tips => '位置提示';

  @override
  String get location_location_tip_1 => '• 先填写地址，然后点击“获取坐标”即可自动获取地图位置';

  @override
  String get location_location_tip_2 => '• 如果您知道确切位置，也可以手动输入坐标';

  @override
  String get location_location_tip_3 => '• 准确的坐标帮助买家在地图上找到您的房产';

  @override
  String get property_details_provide_detailed_info => '提供有关您的财产的详细信息';

  @override
  String get property_details_total_floors => '总楼层数';

  @override
  String get property_details_area_m2 => '面积（平方米）';

  @override
  String get property_details_parking_spaces => '停车位';

  @override
  String get property_details_price => '价格';

  @override
  String get property_details_features => '特征';

  @override
  String get images_add_photos_showcase => '添加照片以展示您的财产';

  @override
  String get images_click_to_upload => '点击上传图片';

  @override
  String get images_max_images_info => '最多 10 张图像，JPG、PNG 或 WEBP';

  @override
  String get images_main => '主要的';

  @override
  String get images_maximum_images_allowed => '最多允许 10 张图像';

  @override
  String get admin_dashboard_title => '管理仪表板';

  @override
  String get admin_dashboard_subtitle => '实时概览您的房地产平台';

  @override
  String get admin_last_update => '最后更新';

  @override
  String get admin_total_properties => '总资产';

  @override
  String get admin_total_agents => '代理总数';

  @override
  String get admin_total_users => '用户总数';

  @override
  String get admin_total_views => '总观看次数';

  @override
  String get admin_error_loading_dashboard => '加载仪表板时出错';

  @override
  String get admin_failed_to_load_data => '无法加载仪表板数据';

  @override
  String get admin_avg_sale_price => '平均销售价格';

  @override
  String get admin_avg_sale_price_subtitle => '所有活跃列表';

  @override
  String get admin_total_portfolio_value => '投资组合总价值';

  @override
  String get admin_total_portfolio_value_subtitle => '综合财产价值';

  @override
  String get admin_avg_price_per_sqm => '每平方米平均价格';

  @override
  String get admin_avg_price_per_sqm_subtitle => '市场利率指标';

  @override
  String get admin_property_types_distribution => '物业类型分布';

  @override
  String get admin_properties_by_city => '各城市的房产';

  @override
  String get admin_properties_by_district => '按地区划分的房产';

  @override
  String get admin_inquiry_types_distribution => '询价类型分布';

  @override
  String get admin_agent_verification_rate => '代理验证率';

  @override
  String get admin_agent_verification_rate_subtitle => '质量控制';

  @override
  String get admin_inquiry_response_rate => '询问回复率';

  @override
  String get admin_inquiry_response_rate_subtitle => '客户服务';

  @override
  String get admin_avg_views_per_property => '每个房产的平均浏览量';

  @override
  String get admin_avg_views_per_property_subtitle => '楼盘人气';

  @override
  String get admin_featured_properties => '特色房产';

  @override
  String get admin_featured_properties_subtitle => '高级列表';

  @override
  String get admin_most_viewed_properties => '最受浏览的房产';

  @override
  String get admin_top_performing_agents => '表现最佳的代理商';

  @override
  String get admin_system_health => '系统健康状况';

  @override
  String get admin_properties_without_images => '没有图像的属性';

  @override
  String get admin_missing_location_data => '缺少位置数据';

  @override
  String get admin_pending_agent_verification => '等待代理验证';

  @override
  String get admin_active => '积极的';

  @override
  String get admin_verified => '已验证';

  @override
  String get admin_active_7d => '活跃（7天）';

  @override
  String get admin_this_month => '本月';

  @override
  String get agents_loading_pending_applications => '正在加载待处理的申请...';

  @override
  String get agents_error_loading_applications => '加载应用程序时出错';

  @override
  String get agents_pending_agents => '待定代理';

  @override
  String get agents_total_pending_applications => '待处理申请总数：';

  @override
  String get agents_pending_verification => '待验证';

  @override
  String get agents_applied_date => '应用：';

  @override
  String get agents_contact_info => '联系信息';

  @override
  String get agents_license_number => '执照号码';

  @override
  String get agents_years_experience => '年经验';

  @override
  String get agents_years_suffix => '年';

  @override
  String get agents_total_sales => '总销售额';

  @override
  String get agents_specialization => '专业化';

  @override
  String get agents_approve => '批准';

  @override
  String get agents_reject => '拒绝';

  @override
  String get agents_no_pending_applications => '没有待处理的申请';

  @override
  String get agents_all_applications_processed => '所有代理申请均已处理';

  @override
  String get general_previous => '以前的';

  @override
  String get general_page => '页';

  @override
  String get general_next => '下一个';

  @override
  String get general_views => '意见';

  @override
  String get general_sales => '销售量';

  @override
  String get general_language_uz => '奥兹别克恰';

  @override
  String get general_language_ru => '俄罗斯';

  @override
  String get general_language_en => '英语';

  @override
  String get general_super_admin => '超级管理员';

  @override
  String get general_staff => '职员';

  @override
  String get general_verified_agent => '已验证代理';

  @override
  String get general_pending_agent => '待定代理';

  @override
  String get general_regular_user => '普通用户';

  @override
  String get general_admin => '行政';

  @override
  String get general_dashboard => '仪表板';

  @override
  String get general_manage_users => '管理用户';

  @override
  String get general_verified_agents => '已验证代理';

  @override
  String get general_agent_panel => '代理面板';

  @override
  String get general_create_property => '创建财产';

  @override
  String get general_my_properties => '我的房产';

  @override
  String get general_inquiries => '查询';

  @override
  String get general_agent_profile => '代理简介';

  @override
  String get general_live => '居住';

  @override
  String get general_logged_out_successfully => '退出成功';

  @override
  String get general_logout_completed_with_errors => '注销完成（有错误）';

  @override
  String get general_application_under_review => '申请正在审核中';

  @override
  String get general_check_status => '检查状态 →';

  @override
  String get general_last_updated => '最后更新：';

  @override
  String get general_permissions_may_be_outdated => '权限可能已过时';

  @override
  String get general_permissions_up_to_date => '权限已更新';

  @override
  String get general_never => '绝不';

  @override
  String get general_properties_found => '找到的属性';

  @override
  String get general_properties_saved => '属性已保存';

  @override
  String get general_saved => '已保存';

  @override
  String get general_loading_properties => '正在加载属性...';

  @override
  String get general_failed_to_load => '无法加载属性。请再试一次。';

  @override
  String get general_no_properties_found => '未找到属性';

  @override
  String get general_try_adjusting => '尝试调整您的搜索条件';

  @override
  String get select_category => '选择类别';

  @override
  String get service_description => '服务说明';

  @override
  String get product_search_placeholder => '输入搜索词来查找产品';

  @override
  String get privacy_policy => '隐私政策';

  @override
  String get terms_subtitle => '隐私政策和条款';

  @override
  String get last_updated => '最后更新';

  @override
  String get contact_information => '联系信息';

  @override
  String get accept_terms => '我接受条款和条件';

  @override
  String get read_terms => '请阅读我们的条款和条件';

  @override
  String get inquiries => '查询与支持';

  @override
  String get inquiries_subtitle => '联系我们寻求帮助';

  @override
  String get help_center => '我们能为您提供什么帮助？';

  @override
  String get help_subtitle => '我们随时为您解答任何问题';

  @override
  String get contact_us => '联系我们';

  @override
  String get email_support => '电子邮件支持';

  @override
  String get call_support => '致电支持';

  @override
  String get send_message => '发送消息';

  @override
  String get fill_contact_form => '填写联系表';

  @override
  String get contact_form => '联系表';

  @override
  String get name => '你的名字';

  @override
  String get name_required => '请输入您的姓名';

  @override
  String get email => '电子邮件';

  @override
  String get email_required => '请输入您的电子邮件';

  @override
  String get email_invalid => '请输入有效的电子邮件';

  @override
  String get subject => '主题';

  @override
  String get subject_required => '请输入主题';

  @override
  String get message => '信息';

  @override
  String get message_required => '请输入您的留言';

  @override
  String get message_too_short => '消息长度必须至少为 10 个字符';

  @override
  String get faq => '常见问题解答';

  @override
  String get follow_us => '跟着我们';

  @override
  String get faq_how_to_sell => '如何在 Tezsell 上销售商品？';

  @override
  String get faq_how_to_sell_answer =>
      '出售物品：1) 创建帐户，2) 点击“+”按钮，3) 选择类别（产品/服务/房地产），4) 添加照片和描述，5) 设置价格，6) 发布！您所在地区的买家将可以看到您的列表。';

  @override
  String get faq_is_free => 'Tezsell 可以免费使用吗？';

  @override
  String get faq_is_free_answer =>
      '是的！ Tezsell 目前 100% 免费。无上市费、无销售佣金、无订阅费。我们将来可能会推出高级功能，但会提前 30 天通知用户。';

  @override
  String get faq_safety => '买卖时如何保证安全？';

  @override
  String get faq_safety_answer =>
      '安全提示：1) 在公共场所见面，2) 付款前检查物品，3) 切勿向陌生人汇款，4) 相信自己的直觉，5) 报告可疑用户，6) 不要过早分享个人信息，7) 带朋友进行大额交易。';

  @override
  String get faq_payment => '付款如何进行？';

  @override
  String get faq_payment_answer =>
      'Tezsell 不处理付款。买家和卖家直接安排付款（现金、银行转账等）。我们只是一个连接人们的平台——你自己处理交易。';

  @override
  String get faq_prohibited => '哪些物品是禁止携带的？';

  @override
  String get faq_prohibited_answer =>
      '违禁物品包括：武器、毒品、赃物、假冒物品、成人内容、活体动物（未经许可）、政府身份证件和危险材料。请参阅我们的条款和条件以获取完整列表。';

  @override
  String get faq_account_delete => '如何删除我的帐户？';

  @override
  String get faq_account_delete_answer =>
      '前往个人资料 → 设置 → 帐户设置 → 删除帐户。注意：这是永久性的，无法撤消。您的所有列表都将被删除。';

  @override
  String get faq_report_user => '如何举报用户或列表？';

  @override
  String get faq_report_user_answer =>
      '点击任何列表或用户个人资料上的三个点 (•••)，然后选择“报告”。选择原因并提交。我们会在 24-48 小时内审核所有报告。';

  @override
  String get faq_change_location => '如何更改我的位置？';

  @override
  String get faq_change_location_answer =>
      '点击主屏幕左上角的位置按钮。您可以选择您所在的地区和地区来查看您所在地区的列表。';

  @override
  String get welcome_customer_center => '欢迎来到客户中心';

  @override
  String get customer_center_subtitle => '我们 24/7 随时为您提供帮助';

  @override
  String get quick_actions => '快速行动';

  @override
  String get live_chat => '实时聊天';

  @override
  String get chat_with_us => '与我们聊天';

  @override
  String get find_answers => '寻找答案';

  @override
  String get my_tickets => '我的门票';

  @override
  String get view_tickets => '查看门票';

  @override
  String get feedback => '反馈';

  @override
  String get share_feedback => '分享反馈';

  @override
  String get contact_methods => '联系方式';

  @override
  String get phone_support => '电话支持';

  @override
  String get available_247 => '24/7 可用';

  @override
  String get response_24h => '24小时内回复';

  @override
  String get telegram_support => '电报支持';

  @override
  String get instant_replies => '即时回复';

  @override
  String get whatsapp_support => 'WhatsApp 支持';

  @override
  String get quick_response => '快速响应';

  @override
  String get popular_topics => '热门话题';

  @override
  String get account_management => '账户管理';

  @override
  String get reset_password => '重置密码';

  @override
  String get update_profile => '更新个人资料';

  @override
  String get verify_account => '验证账户';

  @override
  String get delete_account => '删除账户';

  @override
  String get buying_selling => '买卖';

  @override
  String get how_to_post => '如何发布广告';

  @override
  String get payment_methods => '付款方式';

  @override
  String get shipping_delivery => '运输与交付';

  @override
  String get return_policy => '退货政策';

  @override
  String get safety_security => '安全与安保';

  @override
  String get report_scam => '举报诈骗';

  @override
  String get safe_trading => '安全交易技巧';

  @override
  String get privacy_settings => '隐私设置';

  @override
  String get blocked_users => '被阻止的用户';

  @override
  String get technical_issues => '技术问题';

  @override
  String get app_not_working => '应用程序不工作';

  @override
  String get upload_failed => '上传失败';

  @override
  String get login_problems => '登录问题';

  @override
  String get support_hours => '支持时间';

  @override
  String get mon_fri_9_6 => '周一至周五：上午 9:00 - 下午 6:00';

  @override
  String get how_are_we_doing => '我们怎么样？';

  @override
  String get rate_experience => '评价您的客户服务体验';

  @override
  String get poor => '贫穷的';

  @override
  String get okay => '好的';

  @override
  String get good => '好的';

  @override
  String get excellent => '出色的';

  @override
  String get account_secure => '您的帐户是安全的';

  @override
  String get password_security => '密码与认证';

  @override
  String get change_password => '更改密码';

  @override
  String get two_factor_auth => '双因素身份验证';

  @override
  String get biometric_login => '生物识别登录';

  @override
  String get login_activity => '登录活动';

  @override
  String get active_sessions => '活跃会话';

  @override
  String get login_alerts => '登录提醒';

  @override
  String get account_protection => '账户保护';

  @override
  String get recovery_email => '恢复电子邮件';

  @override
  String get backup_codes => '备份代码';

  @override
  String get danger_zone => '危险区';

  @override
  String get improve_security => '提高安全性';

  @override
  String get security_score => '安全分数';

  @override
  String get last_changed_days => '最后更改时间为 30 天前';

  @override
  String get logout_all_devices => '注销所有设备';

  @override
  String get end_all_sessions => '结束所有会话';

  @override
  String get permanently_delete => '永久删除';

  @override
  String get verification_code_message => '我们将发送验证码以确认您的身份。';

  @override
  String get send_code => '发送代码';

  @override
  String get enter_verification_code => '输入验证码';

  @override
  String get verification_code => '验证码';

  @override
  String get new_password => '新密码';

  @override
  String get confirm_password => '确认密码';

  @override
  String get resend_code => '重新发送代码';

  @override
  String get code_sent_to => '输入发送至的验证码';

  @override
  String get enter_code => '输入验证码';

  @override
  String get code_must_be_6_digits => '代码必须是 6 位数字';

  @override
  String get enter_new_password => '输入新密码';

  @override
  String get minimum_8_characters => '最少 8 个字符';

  @override
  String get passwords_do_not_match => '密码不匹配';

  @override
  String get close => '关闭';

  @override
  String get current => '当前的';

  @override
  String get session_ended => '会议结束';

  @override
  String get update_recovery_email => '更新恢复电子邮件';

  @override
  String get new_email => '新电子邮件';

  @override
  String get update => '更新';

  @override
  String get verification_email_sent => '验证邮件已发送';

  @override
  String get generate_emergency_codes => '生成紧急代码';

  @override
  String get copy_all => '全部复制';

  @override
  String get code_copied => '复制代码';

  @override
  String get all_codes_copied => '复制所有代码';

  @override
  String get logout_all_devices_confirm => '注销所有设备？';

  @override
  String get logout_all_devices_message => '这将结束所有设备上的所有活动会话。';

  @override
  String get logout_all => '全部注销';

  @override
  String get delete_account_confirm => '删除帐户？';

  @override
  String get delete_account_warning => '此操作是永久性的且无法撤消。您的所有数据将被永久删除。';

  @override
  String get what_will_be_deleted => '将删除的内容：';

  @override
  String get profile_and_account_info => '• 您的个人资料和帐户信息';

  @override
  String get all_listings_and_posts => '• 您的所有列表和帖子';

  @override
  String get messages_and_conversations => '留言';

  @override
  String get saved_items_and_preferences => '• 保存的项目和首选项';

  @override
  String get enter_password_to_continue => '输入您的密码以继续';

  @override
  String get continue_val => '继续';

  @override
  String get please_enter_password => '请输入您的密码';

  @override
  String get enter_confirmation_code => '输入验证码';

  @override
  String get deletion_confirmation_message => '我们向您的手机发送了确认码。在下面输入它以永久删除您的帐户。';

  @override
  String get confirmation_code => '验证码';

  @override
  String get please_enter_6_digit_code => '请输入6位数字代码';

  @override
  String get account_deleted => '您的帐户已被删除';

  @override
  String get deletion_cancelled => '删除已取消';

  @override
  String get failed_to_load_user_info => '加载用户信息失败';

  @override
  String get auth_login_to_view_saved => '请登录查看您保存的属性';

  @override
  String get authLoginRequired => '需要登录';

  @override
  String get authLoginToViewSaved => '请登录查看您保存的属性';

  @override
  String get authLogin => '登录';

  @override
  String get savedPropertiesTitle => '已保存的属性';

  @override
  String get loadingSavedProperties => '正在加载保存的属性...';

  @override
  String get errorsFailedToLoadSaved => '无法加载已保存的属性';

  @override
  String get actionsRetry => '重试';

  @override
  String get savedPropertiesNoSaved => '没有保存的属性';

  @override
  String get savedPropertiesStartSaving => '开始探索并保存您喜欢的房产';

  @override
  String get savedPropertiesBrowse => '浏览房产';

  @override
  String get resultsSavedProperties => '保存的属性';

  @override
  String get actionsRefresh => '刷新';

  @override
  String get resultsNoMoreProperties => '没有更多属性';

  @override
  String get propertyCardFeatured => '精选';

  @override
  String get successPropertyUnsaved => '属性已从保存的列表中删除';

  @override
  String get alertsUnsavePropertyFailed => '删除财产失败';

  @override
  String get propertyCardBed => '床';

  @override
  String get propertyCardBath => '洗澡';

  @override
  String get savedPropertiesSavedOn => '保存于';

  @override
  String get propertyCardViewDetails => '查看详情';

  @override
  String get serviceDetailTitle => '服务详情';

  @override
  String get errorLoadingFavorites => '加载收藏夹项目时出错';

  @override
  String get noFavoritesFound => '没有找到喜欢的物品。';

  @override
  String get commentUpdatedSuccess => '评论更新成功！';

  @override
  String get errorUpdatingComment => '更新评论时出错';

  @override
  String get replyAddedSuccess => '回复添加成功！';

  @override
  String get errorAddingReply => '添加回复时出错';

  @override
  String get commentDeletedSuccess => '评论删除成功！';

  @override
  String get errorDeletingComment => '删除评论时出错';

  @override
  String get serviceLikedSuccess => '服务点赞成功！';

  @override
  String get errorLikingService => '喜欢服务时出错';

  @override
  String get serviceDislikedSuccess => '服务拒赞成功！';

  @override
  String get errorDislikingService => '不喜欢服务时出错';

  @override
  String get writeYourReply => '写下你的回复...';

  @override
  String get postReply => '发表回复';

  @override
  String get anonymous => '匿名的';

  @override
  String get editComment => '编辑评论';

  @override
  String get editYourComment => '编辑您的评论...';

  @override
  String get saveChanges => '保存更改';

  @override
  String get propertyOwner => '业主';

  @override
  String get errorLoadingServices => '加载服务时出错';

  @override
  String get noRecommendedServicesFound => '未找到推荐服务。';

  @override
  String get passwordRequired => '需要密码';

  @override
  String get passwordTooShort => '密码必须至少为 8 个字符';

  @override
  String get passwordRequirements => '密码必须包含字母和数字';

  @override
  String get usernameRequired => '用户名是必需的';

  @override
  String get usernameTooShort => '用户名必须至少 3 个字符';

  @override
  String get confirmPasswordRequired => '需要确认密码';

  @override
  String get passwordHelp => '至少 8 个字符、字母和数字';

  @override
  String get usernameExists => '该用户名已存在';

  @override
  String get phoneExists => '该电话号码已被注册';

  @override
  String get networkError => '网络连接错误。请检查您的连接';

  @override
  String get contactSeller => '联系卖家';

  @override
  String get callToReveal => '点击“通话”即可显示';

  @override
  String get camera => '相机';

  @override
  String get gallery => '画廊';

  @override
  String get selectImageSource => '选择图像源';

  @override
  String get uploading => '正在上传...';

  @override
  String get acceptTermsRequired => '您必须接受条款和条件才能继续';

  @override
  String get iAgreeToTerms => '我同意';

  @override
  String get termsAndConditions => '条款和条件';

  @override
  String get zeroToleranceStatement => '并了解对令人反感的内容或滥用行为的用户零容忍。';

  @override
  String get viewTerms => '查看条款和条件';

  @override
  String get reportContent => '报告内容';

  @override
  String get selectReportReason => '请选择举报原因：';

  @override
  String get additionalDetails => '其他详细信息（可选）';

  @override
  String get reportDetailsHint => '提供任何附加信息...';

  @override
  String get reportSubmitted => '感谢您的报告。我们将在 24 小时内审核。';

  @override
  String get reportProduct => '报告产品';

  @override
  String get reportService => '报告服务';

  @override
  String get reportMessage => '举报留言';

  @override
  String get reportUser => '举报用户';

  @override
  String get reportErrorNotImplemented => '报告功能尚不可用。请联系支持人员或稍后重试。';

  @override
  String get reportAlreadySubmitted => '您已举报此内容。我们正在审查您之前的报告。';

  @override
  String get reportFailedGeneric => '未能提交报告。请再试一次。';

  @override
  String get reportFailedNetwork => '发生网络错误。请检查您的连接并重试。';

  @override
  String get becomeAgentTitle => '加入成为房地产经纪人';

  @override
  String get becomeAgentSubtitle => '列出房产并帮助客户找到他们的梦想家园';

  @override
  String get agentBenefits => '好处：';

  @override
  String get agentBenefitVerified => '经过验证的代理徽章';

  @override
  String get agentBenefitAnalytics => '获取分析和见解';

  @override
  String get agentBenefitClients => '与潜在客户直接联系';

  @override
  String get agentBenefitReputation => '建立您的专业声誉';

  @override
  String get agentApplicationForm => '申请表';

  @override
  String get agentAgencyName => '机构名称';

  @override
  String get agentAgencyNameHint => '输入您的房地产经纪公司名称';

  @override
  String get agentAgencyNameRequired => '机构名称为必填项';

  @override
  String get agentLicenceNumber => '执照号码';

  @override
  String get agentLicenceNumberHint => '输入您的房地产许可证号码';

  @override
  String get agentLicenceNumberRequired => '需要许可证号码';

  @override
  String get agentYearsExperience => '多年经验';

  @override
  String get agentYearsExperienceHint => '输入年数';

  @override
  String get agentYearsExperienceRequired => '需要多年经验';

  @override
  String get agentYearsExperienceInvalid => '请输入有效号码';

  @override
  String get agentSpecialization => '专业化';

  @override
  String get agentApplicationNote => '您的申请将由我们的团队审核。一旦您的申请获得批准，您将收到通知。';

  @override
  String get agentSubmitApplication => '提交申请';

  @override
  String get agentApplicationSubmitted => '申请提交成功！我们将尽快审查。';

  @override
  String get agentApplicationStatus => '申请状态';

  @override
  String get agentViewProfile => '查看您的代理资料';

  @override
  String get agentDashboardComingSoon => '代理仪表板即将推出！';

  @override
  String get property_create_basic_information => '基本信息';

  @override
  String get property_create_property_title => '产权 *';

  @override
  String get property_create_property_title_hint => '例如，市中心的现代三卧室公寓';

  @override
  String get property_create_property_title_required => '请输入房产名称';

  @override
  String get property_create_description => '描述 *';

  @override
  String get property_create_description_hint => '详细描述您的财产...';

  @override
  String get property_create_description_required => '请输入描述';

  @override
  String get property_create_property_type => '物业类型';

  @override
  String get property_create_property_type_required => '房产类型 *';

  @override
  String get property_create_listing_type_required => '列表类型 *';

  @override
  String get property_create_pricing => '定价';

  @override
  String get property_create_price => '价格 *';

  @override
  String get property_create_price_hint => '输入价格';

  @override
  String get property_create_price_required => '请输入价格';

  @override
  String get property_create_currency => '货币';

  @override
  String get property_create_property_details => '物业详情';

  @override
  String get property_create_square_meters => '平方。米 *';

  @override
  String get property_create_bedrooms => '卧室 *';

  @override
  String get property_create_bathrooms => '浴室 *';

  @override
  String get property_create_floor => '地面';

  @override
  String get property_create_total_floors => '总楼层数';

  @override
  String get property_create_parking => '停車處';

  @override
  String get property_create_year_built => '建成年份';

  @override
  String get property_create_location => '地点';

  @override
  String get property_create_address => '地址 *';

  @override
  String get property_create_address_hint => '输入房产地址';

  @override
  String get property_create_address_required => '请输入地址';

  @override
  String get property_create_location_detected => '检测到位置';

  @override
  String get property_create_get_location => '获取当前位置';

  @override
  String get property_create_features => '特征';

  @override
  String get property_create_feature_balcony => '阳台';

  @override
  String get property_create_feature_garage => '车库';

  @override
  String get property_create_feature_garden => '花园';

  @override
  String get property_create_feature_pool => '水池';

  @override
  String get property_create_feature_elevator => '电梯';

  @override
  String get property_create_feature_furnished => '家具齐全';

  @override
  String get property_create_images => '财产图片';

  @override
  String get property_create_tap_to_add_images => '点击即可添加图像';

  @override
  String get property_create_at_least_one_image => '至少需要 1 张图片';

  @override
  String get property_create_add_more => '添加更多';

  @override
  String get property_create_required => '必需的';

  @override
  String get property_create_location_required => '请启用定位服务以创建房产';

  @override
  String get property_create_image_required => '至少需要一张房产图片';

  @override
  String get emailVerification => '电子邮件验证';

  @override
  String get pleaseEnterYourEmailAddress => '请输入您的电子邮件地址';

  @override
  String get enterEmailAddress => '输入电子邮件地址';

  @override
  String get resetYourPassword => '重置您的密码';

  @override
  String get resetPasswordDescription => '输入您的电子邮件地址，我们将向您发送验证码以重置您的密码。';

  @override
  String get sendVerificationCode => '发送验证码';

  @override
  String get backToLogin => '返回登录';

  @override
  String get resetPassword => '重置密码';

  @override
  String enterVerificationCodeSentTo(String email) {
    return '输入发送至$email的验证码';
  }

  @override
  String get codeMustBe6Digits => '代码必须是 6 位数字';

  @override
  String get enterNewPassword => '输入新密码';

  @override
  String get minimum8Characters => '最少 8 个字符';

  @override
  String get sending => '正在发送...';

  @override
  String get verifying => '正在验证...';

  @override
  String get new_message => '新消息';

  @override
  String get messages => '留言';

  @override
  String get please_log_in => '请登录查看留言';

  @override
  String get pin => '别针';

  @override
  String get unpin => '取消固定';

  @override
  String get delete_chat => '删除聊天记录';

  @override
  String delete_chat_confirm(String name) {
    return '您确定要删除与 $name 的聊天记录吗？此操作无法撤消。';
  }

  @override
  String chat_deleted(String name) {
    return '与 $name 的聊天已删除';
  }

  @override
  String get delete_failed => '删除聊天记录失败';

  @override
  String get no_conversations => '还没有对话';

  @override
  String get start_conversation_hint => '点击 + 按钮开始对话';

  @override
  String get start_conversation => '开始对话';

  @override
  String get yesterday => '昨天';

  @override
  String get unknown => '未知';

  @override
  String get no_messages_yet => '还没有消息';

  @override
  String get unblock_user => '解除阻止用户';

  @override
  String get block_user => '阻止用户';

  @override
  String get no_blocked_users => '没有被阻止的用户';

  @override
  String get blocked_users_hint => '您阻止的用户将显示在此处';

  @override
  String unblock_user_confirm(String username) {
    return '您确定要解锁 $username 吗？您将能够再次收到他们的消息。';
  }

  @override
  String user_unblocked(String username) {
    return '$username 已解锁';
  }

  @override
  String user_blocked(String username) {
    return '$username 已被阻止';
  }

  @override
  String get failed_to_unblock => '无法解锁用户';

  @override
  String get failed_to_block => '阻止用户失败';

  @override
  String get chat_info => '聊天信息';

  @override
  String get delete_message => '删除留言';

  @override
  String get delete_message_confirm => '您确定要删除此消息吗？';

  @override
  String get typing => '打字...';

  @override
  String get online => '在线的';

  @override
  String get offline => '离线';

  @override
  String last_seen_at(String time) {
    return '最后一次见到 $time';
  }

  @override
  String participants(int count) {
    return '$count 参与者';
  }

  @override
  String get you_are_blocked => '你被屏蔽了';

  @override
  String user_blocked_you(String username) {
    return '$username 已阻止您。您无法发送消息。';
  }

  @override
  String you_blocked_user(String username) {
    return '您已屏蔽 $username';
  }

  @override
  String get cannot_send_messages_blocked => '您无法发送消息。您已被阻止。';

  @override
  String get this_message_was_deleted => '此消息已被删除';

  @override
  String get edit => '编辑';

  @override
  String get reply => '回复';

  @override
  String get editing_message => '编辑消息';

  @override
  String replying_to(String username) {
    return '回复$username';
  }

  @override
  String get voice => '嗓音';

  @override
  String get emoji => '表情符号';

  @override
  String get photo => '📷 照片';

  @override
  String get voice_message => '🎤 语音留言';

  @override
  String get searching => '正在寻找...';

  @override
  String get loading_users => '正在加载用户...';

  @override
  String search_failed(String error) {
    return '搜索失败：$error';
  }

  @override
  String get invalid_user_data => '用户数据无效';

  @override
  String failed_to_start_chat(String error) {
    return '无法开始聊天：$error';
  }

  @override
  String get audio_file_not_available => '音频文件不可用';

  @override
  String failed_to_play_audio(String error) {
    return '音频播放失败：$error';
  }

  @override
  String get image_unavailable => '图片不可用';

  @override
  String get image_too_large => '❌ 图片太大。最大大小为 10MB';

  @override
  String get image_file_not_found => '❌ 找不到图像文件';

  @override
  String get uploading_image => '正在上传图片...';

  @override
  String get image_sent => '✅ 图片已发送！';

  @override
  String get failed_to_send_image => '❌ 发送图片失败';

  @override
  String get uploading_voice_message => '正在上传语音留言...';

  @override
  String get voice_message_sent => '✅ 语音消息已发送！';

  @override
  String get failed_to_send_voice_message => '❌ 发送语音消息失败';

  @override
  String get recording => '🎙️录制中...';

  @override
  String get microphone_permission_denied => '麦克风权限被拒绝';

  @override
  String get starting_chat => '开始聊天...';

  @override
  String get refresh_users => '刷新用户';

  @override
  String get search_by_username_or_phone => '按用户名或电话号码搜索';

  @override
  String get no_users_found => '没有找到用户';

  @override
  String get try_different_search_term => '尝试不同的搜索词';

  @override
  String get no_users_available => '没有可用的用户';

  @override
  String get chat_exists => '聊天已存在';

  @override
  String block_user_confirm(String username) {
    return '您确定要阻止 $username 吗？您将不会收到他们的消息，并且他们将从您的聊天列表中删除。';
  }

  @override
  String chat_room_label(String name) {
    return '聊天室：$name';
  }

  @override
  String id_label(int id) {
    return '编号：$id';
  }

  @override
  String get participants_label => '参加者：';

  @override
  String get type_a_message => '输入消息...';

  @override
  String get edit_message_hint => '编辑留言...';

  @override
  String error_label(String error) {
    return '错误：$error';
  }

  @override
  String get copy => '复制';

  @override
  String comments_title(int count) {
    return '评论 ($count)';
  }

  @override
  String get reply_button => '回复';

  @override
  String replies_count(int count) {
    return '$count 回复';
  }

  @override
  String get you_label => '你';

  @override
  String get delete_reply_title => '删除回复';

  @override
  String get delete_comment_title => '删除评论';

  @override
  String get unknown_date => '日期未知';

  @override
  String get press_enter_to_send => '按 Enter 发送';

  @override
  String get comment_add_error => '添加评论失败';

  @override
  String get service_provider => '服务提供商';

  @override
  String get opening_chat => '正在打开聊天...';

  @override
  String get failed_to_refresh => '刷新失败';

  @override
  String get cannot_chat_with_yourself => '你无法与自己聊天';

  @override
  String opening_chat_with(String username) {
    return '打开与 $username 的聊天...';
  }

  @override
  String get this_will_only_take_a_moment => '这只需要一点时间';

  @override
  String get unable_to_start_chat => '无法开始聊天。请再试一次。';

  @override
  String get profile_listings => '房源';

  @override
  String get profile_followers => '追随者';

  @override
  String get profile_following => '下列的';

  @override
  String get profile_no_products => '没有产品';

  @override
  String get profile_no_services => '无服务';

  @override
  String get profile_no_properties => '无属性';

  @override
  String get profile_user_no_products => '该用户尚未发布任何产品';

  @override
  String get profile_user_no_services => '该用户尚未发布任何服务';

  @override
  String get profile_user_no_properties => '该用户尚未发布任何房产';

  @override
  String get profile_error_occurred => '发生错误';

  @override
  String get profile_error_loading_products => '加载产品时出错';

  @override
  String get profile_error_loading_services => '加载服务时出错';

  @override
  String get profile_no_followers_yet => '还没有关注者';

  @override
  String get profile_no_following_yet => '尚未关注任何人';

  @override
  String get profile_follow => '跟随';

  @override
  String get profile_following_btn => '下列的';

  @override
  String get profile_message => '信息';

  @override
  String get profile_member_since => '会员自';

  @override
  String get profile_loading_error => '加载配置文件时出错';

  @override
  String get profile_retry => '再试一次';

  @override
  String get profile_share => '分享';

  @override
  String get profile_copy_link => '复制链接';

  @override
  String get profile_report => '报告';

  @override
  String get linkCopied => '链接已复制到剪贴板';

  @override
  String get checkOutProfile => '查看';

  @override
  String get onTezsell => '在 TezSell 上';

  @override
  String get selectCountryFirst => '首先选择国家';

  @override
  String get countrySelectionHint => '然后你可以选择你的地区';

  @override
  String get something_went_wrong => '出了点问题';

  @override
  String get check_connection_and_retry => '请检查您的互联网连接并重试';

  @override
  String get sold_badge => '卖';

  @override
  String get more_categories => '更多的';

  @override
  String no_products_in_location(String location) {
    return '在 $location 中找不到产品';
  }

  @override
  String get no_more_products => '没有更多产品可加载';

  @override
  String time_days_ago(int count) {
    return '$count 天前';
  }

  @override
  String time_hours_ago(int count) {
    return '$count小时前';
  }

  @override
  String time_minutes_ago(int count) {
    return '$count分钟前';
  }

  @override
  String get time_just_now => '现在';

  @override
  String no_services_in_location(String location) {
    return '在 $location 中找不到服务';
  }

  @override
  String get no_more_services => '无需加载更多服务';

  @override
  String get error_loading_more_services => '加载更多服务时出错';

  @override
  String get verification_code_length => '验证码必须为6位';

  @override
  String get map_register_title => '你住在哪里？';

  @override
  String get map_register_headline => '在地图上选择您的街区';

  @override
  String get map_register_subtitle => '我们用它来向您展示附近的买家和卖家。您可以稍后调整半径。';

  @override
  String get pick_on_map => '在地图上选择';

  @override
  String get pick_again => '再次选择';

  @override
  String get resolving_location => '正在解决位置...';

  @override
  String get use_dropdown_instead => '使用下拉菜单代替';

  @override
  String country_not_supported(String country) {
    return '我们还不支持 $country。';
  }

  @override
  String get region_not_auto_detected => '无法自动检测您的区域 - 手动选择。';

  @override
  String get district_not_auto_detected => '无法自动检测您的地区 - 请手动选择。';

  @override
  String get browse_no_items_with_location => '该区域还没有包含位置数据的项目。';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => '设置位置';

  @override
  String get location_picker_confirm => '确认位置';

  @override
  String get location_picker_resolve_failed => '无法解析地址 - 请重新选择或仅使用坐标进行确认';

  @override
  String get location_picker_selected_fallback => '所选地点';

  @override
  String get location_permission_denied => '位置权限被拒绝';

  @override
  String get location_permission_denied_settings => '位置权限被拒绝 - 请在“设置”中启用';

  @override
  String get location_permission_permanent => '位置永久被拒绝 — 打开“设置”以启用';

  @override
  String gps_error(String error) {
    return 'GPS 错误：$error';
  }

  @override
  String get verify_neighborhood_title => '验证您的邻居';

  @override
  String get verify_neighborhood_subtitle => '站在你家附近。我们将检查您的 GPS 并要求您确认。';

  @override
  String get verify_neighborhood_button => '验证邻居';

  @override
  String get verify_neighborhood_low_confidence => '继续低信心';

  @override
  String get verify_neighborhood_retry => '重试';

  @override
  String get verify_neighborhood_youre_in => '你在：';

  @override
  String verify_neighborhood_done(String name) {
    return '已验证！ $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'GPS精度为${meters}m（需要≤100m）。移至空旷区域并重试。';
  }

  @override
  String get neighborhood_not_identified => '无法识别您所在位置的街区。';

  @override
  String get unknown_error => '未知错误';

  @override
  String get place_search_hint => '搜索地址或地点';

  @override
  String get place_search_unavailable => '搜索不可用 — 改为放置图钉';

  @override
  String get radius_slider_city => '城市';

  @override
  String radius_slider_km(String value) {
    return '$value公里';
  }

  @override
  String get my_neighborhoods => '我的社区';

  @override
  String get manage_on_map => '在地图上管理';

  @override
  String get no_neighborhoods_yet => '尚无已验证的社区。打开地图验证您所在的位置。';

  @override
  String get open_map_to_verify => '打开地图验证新位置';

  @override
  String get verify_here => '在此验证';

  @override
  String get verify_new_location => '验证新位置';

  @override
  String eviction_warning(String name) {
    return '添加此位置将删除$name（最早的）。此操作无法撤消。';
  }

  @override
  String get verified_today => '今天已验证';

  @override
  String get verified_yesterday => '昨天已验证';

  @override
  String verified_n_days_ago(int days) {
    return '$days天前已验证';
  }

  @override
  String get active_neighborhood => '活跃';

  @override
  String switch_neighborhood_success(String name) {
    return '已切换到$name';
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
}
