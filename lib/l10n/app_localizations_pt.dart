// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get sessionExpired =>
      'Sua sessão expirou. Por favor, faça login novamente.';

  @override
  String get welcome => 'Bem-vindo';

  @override
  String get welcomeBack => 'Bem vindo de volta!';

  @override
  String get loginToYourAccount => 'Faça login para continuar';

  @override
  String get or => 'OU';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get chooseLanguage => 'Escolha seu idioma';

  @override
  String get selectPreferredLanguage =>
      'Selecione seu idioma preferido para o aplicativo';

  @override
  String get continueButton => 'Continuar';

  @override
  String get continueWithGoogle => 'Continuar com o Google';

  @override
  String get continueWithApple => 'Continuar com a Apple';

  @override
  String get continueWithEmail => 'Continuar com e-mail';

  @override
  String get sellAndBuyProducts =>
      'Venda e compre qualquer um dos seus produtos somente conosco';

  @override
  String get usedProductsMarket =>
      'Produtos usados ​​ou mercado de segunda mão';

  @override
  String get home_welcome_title => 'O mercado do seu bairro';

  @override
  String get home_welcome_subtitle =>
      'Compre e venda com pessoas próximas.\nSeguro, simples e local.';

  @override
  String get home_get_started => 'Comece';

  @override
  String get home_sign_in => 'Eu já tenho uma conta';

  @override
  String get home_terms_notice =>
      'Ao continuar, você concorda com nossos Termos de Serviço e Política de Privacidade';

  @override
  String get register => 'Cadastre-se';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta';

  @override
  String get login => 'Conecte-se';

  @override
  String get loginToAccount => 'Faça login na conta';

  @override
  String get enterPhoneNumber => 'Digite o número de telefone';

  @override
  String get password => 'Senha';

  @override
  String get enterPassword => 'Digite a senha';

  @override
  String get forgotPassword => 'Esqueceu sua senha?';

  @override
  String get registerNow => 'Cadastre-se agora';

  @override
  String get loading => 'Carregando...';

  @override
  String get pleaseEnterPhoneNumber =>
      'Por favor insira seu número de telefone';

  @override
  String get pleaseEnterPassword => 'Por favor digite sua senha';

  @override
  String get unexpectedError =>
      'Ocorreu um erro inesperado. Por favor, tente novamente.';

  @override
  String get forgotPasswordComingSoon => 'Esqueci o recurso de senha em breve';

  @override
  String get selectedCountryLabel => 'Selecionado:';

  @override
  String get fullPhoneLabel => 'Completo:';

  @override
  String get home => 'Lar';

  @override
  String get settings => 'Configurações';

  @override
  String get profile => 'Perfil';

  @override
  String get search => 'Procurar';

  @override
  String get notifications => 'Notificações';

  @override
  String get error => 'Erro';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Por favor selecione sua região';

  @override
  String get searchHint => 'Pesquise distrito ou cidade';

  @override
  String get apiError => 'Ocorreu um problema ao chamar a API';

  @override
  String get ok => 'OK';

  @override
  String get emptyList => 'Lista vazia';

  @override
  String get dataLoadingError => 'Ocorre um erro ao carregar os dados';

  @override
  String get confirm => 'Confirmar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String confirmRegionSelection(Object regionName) {
    return 'Deseja selecionar a região $regionName?';
  }

  @override
  String get selectDistrictOrCity => 'Selecione seu bairro ou cidade';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return 'Deseja selecionar a região $regionName - $districtName?';
  }

  @override
  String get noResultsFound => 'Nenhum resultado encontrado.';

  @override
  String errorWithCode(String errorCode) {
    return 'Erro: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'Falha ao carregar dados. Erro: $error';
  }

  @override
  String get phoneVerification => 'Verificação de número de telefone';

  @override
  String get enterPhonePrompt => 'Por favor insira seu número de telefone';

  @override
  String get enterPhoneNumberHint => 'Digite o número de telefone';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Selecionado: $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'Selecione seu país';

  @override
  String get changeCountry => 'Alterar país';

  @override
  String get country => 'País';

  @override
  String get allCountries => 'Todos os países';

  @override
  String get currencyRUB => 'Rublo Russo';

  @override
  String get currencyUAH => 'Hryvnia ucraniana';

  @override
  String get currencyBYN => 'Rublo Bielorrusso';

  @override
  String get currencyMDL => 'Leu da Moldávia';

  @override
  String get currencyGEL => 'Lari georgiano';

  @override
  String get currencyAMD => 'Dram Armênio';

  @override
  String get currencyAZN => 'Manat do Azerbaijão';

  @override
  String get currencyKZT => 'Tenge do Cazaquistão';

  @override
  String get currencyTMT => 'Manat turcomano';

  @override
  String get currencyKGS => 'Som do Quirguistão';

  @override
  String get currencyTJS => 'Somoni tadjique';

  @override
  String get currencyUZS => 'Som uzbeque';

  @override
  String get currencyUSD => 'Dólar americano';

  @override
  String get currencyEUR => 'Euro';

  @override
  String fullNumber(String phoneNumber) {
    return 'Número completo: $phoneNumber';
  }

  @override
  String get sendCode => 'Enviar código';

  @override
  String get enterVerificationCode => 'Insira o código de verificação';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String expires(String time) {
    return 'Expira em: $time';
  }

  @override
  String get verifyAndContinue => 'Verifique e continue';

  @override
  String get invalidVerificationCode => 'Código de verificação inválido';

  @override
  String get verificationCodeSent =>
      'Código de verificação enviado com sucesso';

  @override
  String get failedToSendCode => 'Falha ao enviar o código de verificação';

  @override
  String get verificationCodeResent =>
      'Código de verificação reenviado com sucesso';

  @override
  String get failedToResendCode => 'Falha ao reenviar o código de verificação';

  @override
  String get passwordVerification => 'Verificação de senha';

  @override
  String get completeRegistrationPrompt =>
      'Digite nome de usuário e senha para concluir o registro';

  @override
  String get username => 'Nome de usuário';

  @override
  String get username_required => 'O nome de usuário é obrigatório';

  @override
  String get username_min_length =>
      'O nome de usuário deve ter pelo menos 2 caracteres';

  @override
  String get usernameHint => 'Nome de usuário123';

  @override
  String get confirmPassword => 'Confirme sua senha';

  @override
  String get profileImage => 'Imagem do perfil';

  @override
  String get imageInstructions =>
      'As imagens aparecerão aqui, por favor pressione a imagem do perfil';

  @override
  String get finish => 'Terminar';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get registrationError => 'Erro de registro';

  @override
  String get about => 'Sobre nós';

  @override
  String get chat => 'Bater papo';

  @override
  String get realEstate => 'Imobiliária';

  @override
  String get language => 'POR';

  @override
  String get languageEn => 'Inglês';

  @override
  String get languageRu => 'russo';

  @override
  String get languageUz => 'Usbeque';

  @override
  String get serviceLiked => 'Serviço apreciado';

  @override
  String get support => 'Apoiar';

  @override
  String get service => 'Serviços Empresariais';

  @override
  String get aboutContent =>
      'TezSell é um mercado rápido e fácil para compra e venda de produtos novos e usados. Nossa missão é criar a plataforma mais conveniente e eficiente para cada usuário, garantindo transações tranquilas e uma experiência amigável. Esteja você querendo vender ou comprar, o TezSell facilita a conexão e a conclusão de transações em apenas algumas etapas.Priorizamos a segurança e a privacidade de nossos usuários. Todas as transações são monitoradas cuidadosamente para garantir segurança e conformidade, proporcionando tranquilidade tanto aos compradores quanto aos vendedores. Nossa interface simples e intuitiva permite aos usuários listar produtos rapidamente e encontrar o que precisam. Também facilitamos a comunicação em tempo real através do Telegram, tornando o processo de compra e venda ainda mais tranquilo.';

  @override
  String get errorMessage => 'Ocorreu um erro, verifique o servidor';

  @override
  String get searchLocation => 'Localização';

  @override
  String get searchCategory => 'Categorias';

  @override
  String get searchProductPlaceholder => 'Pesquisar produtos';

  @override
  String get searchServicePlaceholder => 'Procure por serviços';

  @override
  String get search_products_subtitle =>
      'Encontre ótimas ofertas no seu bairro';

  @override
  String get search_services_subtitle => 'Encontre profissionais no seu bairro';

  @override
  String get search_products_error => 'Erro ao pesquisar produtos';

  @override
  String get search_services_error => 'Erro ao pesquisar serviços';

  @override
  String get load_more_products_error => 'Erro ao carregar mais produtos';

  @override
  String get load_more_services_error => 'Erro ao carregar mais serviços';

  @override
  String get try_different_keywords => 'Experimente palavras-chave diferentes';

  @override
  String get searchText => 'Procurar';

  @override
  String get selectedCategory => 'Categoria selecionada:';

  @override
  String get selectedLocation => 'Local selecionado:';

  @override
  String get productError => 'Nenhum produto disponível';

  @override
  String get serviceError => 'Nenhum serviço disponível';

  @override
  String get locationHeader => 'Selecione um local';

  @override
  String get locationPlaceholder => 'Pesquise região aqui';

  @override
  String get categoryHeader => 'Selecione uma categoria';

  @override
  String get categoryPlaceholder => 'Categorias de pesquisa';

  @override
  String get categoryError => 'Nenhuma categoria disponível';

  @override
  String get paginationFirst => 'Primeiro';

  @override
  String get paginationPrevious => 'Anterior';

  @override
  String get pageInfo => 'Página de';

  @override
  String get pageNext => 'Próximo';

  @override
  String get pageLast => 'Durar';

  @override
  String get loadingMessageProduct => 'Carregando produtos...';

  @override
  String get loadingMessageError => 'Erro ao carregar';

  @override
  String get likeProductError => 'Ocorreu um erro ao gostar do produto';

  @override
  String get dislikeProductError => 'Ocorreu um erro ao não gostar do produto';

  @override
  String get loadingMessageLocation => 'Carregando local...';

  @override
  String get loadingLocationError => 'Erro ao carregar localização';

  @override
  String get loadingMessageCategory => 'Carregando categorias...';

  @override
  String get loadingCategoryError => 'Erro ao carregar categorias:';

  @override
  String get profileUpdateSuccessMessage => 'Perfil atualizado com sucesso';

  @override
  String get profileUpdateFailMessage => 'Falha ao atualizar o perfil';

  @override
  String get seeMoreBtn => 'Ver mais';

  @override
  String get profilePageTitle => 'Página de perfil';

  @override
  String get editProfileModalTitle => 'Editar perfil';

  @override
  String get usernameLabel => 'Nome de usuário';

  @override
  String get locationLabel => 'Localização atual';

  @override
  String get profileImageLabel => 'Imagem do perfil';

  @override
  String get chooseFileLabel => 'Escolha um arquivo';

  @override
  String get uploadBtnLabel => 'Atualizar';

  @override
  String get uploadingBtnLabel => 'Atualizando...';

  @override
  String get cancelBtnLabel => 'Cancelar';

  @override
  String get productsTitle => 'Produtos';

  @override
  String get servicesTitle => 'Serviços';

  @override
  String get myProductsTitle => 'Meus produtos';

  @override
  String get myServicesTitle => 'Meus serviços';

  @override
  String get favoriteProductsTitle => 'Produtos favoritos';

  @override
  String get favoriteServicesTitle => 'Serviços favoritos';

  @override
  String get noFavorites => 'Sem favoritos';

  @override
  String get addNewProductBtn => 'Adicionar novo produto';

  @override
  String get addNew => 'Novo';

  @override
  String get addNewServiceBtn => 'Adicionar novo serviço';

  @override
  String get downloadMobileApp => 'Baixe o aplicativo móvel';

  @override
  String get registerPhoneNumberSuccess =>
      'Número de telefone verificado! Você pode prosseguir para a próxima etapa.';

  @override
  String get regionSelectedMessage => 'Região selecionada:';

  @override
  String get districtSelectMessage => 'Distrito selecionado:';

  @override
  String get phoneNumberEmptyMessage =>
      'Verifique seu número de telefone antes de continuar';

  @override
  String get regionEmptyMessage => 'Selecione a região primeiro';

  @override
  String get districtEmptyMessage => 'Selecione o distrito';

  @override
  String get usernamePasswordEmptyMessage =>
      'Por favor insira nome de usuário e senha';

  @override
  String get registerTitle => 'Cadastre-se';

  @override
  String get previousButton => 'Anterior';

  @override
  String get nextButton => 'Próximo';

  @override
  String get completeButton => 'Completo';

  @override
  String stepIndicator(int currentStep) {
    return 'Etapa $currentStep de 4';
  }

  @override
  String get districtSelectTitle => 'Lista Distrital';

  @override
  String get districtSelectParagraph => 'Selecione um distrito:';

  @override
  String get phoneNumber => 'Número de telefone';

  @override
  String get sendOtp => 'Enviar OTP';

  @override
  String get sendAgain => 'Enviar novamente';

  @override
  String get verify => 'Verificar';

  @override
  String get failedToSendOtp =>
      'Falha ao enviar OTP. O servidor retornou falso.';

  @override
  String get errorSendingOtp => 'Ocorreu um erro ao enviar OTP.';

  @override
  String get invalidPhoneNumber => 'Insira um número de telefone válido.';

  @override
  String get verificationSuccess => 'Verificado com sucesso';

  @override
  String get verificationError =>
      'Ocorreu um erro. Por favor, tente novamente mais tarde.';

  @override
  String get regionsList => 'Lista de regiões';

  @override
  String get enterUsername => 'Digite seu nome de usuário';

  @override
  String get welcomeMessage =>
      'Bem-vindo ao Tezsell, faça login com seu número de telefone';

  @override
  String get noAccount => 'Ainda não tem conta? Cadastre-se aqui';

  @override
  String get successLogin => 'Registrado com sucesso';

  @override
  String get myProfile => 'Meu perfil';

  @override
  String get logout => 'sair';

  @override
  String get newProductTitle => 'Título';

  @override
  String get newProductDescription => 'Descrição';

  @override
  String get newProductPrice => 'Preço';

  @override
  String get newProductCondition => 'Doença';

  @override
  String get newProductCategory => 'Categoria';

  @override
  String get newProductImages => 'Imagens';

  @override
  String get addNewService => 'Adicionar novo serviço';

  @override
  String get creating => 'Criando...';

  @override
  String get serviceName => 'Nome do serviço';

  @override
  String get serviceNamePlaceholder => 'Insira o título do serviço';

  @override
  String get serviceDescription => 'Descrição do serviço';

  @override
  String get serviceDescriptionPlaceholder => 'Insira a descrição do serviço';

  @override
  String get serviceCategory => 'Categoria de serviço';

  @override
  String get selectCategory => 'Selecione a categoria';

  @override
  String get loadingCategories => 'Carregando...';

  @override
  String get errorLoadingCategories => 'Erro ao carregar categorias';

  @override
  String get serviceImages => 'Imagens de serviço';

  @override
  String get imageUploadHelper =>
      'Clique no ícone + para adicionar imagens (máximo 10)';

  @override
  String get maxImagesError => 'Você pode enviar no máximo 10 imagens';

  @override
  String get categoryNotFound => 'Categoria não encontrada';

  @override
  String get productCreatedSuccess => 'Produto criado com sucesso';

  @override
  String get productLikeSuccess => 'Produto curtido com sucesso';

  @override
  String get productDislikeSuccess => 'Produto não apreciado com sucesso';

  @override
  String get errorCreatingService => 'Erro ao criar serviço';

  @override
  String get errorCreatingProduct => 'Erro ao criar produto';

  @override
  String get unknownError => 'Ocorreu um erro desconhecido ao criar o serviço';

  @override
  String get submit => 'Enviar';

  @override
  String get selectCategoryAction => 'Selecione a categoria';

  @override
  String get selectCondition => 'Selecione a condição';

  @override
  String get sum => 'Soma';

  @override
  String get noComments =>
      'Nenhum comentário ainda. Seja o primeiro a comentar!';

  @override
  String get commentLikeSuccess => 'Comentário curtido com sucesso';

  @override
  String get commentLikeError => 'Erro ao curtir o comentário';

  @override
  String get unknownErrorMessage => 'Ocorreu um erro desconhecido';

  @override
  String get commentDislikeSuccess => 'Comentário não curtido com sucesso';

  @override
  String get commentDislikeError => 'Erro ao não gostar do comentário';

  @override
  String get replyInfo => 'Por favor, digite uma resposta primeiro';

  @override
  String get replySuccessMessage => 'Resposta adicionada com sucesso';

  @override
  String get replyErrorMessage =>
      'Ocorreu um erro durante a criação da resposta';

  @override
  String get commentUpdateSuccess => 'Comentário atualizado com sucesso';

  @override
  String get commentUpdateError => 'Erro ao atualizar o item de comentário';

  @override
  String get deleteConfirmationMessage =>
      'Tem certeza de que deseja excluir este comentário?';

  @override
  String get commentDeleteSuccess => 'Comentário excluído com sucesso';

  @override
  String get commentDeleteError => 'Erro ao excluir comentário';

  @override
  String get editLabel => 'Editar';

  @override
  String get deleteLabel => 'Excluir';

  @override
  String get saveLabel => 'Salvar';

  @override
  String get replyLabel => 'Responder';

  @override
  String get replyTitle => 'respostas';

  @override
  String get replyPlaceholder => 'Escreva uma resposta...';

  @override
  String get chatLoginMessage =>
      'Você deve estar logado para iniciar um bate-papo';

  @override
  String get chatYourselfMessage => 'Você não pode conversar consigo mesmo.';

  @override
  String get chatRoomMessage => 'Sala de bate-papo criada!';

  @override
  String get chatRoomError => 'Falha ao criar bate-papo!';

  @override
  String get chatCreationError => 'Falha na criação do bate-papo!';

  @override
  String get productsTotal => 'Total de produtos';

  @override
  String get perPage => 'Unid';

  @override
  String get clearAllFilters => 'Limpar todos os filtros';

  @override
  String get clickToUpload => 'Clique para carregar';

  @override
  String get productInStock => 'Em estoque';

  @override
  String get productOutStock => 'Fora de estoque';

  @override
  String get productBack => 'Voltar aos produtos';

  @override
  String get messageSeller => 'Bater papo';

  @override
  String get recommendedProducts => 'Produtos recomendados';

  @override
  String get deleteConfirmationProduct =>
      'Tem certeza de que deseja excluir este produto?';

  @override
  String get productDeleteSuccess => 'Produto excluído com sucesso';

  @override
  String get productDeleteError => 'Erro ao excluir produto';

  @override
  String get newCondition => 'Novo';

  @override
  String get used => 'Usado';

  @override
  String get imageValidType =>
      'Alguns arquivos não foram adicionados. Use arquivos JPG, PNG, GIF ou WebP com menos de 5 MB.';

  @override
  String get imageConfirmMessage =>
      'Tem certeza de que deseja remover esta imagem?';

  @override
  String get titleRequiredMessage => 'O título é obrigatório';

  @override
  String get descRequiredMessage => 'A descrição é obrigatória';

  @override
  String get priceRequiredMessage => 'O preço é obrigatório';

  @override
  String get conditionRequiredMessage => 'A condição é obrigatória';

  @override
  String get pleaseFillAllRequired =>
      'Por favor preencha os campos obrigatórios';

  @override
  String get oneImageConfirmMessage =>
      'É necessária pelo menos uma imagem do produto';

  @override
  String get categoryRequiredMessage => 'A categoria é obrigatória';

  @override
  String get locationInfoError =>
      'Faltam informações de localização do usuário';

  @override
  String get editProductTitle => 'Editar produto';

  @override
  String get imageUploadRequirements =>
      'É necessária pelo menos uma imagem. Você pode fazer upload de até 10 imagens (JPG, PNG, GIF, WebP com menos de 5 MB cada).';

  @override
  String get productUpdatedSuccess => 'Produto atualizado com sucesso';

  @override
  String get productUpdateFailed => 'Falha na atualização do produto';

  @override
  String get errorUpdatingProduct => 'Ocorreu um erro ao atualizar o produto';

  @override
  String get serviceBack => 'Voltar aos serviços';

  @override
  String get likeLabel => 'Como';

  @override
  String get commentsLabel => 'Comentários';

  @override
  String get writeComment => 'Escreva um comentário ...';

  @override
  String get postingLabel => 'Postando...';

  @override
  String get commentCreated => 'Comentário criado';

  @override
  String get postCommentLabel => 'Postar comentário';

  @override
  String get loginPrompt => 'Faça login para visualizar e postar comentários.';

  @override
  String get recommendedServices => 'Serviços recomendados';

  @override
  String get commentsVisibilityNotice =>
      'Os comentários são visíveis apenas para usuários logados.';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get serviceUpdateSuccess => 'Serviço atualizado com sucesso';

  @override
  String get serviceUpdateError => 'Erro ao atualizar o item de serviço';

  @override
  String get editServiceModalTitle => 'Editar serviço';

  @override
  String get enterPhoneNumberWithoutCode =>
      'Digite o número de telefone sem código';

  @override
  String get heroTitle => 'TezVender';

  @override
  String get heroSubtitle => 'Seu mercado rápido e fácil para o Uzbequistão';

  @override
  String get startSelling => 'Comece a vender';

  @override
  String get browseProducts => 'Navegar pelos produtos';

  @override
  String get featuresTitle => 'Por que escolher a TezSell?';

  @override
  String get listingTitle => 'Lista de produtos simples';

  @override
  String get listingDescription =>
      'Liste seus itens com apenas alguns cliques. Adicione fotos, defina seu preço e conecte-se com os compradores instantaneamente.';

  @override
  String get locationTitle => 'Navegação baseada em localização';

  @override
  String get locationDescription =>
      'Encontre ofertas perto de você. Nosso sistema baseado em localização ajuda você a descobrir itens em sua vizinhança.';

  @override
  String get location_subtitle =>
      'Escolha sua região e distrito para ver listagens próximas';

  @override
  String get categoryTitle => 'Filtragem de categoria';

  @override
  String get categoryDescription =>
      'Navegue facilmente por diferentes categorias para encontrar exatamente o que procura.';

  @override
  String get inspirationTitle => 'Inspirado no mercado de cenoura da Coreia';

  @override
  String get inspirationDescription1 =>
      'Construímos o TezSell inspirados no bem-sucedido Mercado de Cenoura da Coreia (당근마켓), mas o adaptamos especificamente para atender às necessidades exclusivas das comunidades locais do Uzbequistão.';

  @override
  String get inspirationDescription2 =>
      'Nossa missão é criar uma plataforma confiável onde os vizinhos possam comprar, vender e se conectar facilmente.';

  @override
  String get comingSoonTitle => 'Em breve no TezSell';

  @override
  String get inAppChat => 'Bate-papo no aplicativo';

  @override
  String get secureTransactions => 'Transações seguras';

  @override
  String get realEstateListings => 'Listagens de imóveis';

  @override
  String get stayUpdated => 'Fique atualizado';

  @override
  String get comingSoonBadge => 'Em breve';

  @override
  String get ctaTitle => 'Junte-se à comunidade TezSell hoje!';

  @override
  String get ctaDescription =>
      'Faça parte da construção de uma melhor experiência de mercado para o Uzbequistão. Compartilhe seu feedback e ajude-nos a crescer!';

  @override
  String get createAccount => 'Criar uma conta';

  @override
  String get learnMore => 'Saber mais';

  @override
  String get replyUpdateSuccess => 'Resposta atualizada com sucesso';

  @override
  String get replyUpdateError => 'Falha ao atualizar a resposta';

  @override
  String get replyDeleteSuccess => 'Resposta excluída com sucesso';

  @override
  String get replyDeleteError => 'Falha ao excluir resposta';

  @override
  String get replyDeleteConfirmation =>
      'Tem certeza de que deseja excluir esta resposta?';

  @override
  String get authenticationRequired => 'Autenticação necessária';

  @override
  String get enterValidReply => 'Insira um texto de resposta válido';

  @override
  String get saving => 'Salvando...';

  @override
  String get deleting => 'Excluindo...';

  @override
  String get properties => 'Propriedades';

  @override
  String get agents => 'Agentes';

  @override
  String get becomeAgent => 'Torne-se um agente';

  @override
  String get main => 'Principal';

  @override
  String get upload => 'Carregar';

  @override
  String get filtered_products => 'Produtos Filtrados';

  @override
  String get filtered_services => 'Serviços filtrados';

  @override
  String get productDetail => 'Detalhes do produto';

  @override
  String get unknownUser => 'Usuário desconhecido';

  @override
  String get locationNotAvailable => 'Local não disponível';

  @override
  String get noTitle => 'Sem título';

  @override
  String get noCategory => 'Nenhuma categoria';

  @override
  String get noDescription => 'Sem descrição';

  @override
  String get som => 'Som';

  @override
  String get about_me => 'Sobre mim';

  @override
  String get my_name => 'O meu nome';

  @override
  String get customer_support => 'Suporte ao Cliente';

  @override
  String get customer_center => 'Central do Cliente';

  @override
  String get customer_inquiries => 'Consultas';

  @override
  String get customer_terms => 'Termos e Condições';

  @override
  String get region => 'Região';

  @override
  String get district => 'Distrito';

  @override
  String get tap_change_profile => 'Toque para alterar a foto';

  @override
  String get language_settings => 'Configurações de idioma';

  @override
  String get selectLanguage => 'Selecione um idioma';

  @override
  String get select_theme => 'Selecione o tema';

  @override
  String get theme => 'Tema';

  @override
  String get location_settings => 'Configurações de localização';

  @override
  String get security => 'Segurança';

  @override
  String get data_storage => 'Dados e armazenamento';

  @override
  String get accessibility => 'Acessibilidade';

  @override
  String get privacy => 'Privacidade';

  @override
  String get light_theme => 'Luz';

  @override
  String get dark_theme => 'Escuro';

  @override
  String get system_theme => 'Padrão do sistema';

  @override
  String get my_products => 'Meus produtos';

  @override
  String get refresh => 'Atualizar';

  @override
  String get delete_product => 'Excluir produto';

  @override
  String get delete_confirmation =>
      'Tem certeza de que deseja excluir este produto?';

  @override
  String get delete => 'Excluir';

  @override
  String error_loading_products(String error) {
    return 'Erro ao carregar produtos: $error';
  }

  @override
  String get product_deleted_success => 'Produto excluído com sucesso';

  @override
  String error_deleting_product(String error) {
    return 'Erro ao excluir produto: $error';
  }

  @override
  String get no_products_found => 'Nenhum produto encontrado';

  @override
  String get add_first_product => 'Comece adicionando seu primeiro produto';

  @override
  String get no_title => 'Sem título';

  @override
  String get no_description => 'Sem descrição';

  @override
  String get in_stock => 'Em estoque';

  @override
  String get out_of_stock => 'Fora de estoque';

  @override
  String get new_condition => 'NOVO';

  @override
  String get edit_product => 'Editar produto';

  @override
  String get delete_product_tooltip => 'Excluir produto';

  @override
  String get sum_currency => 'Soma';

  @override
  String get edit_product_title => 'Editar produto';

  @override
  String get product_name => 'Nome do produto';

  @override
  String get product_description => 'Descrição do produto';

  @override
  String get price => 'Preço';

  @override
  String get condition => 'Doença';

  @override
  String get condition_new => 'Novo';

  @override
  String get condition_like_new => 'Seminovo';

  @override
  String get condition_used => 'Usado';

  @override
  String get condition_refurbished => 'Remodelado';

  @override
  String get currency => 'Moeda';

  @override
  String get category => 'Categoria';

  @override
  String get images => 'Imagens';

  @override
  String get existing_images => 'Imagens Existentes';

  @override
  String get new_images => 'Novas imagens';

  @override
  String get image_instructions =>
      'As imagens aparecerão aqui. Por favor, pressione o ícone de upload acima.';

  @override
  String get update_button => 'Atualizar';

  @override
  String loading_category_error(String error) {
    return 'Erro ao carregar categorias: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Erro ao escolher imagens: $error';
  }

  @override
  String get please_fill_all_required => 'Por favor preencha todos os campos';

  @override
  String get invalid_price_message =>
      'Preço inválido inserido. Por favor insira um número válido.';

  @override
  String get category_required_message => 'Selecione uma categoria válida.';

  @override
  String get one_image_required_message =>
      'É necessária pelo menos uma imagem do produto';

  @override
  String get product_updated_success => 'Produto atualizado com sucesso';

  @override
  String error_updating_product(String error) {
    return 'Erro ao atualizar o produto: $error';
  }

  @override
  String get my_services => 'Meus serviços';

  @override
  String get delete_service => 'Excluir serviço';

  @override
  String get delete_service_confirmation =>
      'Tem certeza de que deseja excluir este serviço?';

  @override
  String get no_services_found => 'Nenhum serviço encontrado';

  @override
  String get add_first_service => 'Comece adicionando seu primeiro serviço';

  @override
  String get edit_service => 'Editar serviço';

  @override
  String get delete_service_tooltip => 'Excluir serviço';

  @override
  String get service_deleted_successfully => 'Serviço excluído com sucesso';

  @override
  String get error_deleting_service => 'Erro ao excluir serviço';

  @override
  String get error_loading_services => 'Erro ao carregar serviços';

  @override
  String get service_name => 'Nome do serviço';

  @override
  String get enter_service_name => 'Digite o nome do serviço';

  @override
  String get service_name_required => 'O nome do serviço é obrigatório';

  @override
  String get service_name_min_length =>
      'O nome do serviço deve ter pelo menos três caracteres';

  @override
  String get enter_service_description => 'Insira a descrição do serviço';

  @override
  String get service_description_required =>
      'A descrição do serviço é obrigatória';

  @override
  String get service_description_min_length =>
      'A descrição deve ter pelo menos 10 caracteres';

  @override
  String get category_required => 'Selecione uma categoria';

  @override
  String get no_categories_available => 'Nenhuma categoria disponível';

  @override
  String get location => 'Localização';

  @override
  String get select_location => 'Selecione o local';

  @override
  String get location_required => 'Selecione um local';

  @override
  String get no_locations_available => 'Nenhum local disponível';

  @override
  String get add_images => 'Adicionar imagens';

  @override
  String get current_images => 'Imagens atuais';

  @override
  String get no_images_selected => 'Nenhuma imagem selecionada';

  @override
  String get save_changes => 'Salvar alterações';

  @override
  String get map_main => 'Mapa e propriedades';

  @override
  String get agent_status => 'Status do agente';

  @override
  String get admin_panel => 'Painel de administração';

  @override
  String get propertiesFound => 'Propriedades encontradas';

  @override
  String get propertiesSaved => 'propriedades salvas';

  @override
  String get saved => 'salvo';

  @override
  String get loadingProperties => 'Carregando propriedades...';

  @override
  String get failedToLoad =>
      'Falha ao carregar propriedades. Por favor, tente novamente.';

  @override
  String get noPropertiesFound => 'Nenhuma propriedade encontrada';

  @override
  String get tryAdjusting => 'Tente ajustar seus critérios de pesquisa';

  @override
  String get search_placeholder => 'Pesquise por título ou localização...';

  @override
  String get search_filters => 'Filtros';

  @override
  String get search_button => 'Procurar';

  @override
  String get search_clear_filters => 'Limpar filtros';

  @override
  String get filter_options_sale_and_rent => 'Venda e aluguel';

  @override
  String get filter_options_for_sale => 'À venda';

  @override
  String get filter_options_for_rent => 'Para alugar';

  @override
  String get filter_options_all_types => 'Todos os tipos';

  @override
  String get filter_options_apartment => 'Apartamento';

  @override
  String get filter_options_house => 'Casa';

  @override
  String get filter_options_townhouse => 'Moradia';

  @override
  String get filter_options_villa => 'Vila';

  @override
  String get filter_options_commercial => 'Comercial';

  @override
  String get filter_options_office => 'Escritório';

  @override
  String get property_card_featured => 'Apresentou';

  @override
  String get property_card_bed => 'quarto';

  @override
  String get property_card_bath => 'banheiro';

  @override
  String get property_card_parking => 'estacionamento';

  @override
  String get property_card_view_details => 'Ver detalhes';

  @override
  String get property_card_contact => 'Contato';

  @override
  String get property_card_balcony => 'Sacada';

  @override
  String get property_card_garage => 'Garagem';

  @override
  String get property_card_garden => 'Jardim';

  @override
  String get property_card_pool => 'Piscina';

  @override
  String get property_card_elevator => 'Elevador';

  @override
  String get property_card_furnished => 'Mobilado';

  @override
  String get property_card_sales => 'vendas';

  @override
  String get pricing_month => '/mês';

  @override
  String get results_properties_found => 'Propriedades encontradas';

  @override
  String get results_properties_saved => 'propriedades salvas';

  @override
  String get results_saved => 'salvo';

  @override
  String get results_loading_properties => 'Carregando propriedades...';

  @override
  String get results_failed_to_load =>
      'Falha ao carregar propriedades. Por favor, tente novamente.';

  @override
  String get results_no_properties_found => 'Nenhuma propriedade encontrada';

  @override
  String get results_try_adjusting =>
      'Tente ajustar seus critérios de pesquisa';

  @override
  String get no_properties_found => 'Nenhuma propriedade encontrada';

  @override
  String get no_category_properties => 'Não há propriedades nesta categoria';

  @override
  String get properties_loading => 'Carregando propriedades...';

  @override
  String get all_properties_loaded => 'Todas as propriedades carregadas';

  @override
  String n_properties(int count) {
    return 'Propriedades $count';
  }

  @override
  String get in_area => 'na área';

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
  String get pagination_previous => 'Anterior';

  @override
  String get pagination_next => 'Próximo';

  @override
  String get pagination_page => 'Página';

  @override
  String get pagination_page_of => 'Página 1 de';

  @override
  String get contact_modal_title => 'Informações de contato';

  @override
  String get contact_modal_agent_contact => 'Contato do agente';

  @override
  String get contact_modal_property_owner => 'Proprietário da propriedade';

  @override
  String get contact_modal_agent_phone_number => 'Número de telefone do agente';

  @override
  String get contact_modal_owner_phone_number =>
      'Número de telefone do proprietário';

  @override
  String get contact_modal_license => 'Licença';

  @override
  String get contact_modal_rating => 'Avaliação';

  @override
  String get contact_modal_call_now => 'Ligue agora';

  @override
  String get contact_modal_copy_number => 'Copiar número';

  @override
  String get contact_modal_close => 'Fechar';

  @override
  String get contact_modal_contact_hours => 'Horário de contato: 9h00 - 20h00';

  @override
  String get contact_modal_agent => 'Agente';

  @override
  String get errors_toggle_save_failed =>
      'Falha ao alternar o salvamento da propriedade:';

  @override
  String get errors_copy_failed => 'Falha ao copiar o número de telefone:';

  @override
  String get errors_phone_copied =>
      'Número de telefone copiado para a área de transferência';

  @override
  String get errors_error_occurred_regions => 'Ocorreu um erro com regiões';

  @override
  String get errors_error_occurred_districts =>
      'Ocorreu um erro com os distritos';

  @override
  String get errors_please_fill_all_required_fields =>
      'Por favor preencha todos os campos obrigatórios';

  @override
  String get errors_authentication_required => 'Autenticação necessária';

  @override
  String get errors_user_info_missing => 'Faltam informações do usuário';

  @override
  String get errors_validation_error => 'Verifique seus dados de entrada';

  @override
  String get errors_permission_denied => 'Permissão negada';

  @override
  String get errors_server_error => 'Ocorreu um erro no servidor';

  @override
  String get errors_network_error => 'Erro de conexão de rede';

  @override
  String get errors_timeout_error => 'Tempo limite da solicitação excedido';

  @override
  String get errors_custom_error => 'Ocorreu um erro';

  @override
  String get errors_error_creating_property => 'Erro ao criar propriedade';

  @override
  String get errors_unknown_error_message => 'Ocorreu um erro desconhecido';

  @override
  String get errors_coordinates_not_found =>
      'Não foi possível encontrar coordenadas para este endereço. Insira-os manualmente.';

  @override
  String get errors_coordinates_error =>
      'Erro ao obter coordenadas. Insira-os manualmente.';

  @override
  String get property_info_views => 'visualizações';

  @override
  String get property_info_listed => 'Listado';

  @override
  String get property_info_price_per_sqm => '/m²';

  @override
  String get property_info_saved => 'Salvo';

  @override
  String get property_info_save => 'Salvar';

  @override
  String get property_info_share => 'Compartilhar';

  @override
  String get loading_loading => 'Carregando...';

  @override
  String get loading_loading_details => 'Carregando detalhes da propriedade...';

  @override
  String get loading_property_not_found => 'Propriedade não encontrada';

  @override
  String get loading_property_not_found_message =>
      'O imóvel que você procura não existe ou foi removido.';

  @override
  String get loading_back_to_properties => 'Voltar para Propriedades';

  @override
  String get loading_title => 'Carregando agentes...';

  @override
  String get loading_message =>
      'Aguarde enquanto carregamos a lista de agentes.';

  @override
  String get loading_agent_not_found => 'Agente não encontrado';

  @override
  String get property_details_title => 'Detalhes da propriedade';

  @override
  String get property_details_bedrooms => 'Quartos';

  @override
  String get property_details_bathrooms => 'Banheiros';

  @override
  String get property_details_floor_area => 'Área útil';

  @override
  String get property_details_parking => 'Estacionamento';

  @override
  String get property_details_basic_information => 'Informações Básicas';

  @override
  String get property_details_property_type => 'Tipo de propriedade:';

  @override
  String get property_details_listing_type => 'Tipo de listagem:';

  @override
  String get property_details_for_sale => 'À venda';

  @override
  String get property_details_for_rent => 'Para alugar';

  @override
  String get property_details_year_built => 'Ano de construção:';

  @override
  String get property_details_floor => 'Chão:';

  @override
  String get property_details_of => 'de';

  @override
  String get property_details_features_amenities => 'Recursos e comodidades';

  @override
  String get sections_description => 'Descrição';

  @override
  String get sections_nearby_amenities => 'Comodidades próximas';

  @override
  String get sections_similar_properties => 'Propriedades semelhantes';

  @override
  String get amenities_metro => 'Metrô';

  @override
  String get amenities_school => 'Escola';

  @override
  String get amenities_hospital => 'Hospital';

  @override
  String get amenities_shopping => 'Compras';

  @override
  String get amenities_away => 'ausente';

  @override
  String get contact_title => 'Informações de contato';

  @override
  String get contact_professional_listing => 'Listagem Profissional';

  @override
  String get contact_listed_by_agent => 'Listado por agente verificado';

  @override
  String get contact_by_owner => 'Por proprietário';

  @override
  String get contact_direct_contact =>
      'Contato direto com proprietário do imóvel';

  @override
  String get contact_property_owner => 'Proprietário da propriedade';

  @override
  String get contact_call_agent => 'Agente de chamada';

  @override
  String get contact_email_agent => 'Agente de e-mail';

  @override
  String get contact_call_owner => 'Chamar proprietário';

  @override
  String get contact_email_owner => 'Proprietário do e-mail';

  @override
  String get contact_send_inquiry => 'Enviar consulta';

  @override
  String get property_status_title => 'Situação da propriedade';

  @override
  String get property_status_availability => 'Disponibilidade:';

  @override
  String get property_status_available => 'Disponível';

  @override
  String get property_status_not_available => 'Não disponível';

  @override
  String get property_status_featured => 'Apresentou:';

  @override
  String get property_status_featured_property => 'Propriedade em destaque';

  @override
  String get property_status_property_id => 'ID da propriedade:';

  @override
  String get inquiry_title => 'Enviar consulta';

  @override
  String get inquiry_inquiry_type => 'Tipo de consulta';

  @override
  String get inquiry_request_info => 'Solicitar informações';

  @override
  String get inquiry_schedule_viewing => 'Agendar visualização';

  @override
  String get inquiry_make_offer => 'Faça uma oferta';

  @override
  String get inquiry_request_callback => 'Solicitar retorno de chamada';

  @override
  String get inquiry_message => 'Mensagem';

  @override
  String get inquiry_message_placeholder =>
      'Conte-nos sobre o seu interesse neste imóvel...';

  @override
  String get inquiry_offered_price => 'Preço oferecido';

  @override
  String get inquiry_enter_offer => 'Insira sua oferta';

  @override
  String get inquiry_preferred_contact_time =>
      'Horário de contato preferencial (opcional)';

  @override
  String get inquiry_contact_time_placeholder =>
      'por exemplo, dias úteis das 9h00 às 17h00';

  @override
  String get inquiry_cancel => 'Cancelar';

  @override
  String get inquiry_sending => 'Enviando...';

  @override
  String get inquiry_send_inquiry => 'Enviar consulta';

  @override
  String get inquiry_inquiry_sent_success => 'Consulta enviada com sucesso!';

  @override
  String get inquiry_inquiry_sent_error =>
      'Falha ao enviar consulta. Por favor, tente novamente.';

  @override
  String get alerts_link_copied =>
      'Link da propriedade copiado para a área de transferência!';

  @override
  String get alerts_phone_copied =>
      'Número de telefone copiado para a área de transferência!';

  @override
  String get alerts_save_property_failed => 'Falha ao salvar a propriedade:';

  @override
  String get alerts_email_subject => 'Consulta sobre:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Olá,\\n\\nEstou interessado no seu imóvel \"$title\" localizado em $address.\\n\\nEntre em contato comigo para mais informações.\\n\\nAtenciosamente';
  }

  @override
  String get related_properties_view_details => 'Ver detalhes';

  @override
  String get header_property => 'Encontre o imóvel dos seus sonhos';

  @override
  String get header_sub_property =>
      'Descubra oportunidades imobiliárias premium nos bairros mais desejáveis ​​de Tashkent';

  @override
  String get header_title => 'Agentes imobiliários';

  @override
  String get header_subtitle =>
      'Encontre agentes experientes para ajudar com suas necessidades imobiliárias';

  @override
  String get header_agents_found => 'agentes encontrados';

  @override
  String get filters_all_specializations => 'Todas as Especializações';

  @override
  String get filters_residential => 'residencial';

  @override
  String get filters_commercial => 'Comercial';

  @override
  String get filters_luxury => 'Luxo';

  @override
  String get filters_investment => 'Investimento';

  @override
  String get filters_any_rating => 'Qualquer classificação';

  @override
  String get filters_four_stars => '4+ estrelas';

  @override
  String get filters_four_half_stars => '4,5+ estrelas';

  @override
  String get filters_five_stars => '5 estrelas';

  @override
  String get filters_highest_rated => 'Mais bem avaliado';

  @override
  String get filters_lowest_rated => 'Classificação mais baixa';

  @override
  String get filters_most_sales => 'Maioria das vendas';

  @override
  String get filters_most_experience => 'Mais experiência';

  @override
  String get agent_card_verified_agent => 'Agente verificado';

  @override
  String get agent_card_years_experience => 'anos de experiência';

  @override
  String get agent_card_years => 'anos';

  @override
  String get agent_card_license => 'Licença';

  @override
  String get agent_card_specialization => 'Especialização';

  @override
  String get agent_card_view_profile => 'Ver perfil';

  @override
  String get agent_card_contact => 'Contato';

  @override
  String get agent_card_verified => 'Verificado';

  @override
  String get no_results_title => 'Nenhum agente encontrado';

  @override
  String get no_results_message =>
      'Tente ajustar seus critérios ou filtros de pesquisa.';

  @override
  String get error_title => 'Erro ao carregar agentes';

  @override
  String get error_message =>
      'Falha ao carregar a lista de agentes. Por favor, tente novamente.';

  @override
  String get error_retry => 'Tentar novamente';

  @override
  String get error_default_message => 'Falha ao carregar detalhes do agente';

  @override
  String get error_try_again => 'Tente novamente';

  @override
  String get notifications_phone_copied =>
      'Número de telefone copiado para a área de transferência';

  @override
  String get notifications_copy_failed =>
      'Falha ao copiar o número de telefone:';

  @override
  String get fallback_agent_name => 'Agente';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Enviar propriedade';

  @override
  String get navigation_submitting => 'Enviando...';

  @override
  String get navigation_back_to_agents => 'Voltar para Agentes';

  @override
  String get agent_profile_verified_agent => 'Agente verificado';

  @override
  String get agent_profile_contact_agent => 'Agente de contato';

  @override
  String get agent_profile_send_message => 'Enviar mensagem';

  @override
  String get agent_profile_years_experience => 'Anos de experiência';

  @override
  String get agent_profile_properties_sold => 'Imóveis Vendidos';

  @override
  String get agent_profile_active_listings => 'Listagens Ativas';

  @override
  String get agent_profile_total_properties => 'Propriedades totais';

  @override
  String get tabs_overview => 'visão geral';

  @override
  String get tabs_properties => 'propriedades';

  @override
  String get tabs_reviews => 'comentários';

  @override
  String get about_agent_title => 'Sobre o agente';

  @override
  String get about_agent_agency => 'Agência';

  @override
  String get about_agent_license_number => 'Número de licença';

  @override
  String get about_agent_specialization => 'Especialização';

  @override
  String get about_agent_member_since => 'Membro desde';

  @override
  String get about_agent_verified_since => 'Verificado desde';

  @override
  String get performance_metrics_title => 'Métricas de desempenho';

  @override
  String get performance_metrics_average_rating => 'Avaliação média';

  @override
  String get performance_metrics_properties_sold => 'Imóveis Vendidos';

  @override
  String get performance_metrics_active_listings => 'Listagens Ativas';

  @override
  String get performance_metrics_years_experience => 'Anos de experiência';

  @override
  String get contact_info_title => 'Informações de contato';

  @override
  String get contact_info_contact_via_platform => 'Contato via Plataforma';

  @override
  String get verification_status_title => 'Status de verificação';

  @override
  String get verification_status_verified_agent => 'Agente verificado';

  @override
  String get verification_status_pending_verification => 'Verificação pendente';

  @override
  String get verification_status_licensed_professional =>
      'Profissional Licenciado';

  @override
  String get verification_status_registered_agency => 'Agência Registrada';

  @override
  String get quick_actions_title => 'Ações rápidas';

  @override
  String get quick_actions_call_now => 'Ligue agora';

  @override
  String get quick_actions_send_message => 'Enviar mensagem';

  @override
  String get quick_actions_view_properties => 'Ver propriedades';

  @override
  String get properties_title => 'Propriedades do agente';

  @override
  String get properties_loading_properties => 'Carregando propriedades...';

  @override
  String get properties_no_properties_title => 'Nenhuma propriedade encontrada';

  @override
  String get properties_no_properties_message =>
      'As propriedades deste agente aparecerão aqui.';

  @override
  String get properties_recent_properties_note =>
      'Mostrando propriedades recentes. Verifique as listagens completas de todas as propriedades dos agentes.';

  @override
  String get properties_listed => 'Listado';

  @override
  String get properties_bed => 'cama';

  @override
  String get properties_bath => 'banho';

  @override
  String get properties_for_sale => 'À venda';

  @override
  String get properties_for_rent => 'Para alugar';

  @override
  String get reviews_title => 'Avaliações de clientes';

  @override
  String get reviews_no_reviews_title => 'Ainda não há comentários';

  @override
  String get reviews_no_reviews_message =>
      'Avaliações e recomendações de clientes aparecerão aqui.';

  @override
  String get fallbacks_agent_name => 'Agente';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => 'Propriedades salvas';

  @override
  String get saved_properties_subtitle =>
      'Suas propriedades favoritas em um só lugar';

  @override
  String get saved_properties_no_saved_properties =>
      'Nenhuma propriedade salva ainda';

  @override
  String get saved_properties_start_saving =>
      'Comece a explorar e salve as propriedades que você gosta';

  @override
  String get saved_properties_browse_properties => 'Navegar pelas propriedades';

  @override
  String get saved_properties_saved_on => 'Salvo em';

  @override
  String get auth_login_required =>
      'Faça login para ver as propriedades salvas';

  @override
  String get auth_login => 'Conecte-se';

  @override
  String get success_property_unsaved => 'Propriedade removida da lista salva';

  @override
  String get success_property_saved => 'Propriedade salva com sucesso';

  @override
  String get success_phone_copied => 'Número de telefone copiado!';

  @override
  String get success_property_created_success => 'Imóvel criado com sucesso!';

  @override
  String get success_agent_approved => 'Agente aprovado com sucesso';

  @override
  String get success_agent_rejected => 'Agente rejeitado com sucesso';

  @override
  String get steps_step => 'Etapa';

  @override
  String get steps_basic_information => 'Informações Básicas';

  @override
  String get steps_location_details => 'Detalhes do local';

  @override
  String get steps_property_details => 'Detalhes da propriedade';

  @override
  String get steps_property_images => 'Imagens de propriedades';

  @override
  String get basic_info_tell_us_about_property => 'Conte-nos sobre seu imóvel';

  @override
  String get basic_info_property_type => 'Tipo de propriedade';

  @override
  String get basic_info_listing_type => 'Tipo de listagem';

  @override
  String get basic_info_property_title => 'Título da propriedade';

  @override
  String get basic_info_title_placeholder =>
      'Insira um título descritivo para sua propriedade';

  @override
  String get basic_info_description => 'Descrição';

  @override
  String get basic_info_description_placeholder =>
      'Descreva detalhadamente o seu imóvel...';

  @override
  String get property_types_apartment => 'Apartamento';

  @override
  String get property_types_house => 'Casa';

  @override
  String get property_types_townhouse => 'Moradia';

  @override
  String get property_types_villa => 'Vila';

  @override
  String get property_types_commercial => 'Comercial';

  @override
  String get property_types_office => 'Escritório';

  @override
  String get property_types_land => 'Terra';

  @override
  String get property_types_warehouse => 'Armazém';

  @override
  String get listing_types_for_sale => 'À venda';

  @override
  String get listing_types_for_rent => 'Para alugar';

  @override
  String get location_where_is_property => 'Onde está localizado o seu imóvel?';

  @override
  String get location_full_address => 'Endereço completo';

  @override
  String get location_address_placeholder => 'Digite o endereço completo';

  @override
  String get location_region => 'Região';

  @override
  String get location_select_region => 'Selecione a região';

  @override
  String get location_district => 'Distrito';

  @override
  String get location_select_district => 'Selecione o distrito';

  @override
  String get location_city => 'Cidade';

  @override
  String get location_city_placeholder => 'Cidade';

  @override
  String get location_loading_regions => 'Carregando regiões...';

  @override
  String get location_loading_districts => 'Carregando distritos...';

  @override
  String get location_map_coordinates => 'Coordenadas do mapa';

  @override
  String get location_get_coordinates => 'Obtenha coordenadas';

  @override
  String get location_latitude => 'Latitude';

  @override
  String get location_longitude => 'Longitude';

  @override
  String get location_coordinates_set => 'Conjunto de coordenadas';

  @override
  String get location_location_tips => 'Dicas de localização';

  @override
  String get location_location_tip_1 =>
      '• Preencha primeiro o endereço e depois clique em \"Obter coordenadas\" para obter automaticamente a localização no mapa';

  @override
  String get location_location_tip_2 =>
      '• Você também pode inserir coordenadas manualmente se souber a localização exata';

  @override
  String get location_location_tip_3 =>
      '• Coordenadas precisas ajudam os compradores a encontrar sua propriedade no mapa';

  @override
  String get property_details_provide_detailed_info =>
      'Forneça informações detalhadas sobre sua propriedade';

  @override
  String get property_details_total_floors => 'Total de andares';

  @override
  String get property_details_area_m2 => 'Área (m²)';

  @override
  String get property_details_parking_spaces => 'Vagas de estacionamento';

  @override
  String get property_details_price => 'Preço';

  @override
  String get property_details_features => 'Características';

  @override
  String get images_add_photos_showcase =>
      'Adicione fotos para mostrar sua propriedade';

  @override
  String get images_click_to_upload => 'Clique para fazer upload de imagens';

  @override
  String get images_max_images_info => 'Máximo de 10 imagens, JPG, PNG ou WEBP';

  @override
  String get images_main => 'Principal';

  @override
  String get images_maximum_images_allowed => 'Máximo de 10 imagens permitidas';

  @override
  String get admin_dashboard_title => 'Painel de administração';

  @override
  String get admin_dashboard_subtitle =>
      'Visão geral em tempo real da sua plataforma imobiliária';

  @override
  String get admin_last_update => 'Última atualização';

  @override
  String get admin_total_properties => 'Propriedades totais';

  @override
  String get admin_total_agents => 'Total de Agentes';

  @override
  String get admin_total_users => 'Total de usuários';

  @override
  String get admin_total_views => 'Total de visualizações';

  @override
  String get admin_error_loading_dashboard => 'Erro ao carregar o painel';

  @override
  String get admin_failed_to_load_data => 'Falha ao carregar dados do painel';

  @override
  String get admin_avg_sale_price => 'Preço médio de venda';

  @override
  String get admin_avg_sale_price_subtitle => 'Todas as listagens ativas';

  @override
  String get admin_total_portfolio_value => 'Valor total do portfólio';

  @override
  String get admin_total_portfolio_value_subtitle =>
      'Valor da propriedade combinada';

  @override
  String get admin_avg_price_per_sqm => 'Preço médio por m²';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Indicador de taxa de mercado';

  @override
  String get admin_property_types_distribution =>
      'Distribuição de tipos de propriedade';

  @override
  String get admin_properties_by_city => 'Imóveis por Cidade';

  @override
  String get admin_properties_by_district => 'Imóveis por Distrito';

  @override
  String get admin_inquiry_types_distribution =>
      'Distribuição de tipos de consulta';

  @override
  String get admin_agent_verification_rate => 'Taxa de verificação do agente';

  @override
  String get admin_agent_verification_rate_subtitle => 'Controle de qualidade';

  @override
  String get admin_inquiry_response_rate => 'Taxa de resposta a consultas';

  @override
  String get admin_inquiry_response_rate_subtitle => 'Atendimento ao Cliente';

  @override
  String get admin_avg_views_per_property =>
      'Média de visualizações por propriedade';

  @override
  String get admin_avg_views_per_property_subtitle =>
      'Popularidade da propriedade';

  @override
  String get admin_featured_properties => 'Propriedades em destaque';

  @override
  String get admin_featured_properties_subtitle => 'Listagens premium';

  @override
  String get admin_most_viewed_properties => 'Propriedades mais vistas';

  @override
  String get admin_top_performing_agents => 'Agentes de melhor desempenho';

  @override
  String get admin_system_health => 'Saúde do sistema';

  @override
  String get admin_properties_without_images => 'Propriedades sem imagens';

  @override
  String get admin_missing_location_data => 'Dados de localização ausentes';

  @override
  String get admin_pending_agent_verification =>
      'Verificação do agente pendente';

  @override
  String get admin_active => 'ativo';

  @override
  String get admin_verified => 'verificado';

  @override
  String get admin_active_7d => 'ativo (7d)';

  @override
  String get admin_this_month => 'este mês';

  @override
  String get agents_loading_pending_applications =>
      'Carregando inscrições pendentes...';

  @override
  String get agents_error_loading_applications =>
      'Erro ao carregar aplicativos';

  @override
  String get agents_pending_agents => 'Agentes Pendentes';

  @override
  String get agents_total_pending_applications =>
      'Total de solicitações pendentes:';

  @override
  String get agents_pending_verification => 'Verificação pendente';

  @override
  String get agents_applied_date => 'Aplicado:';

  @override
  String get agents_contact_info => 'Informações de contato';

  @override
  String get agents_license_number => 'Número de licença';

  @override
  String get agents_years_experience => 'Anos de experiência';

  @override
  String get agents_years_suffix => 'anos';

  @override
  String get agents_total_sales => 'Vendas totais';

  @override
  String get agents_specialization => 'Especialização';

  @override
  String get agents_approve => 'Aprovar';

  @override
  String get agents_reject => 'Rejeitar';

  @override
  String get agents_no_pending_applications => 'Não há inscrições pendentes';

  @override
  String get agents_all_applications_processed =>
      'Todas as solicitações de agentes foram processadas';

  @override
  String get general_previous => 'Anterior';

  @override
  String get general_page => 'Página';

  @override
  String get general_next => 'Próximo';

  @override
  String get general_views => 'visualizações';

  @override
  String get general_sales => 'vendas';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'Russo';

  @override
  String get general_language_en => 'Inglês';

  @override
  String get general_super_admin => 'Superadministrador';

  @override
  String get general_staff => 'Funcionários';

  @override
  String get general_verified_agent => 'Agente verificado';

  @override
  String get general_pending_agent => 'Agente Pendente';

  @override
  String get general_regular_user => 'Usuário regular';

  @override
  String get general_admin => 'Administrador';

  @override
  String get general_dashboard => 'Painel';

  @override
  String get general_manage_users => 'Gerenciar usuários';

  @override
  String get general_verified_agents => 'Agentes verificados';

  @override
  String get general_agent_panel => 'Painel do Agente';

  @override
  String get general_create_property => 'Criar propriedade';

  @override
  String get general_my_properties => 'Minhas propriedades';

  @override
  String get general_inquiries => 'Consultas';

  @override
  String get general_agent_profile => 'Perfil do agente';

  @override
  String get general_live => 'Ao vivo';

  @override
  String get general_logged_out_successfully => 'Desconectado com sucesso';

  @override
  String get general_logout_completed_with_errors =>
      'Logout concluído (com erros)';

  @override
  String get general_application_under_review => 'Solicitação em análise';

  @override
  String get general_check_status => 'Verifique o status →';

  @override
  String get general_last_updated => 'Última atualização:';

  @override
  String get general_permissions_may_be_outdated =>
      'As permissões podem estar desatualizadas';

  @override
  String get general_permissions_up_to_date => 'Permissões atualizadas';

  @override
  String get general_never => 'Nunca';

  @override
  String get general_properties_found => 'Propriedades encontradas';

  @override
  String get general_properties_saved => 'propriedades salvas';

  @override
  String get general_saved => 'salvo';

  @override
  String get general_loading_properties => 'Carregando propriedades...';

  @override
  String get general_failed_to_load =>
      'Falha ao carregar propriedades. Por favor, tente novamente.';

  @override
  String get general_no_properties_found => 'Nenhuma propriedade encontrada';

  @override
  String get general_try_adjusting =>
      'Tente ajustar seus critérios de pesquisa';

  @override
  String get select_category => 'Selecione a categoria';

  @override
  String get service_description => 'Descrição do serviço';

  @override
  String get product_search_placeholder =>
      'Insira um termo de pesquisa para encontrar produtos';

  @override
  String get privacy_policy => 'política de Privacidade';

  @override
  String get terms_subtitle => 'Política de privacidade e termos';

  @override
  String get last_updated => 'Última atualização';

  @override
  String get contact_information => 'Informações de contato';

  @override
  String get accept_terms => 'Aceito os Termos e Condições';

  @override
  String get read_terms => 'Por favor leia nossos termos e condições';

  @override
  String get inquiries => 'Consultas e suporte';

  @override
  String get inquiries_subtitle => 'Contate-nos para obter ajuda';

  @override
  String get help_center => 'Como podemos ajudá-lo?';

  @override
  String get help_subtitle => 'Estamos aqui para ajudá-lo com qualquer dúvida';

  @override
  String get contact_us => 'Contate-nos';

  @override
  String get email_support => 'Suporte por e-mail';

  @override
  String get call_support => 'Ligue para o suporte';

  @override
  String get send_message => 'Enviar mensagem';

  @override
  String get fill_contact_form => 'Preencha o formulário de contato';

  @override
  String get contact_form => 'Formulário de contato';

  @override
  String get name => 'Seu nome';

  @override
  String get name_required => 'Por favor digite seu nome';

  @override
  String get email => 'Endereço de email';

  @override
  String get email_required => 'Por favor insira seu e-mail';

  @override
  String get email_invalid => 'Por favor insira um e-mail válido';

  @override
  String get subject => 'Assunto';

  @override
  String get subject_required => 'Por favor insira um assunto';

  @override
  String get message => 'Mensagem';

  @override
  String get message_required => 'Por favor digite sua mensagem';

  @override
  String get message_too_short =>
      'A mensagem deve ter pelo menos 10 caracteres';

  @override
  String get faq => 'Perguntas frequentes';

  @override
  String get follow_us => 'Siga-nos';

  @override
  String get faq_how_to_sell => 'Como faço para vender itens no Tezsell?';

  @override
  String get faq_how_to_sell_answer =>
      'Para vender itens: 1) Crie uma conta, 2) Toque no botão \'+\', 3) Escolha a categoria (Produtos/Serviços/Imóveis), 4) Adicione fotos e descrição, 5) Defina seu preço, 6) Publique! Sua listagem ficará visível para compradores em sua área.';

  @override
  String get faq_is_free => 'O uso do Tezsell é gratuito?';

  @override
  String get faq_is_free_answer =>
      'Sim! Tezsell é atualmente 100% gratuito. Sem taxas de listagem, sem comissão sobre vendas, sem taxas de assinatura. Poderemos introduzir recursos premium no futuro, mas notificaremos os usuários com 30 dias de antecedência.';

  @override
  String get faq_safety => 'Como posso ficar seguro ao comprar/vender?';

  @override
  String get faq_safety_answer =>
      'Dicas de segurança: 1) Reúna-se em locais públicos, 2) Inspecione itens antes de pagar, 3) Nunca envie dinheiro para estranhos, 4) Confie em seus instintos, 5) Denuncie usuários suspeitos, 6) Não compartilhe informações pessoais muito cedo, 7) Traga um amigo para transações de alto valor.';

  @override
  String get faq_payment => 'Como funcionam os pagamentos?';

  @override
  String get faq_payment_answer =>
      'Tezsell não processa pagamentos. Compradores e vendedores organizam o pagamento diretamente (dinheiro, transferência bancária, etc.). Somos apenas uma plataforma para conectar pessoas – você mesmo cuida da transação.';

  @override
  String get faq_prohibited => 'Quais itens são proibidos?';

  @override
  String get faq_prohibited_answer =>
      'Os itens proibidos incluem: armas, drogas, bens roubados, itens falsificados, conteúdo adulto, animais vivos (sem autorização), identidades governamentais e materiais perigosos. Consulte nossos Termos e Condições para obter a lista completa.';

  @override
  String get faq_account_delete => 'Como excluo minha conta?';

  @override
  String get faq_account_delete_answer =>
      'Vá para Perfil → Configurações → Configurações da conta → Excluir conta. Observação: isso é permanente e não pode ser desfeito. Todas as suas listagens serão removidas.';

  @override
  String get faq_report_user =>
      'Como faço para denunciar um usuário ou listagem?';

  @override
  String get faq_report_user_answer =>
      'Toque nos três pontos (•••) em qualquer listagem ou perfil de usuário e selecione \'Denunciar\'. Escolha o motivo e envie. Analisamos todos os relatórios dentro de 24 a 48 horas.';

  @override
  String get faq_change_location => 'Como mudo minha localização?';

  @override
  String get faq_change_location_answer =>
      'Toque no botão de localização no canto superior esquerdo da tela inicial. Você pode selecionar sua região e distrito para ver listagens em sua área.';

  @override
  String get welcome_customer_center => 'Bem-vindo à Central do Cliente';

  @override
  String get customer_center_subtitle =>
      'Estamos aqui para ajudá-lo 24 horas por dia, 7 dias por semana';

  @override
  String get quick_actions => 'Ações rápidas';

  @override
  String get live_chat => 'Bate-papo ao vivo';

  @override
  String get chat_with_us => 'Converse conosco';

  @override
  String get find_answers => 'Encontre respostas';

  @override
  String get my_tickets => 'Meus ingressos';

  @override
  String get view_tickets => 'Ver ingressos';

  @override
  String get feedback => 'Opinião';

  @override
  String get share_feedback => 'Compartilhe comentários';

  @override
  String get contact_methods => 'Métodos de contato';

  @override
  String get phone_support => 'Suporte por telefone';

  @override
  String get available_247 => 'Disponível 24 horas por dia, 7 dias por semana';

  @override
  String get response_24h => 'Resposta dentro de 24 horas';

  @override
  String get telegram_support => 'Suporte de telegrama';

  @override
  String get instant_replies => 'Respostas instantâneas';

  @override
  String get whatsapp_support => 'Suporte WhatsApp';

  @override
  String get quick_response => 'Resposta rápida';

  @override
  String get popular_topics => 'Tópicos populares';

  @override
  String get account_management => 'Gerenciamento de contas';

  @override
  String get reset_password => 'Redefinir senha';

  @override
  String get update_profile => 'Atualizar perfil';

  @override
  String get verify_account => 'Verifique a conta';

  @override
  String get delete_account => 'Excluir conta';

  @override
  String get buying_selling => 'Compra e Venda';

  @override
  String get how_to_post => 'Como postar anúncios';

  @override
  String get payment_methods => 'Métodos de pagamento';

  @override
  String get shipping_delivery => 'Envio e entrega';

  @override
  String get return_policy => 'Política de devolução';

  @override
  String get safety_security => 'Segurança e proteção';

  @override
  String get report_scam => 'Denunciar fraude';

  @override
  String get safe_trading => 'Dicas de negociação segura';

  @override
  String get privacy_settings => 'Configurações de privacidade';

  @override
  String get blocked_users => 'Usuários bloqueados';

  @override
  String get technical_issues => 'Problemas técnicos';

  @override
  String get app_not_working => 'O aplicativo não funciona';

  @override
  String get upload_failed => 'Falha no upload';

  @override
  String get login_problems => 'Problemas de login';

  @override
  String get support_hours => 'Horário de suporte';

  @override
  String get mon_fri_9_6 => 'Seg-Sex: 9h00 - 18h00';

  @override
  String get how_are_we_doing => 'Como estamos?';

  @override
  String get rate_experience =>
      'Avalie sua experiência de atendimento ao cliente';

  @override
  String get poor => 'Pobre';

  @override
  String get okay => 'OK';

  @override
  String get good => 'Bom';

  @override
  String get excellent => 'Excelente';

  @override
  String get account_secure => 'Sua conta está segura';

  @override
  String get password_security => 'Senha e autenticação';

  @override
  String get change_password => 'Alterar a senha';

  @override
  String get two_factor_auth => 'Autenticação de dois fatores';

  @override
  String get biometric_login => 'Login biométrico';

  @override
  String get login_activity => 'Atividade de login';

  @override
  String get active_sessions => 'Sessões ativas';

  @override
  String get login_alerts => 'Alertas de login';

  @override
  String get account_protection => 'Proteção de conta';

  @override
  String get recovery_email => 'E-mail de recuperação';

  @override
  String get backup_codes => 'Códigos de backup';

  @override
  String get danger_zone => 'Zona de perigo';

  @override
  String get improve_security => 'Melhore a segurança';

  @override
  String get security_score => 'Pontuação de segurança';

  @override
  String get last_changed_days => 'Última alteração há 30 dias';

  @override
  String get logout_all_devices => 'Sair de todos os dispositivos';

  @override
  String get end_all_sessions => 'Encerrar todas as sessões';

  @override
  String get permanently_delete => 'Excluir permanentemente';

  @override
  String get verification_code_message =>
      'Enviaremos um código de verificação para confirmar que é você.';

  @override
  String get send_code => 'Enviar código';

  @override
  String get enter_verification_code => 'Insira o código de verificação';

  @override
  String get verification_code => 'Código de verificação';

  @override
  String get new_password => 'Nova Senha';

  @override
  String get confirm_password => 'Confirme sua senha';

  @override
  String get resend_code => 'Reenviar código';

  @override
  String get code_sent_to => 'Digite o código de verificação enviado para';

  @override
  String get enter_code => 'Insira o código de verificação';

  @override
  String get code_must_be_6_digits => 'O código deve ter 6 dígitos';

  @override
  String get enter_new_password => 'Digite a nova senha';

  @override
  String get minimum_8_characters => 'Mínimo 8 caracteres';

  @override
  String get passwords_do_not_match => 'As senhas não coincidem';

  @override
  String get close => 'Fechar';

  @override
  String get current => 'Atual';

  @override
  String get session_ended => 'Sessão encerrada';

  @override
  String get update_recovery_email => 'Atualizar e-mail de recuperação';

  @override
  String get new_email => 'Novo e-mail';

  @override
  String get update => 'Atualizar';

  @override
  String get verification_email_sent => 'E-mail de verificação enviado';

  @override
  String get generate_emergency_codes => 'Gerar códigos de emergência';

  @override
  String get copy_all => 'Copiar tudo';

  @override
  String get code_copied => 'Código copiado';

  @override
  String get all_codes_copied => 'Todos os códigos copiados';

  @override
  String get logout_all_devices_confirm => 'Sair de todos os dispositivos?';

  @override
  String get logout_all_devices_message =>
      'Isso encerrará todas as sessões ativas em todos os dispositivos.';

  @override
  String get logout_all => 'Sair de tudo';

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
  String get delete_account_confirm => 'Excluir conta?';

  @override
  String get delete_account_warning =>
      'Esta ação é PERMANENTE e não pode ser desfeita. Todos os seus dados serão excluídos permanentemente.';

  @override
  String get what_will_be_deleted => 'O que será excluído:';

  @override
  String get profile_and_account_info => '• Seu perfil e informações da conta';

  @override
  String get all_listings_and_posts => '• Todas as suas listagens e postagens';

  @override
  String get messages_and_conversations => 'Mensagens';

  @override
  String get saved_items_and_preferences => '• Itens e preferências salvos';

  @override
  String get enter_password_to_continue => 'Digite sua senha para continuar';

  @override
  String get continue_val => 'Continuar';

  @override
  String get please_enter_password => 'Por favor digite sua senha';

  @override
  String get enter_confirmation_code => 'Introduza o código de confirmação';

  @override
  String get deletion_confirmation_message =>
      'Enviamos um código de confirmação para o seu telefone. Insira-o abaixo para excluir permanentemente sua conta.';

  @override
  String get confirmation_code => 'Código de confirmação';

  @override
  String get please_enter_6_digit_code =>
      'Por favor insira o código de 6 dígitos';

  @override
  String get account_deleted => 'Sua conta foi excluída';

  @override
  String get deletion_cancelled => 'Exclusão cancelada';

  @override
  String get failed_to_load_user_info =>
      'Falha ao carregar informações do usuário';

  @override
  String get auth_login_to_view_saved =>
      'Faça login para ver suas propriedades salvas';

  @override
  String get authLoginRequired => 'Login obrigatório';

  @override
  String get authLoginToViewSaved =>
      'Faça login para ver suas propriedades salvas';

  @override
  String get authLogin => 'Conecte-se';

  @override
  String get savedPropertiesTitle => 'Propriedades salvas';

  @override
  String get loadingSavedProperties => 'Carregando propriedades salvas...';

  @override
  String get errorsFailedToLoadSaved => 'Falha ao carregar propriedades salvas';

  @override
  String get actionsRetry => 'Tentar novamente';

  @override
  String get savedPropertiesNoSaved => 'Nenhuma propriedade salva';

  @override
  String get savedPropertiesStartSaving =>
      'Comece a explorar e salve as propriedades que você gosta';

  @override
  String get savedPropertiesBrowse => 'Navegar pelas propriedades';

  @override
  String get resultsSavedProperties => 'propriedades salvas';

  @override
  String get actionsRefresh => 'Atualizar';

  @override
  String get resultsNoMoreProperties => 'Não há mais propriedades';

  @override
  String get propertyCardFeatured => 'Apresentou';

  @override
  String get successPropertyUnsaved => 'Propriedade removida da lista salva';

  @override
  String get alertsUnsavePropertyFailed => 'Falha ao remover propriedade';

  @override
  String get propertyCardBed => 'cama';

  @override
  String get propertyCardBath => 'banho';

  @override
  String get savedPropertiesSavedOn => 'Salvo em';

  @override
  String get propertyCardViewDetails => 'Ver detalhes';

  @override
  String get serviceDetailTitle => 'Detalhe do serviço';

  @override
  String get errorLoadingFavorites => 'Erro ao carregar itens favoritos';

  @override
  String get noFavoritesFound => 'Nenhum item favorito encontrado.';

  @override
  String get commentUpdatedSuccess => 'Comentário atualizado com sucesso!';

  @override
  String get errorUpdatingComment => 'Erro ao atualizar o comentário';

  @override
  String get replyAddedSuccess => 'Resposta adicionada com sucesso!';

  @override
  String get errorAddingReply => 'Erro ao adicionar resposta';

  @override
  String get commentDeletedSuccess => 'Comentário excluído com sucesso!';

  @override
  String get errorDeletingComment => 'Erro ao excluir comentário';

  @override
  String get serviceLikedSuccess => 'Serviço curtido com sucesso!';

  @override
  String get errorLikingService => 'Erro ao gostar do serviço';

  @override
  String get serviceDislikedSuccess => 'Serviço não apreciado com sucesso!';

  @override
  String get errorDislikingService => 'Erro ao não gostar do serviço';

  @override
  String get writeYourReply => 'Escreva sua resposta...';

  @override
  String get postReply => 'Postar resposta';

  @override
  String get anonymous => 'Anônimo';

  @override
  String get editComment => 'Editar comentário';

  @override
  String get editYourComment => 'Edite seu comentário...';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get propertyOwner => 'Proprietário da propriedade';

  @override
  String get errorLoadingServices => 'Erro ao carregar serviços';

  @override
  String get noRecommendedServicesFound =>
      'Nenhum serviço recomendado encontrado.';

  @override
  String get passwordRequired => 'A senha é obrigatória';

  @override
  String get passwordTooShort => 'A senha deve ter pelo menos 8 caracteres';

  @override
  String get passwordRequirements => 'A senha deve conter letras e números';

  @override
  String get usernameRequired => 'O nome de usuário é obrigatório';

  @override
  String get usernameTooShort =>
      'O nome de usuário deve ter pelo menos 3 caracteres';

  @override
  String get confirmPasswordRequired => 'A confirmação da senha é necessária';

  @override
  String get passwordHelp => 'Pelo menos 8 caracteres, letras e números';

  @override
  String get usernameExists => 'Este nome de usuário já existe';

  @override
  String get phoneExists => 'Este número de telefone já está registrado';

  @override
  String get networkError => 'Erro de conexão de rede. Verifique sua conexão';

  @override
  String get contactSeller => 'Contate o vendedor';

  @override
  String get callToReveal => 'Toque em \"Ligar\" para revelar';

  @override
  String get camera => 'Câmera';

  @override
  String get gallery => 'Galeria';

  @override
  String get selectImageSource => 'Selecione a fonte da imagem';

  @override
  String get uploading => 'Fazendo upload...';

  @override
  String get acceptTermsRequired =>
      'Você deve aceitar os Termos e Condições para continuar';

  @override
  String get iAgreeToTerms => 'Eu concordo com o';

  @override
  String get termsAndConditions => 'Termos e Condições';

  @override
  String get zeroToleranceStatement =>
      'e compreender que existe tolerância zero para conteúdo questionável ou usuários abusivos.';

  @override
  String get viewTerms => 'Ver Termos e Condições';

  @override
  String get reportContent => 'Denunciar conteúdo';

  @override
  String get selectReportReason => 'Selecione um motivo para denunciar:';

  @override
  String get additionalDetails => 'Detalhes adicionais (opcional)';

  @override
  String get reportDetailsHint => 'Forneça qualquer informação adicional...';

  @override
  String get reportSubmitted =>
      'Obrigado pelo seu relatório. Iremos revisá-lo dentro de 24 horas.';

  @override
  String get reportProduct => 'Reportar produto';

  @override
  String get reportService => 'Serviço de relatórios';

  @override
  String get reportMessage => 'Mensagem de relatório';

  @override
  String get reportUser => 'Denunciar usuário';

  @override
  String get reportErrorNotImplemented =>
      'O recurso de relatório ainda não está disponível. Entre em contato com o suporte ou tente novamente mais tarde.';

  @override
  String get reportAlreadySubmitted =>
      'Você já denunciou este conteúdo. Estamos analisando seu relatório anterior.';

  @override
  String get reportFailedGeneric =>
      'Falha ao enviar relatório. Por favor, tente novamente.';

  @override
  String get reportFailedNetwork =>
      'Ocorreu um erro de rede. Verifique sua conexão e tente novamente.';

  @override
  String get becomeAgentTitle => 'Junte-se como agente imobiliário';

  @override
  String get becomeAgentSubtitle =>
      'Liste propriedades e ajude os clientes a encontrar a casa dos seus sonhos';

  @override
  String get agentBenefits => 'Benefícios:';

  @override
  String get agentBenefitVerified => 'Selo de agente verificado';

  @override
  String get agentBenefitAnalytics => 'Acesso a análises e insights';

  @override
  String get agentBenefitClients => 'Contato direto com potenciais clientes';

  @override
  String get agentBenefitReputation => 'Construa sua reputação profissional';

  @override
  String get agentApplicationForm => 'Formulário de inscrição';

  @override
  String get agentAgencyName => 'Nome da agência';

  @override
  String get agentAgencyNameHint => 'Insira o nome da sua agência imobiliária';

  @override
  String get agentAgencyNameRequired => 'O nome da agência é obrigatório';

  @override
  String get agentLicenceNumber => 'Número de licença';

  @override
  String get agentLicenceNumberHint =>
      'Insira o número da sua licença imobiliária';

  @override
  String get agentLicenceNumberRequired => 'O número da licença é obrigatório';

  @override
  String get agentYearsExperience => 'Anos de experiência';

  @override
  String get agentYearsExperienceHint => 'Insira o número de anos';

  @override
  String get agentYearsExperienceRequired =>
      'Anos de experiência são necessários';

  @override
  String get agentYearsExperienceInvalid => 'Por favor insira um número válido';

  @override
  String get agentSpecialization => 'Especialização';

  @override
  String get agentApplicationNote =>
      'Sua inscrição será analisada por nossa equipe. Você será notificado assim que sua inscrição for aprovada.';

  @override
  String get agentSubmitApplication => 'Enviar inscrição';

  @override
  String get agentApplicationSubmitted =>
      'Candidatura submetida com sucesso! Iremos revisá-lo em breve.';

  @override
  String get agentApplicationStatus => 'Status do aplicativo';

  @override
  String get agentViewProfile => 'Veja o perfil do seu agente';

  @override
  String get agentDashboardComingSoon => 'Painel do agente em breve!';

  @override
  String get property_create_basic_information => 'Informações Básicas';

  @override
  String get property_create_property_title => 'Título da propriedade *';

  @override
  String get property_create_property_title_hint =>
      'por exemplo, apartamento moderno 3BR no centro da cidade';

  @override
  String get property_create_property_title_required =>
      'Por favor insira o título da propriedade';

  @override
  String get property_create_description => 'Descrição *';

  @override
  String get property_create_description_hint =>
      'Descreva detalhadamente o seu imóvel...';

  @override
  String get property_create_description_required =>
      'Por favor insira a descrição';

  @override
  String get property_create_property_type => 'Tipo de propriedade';

  @override
  String get property_create_property_type_required => 'Tipo de propriedade *';

  @override
  String get property_create_listing_type_required => 'Tipo de listagem *';

  @override
  String get property_create_pricing => 'Preços';

  @override
  String get property_create_price => 'Preço *';

  @override
  String get property_create_price_hint => 'Insira o preço';

  @override
  String get property_create_price_required => 'Por favor insira o preço';

  @override
  String get property_create_currency => 'Moeda';

  @override
  String get property_create_property_details => 'Detalhes da propriedade';

  @override
  String get property_create_square_meters => 'Quadrado Metros *';

  @override
  String get property_create_bedrooms => 'Quartos *';

  @override
  String get property_create_bathrooms => 'Banheiros *';

  @override
  String get property_create_floor => 'Chão';

  @override
  String get property_create_total_floors => 'Total de andares';

  @override
  String get property_create_parking => 'Estacionamento';

  @override
  String get property_create_year_built => 'Ano de construção';

  @override
  String get property_create_location => 'Localização';

  @override
  String get property_create_address => 'Endereço *';

  @override
  String get property_create_address_hint => 'Insira o endereço do imóvel';

  @override
  String get property_create_address_required => 'Por favor insira o endereço';

  @override
  String get property_create_location_detected => 'Localização detectada';

  @override
  String get property_create_get_location => 'Obtenha a localização atual';

  @override
  String get property_create_features => 'Características';

  @override
  String get property_create_feature_balcony => 'Sacada';

  @override
  String get property_create_feature_garage => 'Garagem';

  @override
  String get property_create_feature_garden => 'Jardim';

  @override
  String get property_create_feature_pool => 'Piscina';

  @override
  String get property_create_feature_elevator => 'Elevador';

  @override
  String get property_create_feature_furnished => 'Mobilado';

  @override
  String get property_create_images => 'Imagens de propriedades';

  @override
  String get property_create_tap_to_add_images =>
      'Toque para adicionar imagens';

  @override
  String get property_create_at_least_one_image =>
      'É necessária pelo menos uma imagem';

  @override
  String get property_create_add_more => 'Adicionar mais';

  @override
  String get property_create_required => 'Obrigatório';

  @override
  String get property_create_location_required =>
      'Ative os serviços de localização para criar uma propriedade';

  @override
  String get property_create_image_required =>
      'É necessária pelo menos uma imagem de propriedade';

  @override
  String get emailVerification => 'Verificação de e-mail';

  @override
  String get pleaseEnterYourEmailAddress =>
      'Por favor insira seu endereço de e-mail';

  @override
  String get enterEmailAddress => 'Digite o endereço de e-mail';

  @override
  String get resetYourPassword => 'Redefinir sua senha';

  @override
  String get resetPasswordDescription =>
      'Digite seu endereço de e-mail e enviaremos um código de verificação para redefinir sua senha.';

  @override
  String get sendVerificationCode => 'Enviar código de verificação';

  @override
  String get backToLogin => 'Voltar ao login';

  @override
  String get resetPassword => 'Redefinir senha';

  @override
  String enterVerificationCodeSentTo(String email) {
    return 'Digite o código de verificação enviado para $email';
  }

  @override
  String get codeMustBe6Digits => 'O código deve ter 6 dígitos';

  @override
  String get enterNewPassword => 'Digite a nova senha';

  @override
  String get minimum8Characters => 'Mínimo 8 caracteres';

  @override
  String get sending => 'Enviando...';

  @override
  String get verifying => 'Verificando...';

  @override
  String get new_message => 'Nova mensagem';

  @override
  String get messages => 'Mensagens';

  @override
  String get please_log_in => 'Faça login para ver as mensagens';

  @override
  String get pin => 'Alfinete';

  @override
  String get unpin => 'Liberar';

  @override
  String get delete_chat => 'Excluir bate-papo';

  @override
  String delete_chat_confirm(String name) {
    return 'Tem certeza de que deseja excluir o bate-papo com $name? Esta ação não pode ser desfeita.';
  }

  @override
  String chat_deleted(String name) {
    return 'Bate-papo com $name excluído';
  }

  @override
  String get delete_failed => 'Falha ao excluir bate-papo';

  @override
  String get no_conversations => 'Ainda não há conversas';

  @override
  String get start_conversation_hint =>
      'Inicie uma conversa tocando no botão +';

  @override
  String get start_conversation => 'Inicie uma conversa';

  @override
  String get yesterday => 'Ontem';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get no_messages_yet => 'Nenhuma mensagem ainda';

  @override
  String get unblock_user => 'Desbloquear usuário';

  @override
  String get block_user => 'Bloquear usuário';

  @override
  String get no_blocked_users => 'Nenhum usuário bloqueado';

  @override
  String get blocked_users_hint =>
      'Os usuários que você bloquear aparecerão aqui';

  @override
  String unblock_user_confirm(String username) {
    return 'Tem certeza de que deseja desbloquear $username? Você poderá receber mensagens deles novamente.';
  }

  @override
  String user_unblocked(String username) {
    return '$username foi desbloqueado';
  }

  @override
  String user_blocked(String username) {
    return '$username foi bloqueado';
  }

  @override
  String get failed_to_unblock => 'Falha ao desbloquear usuário';

  @override
  String get failed_to_block => 'Falha ao bloquear usuário';

  @override
  String get chat_info => 'Informações do bate-papo';

  @override
  String get delete_message => 'Excluir mensagem';

  @override
  String get delete_message_confirm =>
      'Tem certeza de que deseja excluir esta mensagem?';

  @override
  String get typing => 'digitando...';

  @override
  String get online => 'on-line';

  @override
  String get offline => 'off-line';

  @override
  String last_seen_at(String time) {
    return 'visto pela última vez $time';
  }

  @override
  String participants(int count) {
    return '$count participantes';
  }

  @override
  String get you_are_blocked => 'Você está bloqueado';

  @override
  String user_blocked_you(String username) {
    return '$username bloqueou você. Você não pode enviar mensagens.';
  }

  @override
  String you_blocked_user(String username) {
    return 'Você bloqueou $username';
  }

  @override
  String get cannot_send_messages_blocked =>
      'Você não pode enviar mensagens. Você foi bloqueado.';

  @override
  String get this_message_was_deleted => 'Esta mensagem foi excluída';

  @override
  String get edit => 'Editar';

  @override
  String get reply => 'Responder';

  @override
  String get editing_message => 'Editando mensagem';

  @override
  String replying_to(String username) {
    return 'Respondendo a $username';
  }

  @override
  String get voice => 'Voz';

  @override
  String get emoji => 'Emoji';

  @override
  String get photo => '📷 Foto';

  @override
  String get voice_message => '🎤 Mensagem de voz';

  @override
  String get searching => 'Procurando...';

  @override
  String get loading_users => 'Carregando usuários...';

  @override
  String search_failed(String error) {
    return 'Falha na pesquisa: $error';
  }

  @override
  String get invalid_user_data => 'Dados de usuário inválidos';

  @override
  String failed_to_start_chat(String error) {
    return 'Falha ao iniciar o bate-papo: $error';
  }

  @override
  String get audio_file_not_available => 'Arquivo de áudio não disponível';

  @override
  String failed_to_play_audio(String error) {
    return 'Falha ao reproduzir áudio: $error';
  }

  @override
  String get image_unavailable => 'Imagem indisponível';

  @override
  String get image_too_large =>
      '❌ A imagem é muito grande. O tamanho máximo é 10MB';

  @override
  String get image_file_not_found => '❌ Arquivo de imagem não encontrado';

  @override
  String get uploading_image => 'Carregando imagem...';

  @override
  String get image_sent => '✅ Imagem enviada!';

  @override
  String get failed_to_send_image => '❌ Falha ao enviar imagem';

  @override
  String get uploading_voice_message => 'Carregando mensagem de voz...';

  @override
  String get voice_message_sent => '✅ Mensagem de voz enviada!';

  @override
  String get failed_to_send_voice_message =>
      '❌ Falha ao enviar mensagem de voz';

  @override
  String get recording => '🎙️ Gravando...';

  @override
  String get microphone_permission_denied => 'Permissão de microfone negada';

  @override
  String get starting_chat => 'Iniciando bate-papo...';

  @override
  String get refresh_users => 'Atualizar usuários';

  @override
  String get search_by_username_or_phone =>
      'Pesquise por nome de usuário ou número de telefone';

  @override
  String get no_users_found => 'Nenhum usuário encontrado';

  @override
  String get try_different_search_term =>
      'Experimente um termo de pesquisa diferente';

  @override
  String get no_users_available => 'Nenhum usuário disponível';

  @override
  String get chat_exists => 'O bate-papo existe';

  @override
  String block_user_confirm(String username) {
    return 'Tem certeza de que deseja bloquear $username? Você não receberá mensagens deles e eles serão removidos da sua lista de bate-papo.';
  }

  @override
  String chat_room_label(String name) {
    return 'Sala de bate-papo: $name';
  }

  @override
  String id_label(int id) {
    return 'ID: $id';
  }

  @override
  String get participants_label => 'Participantes:';

  @override
  String get type_a_message => 'Digite uma mensagem...';

  @override
  String get edit_message_hint => 'Editar mensagem...';

  @override
  String error_label(String error) {
    return 'Erro: $error';
  }

  @override
  String get copy => 'Cópia';

  @override
  String comments_title(int count) {
    return 'Comentários ($count)';
  }

  @override
  String get reply_button => 'Responder';

  @override
  String replies_count(int count) {
    return '$count responde';
  }

  @override
  String get you_label => 'Você';

  @override
  String get delete_reply_title => 'Excluir resposta';

  @override
  String get delete_comment_title => 'Excluir comentário';

  @override
  String get unknown_date => 'Data desconhecida';

  @override
  String get press_enter_to_send => 'Pressione Enter para enviar';

  @override
  String get comment_add_error => 'Falha ao adicionar comentário';

  @override
  String get service_provider => 'Provedor de serviços';

  @override
  String get opening_chat => 'Abrindo bate-papo...';

  @override
  String get failed_to_refresh => 'Falha ao atualizar';

  @override
  String get cannot_chat_with_yourself =>
      'Você não pode conversar consigo mesmo';

  @override
  String opening_chat_with(String username) {
    return 'Abrindo bate-papo com $username...';
  }

  @override
  String get this_will_only_take_a_moment => 'Isso levará apenas um momento';

  @override
  String get unable_to_start_chat =>
      'Não foi possível iniciar o bate-papo. Por favor, tente novamente.';

  @override
  String get profile_listings => 'Listagens';

  @override
  String get profile_followers => 'Seguidores';

  @override
  String get profile_following => 'Seguindo';

  @override
  String get profile_no_products => 'Nenhum produto';

  @override
  String get profile_no_services => 'Sem serviços';

  @override
  String get profile_no_properties => 'Nenhuma propriedade';

  @override
  String get profile_user_no_products =>
      'Este usuário ainda não postou nenhum produto';

  @override
  String get profile_user_no_services =>
      'Este usuário ainda não postou nenhum serviço';

  @override
  String get profile_user_no_properties =>
      'Este usuário ainda não postou nenhuma propriedade';

  @override
  String get profile_error_occurred => 'Ocorreu um erro';

  @override
  String get profile_error_loading_products => 'Erro ao carregar produtos';

  @override
  String get profile_error_loading_services => 'Erro ao carregar serviços';

  @override
  String get profile_no_followers_yet => 'Ainda não há seguidores';

  @override
  String get profile_no_following_yet => 'Ainda não estou seguindo ninguém';

  @override
  String get profile_follow => 'Seguir';

  @override
  String get profile_following_btn => 'Seguindo';

  @override
  String get profile_message => 'Mensagem';

  @override
  String get profile_member_since => 'Membro desde';

  @override
  String get profile_loading_error => 'Erro ao carregar perfil';

  @override
  String get profile_retry => 'Tente novamente';

  @override
  String get profile_share => 'Compartilhar';

  @override
  String get profile_copy_link => 'Copiar link';

  @override
  String get profile_report => 'Relatório';

  @override
  String get linkCopied => 'Link copiado para a área de transferência';

  @override
  String get checkOutProfile => 'Confira';

  @override
  String get onTezsell => 'no TezSell';

  @override
  String get selectCountryFirst => 'Selecione o país primeiro';

  @override
  String get countrySelectionHint => 'Então você pode escolher sua região';

  @override
  String get something_went_wrong => 'Algo deu errado';

  @override
  String get check_connection_and_retry =>
      'Verifique sua conexão com a Internet e tente novamente';

  @override
  String get sold_badge => 'VENDIDO';

  @override
  String get more_categories => 'Mais';

  @override
  String no_products_in_location(String location) {
    return 'Nenhum produto encontrado em $location';
  }

  @override
  String get no_more_products => 'Não há mais produtos para carregar';

  @override
  String time_days_ago(int count) {
    return '${count}d atrás';
  }

  @override
  String time_hours_ago(int count) {
    return '${count}h atrás';
  }

  @override
  String time_minutes_ago(int count) {
    return '${count}m atrás';
  }

  @override
  String get time_just_now => 'Agora mesmo';

  @override
  String no_services_in_location(String location) {
    return 'Nenhum serviço encontrado em $location';
  }

  @override
  String get no_more_services => 'Não há mais serviços para carregar';

  @override
  String get error_loading_more_services => 'Erro ao carregar mais serviços';

  @override
  String get verification_code_length =>
      'O código de verificação deve ter 6 dígitos';

  @override
  String get map_register_title => 'Onde você mora?';

  @override
  String get map_register_headline => 'Escolha seu bairro no mapa';

  @override
  String get map_register_subtitle =>
      'Nós o usamos para mostrar compradores e vendedores próximos. Você pode ajustar seu raio mais tarde.';

  @override
  String get pick_on_map => 'Escolha no mapa';

  @override
  String get pick_again => 'Escolha novamente';

  @override
  String get resolving_location => 'Resolvendo localização…';

  @override
  String get use_dropdown_instead => 'Use o menu suspenso';

  @override
  String country_not_supported(String country) {
    return 'Ainda não oferecemos suporte a $country.';
  }

  @override
  String get region_not_auto_detected =>
      'Não foi possível detectar automaticamente sua região. Escolha-a manualmente.';

  @override
  String get district_not_auto_detected =>
      'Não foi possível detectar automaticamente seu distrito. Escolha-o manualmente.';

  @override
  String get browse_no_items_with_location =>
      'Ainda não há itens com dados de localização nesta área.';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => 'Definir localização';

  @override
  String get location_picker_confirm => 'Confirmar localização';

  @override
  String get location_picker_resolve_failed =>
      'Não foi possível resolver o endereço. Escolha novamente ou confirme apenas com as coordenadas';

  @override
  String get location_picker_selected_fallback => 'Local selecionado';

  @override
  String get location_permission_denied => 'Permissão de localização negada';

  @override
  String get location_permission_denied_settings =>
      'Permissão de localização negada – ative em Configurações';

  @override
  String get location_permission_permanent =>
      'Localização permanentemente negada – abra Configurações para ativar';

  @override
  String gps_error(String error) {
    return 'Erro de GPS: $error';
  }

  @override
  String get verify_neighborhood_title => 'Verifique seu bairro';

  @override
  String get verify_neighborhood_subtitle =>
      'Fique na sua vizinhança. Verificaremos seu GPS e pediremos que você confirme.';

  @override
  String get verify_neighborhood_button => 'Verifique a vizinhança';

  @override
  String get verify_neighborhood_low_confidence =>
      'Continue com baixa confiança';

  @override
  String get verify_neighborhood_retry => 'Tentar novamente';

  @override
  String get verify_neighborhood_youre_in => 'Você está em:';

  @override
  String verify_neighborhood_done(String name) {
    return 'Verificado! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'A precisão do GPS é ${meters}m (precisa de ≤100m). Vá para uma área aberta e tente novamente.';
  }

  @override
  String get neighborhood_not_identified =>
      'Não foi possível identificar o bairro para sua localização.';

  @override
  String get unknown_error => 'Erro desconhecido';

  @override
  String get place_search_hint => 'Pesquise um endereço ou local';

  @override
  String get place_search_unavailable =>
      'Pesquisa indisponível – coloque um alfinete';

  @override
  String get radius_slider_city => 'Cidade';

  @override
  String radius_slider_km(String value) {
    return '${value}km';
  }

  @override
  String get my_neighborhoods => 'Meus bairros';

  @override
  String get manage_on_map => 'Gerenciar no mapa';

  @override
  String get no_neighborhoods_yet =>
      'Ainda não há bairros verificados. Abra o mapa para verificar onde você está.';

  @override
  String get open_map_to_verify => 'Abrir mapa para verificar novo local';

  @override
  String get verify_here => 'Verificar aqui';

  @override
  String get verify_new_location => 'Verificar novo local';

  @override
  String eviction_warning(String name) {
    return 'Adicionar este local removerá $name (o mais antigo). Isso não pode ser desfeito.';
  }

  @override
  String get verified_today => 'Verificado hoje';

  @override
  String get verified_yesterday => 'Verificado ontem';

  @override
  String verified_n_days_ago(int days) {
    return 'Verificado há $days dias';
  }

  @override
  String get active_neighborhood => 'Ativo';

  @override
  String switch_neighborhood_success(String name) {
    return 'Alternado para $name';
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
}
