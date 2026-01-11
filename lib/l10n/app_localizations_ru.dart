// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get welcome => 'Добро пожаловать';

  @override
  String get welcomeBack => 'С возвращением!';

  @override
  String get loginToYourAccount => 'Войдите, чтобы продолжить';

  @override
  String get or => 'ИЛИ';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get chooseLanguage => 'Выберите язык';

  @override
  String get selectPreferredLanguage =>
      'Выберите предпочитаемый язык для приложения';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get sellAndBuyProducts =>
      'Продавайте и покупайте любые товары только у нас';

  @override
  String get usedProductsMarket => 'Рынок подержанных товаров';

  @override
  String get home_welcome_title => 'Ваш местный маркетплейс';

  @override
  String get home_welcome_subtitle =>
      'Покупайте и продавайте рядом с домом.\nБезопасно, просто и локально.';

  @override
  String get home_get_started => 'Начать';

  @override
  String get home_sign_in => 'У меня уже есть аккаунт';

  @override
  String get home_terms_notice =>
      'Продолжая, вы соглашаетесь с Условиями использования и Политикой конфиденциальности';

  @override
  String get register => 'Регистрация';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт';

  @override
  String get login => 'Войти';

  @override
  String get loginToAccount => 'Вход в аккаунт';

  @override
  String get enterPhoneNumber => 'Введите номер телефона';

  @override
  String get password => 'Пароль';

  @override
  String get enterPassword => 'Введите пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get registerNow => 'Зарегистрироваться';

  @override
  String get loading => 'Загрузка...';

  @override
  String get pleaseEnterPhoneNumber => 'Пожалуйста, введите номер телефона';

  @override
  String get pleaseEnterPassword => 'Пожалуйста, введите пароль';

  @override
  String get unexpectedError =>
      'Произошла неожиданная ошибка. Попробуйте снова.';

  @override
  String get forgotPasswordComingSoon =>
      'Функция восстановления пароля скоро появится';

  @override
  String get selectedCountryLabel => 'Выбрано:';

  @override
  String get fullPhoneLabel => 'Полный:';

  @override
  String get home => 'Главная';

  @override
  String get settings => 'Настройки';

  @override
  String get profile => 'Профиль';

  @override
  String get search => 'Поиск';

  @override
  String get notifications => 'Уведомления';

  @override
  String get error => 'Ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Пожалуйста, выберите ваш регион';

  @override
  String get searchHint => 'Поиск района или города';

  @override
  String get apiError => 'Проблема при вызове API';

  @override
  String get ok => 'ОК';

  @override
  String get emptyList => 'Пустой список';

  @override
  String get dataLoadingError => 'Ошибка при загрузке данных';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String confirmRegionSelection(Object regionName) {
    return 'Вы хотите выбрать регион $regionName?';
  }

  @override
  String get selectDistrictOrCity => 'Пожалуйста, выберите ваш район или город';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return 'Вы хотите выбрать регион $regionName - $districtName?';
  }

  @override
  String get noResultsFound => 'Результаты не найдены.';

  @override
  String errorWithCode(String errorCode) {
    return 'Ошибка: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'Не удалось загрузить данные. Ошибка: $error';
  }

  @override
  String get phoneVerification => 'Подтверждение номера телефона';

  @override
  String get enterPhonePrompt => 'Пожалуйста, введите ваш номер телефона';

  @override
  String get enterPhoneNumberHint => 'Введите номер телефона';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Выбрано: $countryName ($countryCode)';
  }

  @override
  String fullNumber(String phoneNumber) {
    return 'Полный номер: $phoneNumber';
  }

  @override
  String get sendCode => 'Отправить код';

  @override
  String get enterVerificationCode => 'Введите код подтверждения';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Отправить код повторно';

  @override
  String expires(String time) {
    return 'Истекает: $time';
  }

  @override
  String get verifyAndContinue => 'Подтвердить и продолжить';

  @override
  String get invalidVerificationCode => 'Неверный код подтверждения';

  @override
  String get verificationCodeSent => 'Код подтверждения отправлен успешно';

  @override
  String get failedToSendCode => 'Не удалось отправить код подтверждения';

  @override
  String get verificationCodeResent => 'Код подтверждения отправлен повторно';

  @override
  String get failedToResendCode => 'Не удалось отправить код повторно';

  @override
  String get passwordVerification => 'Подтверждение пароля';

  @override
  String get completeRegistrationPrompt =>
      'Введите имя пользователя и пароль для завершения регистрации';

  @override
  String get username => 'Имя пользователя';

  @override
  String get username_required => 'Имя пользователя обязательно';

  @override
  String get username_min_length =>
      'Имя пользователя должно содержать минимум 2 символа';

  @override
  String get usernameHint => 'Пользователь123';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get profileImage => 'Фото профиля';

  @override
  String get imageInstructions =>
      'Изображения появятся здесь, нажмите на фото профиля';

  @override
  String get finish => 'Завершить';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get registrationError => 'Ошибка регистрации';

  @override
  String get about => 'О нас';

  @override
  String get chat => 'Чат';

  @override
  String get realEstate => 'Недвижимость';

  @override
  String get language => 'РУС';

  @override
  String get languageEn => 'Английский';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageUz => 'Узбекский';

  @override
  String get serviceLiked => 'Услуга понравилась';

  @override
  String get support => 'Поддержка';

  @override
  String get service => 'Бизнес-услуги';

  @override
  String get aboutContent =>
      'TezSell - это быстрая и простая торговая площадка для покупки и продажи новых и подержанных товаров. Наша миссия - создать наиболее удобную и эффективную платформу для каждого пользователя, обеспечивая плавные транзакции и удобный пользовательский интерфейс. Независимо от того, хотите ли вы продавать или покупать, TezSell упрощает подключение и завершение транзакций всего за несколько шагов. Мы уделяем приоритетное внимание безопасности и конфиденциальности наших пользователей. Все транзакции тщательно отслеживаются для обеспечения безопасности и соответствия, обеспечивая спокойствие как покупателям, так и продавцам. Наш простой и интуитивно понятный интерфейс позволяет пользователям быстро размещать товары и находить то, что им нужно. Мы также облегчаем общение в реальном времени через Telegram, делая процесс покупки и продажи еще более плавным.';

  @override
  String get errorMessage => 'Произошла ошибка, проверьте сервер';

  @override
  String get searchLocation => 'Местоположение';

  @override
  String get searchCategory => 'Категории';

  @override
  String get searchProductPlaceholder => 'Поиск товаров';

  @override
  String get searchServicePlaceholder => 'Поиск услуг';

  @override
  String get search_products_subtitle =>
      'Найдите выгодные предложения рядом с вами';

  @override
  String get search_services_subtitle => 'Найдите специалистов рядом с вами';

  @override
  String get search_products_error => 'Ошибка поиска товаров';

  @override
  String get search_services_error => 'Ошибка поиска услуг';

  @override
  String get load_more_products_error => 'Ошибка загрузки товаров';

  @override
  String get load_more_services_error => 'Ошибка загрузки услуг';

  @override
  String get try_different_keywords => 'Попробуйте другие ключевые слова';

  @override
  String get searchText => 'Поиск';

  @override
  String get selectedCategory => 'Выбранная категория: ';

  @override
  String get selectedLocation => 'Выбранное местоположение: ';

  @override
  String get productError => 'Товары недоступны';

  @override
  String get serviceError => 'Услуги недоступны';

  @override
  String get locationHeader => 'Выберите местоположение';

  @override
  String get locationPlaceholder => 'Поиск региона';

  @override
  String get categoryHeader => 'Выберите категорию';

  @override
  String get categoryPlaceholder => 'Поиск категорий';

  @override
  String get categoryError => 'Категории недоступны';

  @override
  String get paginationFirst => 'Первая';

  @override
  String get paginationPrevious => 'Предыдущая';

  @override
  String get pageInfo => 'Страница из';

  @override
  String get pageNext => 'Следующая';

  @override
  String get pageLast => 'Последняя';

  @override
  String get loadingMessageProduct => 'Загрузка товаров...';

  @override
  String get loadingMessageError => 'Ошибка при загрузке';

  @override
  String get likeProductError => 'Ошибка при лайке товара';

  @override
  String get dislikeProductError => 'Ошибка при дизлайке товара';

  @override
  String get loadingMessageLocation => 'Загрузка местоположения...';

  @override
  String get loadingLocationError => 'Ошибка при загрузке местоположения';

  @override
  String get loadingMessageCategory => 'Загрузка категорий...';

  @override
  String get loadingCategoryError => 'Ошибка загрузки категорий:';

  @override
  String get profileUpdateSuccessMessage => 'Профиль успешно обновлен';

  @override
  String get profileUpdateFailMessage => 'Не удалось обновить профиль';

  @override
  String get seeMoreBtn => 'Показать больше';

  @override
  String get profilePageTitle => 'Страница профиля';

  @override
  String get editProfileModalTitle => 'Редактировать профиль';

  @override
  String get usernameLabel => 'Имя пользователя';

  @override
  String get locationLabel => 'Текущее местоположение';

  @override
  String get profileImageLabel => 'Фото профиля';

  @override
  String get chooseFileLabel => 'Выберите файл';

  @override
  String get uploadBtnLabel => 'Обновить';

  @override
  String get uploadingBtnLabel => 'Обновление...';

  @override
  String get cancelBtnLabel => 'Отмена';

  @override
  String get productsTitle => 'Товары';

  @override
  String get servicesTitle => 'Услуги';

  @override
  String get myProductsTitle => 'Мои товары';

  @override
  String get myServicesTitle => 'Мои услуги';

  @override
  String get favoriteProductsTitle => 'Избранные товары';

  @override
  String get favoriteServicesTitle => 'Избранные услуги';

  @override
  String get noFavorites => 'Нет избранного';

  @override
  String get addNewProductBtn => 'Добавить новый товар';

  @override
  String get addNew => 'Новый';

  @override
  String get addNewServiceBtn => 'Добавить новую услугу';

  @override
  String get downloadMobileApp => 'Скачайте мобильное приложение';

  @override
  String get registerPhoneNumberSuccess =>
      'Номер телефона подтвержден! Вы можете перейти к следующему шагу.';

  @override
  String get regionSelectedMessage => 'Регион выбран:';

  @override
  String get districtSelectMessage => 'Район выбран:';

  @override
  String get phoneNumberEmptyMessage =>
      'Пожалуйста, подтвердите номер телефона перед продолжением';

  @override
  String get regionEmptyMessage => 'Пожалуйста, сначала выберите регион';

  @override
  String get districtEmptyMessage => 'Пожалуйста, выберите район';

  @override
  String get usernamePasswordEmptyMessage =>
      'Пожалуйста, введите имя пользователя и пароль';

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get previousButton => 'Назад';

  @override
  String get nextButton => 'Далее';

  @override
  String get completeButton => 'Завершить';

  @override
  String stepIndicator(int currentStep) {
    return 'Шаг $currentStep из 4';
  }

  @override
  String get districtSelectTitle => 'Список районов';

  @override
  String get districtSelectParagraph => 'Выберите район:';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get sendOtp => 'Отправить ОТП';

  @override
  String get sendAgain => 'Отправить снова';

  @override
  String get verify => 'Подтвердить';

  @override
  String get failedToSendOtp =>
      'Не удалось отправить ОТП. Сервер вернул false.';

  @override
  String get errorSendingOtp => 'Произошла ошибка при отправке ОТП.';

  @override
  String get invalidPhoneNumber =>
      'Пожалуйста, введите действительный номер телефона.';

  @override
  String get verificationSuccess => 'Успешно подтверждено';

  @override
  String get verificationError => 'Произошла ошибка. Попробуйте снова позже.';

  @override
  String get regionsList => 'Список регионов';

  @override
  String get enterUsername => 'Введите ваше имя пользователя';

  @override
  String get welcomeMessage =>
      'Добро пожаловать в Tezsell, войдите с помощью номера телефона';

  @override
  String get noAccount => 'Нет аккаунта? Зарегистрируйтесь здесь';

  @override
  String get successLogin => 'Успешный вход';

  @override
  String get myProfile => 'Мой профиль';

  @override
  String get logout => 'выйти';

  @override
  String get newProductTitle => 'Название';

  @override
  String get newProductDescription => 'Описание';

  @override
  String get newProductPrice => 'Цена';

  @override
  String get newProductCondition => 'Состояние';

  @override
  String get newProductCategory => 'Категория';

  @override
  String get newProductImages => 'Изображения';

  @override
  String get addNewService => 'Добавить новую услугу';

  @override
  String get creating => 'Создание...';

  @override
  String get serviceName => 'Название услуги';

  @override
  String get serviceNamePlaceholder => 'Введите название услуги';

  @override
  String get serviceDescription => 'Описание услуги';

  @override
  String get serviceDescriptionPlaceholder => 'Введите описание услуги';

  @override
  String get serviceCategory => 'Категория услуги';

  @override
  String get selectCategory => 'Выберите категорию';

  @override
  String get loadingCategories => 'Загрузка...';

  @override
  String get errorLoadingCategories => 'Ошибка загрузки категорий';

  @override
  String get serviceImages => 'Изображения услуги';

  @override
  String get imageUploadHelper =>
      'Нажмите на значок + для добавления изображений (максимум 10)';

  @override
  String get maxImagesError => 'Вы можете загрузить максимум 10 изображений';

  @override
  String get categoryNotFound => 'Категория не найдена';

  @override
  String get productCreatedSuccess => 'Товар успешно создан';

  @override
  String get productLikeSuccess => 'Товар успешно лайкнут';

  @override
  String get productDislikeSuccess => 'Лайк с товара успешно убран';

  @override
  String get errorCreatingService => 'Ошибка при создании услуги';

  @override
  String get errorCreatingProduct => 'Ошибка при создании товара';

  @override
  String get unknownError => 'Произошла неизвестная ошибка при создании услуги';

  @override
  String get submit => 'Отправить';

  @override
  String get selectCategoryAction => 'Выберите категорию';

  @override
  String get selectCondition => 'Выберите состояние';

  @override
  String get sum => 'Сумма';

  @override
  String get noComments => 'Пока нет комментариев. Будьте первым!';

  @override
  String get commentLikeSuccess => 'Комментарий успешно лайкнут';

  @override
  String get commentLikeError => 'Ошибка при лайке комментария';

  @override
  String get unknownErrorMessage => 'Произошла неизвестная ошибка';

  @override
  String get commentDislikeSuccess => 'Лайк с комментария успешно убран';

  @override
  String get commentDislikeError => 'Ошибка при снятии лайка с комментария';

  @override
  String get replyInfo => 'Пожалуйста, сначала введите ответ';

  @override
  String get replySuccessMessage => 'Ответ успешно добавлен';

  @override
  String get replyErrorMessage => 'Ошибка при создании ответа';

  @override
  String get commentUpdateSuccess => 'Комментарий успешно обновлен';

  @override
  String get commentUpdateError => 'Ошибка обновления комментария';

  @override
  String get deleteConfirmationMessage =>
      'Вы уверены, что хотите удалить этот комментарий?';

  @override
  String get commentDeleteSuccess => 'Комментарий успешно удален';

  @override
  String get commentDeleteError => 'Ошибка удаления комментария';

  @override
  String get editLabel => 'Редактировать';

  @override
  String get deleteLabel => 'Удалить';

  @override
  String get saveLabel => 'Сохранить';

  @override
  String get replyLabel => 'Ответить';

  @override
  String get replyTitle => 'ответы';

  @override
  String get replyPlaceholder => 'Написать ответ...';

  @override
  String get chatLoginMessage => 'Вы должны войти в систему, чтобы начать чат';

  @override
  String get chatYourselfMessage => 'Вы не можете писать сами себе.';

  @override
  String get chatRoomMessage => 'Чат-комната создана!';

  @override
  String get chatRoomError => 'Не удалось создать чат!';

  @override
  String get chatCreationError => 'Создание чата не удалось!';

  @override
  String get productsTotal => 'Всего товаров';

  @override
  String get perPage => 'элементов';

  @override
  String get clearAllFilters => 'Очистить все фильтры';

  @override
  String get clickToUpload => 'Нажмите для загрузки';

  @override
  String get productInStock => 'В наличии';

  @override
  String get productOutStock => 'Нет в наличии';

  @override
  String get productBack => 'Назад к товарам';

  @override
  String get messageSeller => 'Чат';

  @override
  String get recommendedProducts => 'Рекомендуемые товары';

  @override
  String get deleteConfirmationProduct =>
      'Вы уверены, что хотите удалить этот товар?';

  @override
  String get productDeleteSuccess => 'Товар успешно удален';

  @override
  String get productDeleteError => 'Ошибка удаления товара';

  @override
  String get newCondition => 'Новый';

  @override
  String get used => 'Б/у';

  @override
  String get imageValidType =>
      'Некоторые файлы не были добавлены. Используйте файлы JPG, PNG, GIF или WebP размером менее 5МБ.';

  @override
  String get imageConfirmMessage =>
      'Вы уверены, что хотите удалить это изображение?';

  @override
  String get titleRequiredMessage => 'Название обязательно';

  @override
  String get descRequiredMessage => 'Описание обязательно';

  @override
  String get priceRequiredMessage => 'Цена обязательна';

  @override
  String get conditionRequiredMessage => 'Состояние обязательно';

  @override
  String get pleaseFillAllRequired => 'Пожалуйста, заполните обязательные поля';

  @override
  String get oneImageConfirmMessage =>
      'Требуется хотя бы одно изображение товара';

  @override
  String get categoryRequiredMessage => 'Категория обязательна';

  @override
  String get locationInfoError =>
      'Отсутствует информация о местоположении пользователя';

  @override
  String get editProductTitle => 'Редактировать товар';

  @override
  String get imageUploadRequirements =>
      'Требуется хотя бы одно изображение. Вы можете загрузить до 10 изображений (JPG, PNG, GIF, WebP размером до 5МБ каждое).';

  @override
  String get productUpdatedSuccess => 'Товар успешно обновлен';

  @override
  String get productUpdateFailed => 'Не удалось обновить товар';

  @override
  String get errorUpdatingProduct => 'Произошла ошибка при обновлении товара';

  @override
  String get serviceBack => 'Назад к услугам';

  @override
  String get likeLabel => 'Лайк';

  @override
  String get commentsLabel => 'Комментарии';

  @override
  String get writeComment => 'Написать комментарий...';

  @override
  String get postingLabel => 'Публикация...';

  @override
  String get commentCreated => 'Комментарий создан';

  @override
  String get postCommentLabel => 'Опубликовать комментарий';

  @override
  String get loginPrompt =>
      'Пожалуйста, войдите в систему для просмотра и публикации комментариев.';

  @override
  String get recommendedServices => 'Рекомендуемые услуги';

  @override
  String get commentsVisibilityNotice =>
      'Комментарии видны только авторизованным пользователям.';

  @override
  String get comingSoon => 'Скоро будет';

  @override
  String get serviceUpdateSuccess => 'Услуга успешно обновлена';

  @override
  String get serviceUpdateError => 'Ошибка обновления услуги';

  @override
  String get editServiceModalTitle => 'Редактировать услугу';

  @override
  String get enterPhoneNumberWithoutCode => 'Введите номер телефона без кода';

  @override
  String get heroTitle => 'TezSell';

  @override
  String get heroSubtitle =>
      'Ваш быстрый и простой маркетплейс для Узбекистана';

  @override
  String get startSelling => 'Начать продавать';

  @override
  String get browseProducts => 'Просмотреть товары';

  @override
  String get featuresTitle => 'Почему стоит выбрать TezSell?';

  @override
  String get listingTitle => 'Простое размещение товаров';

  @override
  String get listingDescription =>
      'Размещайте ваши товары всего за несколько кликов. Добавляйте фото, устанавливайте цену и мгновенно связывайтесь с покупателями.';

  @override
  String get locationTitle => 'Поиск по местоположению';

  @override
  String get locationDescription =>
      'Находите предложения рядом с вами. Наша система на основе местоположения поможет вам найти товары в вашем районе.';

  @override
  String get location_subtitle =>
      'Выберите регион и район, чтобы увидеть объявления рядом';

  @override
  String get categoryTitle => 'Фильтрация по категориям';

  @override
  String get categoryDescription =>
      'Легко навигируйте по различным категориям, чтобы найти именно то, что вы ищете.';

  @override
  String get inspirationTitle => 'Вдохновлен корейским Carrot Market';

  @override
  String get inspirationDescription1 =>
      'Мы создали TezSell, вдохновившись успешным корейским Carrot Market (당근마켓), но адаптировали его специально для уникальных потребностей местных сообществ Узбекистана.';

  @override
  String get inspirationDescription2 =>
      'Наша миссия - создать надежную платформу, где соседи могут легко покупать, продавать и общаться друг с другом.';

  @override
  String get comingSoonTitle => 'Скоро в TezSell';

  @override
  String get inAppChat => 'Чат в приложении';

  @override
  String get secureTransactions => 'Безопасные транзакции';

  @override
  String get realEstateListings => 'Объявления недвижимости';

  @override
  String get stayUpdated => 'Оставайтесь в курсе';

  @override
  String get comingSoonBadge => 'Скоро будет';

  @override
  String get ctaTitle => 'Присоединяйтесь к сообществу TezSell сегодня!';

  @override
  String get ctaDescription =>
      'Станьте частью создания лучшего маркетплейса для Узбекистана. Делитесь отзывами и помогайте нам расти!';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get learnMore => 'Узнать больше';

  @override
  String get replyUpdateSuccess => 'Ответ успешно обновлен';

  @override
  String get replyUpdateError => 'Не удалось обновить ответ';

  @override
  String get replyDeleteSuccess => 'Ответ успешно удален';

  @override
  String get replyDeleteError => 'Не удалось удалить ответ';

  @override
  String get replyDeleteConfirmation =>
      'Вы уверены, что хотите удалить этот ответ?';

  @override
  String get authenticationRequired => 'Требуется аутентификация';

  @override
  String get enterValidReply => 'Пожалуйста, введите корректный текст ответа';

  @override
  String get saving => 'Сохранение...';

  @override
  String get deleting => 'Удаление...';

  @override
  String get properties => 'Недвижимость';

  @override
  String get agents => 'Агенты';

  @override
  String get becomeAgent => 'Стать агентом';

  @override
  String get main => 'Главный';

  @override
  String get upload => 'Загрузить';

  @override
  String get filtered_products => 'Отфильтрованные товары';

  @override
  String get productDetail => 'Детали товара';

  @override
  String get unknownUser => 'Неизвестный пользователь';

  @override
  String get locationNotAvailable => 'Местоположение недоступно';

  @override
  String get noTitle => 'Без названия';

  @override
  String get noCategory => 'Без категории';

  @override
  String get noDescription => 'Без описания';

  @override
  String get som => 'Сум';

  @override
  String get about_me => 'Обо мне';

  @override
  String get my_name => 'Мое имя';

  @override
  String get customer_support => 'Поддержка клиентов';

  @override
  String get customer_center => 'Центр клиентов';

  @override
  String get customer_inquiries => 'Запросы';

  @override
  String get customer_terms => 'Условия использования';

  @override
  String get region => 'Регион';

  @override
  String get district => 'Район';

  @override
  String get tap_change_profile => 'Нажмите, чтобы изменить фото';

  @override
  String get language_settings => 'Настройки языка';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get select_theme => 'Выберите тему';

  @override
  String get theme => 'Тема';

  @override
  String get location_settings => 'Настройки местоположения';

  @override
  String get security => 'Безопасность';

  @override
  String get data_storage => 'Данные и хранение';

  @override
  String get accessibility => 'Доступность';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get light_theme => 'Светлая';

  @override
  String get dark_theme => 'Темная';

  @override
  String get system_theme => 'Системная по умолчанию';

  @override
  String get my_products => 'Мои товары';

  @override
  String get refresh => 'Обновить';

  @override
  String get delete_product => 'Удалить товар';

  @override
  String get delete_confirmation =>
      'Вы уверены, что хотите удалить этот товар?';

  @override
  String get delete => 'Удалить';

  @override
  String error_loading_products(String error) {
    return 'Ошибка загрузки товаров: $error';
  }

  @override
  String get product_deleted_success => 'Товар успешно удален';

  @override
  String error_deleting_product(String error) {
    return 'Ошибка удаления товара: $error';
  }

  @override
  String get no_products_found => 'Товары не найдены';

  @override
  String get add_first_product => 'Начните с добавления вашего первого товара';

  @override
  String get no_title => 'Без названия';

  @override
  String get no_description => 'Без описания';

  @override
  String get in_stock => 'В наличии';

  @override
  String get out_of_stock => 'Нет в наличии';

  @override
  String get new_condition => 'НОВЫЙ';

  @override
  String get edit_product => 'Редактировать товар';

  @override
  String get delete_product_tooltip => 'Удалить товар';

  @override
  String get sum_currency => 'Сум';

  @override
  String get edit_product_title => 'Редактировать товар';

  @override
  String get product_name => 'Название товара';

  @override
  String get product_description => 'Описание товара';

  @override
  String get price => 'Цена';

  @override
  String get condition => 'Состояние';

  @override
  String get condition_new => 'Новый';

  @override
  String get condition_used => 'Б/у';

  @override
  String get condition_refurbished => 'Восстановленный';

  @override
  String get currency => 'Валюта';

  @override
  String get category => 'Категория';

  @override
  String get images => 'Изображения';

  @override
  String get existing_images => 'Существующие изображения';

  @override
  String get new_images => 'Новые изображения';

  @override
  String get image_instructions =>
      'Изображения появятся здесь. Пожалуйста, нажмите на значок загрузки выше.';

  @override
  String get update_button => 'Обновить';

  @override
  String loading_category_error(String error) {
    return 'Ошибка загрузки категорий: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Ошибка выбора изображений: $error';
  }

  @override
  String get please_fill_all_required => 'Пожалуйста, заполните все поля';

  @override
  String get invalid_price_message =>
      'Введена неверная цена. Пожалуйста, введите корректное число.';

  @override
  String get category_required_message =>
      'Пожалуйста, выберите действительную категорию.';

  @override
  String get one_image_required_message =>
      'Требуется хотя бы одно изображение товара';

  @override
  String get product_updated_success => 'Товар успешно обновлен';

  @override
  String error_updating_product(String error) {
    return 'Ошибка при обновлении товара: $error';
  }

  @override
  String get my_services => 'Мои услуги';

  @override
  String get delete_service => 'Удалить услугу';

  @override
  String get delete_service_confirmation =>
      'Вы уверены, что хотите удалить эту услугу?';

  @override
  String get no_services_found => 'Услуги не найдены';

  @override
  String get add_first_service => 'Начните с добавления вашей первой услуги';

  @override
  String get edit_service => 'Редактировать услугу';

  @override
  String get delete_service_tooltip => 'Удалить услугу';

  @override
  String get service_deleted_successfully => 'Услуга успешно удалена';

  @override
  String get error_deleting_service => 'Ошибка удаления услуги';

  @override
  String get error_loading_services => 'Ошибка загрузки услуг';

  @override
  String get service_name => 'Название услуги';

  @override
  String get enter_service_name => 'Введите название услуги';

  @override
  String get service_name_required => 'Название услуги обязательно';

  @override
  String get service_name_min_length =>
      'Название услуги должно содержать минимум 3 символа';

  @override
  String get enter_service_description => 'Введите описание услуги';

  @override
  String get service_description_required => 'Описание услуги обязательно';

  @override
  String get service_description_min_length =>
      'Описание должно содержать минимум 10 символов';

  @override
  String get category_required => 'Пожалуйста, выберите категорию';

  @override
  String get no_categories_available => 'Категории недоступны';

  @override
  String get location => 'Местоположение';

  @override
  String get select_location => 'Выберите местоположение';

  @override
  String get location_required => 'Пожалуйста, выберите местоположение';

  @override
  String get no_locations_available => 'Местоположения недоступны';

  @override
  String get add_images => 'Добавить изображения';

  @override
  String get current_images => 'Текущие изображения';

  @override
  String get no_images_selected => 'Изображения не выбраны';

  @override
  String get save_changes => 'Сохранить изменения';

  @override
  String get map_main => 'Карта и недвижимость';

  @override
  String get agent_status => 'Статус агента';

  @override
  String get admin_panel => 'Админ панель';

  @override
  String get propertiesFound => 'Найдено объектов';

  @override
  String get propertiesSaved => 'объектов сохранено';

  @override
  String get saved => 'сохранено';

  @override
  String get loadingProperties => 'Загрузка объектов...';

  @override
  String get failedToLoad => 'Не удалось загрузить объекты. Попробуйте снова.';

  @override
  String get noPropertiesFound => 'Объекты не найдены';

  @override
  String get tryAdjusting => 'Попробуйте изменить критерии поиска';

  @override
  String get search_placeholder => 'Поиск по названию или местоположению...';

  @override
  String get search_filters => 'Фильтры';

  @override
  String get search_button => 'Поиск';

  @override
  String get search_clear_filters => 'Очистить фильтры';

  @override
  String get filter_options_sale_and_rent => 'Продажа и аренда';

  @override
  String get filter_options_for_sale => 'На продажу';

  @override
  String get filter_options_for_rent => 'В аренду';

  @override
  String get filter_options_all_types => 'Все типы';

  @override
  String get filter_options_apartment => 'Квартира';

  @override
  String get filter_options_house => 'Дом';

  @override
  String get filter_options_townhouse => 'Таунхаус';

  @override
  String get filter_options_villa => 'Вилла';

  @override
  String get filter_options_commercial => 'Коммерческая';

  @override
  String get filter_options_office => 'Офис';

  @override
  String get property_card_featured => 'Рекомендуемая';

  @override
  String get property_card_bed => 'спальня';

  @override
  String get property_card_bath => 'ванная';

  @override
  String get property_card_parking => 'парковка';

  @override
  String get property_card_view_details => 'Подробности';

  @override
  String get property_card_contact => 'Контакт';

  @override
  String get property_card_balcony => 'Балкон';

  @override
  String get property_card_garage => 'Гараж';

  @override
  String get property_card_garden => 'Сад';

  @override
  String get property_card_pool => 'Бассейн';

  @override
  String get property_card_elevator => 'Лифт';

  @override
  String get property_card_furnished => 'Меблированная';

  @override
  String get property_card_sales => 'продажи';

  @override
  String get pricing_month => '/месяц';

  @override
  String get results_properties_found => 'Найдено недвижимости';

  @override
  String get results_properties_saved => 'недвижимость сохранена';

  @override
  String get results_saved => 'сохранено';

  @override
  String get results_loading_properties => 'Загрузка недвижимости...';

  @override
  String get results_failed_to_load =>
      'Не удалось загрузить недвижимость. Попробуйте еще раз.';

  @override
  String get results_no_properties_found => 'Недвижимость не найдена';

  @override
  String get results_try_adjusting => 'Попробуйте изменить критерии поиска';

  @override
  String get no_properties_found => 'Недвижимость не найдена';

  @override
  String get no_category_properties => 'В этой категории нет недвижимости';

  @override
  String get properties_loading => 'Загрузка недвижимости...';

  @override
  String get all_properties_loaded => 'Вся недвижимость загружена';

  @override
  String get pagination_previous => 'Предыдущая';

  @override
  String get pagination_next => 'Следующая';

  @override
  String get pagination_page => 'Страница';

  @override
  String get pagination_page_of => 'Страница 1 из';

  @override
  String get contact_modal_title => 'Контактная информация';

  @override
  String get contact_modal_agent_contact => 'Контакт агента';

  @override
  String get contact_modal_property_owner => 'Владелец недвижимости';

  @override
  String get contact_modal_agent_phone_number => 'Номер телефона агента';

  @override
  String get contact_modal_owner_phone_number => 'Номер телефона владельца';

  @override
  String get contact_modal_license => 'Лицензия';

  @override
  String get contact_modal_rating => 'Рейтинг';

  @override
  String get contact_modal_call_now => 'Позвонить сейчас';

  @override
  String get contact_modal_copy_number => 'Копировать номер';

  @override
  String get contact_modal_close => 'Закрыть';

  @override
  String get contact_modal_contact_hours => 'Часы контакта: 9:00 - 20:00';

  @override
  String get contact_modal_agent => 'Агент';

  @override
  String get errors_toggle_save_failed =>
      'Не удалось переключить сохранение недвижимости:';

  @override
  String get errors_copy_failed => 'Не удалось скопировать номер телефона:';

  @override
  String get errors_phone_copied => 'Номер телефона скопирован в буфер обмена';

  @override
  String get errors_error_occurred_regions => 'Произошла ошибка с регионами';

  @override
  String get errors_error_occurred_districts => 'Произошла ошибка с районами';

  @override
  String get errors_please_fill_all_required_fields =>
      'Пожалуйста, заполните все обязательные поля';

  @override
  String get errors_authentication_required => 'Требуется аутентификация';

  @override
  String get errors_user_info_missing =>
      'Информация о пользователе отсутствует';

  @override
  String get errors_validation_error =>
      'Пожалуйста, проверьте введенные данные';

  @override
  String get errors_permission_denied => 'Доступ запрещен';

  @override
  String get errors_server_error => 'Произошла ошибка сервера';

  @override
  String get errors_network_error => 'Ошибка сетевого соединения';

  @override
  String get errors_timeout_error => 'Превышено время ожидания запроса';

  @override
  String get errors_custom_error => 'Произошла ошибка';

  @override
  String get errors_error_creating_property => 'Ошибка создания недвижимости';

  @override
  String get errors_unknown_error_message => 'Произошла неизвестная ошибка';

  @override
  String get errors_coordinates_not_found =>
      'Не удалось найти координаты для этого адреса. Пожалуйста, введите их вручную.';

  @override
  String get errors_coordinates_error =>
      'Ошибка получения координат. Пожалуйста, введите их вручную.';

  @override
  String get property_info_views => 'просмотров';

  @override
  String get property_info_listed => 'Размещено';

  @override
  String get property_info_price_per_sqm => '/м²';

  @override
  String get property_info_saved => 'Сохранено';

  @override
  String get property_info_save => 'Сохранить';

  @override
  String get property_info_share => 'Поделиться';

  @override
  String get loading_loading => 'Загрузка...';

  @override
  String get loading_loading_details => 'Загрузка деталей недвижимости...';

  @override
  String get loading_property_not_found => 'Недвижимость не найдена';

  @override
  String get loading_property_not_found_message =>
      'Недвижимость, которую вы ищете, не существует или была удалена.';

  @override
  String get loading_back_to_properties => 'Вернуться к недвижимости';

  @override
  String get loading_title => 'Загрузка агентов...';

  @override
  String get loading_message =>
      'Пожалуйста, подождите, пока мы загружаем список агентов.';

  @override
  String get loading_agent_not_found => 'Агент не найден';

  @override
  String get property_details_title => 'Детали недвижимости';

  @override
  String get property_details_bedrooms => 'Спальни';

  @override
  String get property_details_bathrooms => 'Ванные комнаты';

  @override
  String get property_details_floor_area => 'Площадь этажа';

  @override
  String get property_details_parking => 'Парковка';

  @override
  String get property_details_basic_information => 'Основная информация';

  @override
  String get property_details_property_type => 'Тип недвижимости:';

  @override
  String get property_details_listing_type => 'Тип объявления:';

  @override
  String get property_details_for_sale => 'На продажу';

  @override
  String get property_details_for_rent => 'В аренду';

  @override
  String get property_details_year_built => 'Год постройки:';

  @override
  String get property_details_floor => 'Этаж:';

  @override
  String get property_details_of => 'из';

  @override
  String get property_details_features_amenities => 'Особенности и удобства';

  @override
  String get sections_description => 'Описание';

  @override
  String get sections_nearby_amenities => 'Ближайшие удобства';

  @override
  String get sections_similar_properties => 'Похожая недвижимость';

  @override
  String get amenities_metro => 'Метро';

  @override
  String get amenities_school => 'Школа';

  @override
  String get amenities_hospital => 'Больница';

  @override
  String get amenities_shopping => 'Магазины';

  @override
  String get amenities_away => 'расстояние';

  @override
  String get contact_title => 'Контактная информация';

  @override
  String get contact_professional_listing => 'Профессиональное объявление';

  @override
  String get contact_listed_by_agent => 'Размещено проверенным агентом';

  @override
  String get contact_by_owner => 'От владельца';

  @override
  String get contact_direct_contact =>
      'Прямой контакт с владельцем недвижимости';

  @override
  String get contact_property_owner => 'Владелец недвижимости';

  @override
  String get contact_call_agent => 'Позвонить агенту';

  @override
  String get contact_email_agent => 'Отправить email агенту';

  @override
  String get contact_call_owner => 'Позвонить владельцу';

  @override
  String get contact_email_owner => 'Отправить email владельцу';

  @override
  String get contact_send_inquiry => 'Отправить запрос';

  @override
  String get property_status_title => 'Статус недвижимости';

  @override
  String get property_status_availability => 'Доступность:';

  @override
  String get property_status_available => 'Доступна';

  @override
  String get property_status_not_available => 'Недоступна';

  @override
  String get property_status_featured => 'Рекомендуемая:';

  @override
  String get property_status_featured_property => 'Рекомендуемая недвижимость';

  @override
  String get property_status_property_id => 'ID недвижимости:';

  @override
  String get inquiry_title => 'Отправить запрос';

  @override
  String get inquiry_inquiry_type => 'Тип запроса';

  @override
  String get inquiry_request_info => 'Запросить информацию';

  @override
  String get inquiry_schedule_viewing => 'Запланировать просмотр';

  @override
  String get inquiry_make_offer => 'Сделать предложение';

  @override
  String get inquiry_request_callback => 'Запросить обратный звонок';

  @override
  String get inquiry_message => 'Сообщение';

  @override
  String get inquiry_message_placeholder =>
      'Расскажите нам о вашем интересе к этой недвижимости...';

  @override
  String get inquiry_offered_price => 'Предлагаемая цена';

  @override
  String get inquiry_enter_offer => 'Введите ваше предложение';

  @override
  String get inquiry_preferred_contact_time =>
      'Предпочтительное время контакта (необязательно)';

  @override
  String get inquiry_contact_time_placeholder => 'например, Будни 9:00 - 17:00';

  @override
  String get inquiry_cancel => 'Отмена';

  @override
  String get inquiry_sending => 'Отправка...';

  @override
  String get inquiry_send_inquiry => 'Отправить запрос';

  @override
  String get inquiry_inquiry_sent_success => 'Запрос успешно отправлен!';

  @override
  String get inquiry_inquiry_sent_error =>
      'Не удалось отправить запрос. Попробуйте еще раз.';

  @override
  String get alerts_link_copied =>
      'Ссылка на недвижимость скопирована в буфер обмена!';

  @override
  String get alerts_phone_copied => 'Номер телефона скопирован в буфер обмена!';

  @override
  String get alerts_save_property_failed =>
      'Не удалось сохранить недвижимость:';

  @override
  String get alerts_email_subject => 'Запрос о:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Здравствуйте,\\n\\nМеня интересует ваша недвижимость \"$title\" расположенная по адресу $address.\\n\\nПожалуйста, свяжитесь со мной для получения дополнительной информации.\\n\\nС наилучшими пожеланиями';
  }

  @override
  String get related_properties_view_details => 'Подробности';

  @override
  String get header_property => 'Найдите недвижимость вашей мечты';

  @override
  String get header_sub_property =>
      'Откройте для себя премиальные возможности недвижимости в самых желанных районах Ташкента';

  @override
  String get header_title => 'Агенты по недвижимости';

  @override
  String get header_subtitle =>
      'Найдите опытных агентов для помощи с вашими потребностями в недвижимости';

  @override
  String get header_agents_found => 'агентов найдено';

  @override
  String get filters_all_specializations => 'Все специализации';

  @override
  String get filters_residential => 'Жилая';

  @override
  String get filters_commercial => 'Коммерческая';

  @override
  String get filters_luxury => 'Элитная недвижимость';

  @override
  String get filters_investment => 'Инвестиционная';

  @override
  String get filters_any_rating => 'Любой рейтинг';

  @override
  String get filters_four_stars => '4+ звезды';

  @override
  String get filters_four_half_stars => '4.5+ звезды';

  @override
  String get filters_five_stars => '5 звезд';

  @override
  String get filters_highest_rated => 'Самый высокий рейтинг';

  @override
  String get filters_lowest_rated => 'Самый низкий рейтинг';

  @override
  String get filters_most_sales => 'Больше всего продаж';

  @override
  String get filters_most_experience => 'Больше всего опыта';

  @override
  String get agent_card_verified_agent => 'Проверенный агент';

  @override
  String get agent_card_years_experience => 'лет опыта';

  @override
  String get agent_card_years => 'лет';

  @override
  String get agent_card_license => 'Лицензия';

  @override
  String get agent_card_specialization => 'Специализация';

  @override
  String get agent_card_view_profile => 'Просмотр профиля';

  @override
  String get agent_card_contact => 'Контакт';

  @override
  String get agent_card_verified => 'Проверен';

  @override
  String get no_results_title => 'Агенты не найдены';

  @override
  String get no_results_message =>
      'Попробуйте изменить критерии поиска или фильтры.';

  @override
  String get error_title => 'Ошибка загрузки агентов';

  @override
  String get error_message =>
      'Не удалось загрузить список агентов. Попробуйте еще раз.';

  @override
  String get error_retry => 'Повторить';

  @override
  String get error_default_message => 'Не удалось загрузить детали агента';

  @override
  String get error_try_again => 'Попробовать еще раз';

  @override
  String get notifications_phone_copied =>
      'Номер телефона скопирован в буфер обмена';

  @override
  String get notifications_copy_failed =>
      'Не удалось скопировать номер телефона:';

  @override
  String get fallback_agent_name => 'Агент';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Подать недвижимость';

  @override
  String get navigation_submitting => 'Отправка...';

  @override
  String get navigation_back_to_agents => 'Вернуться к агентам';

  @override
  String get agent_profile_verified_agent => 'Проверенный агент';

  @override
  String get agent_profile_contact_agent => 'Связаться с агентом';

  @override
  String get agent_profile_send_message => 'Отправить сообщение';

  @override
  String get agent_profile_years_experience => 'Лет опыта';

  @override
  String get agent_profile_properties_sold => 'Продано недвижимости';

  @override
  String get agent_profile_active_listings => 'Активные объявления';

  @override
  String get agent_profile_total_properties => 'Всего недвижимости';

  @override
  String get tabs_overview => 'обзор';

  @override
  String get tabs_properties => 'недвижимость';

  @override
  String get tabs_reviews => 'отзывы';

  @override
  String get about_agent_title => 'О агенте';

  @override
  String get about_agent_agency => 'Агентство';

  @override
  String get about_agent_license_number => 'Номер лицензии';

  @override
  String get about_agent_specialization => 'Специализация';

  @override
  String get about_agent_member_since => 'Участник с';

  @override
  String get about_agent_verified_since => 'Проверен с';

  @override
  String get performance_metrics_title => 'Показатели эффективности';

  @override
  String get performance_metrics_average_rating => 'Средний рейтинг';

  @override
  String get performance_metrics_properties_sold => 'Продано недвижимости';

  @override
  String get performance_metrics_active_listings => 'Активные объявления';

  @override
  String get performance_metrics_years_experience => 'Лет опыта';

  @override
  String get contact_info_title => 'Контактная информация';

  @override
  String get contact_info_contact_via_platform => 'Связаться через платформу';

  @override
  String get verification_status_title => 'Статус проверки';

  @override
  String get verification_status_verified_agent => 'Проверенный агент';

  @override
  String get verification_status_pending_verification => 'Ожидает проверки';

  @override
  String get verification_status_licensed_professional =>
      'Лицензированный специалист';

  @override
  String get verification_status_registered_agency =>
      'Зарегистрированное агентство';

  @override
  String get quick_actions_title => 'Быстрые действия';

  @override
  String get quick_actions_call_now => 'Позвонить сейчас';

  @override
  String get quick_actions_send_message => 'Отправить сообщение';

  @override
  String get quick_actions_view_properties => 'Просмотр недвижимости';

  @override
  String get properties_title => 'Недвижимость агента';

  @override
  String get properties_loading_properties => 'Загрузка недвижимости...';

  @override
  String get properties_no_properties_title => 'Недвижимость не найдена';

  @override
  String get properties_no_properties_message =>
      'Недвижимость этого агента появится здесь.';

  @override
  String get properties_recent_properties_note =>
      'Показаны последние объекты недвижимости. Для всех объектов агента проверьте полные списки.';

  @override
  String get properties_listed => 'Размещено';

  @override
  String get properties_bed => 'спальня';

  @override
  String get properties_bath => 'ванная';

  @override
  String get properties_for_sale => 'На продажу';

  @override
  String get properties_for_rent => 'В аренду';

  @override
  String get reviews_title => 'Отзывы клиентов';

  @override
  String get reviews_no_reviews_title => 'Пока нет отзывов';

  @override
  String get reviews_no_reviews_message =>
      'Отзывы и рекомендации клиентов появятся здесь.';

  @override
  String get fallbacks_agent_name => 'Агент';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => 'Сохраненная недвижимость';

  @override
  String get saved_properties_subtitle =>
      'Ваша избранная недвижимость в одном месте';

  @override
  String get saved_properties_no_saved_properties =>
      'Пока нет сохраненной недвижимости';

  @override
  String get saved_properties_start_saving =>
      'Начните исследовать и сохранять понравившуюся недвижимость';

  @override
  String get saved_properties_browse_properties => 'Просмотр недвижимости';

  @override
  String get saved_properties_saved_on => 'Сохранено';

  @override
  String get auth_login_required =>
      'Пожалуйста, войдите в систему для просмотра сохраненной недвижимости';

  @override
  String get auth_login => 'Войти';

  @override
  String get success_property_unsaved =>
      'Недвижимость удалена из сохраненного списка';

  @override
  String get success_property_saved => 'Недвижимость успешно сохранена';

  @override
  String get success_phone_copied => 'Номер телефона скопирован!';

  @override
  String get success_property_created_success =>
      'Недвижимость успешно создана!';

  @override
  String get success_agent_approved => 'Агент успешно одобрен';

  @override
  String get success_agent_rejected => 'Агент успешно отклонен';

  @override
  String get steps_step => 'Шаг';

  @override
  String get steps_basic_information => 'Основная информация';

  @override
  String get steps_location_details => 'Детали местоположения';

  @override
  String get steps_property_details => 'Детали недвижимости';

  @override
  String get steps_property_images => 'Изображения недвижимости';

  @override
  String get basic_info_tell_us_about_property =>
      'Расскажите нам о вашей недвижимости';

  @override
  String get basic_info_property_type => 'Тип недвижимости';

  @override
  String get basic_info_listing_type => 'Тип объявления';

  @override
  String get basic_info_property_title => 'Название недвижимости';

  @override
  String get basic_info_title_placeholder =>
      'Введите описательное название для вашей недвижимости';

  @override
  String get basic_info_description => 'Описание';

  @override
  String get basic_info_description_placeholder =>
      'Опишите вашу недвижимость подробно...';

  @override
  String get property_types_apartment => 'Квартира';

  @override
  String get property_types_house => 'Дом';

  @override
  String get property_types_townhouse => 'Таунхаус';

  @override
  String get property_types_villa => 'Вилла';

  @override
  String get property_types_commercial => 'Коммерческая';

  @override
  String get property_types_office => 'Офис';

  @override
  String get property_types_land => 'Земля';

  @override
  String get property_types_warehouse => 'Склад';

  @override
  String get listing_types_for_sale => 'На продажу';

  @override
  String get listing_types_for_rent => 'В аренду';

  @override
  String get location_where_is_property => 'Где находится ваша недвижимость?';

  @override
  String get location_full_address => 'Полный адрес';

  @override
  String get location_address_placeholder => 'Введите полный адрес';

  @override
  String get location_region => 'Регион';

  @override
  String get location_select_region => 'Выберите регион';

  @override
  String get location_district => 'Район';

  @override
  String get location_select_district => 'Выберите район';

  @override
  String get location_city => 'Город';

  @override
  String get location_city_placeholder => 'Город';

  @override
  String get location_loading_regions => 'Загрузка регионов...';

  @override
  String get location_loading_districts => 'Загрузка районов...';

  @override
  String get location_map_coordinates => 'Координаты карты';

  @override
  String get location_get_coordinates => 'Получить координаты';

  @override
  String get location_latitude => 'Широта';

  @override
  String get location_longitude => 'Долгота';

  @override
  String get location_coordinates_set => 'Координаты установлены';

  @override
  String get location_location_tips => 'Советы по местоположению';

  @override
  String get location_location_tip_1 =>
      '• Сначала заполните адрес, затем нажмите \"Получить координаты\" для автоматического получения местоположения на карте';

  @override
  String get location_location_tip_2 =>
      '• Вы также можете вручную ввести координаты, если знаете точное местоположение';

  @override
  String get location_location_tip_3 =>
      '• Точные координаты помогают покупателям найти вашу недвижимость на карте';

  @override
  String get property_details_provide_detailed_info =>
      'Предоставьте подробную информацию о вашей недвижимости';

  @override
  String get property_details_total_floors => 'Всего этажей';

  @override
  String get property_details_area_m2 => 'Площадь (м²)';

  @override
  String get property_details_parking_spaces => 'Парковочные места';

  @override
  String get property_details_price => 'Цена';

  @override
  String get property_details_features => 'Особенности';

  @override
  String get images_add_photos_showcase =>
      'Добавьте фотографии для демонстрации вашей недвижимости';

  @override
  String get images_click_to_upload => 'Нажмите для загрузки изображений';

  @override
  String get images_max_images_info =>
      'Максимум 10 изображений, JPG, PNG или WEBP';

  @override
  String get images_main => 'Главное';

  @override
  String get images_maximum_images_allowed =>
      'Разрешено максимум 10 изображений';

  @override
  String get admin_dashboard_title => 'Панель администратора';

  @override
  String get admin_dashboard_subtitle =>
      'Обзор вашей платформы недвижимости в реальном времени';

  @override
  String get admin_last_update => 'Последнее обновление';

  @override
  String get admin_total_properties => 'Всего недвижимости';

  @override
  String get admin_total_agents => 'Всего агентов';

  @override
  String get admin_total_users => 'Всего пользователей';

  @override
  String get admin_total_views => 'Всего просмотров';

  @override
  String get admin_error_loading_dashboard => 'Ошибка загрузки панели';

  @override
  String get admin_failed_to_load_data => 'Не удалось загрузить данные панели';

  @override
  String get admin_avg_sale_price => 'Средняя цена продажи';

  @override
  String get admin_avg_sale_price_subtitle => 'Все активные объекты';

  @override
  String get admin_total_portfolio_value => 'Общая стоимость портфеля';

  @override
  String get admin_total_portfolio_value_subtitle =>
      'Совокупная стоимость недвижимости';

  @override
  String get admin_avg_price_per_sqm => 'Средняя цена за кв.м';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Индикатор рыночной ставки';

  @override
  String get admin_property_types_distribution =>
      'Распределение типов недвижимости';

  @override
  String get admin_properties_by_city => 'Недвижимость по городам';

  @override
  String get admin_properties_by_district => 'Недвижимость по районам';

  @override
  String get admin_inquiry_types_distribution => 'Распределение типов запросов';

  @override
  String get admin_agent_verification_rate => 'Степень проверки агентов';

  @override
  String get admin_agent_verification_rate_subtitle => 'Контроль качества';

  @override
  String get admin_inquiry_response_rate => 'Степень ответа на запросы';

  @override
  String get admin_inquiry_response_rate_subtitle => 'Обслуживание клиентов';

  @override
  String get admin_avg_views_per_property =>
      'Средние просмотры на недвижимость';

  @override
  String get admin_avg_views_per_property_subtitle =>
      'Популярность недвижимости';

  @override
  String get admin_featured_properties => 'Рекомендуемая недвижимость';

  @override
  String get admin_featured_properties_subtitle => 'Премиум объявления';

  @override
  String get admin_most_viewed_properties =>
      'Самая просматриваемая недвижимость';

  @override
  String get admin_top_performing_agents => 'Лучшие агенты';

  @override
  String get admin_system_health => 'Состояние системы';

  @override
  String get admin_properties_without_images => 'Недвижимость без изображений';

  @override
  String get admin_missing_location_data =>
      'Отсутствующие данные о местоположении';

  @override
  String get admin_pending_agent_verification => 'Ожидающие проверки агенты';

  @override
  String get admin_active => 'активные';

  @override
  String get admin_verified => 'проверенные';

  @override
  String get admin_active_7d => 'активные (7д)';

  @override
  String get admin_this_month => 'в этом месяце';

  @override
  String get agents_loading_pending_applications =>
      'Загрузка ожидающих заявок...';

  @override
  String get agents_error_loading_applications => 'Ошибка загрузки заявок';

  @override
  String get agents_pending_agents => 'Ожидающие агенты';

  @override
  String get agents_total_pending_applications => 'Всего ожидающих заявок: ';

  @override
  String get agents_pending_verification => 'Ожидает проверки';

  @override
  String get agents_applied_date => 'Подано: ';

  @override
  String get agents_contact_info => 'Контактная информация';

  @override
  String get agents_license_number => 'Номер лицензии';

  @override
  String get agents_years_experience => 'Лет опыта';

  @override
  String get agents_years_suffix => ' лет';

  @override
  String get agents_total_sales => 'Всего продаж';

  @override
  String get agents_specialization => 'Специализация';

  @override
  String get agents_approve => 'Одобрить';

  @override
  String get agents_reject => 'Отклонить';

  @override
  String get agents_no_pending_applications => 'Нет ожидающих заявок';

  @override
  String get agents_all_applications_processed =>
      'Все заявки агентов обработаны';

  @override
  String get general_previous => 'Предыдущая';

  @override
  String get general_page => 'Страница ';

  @override
  String get general_next => 'Следующая';

  @override
  String get general_views => 'просмотры';

  @override
  String get general_sales => 'продажи';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'Русский';

  @override
  String get general_language_en => 'English';

  @override
  String get general_super_admin => 'Супер администратор';

  @override
  String get general_staff => 'Персонал';

  @override
  String get general_verified_agent => 'Проверенный агент';

  @override
  String get general_pending_agent => 'Ожидающий агент';

  @override
  String get general_regular_user => 'Пользователь';

  @override
  String get general_admin => 'Администратор';

  @override
  String get general_dashboard => 'Панель';

  @override
  String get general_manage_users => 'Управление пользователями';

  @override
  String get general_verified_agents => 'Проверенные агенты';

  @override
  String get general_agent_panel => 'Панель агента';

  @override
  String get general_create_property => 'Создать недвижимость';

  @override
  String get general_my_properties => 'Моя недвижимость';

  @override
  String get general_inquiries => 'Запросы';

  @override
  String get general_agent_profile => 'Профиль агента';

  @override
  String get general_live => 'Онлайн';

  @override
  String get general_logged_out_successfully => 'Успешный выход из системы';

  @override
  String get general_logout_completed_with_errors =>
      'Выход выполнен (с ошибками)';

  @override
  String get general_application_under_review => 'Заявка на рассмотрении';

  @override
  String get general_check_status => 'Проверить статус →';

  @override
  String get general_last_updated => 'Последнее обновление:';

  @override
  String get general_permissions_may_be_outdated =>
      'Права доступа могут быть устаревшими';

  @override
  String get general_permissions_up_to_date => 'Права доступа актуальны';

  @override
  String get general_never => 'Никогда';

  @override
  String get general_properties_found => 'Объектов найдено';

  @override
  String get general_properties_saved => 'объектов сохранено';

  @override
  String get general_saved => 'сохранено';

  @override
  String get general_loading_properties => 'Загрузка объектов...';

  @override
  String get general_failed_to_load => 'Не удалось загрузить объекты. Попробуй';

  @override
  String get general_no_properties_found => 'Объекты не найдены';

  @override
  String get general_try_adjusting => 'Попробуйте изменить критерии поиска';

  @override
  String get select_category => 'Выберите категорию';

  @override
  String get service_description => 'Описание услуги';

  @override
  String get product_search_placeholder =>
      'Введите поисковый запрос, чтобы найти товары';

  @override
  String get privacy_policy => 'Политика конфиденциальности';

  @override
  String get terms_subtitle => 'Конфиденциальность и условия';

  @override
  String get last_updated => 'Последнее обновление';

  @override
  String get contact_information => 'Контактная информация';

  @override
  String get accept_terms => 'Я принимаю Условия использования';

  @override
  String get read_terms => 'Пожалуйста, прочитайте наши условия';

  @override
  String get inquiries => 'Обращения и поддержка';

  @override
  String get inquiries_subtitle => 'Свяжитесь с нами';

  @override
  String get help_center => 'Как мы можем вам помочь?';

  @override
  String get help_subtitle => 'Мы готовы ответить на ваши вопросы';

  @override
  String get contact_us => 'Связаться с нами';

  @override
  String get email_support => 'Поддержка по Email';

  @override
  String get call_support => 'Позвонить в поддержку';

  @override
  String get send_message => 'Отправить сообщение';

  @override
  String get fill_contact_form => 'Заполните форму';

  @override
  String get contact_form => 'Форма обратной связи';

  @override
  String get name => 'Ваше имя';

  @override
  String get name_required => 'Пожалуйста, введите имя';

  @override
  String get email => 'Email адрес';

  @override
  String get email_required => 'Пожалуйста, введите email';

  @override
  String get email_invalid => 'Введите корректный email';

  @override
  String get subject => 'Тема';

  @override
  String get subject_required => 'Пожалуйста, введите тему';

  @override
  String get message => 'Сообщение';

  @override
  String get message_required => 'Пожалуйста, введите сообщение';

  @override
  String get message_too_short =>
      'Сообщение должно содержать минимум 10 символов';

  @override
  String get faq => 'Часто задаваемые вопросы';

  @override
  String get follow_us => 'Подписывайтесь на нас';

  @override
  String get faq_how_to_sell => 'Как продать товар на Tezsell?';

  @override
  String get faq_how_to_sell_answer =>
      'Чтобы продать товар: 1) Создайте аккаунт, 2) Нажмите кнопку \'+\', 3) Выберите категорию (Товары/Услуги/Недвижимость), 4) Добавьте фото и описание, 5) Установите цену, 6) Опубликуйте! Ваше объявление будет видно покупателям в вашем районе.';

  @override
  String get faq_is_free => 'Tezsell бесплатный?';

  @override
  String get faq_is_free_answer =>
      'Да! Tezsell на данный момент полностью бесплатный. Нет платы за размещение, нет комиссии с продаж, нет абонентской платы. Мы можем ввести премиум-функции в будущем, но уведомим пользователей за 30 дней.';

  @override
  String get faq_safety => 'Как оставаться в безопасности при покупке/продаже?';

  @override
  String get faq_safety_answer =>
      'Советы по безопасности: 1) Встречайтесь в общественных местах, 2) Проверяйте товары перед оплатой, 3) Не отправляйте деньги незнакомцам, 4) Доверяйте интуиции, 5) Сообщайте о подозрительных пользователях, 6) Не делитесь личной информацией слишком рано, 7) Берите друга на дорогие сделки.';

  @override
  String get faq_payment => 'Как работают платежи?';

  @override
  String get faq_payment_answer =>
      'Tezsell не обрабатывает платежи. Покупатели и продавцы договариваются о платеже напрямую (наличные, банковский перевод и т.д.). Мы просто платформа для связи людей - вы сами проводите сделку.';

  @override
  String get faq_prohibited => 'Какие товары запрещены?';

  @override
  String get faq_prohibited_answer =>
      'Запрещенные товары: оружие, наркотики, краденое, контрафакт, контент для взрослых, живые животные (без разрешений), государственные удостоверения, опасные материалы. Полный список в Условиях использования.';

  @override
  String get faq_account_delete => 'Как удалить аккаунт?';

  @override
  String get faq_account_delete_answer =>
      'Перейдите в Профиль → Настройки → Настройки аккаунта → Удалить аккаунт. Внимание: это необратимо. Все ваши объявления будут удалены.';

  @override
  String get faq_report_user =>
      'Как пожаловаться на пользователя или объявление?';

  @override
  String get faq_report_user_answer =>
      'Нажмите три точки (•••) на любом объявлении или профиле пользователя, выберите \'Пожаловаться\'. Выберите причину и отправьте. Мы рассматриваем все жалобы в течение 24-48 часов.';

  @override
  String get faq_change_location => 'Как изменить местоположение?';

  @override
  String get faq_change_location_answer =>
      'Нажмите кнопку местоположения в левом верхнем углу главного экрана. Вы можете выбрать регион и район для просмотра объявлений в вашем районе.';

  @override
  String get welcome_customer_center => 'Добро пожаловать в центр поддержки';

  @override
  String get customer_center_subtitle => 'Мы здесь, чтобы помочь вам 24/7';

  @override
  String get quick_actions => 'Быстрые действия';

  @override
  String get live_chat => 'Онлайн-чат';

  @override
  String get chat_with_us => 'Напишите нам';

  @override
  String get find_answers => 'Найти ответы';

  @override
  String get my_tickets => 'Мои обращения';

  @override
  String get view_tickets => 'Просмотр обращений';

  @override
  String get feedback => 'Отзыв';

  @override
  String get share_feedback => 'Оставить отзыв';

  @override
  String get contact_methods => 'Способы связи';

  @override
  String get phone_support => 'Телефонная поддержка';

  @override
  String get available_247 => 'Доступно 24/7';

  @override
  String get response_24h => 'Ответ в течение 24 часов';

  @override
  String get telegram_support => 'Поддержка в Telegram';

  @override
  String get instant_replies => 'Мгновенные ответы';

  @override
  String get whatsapp_support => 'Поддержка в WhatsApp';

  @override
  String get quick_response => 'Быстрый ответ';

  @override
  String get popular_topics => 'Популярные темы';

  @override
  String get account_management => 'Управление аккаунтом';

  @override
  String get reset_password => 'Сброс пароля';

  @override
  String get update_profile => 'Обновить профиль';

  @override
  String get verify_account => 'Верификация аккаунта';

  @override
  String get delete_account => 'Удалить аккаунт';

  @override
  String get buying_selling => 'Покупка и продажа';

  @override
  String get how_to_post => 'Как разместить объявление';

  @override
  String get payment_methods => 'Способы оплаты';

  @override
  String get shipping_delivery => 'Доставка';

  @override
  String get return_policy => 'Политика возврата';

  @override
  String get safety_security => 'Безопасность';

  @override
  String get report_scam => 'Сообщить о мошенничестве';

  @override
  String get safe_trading => 'Советы безопасной торговли';

  @override
  String get privacy_settings => 'Настройки конфиденциальности';

  @override
  String get blocked_users => 'Заблокированные пользователи';

  @override
  String get technical_issues => 'Технические проблемы';

  @override
  String get app_not_working => 'Приложение не работает';

  @override
  String get upload_failed => 'Ошибка загрузки';

  @override
  String get login_problems => 'Проблемы со входом';

  @override
  String get support_hours => 'Часы поддержки';

  @override
  String get mon_fri_9_6 => 'Пн-Пт: 9:00 - 18:00';

  @override
  String get how_are_we_doing => 'Как у нас дела?';

  @override
  String get rate_experience => 'Оцените качество обслуживания';

  @override
  String get poor => 'Плохо';

  @override
  String get okay => 'Нормально';

  @override
  String get good => 'Хорошо';

  @override
  String get excellent => 'Отлично';

  @override
  String get account_secure => 'Ваш аккаунт защищен';

  @override
  String get password_security => 'Пароль и аутентификация';

  @override
  String get change_password => 'Изменить пароль';

  @override
  String get two_factor_auth => 'Двухфакторная аутентификация';

  @override
  String get biometric_login => 'Биометрический вход';

  @override
  String get login_activity => 'Активность входа';

  @override
  String get active_sessions => 'Активные сеансы';

  @override
  String get login_alerts => 'Уведомления о входе';

  @override
  String get account_protection => 'Защита аккаунта';

  @override
  String get recovery_email => 'Email для восстановления';

  @override
  String get backup_codes => 'Резервные коды';

  @override
  String get danger_zone => 'Опасная зона';

  @override
  String get improve_security => 'Улучшить безопасность';

  @override
  String get security_score => 'Уровень безопасности';

  @override
  String get last_changed_days => 'Последнее изменение 30 дней назад';

  @override
  String get logout_all_devices => 'Выйти со всех устройств';

  @override
  String get end_all_sessions => 'Завершить все сеансы';

  @override
  String get permanently_delete => 'Удалить навсегда';

  @override
  String get verification_code_message =>
      'Мы отправим код подтверждения, чтобы убедиться, что это вы.';

  @override
  String get send_code => 'Отправить код';

  @override
  String get enter_verification_code => 'Введите код подтверждения';

  @override
  String get verification_code => 'Код подтверждения';

  @override
  String get new_password => 'Новый пароль';

  @override
  String get confirm_password => 'Подтвердите пароль';

  @override
  String get resend_code => 'Отправить повторно';

  @override
  String get code_sent_to => 'Введите код подтверждения, отправленный на';

  @override
  String get enter_code => 'Введите код подтверждения';

  @override
  String get code_must_be_6_digits => 'Код должен состоять из 6 цифр';

  @override
  String get enter_new_password => 'Введите новый пароль';

  @override
  String get minimum_8_characters => 'Минимум 8 символов';

  @override
  String get passwords_do_not_match => 'Пароли не совпадают';

  @override
  String get close => 'Закрыть';

  @override
  String get current => 'Текущий';

  @override
  String get session_ended => 'Сеанс завершён';

  @override
  String get update_recovery_email => 'Обновить резервную почту';

  @override
  String get new_email => 'Новая почта';

  @override
  String get update => 'Обновить';

  @override
  String get verification_email_sent => 'Письмо с подтверждением отправлено';

  @override
  String get generate_emergency_codes => 'Сгенерировать аварийные коды';

  @override
  String get copy_all => 'Скопировать всё';

  @override
  String get code_copied => 'Код скопирован';

  @override
  String get all_codes_copied => 'Все коды скопированы';

  @override
  String get logout_all_devices_confirm => 'Выйти со всех устройств?';

  @override
  String get logout_all_devices_message =>
      'Это завершит все активные сеансы на всех устройствах.';

  @override
  String get logout_all => 'Выйти со всех';

  @override
  String get delete_account_confirm => 'Удалить аккаунт?';

  @override
  String get delete_account_warning =>
      'Это действие НЕОБРАТИМО. Все ваши данные будут удалены навсегда.';

  @override
  String get what_will_be_deleted => 'Что будет удалено:';

  @override
  String get profile_and_account_info =>
      '• Ваш профиль и информация об аккаунте';

  @override
  String get all_listings_and_posts => '• Все ваши объявления и публикации';

  @override
  String get messages_and_conversations => '• Ваши сообщения и переписки';

  @override
  String get saved_items_and_preferences =>
      '• Сохранённые элементы и настройки';

  @override
  String get enter_password_to_continue => 'Введите пароль для продолжения';

  @override
  String get continue_val => 'Продолжить';

  @override
  String get please_enter_password => 'Пожалуйста, введите ваш пароль';

  @override
  String get enter_confirmation_code => 'Введите код подтверждения';

  @override
  String get deletion_confirmation_message =>
      'Мы отправили код подтверждения на ваш телефон. Введите его ниже, чтобы навсегда удалить аккаунт.';

  @override
  String get confirmation_code => 'Код подтверждения';

  @override
  String get please_enter_6_digit_code => 'Пожалуйста, введите 6-значный код';

  @override
  String get account_deleted => 'Ваш аккаунт удалён';

  @override
  String get deletion_cancelled => 'Удаление отменено';

  @override
  String get failed_to_load_user_info =>
      'Не удалось загрузить информацию пользователя';

  @override
  String get auth_login_to_view_saved =>
      'Войдите, чтобы просмотреть сохраненную недвижимость';

  @override
  String get authLoginRequired => 'Требуется вход';

  @override
  String get authLoginToViewSaved =>
      'Войдите, чтобы просмотреть сохраненную недвижимость';

  @override
  String get authLogin => 'Войти';

  @override
  String get savedPropertiesTitle => 'Сохраненная Недвижимость';

  @override
  String get loadingSavedProperties => 'Загрузка сохраненной недвижимости...';

  @override
  String get errorsFailedToLoadSaved =>
      'Не удалось загрузить сохраненную недвижимость';

  @override
  String get actionsRetry => 'Повторить';

  @override
  String get savedPropertiesNoSaved => 'Нет Сохраненной Недвижимости';

  @override
  String get savedPropertiesStartSaving =>
      'Изучайте и сохраняйте понравившуюся недвижимость';

  @override
  String get savedPropertiesBrowse => 'Просмотреть Недвижимость';

  @override
  String get resultsSavedProperties => 'сохранено объектов';

  @override
  String get actionsRefresh => 'Обновить';

  @override
  String get resultsNoMoreProperties => 'Больше нет объектов';

  @override
  String get propertyCardFeatured => 'Рекомендуемое';

  @override
  String get successPropertyUnsaved => 'Недвижимость удалена из сохраненных';

  @override
  String get alertsUnsavePropertyFailed => 'Не удалось удалить недвижимость';

  @override
  String get propertyCardBed => 'спальня';

  @override
  String get propertyCardBath => 'ванная';

  @override
  String get savedPropertiesSavedOn => 'Сохранено';

  @override
  String get propertyCardViewDetails => 'Подробнее';

  @override
  String get serviceDetailTitle => 'Детали услуги';

  @override
  String get errorLoadingFavorites => 'Ошибка загрузки избранных элементов';

  @override
  String get noFavoritesFound => 'Избранные элементы не найдены.';

  @override
  String get commentUpdatedSuccess => 'Комментарий успешно обновлен!';

  @override
  String get errorUpdatingComment => 'Ошибка обновления комментария';

  @override
  String get replyAddedSuccess => 'Ответ успешно добавлен!';

  @override
  String get errorAddingReply => 'Ошибка добавления ответа';

  @override
  String get commentDeletedSuccess => 'Комментарий успешно удален!';

  @override
  String get errorDeletingComment => 'Ошибка удаления комментария';

  @override
  String get serviceLikedSuccess => 'Услуга успешно добавлена в избранное!';

  @override
  String get errorLikingService => 'Ошибка добавления в избранное';

  @override
  String get serviceDislikedSuccess => 'Услуга успешно удалена из избранного!';

  @override
  String get errorDislikingService => 'Ошибка удаления из избранного';

  @override
  String get writeYourReply => 'Напишите ваш ответ...';

  @override
  String get postReply => 'Опубликовать ответ';

  @override
  String get anonymous => 'Аноним';

  @override
  String get editComment => 'Редактировать комментарий';

  @override
  String get editYourComment => 'Редактировать комментарий...';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get propertyOwner => 'Владелец';

  @override
  String get errorLoadingServices => 'Ошибка загрузки услуг';

  @override
  String get noRecommendedServicesFound => 'Рекомендуемые услуги не найдены.';

  @override
  String get passwordRequired => 'Пароль обязателен';

  @override
  String get passwordTooShort => 'Пароль должен содержать минимум 8 символов';

  @override
  String get passwordRequirements => 'Пароль должен содержать буквы и цифры';

  @override
  String get usernameRequired => 'Имя пользователя обязательно';

  @override
  String get usernameTooShort =>
      'Имя пользователя должно содержать минимум 3 символа';

  @override
  String get confirmPasswordRequired => 'Подтверждение пароля обязательно';

  @override
  String get passwordHelp => 'Минимум 8 символов, буквы и цифры';

  @override
  String get usernameExists => 'Это имя пользователя уже существует';

  @override
  String get phoneExists => 'Этот номер телефона уже зарегистрирован';

  @override
  String get networkError =>
      'Ошибка подключения к интернету. Пожалуйста, проверьте соединение';

  @override
  String get contactSeller => 'Связаться с продавцом';

  @override
  String get callToReveal => 'Нажмите \"Позвонить\" чтобы увидеть';

  @override
  String get camera => 'Камера';

  @override
  String get gallery => 'Галерея';

  @override
  String get selectImageSource => 'Выберите источник изображения';

  @override
  String get uploading => 'Загрузка...';

  @override
  String get acceptTermsRequired =>
      'Вы должны принять Условия использования для продолжения';

  @override
  String get iAgreeToTerms => 'Я согласен с ';

  @override
  String get termsAndConditions => 'Условиями использования';

  @override
  String get zeroToleranceStatement =>
      ' и понимаю, что существует нулевая терпимость к неприемлемому контенту или оскорбительным пользователям.';

  @override
  String get viewTerms => 'Просмотреть Условия использования';

  @override
  String get reportContent => 'Пожаловаться на контент';

  @override
  String get selectReportReason => 'Пожалуйста, выберите причину жалобы:';

  @override
  String get additionalDetails => 'Дополнительные детали (необязательно)';

  @override
  String get reportDetailsHint =>
      'Предоставьте любую дополнительную информацию...';

  @override
  String get reportSubmitted =>
      'Спасибо за вашу жалобу. Мы рассмотрим её в течение 24 часов.';

  @override
  String get reportProduct => 'Пожаловаться на товар';

  @override
  String get reportService => 'Пожаловаться на услугу';

  @override
  String get reportMessage => 'Пожаловаться на сообщение';

  @override
  String get reportUser => 'Пожаловаться на пользователя';

  @override
  String get reportErrorNotImplemented =>
      'Функция жалоб пока недоступна. Пожалуйста, свяжитесь с поддержкой или попробуйте позже.';

  @override
  String get reportAlreadySubmitted =>
      'Вы уже пожаловались на этот контент. Мы рассматриваем вашу предыдущую жалобу.';

  @override
  String get reportFailedGeneric =>
      'Не удалось отправить жалобу. Пожалуйста, попробуйте снова.';

  @override
  String get reportFailedNetwork =>
      'Произошла ошибка сети. Пожалуйста, проверьте подключение и попробуйте снова.';

  @override
  String get becomeAgentTitle => 'Стать агентом по недвижимости';

  @override
  String get becomeAgentSubtitle =>
      'Размещайте недвижимость и помогайте клиентам найти дом мечты';

  @override
  String get agentBenefits => 'Преимущества:';

  @override
  String get agentBenefitVerified => 'Значок проверенного агента';

  @override
  String get agentBenefitAnalytics => 'Доступ к аналитике и статистике';

  @override
  String get agentBenefitClients => 'Прямой контакт с потенциальными клиентами';

  @override
  String get agentBenefitReputation =>
      'Создайте свою профессиональную репутацию';

  @override
  String get agentApplicationForm => 'Форма заявки';

  @override
  String get agentAgencyName => 'Название агентства';

  @override
  String get agentAgencyNameHint =>
      'Введите название вашего агентства недвижимости';

  @override
  String get agentAgencyNameRequired => 'Название агентства обязательно';

  @override
  String get agentLicenceNumber => 'Номер лицензии';

  @override
  String get agentLicenceNumberHint => 'Введите номер лицензии на недвижимость';

  @override
  String get agentLicenceNumberRequired => 'Номер лицензии обязателен';

  @override
  String get agentYearsExperience => 'Опыт работы (лет)';

  @override
  String get agentYearsExperienceHint => 'Введите количество лет';

  @override
  String get agentYearsExperienceRequired => 'Опыт работы обязателен';

  @override
  String get agentYearsExperienceInvalid =>
      'Пожалуйста, введите действительное число';

  @override
  String get agentSpecialization => 'Специализация';

  @override
  String get agentApplicationNote =>
      'Ваша заявка будет рассмотрена нашей командой. Вы будете уведомлены после одобрения заявки.';

  @override
  String get agentSubmitApplication => 'Отправить заявку';

  @override
  String get agentApplicationSubmitted =>
      'Заявка успешно отправлена! Мы рассмотрим её в ближайшее время.';

  @override
  String get agentApplicationStatus => 'Статус заявки';

  @override
  String get agentViewProfile => 'Просмотреть профиль агента';

  @override
  String get agentDashboardComingSoon => 'Панель агента скоро появится!';

  @override
  String get property_create_basic_information => 'Основная информация';

  @override
  String get property_create_property_title => 'Название недвижимости *';

  @override
  String get property_create_property_title_hint =>
      'например, Современная 3-комнатная квартира в центре города';

  @override
  String get property_create_property_title_required =>
      'Пожалуйста, введите название недвижимости';

  @override
  String get property_create_description => 'Описание *';

  @override
  String get property_create_description_hint =>
      'Опишите вашу недвижимость подробно...';

  @override
  String get property_create_description_required =>
      'Пожалуйста, введите описание';

  @override
  String get property_create_property_type => 'Тип недвижимости';

  @override
  String get property_create_property_type_required => 'Тип недвижимости *';

  @override
  String get property_create_listing_type_required => 'Тип объявления *';

  @override
  String get property_create_pricing => 'Цена';

  @override
  String get property_create_price => 'Цена *';

  @override
  String get property_create_price_hint => 'Введите цену';

  @override
  String get property_create_price_required => 'Пожалуйста, введите цену';

  @override
  String get property_create_currency => 'Валюта';

  @override
  String get property_create_property_details => 'Детали недвижимости';

  @override
  String get property_create_square_meters => 'Кв. метры *';

  @override
  String get property_create_bedrooms => 'Спальни *';

  @override
  String get property_create_bathrooms => 'Ванные комнаты *';

  @override
  String get property_create_floor => 'Этаж';

  @override
  String get property_create_total_floors => 'Всего этажей';

  @override
  String get property_create_parking => 'Парковка';

  @override
  String get property_create_year_built => 'Год постройки';

  @override
  String get property_create_location => 'Местоположение';

  @override
  String get property_create_address => 'Адрес *';

  @override
  String get property_create_address_hint => 'Введите адрес недвижимости';

  @override
  String get property_create_address_required => 'Пожалуйста, введите адрес';

  @override
  String get property_create_location_detected => 'Местоположение определено';

  @override
  String get property_create_get_location => 'Получить текущее местоположение';

  @override
  String get property_create_features => 'Особенности';

  @override
  String get property_create_feature_balcony => 'Балкон';

  @override
  String get property_create_feature_garage => 'Гараж';

  @override
  String get property_create_feature_garden => 'Сад';

  @override
  String get property_create_feature_pool => 'Бассейн';

  @override
  String get property_create_feature_elevator => 'Лифт';

  @override
  String get property_create_feature_furnished => 'Меблировано';

  @override
  String get property_create_images => 'Фотографии недвижимости';

  @override
  String get property_create_tap_to_add_images =>
      'Нажмите, чтобы добавить фотографии';

  @override
  String get property_create_at_least_one_image =>
      'Требуется минимум 1 фотография';

  @override
  String get property_create_add_more => 'Добавить еще';

  @override
  String get property_create_required => 'Обязательно';

  @override
  String get property_create_location_required =>
      'Пожалуйста, включите службы геолокации для создания недвижимости';

  @override
  String get property_create_image_required =>
      'Требуется минимум одна фотография недвижимости';

  @override
  String get emailVerification => 'Подтверждение электронной почты';

  @override
  String get pleaseEnterYourEmailAddress =>
      'Пожалуйста, введите ваш адрес электронной почты';

  @override
  String get enterEmailAddress => 'Введите адрес электронной почты';

  @override
  String get resetYourPassword => 'Сбросить пароль';

  @override
  String get resetPasswordDescription =>
      'Введите ваш адрес электронной почты, и мы отправим вам код подтверждения для сброса пароля.';

  @override
  String get sendVerificationCode => 'Отправить код подтверждения';

  @override
  String get backToLogin => 'Вернуться к входу';

  @override
  String get resetPassword => 'Сбросить пароль';

  @override
  String enterVerificationCodeSentTo(String email) {
    return 'Введите код подтверждения, отправленный на $email';
  }

  @override
  String get codeMustBe6Digits => 'Код должен состоять из 6 цифр';

  @override
  String get enterNewPassword => 'Введите новый пароль';

  @override
  String get minimum8Characters => 'Минимум 8 символов';

  @override
  String get sending => 'Отправка...';

  @override
  String get verifying => 'Проверка...';

  @override
  String get new_message => 'Новое сообщение';

  @override
  String get messages => 'Сообщения';

  @override
  String get please_log_in =>
      'Пожалуйста, войдите, чтобы просматривать сообщения';

  @override
  String get delete_chat => 'Удалить чат';

  @override
  String delete_chat_confirm(String name) {
    return 'Вы уверены, что хотите удалить чат с $name? Это действие нельзя отменить.';
  }

  @override
  String chat_deleted(String name) {
    return 'Чат с $name удалён';
  }

  @override
  String get delete_failed => 'Не удалось удалить чат';

  @override
  String get no_conversations => 'Пока нет диалогов';

  @override
  String get start_conversation_hint => 'Начните разговор, нажав кнопку +';

  @override
  String get start_conversation => 'Начать разговор';

  @override
  String get yesterday => 'Вчера';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get no_messages_yet => 'Сообщений пока нет';

  @override
  String get unblock_user => 'Разблокировать пользователя';

  @override
  String get block_user => 'Заблокировать пользователя';

  @override
  String get no_blocked_users => 'Нет заблокированных пользователей';

  @override
  String get blocked_users_hint =>
      'Заблокированные вами пользователи появятся здесь';

  @override
  String unblock_user_confirm(String username) {
    return 'Вы уверены, что хотите разблокировать $username? Вы снова сможете получать сообщения от них.';
  }

  @override
  String user_unblocked(String username) {
    return '$username разблокирован';
  }

  @override
  String user_blocked(String username) {
    return '$username заблокирован';
  }

  @override
  String get failed_to_unblock => 'Не удалось разблокировать пользователя';

  @override
  String get failed_to_block => 'Не удалось заблокировать пользователя';

  @override
  String get chat_info => 'Информация о чате';

  @override
  String get delete_message => 'Удалить сообщение';

  @override
  String get delete_message_confirm =>
      'Вы уверены, что хотите удалить это сообщение?';

  @override
  String get typing => 'печатает...';

  @override
  String get online => 'в сети';

  @override
  String participants(int count) {
    return '$count участников';
  }

  @override
  String get you_are_blocked => 'Вы заблокированы';

  @override
  String user_blocked_you(String username) {
    return '$username заблокировал вас. Вы не можете отправлять сообщения.';
  }

  @override
  String you_blocked_user(String username) {
    return 'Вы заблокировали $username';
  }

  @override
  String get cannot_send_messages_blocked =>
      'Вы не можете отправлять сообщения. Вы были заблокированы.';

  @override
  String get this_message_was_deleted => 'Это сообщение было удалено';

  @override
  String get edit => 'Редактировать';

  @override
  String get reply => 'Ответить';

  @override
  String get add_reaction => 'Добавить реакцию';

  @override
  String get editing_message => 'Редактирование сообщения';

  @override
  String replying_to(String username) {
    return 'Ответ $username';
  }

  @override
  String get voice => 'Голос';

  @override
  String get emoji => 'Эмодзи';

  @override
  String get photo => '📷 Фото';

  @override
  String get voice_message => '🎤 Голосовое сообщение';

  @override
  String get searching => 'Поиск...';

  @override
  String get loading_users => 'Загрузка пользователей...';

  @override
  String search_failed(String error) {
    return 'Ошибка поиска: $error';
  }

  @override
  String get invalid_user_data => 'Неверные данные пользователя';

  @override
  String failed_to_start_chat(String error) {
    return 'Не удалось начать чат: $error';
  }

  @override
  String get audio_file_not_available => 'Аудиофайл недоступен';

  @override
  String failed_to_play_audio(String error) {
    return 'Не удалось воспроизвести аудио: $error';
  }

  @override
  String get image_unavailable => 'Изображение недоступно';

  @override
  String get image_too_large =>
      '❌ Изображение слишком большое. Максимальный размер 10 МБ';

  @override
  String get image_file_not_found => '❌ Файл изображения не найден';

  @override
  String get uploading_image => 'Загрузка изображения...';

  @override
  String get image_sent => '✅ Изображение отправлено!';

  @override
  String get failed_to_send_image => '❌ Не удалось отправить изображение';

  @override
  String get uploading_voice_message => 'Загрузка голосового сообщения...';

  @override
  String get voice_message_sent => '✅ Голосовое сообщение отправлено!';

  @override
  String get failed_to_send_voice_message =>
      '❌ Не удалось отправить голосовое сообщение';

  @override
  String get recording => '🎙️ Запись...';

  @override
  String get microphone_permission_denied => 'Доступ к микрофону запрещён';

  @override
  String get starting_chat => 'Запуск чата...';

  @override
  String get refresh_users => 'Обновить пользователей';

  @override
  String get search_by_username_or_phone =>
      'Поиск по имени пользователя или номеру телефона';

  @override
  String get no_users_found => 'Пользователи не найдены';

  @override
  String get try_different_search_term => 'Попробуйте другой поисковый запрос';

  @override
  String get no_users_available => 'Нет доступных пользователей';

  @override
  String get chat_exists => 'Чат существует';

  @override
  String block_user_confirm(String username) {
    return 'Вы уверены, что хотите заблокировать $username? Вы не будете получать сообщения от них, и они будут удалены из вашего списка чатов.';
  }

  @override
  String chat_room_label(String name) {
    return 'Чат: $name';
  }

  @override
  String id_label(int id) {
    return 'ID: $id';
  }

  @override
  String get participants_label => 'Участники:';

  @override
  String get type_a_message => 'Введите сообщение...';

  @override
  String get edit_message_hint => 'Редактировать сообщение...';

  @override
  String error_label(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get copy => 'Копировать';

  @override
  String comments_title(int count) {
    return 'Комментарии ($count)';
  }

  @override
  String get reply_button => 'Ответить';

  @override
  String replies_count(int count) {
    return '$count ответов';
  }

  @override
  String get you_label => 'Вы';

  @override
  String get delete_reply_title => 'Удалить ответ';

  @override
  String get delete_comment_title => 'Удалить комментарий';

  @override
  String get unknown_date => 'Неизвестная дата';

  @override
  String get press_enter_to_send => 'Нажмите Enter для отправки';

  @override
  String get comment_add_error => 'Не удалось добавить комментарий';

  @override
  String get service_provider => 'Поставщик услуг';

  @override
  String get opening_chat => 'Открытие чата...';

  @override
  String get failed_to_refresh => 'Не удалось обновить';

  @override
  String get cannot_chat_with_yourself => 'Вы не можете общаться с самим собой';

  @override
  String opening_chat_with(String username) {
    return 'Открытие чата с $username...';
  }

  @override
  String get this_will_only_take_a_moment => 'Это займет всего мгновение';

  @override
  String get unable_to_start_chat =>
      'Не удалось начать чат. Пожалуйста, попробуйте снова.';

  @override
  String get profile_listings => 'Объявления';

  @override
  String get profile_followers => 'Подписчики';

  @override
  String get profile_following => 'Подписки';

  @override
  String get profile_no_products => 'Нет товаров';

  @override
  String get profile_no_services => 'Нет услуг';

  @override
  String get profile_no_properties => 'Нет недвижимости';

  @override
  String get profile_user_no_products =>
      'Этот пользователь еще не разместил товары';

  @override
  String get profile_user_no_services =>
      'Этот пользователь еще не разместил услуги';

  @override
  String get profile_user_no_properties =>
      'Этот пользователь еще не разместил недвижимость';

  @override
  String get profile_error_occurred => 'Произошла ошибка';

  @override
  String get profile_error_loading_products => 'Ошибка загрузки товаров';

  @override
  String get profile_error_loading_services => 'Ошибка загрузки услуг';

  @override
  String get profile_no_followers_yet => 'Пока нет подписчиков';

  @override
  String get profile_no_following_yet => 'Пока нет подписок';

  @override
  String get profile_follow => 'Подписаться';

  @override
  String get profile_following_btn => 'Подписан';

  @override
  String get profile_message => 'Сообщение';

  @override
  String get profile_member_since => 'Участник с';

  @override
  String get profile_loading_error => 'Ошибка загрузки профиля';

  @override
  String get profile_retry => 'Повторить';

  @override
  String get profile_share => 'Поделиться';

  @override
  String get profile_copy_link => 'Копировать ссылку';

  @override
  String get profile_report => 'Пожаловаться';

  @override
  String get linkCopied => 'Ссылка скопирована';

  @override
  String get checkOutProfile => 'Посмотрите профиль';

  @override
  String get onTezsell => 'в TezSell';
}
