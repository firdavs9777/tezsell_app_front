// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get welcome => 'いらっしゃいませ';

  @override
  String get welcomeBack => 'おかえり！';

  @override
  String get loginToYourAccount => '続行するにはログインしてください';

  @override
  String get or => 'または';

  @override
  String get dontHaveAccount => 'アカウントをお持ちでない場合は、';

  @override
  String get chooseLanguage => '言語を選択してください';

  @override
  String get selectPreferredLanguage => 'アプリの優先言語を選択してください';

  @override
  String get continueButton => '続く';

  @override
  String get continueWithGoogle => 'Google を続ける';

  @override
  String get continueWithApple => 'Apple で続行';

  @override
  String get continueWithEmail => 'メールで続行';

  @override
  String get sellAndBuyProducts => '貴社の製品の販売および購入は当社でのみ行ってください';

  @override
  String get usedProductsMarket => '中古品または中古市場';

  @override
  String get home_welcome_title => 'あなたの近所のマーケットプレイス';

  @override
  String get home_welcome_subtitle => '近くの人と一緒に売買しましょう。\n安全、シンプル、そしてローカル。';

  @override
  String get home_get_started => '始めましょう';

  @override
  String get home_sign_in => 'すでにアカウントを持っています';

  @override
  String get home_terms_notice => '続行すると、サービス利用規約とプライバシー ポリシーに同意したことになります。';

  @override
  String get register => '登録する';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちです';

  @override
  String get login => 'ログイン';

  @override
  String get loginToAccount => 'アカウントにログイン';

  @override
  String get enterPhoneNumber => '電話番号を入力してください';

  @override
  String get password => 'パスワード';

  @override
  String get enterPassword => 'パスワードを入力してください';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get registerNow => '今すぐ登録';

  @override
  String get loading => '読み込み中...';

  @override
  String get pleaseEnterPhoneNumber => '電話番号を入力してください';

  @override
  String get pleaseEnterPassword => 'パスワードを入力してください';

  @override
  String get unexpectedError => '予期しないエラーが発生しました。もう一度試してください。';

  @override
  String get forgotPasswordComingSoon => 'パスワードを忘れた場合の機能は近日公開予定';

  @override
  String get selectedCountryLabel => '選択済み:';

  @override
  String get fullPhoneLabel => '満杯：';

  @override
  String get home => '家';

  @override
  String get settings => '設定';

  @override
  String get profile => 'プロフィール';

  @override
  String get search => '検索';

  @override
  String get notifications => '通知';

  @override
  String get error => 'エラー';

  @override
  String get retry => 'リトライ';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get appTitle => 'テッセル';

  @override
  String get selectRegion => '地域を選択してください';

  @override
  String get searchHint => '地区または都市を検索する';

  @override
  String get apiError => 'APIの呼び出し中に問題が発生しました';

  @override
  String get ok => 'わかりました';

  @override
  String get emptyList => '空のリスト';

  @override
  String get dataLoadingError => 'データの読み込み中にエラーが発生しました';

  @override
  String get confirm => '確認する';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String confirmRegionSelection(Object regionName) {
    return '$regionName 地域を選択しますか?';
  }

  @override
  String get selectDistrictOrCity => 'あなたの地区または都市を選択してください';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return '$regionName 領域 - $districtName を選択しますか?';
  }

  @override
  String get noResultsFound => '結果が見つかりませんでした。';

  @override
  String errorWithCode(String errorCode) {
    return 'エラー: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'データのロードに失敗しました。エラー: $error';
  }

  @override
  String get phoneVerification => '電話番号認証';

  @override
  String get enterPhonePrompt => '電話番号を入力してください';

  @override
  String get enterPhoneNumberHint => '電話番号を入力してください';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return '選択済み: $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'あなたの国を選択してください';

  @override
  String get changeCountry => '国を変更する';

  @override
  String get country => '国';

  @override
  String get allCountries => 'すべての国';

  @override
  String get currencyRUB => 'ロシアルーブル';

  @override
  String get currencyUAH => 'ウクライナ・グリブナ';

  @override
  String get currencyBYN => 'ベラルーシルーブル';

  @override
  String get currencyMDL => 'モルドバ・レウ';

  @override
  String get currencyGEL => 'グルジアラリ';

  @override
  String get currencyAMD => 'アルメニアン ドラム';

  @override
  String get currencyAZN => 'アゼルバイジャン マナト';

  @override
  String get currencyKZT => 'カザフスタン テンゲ';

  @override
  String get currencyTMT => 'トルクメンマナト';

  @override
  String get currencyKGS => 'キルギスタンのソム';

  @override
  String get currencyTJS => 'タジキスタンのソモニ';

  @override
  String get currencyUZS => 'ウズベキスタン・ソム';

  @override
  String get currencyUSD => '米ドル';

  @override
  String get currencyEUR => 'ユーロ';

  @override
  String fullNumber(String phoneNumber) {
    return '完全な番号: $phoneNumber';
  }

  @override
  String get sendCode => 'コードを送信する';

  @override
  String get enterVerificationCode => '確認コードを入力してください';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'コードを再送信する';

  @override
  String expires(String time) {
    return '有効期限: $time';
  }

  @override
  String get verifyAndContinue => '確認して続行';

  @override
  String get invalidVerificationCode => '無効な確認コード';

  @override
  String get verificationCodeSent => '確認コードが正常に送信されました';

  @override
  String get failedToSendCode => '確認コードの送信に失敗しました';

  @override
  String get verificationCodeResent => '確認コードが正常に再送信されました';

  @override
  String get failedToResendCode => '確認コードの再送信に失敗しました';

  @override
  String get passwordVerification => 'パスワードの検証';

  @override
  String get completeRegistrationPrompt => 'ユーザー名とパスワードを入力して登録を完了します';

  @override
  String get username => 'ユーザー名';

  @override
  String get username_required => 'ユーザー名は必須です';

  @override
  String get username_min_length => 'ユーザー名は少なくとも 2 文字である必要があります';

  @override
  String get usernameHint => 'ユーザー名123';

  @override
  String get confirmPassword => 'パスワードを認証する';

  @override
  String get profileImage => 'プロフィール画像';

  @override
  String get imageInstructions => 'ここに画像が表示されます。プロフィール画像を押してください';

  @override
  String get finish => '仕上げる';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get registrationError => '登録エラー';

  @override
  String get about => '私たちについて';

  @override
  String get chat => 'チャット';

  @override
  String get realEstate => '不動産';

  @override
  String get language => '英語';

  @override
  String get languageEn => '英語';

  @override
  String get languageRu => 'ロシア';

  @override
  String get languageUz => 'ウズベク語';

  @override
  String get serviceLiked => '気に入ったサービス';

  @override
  String get support => 'サポート';

  @override
  String get service => 'ビジネスサービス';

  @override
  String get aboutContent =>
      'TezSell は、新品および中古製品を売買できる迅速かつ簡単なマーケットプレイスです。私たちの使命は、すべてのユーザーにとって最も便利で効率的なプラットフォームを作成し、スムーズな取引とユーザーフレンドリーなエクスペリエンスを保証することです。販売する場合でも購入する場合でも、TezSell を使用すると、わずか数ステップで簡単に接続して取引を完了できます。当社はユーザーのセキュリティとプライバシーを優先します。すべての取引は安全性とコンプライアンスを確保するために注意深く監視されており、買い手と売り手の両方に安心感を提供します。シンプルで直感的なインターフェイスにより、ユーザーは製品をすばやくリストし、必要なものを見つけることができます。また、Telegram を介したリアルタイムのコミュニケーションも促進し、売買プロセスをさらにスムーズにします。';

  @override
  String get errorMessage => 'エラーが発生しました。サーバーを確認してください';

  @override
  String get searchLocation => '位置';

  @override
  String get searchCategory => 'カテゴリー';

  @override
  String get searchProductPlaceholder => '製品を探す';

  @override
  String get searchServicePlaceholder => 'サービスを探す';

  @override
  String get search_products_subtitle => '近所のお得な情報を見つける';

  @override
  String get search_services_subtitle => '近所の専門家を探す';

  @override
  String get search_products_error => '製品検索エラー';

  @override
  String get search_services_error => 'サービス検索エラー';

  @override
  String get load_more_products_error => 'さらに製品を読み込むときにエラーが発生しました';

  @override
  String get load_more_services_error => 'さらにサービスをロード中にエラーが発生しました';

  @override
  String get try_different_keywords => '別のキーワードを試してください';

  @override
  String get searchText => '検索';

  @override
  String get selectedCategory => '選択したカテゴリ:';

  @override
  String get selectedLocation => '選択した場所:';

  @override
  String get productError => '利用可能な製品はありません';

  @override
  String get serviceError => '利用できるサービスはありません';

  @override
  String get locationHeader => '場所を選択してください';

  @override
  String get locationPlaceholder => '地域検索はこちらから';

  @override
  String get categoryHeader => 'カテゴリを選択してください';

  @override
  String get categoryPlaceholder => '検索カテゴリ';

  @override
  String get categoryError => '利用可能なカテゴリがありません';

  @override
  String get paginationFirst => '初め';

  @override
  String get paginationPrevious => '前の';

  @override
  String get pageInfo => 'のページ';

  @override
  String get pageNext => '次';

  @override
  String get pageLast => '最後';

  @override
  String get loadingMessageProduct => '製品を読み込み中...';

  @override
  String get loadingMessageError => '読み込み中のエラー';

  @override
  String get likeProductError => '製品をお気に入りに登録中にエラーが発生しました';

  @override
  String get dislikeProductError => '製品が嫌いなときにエラーが発生しました';

  @override
  String get loadingMessageLocation => '場所を読み込んでいます...';

  @override
  String get loadingLocationError => '場所の読み込み中にエラーが発生しました';

  @override
  String get loadingMessageCategory => 'カテゴリを読み込んでいます...';

  @override
  String get loadingCategoryError => 'カテゴリの読み込みエラー:';

  @override
  String get profileUpdateSuccessMessage => 'プロファイルが正常に更新されました';

  @override
  String get profileUpdateFailMessage => 'プロフィールの更新に失敗しました';

  @override
  String get seeMoreBtn => 'もっと見る';

  @override
  String get profilePageTitle => 'プロフィールページ';

  @override
  String get editProfileModalTitle => 'プロフィールの編集';

  @override
  String get usernameLabel => 'ユーザー名';

  @override
  String get locationLabel => '現在地';

  @override
  String get profileImageLabel => 'プロフィール画像';

  @override
  String get chooseFileLabel => 'ファイルを選択してください';

  @override
  String get uploadBtnLabel => 'アップデート';

  @override
  String get uploadingBtnLabel => '更新中...';

  @override
  String get cancelBtnLabel => 'キャンセル';

  @override
  String get productsTitle => '製品';

  @override
  String get servicesTitle => 'サービス';

  @override
  String get myProductsTitle => '私の製品';

  @override
  String get myServicesTitle => '私のサービス';

  @override
  String get favoriteProductsTitle => 'お気に入りの製品';

  @override
  String get favoriteServicesTitle => 'お気に入りのサービス';

  @override
  String get noFavorites => 'お気に入りがありません';

  @override
  String get addNewProductBtn => '新しい製品を追加';

  @override
  String get addNew => '新しい';

  @override
  String get addNewServiceBtn => '新しいサービスを追加する';

  @override
  String get downloadMobileApp => 'モバイルアプリをダウンロードする';

  @override
  String get registerPhoneNumberSuccess => '電話番号認証されました！次のステップに進むことができます。';

  @override
  String get regionSelectedMessage => '選択された地域:';

  @override
  String get districtSelectMessage => '選択された地区:';

  @override
  String get phoneNumberEmptyMessage => '続行する前に電話番号を確認してください';

  @override
  String get regionEmptyMessage => '最初に地域を選択してください';

  @override
  String get districtEmptyMessage => '地区を選択してください';

  @override
  String get usernamePasswordEmptyMessage => 'ユーザー名とパスワードを入力してください';

  @override
  String get registerTitle => '登録する';

  @override
  String get previousButton => '前の';

  @override
  String get nextButton => '次';

  @override
  String get completeButton => '完了';

  @override
  String stepIndicator(int currentStep) {
    return 'ステップ $currentStep (4 つ中)';
  }

  @override
  String get districtSelectTitle => '地区リスト';

  @override
  String get districtSelectParagraph => '地区を選択してください:';

  @override
  String get phoneNumber => '電話番号';

  @override
  String get sendOtp => 'OTPを送信する';

  @override
  String get sendAgain => '再送信';

  @override
  String get verify => '確認する';

  @override
  String get failedToSendOtp => 'OTPの送信に失敗しました。サーバーは false を返しました。';

  @override
  String get errorSendingOtp => 'OTP の送信中にエラーが発生しました。';

  @override
  String get invalidPhoneNumber => '有効な電話番号を入力してください。';

  @override
  String get verificationSuccess => '正常に検証されました';

  @override
  String get verificationError => 'エラーが発生しました。後でもう一度試してください。';

  @override
  String get regionsList => '地域リスト';

  @override
  String get enterUsername => 'ユーザー名を入力してください';

  @override
  String get welcomeMessage => 'Tezsell へようこそ。電話番号でログインしてください';

  @override
  String get noAccount => 'まだアカウントをお持ちですか?ここに登録してください';

  @override
  String get successLogin => '正常にログに記録されました';

  @override
  String get myProfile => '私のプロフィール';

  @override
  String get logout => 'ログアウト';

  @override
  String get newProductTitle => 'タイトル';

  @override
  String get newProductDescription => '説明';

  @override
  String get newProductPrice => '価格';

  @override
  String get newProductCondition => '状態';

  @override
  String get newProductCategory => 'カテゴリ';

  @override
  String get newProductImages => '画像';

  @override
  String get addNewService => '新しいサービスを追加する';

  @override
  String get creating => '作成...';

  @override
  String get serviceName => 'サービス名';

  @override
  String get serviceNamePlaceholder => 'サービスタイトルを入力してください';

  @override
  String get serviceDescription => 'サービスの説明';

  @override
  String get serviceDescriptionPlaceholder => 'サービスの説明を入力してください';

  @override
  String get serviceCategory => 'サービスカテゴリー';

  @override
  String get selectCategory => 'カテゴリを選択してください';

  @override
  String get loadingCategories => '読み込み中...';

  @override
  String get errorLoadingCategories => 'カテゴリの読み込みエラー';

  @override
  String get serviceImages => 'サービスイメージ';

  @override
  String get imageUploadHelper => '+ アイコンをクリックして画像を追加します (最大 10 件)';

  @override
  String get maxImagesError => '最大10枚の画像をアップロードできます';

  @override
  String get categoryNotFound => 'カテゴリが見つかりません';

  @override
  String get productCreatedSuccess => '製品が正常に作成されました';

  @override
  String get productLikeSuccess => '製品が正常に気に入りました';

  @override
  String get productDislikeSuccess => '製品は正常に嫌われました';

  @override
  String get errorCreatingService => 'サービスの作成中にエラーが発生しました';

  @override
  String get errorCreatingProduct => '製品作成中にエラーが発生しました';

  @override
  String get unknownError => 'サービスの作成中に不明なエラーが発生しました';

  @override
  String get submit => '提出する';

  @override
  String get selectCategoryAction => 'カテゴリの選択';

  @override
  String get selectCondition => '条件の選択';

  @override
  String get sum => '和';

  @override
  String get noComments => 'コメントはまだありません。最初にコメントしてみませんか!';

  @override
  String get commentLikeSuccess => 'コメントが正常に気に入りました';

  @override
  String get commentLikeError => 'コメントにいいねをするときにエラーが発生しました';

  @override
  String get unknownErrorMessage => '不明なエラーが発生しました';

  @override
  String get commentDislikeSuccess => 'コメントが正常に拒否されました';

  @override
  String get commentDislikeError => 'コメントを嫌う際のエラー';

  @override
  String get replyInfo => '最初に返信を入力してください';

  @override
  String get replySuccessMessage => '返信が正常に追加されました';

  @override
  String get replyErrorMessage => '返信の作成中にエラーが発生しました';

  @override
  String get commentUpdateSuccess => 'コメントが正常に更新されました';

  @override
  String get commentUpdateError => 'コメント項目の更新中にエラーが発生しました';

  @override
  String get deleteConfirmationMessage => 'このコメントを削除してもよろしいですか?';

  @override
  String get commentDeleteSuccess => 'コメントは正常に削除されました';

  @override
  String get commentDeleteError => 'コメント削除エラー';

  @override
  String get editLabel => '編集';

  @override
  String get deleteLabel => '消去';

  @override
  String get saveLabel => '保存';

  @override
  String get replyLabel => '返事';

  @override
  String get replyTitle => '返信する';

  @override
  String get replyPlaceholder => '返信を書いてください...';

  @override
  String get chatLoginMessage => 'チャットを開始するにはログインする必要があります';

  @override
  String get chatYourselfMessage => '自分自身とチャットすることはできません。';

  @override
  String get chatRoomMessage => 'チャットルームができました！';

  @override
  String get chatRoomError => 'チャットの作成に失敗しました!';

  @override
  String get chatCreationError => 'チャットの作成に失敗しました!';

  @override
  String get productsTotal => '製品合計';

  @override
  String get perPage => 'アイテム';

  @override
  String get clearAllFilters => 'すべてのフィルターをクリア';

  @override
  String get clickToUpload => 'クリックしてアップロード';

  @override
  String get productInStock => '在庫あり';

  @override
  String get productOutStock => '在庫切れ';

  @override
  String get productBack => '製品に戻る';

  @override
  String get messageSeller => 'チャット';

  @override
  String get recommendedProducts => 'おすすめ商品';

  @override
  String get deleteConfirmationProduct => 'この商品を削除してもよろしいですか?';

  @override
  String get productDeleteSuccess => '製品は正常に削除されました';

  @override
  String get productDeleteError => '製品の削除中にエラーが発生しました';

  @override
  String get newCondition => '新しい';

  @override
  String get used => '使用済み';

  @override
  String get imageValidType =>
      '一部のファイルが追加されませんでした。 5MB以下のJPG、PNG、GIF、またはWebPファイルを使用してください。';

  @override
  String get imageConfirmMessage => 'この画像を削除してもよろしいですか?';

  @override
  String get titleRequiredMessage => 'タイトルは必須です';

  @override
  String get descRequiredMessage => '説明は必須です';

  @override
  String get priceRequiredMessage => '価格は必須です';

  @override
  String get conditionRequiredMessage => '条件は必須です';

  @override
  String get pleaseFillAllRequired => '必須フィールドに入力してください';

  @override
  String get oneImageConfirmMessage => '少なくとも 1 つの製品画像が必要です';

  @override
  String get categoryRequiredMessage => 'カテゴリは必須です';

  @override
  String get locationInfoError => 'ユーザーの位置情報が欠落しています';

  @override
  String get editProductTitle => '製品の編集';

  @override
  String get imageUploadRequirements =>
      '少なくとも 1 つの画像が必要です。最大 10 枚の画像 (それぞれ 5MB 未満の JPG、PNG、GIF、WebP) をアップロードできます。';

  @override
  String get productUpdatedSuccess => '製品が正常に更新されました';

  @override
  String get productUpdateFailed => '製品のアップデートに失敗しました';

  @override
  String get errorUpdatingProduct => '製品のアップデート中にエラーが発生しました';

  @override
  String get serviceBack => 'サービスに戻る';

  @override
  String get likeLabel => 'のように';

  @override
  String get commentsLabel => 'コメント';

  @override
  String get writeComment => 'コメントを書いてください...';

  @override
  String get postingLabel => '投稿中...';

  @override
  String get commentCreated => 'コメントが作成されました';

  @override
  String get postCommentLabel => 'コメントを投稿する';

  @override
  String get loginPrompt => 'コメントを表示および投稿するにはログインしてください。';

  @override
  String get recommendedServices => 'おすすめサービス';

  @override
  String get commentsVisibilityNotice => 'コメントはログインしたユーザーのみに表示されます。';

  @override
  String get comingSoon => '近日公開';

  @override
  String get serviceUpdateSuccess => 'サービスが正常に更新されました';

  @override
  String get serviceUpdateError => 'サービス項目の更新中にエラーが発生しました';

  @override
  String get editServiceModalTitle => 'サービスの編集';

  @override
  String get enterPhoneNumberWithoutCode => 'コードなしの電話番号を入力してください';

  @override
  String get heroTitle => 'テズセル';

  @override
  String get heroSubtitle => 'ウズベキスタン向けの迅速かつ簡単なマーケットプレイス';

  @override
  String get startSelling => '販売を開始する';

  @override
  String get browseProducts => '製品を閲覧する';

  @override
  String get featuresTitle => 'TezSell を選ぶ理由';

  @override
  String get listingTitle => 'シンプルな商品リスト';

  @override
  String get listingDescription =>
      '数回クリックするだけでアイテムをリストできます。写真を追加し、価格を設定すれば、すぐに購入者とつながります。';

  @override
  String get locationTitle => '位置ベースのブラウジング';

  @override
  String get locationDescription =>
      'お近くのお買い得品を見つけてください。当社の位置ベースのシステムは、近所のアイテムを見つけるのに役立ちます。';

  @override
  String get location_subtitle => '地域と地区を選択すると、近くのリストが表示されます';

  @override
  String get categoryTitle => 'カテゴリフィルタリング';

  @override
  String get categoryDescription => 'さまざまなカテゴリを簡単に移動して、探しているものを正確に見つけます。';

  @override
  String get inspirationTitle => '韓国のニンジン市場からインスピレーションを得た';

  @override
  String get inspirationDescription1 =>
      '私たちは、韓国の成功したニンジン市場 (당근마켓) からインスピレーションを得て TezSell を構築しましたが、特にウズベキスタンの地元コミュニティの固有のニーズを満たすように調整しました。';

  @override
  String get inspirationDescription2 =>
      '私たちの使命は、隣人同士が簡単に売買し、つながりを持てる、信頼できるプラットフォームを作成することです。';

  @override
  String get comingSoonTitle => 'TezSell に近日登場予定';

  @override
  String get inAppChat => 'アプリ内チャット';

  @override
  String get secureTransactions => '安全なトランザクション';

  @override
  String get realEstateListings => '不動産物件情報';

  @override
  String get stayUpdated => '最新情報を入手';

  @override
  String get comingSoonBadge => '近日公開';

  @override
  String get ctaTitle => '今すぐ TezSell コミュニティに参加してください!';

  @override
  String get ctaDescription =>
      'ウズベキスタンのより良いマーケットプレイス体験の構築に参加してください。フィードバックを共有して、当社の成長にご協力ください。';

  @override
  String get createAccount => 'アカウントを作成する';

  @override
  String get learnMore => 'もっと詳しく知る';

  @override
  String get replyUpdateSuccess => '返信が正常に更新されました';

  @override
  String get replyUpdateError => '返信を更新できませんでした';

  @override
  String get replyDeleteSuccess => '返信は正常に削除されました';

  @override
  String get replyDeleteError => '返信の削除に失敗しました';

  @override
  String get replyDeleteConfirmation => 'この返信を削除してもよろしいですか?';

  @override
  String get authenticationRequired => '認証が必要です';

  @override
  String get enterValidReply => '有効な返信テキストを入力してください';

  @override
  String get saving => '保存中...';

  @override
  String get deleting => '削除中...';

  @override
  String get properties => 'プロパティ';

  @override
  String get agents => 'エージェント';

  @override
  String get becomeAgent => 'エージェントになる';

  @override
  String get main => '主要';

  @override
  String get upload => 'アップロード';

  @override
  String get filtered_products => 'フィルタリングされた製品';

  @override
  String get filtered_services => 'フィルタリングされたサービス';

  @override
  String get productDetail => '製品詳細';

  @override
  String get unknownUser => '不明なユーザー';

  @override
  String get locationNotAvailable => '場所が利用できません';

  @override
  String get noTitle => 'タイトルなし';

  @override
  String get noCategory => 'カテゴリなし';

  @override
  String get noDescription => '説明なし';

  @override
  String get som => 'ソム';

  @override
  String get about_me => '私について';

  @override
  String get my_name => '私の名前';

  @override
  String get customer_support => 'カスタマーサポート';

  @override
  String get customer_center => 'カスタマーセンター';

  @override
  String get customer_inquiries => 'お問い合わせ';

  @override
  String get customer_terms => '利用規約';

  @override
  String get region => '地域';

  @override
  String get district => '地区';

  @override
  String get tap_change_profile => 'タップして写真を変更します';

  @override
  String get language_settings => '言語設定';

  @override
  String get selectLanguage => '言語を選択してください';

  @override
  String get select_theme => 'テーマの選択';

  @override
  String get theme => 'テーマ';

  @override
  String get location_settings => '位置情報の設定';

  @override
  String get security => '安全';

  @override
  String get data_storage => 'データとストレージ';

  @override
  String get accessibility => 'アクセシビリティ';

  @override
  String get privacy => 'プライバシー';

  @override
  String get light_theme => 'ライト';

  @override
  String get dark_theme => '暗い';

  @override
  String get system_theme => 'システムのデフォルト';

  @override
  String get my_products => '私の製品';

  @override
  String get refresh => 'リフレッシュ';

  @override
  String get delete_product => '製品の削除';

  @override
  String get delete_confirmation => 'この商品を削除してもよろしいですか?';

  @override
  String get delete => '消去';

  @override
  String error_loading_products(String error) {
    return '製品のロード中にエラーが発生しました: $error';
  }

  @override
  String get product_deleted_success => '製品は正常に削除されました';

  @override
  String error_deleting_product(String error) {
    return '製品削除エラー: $error';
  }

  @override
  String get no_products_found => '製品が見つかりませんでした';

  @override
  String get add_first_product => '最初の製品を追加することから始めます';

  @override
  String get no_title => 'タイトルなし';

  @override
  String get no_description => '説明なし';

  @override
  String get in_stock => '在庫あり';

  @override
  String get out_of_stock => '在庫切れ';

  @override
  String get new_condition => '新しい';

  @override
  String get edit_product => '製品の編集';

  @override
  String get delete_product_tooltip => '製品の削除';

  @override
  String get sum_currency => '和';

  @override
  String get edit_product_title => '製品の編集';

  @override
  String get product_name => '製品名';

  @override
  String get product_description => '製品説明';

  @override
  String get price => '価格';

  @override
  String get condition => '状態';

  @override
  String get condition_new => '新しい';

  @override
  String get condition_used => '使用済み';

  @override
  String get condition_refurbished => '改装済み';

  @override
  String get currency => '通貨';

  @override
  String get category => 'カテゴリ';

  @override
  String get images => '画像';

  @override
  String get existing_images => '既存のイメージ';

  @override
  String get new_images => '新しい画像';

  @override
  String get image_instructions => 'ここに画像が表示されます。上のアップロードアイコンを押してください。';

  @override
  String get update_button => 'アップデート';

  @override
  String loading_category_error(String error) {
    return 'カテゴリの読み込みエラー: $error';
  }

  @override
  String error_picking_images(String error) {
    return '画像選択エラー: $error';
  }

  @override
  String get please_fill_all_required => 'すべてのフィールドに入力してください';

  @override
  String get invalid_price_message => '無効な価格が入力されました。有効な番号を入力してください。';

  @override
  String get category_required_message => '有効なカテゴリを選択してください。';

  @override
  String get one_image_required_message => '少なくとも 1 つの製品画像が必要です';

  @override
  String get product_updated_success => '製品が正常に更新されました';

  @override
  String error_updating_product(String error) {
    return '製品の更新中にエラーが発生しました: $error';
  }

  @override
  String get my_services => '私のサービス';

  @override
  String get delete_service => 'サービスの削除';

  @override
  String get delete_service_confirmation => 'このサービスを削除してもよろしいですか?';

  @override
  String get no_services_found => 'サービスが見つかりませんでした';

  @override
  String get add_first_service => '最初のサービスを追加することから始めます';

  @override
  String get edit_service => 'サービスの編集';

  @override
  String get delete_service_tooltip => 'サービスの削除';

  @override
  String get service_deleted_successfully => 'サービスが正常に削除されました';

  @override
  String get error_deleting_service => 'サービスの削除中にエラーが発生しました';

  @override
  String get error_loading_services => 'サービスの読み込みエラー';

  @override
  String get service_name => 'サービス名';

  @override
  String get enter_service_name => 'サービス名を入力してください';

  @override
  String get service_name_required => 'サービス名は必須です';

  @override
  String get service_name_min_length => 'サービス名は 3 文字以上である必要があります';

  @override
  String get enter_service_description => 'サービスの説明を入力してください';

  @override
  String get service_description_required => 'サービスの説明は必須です';

  @override
  String get service_description_min_length => '説明は 10 文字以上である必要があります';

  @override
  String get category_required => 'カテゴリを選択してください';

  @override
  String get no_categories_available => '利用可能なカテゴリがありません';

  @override
  String get location => '位置';

  @override
  String get select_location => '場所を選択してください';

  @override
  String get location_required => '場所を選択してください';

  @override
  String get no_locations_available => '利用できる場所がありません';

  @override
  String get add_images => '画像の追加';

  @override
  String get current_images => '現在の画像';

  @override
  String get no_images_selected => '画像が選択されていません';

  @override
  String get save_changes => '変更を保存';

  @override
  String get map_main => 'マップとプロパティ';

  @override
  String get agent_status => 'エージェントのステータス';

  @override
  String get admin_panel => '管理者パネル';

  @override
  String get propertiesFound => '見つかったプロパティ';

  @override
  String get propertiesSaved => '保存されたプロパティ';

  @override
  String get saved => '保存されました';

  @override
  String get loadingProperties => 'プロパティを読み込んでいます...';

  @override
  String get failedToLoad => 'プロパティの読み込みに失敗しました。もう一度試してください。';

  @override
  String get noPropertiesFound => 'プロパティが見つかりませんでした';

  @override
  String get tryAdjusting => '検索条件を調整してみてください';

  @override
  String get search_placeholder => 'タイトルや場所で検索...';

  @override
  String get search_filters => 'フィルター';

  @override
  String get search_button => '検索';

  @override
  String get search_clear_filters => 'フィルターをクリアする';

  @override
  String get filter_options_sale_and_rent => '販売とレンタル';

  @override
  String get filter_options_for_sale => '販売用';

  @override
  String get filter_options_for_rent => '賃貸用';

  @override
  String get filter_options_all_types => '全種類';

  @override
  String get filter_options_apartment => 'アパート';

  @override
  String get filter_options_house => '家';

  @override
  String get filter_options_townhouse => 'タウンハウス';

  @override
  String get filter_options_villa => 'ヴィラ';

  @override
  String get filter_options_commercial => 'コマーシャル';

  @override
  String get filter_options_office => 'オフィス';

  @override
  String get property_card_featured => '注目の';

  @override
  String get property_card_bed => '寝室';

  @override
  String get property_card_bath => 'バスルーム';

  @override
  String get property_card_parking => '駐車場';

  @override
  String get property_card_view_details => '詳細を見る';

  @override
  String get property_card_contact => '接触';

  @override
  String get property_card_balcony => 'バルコニー';

  @override
  String get property_card_garage => 'ガレージ';

  @override
  String get property_card_garden => '庭';

  @override
  String get property_card_pool => 'プール';

  @override
  String get property_card_elevator => 'エレベーター';

  @override
  String get property_card_furnished => '家具付き';

  @override
  String get property_card_sales => '販売';

  @override
  String get pricing_month => '/月';

  @override
  String get results_properties_found => '見つかったプロパティ';

  @override
  String get results_properties_saved => '保存されたプロパティ';

  @override
  String get results_saved => '保存されました';

  @override
  String get results_loading_properties => 'プロパティを読み込んでいます...';

  @override
  String get results_failed_to_load => 'プロパティの読み込みに失敗しました。もう一度試してください。';

  @override
  String get results_no_properties_found => 'プロパティが見つかりませんでした';

  @override
  String get results_try_adjusting => '検索条件を調整してみてください';

  @override
  String get no_properties_found => 'プロパティが見つかりませんでした';

  @override
  String get no_category_properties => 'このカテゴリにはプロパティがありません';

  @override
  String get properties_loading => 'プロパティを読み込んでいます...';

  @override
  String get all_properties_loaded => 'すべてのプロパティがロードされました';

  @override
  String n_properties(int count) {
    return '$count プロパティ';
  }

  @override
  String get in_area => 'エリア内';

  @override
  String get pagination_previous => '前の';

  @override
  String get pagination_next => '次';

  @override
  String get pagination_page => 'ページ';

  @override
  String get pagination_page_of => '1ページ目';

  @override
  String get contact_modal_title => '連絡先';

  @override
  String get contact_modal_agent_contact => 'エージェントの連絡先';

  @override
  String get contact_modal_property_owner => '不動産所有者';

  @override
  String get contact_modal_agent_phone_number => 'エージェントの電話番号';

  @override
  String get contact_modal_owner_phone_number => '所有者の電話番号';

  @override
  String get contact_modal_license => 'ライセンス';

  @override
  String get contact_modal_rating => '評価';

  @override
  String get contact_modal_call_now => '今すぐ電話してください';

  @override
  String get contact_modal_copy_number => 'コピー番号';

  @override
  String get contact_modal_close => '近い';

  @override
  String get contact_modal_contact_hours => 'お問い合わせ時間: 9:00 AM - 8:00 PM';

  @override
  String get contact_modal_agent => 'エージェント';

  @override
  String get errors_toggle_save_failed => 'プロパティの保存を切り替えることができませんでした:';

  @override
  String get errors_copy_failed => '電話番号をコピーできませんでした:';

  @override
  String get errors_phone_copied => '電話番号をクリップボードにコピーしました';

  @override
  String get errors_error_occurred_regions => 'リージョンでエラーが発生しました';

  @override
  String get errors_error_occurred_districts => '地区でエラーが発生しました';

  @override
  String get errors_please_fill_all_required_fields => '必須フィールドをすべて入力してください';

  @override
  String get errors_authentication_required => '認証が必要です';

  @override
  String get errors_user_info_missing => 'ユーザー情報が不足しています';

  @override
  String get errors_validation_error => '入力データを確認してください';

  @override
  String get errors_permission_denied => '許可が拒否されました';

  @override
  String get errors_server_error => 'サーバーエラーが発生しました';

  @override
  String get errors_network_error => 'ネットワーク接続エラー';

  @override
  String get errors_timeout_error => 'リクエストのタイムアウトを超えました';

  @override
  String get errors_custom_error => 'エラーが発生しました';

  @override
  String get errors_error_creating_property => 'プロパティの作成中にエラーが発生しました';

  @override
  String get errors_unknown_error_message => '不明なエラーが発生しました';

  @override
  String get errors_coordinates_not_found => 'この住所の座標が見つかりませんでした。手動で入力してください。';

  @override
  String get errors_coordinates_error => '座標の取得中にエラーが発生しました。手動で入力してください。';

  @override
  String get property_info_views => 'ビュー';

  @override
  String get property_info_listed => '上場';

  @override
  String get property_info_price_per_sqm => '/平方メートル';

  @override
  String get property_info_saved => '保存されました';

  @override
  String get property_info_save => '保存';

  @override
  String get property_info_share => '共有';

  @override
  String get loading_loading => '読み込み中...';

  @override
  String get loading_loading_details => '物件の詳細を読み込み中...';

  @override
  String get loading_property_not_found => 'プロパティが見つかりません';

  @override
  String get loading_property_not_found_message => 'お探しの物件は存在しないか、削除されました。';

  @override
  String get loading_back_to_properties => 'プロパティに戻る';

  @override
  String get loading_title => 'エージェントをロード中...';

  @override
  String get loading_message => 'エージェントのリストをロードするまでお待ちください。';

  @override
  String get loading_agent_not_found => 'エージェントが見つかりません';

  @override
  String get property_details_title => '物件詳細';

  @override
  String get property_details_bedrooms => '寝室';

  @override
  String get property_details_bathrooms => 'バスルーム';

  @override
  String get property_details_floor_area => '床面積';

  @override
  String get property_details_parking => '駐車場';

  @override
  String get property_details_basic_information => '基本情報';

  @override
  String get property_details_property_type => 'プロパティの種類:';

  @override
  String get property_details_listing_type => 'リストの種類:';

  @override
  String get property_details_for_sale => '販売用';

  @override
  String get property_details_for_rent => '賃貸用';

  @override
  String get property_details_year_built => '築年数:';

  @override
  String get property_details_floor => '床：';

  @override
  String get property_details_of => 'の';

  @override
  String get property_details_features_amenities => '特徴とアメニティ';

  @override
  String get sections_description => '説明';

  @override
  String get sections_nearby_amenities => '近隣の施設';

  @override
  String get sections_similar_properties => '類似のプロパティ';

  @override
  String get amenities_metro => '地下鉄';

  @override
  String get amenities_school => '学校';

  @override
  String get amenities_hospital => '病院';

  @override
  String get amenities_shopping => '買い物';

  @override
  String get amenities_away => '離れて';

  @override
  String get contact_title => '連絡先';

  @override
  String get contact_professional_listing => 'プロフェッショナルリスト';

  @override
  String get contact_listed_by_agent => '認証済みエージェントによってリストされています';

  @override
  String get contact_by_owner => '所有者による';

  @override
  String get contact_direct_contact => '不動産オーナーとの直接コンタクト';

  @override
  String get contact_property_owner => '不動産所有者';

  @override
  String get contact_call_agent => 'エージェントに電話をかける';

  @override
  String get contact_email_agent => '電子メールエージェント';

  @override
  String get contact_call_owner => '所有者に電話をかける';

  @override
  String get contact_email_owner => '電子メールの所有者';

  @override
  String get contact_send_inquiry => 'お問い合わせを送信';

  @override
  String get property_status_title => '物件のステータス';

  @override
  String get property_status_availability => '可用性：';

  @override
  String get property_status_available => '利用可能';

  @override
  String get property_status_not_available => '利用不可';

  @override
  String get property_status_featured => '注目:';

  @override
  String get property_status_featured_property => '注目の物件';

  @override
  String get property_status_property_id => 'プロパティID:';

  @override
  String get inquiry_title => 'お問い合わせを送信';

  @override
  String get inquiry_inquiry_type => 'お問い合わせの種類';

  @override
  String get inquiry_request_info => '情報のリクエスト';

  @override
  String get inquiry_schedule_viewing => 'スケジュールの閲覧';

  @override
  String get inquiry_make_offer => 'オファーをする';

  @override
  String get inquiry_request_callback => 'リクエストコールバック';

  @override
  String get inquiry_message => 'メッセージ';

  @override
  String get inquiry_message_placeholder => 'この物件へのご興味についてお知らせください...';

  @override
  String get inquiry_offered_price => '提示価格';

  @override
  String get inquiry_enter_offer => 'オファーを入力してください';

  @override
  String get inquiry_preferred_contact_time => 'ご希望の連絡時間 (オプション)';

  @override
  String get inquiry_contact_time_placeholder => '例：平日 9:00 AM - 5:00 PM';

  @override
  String get inquiry_cancel => 'キャンセル';

  @override
  String get inquiry_sending => '送信中...';

  @override
  String get inquiry_send_inquiry => 'お問い合わせを送信';

  @override
  String get inquiry_inquiry_sent_success => 'お問い合わせは正常に送信されました。';

  @override
  String get inquiry_inquiry_sent_error => 'お問い合わせの送信に失敗しました。もう一度試してください。';

  @override
  String get alerts_link_copied => 'プロパティ リンクがクリップボードにコピーされました。';

  @override
  String get alerts_phone_copied => '電話番号がクリップボードにコピーされました!';

  @override
  String get alerts_save_property_failed => 'プロパティを保存できませんでした:';

  @override
  String get alerts_email_subject => 'に関するお問い合わせ:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'こんにちは。\\n\\n$address にある貴社の物件「$title」に興味があります。\\n\\n詳細についてはお問い合わせください。\\n\\nよろしくお願いいたします。';
  }

  @override
  String get related_properties_view_details => '詳細を見る';

  @override
  String get header_property => '夢の物件を見つけよう';

  @override
  String get header_sub_property => 'タシケントの最も魅力的な地域でプレミアム不動産の機会を見つけてください';

  @override
  String get header_title => '不動産業者';

  @override
  String get header_subtitle => '不動産のニーズに応える経験豊富なエージェントを見つける';

  @override
  String get header_agents_found => 'エージェントが見つかりました';

  @override
  String get filters_all_specializations => 'すべての専門分野';

  @override
  String get filters_residential => '居住の';

  @override
  String get filters_commercial => 'コマーシャル';

  @override
  String get filters_luxury => '贅沢';

  @override
  String get filters_investment => '投資';

  @override
  String get filters_any_rating => '任意の評価';

  @override
  String get filters_four_stars => '星4つ以上';

  @override
  String get filters_four_half_stars => '4.5 つ星以上';

  @override
  String get filters_five_stars => '5つ星';

  @override
  String get filters_highest_rated => '最高評価';

  @override
  String get filters_lowest_rated => '最低評価';

  @override
  String get filters_most_sales => '最多販売数';

  @override
  String get filters_most_experience => '最も多くの経験';

  @override
  String get agent_card_verified_agent => '認証済みエージェント';

  @override
  String get agent_card_years_experience => '年の経験';

  @override
  String get agent_card_years => '年';

  @override
  String get agent_card_license => 'ライセンス';

  @override
  String get agent_card_specialization => '専門分野';

  @override
  String get agent_card_view_profile => 'プロフィールを見る';

  @override
  String get agent_card_contact => '接触';

  @override
  String get agent_card_verified => '確認済み';

  @override
  String get no_results_title => 'エージェントが見つかりませんでした';

  @override
  String get no_results_message => '検索条件やフィルターを調整してみてください。';

  @override
  String get error_title => 'エージェントの読み込みエラー';

  @override
  String get error_message => 'エージェントリストの読み込みに失敗しました。もう一度試してください。';

  @override
  String get error_retry => 'リトライ';

  @override
  String get error_default_message => 'エージェントの詳細をロードできませんでした';

  @override
  String get error_try_again => 'もう一度やり直してください';

  @override
  String get notifications_phone_copied => '電話番号をクリップボードにコピーしました';

  @override
  String get notifications_copy_failed => '電話番号をコピーできませんでした:';

  @override
  String get fallback_agent_name => 'エージェント';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'プロパティの送信';

  @override
  String get navigation_submitting => '送信中...';

  @override
  String get navigation_back_to_agents => 'エージェントに戻る';

  @override
  String get agent_profile_verified_agent => '認証済みエージェント';

  @override
  String get agent_profile_contact_agent => 'エージェントに連絡する';

  @override
  String get agent_profile_send_message => 'メッセージを送信する';

  @override
  String get agent_profile_years_experience => '長年の経験';

  @override
  String get agent_profile_properties_sold => '販売物件';

  @override
  String get agent_profile_active_listings => 'アクティブなリスト';

  @override
  String get agent_profile_total_properties => '総特性';

  @override
  String get tabs_overview => '概要';

  @override
  String get tabs_properties => 'プロパティ';

  @override
  String get tabs_reviews => 'レビュー';

  @override
  String get about_agent_title => 'エージェントについて';

  @override
  String get about_agent_agency => '代理店';

  @override
  String get about_agent_license_number => 'ライセンス番号';

  @override
  String get about_agent_specialization => '専門分野';

  @override
  String get about_agent_member_since => 'メンバー歴';

  @override
  String get about_agent_verified_since => '検証日';

  @override
  String get performance_metrics_title => 'パフォーマンス指標';

  @override
  String get performance_metrics_average_rating => '平均評価';

  @override
  String get performance_metrics_properties_sold => '販売物件';

  @override
  String get performance_metrics_active_listings => 'アクティブなリスト';

  @override
  String get performance_metrics_years_experience => '長年の経験';

  @override
  String get contact_info_title => '連絡先';

  @override
  String get contact_info_contact_via_platform => 'プラットフォーム経由で連絡する';

  @override
  String get verification_status_title => '検証ステータス';

  @override
  String get verification_status_verified_agent => '認証済みエージェント';

  @override
  String get verification_status_pending_verification => '検証保留中';

  @override
  String get verification_status_licensed_professional => '認定プロフェッショナル';

  @override
  String get verification_status_registered_agency => '登録代理店';

  @override
  String get quick_actions_title => 'クイックアクション';

  @override
  String get quick_actions_call_now => '今すぐ電話してください';

  @override
  String get quick_actions_send_message => 'メッセージを送信する';

  @override
  String get quick_actions_view_properties => 'プロパティの表示';

  @override
  String get properties_title => 'エージェントのプロパティ';

  @override
  String get properties_loading_properties => 'プロパティを読み込んでいます...';

  @override
  String get properties_no_properties_title => 'プロパティが見つかりません';

  @override
  String get properties_no_properties_message => 'このエージェントのプロパティがここに表示されます。';

  @override
  String get properties_recent_properties_note =>
      '最近の物件を表示しています。すべてのエージェントのプロパティの完全なリストを確認してください。';

  @override
  String get properties_listed => '上場';

  @override
  String get properties_bed => 'ベッド';

  @override
  String get properties_bath => 'バス';

  @override
  String get properties_for_sale => '販売用';

  @override
  String get properties_for_rent => '賃貸用';

  @override
  String get reviews_title => 'お客様のレビュー';

  @override
  String get reviews_no_reviews_title => 'まだレビューはありません';

  @override
  String get reviews_no_reviews_message => 'クライアントのレビューと推奨事項がここに表示されます。';

  @override
  String get fallbacks_agent_name => 'エージェント';

  @override
  String get fallbacks_default_profile_image => '/デフォルト-アバター.png';

  @override
  String get saved_properties_title => '保存されたプロパティ';

  @override
  String get saved_properties_subtitle => 'お気に入りの物件を 1 か所に';

  @override
  String get saved_properties_no_saved_properties => '保存されたプロパティはまだありません';

  @override
  String get saved_properties_start_saving => '探索を開始し、気に入った物件を保存します';

  @override
  String get saved_properties_browse_properties => 'プロパティを参照する';

  @override
  String get saved_properties_saved_on => '保存日';

  @override
  String get auth_login_required => '保存されたプロパティを表示するにはログインしてください';

  @override
  String get auth_login => 'ログイン';

  @override
  String get success_property_unsaved => '保存されたリストからプロパティが削除されました';

  @override
  String get success_property_saved => 'プロパティが正常に保存されました';

  @override
  String get success_phone_copied => '電話番号をコピーしました！';

  @override
  String get success_property_created_success => 'プロパティが正常に作成されました。';

  @override
  String get success_agent_approved => 'エージェントは正常に承認されました';

  @override
  String get success_agent_rejected => 'エージェントは正常に拒否されました';

  @override
  String get steps_step => 'ステップ';

  @override
  String get steps_basic_information => '基本情報';

  @override
  String get steps_location_details => '場所の詳細';

  @override
  String get steps_property_details => '物件詳細';

  @override
  String get steps_property_images => '物件画像';

  @override
  String get basic_info_tell_us_about_property => 'あなたの物件について教えてください';

  @override
  String get basic_info_property_type => 'プロパティの種類';

  @override
  String get basic_info_listing_type => 'リストタイプ';

  @override
  String get basic_info_property_title => '物件のタイトル';

  @override
  String get basic_info_title_placeholder => '物件のわかりやすいタイトルを入力してください';

  @override
  String get basic_info_description => '説明';

  @override
  String get basic_info_description_placeholder => '物件を詳しく説明して...';

  @override
  String get property_types_apartment => 'アパート';

  @override
  String get property_types_house => '家';

  @override
  String get property_types_townhouse => 'タウンハウス';

  @override
  String get property_types_villa => 'ヴィラ';

  @override
  String get property_types_commercial => 'コマーシャル';

  @override
  String get property_types_office => 'オフィス';

  @override
  String get property_types_land => '土地';

  @override
  String get property_types_warehouse => '倉庫';

  @override
  String get listing_types_for_sale => '販売用';

  @override
  String get listing_types_for_rent => '賃貸用';

  @override
  String get location_where_is_property => 'あなたの物件はどこにありますか?';

  @override
  String get location_full_address => '完全な住所';

  @override
  String get location_address_placeholder => '完全な住所を入力してください';

  @override
  String get location_region => '地域';

  @override
  String get location_select_region => '地域を選択してください';

  @override
  String get location_district => '地区';

  @override
  String get location_select_district => '地区を選択してください';

  @override
  String get location_city => '市';

  @override
  String get location_city_placeholder => '市';

  @override
  String get location_loading_regions => 'リージョンをロード中...';

  @override
  String get location_loading_districts => '地区を読み込んでいます...';

  @override
  String get location_map_coordinates => '地図座標';

  @override
  String get location_get_coordinates => '座標を取得する';

  @override
  String get location_latitude => '緯度';

  @override
  String get location_longitude => '経度';

  @override
  String get location_coordinates_set => '座標セット';

  @override
  String get location_location_tips => '場所のヒント';

  @override
  String get location_location_tip_1 =>
      '• 最初に住所を入力し、次に「座標を取得」をクリックすると、地図の位置が自動的に取得されます。';

  @override
  String get location_location_tip_2 => '• 正確な位置がわかっている場合は、手動で座標を入力することもできます。';

  @override
  String get location_location_tip_3 =>
      '• 正確な座標により、購入者は地図上であなたの不動産を見つけることができます';

  @override
  String get property_details_provide_detailed_info => '物件に関する詳しい情報を提供する';

  @override
  String get property_details_total_floors => '総階数';

  @override
  String get property_details_area_m2 => '面積(㎡)';

  @override
  String get property_details_parking_spaces => '駐車スペース';

  @override
  String get property_details_price => '価格';

  @override
  String get property_details_features => '特徴';

  @override
  String get images_add_photos_showcase => '写真を追加して物件を紹介します';

  @override
  String get images_click_to_upload => 'クリックして画像をアップロードします';

  @override
  String get images_max_images_info => '最大 10 枚の画像、JPG、PNG、または WEBP';

  @override
  String get images_main => '主要';

  @override
  String get images_maximum_images_allowed => '最大 10 枚の画像が許可されます';

  @override
  String get admin_dashboard_title => '管理者ダッシュボード';

  @override
  String get admin_dashboard_subtitle => '不動産プラットフォームのリアルタイム概要';

  @override
  String get admin_last_update => '最終更新';

  @override
  String get admin_total_properties => '総特性';

  @override
  String get admin_total_agents => '総エージェント数';

  @override
  String get admin_total_users => '総ユーザー数';

  @override
  String get admin_total_views => '合計視聴数';

  @override
  String get admin_error_loading_dashboard => 'ダッシュボードの読み込みエラー';

  @override
  String get admin_failed_to_load_data => 'ダッシュボードデータのロードに失敗しました';

  @override
  String get admin_avg_sale_price => '平均販売価格';

  @override
  String get admin_avg_sale_price_subtitle => 'すべてのアクティブなリスト';

  @override
  String get admin_total_portfolio_value => 'ポートフォリオ総額';

  @override
  String get admin_total_portfolio_value_subtitle => '結合されたプロパティ値';

  @override
  String get admin_avg_price_per_sqm => '平方メートルあたりの平均価格';

  @override
  String get admin_avg_price_per_sqm_subtitle => '市場レート指標';

  @override
  String get admin_property_types_distribution => 'プロパティの種類の分布';

  @override
  String get admin_properties_by_city => '都市別の物件';

  @override
  String get admin_properties_by_district => '地区別の物件';

  @override
  String get admin_inquiry_types_distribution => 'お問い合わせの種類の分布';

  @override
  String get admin_agent_verification_rate => 'エージェント検証率';

  @override
  String get admin_agent_verification_rate_subtitle => '品質管理';

  @override
  String get admin_inquiry_response_rate => '問い合わせ対応率';

  @override
  String get admin_inquiry_response_rate_subtitle => '顧客サービス';

  @override
  String get admin_avg_views_per_property => 'プロパティごとの平均ビュー数';

  @override
  String get admin_avg_views_per_property_subtitle => '物件の人気';

  @override
  String get admin_featured_properties => '注目の物件';

  @override
  String get admin_featured_properties_subtitle => 'プレミアムリスト';

  @override
  String get admin_most_viewed_properties => '最も閲覧されている物件';

  @override
  String get admin_top_performing_agents => '成績上位のエージェント';

  @override
  String get admin_system_health => 'システムの健全性';

  @override
  String get admin_properties_without_images => '画像のないプロパティ';

  @override
  String get admin_missing_location_data => '位置データがありません';

  @override
  String get admin_pending_agent_verification => 'エージェントの確認待ち';

  @override
  String get admin_active => 'アクティブ';

  @override
  String get admin_verified => '検証済み';

  @override
  String get admin_active_7d => 'アクティブ (7d)';

  @override
  String get admin_this_month => '今月';

  @override
  String get agents_loading_pending_applications => '保留中のアプリケーションをロードしています...';

  @override
  String get agents_error_loading_applications => 'アプリケーションの読み込みエラー';

  @override
  String get agents_pending_agents => '保留中のエージェント';

  @override
  String get agents_total_pending_applications => '保留中のアプリケーションの合計:';

  @override
  String get agents_pending_verification => '検証保留中';

  @override
  String get agents_applied_date => '適用済み：';

  @override
  String get agents_contact_info => '連絡先';

  @override
  String get agents_license_number => 'ライセンス番号';

  @override
  String get agents_years_experience => '長年の経験';

  @override
  String get agents_years_suffix => '年';

  @override
  String get agents_total_sales => '総売上高';

  @override
  String get agents_specialization => '専門分野';

  @override
  String get agents_approve => '承認する';

  @override
  String get agents_reject => '拒否する';

  @override
  String get agents_no_pending_applications => '保留中の申請はありません';

  @override
  String get agents_all_applications_processed => 'すべてのエージェント申請が処理されました';

  @override
  String get general_previous => '前の';

  @override
  String get general_page => 'ページ';

  @override
  String get general_next => '次';

  @override
  String get general_views => 'ビュー';

  @override
  String get general_sales => '販売';

  @override
  String get general_language_uz => 'オズベクチャ';

  @override
  String get general_language_ru => 'Русский';

  @override
  String get general_language_en => '英語';

  @override
  String get general_super_admin => 'スーパー管理者';

  @override
  String get general_staff => 'スタッフ';

  @override
  String get general_verified_agent => '認証済みエージェント';

  @override
  String get general_pending_agent => '保留中のエージェント';

  @override
  String get general_regular_user => '一般ユーザー';

  @override
  String get general_admin => '管理者';

  @override
  String get general_dashboard => 'ダッシュボード';

  @override
  String get general_manage_users => 'ユーザーの管理';

  @override
  String get general_verified_agents => '検証済みエージェント';

  @override
  String get general_agent_panel => 'エージェントパネル';

  @override
  String get general_create_property => 'プロパティの作成';

  @override
  String get general_my_properties => '私のプロパティ';

  @override
  String get general_inquiries => 'お問い合わせ';

  @override
  String get general_agent_profile => 'エージェントプロフィール';

  @override
  String get general_live => 'ライブ';

  @override
  String get general_logged_out_successfully => '正常にログアウトされました';

  @override
  String get general_logout_completed_with_errors => 'ログアウト完了（エラーあり）';

  @override
  String get general_application_under_review => '申請は審査中です';

  @override
  String get general_check_status => 'ステータスを確認 →';

  @override
  String get general_last_updated => '最終更新日:';

  @override
  String get general_permissions_may_be_outdated => '権限が古い可能性があります';

  @override
  String get general_permissions_up_to_date => '最新の権限';

  @override
  String get general_never => '一度もない';

  @override
  String get general_properties_found => '見つかったプロパティ';

  @override
  String get general_properties_saved => '保存されたプロパティ';

  @override
  String get general_saved => '保存されました';

  @override
  String get general_loading_properties => 'プロパティを読み込んでいます...';

  @override
  String get general_failed_to_load => 'プロパティの読み込みに失敗しました。もう一度試してください。';

  @override
  String get general_no_properties_found => 'プロパティが見つかりませんでした';

  @override
  String get general_try_adjusting => '検索条件を調整してみてください';

  @override
  String get select_category => 'カテゴリを選択してください';

  @override
  String get service_description => 'サービスの説明';

  @override
  String get product_search_placeholder => '検索語を入力して製品を検索します';

  @override
  String get privacy_policy => 'プライバシーポリシー';

  @override
  String get terms_subtitle => 'プライバシーポリシーと規約';

  @override
  String get last_updated => '最終更新日';

  @override
  String get contact_information => '連絡先';

  @override
  String get accept_terms => '利用規約に同意します';

  @override
  String get read_terms => '当社の利用規約をお読みください';

  @override
  String get inquiries => 'お問い合わせ＆サポート';

  @override
  String get inquiries_subtitle => 'サポートが必要な場合はお問い合わせください';

  @override
  String get help_center => 'どのようにお手伝いできるでしょうか?';

  @override
  String get help_subtitle => 'ご質問がございましたらお気軽にお問い合わせください';

  @override
  String get contact_us => 'お問い合わせ';

  @override
  String get email_support => '電子メールサポート';

  @override
  String get call_support => 'サポートに電話する';

  @override
  String get send_message => 'メッセージを送信する';

  @override
  String get fill_contact_form => 'お問い合わせフォームに記入してください';

  @override
  String get contact_form => 'お問い合わせフォーム';

  @override
  String get name => 'あなたの名前';

  @override
  String get name_required => 'あなたの名前を入力してください';

  @override
  String get email => '電子メールアドレス';

  @override
  String get email_required => 'メールアドレスを入力してください';

  @override
  String get email_invalid => '有効なメールアドレスを入力してください';

  @override
  String get subject => '主題';

  @override
  String get subject_required => '件名を入力してください';

  @override
  String get message => 'メッセージ';

  @override
  String get message_required => 'メッセージを入力してください';

  @override
  String get message_too_short => 'メッセージは 10 文字以上である必要があります';

  @override
  String get faq => 'よくある質問';

  @override
  String get follow_us => '私たちに従ってください';

  @override
  String get faq_how_to_sell => 'Tezsell でアイテムを販売するにはどうすればよいですか?';

  @override
  String get faq_how_to_sell_answer =>
      'アイテムを販売するには: 1) アカウントを作成、2) 「+」ボタンをタップ、3) カテゴリ (製品/サービス/不動産) を選択、4) 写真と説明を追加、5) 価格を設定、6) 公開!あなたのリストはあなたの地域の購入者に表示されます。';

  @override
  String get faq_is_free => 'テッセルは無料で使用できますか?';

  @override
  String get faq_is_free_answer =>
      'はい！ Tezsell は現在完全に無料です。掲載料、販売手数料、購読料はかかりません。将来的にプレミアム機能を導入する可能性がありますが、30 日前にユーザーに通知します。';

  @override
  String get faq_safety => '売買時に安全を保つにはどうすればよいですか?';

  @override
  String get faq_safety_answer =>
      '安全に関するヒント: 1) 公共の場所で会う、2) 支払う前に品物を検査する、3) 見知らぬ人には決して送金しない、4) 自分の直感を信じる、5) 不審なユーザーは報告する、6) あまり早く個人情報を共有しない、7) 高額な取引には友人を連れてくる。';

  @override
  String get faq_payment => '支払いはどのように行われますか?';

  @override
  String get faq_payment_answer =>
      'Tezsell は支払いを処理しません。買い手と売り手は直接支払いを手配します（現金、銀行振込など）。私たちは人々を結び付ける単なるプラットフォームです。取引はあなた自身が処理します。';

  @override
  String get faq_prohibited => '禁止されている物品は何ですか?';

  @override
  String get faq_prohibited_answer =>
      '禁止されている品目には、武器、薬物、盗難品、偽造品、アダルト コンテンツ、生きた動物 (許可なし)、政府の身分証明書、危険物が含まれます。完全なリストについては、利用規約をご覧ください。';

  @override
  String get faq_account_delete => 'アカウントを削除するにはどうすればよいですか?';

  @override
  String get faq_account_delete_answer =>
      '「プロフィール」→「設定」→「アカウント設定」→「アカウントの削除」に移動します。注: これは永続的なものであり、元に戻すことはできません。すべての出品は削除されます。';

  @override
  String get faq_report_user => 'ユーザーまたはリストを報告するにはどうすればよいですか?';

  @override
  String get faq_report_user_answer =>
      'リストまたはユーザー プロフィール上の 3 つの点 (•••) をタップし、[レポート] を選択します。理由を選択して送信してください。すべてのレポートは 24 ～ 48 時間以内に確認されます。';

  @override
  String get faq_change_location => '現在地を変更するにはどうすればよいですか?';

  @override
  String get faq_change_location_answer =>
      'ホーム画面の左上隅にある位置ボタンをタップします。地域と地区を選択すると、その地域のリストが表示されます。';

  @override
  String get welcome_customer_center => 'カスタマーセンターへようこそ';

  @override
  String get customer_center_subtitle => '24時間年中無休でお手伝いいたします';

  @override
  String get quick_actions => 'クイックアクション';

  @override
  String get live_chat => 'ライブチャット';

  @override
  String get chat_with_us => 'チャットしてみよう';

  @override
  String get find_answers => '答えを見つける';

  @override
  String get my_tickets => '私のチケット';

  @override
  String get view_tickets => 'チケットを見る';

  @override
  String get feedback => 'フィードバック';

  @override
  String get share_feedback => 'フィードバックを共有する';

  @override
  String get contact_methods => '連絡方法';

  @override
  String get phone_support => '電話サポート';

  @override
  String get available_247 => '24時間365日利用可能';

  @override
  String get response_24h => '24時間以内に返答';

  @override
  String get telegram_support => '電報サポート';

  @override
  String get instant_replies => '即時返信';

  @override
  String get whatsapp_support => 'WhatsApp サポート';

  @override
  String get quick_response => '素早い対応';

  @override
  String get popular_topics => '人気のトピック';

  @override
  String get account_management => 'アカウント管理';

  @override
  String get reset_password => 'パスワードのリセット';

  @override
  String get update_profile => 'プロフィールを更新する';

  @override
  String get verify_account => 'アカウントの確認';

  @override
  String get delete_account => 'アカウントの削除';

  @override
  String get buying_selling => '売買';

  @override
  String get how_to_post => '広告の掲載方法';

  @override
  String get payment_methods => 'お支払い方法';

  @override
  String get shipping_delivery => '配送と配達';

  @override
  String get return_policy => '返品規則';

  @override
  String get safety_security => '安心・安全';

  @override
  String get report_scam => '詐欺を報告する';

  @override
  String get safe_trading => '安全な取引のヒント';

  @override
  String get privacy_settings => 'プライバシー設定';

  @override
  String get blocked_users => 'ブロックされたユーザー';

  @override
  String get technical_issues => '技術的な問題';

  @override
  String get app_not_working => 'アプリが動作しない';

  @override
  String get upload_failed => 'アップロードに失敗しました';

  @override
  String get login_problems => 'ログインの問題';

  @override
  String get support_hours => 'サポート時間';

  @override
  String get mon_fri_9_6 => '月曜～金曜: 午前9時～午後6時';

  @override
  String get how_are_we_doing => '調子はどうですか？';

  @override
  String get rate_experience => 'カスタマーサービス体験を評価してください';

  @override
  String get poor => '貧しい';

  @override
  String get okay => 'わかった';

  @override
  String get good => '良い';

  @override
  String get excellent => '素晴らしい';

  @override
  String get account_secure => 'あなたのアカウントは安全です';

  @override
  String get password_security => 'パスワードと認証';

  @override
  String get change_password => 'パスワードを変更する';

  @override
  String get two_factor_auth => '二要素認証';

  @override
  String get biometric_login => '生体認証ログイン';

  @override
  String get login_activity => 'ログインアクティビティ';

  @override
  String get active_sessions => 'アクティブなセッション';

  @override
  String get login_alerts => 'ログインアラート';

  @override
  String get account_protection => 'アカウントの保護';

  @override
  String get recovery_email => '回復メール';

  @override
  String get backup_codes => 'バックアップコード';

  @override
  String get danger_zone => '危険地帯';

  @override
  String get improve_security => 'セキュリティの向上';

  @override
  String get security_score => 'セキュリティスコア';

  @override
  String get last_changed_days => '最後に変更されたのは 30 日前';

  @override
  String get logout_all_devices => 'すべてのデバイスをログアウトする';

  @override
  String get end_all_sessions => 'すべてのセッションを終了する';

  @override
  String get permanently_delete => '完全に削除';

  @override
  String get verification_code_message => 'ご本人であることを確認するための確認コードを送信します。';

  @override
  String get send_code => 'コードを送信する';

  @override
  String get enter_verification_code => '認証コードを入力してください';

  @override
  String get verification_code => '検証コード';

  @override
  String get new_password => '新しいパスワード';

  @override
  String get confirm_password => 'パスワードを認証する';

  @override
  String get resend_code => 'コードを再送信する';

  @override
  String get code_sent_to => 'に送信された確認コードを入力してください';

  @override
  String get enter_code => '確認コードを入力してください';

  @override
  String get code_must_be_6_digits => 'コードは6桁である必要があります';

  @override
  String get enter_new_password => '新しいパスワードを入力してください';

  @override
  String get minimum_8_characters => '最低 8 文字';

  @override
  String get passwords_do_not_match => 'パスワードが一致しません';

  @override
  String get close => '近い';

  @override
  String get current => '現在';

  @override
  String get session_ended => 'セッションが終了しました';

  @override
  String get update_recovery_email => '回復メールを更新する';

  @override
  String get new_email => '新しいメール';

  @override
  String get update => 'アップデート';

  @override
  String get verification_email_sent => '確認メールが送信されました';

  @override
  String get generate_emergency_codes => '緊急コードを生成する';

  @override
  String get copy_all => 'すべてコピー';

  @override
  String get code_copied => 'コードをコピーしました';

  @override
  String get all_codes_copied => 'すべてのコードがコピーされました';

  @override
  String get logout_all_devices_confirm => 'すべてのデバイスをログアウトしますか?';

  @override
  String get logout_all_devices_message =>
      'これにより、すべてのデバイス上のすべてのアクティブなセッションが終了します。';

  @override
  String get logout_all => 'すべてログアウト';

  @override
  String get delete_account_confirm => 'アカウントを削除しますか?';

  @override
  String get delete_account_warning =>
      'このアクションは永続的であり、元に戻すことはできません。すべてのデータは完全に削除されます。';

  @override
  String get what_will_be_deleted => '削除されるもの:';

  @override
  String get profile_and_account_info => '• あなたのプロフィールとアカウント情報';

  @override
  String get all_listings_and_posts => '• すべてのリストと投稿';

  @override
  String get messages_and_conversations => 'メッセージ';

  @override
  String get saved_items_and_preferences => '• 保存された項目と設定';

  @override
  String get enter_password_to_continue => '続行するにはパスワードを入力してください';

  @override
  String get continue_val => '続く';

  @override
  String get please_enter_password => 'パスワードを入力してください';

  @override
  String get enter_confirmation_code => '認証コードを入力';

  @override
  String get deletion_confirmation_message =>
      '確認コードをあなたの携帯電話に送信しました。アカウントを完全に削除するには、以下に入力してください。';

  @override
  String get confirmation_code => '確認コード';

  @override
  String get please_enter_6_digit_code => '6桁のコードを入力してください';

  @override
  String get account_deleted => 'あなたのアカウントは削除されました';

  @override
  String get deletion_cancelled => '削除がキャンセルされました';

  @override
  String get failed_to_load_user_info => 'ユーザー情報の読み込みに失敗しました';

  @override
  String get auth_login_to_view_saved => '保存したプロパティを表示するにはログインしてください';

  @override
  String get authLoginRequired => 'ログインが必要です';

  @override
  String get authLoginToViewSaved => '保存したプロパティを表示するにはログインしてください';

  @override
  String get authLogin => 'ログイン';

  @override
  String get savedPropertiesTitle => '保存されたプロパティ';

  @override
  String get loadingSavedProperties => '保存されたプロパティをロードしています...';

  @override
  String get errorsFailedToLoadSaved => '保存されたプロパティのロードに失敗しました';

  @override
  String get actionsRetry => 'リトライ';

  @override
  String get savedPropertiesNoSaved => '保存されたプロパティはありません';

  @override
  String get savedPropertiesStartSaving => '探索を開始し、気に入った物件を保存します';

  @override
  String get savedPropertiesBrowse => 'プロパティを参照する';

  @override
  String get resultsSavedProperties => '保存されたプロパティ';

  @override
  String get actionsRefresh => 'リフレッシュ';

  @override
  String get resultsNoMoreProperties => 'これ以上のプロパティはありません';

  @override
  String get propertyCardFeatured => '注目の';

  @override
  String get successPropertyUnsaved => '保存されたリストからプロパティが削除されました';

  @override
  String get alertsUnsavePropertyFailed => 'プロパティの削除に失敗しました';

  @override
  String get propertyCardBed => 'ベッド';

  @override
  String get propertyCardBath => 'バス';

  @override
  String get savedPropertiesSavedOn => '保存日';

  @override
  String get propertyCardViewDetails => '詳細を見る';

  @override
  String get serviceDetailTitle => 'サービス詳細';

  @override
  String get errorLoadingFavorites => 'お気に入りアイテムの読み込みエラー';

  @override
  String get noFavoritesFound => 'お気に入りのアイテムが見つかりませんでした。';

  @override
  String get commentUpdatedSuccess => 'コメントが正常に更新されました！';

  @override
  String get errorUpdatingComment => 'コメント更新エラー';

  @override
  String get replyAddedSuccess => '返信が正常に追加されました。';

  @override
  String get errorAddingReply => '返信の追加中にエラーが発生しました';

  @override
  String get commentDeletedSuccess => 'コメントは正常に削除されました。';

  @override
  String get errorDeletingComment => 'コメント削除エラー';

  @override
  String get serviceLikedSuccess => 'サービスは無事気に入りました！';

  @override
  String get errorLikingService => 'サービスを気に入っているときにエラーが発生しました';

  @override
  String get serviceDislikedSuccess => 'サービスは正常に嫌われました!';

  @override
  String get errorDislikingService => 'サービスが嫌いなエラー';

  @override
  String get writeYourReply => '返信を書いてください...';

  @override
  String get postReply => '返信を投稿する';

  @override
  String get anonymous => '匿名';

  @override
  String get editComment => 'コメントの編集';

  @override
  String get editYourComment => 'コメントを編集...';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get propertyOwner => '不動産所有者';

  @override
  String get errorLoadingServices => 'サービスの読み込みエラー';

  @override
  String get noRecommendedServicesFound => 'おすすめのサービスは見つかりませんでした。';

  @override
  String get passwordRequired => 'パスワードが必要です';

  @override
  String get passwordTooShort => 'パスワードは8文字以上である必要があります';

  @override
  String get passwordRequirements => 'パスワードには文字と数字を含める必要があります';

  @override
  String get usernameRequired => 'ユーザー名は必須です';

  @override
  String get usernameTooShort => 'ユーザー名は少なくとも 3 文字である必要があります';

  @override
  String get confirmPasswordRequired => 'パスワードの確認が必要です';

  @override
  String get passwordHelp => '少なくとも 8 文字の文字と数字';

  @override
  String get usernameExists => 'このユーザー名はすでに存在します';

  @override
  String get phoneExists => 'この電話番号はすでに登録されています';

  @override
  String get networkError => 'ネットワーク接続エラー。接続を確認してください';

  @override
  String get contactSeller => '販売者に連絡する';

  @override
  String get callToReveal => '「通話」をタップすると表示されます';

  @override
  String get camera => 'カメラ';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get selectImageSource => '画像ソースの選択';

  @override
  String get uploading => 'アップロード中...';

  @override
  String get acceptTermsRequired => '続行するには利用規約に同意する必要があります';

  @override
  String get iAgreeToTerms => 'に同意します';

  @override
  String get termsAndConditions => '利用規約';

  @override
  String get zeroToleranceStatement =>
      'また、不快なコンテンツや虐待的なユーザーは一切許容されないことを理解してください。';

  @override
  String get viewTerms => '利用規約を見る';

  @override
  String get reportContent => '報告内容';

  @override
  String get selectReportReason => '報告する理由を選択してください:';

  @override
  String get additionalDetails => '追加の詳細 (オプション)';

  @override
  String get reportDetailsHint => '追加情報があれば提供してください...';

  @override
  String get reportSubmitted => 'ご報告ありがとうございます。 24時間以内に審査させていただきます。';

  @override
  String get reportProduct => 'レポート製品';

  @override
  String get reportService => 'レポートサービス';

  @override
  String get reportMessage => 'レポートメッセージ';

  @override
  String get reportUser => 'ユーザーを報告する';

  @override
  String get reportErrorNotImplemented =>
      'レポート機能はまだ利用できません。サポートに連絡するか、後でもう一度試してください。';

  @override
  String get reportAlreadySubmitted => 'この内容はすでに報告済みです。前回のレポートを検討中です。';

  @override
  String get reportFailedGeneric => 'レポートの提出に失敗しました。もう一度試してください。';

  @override
  String get reportFailedNetwork => 'ネットワークエラーが発生しました。接続を確認して、もう一度試してください。';

  @override
  String get becomeAgentTitle => '不動産業者として参加する';

  @override
  String get becomeAgentSubtitle => '物件をリストアップし、顧客が夢のマイホームを見つけるお手伝いをします';

  @override
  String get agentBenefits => '利点：';

  @override
  String get agentBenefitVerified => '確認済みエージェントバッジ';

  @override
  String get agentBenefitAnalytics => '分析と洞察へのアクセス';

  @override
  String get agentBenefitClients => '潜在的な顧客との直接コンタクト';

  @override
  String get agentBenefitReputation => '専門的な評判を築く';

  @override
  String get agentApplicationForm => '申請フォーム';

  @override
  String get agentAgencyName => '代理店名';

  @override
  String get agentAgencyNameHint => '不動産会社名を入力してください';

  @override
  String get agentAgencyNameRequired => '代理店名は必須です';

  @override
  String get agentLicenceNumber => 'ライセンス番号';

  @override
  String get agentLicenceNumberHint => '不動産免許番号を入力してください';

  @override
  String get agentLicenceNumberRequired => 'ライセンス番号は必須です';

  @override
  String get agentYearsExperience => '長年の経験';

  @override
  String get agentYearsExperienceHint => '年数を入力してください';

  @override
  String get agentYearsExperienceRequired => '長年の経験が必要です';

  @override
  String get agentYearsExperienceInvalid => '有効な番号を入力してください';

  @override
  String get agentSpecialization => '専門分野';

  @override
  String get agentApplicationNote =>
      'あなたの申請は私たちのチームによって審査されます。申請が承認されると通知が届きます。';

  @override
  String get agentSubmitApplication => '申請書の提出';

  @override
  String get agentApplicationSubmitted => '申請は正常に送信されました。すぐにレビューします。';

  @override
  String get agentApplicationStatus => '申請状況';

  @override
  String get agentViewProfile => 'エージェントのプロフィールを表示する';

  @override
  String get agentDashboardComingSoon => 'エージェント ダッシュボードは近日公開予定です。';

  @override
  String get property_create_basic_information => '基本情報';

  @override
  String get property_create_property_title => '物件タイトル *';

  @override
  String get property_create_property_title_hint =>
      '例: 市内中心部のモダンな 3 ベッドルーム アパートメント';

  @override
  String get property_create_property_title_required => '物件タイトルを入力してください';

  @override
  String get property_create_description => '説明 *';

  @override
  String get property_create_description_hint => '物件を詳しく説明して...';

  @override
  String get property_create_description_required => '説明を入力してください';

  @override
  String get property_create_property_type => 'プロパティの種類';

  @override
  String get property_create_property_type_required => 'プロパティの種類 *';

  @override
  String get property_create_listing_type_required => '出品タイプ *';

  @override
  String get property_create_pricing => '価格設定';

  @override
  String get property_create_price => '価格 *';

  @override
  String get property_create_price_hint => '価格を入力してください';

  @override
  String get property_create_price_required => '価格を入力してください';

  @override
  String get property_create_currency => '通貨';

  @override
  String get property_create_property_details => '物件詳細';

  @override
  String get property_create_square_meters => '平方メートルメートル *';

  @override
  String get property_create_bedrooms => '寝室 *';

  @override
  String get property_create_bathrooms => 'バスルーム *';

  @override
  String get property_create_floor => '床';

  @override
  String get property_create_total_floors => '総階数';

  @override
  String get property_create_parking => '駐車場';

  @override
  String get property_create_year_built => '築年数';

  @override
  String get property_create_location => '位置';

  @override
  String get property_create_address => '住所 *';

  @override
  String get property_create_address_hint => '物件の住所を入力してください';

  @override
  String get property_create_address_required => '住所を入力してください';

  @override
  String get property_create_location_detected => '位置が検出されました';

  @override
  String get property_create_get_location => '現在位置を取得する';

  @override
  String get property_create_features => '特徴';

  @override
  String get property_create_feature_balcony => 'バルコニー';

  @override
  String get property_create_feature_garage => 'ガレージ';

  @override
  String get property_create_feature_garden => '庭';

  @override
  String get property_create_feature_pool => 'プール';

  @override
  String get property_create_feature_elevator => 'エレベーター';

  @override
  String get property_create_feature_furnished => '家具付き';

  @override
  String get property_create_images => '物件画像';

  @override
  String get property_create_tap_to_add_images => 'タップして画像を追加します';

  @override
  String get property_create_at_least_one_image => '少なくとも 1 つの画像が必要です';

  @override
  String get property_create_add_more => 'さらに追加';

  @override
  String get property_create_required => '必須';

  @override
  String get property_create_location_required =>
      'プロパティを作成するには位置情報サービスを有効にしてください';

  @override
  String get property_create_image_required => '少なくとも 1 つのプロパティ画像が必要です';

  @override
  String get emailVerification => 'メール認証';

  @override
  String get pleaseEnterYourEmailAddress => 'メールアドレスを入力してください';

  @override
  String get enterEmailAddress => 'メールアドレスを入力してください';

  @override
  String get resetYourPassword => 'パスワードをリセットする';

  @override
  String get resetPasswordDescription =>
      'メールアドレスを入力してください。パスワードをリセットするための確認コードが送信されます。';

  @override
  String get sendVerificationCode => '認証コードを送信する';

  @override
  String get backToLogin => 'ログインに戻る';

  @override
  String get resetPassword => 'パスワードのリセット';

  @override
  String enterVerificationCodeSentTo(String email) {
    return '$email に送信された確認コードを入力してください';
  }

  @override
  String get codeMustBe6Digits => 'コードは6桁である必要があります';

  @override
  String get enterNewPassword => '新しいパスワードを入力してください';

  @override
  String get minimum8Characters => '最低 8 文字';

  @override
  String get sending => '送信中...';

  @override
  String get verifying => '確認中...';

  @override
  String get new_message => '新しいメッセージ';

  @override
  String get messages => 'メッセージ';

  @override
  String get please_log_in => 'メッセージを表示するにはログインしてください';

  @override
  String get pin => 'ピン';

  @override
  String get unpin => '固定を解除する';

  @override
  String get delete_chat => 'チャットの削除';

  @override
  String delete_chat_confirm(String name) {
    return '$name とのチャットを削除してもよろしいですか?この操作は元に戻すことができません。';
  }

  @override
  String chat_deleted(String name) {
    return '$name とのチャットが削除されました';
  }

  @override
  String get delete_failed => 'チャットの削除に失敗しました';

  @override
  String get no_conversations => 'まだ会話はありません';

  @override
  String get start_conversation_hint => '+ボタンをタップして会話を開始します';

  @override
  String get start_conversation => '会話を始める';

  @override
  String get yesterday => '昨日';

  @override
  String get unknown => '未知';

  @override
  String get no_messages_yet => 'まだメッセージはありません';

  @override
  String get unblock_user => 'ユーザーのブロックを解除する';

  @override
  String get block_user => 'ユーザーをブロックする';

  @override
  String get no_blocked_users => 'ブロックされたユーザーはいません';

  @override
  String get blocked_users_hint => 'ブロックしたユーザーがここに表示されます';

  @override
  String unblock_user_confirm(String username) {
    return 'Are you sure you want to unblock $username?再び彼らからのメッセージを受け取ることができるようになります。';
  }

  @override
  String user_unblocked(String username) {
    return '$username のブロックが解除されました';
  }

  @override
  String user_blocked(String username) {
    return '$username はブロックされました';
  }

  @override
  String get failed_to_unblock => 'ユーザーのブロックを解除できませんでした';

  @override
  String get failed_to_block => 'ユーザーをブロックできませんでした';

  @override
  String get chat_info => 'チャット情報';

  @override
  String get delete_message => 'メッセージの削除';

  @override
  String get delete_message_confirm => 'このメッセージを削除してもよろしいですか?';

  @override
  String get typing => 'タイピング...';

  @override
  String get online => 'オンライン';

  @override
  String get offline => 'オフライン';

  @override
  String last_seen_at(String time) {
    return '最後に見たのは$time';
  }

  @override
  String participants(int count) {
    return '$count 参加者';
  }

  @override
  String get you_are_blocked => 'あなたはブロックされています';

  @override
  String user_blocked_you(String username) {
    return '$username があなたをブロックしました。メッセージを送信することはできません。';
  }

  @override
  String you_blocked_user(String username) {
    return '$username をブロックしました';
  }

  @override
  String get cannot_send_messages_blocked =>
      'メッセージを送信することはできません。あなたはブロックされました。';

  @override
  String get this_message_was_deleted => 'このメッセージは削除されました';

  @override
  String get edit => '編集';

  @override
  String get reply => '返事';

  @override
  String get editing_message => 'メッセージの編集';

  @override
  String replying_to(String username) {
    return '$usernameに返信する';
  }

  @override
  String get voice => '声';

  @override
  String get emoji => '絵文字';

  @override
  String get photo => '📷 写真';

  @override
  String get voice_message => '🎤 音声メッセージ';

  @override
  String get searching => '検索中...';

  @override
  String get loading_users => 'ユーザーを読み込んでいます...';

  @override
  String search_failed(String error) {
    return '検索に失敗しました: $error';
  }

  @override
  String get invalid_user_data => '無効なユーザーデータ';

  @override
  String failed_to_start_chat(String error) {
    return 'チャットを開始できませんでした: $error';
  }

  @override
  String get audio_file_not_available => '音声ファイルが利用できません';

  @override
  String failed_to_play_audio(String error) {
    return 'オーディオの再生に失敗しました: $error';
  }

  @override
  String get image_unavailable => '画像が利用できません';

  @override
  String get image_too_large => '❌ 画像が大きすぎます。最大サイズは10MBです';

  @override
  String get image_file_not_found => '❌ 画像ファイルが見つかりません';

  @override
  String get uploading_image => '画像をアップロードしています...';

  @override
  String get image_sent => '✅画像を送信しました！';

  @override
  String get failed_to_send_image => '❌ 画像の送信に失敗しました';

  @override
  String get uploading_voice_message => '音声メッセージをアップロードしています...';

  @override
  String get voice_message_sent => '✅ 音声メッセージが送信されました!';

  @override
  String get failed_to_send_voice_message => '❌ 音声メッセージの送信に失敗しました';

  @override
  String get recording => '🎙️ 録音中...';

  @override
  String get microphone_permission_denied => 'マイクの許可が拒否されました';

  @override
  String get starting_chat => 'チャットを開始しています...';

  @override
  String get refresh_users => 'ユーザーを更新する';

  @override
  String get search_by_username_or_phone => 'ユーザー名または電話番号で検索する';

  @override
  String get no_users_found => 'ユーザーが見つかりませんでした';

  @override
  String get try_different_search_term => '別の検索語を試してください';

  @override
  String get no_users_available => '利用可能なユーザーがいません';

  @override
  String get chat_exists => 'チャットが存在します';

  @override
  String block_user_confirm(String username) {
    return '$username をブロックしてもよろしいですか?彼らからメッセージは受信されなくなり、チャット リストから削除されます。';
  }

  @override
  String chat_room_label(String name) {
    return 'チャット ルーム: $name';
  }

  @override
  String id_label(int id) {
    return 'ID: $id';
  }

  @override
  String get participants_label => '参加者：';

  @override
  String get type_a_message => 'メッセージを入力してください...';

  @override
  String get edit_message_hint => 'メッセージを編集...';

  @override
  String error_label(String error) {
    return 'エラー: $error';
  }

  @override
  String get copy => 'コピー';

  @override
  String comments_title(int count) {
    return 'コメント ($count)';
  }

  @override
  String get reply_button => '返事';

  @override
  String replies_count(int count) {
    return '$count が返信します';
  }

  @override
  String get you_label => 'あなた';

  @override
  String get delete_reply_title => '返信の削除';

  @override
  String get delete_comment_title => 'コメントの削除';

  @override
  String get unknown_date => '日付不明';

  @override
  String get press_enter_to_send => 'Enterを押して送信してください';

  @override
  String get comment_add_error => 'コメントの追加に失敗しました';

  @override
  String get service_provider => 'サービスプロバイダー';

  @override
  String get opening_chat => 'チャットを開いています...';

  @override
  String get failed_to_refresh => '更新に失敗しました';

  @override
  String get cannot_chat_with_yourself => '自分自身とチャットすることはできません';

  @override
  String opening_chat_with(String username) {
    return '$username とのチャットを開始しています...';
  }

  @override
  String get this_will_only_take_a_moment => 'これには少し時間がかかります';

  @override
  String get unable_to_start_chat => 'チャットを開始できません。もう一度試してください。';

  @override
  String get profile_listings => 'リスト';

  @override
  String get profile_followers => 'フォロワー';

  @override
  String get profile_following => '続く';

  @override
  String get profile_no_products => '商品がありません';

  @override
  String get profile_no_services => 'サービスなし';

  @override
  String get profile_no_properties => 'プロパティがありません';

  @override
  String get profile_user_no_products => 'このユーザーはまだ商品を投稿していません';

  @override
  String get profile_user_no_services => 'このユーザーはまだサービスを投稿していません';

  @override
  String get profile_user_no_properties => 'このユーザーはまだ物件を投稿していません';

  @override
  String get profile_error_occurred => 'エラーが発生しました';

  @override
  String get profile_error_loading_products => '製品の読み込みエラー';

  @override
  String get profile_error_loading_services => 'サービスの読み込みエラー';

  @override
  String get profile_no_followers_yet => 'まだフォロワーがいません';

  @override
  String get profile_no_following_yet => 'まだ誰もフォローしていません';

  @override
  String get profile_follow => 'フォローする';

  @override
  String get profile_following_btn => '続く';

  @override
  String get profile_message => 'メッセージ';

  @override
  String get profile_member_since => '以来のメンバー';

  @override
  String get profile_loading_error => 'プロファイルの読み込みエラー';

  @override
  String get profile_retry => 'もう一度やり直してください';

  @override
  String get profile_share => '共有';

  @override
  String get profile_copy_link => 'リンクをコピー';

  @override
  String get profile_report => '報告';

  @override
  String get linkCopied => 'リンクがクリップボードにコピーされました';

  @override
  String get checkOutProfile => 'チェックアウト';

  @override
  String get onTezsell => 'TezSell で';

  @override
  String get selectCountryFirst => '最初に国を選択してください';

  @override
  String get countrySelectionHint => '次に、地域を選択できます';

  @override
  String get something_went_wrong => '何か問題が発生しました';

  @override
  String get check_connection_and_retry => 'インターネット接続を確認して、もう一度お試しください';

  @override
  String get sold_badge => '販売済み';

  @override
  String get more_categories => 'もっと';

  @override
  String no_products_in_location(String location) {
    return '$location には製品が見つかりませんでした';
  }

  @override
  String get no_more_products => 'これ以上ロードする商品はありません';

  @override
  String time_days_ago(int count) {
    return '$count日前';
  }

  @override
  String time_hours_ago(int count) {
    return '$count時間前';
  }

  @override
  String time_minutes_ago(int count) {
    return '$count分前';
  }

  @override
  String get time_just_now => 'ちょうど今';

  @override
  String no_services_in_location(String location) {
    return '$location にサービスが見つかりませんでした';
  }

  @override
  String get no_more_services => 'これ以上ロードするサービスはありません';

  @override
  String get error_loading_more_services => 'さらにサービスをロード中にエラーが発生しました';

  @override
  String get verification_code_length => '認証コードは6桁である必要があります';

  @override
  String get map_register_title => 'どこに住んでいますか？';

  @override
  String get map_register_headline => '地図上で近所を選択してください';

  @override
  String get map_register_subtitle => '近くの買い手と売り手を紹介するために使用します。半径は後で調整できます。';

  @override
  String get pick_on_map => '地図上で選ぶ';

  @override
  String get pick_again => 'もう一度選択してください';

  @override
  String get resolving_location => '位置情報を解決中…';

  @override
  String get use_dropdown_instead => '代わりにドロップダウンを使用してください';

  @override
  String country_not_supported(String country) {
    return '$country はまだサポートされていません。';
  }

  @override
  String get region_not_auto_detected => '地域を自動検出できませんでした。手動で選択してください。';

  @override
  String get district_not_auto_detected => '地区を自動検出できませんでした。手動で選択してください。';

  @override
  String get browse_no_items_with_location => 'このエリアには位置データを持つアイテムはまだありません。';

  @override
  String get location_picker_title => '場所を設定する';

  @override
  String get location_picker_confirm => '場所を確認する';

  @override
  String get location_picker_resolve_failed =>
      '住所を解決できませんでした - もう一度選択するか、座標のみで確認してください';

  @override
  String get location_picker_selected_fallback => '選択した場所';

  @override
  String get location_permission_denied => '位置情報の許可が拒否されました';

  @override
  String get location_permission_denied_settings =>
      '位置情報の許可が拒否されました - 設定で有効にしてください';

  @override
  String get location_permission_permanent => '位置情報が永久に拒否されました — 設定を開いて有効にします';

  @override
  String gps_error(String error) {
    return 'GPS エラー: $error';
  }

  @override
  String get verify_neighborhood_title => '近所を確認する';

  @override
  String get verify_neighborhood_subtitle =>
      'あなたの近所に立ってください。 GPS をチェックして確認を求めます。';

  @override
  String get verify_neighborhood_button => '近隣の検証';

  @override
  String get verify_neighborhood_low_confidence => '低い自信を持って続行する';

  @override
  String get verify_neighborhood_retry => 'リトライ';

  @override
  String get verify_neighborhood_youre_in => 'あなたは次の場所にいます:';

  @override
  String verify_neighborhood_done(String name) {
    return '検証されました！ $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'GPS の精度は ${meters}m (必要 ≤100m) です。開けた場所に移動して、もう一度試してください。';
  }

  @override
  String get neighborhood_not_identified => 'お住まいの地域の近隣地域を特定できませんでした。';

  @override
  String get unknown_error => '不明なエラー';

  @override
  String get place_search_hint => '住所または場所を検索する';

  @override
  String get place_search_unavailable => '検索は利用できません — 代わりにピンをドロップしてください';

  @override
  String get radius_slider_city => '市';

  @override
  String radius_slider_km(String value) {
    return '${value}km';
  }

  @override
  String get my_neighborhoods => 'マイエリア';

  @override
  String get manage_on_map => 'マップで管理';

  @override
  String get no_neighborhoods_yet => 'まだ認証済みのエリアがありません。マップを開いて現在地を認証してください。';

  @override
  String get open_map_to_verify => 'マップを開いて新しい場所を認証';

  @override
  String get verify_here => 'ここで認証';

  @override
  String get verify_new_location => '新しい場所を認証';

  @override
  String eviction_warning(String name) {
    return 'この場所を追加すると$name（最も古い場所）が削除されます。この操作は元に戻せません。';
  }

  @override
  String get verified_today => '今日認証済み';

  @override
  String get verified_yesterday => '昨日認証済み';

  @override
  String verified_n_days_ago(int days) {
    return '$days日前に認証済み';
  }

  @override
  String get active_neighborhood => 'アクティブ';

  @override
  String switch_neighborhood_success(String name) {
    return '$nameに切り替えました';
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
