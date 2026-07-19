// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcome => 'Bienvenido';

  @override
  String get welcomeBack => '¡Bienvenido de nuevo!';

  @override
  String get loginToYourAccount => 'Inicia sesión para continuar';

  @override
  String get or => 'O';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get chooseLanguage => 'Elige tu idioma';

  @override
  String get selectPreferredLanguage =>
      'Seleccione su idioma preferido para la aplicación';

  @override
  String get continueButton => 'Continuar';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithApple => 'Continuar con Apple';

  @override
  String get continueWithEmail => 'Continuar con el correo electrónico';

  @override
  String get sellAndBuyProducts =>
      'Vende y compra cualquiera de tus productos solo con nosotros';

  @override
  String get usedProductsMarket =>
      'Productos usados ​​o mercado de segunda mano';

  @override
  String get home_welcome_title => 'El mercado de tu barrio';

  @override
  String get home_welcome_subtitle =>
      'Compra y vende con personas cercanas.\nSeguro, sencillo y local.';

  @override
  String get home_get_started => 'Empezar';

  @override
  String get home_sign_in => 'ya tengo una cuenta';

  @override
  String get home_terms_notice =>
      'Al continuar, aceptas nuestros Términos de servicio y Política de privacidad.';

  @override
  String get register => 'Registro';

  @override
  String get alreadyHaveAccount => 'Ya tienes una cuenta';

  @override
  String get login => 'Acceso';

  @override
  String get loginToAccount => 'Iniciar sesión en la cuenta';

  @override
  String get enterPhoneNumber => 'Introduce el número de teléfono';

  @override
  String get password => 'Contraseña';

  @override
  String get enterPassword => 'Introduce la contraseña';

  @override
  String get forgotPassword => '¿Has olvidado tu contraseña?';

  @override
  String get registerNow => 'Regístrese ahora';

  @override
  String get loading => 'Cargando...';

  @override
  String get pleaseEnterPhoneNumber =>
      'Por favor ingresa tu número de teléfono';

  @override
  String get pleaseEnterPassword => 'Por favor ingrese su contraseña';

  @override
  String get unexpectedError =>
      'Se produjo un error inesperado. Por favor inténtalo de nuevo.';

  @override
  String get forgotPasswordComingSoon =>
      'Función de olvidé mi contraseña próximamente';

  @override
  String get selectedCountryLabel => 'Seleccionado:';

  @override
  String get fullPhoneLabel => 'Lleno:';

  @override
  String get home => 'Hogar';

  @override
  String get settings => 'Ajustes';

  @override
  String get profile => 'Perfil';

  @override
  String get search => 'Buscar';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Rever';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Ahorrar';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Por favor seleccione su región';

  @override
  String get searchHint => 'Buscar distrito o ciudad';

  @override
  String get apiError => 'Se produjo un problema al llamar a la API.';

  @override
  String get ok => 'DE ACUERDO';

  @override
  String get emptyList => 'Lista vacía';

  @override
  String get dataLoadingError => 'Hay un error al cargar datos.';

  @override
  String get confirm => 'Confirmar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String confirmRegionSelection(Object regionName) {
    return '¿Quiere seleccionar la región $regionName?';
  }

  @override
  String get selectDistrictOrCity =>
      'Por favor seleccione su distrito o ciudad';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return '¿Quiere seleccionar la región $regionName - $districtName?';
  }

  @override
  String get noResultsFound => 'No se encontraron resultados.';

  @override
  String errorWithCode(String errorCode) {
    return 'Error: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'No se pudieron cargar los datos. Error: $error';
  }

  @override
  String get phoneVerification => 'Verificación de número de teléfono';

  @override
  String get enterPhonePrompt => 'Por favor ingresa tu número de teléfono';

  @override
  String get enterPhoneNumberHint => 'Introduce el número de teléfono';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Seleccionado: $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'Selecciona tu país';

  @override
  String get changeCountry => 'Cambiar pais';

  @override
  String get country => 'País';

  @override
  String get allCountries => 'Todos los paises';

  @override
  String get currencyRUB => 'rublo ruso';

  @override
  String get currencyUAH => 'grivna ucraniana';

  @override
  String get currencyBYN => 'Rublo bielorruso';

  @override
  String get currencyMDL => 'Leu moldavo';

  @override
  String get currencyGEL => 'Lari georgiano';

  @override
  String get currencyAMD => 'Dram armenio';

  @override
  String get currencyAZN => 'Manat azerbaiyano';

  @override
  String get currencyKZT => 'Tenge kazajo';

  @override
  String get currencyTMT => 'Manat turcomano';

  @override
  String get currencyKGS => 'som kirguís';

  @override
  String get currencyTJS => 'Somoni tayiko';

  @override
  String get currencyUZS => 'som uzbeko';

  @override
  String get currencyUSD => 'dólar estadounidense';

  @override
  String get currencyEUR => 'Euro';

  @override
  String fullNumber(String phoneNumber) {
    return 'Número completo: $phoneNumber';
  }

  @override
  String get sendCode => 'Enviar código';

  @override
  String get enterVerificationCode => 'Ingrese el código de verificación';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String expires(String time) {
    return 'Vence: $time';
  }

  @override
  String get verifyAndContinue => 'Verificar y continuar';

  @override
  String get invalidVerificationCode => 'Código de verificación no válido';

  @override
  String get verificationCodeSent =>
      'Código de verificación enviado exitosamente';

  @override
  String get failedToSendCode => 'No se pudo enviar el código de verificación';

  @override
  String get verificationCodeResent =>
      'El código de verificación se reenvía correctamente';

  @override
  String get failedToResendCode =>
      'No se pudo reenviar el código de verificación';

  @override
  String get passwordVerification => 'Verificación de contraseña';

  @override
  String get completeRegistrationPrompt =>
      'Ingrese nombre de usuario y contraseña para completar el registro';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get username_required => 'El nombre de usuario es obligatorio';

  @override
  String get username_min_length =>
      'El nombre de usuario debe tener al menos 2 caracteres.';

  @override
  String get usernameHint => 'Nombre de usuario123';

  @override
  String get confirmPassword => 'confirmar Contraseña';

  @override
  String get profileImage => 'Imagen de perfil';

  @override
  String get imageInstructions =>
      'Las imágenes aparecerán aquí, por favor presione imagen de perfil.';

  @override
  String get finish => 'Finalizar';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get registrationError => 'Error de registro';

  @override
  String get about => 'Sobre nosotros';

  @override
  String get chat => 'Charlar';

  @override
  String get realEstate => 'Bienes raíces';

  @override
  String get language => 'ESP';

  @override
  String get languageEn => 'Inglés';

  @override
  String get languageRu => 'ruso';

  @override
  String get languageUz => 'uzbeko';

  @override
  String get serviceLiked => 'Me gustó el servicio';

  @override
  String get support => 'Apoyo';

  @override
  String get service => 'Servicios Empresariales';

  @override
  String get aboutContent =>
      'TezSell es un mercado rápido y sencillo para comprar y vender productos nuevos y usados. Nuestra misión es crear la plataforma más conveniente y eficiente para cada usuario, garantizando transacciones fluidas y una experiencia fácil de usar. Ya sea que esté buscando vender o comprar, TezSell facilita la conexión y completar transacciones en solo unos pocos pasos. Priorizamos la seguridad y privacidad de nuestros usuarios. Todas las transacciones se monitorean cuidadosamente para garantizar la seguridad y el cumplimiento, brindando tranquilidad tanto a compradores como a vendedores. Nuestra interfaz sencilla e intuitiva permite a los usuarios enumerar rápidamente productos y encontrar lo que necesitan. También facilitamos la comunicación en tiempo real a través de Telegram, haciendo aún más fluido el proceso de compra y venta.';

  @override
  String get errorMessage => 'Se produjo un error, verifique el servidor.';

  @override
  String get searchLocation => 'Ubicación';

  @override
  String get searchCategory => 'Categorías';

  @override
  String get searchProductPlaceholder => 'Buscar productos';

  @override
  String get searchServicePlaceholder => 'Buscar servicios';

  @override
  String get search_products_subtitle =>
      'Encuentra grandes ofertas en tu vecindario';

  @override
  String get search_services_subtitle => 'Encuentra profesionales en tu barrio';

  @override
  String get search_products_error => 'Error al buscar productos';

  @override
  String get search_services_error => 'Error al buscar servicios';

  @override
  String get load_more_products_error => 'Error al cargar más productos';

  @override
  String get load_more_services_error => 'Error al cargar más servicios';

  @override
  String get try_different_keywords => 'Pruebe diferentes palabras clave';

  @override
  String get searchText => 'Buscar';

  @override
  String get selectedCategory => 'Categoría seleccionada:';

  @override
  String get selectedLocation => 'Ubicación seleccionada:';

  @override
  String get productError => 'No hay productos disponibles';

  @override
  String get serviceError => 'No hay servicios disponibles';

  @override
  String get locationHeader => 'Seleccione una ubicación';

  @override
  String get locationPlaceholder => 'Buscar región aquí';

  @override
  String get categoryHeader => 'Seleccione una categoría';

  @override
  String get categoryPlaceholder => 'Categorías de búsqueda';

  @override
  String get categoryError => 'No hay categorías disponibles';

  @override
  String get paginationFirst => 'Primero';

  @override
  String get paginationPrevious => 'Anterior';

  @override
  String get pageInfo => 'Página de';

  @override
  String get pageNext => 'Próximo';

  @override
  String get pageLast => 'Último';

  @override
  String get loadingMessageProduct => 'Cargando productos...';

  @override
  String get loadingMessageError => 'Error al cargar';

  @override
  String get likeProductError =>
      'Se produjo un error al dar me gusta al producto.';

  @override
  String get dislikeProductError =>
      'Se produjo un error al no gustarle el producto';

  @override
  String get loadingMessageLocation => 'Ubicación de carga...';

  @override
  String get loadingLocationError => 'Error al cargar la ubicación';

  @override
  String get loadingMessageCategory => 'Cargando categorías...';

  @override
  String get loadingCategoryError => 'Error al cargar categorías:';

  @override
  String get profileUpdateSuccessMessage => 'Perfil actualizado exitosamente';

  @override
  String get profileUpdateFailMessage => 'No se pudo actualizar el perfil';

  @override
  String get seeMoreBtn => 'Ver más';

  @override
  String get profilePageTitle => 'Página de perfil';

  @override
  String get editProfileModalTitle => 'Editar perfil';

  @override
  String get usernameLabel => 'Nombre de usuario';

  @override
  String get locationLabel => 'Ubicación actual';

  @override
  String get profileImageLabel => 'Imagen de perfil';

  @override
  String get chooseFileLabel => 'Elige un archivo';

  @override
  String get uploadBtnLabel => 'Actualizar';

  @override
  String get uploadingBtnLabel => 'Actualizando...';

  @override
  String get cancelBtnLabel => 'Cancelar';

  @override
  String get productsTitle => 'Productos';

  @override
  String get servicesTitle => 'Servicios';

  @override
  String get myProductsTitle => 'Mis productos';

  @override
  String get myServicesTitle => 'Mis servicios';

  @override
  String get favoriteProductsTitle => 'Productos favoritos';

  @override
  String get favoriteServicesTitle => 'Servicios favoritos';

  @override
  String get noFavorites => 'Sin favoritos';

  @override
  String get addNewProductBtn => 'Agregar nuevo producto';

  @override
  String get addNew => 'Nuevo';

  @override
  String get addNewServiceBtn => 'Agregar nuevo servicio';

  @override
  String get downloadMobileApp => 'Descarga la aplicación móvil';

  @override
  String get registerPhoneNumberSuccess =>
      '¡Número de teléfono verificado! Puede continuar con el siguiente paso.';

  @override
  String get regionSelectedMessage => 'Región seleccionada:';

  @override
  String get districtSelectMessage => 'Distrito seleccionado:';

  @override
  String get phoneNumberEmptyMessage =>
      'Por favor verifique su número de teléfono antes de continuar';

  @override
  String get regionEmptyMessage => 'Por favor seleccione la región primero';

  @override
  String get districtEmptyMessage => 'Por favor seleccione el distrito';

  @override
  String get usernamePasswordEmptyMessage =>
      'Por favor ingrese nombre de usuario y contraseña';

  @override
  String get registerTitle => 'Registro';

  @override
  String get previousButton => 'Anterior';

  @override
  String get nextButton => 'Próximo';

  @override
  String get completeButton => 'Completo';

  @override
  String stepIndicator(int currentStep) {
    return 'Paso $currentStep de 4';
  }

  @override
  String get districtSelectTitle => 'Lista de distritos';

  @override
  String get districtSelectParagraph => 'Seleccione un distrito:';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get sendOtp => 'Enviar OTP';

  @override
  String get sendAgain => 'Enviar de nuevo';

  @override
  String get verify => 'Verificar';

  @override
  String get failedToSendOtp =>
      'No se pudo enviar OTP. El servidor devolvió falso.';

  @override
  String get errorSendingOtp => 'Se produjo un error al enviar OTP.';

  @override
  String get invalidPhoneNumber =>
      'Por favor ingrese un número de teléfono válido.';

  @override
  String get verificationSuccess => 'Verificado con éxito';

  @override
  String get verificationError =>
      'Se produjo un error. Inténtelo de nuevo más tarde.';

  @override
  String get regionsList => 'Lista de regiones';

  @override
  String get enterUsername => 'Ingrese su nombre de usuario';

  @override
  String get welcomeMessage =>
      'Bienvenido a Tezsell, inicia sesión con tu número de teléfono';

  @override
  String get noAccount => '¿Aún no tienes cuenta? Regístrate aquí';

  @override
  String get successLogin => 'Iniciado sesión exitosamente';

  @override
  String get myProfile => 'Mi perfil';

  @override
  String get logout => 'cerrar sesión';

  @override
  String get newProductTitle => 'Título';

  @override
  String get newProductDescription => 'Descripción';

  @override
  String get newProductPrice => 'Precio';

  @override
  String get newProductCondition => 'Condición';

  @override
  String get newProductCategory => 'Categoría';

  @override
  String get newProductImages => 'Imágenes';

  @override
  String get addNewService => 'Agregar nuevo servicio';

  @override
  String get creating => 'Creando...';

  @override
  String get serviceName => 'Nombre del servicio';

  @override
  String get serviceNamePlaceholder => 'Introduzca el título del servicio';

  @override
  String get serviceDescription => 'Descripción del servicio';

  @override
  String get serviceDescriptionPlaceholder =>
      'Ingrese la descripción del servicio';

  @override
  String get serviceCategory => 'Categoría de servicio';

  @override
  String get selectCategory => 'Seleccionar categoría';

  @override
  String get loadingCategories => 'Cargando...';

  @override
  String get errorLoadingCategories => 'Error al cargar categorías';

  @override
  String get serviceImages => 'Imágenes de servicio';

  @override
  String get imageUploadHelper =>
      'Haga clic en el ícono + para agregar imágenes (máximo 10)';

  @override
  String get maxImagesError => 'Puedes subir un máximo de 10 imágenes.';

  @override
  String get categoryNotFound => 'Categoría no encontrada';

  @override
  String get productCreatedSuccess => 'Producto creado exitosamente';

  @override
  String get productLikeSuccess => 'Producto gustado exitosamente';

  @override
  String get productDislikeSuccess => 'Producto no me gustó con éxito';

  @override
  String get errorCreatingService => 'Error al crear el servicio';

  @override
  String get errorCreatingProduct => 'Error al crear el producto';

  @override
  String get unknownError =>
      'Se produjo un error desconocido al crear el servicio.';

  @override
  String get submit => 'Entregar';

  @override
  String get selectCategoryAction => 'Seleccionar categoría';

  @override
  String get selectCondition => 'Seleccionar condición';

  @override
  String get sum => 'Suma';

  @override
  String get noComments =>
      'Aún no hay comentarios. ¡Sé el primero en comentar!';

  @override
  String get commentLikeSuccess => 'Comentario me gustó con éxito';

  @override
  String get commentLikeError => 'Error al darle me gusta al comentario';

  @override
  String get unknownErrorMessage => 'Se produjo un error desconocido';

  @override
  String get commentDislikeSuccess => 'Comentario no me gusta correctamente';

  @override
  String get commentDislikeError => 'Error al dar me gusta al comentario';

  @override
  String get replyInfo => 'Por favor ingresa una respuesta primero';

  @override
  String get replySuccessMessage => 'Respuesta agregada exitosamente';

  @override
  String get replyErrorMessage =>
      'Se produjo un error durante la creación de la respuesta.';

  @override
  String get commentUpdateSuccess => 'Comentario actualizado exitosamente';

  @override
  String get commentUpdateError =>
      'Error al actualizar el elemento de comentario';

  @override
  String get deleteConfirmationMessage =>
      '¿Estás seguro de que quieres eliminar este comentario?';

  @override
  String get commentDeleteSuccess => 'Comentario eliminado con éxito';

  @override
  String get commentDeleteError => 'Error al eliminar comentario';

  @override
  String get editLabel => 'Editar';

  @override
  String get deleteLabel => 'Borrar';

  @override
  String get saveLabel => 'Ahorrar';

  @override
  String get replyLabel => 'Responder';

  @override
  String get replyTitle => 'respuestas';

  @override
  String get replyPlaceholder => 'Escribe una respuesta...';

  @override
  String get chatLoginMessage => 'Debes iniciar sesión para iniciar un chat.';

  @override
  String get chatYourselfMessage => 'No puedes chatear contigo mismo.';

  @override
  String get chatRoomMessage => '¡Sala de chat creada!';

  @override
  String get chatRoomError => '¡No se pudo crear el chat!';

  @override
  String get chatCreationError => '¡Error al crear el chat!';

  @override
  String get productsTotal => 'Total de productos';

  @override
  String get perPage => 'elementos';

  @override
  String get clearAllFilters => 'Limpiar todos los filtros';

  @override
  String get clickToUpload => 'Haga clic para cargar';

  @override
  String get productInStock => 'En stock';

  @override
  String get productOutStock => 'Agotado';

  @override
  String get productBack => 'Volver a productos';

  @override
  String get messageSeller => 'Charlar';

  @override
  String get recommendedProducts => 'Productos recomendados';

  @override
  String get deleteConfirmationProduct =>
      '¿Estás seguro de que deseas eliminar este producto?';

  @override
  String get productDeleteSuccess => 'Producto eliminado exitosamente';

  @override
  String get productDeleteError => 'Error al eliminar el producto';

  @override
  String get newCondition => 'Nuevo';

  @override
  String get used => 'Usado';

  @override
  String get imageValidType =>
      'Algunos archivos no se agregaron. Utilice archivos JPG, PNG, GIF o WebP de menos de 5 MB.';

  @override
  String get imageConfirmMessage =>
      '¿Estás seguro de que deseas eliminar esta imagen?';

  @override
  String get titleRequiredMessage => 'Se requiere título';

  @override
  String get descRequiredMessage => 'Se requiere descripción';

  @override
  String get priceRequiredMessage => 'Se requiere precio';

  @override
  String get conditionRequiredMessage => 'Se requiere condición';

  @override
  String get pleaseFillAllRequired =>
      'Por favor complete los campos requeridos';

  @override
  String get oneImageConfirmMessage =>
      'Se requiere al menos una imagen de producto.';

  @override
  String get categoryRequiredMessage => 'Se requiere categoría';

  @override
  String get locationInfoError => 'Falta información de ubicación del usuario';

  @override
  String get editProductTitle => 'Editar producto';

  @override
  String get imageUploadRequirements =>
      'Se requiere al menos una imagen. Puede cargar hasta 10 imágenes (JPG, PNG, GIF, WebP de menos de 5 MB cada una).';

  @override
  String get productUpdatedSuccess => 'Producto actualizado exitosamente';

  @override
  String get productUpdateFailed => 'Error en la actualización del producto';

  @override
  String get errorUpdatingProduct =>
      'Se produjo un error al actualizar el producto.';

  @override
  String get serviceBack => 'Volver a servicios';

  @override
  String get likeLabel => 'Como';

  @override
  String get commentsLabel => 'Comentarios';

  @override
  String get writeComment => 'Escribe un comentario...';

  @override
  String get postingLabel => 'Destino...';

  @override
  String get commentCreated => 'Comentario creado';

  @override
  String get postCommentLabel => 'Publicar comentario';

  @override
  String get loginPrompt => 'Inicie sesión para ver y publicar comentarios.';

  @override
  String get recommendedServices => 'Servicios recomendados';

  @override
  String get commentsVisibilityNotice =>
      'Los comentarios sólo son visibles para los usuarios que han iniciado sesión.';

  @override
  String get comingSoon => 'Muy pronto';

  @override
  String get serviceUpdateSuccess => 'Servicio actualizado exitosamente';

  @override
  String get serviceUpdateError =>
      'Error al actualizar el elemento de servicio';

  @override
  String get editServiceModalTitle => 'Editar servicio';

  @override
  String get enterPhoneNumberWithoutCode =>
      'Ingrese el número de teléfono sin código';

  @override
  String get heroTitle => 'TezVender';

  @override
  String get heroSubtitle => 'Su mercado rápido y fácil para Uzbekistán';

  @override
  String get startSelling => 'Empezar a vender';

  @override
  String get browseProducts => 'Explorar productos';

  @override
  String get featuresTitle => '¿Por qué elegir TezSell?';

  @override
  String get listingTitle => 'Listado de productos sencillo';

  @override
  String get listingDescription =>
      'Enumere sus artículos con solo unos pocos clics. Agregue fotos, establezca su precio y conéctese con compradores al instante.';

  @override
  String get locationTitle => 'Navegación basada en la ubicación';

  @override
  String get locationDescription =>
      'Encuentra ofertas cerca de ti. Nuestro sistema basado en la ubicación le ayuda a descubrir artículos en su vecindario.';

  @override
  String get location_subtitle =>
      'Elija su región y distrito para ver listados cercanos';

  @override
  String get categoryTitle => 'Filtrado de categorías';

  @override
  String get categoryDescription =>
      'Navega fácilmente por diferentes categorías para encontrar exactamente lo que estás buscando.';

  @override
  String get inspirationTitle =>
      'Inspirado en el mercado de zanahorias de Corea';

  @override
  String get inspirationDescription1 =>
      'Creamos TezSell inspirándonos en el exitoso Carrot Market (당근마켓) de Corea, pero lo adaptamos específicamente para satisfacer las necesidades únicas de las comunidades locales de Uzbekistán.';

  @override
  String get inspirationDescription2 =>
      'Nuestra misión es crear una plataforma confiable donde los vecinos puedan comprar, vender y conectarse entre sí fácilmente.';

  @override
  String get comingSoonTitle => 'Próximamente en TezSell';

  @override
  String get inAppChat => 'Chat en la aplicación';

  @override
  String get secureTransactions => 'Transacciones seguras';

  @override
  String get realEstateListings => 'Listados de bienes raíces';

  @override
  String get stayUpdated => 'Manténgase actualizado';

  @override
  String get comingSoonBadge => 'Muy pronto';

  @override
  String get ctaTitle => '¡Únase a la comunidad TezSell hoy!';

  @override
  String get ctaDescription =>
      'Sea parte de la construcción de una mejor experiencia de mercado para Uzbekistán. ¡Comparte tus comentarios y ayúdanos a crecer!';

  @override
  String get createAccount => 'Crear una cuenta';

  @override
  String get learnMore => 'Más información';

  @override
  String get replyUpdateSuccess => 'Respuesta actualizada con éxito';

  @override
  String get replyUpdateError => 'No se pudo actualizar la respuesta';

  @override
  String get replyDeleteSuccess => 'Respuesta eliminada exitosamente';

  @override
  String get replyDeleteError => 'No se pudo eliminar la respuesta';

  @override
  String get replyDeleteConfirmation =>
      '¿Estás seguro de que quieres eliminar esta respuesta?';

  @override
  String get authenticationRequired => 'Se requiere autenticación';

  @override
  String get enterValidReply =>
      'Por favor ingresa un texto de respuesta válido';

  @override
  String get saving => 'Ahorro...';

  @override
  String get deleting => 'Eliminando...';

  @override
  String get properties => 'Propiedades';

  @override
  String get agents => 'Agentes';

  @override
  String get becomeAgent => 'Conviértete en un agente';

  @override
  String get main => 'Principal';

  @override
  String get upload => 'Subir';

  @override
  String get filtered_products => 'Productos filtrados';

  @override
  String get filtered_services => 'Servicios filtrados';

  @override
  String get productDetail => 'Detalle del producto';

  @override
  String get unknownUser => 'Usuario desconocido';

  @override
  String get locationNotAvailable => 'Ubicación no disponible';

  @override
  String get noTitle => 'Sin título';

  @override
  String get noCategory => 'Sin categoría';

  @override
  String get noDescription => 'Sin descripción';

  @override
  String get som => 'algo';

  @override
  String get about_me => 'Acerca de mí';

  @override
  String get my_name => 'mi nombre';

  @override
  String get customer_support => 'Atención al cliente';

  @override
  String get customer_center => 'Centro de atención al cliente';

  @override
  String get customer_inquiries => 'Consultas';

  @override
  String get customer_terms => 'Términos y condiciones';

  @override
  String get region => 'Región';

  @override
  String get district => 'Distrito';

  @override
  String get tap_change_profile => 'Toca para cambiar la foto';

  @override
  String get language_settings => 'Configuración de idioma';

  @override
  String get selectLanguage => 'Seleccione un idioma';

  @override
  String get select_theme => 'Seleccionar tema';

  @override
  String get theme => 'Tema';

  @override
  String get location_settings => 'Configuración de ubicación';

  @override
  String get security => 'Seguridad';

  @override
  String get data_storage => 'Datos y almacenamiento';

  @override
  String get accessibility => 'Accesibilidad';

  @override
  String get privacy => 'Privacidad';

  @override
  String get light_theme => 'Luz';

  @override
  String get dark_theme => 'Oscuro';

  @override
  String get system_theme => 'Valor predeterminado del sistema';

  @override
  String get my_products => 'Mis productos';

  @override
  String get refresh => 'Refrescar';

  @override
  String get delete_product => 'Eliminar producto';

  @override
  String get delete_confirmation =>
      '¿Estás seguro de que deseas eliminar este producto?';

  @override
  String get delete => 'Borrar';

  @override
  String error_loading_products(String error) {
    return 'Error al cargar productos: $error';
  }

  @override
  String get product_deleted_success => 'Producto eliminado exitosamente';

  @override
  String error_deleting_product(String error) {
    return 'Error al eliminar producto: $error';
  }

  @override
  String get no_products_found => 'No se encontraron productos';

  @override
  String get add_first_product => 'Comience agregando su primer producto';

  @override
  String get no_title => 'Sin título';

  @override
  String get no_description => 'Sin descripción';

  @override
  String get in_stock => 'En stock';

  @override
  String get out_of_stock => 'Agotado';

  @override
  String get new_condition => 'NUEVO';

  @override
  String get edit_product => 'Editar producto';

  @override
  String get delete_product_tooltip => 'Eliminar producto';

  @override
  String get sum_currency => 'Suma';

  @override
  String get edit_product_title => 'Editar producto';

  @override
  String get product_name => 'Nombre del producto';

  @override
  String get product_description => 'Descripción del Producto';

  @override
  String get price => 'Precio';

  @override
  String get condition => 'Condición';

  @override
  String get condition_new => 'Nuevo';

  @override
  String get condition_used => 'Usado';

  @override
  String get condition_refurbished => 'Renovar';

  @override
  String get currency => 'Divisa';

  @override
  String get category => 'Categoría';

  @override
  String get images => 'Imágenes';

  @override
  String get existing_images => 'Imágenes existentes';

  @override
  String get new_images => 'Nuevas imágenes';

  @override
  String get image_instructions =>
      'Las imágenes aparecerán aquí. Por favor presione el ícono de carga arriba.';

  @override
  String get update_button => 'Actualizar';

  @override
  String loading_category_error(String error) {
    return 'Error al cargar categorías: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Error al seleccionar imágenes: $error';
  }

  @override
  String get please_fill_all_required => 'Por favor llena todos los campos';

  @override
  String get invalid_price_message =>
      'Precio no válido ingresado. Por favor ingrese un número válido.';

  @override
  String get category_required_message =>
      'Por favor seleccione una categoría válida.';

  @override
  String get one_image_required_message =>
      'Se requiere al menos una imagen de producto.';

  @override
  String get product_updated_success => 'Producto actualizado exitosamente';

  @override
  String error_updating_product(String error) {
    return 'Error al actualizar el producto: $error';
  }

  @override
  String get my_services => 'Mis servicios';

  @override
  String get delete_service => 'Eliminar servicio';

  @override
  String get delete_service_confirmation =>
      '¿Estás seguro de que deseas eliminar este servicio?';

  @override
  String get no_services_found => 'No se encontraron servicios';

  @override
  String get add_first_service => 'Comience agregando su primer servicio';

  @override
  String get edit_service => 'Editar servicio';

  @override
  String get delete_service_tooltip => 'Eliminar servicio';

  @override
  String get service_deleted_successfully => 'Servicio eliminado exitosamente';

  @override
  String get error_deleting_service => 'Error al eliminar el servicio';

  @override
  String get error_loading_services => 'Error al cargar servicios';

  @override
  String get service_name => 'Nombre del servicio';

  @override
  String get enter_service_name => 'Introduzca el nombre del servicio';

  @override
  String get service_name_required => 'El nombre del servicio es obligatorio.';

  @override
  String get service_name_min_length =>
      'El nombre del servicio debe tener al menos 3 caracteres.';

  @override
  String get enter_service_description => 'Ingrese la descripción del servicio';

  @override
  String get service_description_required =>
      'Se requiere descripción del servicio';

  @override
  String get service_description_min_length =>
      'La descripción debe tener al menos 10 caracteres.';

  @override
  String get category_required => 'Por favor seleccione una categoría';

  @override
  String get no_categories_available => 'No hay categorías disponibles';

  @override
  String get location => 'Ubicación';

  @override
  String get select_location => 'Seleccionar ubicación';

  @override
  String get location_required => 'Por favor seleccione una ubicación';

  @override
  String get no_locations_available => 'No hay ubicaciones disponibles';

  @override
  String get add_images => 'Agregar imágenes';

  @override
  String get current_images => 'Imágenes actuales';

  @override
  String get no_images_selected => 'No hay imágenes seleccionadas';

  @override
  String get save_changes => 'Guardar cambios';

  @override
  String get map_main => 'Mapa y Propiedades';

  @override
  String get agent_status => 'Estado del agente';

  @override
  String get admin_panel => 'Panel de administración';

  @override
  String get propertiesFound => 'Propiedades encontradas';

  @override
  String get propertiesSaved => 'propiedades guardadas';

  @override
  String get saved => 'salvado';

  @override
  String get loadingProperties => 'Cargando propiedades...';

  @override
  String get failedToLoad =>
      'No se pudieron cargar las propiedades. Por favor inténtalo de nuevo.';

  @override
  String get noPropertiesFound => 'No se encontraron propiedades';

  @override
  String get tryAdjusting => 'Intente ajustar sus criterios de búsqueda';

  @override
  String get search_placeholder => 'Buscar por título o ubicación...';

  @override
  String get search_filters => 'Filtros';

  @override
  String get search_button => 'Buscar';

  @override
  String get search_clear_filters => 'Borrar filtros';

  @override
  String get filter_options_sale_and_rent => 'Venta y Alquiler';

  @override
  String get filter_options_for_sale => 'En venta';

  @override
  String get filter_options_for_rent => 'En alquiler';

  @override
  String get filter_options_all_types => 'Todos los tipos';

  @override
  String get filter_options_apartment => 'Departamento';

  @override
  String get filter_options_house => 'Casa';

  @override
  String get filter_options_townhouse => 'Casa adosada';

  @override
  String get filter_options_villa => 'Villa';

  @override
  String get filter_options_commercial => 'Comercial';

  @override
  String get filter_options_office => 'Oficina';

  @override
  String get property_card_featured => 'Presentado';

  @override
  String get property_card_bed => 'dormitorio';

  @override
  String get property_card_bath => 'baño';

  @override
  String get property_card_parking => 'aparcamiento';

  @override
  String get property_card_view_details => 'Ver detalles';

  @override
  String get property_card_contact => 'Contacto';

  @override
  String get property_card_balcony => 'Balcón';

  @override
  String get property_card_garage => 'Cochera';

  @override
  String get property_card_garden => 'Jardín';

  @override
  String get property_card_pool => 'Piscina';

  @override
  String get property_card_elevator => 'Ascensor';

  @override
  String get property_card_furnished => 'Amueblado';

  @override
  String get property_card_sales => 'ventas';

  @override
  String get pricing_month => '/mes';

  @override
  String get results_properties_found => 'Propiedades encontradas';

  @override
  String get results_properties_saved => 'propiedades guardadas';

  @override
  String get results_saved => 'salvado';

  @override
  String get results_loading_properties => 'Cargando propiedades...';

  @override
  String get results_failed_to_load =>
      'No se pudieron cargar las propiedades. Por favor inténtalo de nuevo.';

  @override
  String get results_no_properties_found => 'No se encontraron propiedades';

  @override
  String get results_try_adjusting =>
      'Intente ajustar sus criterios de búsqueda';

  @override
  String get no_properties_found => 'No se encontraron propiedades';

  @override
  String get no_category_properties => 'No hay propiedades en esta categoría.';

  @override
  String get properties_loading => 'Cargando propiedades...';

  @override
  String get all_properties_loaded => 'Todas las propiedades cargadas';

  @override
  String n_properties(int count) {
    return '$count propiedades';
  }

  @override
  String get in_area => 'en el área';

  @override
  String get pagination_previous => 'Anterior';

  @override
  String get pagination_next => 'Próximo';

  @override
  String get pagination_page => 'Página';

  @override
  String get pagination_page_of => 'Página 1 de';

  @override
  String get contact_modal_title => 'Información del contacto';

  @override
  String get contact_modal_agent_contact => 'Contacto del agente';

  @override
  String get contact_modal_property_owner => 'Dueño de la propiedad';

  @override
  String get contact_modal_agent_phone_number =>
      'Número de teléfono del agente';

  @override
  String get contact_modal_owner_phone_number =>
      'Número de teléfono del propietario';

  @override
  String get contact_modal_license => 'Licencia';

  @override
  String get contact_modal_rating => 'Clasificación';

  @override
  String get contact_modal_call_now => 'Llama ahora';

  @override
  String get contact_modal_copy_number => 'Número de copia';

  @override
  String get contact_modal_close => 'Cerca';

  @override
  String get contact_modal_contact_hours =>
      'Horario de contacto: 9:00 a. m. - 8:00 p. m.';

  @override
  String get contact_modal_agent => 'Agente';

  @override
  String get errors_toggle_save_failed =>
      'No se pudo alternar guardar propiedad:';

  @override
  String get errors_copy_failed => 'No se pudo copiar el número de teléfono:';

  @override
  String get errors_phone_copied =>
      'Número de teléfono copiado al portapapeles';

  @override
  String get errors_error_occurred_regions =>
      'Se produjo un error con las regiones.';

  @override
  String get errors_error_occurred_districts =>
      'Se produjo un error con los distritos.';

  @override
  String get errors_please_fill_all_required_fields =>
      'Por favor complete todos los campos requeridos';

  @override
  String get errors_authentication_required => 'Se requiere autenticación';

  @override
  String get errors_user_info_missing => 'Falta información del usuario';

  @override
  String get errors_validation_error =>
      'Por favor verifique sus datos de entrada';

  @override
  String get errors_permission_denied => 'Permiso denegado';

  @override
  String get errors_server_error => 'Ocurrió un error en el servidor';

  @override
  String get errors_network_error => 'Error de conexión de red';

  @override
  String get errors_timeout_error =>
      'Se superó el tiempo de espera de la solicitud';

  @override
  String get errors_custom_error => 'Se produjo un error';

  @override
  String get errors_error_creating_property => 'Error al crear la propiedad';

  @override
  String get errors_unknown_error_message => 'Se produjo un error desconocido';

  @override
  String get errors_coordinates_not_found =>
      'No se pudieron encontrar coordenadas para esta dirección. Introdúzcalos manualmente.';

  @override
  String get errors_coordinates_error =>
      'Error al obtener las coordenadas. Introdúzcalos manualmente.';

  @override
  String get property_info_views => 'vistas';

  @override
  String get property_info_listed => 'Listado';

  @override
  String get property_info_price_per_sqm => '/m²';

  @override
  String get property_info_saved => 'Guardado';

  @override
  String get property_info_save => 'Ahorrar';

  @override
  String get property_info_share => 'Compartir';

  @override
  String get loading_loading => 'Cargando...';

  @override
  String get loading_loading_details => 'Cargando detalles de la propiedad...';

  @override
  String get loading_property_not_found => 'Propiedad no encontrada';

  @override
  String get loading_property_not_found_message =>
      'La propiedad que buscas no existe o ha sido eliminada.';

  @override
  String get loading_back_to_properties => 'Volver a Propiedades';

  @override
  String get loading_title => 'Cargando agentes...';

  @override
  String get loading_message => 'Espere mientras cargamos la lista de agentes.';

  @override
  String get loading_agent_not_found => 'Agente no encontrado';

  @override
  String get property_details_title => 'Detalles de la propiedad';

  @override
  String get property_details_bedrooms => 'Dormitorios';

  @override
  String get property_details_bathrooms => 'Baños';

  @override
  String get property_details_floor_area => 'Área del piso';

  @override
  String get property_details_parking => 'Aparcamiento';

  @override
  String get property_details_basic_information => 'Información básica';

  @override
  String get property_details_property_type => 'Tipo de propiedad:';

  @override
  String get property_details_listing_type => 'Tipo de listado:';

  @override
  String get property_details_for_sale => 'En venta';

  @override
  String get property_details_for_rent => 'En alquiler';

  @override
  String get property_details_year_built => 'Año de construcción:';

  @override
  String get property_details_floor => 'Piso:';

  @override
  String get property_details_of => 'de';

  @override
  String get property_details_features_amenities =>
      'Características y comodidades';

  @override
  String get sections_description => 'Descripción';

  @override
  String get sections_nearby_amenities => 'Servicios cercanos';

  @override
  String get sections_similar_properties => 'Propiedades similares';

  @override
  String get amenities_metro => 'Metro';

  @override
  String get amenities_school => 'Escuela';

  @override
  String get amenities_hospital => 'Hospital';

  @override
  String get amenities_shopping => 'Compras';

  @override
  String get amenities_away => 'lejos';

  @override
  String get contact_title => 'Información del contacto';

  @override
  String get contact_professional_listing => 'Listado profesional';

  @override
  String get contact_listed_by_agent => 'Listado por agente verificado';

  @override
  String get contact_by_owner => 'Por propietario';

  @override
  String get contact_direct_contact =>
      'Contacto directo con el dueño de la propiedad.';

  @override
  String get contact_property_owner => 'Dueño de la propiedad';

  @override
  String get contact_call_agent => 'Llamar al agente';

  @override
  String get contact_email_agent => 'Agente de correo electrónico';

  @override
  String get contact_call_owner => 'Llamar al propietario';

  @override
  String get contact_email_owner => 'Propietario del correo electrónico';

  @override
  String get contact_send_inquiry => 'Enviar consulta';

  @override
  String get property_status_title => 'Estado de la propiedad';

  @override
  String get property_status_availability => 'Disponibilidad:';

  @override
  String get property_status_available => 'Disponible';

  @override
  String get property_status_not_available => 'No disponible';

  @override
  String get property_status_featured => 'Presentado:';

  @override
  String get property_status_featured_property => 'Propiedad destacada';

  @override
  String get property_status_property_id => 'Identificación de propiedad:';

  @override
  String get inquiry_title => 'Enviar consulta';

  @override
  String get inquiry_inquiry_type => 'Tipo de consulta';

  @override
  String get inquiry_request_info => 'Solicitar información';

  @override
  String get inquiry_schedule_viewing => 'Programar visualización';

  @override
  String get inquiry_make_offer => 'Hacer oferta';

  @override
  String get inquiry_request_callback => 'Solicitar devolución de llamada';

  @override
  String get inquiry_message => 'Mensaje';

  @override
  String get inquiry_message_placeholder =>
      'Cuéntenos sobre su interés en esta propiedad...';

  @override
  String get inquiry_offered_price => 'Precio ofrecido';

  @override
  String get inquiry_enter_offer => 'Introduce tu oferta';

  @override
  String get inquiry_preferred_contact_time =>
      'Hora de contacto preferida (opcional)';

  @override
  String get inquiry_contact_time_placeholder =>
      'por ejemplo, de lunes a viernes de 9:00 a. m. a 5:00 p. m.';

  @override
  String get inquiry_cancel => 'Cancelar';

  @override
  String get inquiry_sending => 'Envío...';

  @override
  String get inquiry_send_inquiry => 'Enviar consulta';

  @override
  String get inquiry_inquiry_sent_success => '¡Consulta enviada exitosamente!';

  @override
  String get inquiry_inquiry_sent_error =>
      'No se pudo enviar la consulta. Por favor inténtalo de nuevo.';

  @override
  String get alerts_link_copied =>
      '¡Enlace de propiedad copiado al portapapeles!';

  @override
  String get alerts_phone_copied =>
      '¡Número de teléfono copiado al portapapeles!';

  @override
  String get alerts_save_property_failed => 'No se pudo guardar la propiedad:';

  @override
  String get alerts_email_subject => 'Consulta sobre:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Hola,\\n\\nEstoy interesado en su propiedad \"$title\" ubicada en $address.\\n\\nPor favor contácteme para obtener más información.\\n\\nSaludos cordiales';
  }

  @override
  String get related_properties_view_details => 'Ver detalles';

  @override
  String get header_property => 'Encuentre la propiedad de sus sueños';

  @override
  String get header_sub_property =>
      'Descubra oportunidades inmobiliarias premium en los barrios más atractivos de Tashkent';

  @override
  String get header_title => 'Agentes inmobiliarios';

  @override
  String get header_subtitle =>
      'Encuentre agentes experimentados para ayudarle con sus necesidades inmobiliarias';

  @override
  String get header_agents_found => 'agentes encontrados';

  @override
  String get filters_all_specializations => 'Todas las especializaciones';

  @override
  String get filters_residential => 'Residencial';

  @override
  String get filters_commercial => 'Comercial';

  @override
  String get filters_luxury => 'Lujo';

  @override
  String get filters_investment => 'Inversión';

  @override
  String get filters_any_rating => 'Cualquier calificación';

  @override
  String get filters_four_stars => '4+ estrellas';

  @override
  String get filters_four_half_stars => '4,5+ estrellas';

  @override
  String get filters_five_stars => '5 estrellas';

  @override
  String get filters_highest_rated => 'Mejor valorado';

  @override
  String get filters_lowest_rated => 'Calificación más baja';

  @override
  String get filters_most_sales => 'Mayoría de ventas';

  @override
  String get filters_most_experience => 'Mayor experiencia';

  @override
  String get agent_card_verified_agent => 'Agente verificado';

  @override
  String get agent_card_years_experience => 'años de experiencia';

  @override
  String get agent_card_years => 'años';

  @override
  String get agent_card_license => 'Licencia';

  @override
  String get agent_card_specialization => 'Especialización';

  @override
  String get agent_card_view_profile => 'Ver perfil';

  @override
  String get agent_card_contact => 'Contacto';

  @override
  String get agent_card_verified => 'Verificado';

  @override
  String get no_results_title => 'No se encontraron agentes';

  @override
  String get no_results_message =>
      'Intente ajustar sus criterios o filtros de búsqueda.';

  @override
  String get error_title => 'Error al cargar agentes';

  @override
  String get error_message =>
      'No se pudo cargar la lista de agentes. Por favor inténtalo de nuevo.';

  @override
  String get error_retry => 'Rever';

  @override
  String get error_default_message =>
      'No se pudieron cargar los detalles del agente';

  @override
  String get error_try_again => 'Intentar otra vez';

  @override
  String get notifications_phone_copied =>
      'Número de teléfono copiado al portapapeles';

  @override
  String get notifications_copy_failed =>
      'No se pudo copiar el número de teléfono:';

  @override
  String get fallback_agent_name => 'Agente';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Enviar propiedad';

  @override
  String get navigation_submitting => 'Sumisión...';

  @override
  String get navigation_back_to_agents => 'Volver a Agentes';

  @override
  String get agent_profile_verified_agent => 'Agente verificado';

  @override
  String get agent_profile_contact_agent => 'Contactar al agente';

  @override
  String get agent_profile_send_message => 'Enviar mensaje';

  @override
  String get agent_profile_years_experience => 'Años de experiencia';

  @override
  String get agent_profile_properties_sold => 'Propiedades vendidas';

  @override
  String get agent_profile_active_listings => 'Listados activos';

  @override
  String get agent_profile_total_properties => 'Propiedades totales';

  @override
  String get tabs_overview => 'descripción general';

  @override
  String get tabs_properties => 'propiedades';

  @override
  String get tabs_reviews => 'opiniones';

  @override
  String get about_agent_title => 'Acerca del agente';

  @override
  String get about_agent_agency => 'Agencia';

  @override
  String get about_agent_license_number => 'Número de licencia';

  @override
  String get about_agent_specialization => 'Especialización';

  @override
  String get about_agent_member_since => 'Miembro desde';

  @override
  String get about_agent_verified_since => 'Verificado desde';

  @override
  String get performance_metrics_title => 'Métricas de rendimiento';

  @override
  String get performance_metrics_average_rating => 'Calificación promedio';

  @override
  String get performance_metrics_properties_sold => 'Propiedades vendidas';

  @override
  String get performance_metrics_active_listings => 'Listados activos';

  @override
  String get performance_metrics_years_experience => 'Años de experiencia';

  @override
  String get contact_info_title => 'Información del contacto';

  @override
  String get contact_info_contact_via_platform => 'Contacto vía Plataforma';

  @override
  String get verification_status_title => 'Estado de verificación';

  @override
  String get verification_status_verified_agent => 'Agente verificado';

  @override
  String get verification_status_pending_verification =>
      'Pendiente de verificación';

  @override
  String get verification_status_licensed_professional =>
      'Profesional Licenciado';

  @override
  String get verification_status_registered_agency => 'Agencia registrada';

  @override
  String get quick_actions_title => 'Acciones rápidas';

  @override
  String get quick_actions_call_now => 'Llama ahora';

  @override
  String get quick_actions_send_message => 'Enviar mensaje';

  @override
  String get quick_actions_view_properties => 'Ver propiedades';

  @override
  String get properties_title => 'Propiedades del agente';

  @override
  String get properties_loading_properties => 'Cargando propiedades...';

  @override
  String get properties_no_properties_title => 'No se encontraron propiedades';

  @override
  String get properties_no_properties_message =>
      'Las propiedades de este agente aparecerán aquí.';

  @override
  String get properties_recent_properties_note =>
      'Mostrando propiedades recientes. Consulte los listados completos de todas las propiedades de los agentes.';

  @override
  String get properties_listed => 'Listado';

  @override
  String get properties_bed => 'cama';

  @override
  String get properties_bath => 'baño';

  @override
  String get properties_for_sale => 'En venta';

  @override
  String get properties_for_rent => 'En alquiler';

  @override
  String get reviews_title => 'Reseñas de clientes';

  @override
  String get reviews_no_reviews_title => 'Aún no hay reseñas';

  @override
  String get reviews_no_reviews_message =>
      'Las reseñas y recomendaciones de los clientes aparecerán aquí.';

  @override
  String get fallbacks_agent_name => 'Agente';

  @override
  String get fallbacks_default_profile_image => '/avatar-predeterminado.png';

  @override
  String get saved_properties_title => 'Propiedades guardadas';

  @override
  String get saved_properties_subtitle =>
      'Tus propiedades favoritas en un solo lugar';

  @override
  String get saved_properties_no_saved_properties =>
      'Aún no hay propiedades guardadas';

  @override
  String get saved_properties_start_saving =>
      'Comience a explorar y guarde las propiedades que le gusten';

  @override
  String get saved_properties_browse_properties => 'Explorar propiedades';

  @override
  String get saved_properties_saved_on => 'Guardado en';

  @override
  String get auth_login_required =>
      'Por favor inicie sesión para ver las propiedades guardadas';

  @override
  String get auth_login => 'Acceso';

  @override
  String get success_property_unsaved =>
      'Propiedad eliminada de la lista guardada';

  @override
  String get success_property_saved => 'Propiedad guardada exitosamente';

  @override
  String get success_phone_copied => '¡Número de teléfono copiado!';

  @override
  String get success_property_created_success => '¡Propiedad creada con éxito!';

  @override
  String get success_agent_approved => 'Agente aprobado exitosamente';

  @override
  String get success_agent_rejected => 'Agente rechazado exitosamente';

  @override
  String get steps_step => 'Paso';

  @override
  String get steps_basic_information => 'Información básica';

  @override
  String get steps_location_details => 'Detalles de la ubicación';

  @override
  String get steps_property_details => 'Detalles de la propiedad';

  @override
  String get steps_property_images => 'Imágenes de propiedad';

  @override
  String get basic_info_tell_us_about_property =>
      'Cuéntanos sobre tu propiedad';

  @override
  String get basic_info_property_type => 'Tipo de propiedad';

  @override
  String get basic_info_listing_type => 'Tipo de listado';

  @override
  String get basic_info_property_title => 'Título de propiedad';

  @override
  String get basic_info_title_placeholder =>
      'Introduzca un título descriptivo para su propiedad';

  @override
  String get basic_info_description => 'Descripción';

  @override
  String get basic_info_description_placeholder =>
      'Describe tu propiedad en detalle...';

  @override
  String get property_types_apartment => 'Departamento';

  @override
  String get property_types_house => 'Casa';

  @override
  String get property_types_townhouse => 'Casa adosada';

  @override
  String get property_types_villa => 'Villa';

  @override
  String get property_types_commercial => 'Comercial';

  @override
  String get property_types_office => 'Oficina';

  @override
  String get property_types_land => 'Tierra';

  @override
  String get property_types_warehouse => 'Depósito';

  @override
  String get listing_types_for_sale => 'En venta';

  @override
  String get listing_types_for_rent => 'En alquiler';

  @override
  String get location_where_is_property => '¿Dónde está ubicada su propiedad?';

  @override
  String get location_full_address => 'Dirección completa';

  @override
  String get location_address_placeholder => 'Introduce la dirección completa';

  @override
  String get location_region => 'Región';

  @override
  String get location_select_region => 'Seleccionar región';

  @override
  String get location_district => 'Distrito';

  @override
  String get location_select_district => 'Seleccionar distrito';

  @override
  String get location_city => 'Ciudad';

  @override
  String get location_city_placeholder => 'Ciudad';

  @override
  String get location_loading_regions => 'Cargando regiones...';

  @override
  String get location_loading_districts => 'Cargando distritos...';

  @override
  String get location_map_coordinates => 'Coordenadas del mapa';

  @override
  String get location_get_coordinates => 'Obtener coordenadas';

  @override
  String get location_latitude => 'Latitud';

  @override
  String get location_longitude => 'Longitud';

  @override
  String get location_coordinates_set => 'conjunto de coordenadas';

  @override
  String get location_location_tips => 'Consejos de ubicación';

  @override
  String get location_location_tip_1 =>
      '• Primero complete la dirección y luego haga clic en \'Obtener coordenadas\' para obtener automáticamente la ubicación en el mapa.';

  @override
  String get location_location_tip_2 =>
      '• También puedes ingresar coordenadas manualmente si conoces la ubicación exacta';

  @override
  String get location_location_tip_3 =>
      '• Las coordenadas precisas ayudan a los compradores a encontrar su propiedad en el mapa';

  @override
  String get property_details_provide_detailed_info =>
      'Proporcionar información detallada sobre su propiedad';

  @override
  String get property_details_total_floors => 'Pisos totales';

  @override
  String get property_details_area_m2 => 'Área (m²)';

  @override
  String get property_details_parking_spaces => 'Plazas de aparcamiento';

  @override
  String get property_details_price => 'Precio';

  @override
  String get property_details_features => 'Características';

  @override
  String get images_add_photos_showcase =>
      'Añade fotos para mostrar tu propiedad';

  @override
  String get images_click_to_upload => 'Haga clic para subir imágenes';

  @override
  String get images_max_images_info => 'Máximo 10 imágenes, JPG, PNG o WEBP';

  @override
  String get images_main => 'Principal';

  @override
  String get images_maximum_images_allowed => 'Máximo 10 imágenes permitidas';

  @override
  String get admin_dashboard_title => 'Panel de administración';

  @override
  String get admin_dashboard_subtitle =>
      'Visión general en tiempo real de su plataforma inmobiliaria';

  @override
  String get admin_last_update => 'Última actualización';

  @override
  String get admin_total_properties => 'Propiedades totales';

  @override
  String get admin_total_agents => 'Agentes totales';

  @override
  String get admin_total_users => 'Usuarios totales';

  @override
  String get admin_total_views => 'Vistas totales';

  @override
  String get admin_error_loading_dashboard => 'Error al cargar el panel';

  @override
  String get admin_failed_to_load_data =>
      'No se pudieron cargar los datos del panel';

  @override
  String get admin_avg_sale_price => 'Precio de venta promedio';

  @override
  String get admin_avg_sale_price_subtitle => 'Todos los listados activos';

  @override
  String get admin_total_portfolio_value => 'Valor total de la cartera';

  @override
  String get admin_total_portfolio_value_subtitle =>
      'Valor de propiedad combinado';

  @override
  String get admin_avg_price_per_sqm => 'Precio medio por m2';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Indicador de tasa de mercado';

  @override
  String get admin_property_types_distribution =>
      'Distribución de tipos de propiedad';

  @override
  String get admin_properties_by_city => 'Propiedades por ciudad';

  @override
  String get admin_properties_by_district => 'Propiedades por Distrito';

  @override
  String get admin_inquiry_types_distribution =>
      'Distribución de tipos de consultas';

  @override
  String get admin_agent_verification_rate => 'Tasa de verificación del agente';

  @override
  String get admin_agent_verification_rate_subtitle => 'Control de calidad';

  @override
  String get admin_inquiry_response_rate => 'Tasa de respuesta a consultas';

  @override
  String get admin_inquiry_response_rate_subtitle => 'Servicio al cliente';

  @override
  String get admin_avg_views_per_property => 'Vistas promedio por propiedad';

  @override
  String get admin_avg_views_per_property_subtitle =>
      'Popularidad de la propiedad';

  @override
  String get admin_featured_properties => 'Propiedades destacadas';

  @override
  String get admin_featured_properties_subtitle => 'Listados premium';

  @override
  String get admin_most_viewed_properties => 'Propiedades más vistas';

  @override
  String get admin_top_performing_agents => 'Agentes con mejor desempeño';

  @override
  String get admin_system_health => 'Estado del sistema';

  @override
  String get admin_properties_without_images => 'Propiedades sin imágenes';

  @override
  String get admin_missing_location_data => 'Faltan datos de ubicación';

  @override
  String get admin_pending_agent_verification =>
      'Pendiente de verificación del agente';

  @override
  String get admin_active => 'activo';

  @override
  String get admin_verified => 'verificado';

  @override
  String get admin_active_7d => 'activo (7d)';

  @override
  String get admin_this_month => 'este mes';

  @override
  String get agents_loading_pending_applications =>
      'Cargando solicitudes pendientes...';

  @override
  String get agents_error_loading_applications =>
      'Error al cargar aplicaciones';

  @override
  String get agents_pending_agents => 'Agentes pendientes';

  @override
  String get agents_total_pending_applications =>
      'Total de solicitudes pendientes:';

  @override
  String get agents_pending_verification => 'Pendiente de verificación';

  @override
  String get agents_applied_date => 'Aplicado:';

  @override
  String get agents_contact_info => 'Información del contacto';

  @override
  String get agents_license_number => 'Número de licencia';

  @override
  String get agents_years_experience => 'Años de experiencia';

  @override
  String get agents_years_suffix => 'años';

  @override
  String get agents_total_sales => 'Ventas totales';

  @override
  String get agents_specialization => 'Especialización';

  @override
  String get agents_approve => 'Aprobar';

  @override
  String get agents_reject => 'Rechazar';

  @override
  String get agents_no_pending_applications => 'No hay solicitudes pendientes';

  @override
  String get agents_all_applications_processed =>
      'Todas las solicitudes de agentes han sido procesadas.';

  @override
  String get general_previous => 'Anterior';

  @override
  String get general_page => 'Página';

  @override
  String get general_next => 'Próximo';

  @override
  String get general_views => 'vistas';

  @override
  String get general_sales => 'ventas';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'ruso';

  @override
  String get general_language_en => 'Inglés';

  @override
  String get general_super_admin => 'Súper administrador';

  @override
  String get general_staff => 'Personal';

  @override
  String get general_verified_agent => 'Agente verificado';

  @override
  String get general_pending_agent => 'Agente pendiente';

  @override
  String get general_regular_user => 'Usuario habitual';

  @override
  String get general_admin => 'Administración';

  @override
  String get general_dashboard => 'Panel';

  @override
  String get general_manage_users => 'Administrar usuarios';

  @override
  String get general_verified_agents => 'Agentes verificados';

  @override
  String get general_agent_panel => 'Panel de agentes';

  @override
  String get general_create_property => 'Crear propiedad';

  @override
  String get general_my_properties => 'Mis propiedades';

  @override
  String get general_inquiries => 'Consultas';

  @override
  String get general_agent_profile => 'Perfil del agente';

  @override
  String get general_live => 'Vivir';

  @override
  String get general_logged_out_successfully => 'Cerró sesión exitosamente';

  @override
  String get general_logout_completed_with_errors =>
      'Cierre de sesión completado (con errores)';

  @override
  String get general_application_under_review => 'Solicitud bajo revisión';

  @override
  String get general_check_status => 'Consultar estado →';

  @override
  String get general_last_updated => 'Última actualización:';

  @override
  String get general_permissions_may_be_outdated =>
      'Los permisos pueden estar desactualizados';

  @override
  String get general_permissions_up_to_date => 'Permisos al día';

  @override
  String get general_never => 'Nunca';

  @override
  String get general_properties_found => 'Propiedades encontradas';

  @override
  String get general_properties_saved => 'propiedades guardadas';

  @override
  String get general_saved => 'salvado';

  @override
  String get general_loading_properties => 'Cargando propiedades...';

  @override
  String get general_failed_to_load =>
      'No se pudieron cargar las propiedades. Por favor inténtalo de nuevo.';

  @override
  String get general_no_properties_found => 'No se encontraron propiedades';

  @override
  String get general_try_adjusting =>
      'Intente ajustar sus criterios de búsqueda';

  @override
  String get select_category => 'Seleccionar categoría';

  @override
  String get service_description => 'Descripción del servicio';

  @override
  String get product_search_placeholder =>
      'Ingrese un término de búsqueda para encontrar productos';

  @override
  String get privacy_policy => 'política de privacidad';

  @override
  String get terms_subtitle => 'Política de privacidad y términos';

  @override
  String get last_updated => 'Última actualización';

  @override
  String get contact_information => 'Información del contacto';

  @override
  String get accept_terms => 'Acepto Términos y Condiciones';

  @override
  String get read_terms => 'Por favor lea nuestros términos y condiciones.';

  @override
  String get inquiries => 'Consultas y soporte';

  @override
  String get inquiries_subtitle => 'Contáctenos para obtener ayuda';

  @override
  String get help_center => '¿Cómo podemos ayudarte?';

  @override
  String get help_subtitle =>
      'Estamos aquí para ayudarte con cualquier pregunta.';

  @override
  String get contact_us => 'Contáctenos';

  @override
  String get email_support => 'Soporte por correo electrónico';

  @override
  String get call_support => 'Llamar a soporte';

  @override
  String get send_message => 'Enviar mensaje';

  @override
  String get fill_contact_form => 'Rellenar formulario de contacto';

  @override
  String get contact_form => 'Formulario de contacto';

  @override
  String get name => 'Su nombre';

  @override
  String get name_required => 'Por favor ingresa tu nombre';

  @override
  String get email => 'Dirección de correo electrónico';

  @override
  String get email_required => 'Por favor ingrese su correo electrónico';

  @override
  String get email_invalid =>
      'Por favor introduce un correo electrónico válido';

  @override
  String get subject => 'Sujeto';

  @override
  String get subject_required => 'Por favor ingresa un asunto';

  @override
  String get message => 'Mensaje';

  @override
  String get message_required => 'Por favor ingresa tu mensaje';

  @override
  String get message_too_short =>
      'El mensaje debe tener al menos 10 caracteres.';

  @override
  String get faq => 'Preguntas frecuentes';

  @override
  String get follow_us => 'Síganos';

  @override
  String get faq_how_to_sell => '¿Cómo vendo artículos en Tezsell?';

  @override
  String get faq_how_to_sell_answer =>
      'Para vender artículos: 1) Cree una cuenta, 2) Toque el botón \'+\', 3) Elija categoría (Productos/Servicios/Bienes Raíces), 4) Agregue fotos y descripción, 5) Establezca su precio, 6) ¡Publique! Su anuncio será visible para los compradores de su área.';

  @override
  String get faq_is_free => '¿Tezsell es de uso gratuito?';

  @override
  String get faq_is_free_answer =>
      '¡Sí! Actualmente, Tezsell es 100% gratuito. Sin tarifas de listado, sin comisiones por ventas, sin cargos de suscripción. Es posible que introduzcamos funciones premium en el futuro, pero notificaremos a los usuarios con 30 días de anticipación.';

  @override
  String get faq_safety => '¿Cómo puedo mantenerme seguro al comprar/vender?';

  @override
  String get faq_safety_answer =>
      'Consejos de seguridad: 1) Reúnase en lugares públicos, 2) Inspeccione los artículos antes de pagar, 3) Nunca envíe dinero a extraños, 4) Confíe en sus instintos, 5) Informe a usuarios sospechosos, 6) No comparta información personal demasiado pronto, 7) Traiga a un amigo para transacciones de alto valor.';

  @override
  String get faq_payment => '¿Cómo funcionan los pagos?';

  @override
  String get faq_payment_answer =>
      'Tezsell no procesa pagos. Los compradores y vendedores organizan el pago directamente (efectivo, transferencia bancaria, etc.). Somos solo una plataforma para conectar a las personas: ustedes mismos manejan la transacción.';

  @override
  String get faq_prohibited => '¿Qué artículos están prohibidos?';

  @override
  String get faq_prohibited_answer =>
      'Los artículos prohibidos incluyen: armas, drogas, bienes robados, artículos falsificados, contenido para adultos, animales vivos (sin permisos), identificaciones gubernamentales y materiales peligrosos. Consulte nuestros Términos y condiciones para obtener la lista completa.';

  @override
  String get faq_account_delete => '¿Cómo elimino mi cuenta?';

  @override
  String get faq_account_delete_answer =>
      'Vaya a Perfil → Configuración → Configuración de cuenta → Eliminar cuenta. Nota: Esto es permanente y no se puede deshacer. Se eliminarán todos sus listados.';

  @override
  String get faq_report_user => '¿Cómo denuncio a un usuario o listado?';

  @override
  String get faq_report_user_answer =>
      'Toque los tres puntos (•••) en cualquier listado o perfil de usuario, luego seleccione \'Denunciar\'. Elija el motivo y envíelo. Revisamos todos los informes en un plazo de 24 a 48 horas.';

  @override
  String get faq_change_location => '¿Cómo cambio mi ubicación?';

  @override
  String get faq_change_location_answer =>
      'Toque el botón de ubicación en la esquina superior izquierda de la pantalla de inicio. Puede seleccionar su región y distrito para ver listados en su área.';

  @override
  String get welcome_customer_center =>
      'Bienvenido al centro de atención al cliente';

  @override
  String get customer_center_subtitle =>
      'Estamos aquí para ayudarte 24 horas al día, 7 días a la semana';

  @override
  String get quick_actions => 'Acciones rápidas';

  @override
  String get live_chat => 'Chat en vivo';

  @override
  String get chat_with_us => 'Chatea con nosotros';

  @override
  String get find_answers => 'encontrar respuestas';

  @override
  String get my_tickets => 'Mis entradas';

  @override
  String get view_tickets => 'Ver entradas';

  @override
  String get feedback => 'Comentario';

  @override
  String get share_feedback => 'Compartir comentarios';

  @override
  String get contact_methods => 'Métodos de contacto';

  @override
  String get phone_support => 'Soporte telefónico';

  @override
  String get available_247 => 'Disponible 24 horas al día, 7 días a la semana';

  @override
  String get response_24h => 'Respuesta en 24 horas';

  @override
  String get telegram_support => 'Soporte de telegramas';

  @override
  String get instant_replies => 'Respuestas instantáneas';

  @override
  String get whatsapp_support => 'Soporte WhatsApp';

  @override
  String get quick_response => 'Respuesta rápida';

  @override
  String get popular_topics => 'Temas populares';

  @override
  String get account_management => 'Gestión de cuentas';

  @override
  String get reset_password => 'Restablecer contraseña';

  @override
  String get update_profile => 'Actualizar perfil';

  @override
  String get verify_account => 'Verificar cuenta';

  @override
  String get delete_account => 'Eliminar cuenta';

  @override
  String get buying_selling => 'Compra y Venta';

  @override
  String get how_to_post => 'Cómo publicar anuncios';

  @override
  String get payment_methods => 'Métodos de pago';

  @override
  String get shipping_delivery => 'Envío y entrega';

  @override
  String get return_policy => 'Política de devoluciones';

  @override
  String get safety_security => 'Seguridad y protección';

  @override
  String get report_scam => 'Informar estafa';

  @override
  String get safe_trading => 'Consejos para operar con seguridad';

  @override
  String get privacy_settings => 'Configuración de privacidad';

  @override
  String get blocked_users => 'Usuarios bloqueados';

  @override
  String get technical_issues => 'Problemas técnicos';

  @override
  String get app_not_working => 'La aplicación no funciona';

  @override
  String get upload_failed => 'Error de carga';

  @override
  String get login_problems => 'Problemas de inicio de sesión';

  @override
  String get support_hours => 'Horas de soporte';

  @override
  String get mon_fri_9_6 => 'Lunes a viernes: 9:00 a. m. - 6:00 p. m.';

  @override
  String get how_are_we_doing => '¿Cómo estamos?';

  @override
  String get rate_experience =>
      'Califica tu experiencia de servicio al cliente';

  @override
  String get poor => 'Pobre';

  @override
  String get okay => 'Bueno';

  @override
  String get good => 'Bien';

  @override
  String get excellent => 'Excelente';

  @override
  String get account_secure => 'Su cuenta es segura';

  @override
  String get password_security => 'Contraseña y autenticación';

  @override
  String get change_password => 'Cambiar la contraseña';

  @override
  String get two_factor_auth => 'Autenticación de dos factores';

  @override
  String get biometric_login => 'Inicio de sesión biométrico';

  @override
  String get login_activity => 'Actividad de inicio de sesión';

  @override
  String get active_sessions => 'Sesiones activas';

  @override
  String get login_alerts => 'Alertas de inicio de sesión';

  @override
  String get account_protection => 'Protección de cuenta';

  @override
  String get recovery_email => 'Correo electrónico de recuperación';

  @override
  String get backup_codes => 'Códigos de respaldo';

  @override
  String get danger_zone => 'Zona de peligro';

  @override
  String get improve_security => 'Mejorar la seguridad';

  @override
  String get security_score => 'Puntuación de seguridad';

  @override
  String get last_changed_days => 'Último cambio hace 30 días';

  @override
  String get logout_all_devices => 'Cerrar sesión en todos los dispositivos';

  @override
  String get end_all_sessions => 'Finalizar todas las sesiones';

  @override
  String get permanently_delete => 'Eliminar permanentemente';

  @override
  String get verification_code_message =>
      'Le enviaremos un código de verificación para confirmar que es usted.';

  @override
  String get send_code => 'Enviar código';

  @override
  String get enter_verification_code => 'Ingrese el código de verificación';

  @override
  String get verification_code => 'Código de verificación';

  @override
  String get new_password => 'Nueva contraseña';

  @override
  String get confirm_password => 'confirmar Contraseña';

  @override
  String get resend_code => 'Reenviar código';

  @override
  String get code_sent_to => 'Ingrese el código de verificación enviado a';

  @override
  String get enter_code => 'Ingrese el código de verificación';

  @override
  String get code_must_be_6_digits => 'El código debe tener 6 dígitos.';

  @override
  String get enter_new_password => 'Ingrese una nueva contraseña';

  @override
  String get minimum_8_characters => 'Mínimo 8 caracteres';

  @override
  String get passwords_do_not_match => 'Las contraseñas no coinciden';

  @override
  String get close => 'Cerca';

  @override
  String get current => 'Actual';

  @override
  String get session_ended => 'Sesión finalizada';

  @override
  String get update_recovery_email =>
      'Actualizar correo electrónico de recuperación';

  @override
  String get new_email => 'Nuevo correo electrónico';

  @override
  String get update => 'Actualizar';

  @override
  String get verification_email_sent =>
      'Correo electrónico de verificación enviado';

  @override
  String get generate_emergency_codes => 'Generar códigos de emergencia';

  @override
  String get copy_all => 'Copiar todo';

  @override
  String get code_copied => 'Código copiado';

  @override
  String get all_codes_copied => 'Todos los códigos copiados';

  @override
  String get logout_all_devices_confirm =>
      '¿Cerrar sesión en todos los dispositivos?';

  @override
  String get logout_all_devices_message =>
      'Esto finalizará todas las sesiones activas en todos los dispositivos.';

  @override
  String get logout_all => 'Cerrar sesión en todo';

  @override
  String get delete_account_confirm => '¿Eliminar cuenta?';

  @override
  String get delete_account_warning =>
      'Esta acción es PERMANENTE y no se puede deshacer. Todos sus datos serán eliminados permanentemente.';

  @override
  String get what_will_be_deleted => 'Qué se eliminará:';

  @override
  String get profile_and_account_info =>
      '• Su perfil y la información de su cuenta';

  @override
  String get all_listings_and_posts => '• Todos tus listados y publicaciones';

  @override
  String get messages_and_conversations => 'Mensajes';

  @override
  String get saved_items_and_preferences =>
      '• Elementos guardados y preferencias';

  @override
  String get enter_password_to_continue =>
      'Ingresa tu contraseña para continuar';

  @override
  String get continue_val => 'Continuar';

  @override
  String get please_enter_password => 'Por favor ingrese su contraseña';

  @override
  String get enter_confirmation_code => 'Introducir el código de confirmación';

  @override
  String get deletion_confirmation_message =>
      'Le enviamos un código de confirmación a su teléfono. Ingréselo a continuación para eliminar permanentemente su cuenta.';

  @override
  String get confirmation_code => 'Código de confirmación';

  @override
  String get please_enter_6_digit_code =>
      'Por favor ingresa el código de 6 dígitos';

  @override
  String get account_deleted => 'Tu cuenta ha sido eliminada';

  @override
  String get deletion_cancelled => 'Eliminación cancelada';

  @override
  String get failed_to_load_user_info =>
      'No se pudo cargar la información del usuario';

  @override
  String get auth_login_to_view_saved =>
      'Por favor inicie sesión para ver sus propiedades guardadas';

  @override
  String get authLoginRequired => 'Iniciar sesión requerido';

  @override
  String get authLoginToViewSaved =>
      'Por favor inicie sesión para ver sus propiedades guardadas';

  @override
  String get authLogin => 'Acceso';

  @override
  String get savedPropertiesTitle => 'Propiedades guardadas';

  @override
  String get loadingSavedProperties => 'Cargando propiedades guardadas...';

  @override
  String get errorsFailedToLoadSaved =>
      'No se pudieron cargar las propiedades guardadas';

  @override
  String get actionsRetry => 'Rever';

  @override
  String get savedPropertiesNoSaved => 'No hay propiedades guardadas';

  @override
  String get savedPropertiesStartSaving =>
      'Comience a explorar y guarde las propiedades que le gusten';

  @override
  String get savedPropertiesBrowse => 'Explorar propiedades';

  @override
  String get resultsSavedProperties => 'propiedades guardadas';

  @override
  String get actionsRefresh => 'Refrescar';

  @override
  String get resultsNoMoreProperties => 'No más propiedades';

  @override
  String get propertyCardFeatured => 'Presentado';

  @override
  String get successPropertyUnsaved =>
      'Propiedad eliminada de la lista guardada';

  @override
  String get alertsUnsavePropertyFailed => 'No se pudo eliminar la propiedad';

  @override
  String get propertyCardBed => 'cama';

  @override
  String get propertyCardBath => 'baño';

  @override
  String get savedPropertiesSavedOn => 'Guardado en';

  @override
  String get propertyCardViewDetails => 'Ver detalles';

  @override
  String get serviceDetailTitle => 'Detalle del servicio';

  @override
  String get errorLoadingFavorites => 'Error al cargar artículos favoritos';

  @override
  String get noFavoritesFound => 'No se encontraron artículos favoritos.';

  @override
  String get commentUpdatedSuccess => '¡Comentario actualizado exitosamente!';

  @override
  String get errorUpdatingComment => 'Error al actualizar el comentario';

  @override
  String get replyAddedSuccess => '¡Respuesta agregada exitosamente!';

  @override
  String get errorAddingReply => 'Error al agregar la respuesta';

  @override
  String get commentDeletedSuccess => '¡Comentario eliminado exitosamente!';

  @override
  String get errorDeletingComment => 'Error al eliminar comentario';

  @override
  String get serviceLikedSuccess => '¡El servicio le gustó con éxito!';

  @override
  String get errorLikingService => 'Error al gustar el servicio';

  @override
  String get serviceDislikedSuccess => '¡El servicio no me gustó con éxito!';

  @override
  String get errorDislikingService => 'Error al no gustar el servicio';

  @override
  String get writeYourReply => 'Escribe tu respuesta...';

  @override
  String get postReply => 'Publicar respuesta';

  @override
  String get anonymous => 'Anónimo';

  @override
  String get editComment => 'Editar comentario';

  @override
  String get editYourComment => 'Edita tu comentario...';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get propertyOwner => 'Dueño de la propiedad';

  @override
  String get errorLoadingServices => 'Error al cargar servicios';

  @override
  String get noRecommendedServicesFound =>
      'No se encontraron servicios recomendados.';

  @override
  String get passwordRequired => 'Se requiere contraseña';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres.';

  @override
  String get passwordRequirements =>
      'La contraseña debe contener letras y números.';

  @override
  String get usernameRequired => 'El nombre de usuario es obligatorio';

  @override
  String get usernameTooShort =>
      'El nombre de usuario debe tener al menos 3 caracteres.';

  @override
  String get confirmPasswordRequired =>
      'Se requiere confirmación de contraseña';

  @override
  String get passwordHelp => 'Al menos 8 caracteres, letras y números.';

  @override
  String get usernameExists => 'Este nombre de usuario ya existe';

  @override
  String get phoneExists => 'Este número de teléfono ya está registrado';

  @override
  String get networkError =>
      'Error de conexión de red. Por favor revisa tu conexión';

  @override
  String get contactSeller => 'Contactar al vendedor';

  @override
  String get callToReveal => 'Toca \"Llamar\" para revelar';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get selectImageSource => 'Seleccionar fuente de imagen';

  @override
  String get uploading => 'Subiendo...';

  @override
  String get acceptTermsRequired =>
      'Debes aceptar los Términos y Condiciones para continuar';

  @override
  String get iAgreeToTerms => 'Estoy de acuerdo con el';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get zeroToleranceStatement =>
      'y comprender que existe tolerancia cero con el contenido objetable o los usuarios abusivos.';

  @override
  String get viewTerms => 'Ver términos y condiciones';

  @override
  String get reportContent => 'Informar contenido';

  @override
  String get selectReportReason => 'Seleccione un motivo para informar:';

  @override
  String get additionalDetails => 'Detalles adicionales (opcional)';

  @override
  String get reportDetailsHint =>
      'Proporcione cualquier información adicional...';

  @override
  String get reportSubmitted =>
      'Gracias por tu informe. Lo revisaremos dentro de las 24 horas.';

  @override
  String get reportProduct => 'Reportar producto';

  @override
  String get reportService => 'Servicio de informes';

  @override
  String get reportMessage => 'Mensaje de informe';

  @override
  String get reportUser => 'Reportar usuario';

  @override
  String get reportErrorNotImplemented =>
      'La función de informes aún no está disponible. Comuníquese con el soporte o inténtelo nuevamente más tarde.';

  @override
  String get reportAlreadySubmitted =>
      'Ya has reportado este contenido. Estamos revisando su informe anterior.';

  @override
  String get reportFailedGeneric =>
      'No se pudo enviar el informe. Por favor inténtalo de nuevo.';

  @override
  String get reportFailedNetwork =>
      'Se produjo un error de red. Por favor verifique su conexión e inténtelo nuevamente.';

  @override
  String get becomeAgentTitle => 'Únase como agente inmobiliario';

  @override
  String get becomeAgentSubtitle =>
      'Enumere propiedades y ayude a los clientes a encontrar la casa de sus sueños';

  @override
  String get agentBenefits => 'Beneficios:';

  @override
  String get agentBenefitVerified => 'Insignia de agente verificado';

  @override
  String get agentBenefitAnalytics => 'Acceso a análisis e información';

  @override
  String get agentBenefitClients =>
      'Contacto directo con clientes potenciales.';

  @override
  String get agentBenefitReputation => 'Construye tu reputación profesional';

  @override
  String get agentApplicationForm => 'Formulario de solicitud';

  @override
  String get agentAgencyName => 'Nombre de la agencia';

  @override
  String get agentAgencyNameHint =>
      'Introduzca el nombre de su agencia inmobiliaria';

  @override
  String get agentAgencyNameRequired =>
      'El nombre de la agencia es obligatorio.';

  @override
  String get agentLicenceNumber => 'Número de licencia';

  @override
  String get agentLicenceNumberHint =>
      'Ingrese su número de licencia de bienes raíces';

  @override
  String get agentLicenceNumberRequired => 'Se requiere número de licencia';

  @override
  String get agentYearsExperience => 'Años de experiencia';

  @override
  String get agentYearsExperienceHint => 'Introduzca el número de años';

  @override
  String get agentYearsExperienceRequired => 'Se requieren años de experiencia';

  @override
  String get agentYearsExperienceInvalid =>
      'Por favor ingresa un número válido';

  @override
  String get agentSpecialization => 'Especialización';

  @override
  String get agentApplicationNote =>
      'Su solicitud será revisada por nuestro equipo. Se le notificará una vez que se apruebe su solicitud.';

  @override
  String get agentSubmitApplication => 'Enviar solicitud';

  @override
  String get agentApplicationSubmitted =>
      '¡Solicitud enviada exitosamente! Lo revisaremos pronto.';

  @override
  String get agentApplicationStatus => 'Estado de la solicitud';

  @override
  String get agentViewProfile => 'Ver tu perfil de agente';

  @override
  String get agentDashboardComingSoon => '¡Próximamente el panel de agentes!';

  @override
  String get property_create_basic_information => 'Información básica';

  @override
  String get property_create_property_title => 'Título de propiedad *';

  @override
  String get property_create_property_title_hint =>
      'por ejemplo, apartamento moderno de 3 dormitorios en el centro de la ciudad';

  @override
  String get property_create_property_title_required =>
      'Por favor ingrese el título de la propiedad';

  @override
  String get property_create_description => 'Descripción *';

  @override
  String get property_create_description_hint =>
      'Describe tu propiedad en detalle...';

  @override
  String get property_create_description_required =>
      'Por favor ingrese la descripción';

  @override
  String get property_create_property_type => 'Tipo de propiedad';

  @override
  String get property_create_property_type_required => 'Tipo de propiedad *';

  @override
  String get property_create_listing_type_required => 'Tipo de listado *';

  @override
  String get property_create_pricing => 'Precios';

  @override
  String get property_create_price => 'Precio *';

  @override
  String get property_create_price_hint => 'Introduce el precio';

  @override
  String get property_create_price_required => 'Por favor ingrese el precio';

  @override
  String get property_create_currency => 'Divisa';

  @override
  String get property_create_property_details => 'Detalles de la propiedad';

  @override
  String get property_create_square_meters => 'Cuadrados. Metros *';

  @override
  String get property_create_bedrooms => 'Dormitorios *';

  @override
  String get property_create_bathrooms => 'Baños *';

  @override
  String get property_create_floor => 'Piso';

  @override
  String get property_create_total_floors => 'Pisos totales';

  @override
  String get property_create_parking => 'Aparcamiento';

  @override
  String get property_create_year_built => 'Año de construcción';

  @override
  String get property_create_location => 'Ubicación';

  @override
  String get property_create_address => 'DIRECCIÓN *';

  @override
  String get property_create_address_hint =>
      'Introduzca la dirección de la propiedad';

  @override
  String get property_create_address_required =>
      'Por favor ingrese la dirección';

  @override
  String get property_create_location_detected => 'Ubicación detectada';

  @override
  String get property_create_get_location => 'Obtener ubicación actual';

  @override
  String get property_create_features => 'Características';

  @override
  String get property_create_feature_balcony => 'Balcón';

  @override
  String get property_create_feature_garage => 'Cochera';

  @override
  String get property_create_feature_garden => 'Jardín';

  @override
  String get property_create_feature_pool => 'Piscina';

  @override
  String get property_create_feature_elevator => 'Ascensor';

  @override
  String get property_create_feature_furnished => 'Amueblado';

  @override
  String get property_create_images => 'Imágenes de propiedad';

  @override
  String get property_create_tap_to_add_images => 'Toca para agregar imágenes';

  @override
  String get property_create_at_least_one_image =>
      'Se requiere al menos 1 imagen';

  @override
  String get property_create_add_more => 'Añadir más';

  @override
  String get property_create_required => 'Requerido';

  @override
  String get property_create_location_required =>
      'Habilite los servicios de ubicación para crear una propiedad.';

  @override
  String get property_create_image_required =>
      'Se requiere al menos una imagen de propiedad';

  @override
  String get emailVerification => 'Verificación de correo electrónico';

  @override
  String get pleaseEnterYourEmailAddress =>
      'Por favor ingrese su dirección de correo electrónico';

  @override
  String get enterEmailAddress =>
      'Introduzca la dirección de correo electrónico';

  @override
  String get resetYourPassword => 'Restablecer su contraseña';

  @override
  String get resetPasswordDescription =>
      'Ingrese su dirección de correo electrónico y le enviaremos un código de verificación para restablecer su contraseña.';

  @override
  String get sendVerificationCode => 'Enviar código de verificación';

  @override
  String get backToLogin => 'Volver a iniciar sesión';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String enterVerificationCodeSentTo(String email) {
    return 'Ingrese el código de verificación enviado a $email';
  }

  @override
  String get codeMustBe6Digits => 'El código debe tener 6 dígitos.';

  @override
  String get enterNewPassword => 'Ingrese una nueva contraseña';

  @override
  String get minimum8Characters => 'Mínimo 8 caracteres';

  @override
  String get sending => 'Envío...';

  @override
  String get verifying => 'Verificando...';

  @override
  String get new_message => 'Nuevo mensaje';

  @override
  String get messages => 'Mensajes';

  @override
  String get please_log_in => 'Por favor inicia sesión para ver mensajes';

  @override
  String get pin => 'Alfiler';

  @override
  String get unpin => 'Desprender';

  @override
  String get delete_chat => 'Eliminar chat';

  @override
  String delete_chat_confirm(String name) {
    return '¿Estás seguro de que deseas eliminar el chat con $name? Esta acción no se puede deshacer.';
  }

  @override
  String chat_deleted(String name) {
    return 'Chat con $name eliminado';
  }

  @override
  String get delete_failed => 'No se pudo eliminar el chat';

  @override
  String get no_conversations => 'Aún no hay conversaciones';

  @override
  String get start_conversation_hint =>
      'Inicie una conversación tocando el botón +';

  @override
  String get start_conversation => 'Iniciar una conversación';

  @override
  String get yesterday => 'Ayer';

  @override
  String get unknown => 'Desconocido';

  @override
  String get no_messages_yet => 'Aún no hay mensajes';

  @override
  String get unblock_user => 'Desbloquear usuario';

  @override
  String get block_user => 'Bloquear usuario';

  @override
  String get no_blocked_users => 'Ningún usuario bloqueado';

  @override
  String get blocked_users_hint => 'Los usuarios que bloquees aparecerán aquí';

  @override
  String unblock_user_confirm(String username) {
    return '¿Estás seguro de que quieres desbloquear $username? Podrás recibir mensajes de ellos nuevamente.';
  }

  @override
  String user_unblocked(String username) {
    return '$username ha sido desbloqueado';
  }

  @override
  String user_blocked(String username) {
    return '$username ha sido bloqueado';
  }

  @override
  String get failed_to_unblock => 'No se pudo desbloquear al usuario';

  @override
  String get failed_to_block => 'No se pudo bloquear al usuario';

  @override
  String get chat_info => 'Información de chat';

  @override
  String get delete_message => 'Eliminar mensaje';

  @override
  String get delete_message_confirm =>
      '¿Estás seguro de que deseas eliminar este mensaje?';

  @override
  String get typing => 'mecanografía...';

  @override
  String get online => 'en línea';

  @override
  String get offline => 'desconectado';

  @override
  String last_seen_at(String time) {
    return 'visto por última vez $time';
  }

  @override
  String participants(int count) {
    return '$count participantes';
  }

  @override
  String get you_are_blocked => 'estas bloqueado';

  @override
  String user_blocked_you(String username) {
    return '$username te ha bloqueado. No puedes enviar mensajes.';
  }

  @override
  String you_blocked_user(String username) {
    return 'Has bloqueado a $username';
  }

  @override
  String get cannot_send_messages_blocked =>
      'No puedes enviar mensajes. Has sido bloqueado.';

  @override
  String get this_message_was_deleted => 'Este mensaje fue eliminado';

  @override
  String get edit => 'Editar';

  @override
  String get reply => 'Responder';

  @override
  String get add_reaction => 'Agregar reacción';

  @override
  String get editing_message => 'Editando mensaje';

  @override
  String replying_to(String username) {
    return 'Respondiendo a $username';
  }

  @override
  String get voice => 'Voz';

  @override
  String get emoji => 'emojis';

  @override
  String get photo => '📷 Foto';

  @override
  String get voice_message => '🎤 Mensaje de voz';

  @override
  String get searching => 'Búsqueda...';

  @override
  String get loading_users => 'Cargando usuarios...';

  @override
  String search_failed(String error) {
    return 'Búsqueda fallida: $error';
  }

  @override
  String get invalid_user_data => 'Datos de usuario no válidos';

  @override
  String failed_to_start_chat(String error) {
    return 'No se pudo iniciar el chat: $error';
  }

  @override
  String get audio_file_not_available => 'Archivo de audio no disponible';

  @override
  String failed_to_play_audio(String error) {
    return 'No se pudo reproducir el audio: $error';
  }

  @override
  String get image_unavailable => 'Imagen no disponible';

  @override
  String get image_too_large =>
      '❌ La imagen es demasiado grande. El tamaño máximo es 10 MB';

  @override
  String get image_file_not_found => '❌ Archivo de imagen no encontrado';

  @override
  String get uploading_image => 'Subiendo imagen...';

  @override
  String get image_sent => '✅Imagen enviada!';

  @override
  String get failed_to_send_image => '❌ No se pudo enviar la imagen';

  @override
  String get uploading_voice_message => 'Subiendo mensaje de voz...';

  @override
  String get voice_message_sent => '✅ ¡Mensaje de voz enviado!';

  @override
  String get failed_to_send_voice_message =>
      '❌ No se pudo enviar el mensaje de voz';

  @override
  String get recording => '🎙️ Grabación...';

  @override
  String get microphone_permission_denied => 'Permiso de micrófono denegado';

  @override
  String get starting_chat => 'Iniciando chat...';

  @override
  String get refresh_users => 'Actualizar usuarios';

  @override
  String get search_by_username_or_phone =>
      'Buscar por nombre de usuario o número de teléfono';

  @override
  String get no_users_found => 'No se encontraron usuarios';

  @override
  String get try_different_search_term =>
      'Pruebe con un término de búsqueda diferente';

  @override
  String get no_users_available => 'No hay usuarios disponibles';

  @override
  String get chat_exists => 'El chat existe';

  @override
  String block_user_confirm(String username) {
    return '¿Estás seguro de que quieres bloquear a $username? No recibirás mensajes de ellos y serán eliminados de tu lista de chat.';
  }

  @override
  String chat_room_label(String name) {
    return 'Sala de chat: $name';
  }

  @override
  String id_label(int id) {
    return 'Identificación: $id';
  }

  @override
  String get participants_label => 'Participantes:';

  @override
  String get type_a_message => 'Escribe un mensaje...';

  @override
  String get edit_message_hint => 'Editar mensaje...';

  @override
  String error_label(String error) {
    return 'Error: $error';
  }

  @override
  String get copy => 'Copiar';

  @override
  String comments_title(int count) {
    return 'Comentarios ($count)';
  }

  @override
  String get reply_button => 'Responder';

  @override
  String replies_count(int count) {
    return '$count responde';
  }

  @override
  String get you_label => 'Tú';

  @override
  String get delete_reply_title => 'Eliminar respuesta';

  @override
  String get delete_comment_title => 'Eliminar comentario';

  @override
  String get unknown_date => 'Fecha desconocida';

  @override
  String get press_enter_to_send => 'Pulsa Intro para enviar';

  @override
  String get comment_add_error => 'No se pudo agregar el comentario';

  @override
  String get service_provider => 'Proveedor de servicios';

  @override
  String get opening_chat => 'Abriendo chat...';

  @override
  String get failed_to_refresh => 'No se pudo actualizar';

  @override
  String get cannot_chat_with_yourself => 'No puedes chatear contigo mismo';

  @override
  String opening_chat_with(String username) {
    return 'Abriendo chat con $username...';
  }

  @override
  String get this_will_only_take_a_moment => 'Esto sólo tomará un momento';

  @override
  String get unable_to_start_chat =>
      'No se puede iniciar el chat. Por favor inténtalo de nuevo.';

  @override
  String get profile_listings => 'Listados';

  @override
  String get profile_followers => 'Seguidores';

  @override
  String get profile_following => 'Siguiente';

  @override
  String get profile_no_products => 'Sin productos';

  @override
  String get profile_no_services => 'Sin servicios';

  @override
  String get profile_no_properties => 'Sin propiedades';

  @override
  String get profile_user_no_products =>
      'Este usuario aún no ha publicado ningún producto.';

  @override
  String get profile_user_no_services =>
      'Este usuario aún no ha publicado ningún servicio.';

  @override
  String get profile_user_no_properties =>
      'Este usuario aún no ha publicado ninguna propiedad.';

  @override
  String get profile_error_occurred => 'Ocurrió un error';

  @override
  String get profile_error_loading_products => 'Error al cargar productos';

  @override
  String get profile_error_loading_services => 'Error al cargar servicios';

  @override
  String get profile_no_followers_yet => 'Aún no hay seguidores';

  @override
  String get profile_no_following_yet => 'No seguir a nadie todavía';

  @override
  String get profile_follow => 'Seguir';

  @override
  String get profile_following_btn => 'Siguiente';

  @override
  String get profile_message => 'Mensaje';

  @override
  String get profile_member_since => 'Miembro desde';

  @override
  String get profile_loading_error => 'Error al cargar el perfil';

  @override
  String get profile_retry => 'Intentar otra vez';

  @override
  String get profile_share => 'Compartir';

  @override
  String get profile_copy_link => 'Copiar enlace';

  @override
  String get profile_report => 'Informe';

  @override
  String get linkCopied => 'Enlace copiado al portapapeles';

  @override
  String get checkOutProfile => 'Verificar';

  @override
  String get onTezsell => 'en TezSell';

  @override
  String get selectCountryFirst => 'Seleccione el país primero';

  @override
  String get countrySelectionHint => 'Entonces puedes elegir tu región.';

  @override
  String get something_went_wrong => 'algo salió mal';

  @override
  String get check_connection_and_retry =>
      'Por favor verifique su conexión a Internet e inténtelo nuevamente.';

  @override
  String get sold_badge => 'VENDIDO';

  @override
  String get more_categories => 'Más';

  @override
  String no_products_in_location(String location) {
    return 'No se encontraron productos en $location';
  }

  @override
  String get no_more_products => 'No más productos para cargar';

  @override
  String time_days_ago(int count) {
    return 'Hace ${count}d';
  }

  @override
  String time_hours_ago(int count) {
    return 'Hace ${count}h';
  }

  @override
  String time_minutes_ago(int count) {
    return 'Hace ${count}m';
  }

  @override
  String get time_just_now => 'En este momento';

  @override
  String no_services_in_location(String location) {
    return 'No se encontraron servicios en $location';
  }

  @override
  String get no_more_services => 'No más servicios para cargar';

  @override
  String get error_loading_more_services => 'Error al cargar más servicios';

  @override
  String get verification_code_length =>
      'El código de verificación debe tener 6 dígitos.';

  @override
  String get map_register_title => '¿Dónde vive?';

  @override
  String get map_register_headline => 'Elige tu barrio en el mapa';

  @override
  String get map_register_subtitle =>
      'Lo usamos para mostrarle compradores y vendedores cercanos. Puedes ajustar tu radio más tarde.';

  @override
  String get pick_on_map => 'Elegir en el mapa';

  @override
  String get pick_again => 'Escoger de nuevo';

  @override
  String get resolving_location => 'Resolviendo ubicación…';

  @override
  String get use_dropdown_instead => 'Utilice el menú desplegable en su lugar';

  @override
  String country_not_supported(String country) {
    return 'Aún no admitimos $country.';
  }

  @override
  String get region_not_auto_detected =>
      'No se pudo detectar automáticamente tu región; selecciónala manualmente.';

  @override
  String get district_not_auto_detected =>
      'No se pudo detectar automáticamente su distrito; selecciónelo manualmente.';

  @override
  String get browse_no_items_with_location =>
      'Aún no hay elementos con datos de ubicación en esta área.';

  @override
  String get location_picker_title => 'Establecer ubicación';

  @override
  String get location_picker_confirm => 'Confirmar ubicación';

  @override
  String get location_picker_resolve_failed =>
      'No se pudo resolver la dirección: elija nuevamente o confirme solo con coordenadas';

  @override
  String get location_picker_selected_fallback => 'Ubicación seleccionada';

  @override
  String get location_permission_denied => 'Permiso de ubicación denegado';

  @override
  String get location_permission_denied_settings =>
      'Permiso de ubicación denegado: habilítelo en Configuración';

  @override
  String get location_permission_permanent =>
      'Ubicación denegada permanentemente: abre Configuración para habilitarla';

  @override
  String gps_error(String error) {
    return 'Error de GPS: $error';
  }

  @override
  String get verify_neighborhood_title => 'Verifica tu vecindario';

  @override
  String get verify_neighborhood_subtitle =>
      'Párate en tu vecindario. Comprobaremos tu GPS y te pediremos que confirmes.';

  @override
  String get verify_neighborhood_button => 'Verificar vecindario';

  @override
  String get verify_neighborhood_low_confidence =>
      'Continuar con poca confianza';

  @override
  String get verify_neighborhood_retry => 'Rever';

  @override
  String get verify_neighborhood_youre_in => 'Estás en:';

  @override
  String verify_neighborhood_done(String name) {
    return '¡Verificado! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'La precisión del GPS es ${meters}m (necesita ≤100 m). Vaya a un área abierta e inténtelo de nuevo.';
  }

  @override
  String get neighborhood_not_identified =>
      'No se pudo identificar el vecindario para su ubicación.';

  @override
  String get unknown_error => 'Error desconocido';

  @override
  String get place_search_hint => 'Buscar una dirección o lugar';

  @override
  String get place_search_unavailable =>
      'La búsqueda no está disponible; en su lugar, coloca un marcador';

  @override
  String get radius_slider_city => 'Ciudad';

  @override
  String radius_slider_km(String value) {
    return '$value kilómetros';
  }

  @override
  String get my_neighborhoods => 'Mis barrios';

  @override
  String get manage_on_map => 'Gestionar en mapa';

  @override
  String get no_neighborhoods_yet =>
      'Aún no hay barrios verificados. Abre el mapa para verificar dónde estás.';

  @override
  String get open_map_to_verify => 'Abrir mapa para verificar nueva ubicación';

  @override
  String get verify_here => 'Verificar aquí';

  @override
  String get verify_new_location => 'Verificar nueva ubicación';

  @override
  String eviction_warning(String name) {
    return 'Agregar esta ubicación eliminará $name (el más antiguo). Esto no se puede deshacer.';
  }

  @override
  String get verified_today => 'Verificado hoy';

  @override
  String get verified_yesterday => 'Verificado ayer';

  @override
  String verified_n_days_ago(int days) {
    return 'Verificado hace $days días';
  }

  @override
  String get active_neighborhood => 'Activo';

  @override
  String switch_neighborhood_success(String name) {
    return 'Cambiado a $name';
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
}
