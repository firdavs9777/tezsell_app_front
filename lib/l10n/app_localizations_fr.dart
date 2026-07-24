// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get sessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get welcome => 'Accueillir';

  @override
  String get welcomeBack => 'Content de te revoir!';

  @override
  String get loginToYourAccount => 'Connectez-vous pour continuer';

  @override
  String get or => 'OU';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get chooseLanguage => 'Choisissez votre langue';

  @override
  String get selectPreferredLanguage =>
      'Sélectionnez votre langue préférée pour l\'application';

  @override
  String get continueButton => 'Continuer';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get continueWithEmail => 'Continuer avec l\'e-mail';

  @override
  String get sellAndBuyProducts =>
      'Vendez et achetez n\'importe lequel de vos produits uniquement avec nous';

  @override
  String get usedProductsMarket =>
      'Produits d\'occasion ou marché de l\'occasion';

  @override
  String get home_welcome_title => 'Votre marché de quartier';

  @override
  String get home_welcome_subtitle =>
      'Achetez et vendez avec des personnes à proximité.\nSûr, simple et local.';

  @override
  String get home_get_started => 'Commencer';

  @override
  String get home_sign_in => 'J\'ai déjà un compte';

  @override
  String get home_terms_notice =>
      'En continuant, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité.';

  @override
  String get register => 'Registre';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte';

  @override
  String get login => 'Se connecter';

  @override
  String get loginToAccount => 'Connectez-vous au compte';

  @override
  String get enterPhoneNumber => 'Entrez le numéro de téléphone';

  @override
  String get password => 'Mot de passe';

  @override
  String get enterPassword => 'Entrez le mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get registerNow => 'Inscrivez-vous maintenant';

  @override
  String get loading => 'Chargement...';

  @override
  String get pleaseEnterPhoneNumber =>
      'Veuillez entrer votre numéro de téléphone';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get unexpectedError =>
      'Une erreur inattendue s\'est produite. Veuillez réessayer.';

  @override
  String get forgotPasswordComingSoon =>
      'Fonctionnalité de mot de passe oublié bientôt disponible';

  @override
  String get selectedCountryLabel => 'Choisi:';

  @override
  String get fullPhoneLabel => 'Complet:';

  @override
  String get home => 'Maison';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Recherche';

  @override
  String get notifications => 'Notifications';

  @override
  String get error => 'Erreur';

  @override
  String get retry => 'Réessayer';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Sauvegarder';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Veuillez sélectionner votre région';

  @override
  String get searchHint => 'Rechercher un quartier ou une ville';

  @override
  String get apiError => 'Un problème est survenu lors de l\'appel de l\'API';

  @override
  String get ok => 'D\'ACCORD';

  @override
  String get emptyList => 'Liste vide';

  @override
  String get dataLoadingError =>
      'Il y a une erreur lors du chargement des données';

  @override
  String get confirm => 'Confirmer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String confirmRegionSelection(Object regionName) {
    return 'Voulez-vous sélectionner la région $regionName ?';
  }

  @override
  String get selectDistrictOrCity =>
      'Veuillez sélectionner votre quartier ou votre ville';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return 'Voulez-vous sélectionner la région $regionName - $districtName ?';
  }

  @override
  String get noResultsFound => 'Aucun résultat trouvé.';

  @override
  String errorWithCode(String errorCode) {
    return 'Erreur : $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'Échec du chargement des données. Erreur : $error';
  }

  @override
  String get phoneVerification => 'Vérification du numéro de téléphone';

  @override
  String get enterPhonePrompt => 'Veuillez entrer votre numéro de téléphone';

  @override
  String get enterPhoneNumberHint => 'Entrez le numéro de téléphone';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Sélectionné : $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'Sélectionnez votre pays';

  @override
  String get changeCountry => 'Changer de pays';

  @override
  String get country => 'Pays';

  @override
  String get allCountries => 'Tous les pays';

  @override
  String get currencyRUB => 'Rouble russe';

  @override
  String get currencyUAH => 'Hryvnia ukrainienne';

  @override
  String get currencyBYN => 'Rouble biélorusse';

  @override
  String get currencyMDL => 'Leu moldave';

  @override
  String get currencyGEL => 'Lari géorgien';

  @override
  String get currencyAMD => 'Dram arménien';

  @override
  String get currencyAZN => 'Manat azerbaïdjanais';

  @override
  String get currencyKZT => 'Tenge kazakh';

  @override
  String get currencyTMT => 'Manat turkmène';

  @override
  String get currencyKGS => 'Som kirghize';

  @override
  String get currencyTJS => 'Somoni tadjik';

  @override
  String get currencyUZS => 'Som ouzbek';

  @override
  String get currencyUSD => 'Dollar américain';

  @override
  String get currencyEUR => 'Euro';

  @override
  String fullNumber(String phoneNumber) {
    return 'Numéro complet : $phoneNumber';
  }

  @override
  String get sendCode => 'Envoyer le code';

  @override
  String get enterVerificationCode => 'Entrez le code de vérification';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String expires(String time) {
    return 'Expire : $time';
  }

  @override
  String get verifyAndContinue => 'Vérifier et continuer';

  @override
  String get invalidVerificationCode => 'Code de vérification invalide';

  @override
  String get verificationCodeSent => 'Code de vérification envoyé avec succès';

  @override
  String get failedToSendCode => 'Échec de l\'envoi du code de vérification';

  @override
  String get verificationCodeResent =>
      'Code de vérification renvoyé avec succès';

  @override
  String get failedToResendCode => 'Échec du renvoi du code de vérification';

  @override
  String get passwordVerification => 'Vérification du mot de passe';

  @override
  String get completeRegistrationPrompt =>
      'Entrez le nom d\'utilisateur et le mot de passe pour terminer l\'inscription';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get username_required => 'Le nom d\'utilisateur est requis';

  @override
  String get username_min_length =>
      'Le nom d\'utilisateur doit comporter au moins 2 caractères';

  @override
  String get usernameHint => 'Nom d\'utilisateur123';

  @override
  String get confirmPassword => 'Confirmez le mot de passe';

  @override
  String get profileImage => 'Image de profil';

  @override
  String get imageInstructions =>
      'Les images apparaîtront ici, veuillez appuyer sur l\'image de profil';

  @override
  String get finish => 'Finition';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get registrationError => 'Erreur d\'enregistrement';

  @override
  String get about => 'À propos de nous';

  @override
  String get chat => 'Chat';

  @override
  String get realEstate => 'Immobilier';

  @override
  String get language => 'FR';

  @override
  String get languageEn => 'Anglais';

  @override
  String get languageRu => 'russe';

  @override
  String get languageUz => 'Ouzbek';

  @override
  String get serviceLiked => 'Service apprécié';

  @override
  String get support => 'Soutien';

  @override
  String get service => 'Services aux entreprises';

  @override
  String get aboutContent =>
      'TezSell est une place de marché rapide et simple pour acheter et vendre des produits neufs et d\'occasion. Notre mission est de créer la plateforme la plus pratique et la plus efficace pour chaque utilisateur, garantissant des transactions fluides et une expérience conviviale. Que vous cherchiez à vendre ou à acheter, TezSell facilite la connexion et la réalisation de transactions en quelques étapes seulement. Nous accordons la priorité à la sécurité et à la confidentialité de nos utilisateurs. Toutes les transactions sont soigneusement surveillées pour garantir la sécurité et la conformité, offrant ainsi une tranquillité d\'esprit aux acheteurs et aux vendeurs. Notre interface simple et intuitive permet aux utilisateurs de lister rapidement les produits et de trouver ce dont ils ont besoin. Nous facilitons également la communication en temps réel via Telegram, rendant le processus d\'achat et de vente encore plus fluide.';

  @override
  String get errorMessage =>
      'Une erreur s\'est produite, veuillez vérifier le serveur';

  @override
  String get searchLocation => 'Emplacement';

  @override
  String get searchCategory => 'Catégories';

  @override
  String get searchProductPlaceholder => 'Rechercher des produits';

  @override
  String get searchServicePlaceholder => 'Rechercher des prestations';

  @override
  String get search_products_subtitle =>
      'Trouvez des bonnes affaires dans votre quartier';

  @override
  String get search_services_subtitle =>
      'Trouvez des professionnels dans votre quartier';

  @override
  String get search_products_error => 'Erreur lors de la recherche de produits';

  @override
  String get search_services_error =>
      'Erreur lors de la recherche des services';

  @override
  String get load_more_products_error =>
      'Erreur lors du chargement de plus de produits';

  @override
  String get load_more_services_error =>
      'Erreur lors du chargement de plus de services';

  @override
  String get try_different_keywords => 'Essayez différents mots-clés';

  @override
  String get searchText => 'Recherche';

  @override
  String get selectedCategory => 'Catégorie sélectionnée :';

  @override
  String get selectedLocation => 'Emplacement sélectionné :';

  @override
  String get productError => 'Aucun produit disponible';

  @override
  String get serviceError => 'Aucun service disponible';

  @override
  String get locationHeader => 'Sélectionnez un emplacement';

  @override
  String get locationPlaceholder => 'Rechercher une région ici';

  @override
  String get categoryHeader => 'Sélectionnez une catégorie';

  @override
  String get categoryPlaceholder => 'Catégories de recherche';

  @override
  String get categoryError => 'Aucune catégorie disponible';

  @override
  String get paginationFirst => 'D\'abord';

  @override
  String get paginationPrevious => 'Précédent';

  @override
  String get pageInfo => 'Page de';

  @override
  String get pageNext => 'Suivant';

  @override
  String get pageLast => 'Dernier';

  @override
  String get loadingMessageProduct => 'Chargement des produits...';

  @override
  String get loadingMessageError => 'Erreur lors du chargement';

  @override
  String get likeProductError =>
      'Une erreur s\'est produite lors de l\'appréciation du produit';

  @override
  String get dislikeProductError =>
      'Une erreur s\'est produite lors du refus du produit';

  @override
  String get loadingMessageLocation => 'Emplacement de chargement...';

  @override
  String get loadingLocationError =>
      'Erreur lors du chargement de l\'emplacement';

  @override
  String get loadingMessageCategory => 'Chargement des catégories...';

  @override
  String get loadingCategoryError => 'Erreur de chargement des catégories :';

  @override
  String get profileUpdateSuccessMessage => 'Profil mis à jour avec succès';

  @override
  String get profileUpdateFailMessage => 'Échec de la mise à jour du profil';

  @override
  String get seeMoreBtn => 'Voir plus';

  @override
  String get profilePageTitle => 'Page de profil';

  @override
  String get editProfileModalTitle => 'Modifier le profil';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get locationLabel => 'Emplacement actuel';

  @override
  String get profileImageLabel => 'Image de profil';

  @override
  String get chooseFileLabel => 'Choisissez un fichier';

  @override
  String get uploadBtnLabel => 'Mise à jour';

  @override
  String get uploadingBtnLabel => 'Mise à jour...';

  @override
  String get cancelBtnLabel => 'Annuler';

  @override
  String get productsTitle => 'Produits';

  @override
  String get servicesTitle => 'Services';

  @override
  String get myProductsTitle => 'Mes produits';

  @override
  String get myServicesTitle => 'Mes services';

  @override
  String get favoriteProductsTitle => 'Produits préférés';

  @override
  String get favoriteServicesTitle => 'Services favoris';

  @override
  String get noFavorites => 'Aucun favori';

  @override
  String get addNewProductBtn => 'Ajouter un nouveau produit';

  @override
  String get addNew => 'Nouveau';

  @override
  String get addNewServiceBtn => 'Ajouter un nouveau service';

  @override
  String get downloadMobileApp => 'Téléchargez l\'application mobile';

  @override
  String get registerPhoneNumberSuccess =>
      'Numéro de téléphone vérifié ! Vous pouvez passer à l\'étape suivante.';

  @override
  String get regionSelectedMessage => 'Région sélectionnée :';

  @override
  String get districtSelectMessage => 'Quartier sélectionné :';

  @override
  String get phoneNumberEmptyMessage =>
      'Veuillez vérifier votre numéro de téléphone avant de continuer';

  @override
  String get regionEmptyMessage => 'Veuillez d\'abord sélectionner la région';

  @override
  String get districtEmptyMessage => 'Veuillez sélectionner le quartier';

  @override
  String get usernamePasswordEmptyMessage =>
      'Veuillez saisir votre nom d\'utilisateur et votre mot de passe';

  @override
  String get registerTitle => 'Registre';

  @override
  String get previousButton => 'Précédent';

  @override
  String get nextButton => 'Suivant';

  @override
  String get completeButton => 'Complet';

  @override
  String stepIndicator(int currentStep) {
    return 'Étape $currentStep sur 4';
  }

  @override
  String get districtSelectTitle => 'Liste des districts';

  @override
  String get districtSelectParagraph => 'Sélectionnez un quartier :';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get sendOtp => 'Envoyer OTP';

  @override
  String get sendAgain => 'Envoyer à nouveau';

  @override
  String get verify => 'Vérifier';

  @override
  String get failedToSendOtp =>
      'Échec de l\'envoi d\'OTP. Le serveur a renvoyé false.';

  @override
  String get errorSendingOtp =>
      'Une erreur s\'est produite lors de l\'envoi d\'OTP.';

  @override
  String get invalidPhoneNumber =>
      'Veuillez entrer un numéro de téléphone valide.';

  @override
  String get verificationSuccess => 'Vérifié avec succès';

  @override
  String get verificationError =>
      'Une erreur s\'est produite. Veuillez réessayer plus tard.';

  @override
  String get regionsList => 'Liste des régions';

  @override
  String get enterUsername => 'Entrez votre nom d\'utilisateur';

  @override
  String get welcomeMessage =>
      'Bienvenue sur Tezsell, connectez-vous avec votre numéro de téléphone';

  @override
  String get noAccount => 'Pas encore de compte ? Inscrivez-vous ici';

  @override
  String get successLogin => 'Connecté avec succès';

  @override
  String get myProfile => 'Mon profil';

  @override
  String get logout => 'déconnexion';

  @override
  String get newProductTitle => 'Titre';

  @override
  String get newProductDescription => 'Description';

  @override
  String get newProductPrice => 'Prix';

  @override
  String get newProductCondition => 'Condition';

  @override
  String get newProductCategory => 'Catégorie';

  @override
  String get newProductImages => 'Images';

  @override
  String get addNewService => 'Ajouter un nouveau service';

  @override
  String get creating => 'Création...';

  @override
  String get serviceName => 'Nom du service';

  @override
  String get serviceNamePlaceholder => 'Entrez le titre du service';

  @override
  String get serviceDescription => 'Description des services';

  @override
  String get serviceDescriptionPlaceholder =>
      'Entrez la description du service';

  @override
  String get serviceCategory => 'Catégorie de services';

  @override
  String get selectCategory => 'Sélectionnez la catégorie';

  @override
  String get loadingCategories => 'Chargement...';

  @override
  String get errorLoadingCategories =>
      'Erreur lors du chargement des catégories';

  @override
  String get serviceImages => 'Images de services';

  @override
  String get imageUploadHelper =>
      'Cliquez sur l\'icône + pour ajouter des images (maximum 10)';

  @override
  String get maxImagesError =>
      'Vous pouvez télécharger un maximum de 10 images';

  @override
  String get categoryNotFound => 'Catégorie introuvable';

  @override
  String get productCreatedSuccess => 'Produit créé avec succès';

  @override
  String get productLikeSuccess => 'Produit apprécié avec succès';

  @override
  String get productDislikeSuccess => 'Produit détesté avec succès';

  @override
  String get errorCreatingService => 'Erreur lors de la création du service';

  @override
  String get errorCreatingProduct => 'Erreur lors de la création du produit';

  @override
  String get unknownError =>
      'Une erreur inconnue s\'est produite lors de la création du service';

  @override
  String get submit => 'Soumettre';

  @override
  String get selectCategoryAction => 'Sélectionnez une catégorie';

  @override
  String get selectCondition => 'Sélectionner une condition';

  @override
  String get sum => 'Somme';

  @override
  String get noComments =>
      'Pas encore de commentaires. Soyez le premier à commenter !';

  @override
  String get commentLikeSuccess => 'Commentaire aimé avec succès';

  @override
  String get commentLikeError => 'Erreur en aimant le commentaire';

  @override
  String get unknownErrorMessage => 'Une erreur inconnue s\'est produite';

  @override
  String get commentDislikeSuccess =>
      'Le commentaire n\'a pas été aimé avec succès';

  @override
  String get commentDislikeError =>
      'Erreur lorsque je n\'aime pas le commentaire';

  @override
  String get replyInfo => 'Veuillez d\'abord saisir une réponse';

  @override
  String get replySuccessMessage => 'Réponse ajoutée avec succès';

  @override
  String get replyErrorMessage =>
      'Une erreur s\'est produite lors de la création de la réponse';

  @override
  String get commentUpdateSuccess => 'Commentaire mis à jour avec succès';

  @override
  String get commentUpdateError =>
      'Erreur lors de la mise à jour de l\'élément de commentaire';

  @override
  String get deleteConfirmationMessage =>
      'Êtes-vous sûr de vouloir supprimer ce commentaire ?';

  @override
  String get commentDeleteSuccess => 'Commentaire supprimé avec succès';

  @override
  String get commentDeleteError =>
      'Erreur lors de la suppression du commentaire';

  @override
  String get editLabel => 'Modifier';

  @override
  String get deleteLabel => 'Supprimer';

  @override
  String get saveLabel => 'Sauvegarder';

  @override
  String get replyLabel => 'Répondre';

  @override
  String get replyTitle => 'réponses';

  @override
  String get replyPlaceholder => 'Écrivez une réponse...';

  @override
  String get chatLoginMessage =>
      'Vous devez être connecté pour démarrer une discussion';

  @override
  String get chatYourselfMessage =>
      'Vous ne pouvez pas discuter avec vous-même.';

  @override
  String get chatRoomMessage => 'Salon de discussion créé !';

  @override
  String get chatRoomError => 'Échec de la création du chat !';

  @override
  String get chatCreationError => 'La création du chat a échoué !';

  @override
  String get productsTotal => 'Total des produits';

  @override
  String get perPage => 'articles';

  @override
  String get clearAllFilters => 'Supprimer tous les filtres';

  @override
  String get clickToUpload => 'Cliquez pour télécharger';

  @override
  String get productInStock => 'En stock';

  @override
  String get productOutStock => 'En rupture de stock';

  @override
  String get productBack => 'Retour aux produits';

  @override
  String get messageSeller => 'Chat';

  @override
  String get recommendedProducts => 'Produits recommandés';

  @override
  String get deleteConfirmationProduct =>
      'Êtes-vous sûr de vouloir supprimer ce produit ?';

  @override
  String get productDeleteSuccess => 'Produit supprimé avec succès';

  @override
  String get productDeleteError => 'Erreur lors de la suppression du produit';

  @override
  String get newCondition => 'Nouveau';

  @override
  String get used => 'Utilisé';

  @override
  String get imageValidType =>
      'Certains fichiers n\'ont pas été ajoutés. Veuillez utiliser des fichiers JPG, PNG, GIF ou WebP de moins de 5 Mo.';

  @override
  String get imageConfirmMessage =>
      'Êtes-vous sûr de vouloir supprimer cette image ?';

  @override
  String get titleRequiredMessage => 'Le titre est requis';

  @override
  String get descRequiredMessage => 'Une description est requise';

  @override
  String get priceRequiredMessage => 'Le prix est obligatoire';

  @override
  String get conditionRequiredMessage => 'La condition est requise';

  @override
  String get pleaseFillAllRequired =>
      'Veuillez remplir les champs obligatoires';

  @override
  String get oneImageConfirmMessage =>
      'Au moins une image de produit est requise';

  @override
  String get categoryRequiredMessage => 'La catégorie est obligatoire';

  @override
  String get locationInfoError =>
      'Les informations de localisation de l\'utilisateur sont manquantes';

  @override
  String get editProductTitle => 'Modifier le produit';

  @override
  String get imageUploadRequirements =>
      'Au moins une image est requise. Vous pouvez télécharger jusqu\'à 10 images (JPG, PNG, GIF, WebP de moins de 5 Mo chacune).';

  @override
  String get productUpdatedSuccess => 'Produit mis à jour avec succès';

  @override
  String get productUpdateFailed => 'La mise à jour du produit a échoué';

  @override
  String get errorUpdatingProduct =>
      'Une erreur s\'est produite lors de la mise à jour du produit';

  @override
  String get serviceBack => 'Retour aux prestations';

  @override
  String get likeLabel => 'Comme';

  @override
  String get commentsLabel => 'Commentaires';

  @override
  String get writeComment => 'Écrivez un commentaire...';

  @override
  String get postingLabel => 'Affectation...';

  @override
  String get commentCreated => 'Commentaire créé';

  @override
  String get postCommentLabel => 'Publier un commentaire';

  @override
  String get loginPrompt =>
      'Veuillez vous connecter pour consulter et publier des commentaires.';

  @override
  String get recommendedServices => 'Services recommandés';

  @override
  String get commentsVisibilityNotice =>
      'Les commentaires ne sont visibles que par les utilisateurs connectés.';

  @override
  String get comingSoon => 'À venir';

  @override
  String get serviceUpdateSuccess => 'Service mis à jour avec succès';

  @override
  String get serviceUpdateError =>
      'Erreur lors de la mise à jour de l\'élément de service';

  @override
  String get editServiceModalTitle => 'Modifier le service';

  @override
  String get enterPhoneNumberWithoutCode =>
      'Entrez le numéro de téléphone sans code';

  @override
  String get heroTitle => 'TezVendre';

  @override
  String get heroSubtitle =>
      'Votre marché rapide et facile pour l\'Ouzbékistan';

  @override
  String get startSelling => 'Commencez à vendre';

  @override
  String get browseProducts => 'Parcourir les produits';

  @override
  String get featuresTitle => 'Pourquoi choisir TezSell ?';

  @override
  String get listingTitle => 'Liste de produits simple';

  @override
  String get listingDescription =>
      'Listez vos articles en quelques clics. Ajoutez des photos, fixez votre prix et connectez-vous instantanément avec les acheteurs.';

  @override
  String get locationTitle => 'Navigation basée sur la localisation';

  @override
  String get locationDescription =>
      'Trouvez des offres près de chez vous. Notre système basé sur la localisation vous aide à découvrir des objets dans votre quartier.';

  @override
  String get location_subtitle =>
      'Choisissez votre région et votre district pour voir les annonces à proximité';

  @override
  String get categoryTitle => 'Filtrage par catégorie';

  @override
  String get categoryDescription =>
      'Naviguez facilement à travers les différentes catégories pour trouver exactement ce que vous recherchez.';

  @override
  String get inspirationTitle => 'Inspiré du marché coréen de la carotte';

  @override
  String get inspirationDescription1 =>
      'Nous avons construit TezSell en nous inspirant du marché coréen des carottes (당근마켓), mais nous l\'avons spécifiquement adapté pour répondre aux besoins uniques des communautés locales d\'Ouzbékistan.';

  @override
  String get inspirationDescription2 =>
      'Notre mission est de créer une plateforme fiable où les voisins peuvent acheter, vendre et se connecter facilement.';

  @override
  String get comingSoonTitle => 'Bientôt disponible sur TezSell';

  @override
  String get inAppChat => 'Chat dans l\'application';

  @override
  String get secureTransactions => 'Transactions sécurisées';

  @override
  String get realEstateListings => 'Annonces immobilières';

  @override
  String get stayUpdated => 'Restez à jour';

  @override
  String get comingSoonBadge => 'À venir';

  @override
  String get ctaTitle => 'Rejoignez la communauté TezSell dès aujourd\'hui !';

  @override
  String get ctaDescription =>
      'Participez à la création d’une meilleure expérience de marché pour l’Ouzbékistan. Partagez vos commentaires et aidez-nous à grandir !';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get learnMore => 'Apprendre encore plus';

  @override
  String get replyUpdateSuccess => 'Réponse mise à jour avec succès';

  @override
  String get replyUpdateError => 'Échec de la mise à jour de la réponse';

  @override
  String get replyDeleteSuccess => 'Réponse supprimée avec succès';

  @override
  String get replyDeleteError => 'Échec de la suppression de la réponse';

  @override
  String get replyDeleteConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cette réponse ?';

  @override
  String get authenticationRequired => 'Authentification requise';

  @override
  String get enterValidReply => 'Veuillez saisir un texte de réponse valide';

  @override
  String get saving => 'Économie...';

  @override
  String get deleting => 'Suppression...';

  @override
  String get properties => 'Propriétés';

  @override
  String get agents => 'Agents';

  @override
  String get becomeAgent => 'Devenez agent';

  @override
  String get main => 'Principal';

  @override
  String get upload => 'Télécharger';

  @override
  String get filtered_products => 'Produits filtrés';

  @override
  String get filtered_services => 'Services filtrés';

  @override
  String get productDetail => 'Détail du produit';

  @override
  String get unknownUser => 'Utilisateur inconnu';

  @override
  String get locationNotAvailable => 'Emplacement non disponible';

  @override
  String get noTitle => 'Pas de titre';

  @override
  String get noCategory => 'Aucune catégorie';

  @override
  String get noDescription => 'Aucune description';

  @override
  String get som => 'Som';

  @override
  String get about_me => 'Sur moi';

  @override
  String get my_name => 'Mon nom';

  @override
  String get customer_support => 'Assistance client';

  @override
  String get customer_center => 'Centre client';

  @override
  String get customer_inquiries => 'Demandes de renseignements';

  @override
  String get customer_terms => 'Termes et conditions';

  @override
  String get region => 'Région';

  @override
  String get district => 'District';

  @override
  String get tap_change_profile => 'Appuyez pour changer de photo';

  @override
  String get language_settings => 'Paramètres de langue';

  @override
  String get selectLanguage => 'Sélectionnez une langue';

  @override
  String get select_theme => 'Sélectionnez un thème';

  @override
  String get theme => 'Thème';

  @override
  String get location_settings => 'Paramètres de localisation';

  @override
  String get security => 'Sécurité';

  @override
  String get data_storage => 'Données et stockage';

  @override
  String get accessibility => 'Accessibilité';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get light_theme => 'Lumière';

  @override
  String get dark_theme => 'Sombre';

  @override
  String get system_theme => 'Système par défaut';

  @override
  String get my_products => 'Mes produits';

  @override
  String get refresh => 'Rafraîchir';

  @override
  String get delete_product => 'Supprimer le produit';

  @override
  String get delete_confirmation =>
      'Êtes-vous sûr de vouloir supprimer ce produit ?';

  @override
  String get delete => 'Supprimer';

  @override
  String error_loading_products(String error) {
    return 'Erreur lors du chargement des produits : $error';
  }

  @override
  String get product_deleted_success => 'Produit supprimé avec succès';

  @override
  String error_deleting_product(String error) {
    return 'Erreur lors de la suppression du produit : $error';
  }

  @override
  String get no_products_found => 'Aucun produit trouvé';

  @override
  String get add_first_product => 'Commencez par ajouter votre premier produit';

  @override
  String get no_title => 'Pas de titre';

  @override
  String get no_description => 'Pas de description';

  @override
  String get in_stock => 'En stock';

  @override
  String get out_of_stock => 'En rupture de stock';

  @override
  String get new_condition => 'NOUVEAU';

  @override
  String get edit_product => 'Modifier le produit';

  @override
  String get delete_product_tooltip => 'Supprimer le produit';

  @override
  String get sum_currency => 'Somme';

  @override
  String get edit_product_title => 'Modifier le produit';

  @override
  String get product_name => 'Nom du produit';

  @override
  String get product_description => 'Description du produit';

  @override
  String get price => 'Prix';

  @override
  String get condition => 'Condition';

  @override
  String get condition_new => 'Nouveau';

  @override
  String get condition_like_new => 'Comme neuf';

  @override
  String get condition_used => 'Utilisé';

  @override
  String get condition_refurbished => 'Remis à neuf';

  @override
  String get currency => 'Devise';

  @override
  String get category => 'Catégorie';

  @override
  String get images => 'Images';

  @override
  String get existing_images => 'Images existantes';

  @override
  String get new_images => 'Nouvelles images';

  @override
  String get image_instructions =>
      'Les images apparaîtront ici. Veuillez appuyer sur l\'icône de téléchargement ci-dessus.';

  @override
  String get update_button => 'Mise à jour';

  @override
  String loading_category_error(String error) {
    return 'Erreur de chargement des catégories : $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Erreur lors de la sélection des images : $error';
  }

  @override
  String get please_fill_all_required => 'Veuillez remplir tous les champs';

  @override
  String get invalid_price_message =>
      'Prix ​​saisi invalide. Veuillez entrer un numéro valide.';

  @override
  String get category_required_message =>
      'Veuillez sélectionner une catégorie valide.';

  @override
  String get one_image_required_message =>
      'Au moins une image de produit est requise';

  @override
  String get product_updated_success => 'Produit mis à jour avec succès';

  @override
  String error_updating_product(String error) {
    return 'Erreur lors de la mise à jour du produit : $error';
  }

  @override
  String get my_services => 'Mes services';

  @override
  String get delete_service => 'Supprimer le service';

  @override
  String get delete_service_confirmation =>
      'Êtes-vous sûr de vouloir supprimer ce service ?';

  @override
  String get no_services_found => 'Aucun service trouvé';

  @override
  String get add_first_service => 'Commencez par ajouter votre premier service';

  @override
  String get edit_service => 'Modifier le service';

  @override
  String get delete_service_tooltip => 'Supprimer le service';

  @override
  String get service_deleted_successfully => 'Service supprimé avec succès';

  @override
  String get error_deleting_service =>
      'Erreur lors de la suppression du service';

  @override
  String get error_loading_services => 'Erreur lors du chargement des services';

  @override
  String get service_name => 'Nom du service';

  @override
  String get enter_service_name => 'Entrez le nom du service';

  @override
  String get service_name_required => 'Le nom du service est requis';

  @override
  String get service_name_min_length =>
      'Le nom du service doit comporter au moins 3 caractères';

  @override
  String get enter_service_description => 'Entrez la description du service';

  @override
  String get service_description_required =>
      'Une description du service est requise';

  @override
  String get service_description_min_length =>
      'La description doit comporter au moins 10 caractères';

  @override
  String get category_required => 'Veuillez sélectionner une catégorie';

  @override
  String get no_categories_available => 'Aucune catégorie disponible';

  @override
  String get location => 'Emplacement';

  @override
  String get select_location => 'Sélectionnez un emplacement';

  @override
  String get location_required => 'Veuillez sélectionner un emplacement';

  @override
  String get no_locations_available => 'Aucun emplacement disponible';

  @override
  String get add_images => 'Ajouter des images';

  @override
  String get current_images => 'Images actuelles';

  @override
  String get no_images_selected => 'Aucune image sélectionnée';

  @override
  String get save_changes => 'Enregistrer les modifications';

  @override
  String get map_main => 'Carte et propriétés';

  @override
  String get agent_status => 'Statut de l\'agent';

  @override
  String get admin_panel => 'Panneau d\'administration';

  @override
  String get propertiesFound => 'Propriétés trouvées';

  @override
  String get propertiesSaved => 'propriétés enregistrées';

  @override
  String get saved => 'enregistré';

  @override
  String get loadingProperties => 'Chargement des propriétés...';

  @override
  String get failedToLoad =>
      'Échec du chargement des propriétés. Veuillez réessayer.';

  @override
  String get noPropertiesFound => 'Aucune propriété trouvée';

  @override
  String get tryAdjusting => 'Essayez d\'ajuster vos critères de recherche';

  @override
  String get search_placeholder => 'Recherche par titre ou lieu...';

  @override
  String get search_filters => 'Filtres';

  @override
  String get search_button => 'Recherche';

  @override
  String get search_clear_filters => 'Effacer les filtres';

  @override
  String get filter_options_sale_and_rent => 'Vente et location';

  @override
  String get filter_options_for_sale => 'À vendre';

  @override
  String get filter_options_for_rent => 'À louer';

  @override
  String get filter_options_all_types => 'Tous types';

  @override
  String get filter_options_apartment => 'Appartement';

  @override
  String get filter_options_house => 'Maison';

  @override
  String get filter_options_townhouse => 'Maison de ville';

  @override
  String get filter_options_villa => 'Villa';

  @override
  String get filter_options_commercial => 'Commercial';

  @override
  String get filter_options_office => 'Bureau';

  @override
  String get property_card_featured => 'En vedette';

  @override
  String get property_card_bed => 'chambre à coucher';

  @override
  String get property_card_bath => 'salle de bain';

  @override
  String get property_card_parking => 'parking';

  @override
  String get property_card_view_details => 'Afficher les détails';

  @override
  String get property_card_contact => 'Contact';

  @override
  String get property_card_balcony => 'Balcon';

  @override
  String get property_card_garage => 'Garage';

  @override
  String get property_card_garden => 'Jardin';

  @override
  String get property_card_pool => 'Piscine';

  @override
  String get property_card_elevator => 'Ascenseur';

  @override
  String get property_card_furnished => 'Meublé';

  @override
  String get property_card_sales => 'ventes';

  @override
  String get pricing_month => '/mois';

  @override
  String get results_properties_found => 'Propriétés trouvées';

  @override
  String get results_properties_saved => 'propriétés enregistrées';

  @override
  String get results_saved => 'enregistré';

  @override
  String get results_loading_properties => 'Chargement des propriétés...';

  @override
  String get results_failed_to_load =>
      'Échec du chargement des propriétés. Veuillez réessayer.';

  @override
  String get results_no_properties_found => 'Aucune propriété trouvée';

  @override
  String get results_try_adjusting =>
      'Essayez d\'ajuster vos critères de recherche';

  @override
  String get no_properties_found => 'Aucune propriété trouvée';

  @override
  String get no_category_properties => 'Aucune propriété dans cette catégorie';

  @override
  String get properties_loading => 'Chargement des propriétés...';

  @override
  String get all_properties_loaded => 'Toutes les propriétés chargées';

  @override
  String n_properties(int count) {
    return 'Propriétés $count';
  }

  @override
  String get in_area => 'dans la zone';

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
  String get pagination_previous => 'Précédent';

  @override
  String get pagination_next => 'Suivant';

  @override
  String get pagination_page => 'Page';

  @override
  String get pagination_page_of => 'Page 1 de';

  @override
  String get contact_modal_title => 'Coordonnées';

  @override
  String get contact_modal_agent_contact => 'Contact Agent';

  @override
  String get contact_modal_property_owner => 'Propriétaire foncier';

  @override
  String get contact_modal_agent_phone_number =>
      'Numéro de téléphone de l\'agent';

  @override
  String get contact_modal_owner_phone_number =>
      'Numéro de téléphone du propriétaire';

  @override
  String get contact_modal_license => 'Licence';

  @override
  String get contact_modal_rating => 'Notation';

  @override
  String get contact_modal_call_now => 'Appelez maintenant';

  @override
  String get contact_modal_copy_number => 'Numéro de copie';

  @override
  String get contact_modal_close => 'Fermer';

  @override
  String get contact_modal_contact_hours =>
      'Horaires de contact : 9h00 - 20h00';

  @override
  String get contact_modal_agent => 'Agent';

  @override
  String get errors_toggle_save_failed =>
      'Échec de l\'activation de l\'enregistrement des propriétés :';

  @override
  String get errors_copy_failed => 'Échec de la copie du numéro de téléphone :';

  @override
  String get errors_phone_copied =>
      'Numéro de téléphone copié dans le presse-papiers';

  @override
  String get errors_error_occurred_regions =>
      'Une erreur s\'est produite avec les régions';

  @override
  String get errors_error_occurred_districts =>
      'Une erreur s\'est produite avec les districts';

  @override
  String get errors_please_fill_all_required_fields =>
      'Veuillez remplir tous les champs obligatoires';

  @override
  String get errors_authentication_required => 'Authentification requise';

  @override
  String get errors_user_info_missing => 'Informations utilisateur manquantes';

  @override
  String get errors_validation_error =>
      'Veuillez vérifier vos données d\'entrée';

  @override
  String get errors_permission_denied => 'Autorisation refusée';

  @override
  String get errors_server_error => 'Une erreur de serveur s\'est produite';

  @override
  String get errors_network_error => 'Erreur de connexion réseau';

  @override
  String get errors_timeout_error =>
      'Délai d\'expiration de la demande dépassé';

  @override
  String get errors_custom_error => 'Une erreur s\'est produite';

  @override
  String get errors_error_creating_property =>
      'Erreur lors de la création de la propriété';

  @override
  String get errors_unknown_error_message =>
      'Une erreur inconnue s\'est produite';

  @override
  String get errors_coordinates_not_found =>
      'Impossible de trouver les coordonnées pour cette adresse. Veuillez les saisir manuellement.';

  @override
  String get errors_coordinates_error =>
      'Erreur lors de l\'obtention des coordonnées. Veuillez les saisir manuellement.';

  @override
  String get property_info_views => 'vues';

  @override
  String get property_info_listed => 'Inscrit';

  @override
  String get property_info_price_per_sqm => '/m²';

  @override
  String get property_info_saved => 'Enregistré';

  @override
  String get property_info_save => 'Sauvegarder';

  @override
  String get property_info_share => 'Partager';

  @override
  String get loading_loading => 'Chargement...';

  @override
  String get loading_loading_details =>
      'Chargement des détails de la propriété...';

  @override
  String get loading_property_not_found => 'Propriété introuvable';

  @override
  String get loading_property_not_found_message =>
      'Le bien que vous recherchez n\'existe pas ou a été supprimé.';

  @override
  String get loading_back_to_properties => 'Retour aux propriétés';

  @override
  String get loading_title => 'Agents de chargement...';

  @override
  String get loading_message =>
      'Veuillez patienter pendant que nous chargeons la liste des agents.';

  @override
  String get loading_agent_not_found => 'Agent introuvable';

  @override
  String get property_details_title => 'Détails de la propriété';

  @override
  String get property_details_bedrooms => 'Chambres';

  @override
  String get property_details_bathrooms => 'Salles de bains';

  @override
  String get property_details_floor_area => 'Surface au sol';

  @override
  String get property_details_parking => 'Parking';

  @override
  String get property_details_basic_information => 'Informations de base';

  @override
  String get property_details_property_type => 'Type de propriété :';

  @override
  String get property_details_listing_type => 'Type d\'annonce :';

  @override
  String get property_details_for_sale => 'À vendre';

  @override
  String get property_details_for_rent => 'À louer';

  @override
  String get property_details_year_built => 'Année de construction :';

  @override
  String get property_details_floor => 'Sol:';

  @override
  String get property_details_of => 'de';

  @override
  String get property_details_features_amenities =>
      'Caractéristiques et commodités';

  @override
  String get sections_description => 'Description';

  @override
  String get sections_nearby_amenities => 'Commodités à proximité';

  @override
  String get sections_similar_properties => 'Propriétés similaires';

  @override
  String get amenities_metro => 'Métro';

  @override
  String get amenities_school => 'École';

  @override
  String get amenities_hospital => 'Hôpital';

  @override
  String get amenities_shopping => 'Achats';

  @override
  String get amenities_away => 'loin';

  @override
  String get contact_title => 'Coordonnées';

  @override
  String get contact_professional_listing => 'Annonce professionnelle';

  @override
  String get contact_listed_by_agent => 'Répertorié par un agent vérifié';

  @override
  String get contact_by_owner => 'Par propriétaire';

  @override
  String get contact_direct_contact => 'Contact direct avec le propriétaire';

  @override
  String get contact_property_owner => 'Propriétaire foncier';

  @override
  String get contact_call_agent => 'Agent d\'appel';

  @override
  String get contact_email_agent => 'Agent de messagerie';

  @override
  String get contact_call_owner => 'Appeler le propriétaire';

  @override
  String get contact_email_owner => 'Propriétaire de l\'e-mail';

  @override
  String get contact_send_inquiry => 'Envoyer une demande';

  @override
  String get property_status_title => 'Statut de la propriété';

  @override
  String get property_status_availability => 'Disponibilité:';

  @override
  String get property_status_available => 'Disponible';

  @override
  String get property_status_not_available => 'Pas disponible';

  @override
  String get property_status_featured => 'En vedette:';

  @override
  String get property_status_featured_property => 'Propriété en vedette';

  @override
  String get property_status_property_id => 'ID de propriété :';

  @override
  String get inquiry_title => 'Envoyer une demande';

  @override
  String get inquiry_inquiry_type => 'Type de demande';

  @override
  String get inquiry_request_info => 'Demander des informations';

  @override
  String get inquiry_schedule_viewing => 'Programmer le visionnage';

  @override
  String get inquiry_make_offer => 'Faire une offre';

  @override
  String get inquiry_request_callback => 'Demander un rappel';

  @override
  String get inquiry_message => 'Message';

  @override
  String get inquiry_message_placeholder =>
      'Parlez-nous de votre intérêt pour cette propriété...';

  @override
  String get inquiry_offered_price => 'Prix ​​offert';

  @override
  String get inquiry_enter_offer => 'Entrez votre offre';

  @override
  String get inquiry_preferred_contact_time =>
      'Heure de contact préférée (facultatif)';

  @override
  String get inquiry_contact_time_placeholder =>
      'par exemple, en semaine de 9h00 à 17h00';

  @override
  String get inquiry_cancel => 'Annuler';

  @override
  String get inquiry_sending => 'Envoi...';

  @override
  String get inquiry_send_inquiry => 'Envoyer une demande';

  @override
  String get inquiry_inquiry_sent_success => 'Demande envoyée avec succès !';

  @override
  String get inquiry_inquiry_sent_error =>
      'Échec de l\'envoi de la demande. Veuillez réessayer.';

  @override
  String get alerts_link_copied =>
      'Lien de propriété copié dans le presse-papier !';

  @override
  String get alerts_phone_copied =>
      'Numéro de téléphone copié dans le presse-papier !';

  @override
  String get alerts_save_property_failed =>
      'Échec de l\'enregistrement de la propriété :';

  @override
  String get alerts_email_subject => 'Enquête sur :';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Bonjour,\\n\\nJe suis intéressé par votre propriété \"$title\" située au $address.\\n\\nVeuillez me contacter pour plus d\'informations.\\n\\nBien cordialement.';
  }

  @override
  String get related_properties_view_details => 'Afficher les détails';

  @override
  String get header_property => 'Trouvez la propriété de vos rêves';

  @override
  String get header_sub_property =>
      'Découvrez des opportunités immobilières haut de gamme dans les quartiers les plus prisés de Tachkent';

  @override
  String get header_title => 'Agents immobiliers';

  @override
  String get header_subtitle =>
      'Trouvez des agents expérimentés pour vous aider avec vos besoins immobiliers';

  @override
  String get header_agents_found => 'agents trouvés';

  @override
  String get filters_all_specializations => 'Toutes les spécialisations';

  @override
  String get filters_residential => 'Résidentiel';

  @override
  String get filters_commercial => 'Commercial';

  @override
  String get filters_luxury => 'Luxe';

  @override
  String get filters_investment => 'Investissement';

  @override
  String get filters_any_rating => 'N\'importe quelle note';

  @override
  String get filters_four_stars => '4+ étoiles';

  @override
  String get filters_four_half_stars => '4,5+ étoiles';

  @override
  String get filters_five_stars => '5 étoiles';

  @override
  String get filters_highest_rated => 'Les mieux notés';

  @override
  String get filters_lowest_rated => 'Le moins bien noté';

  @override
  String get filters_most_sales => 'La plupart des ventes';

  @override
  String get filters_most_experience => 'Plus d\'expérience';

  @override
  String get agent_card_verified_agent => 'Agent vérifié';

  @override
  String get agent_card_years_experience => 'années d\'expérience';

  @override
  String get agent_card_years => 'années';

  @override
  String get agent_card_license => 'Licence';

  @override
  String get agent_card_specialization => 'Spécialisation';

  @override
  String get agent_card_view_profile => 'Voir le profil';

  @override
  String get agent_card_contact => 'Contact';

  @override
  String get agent_card_verified => 'Vérifié';

  @override
  String get no_results_title => 'Aucun agent trouvé';

  @override
  String get no_results_message =>
      'Essayez d\'ajuster vos critères de recherche ou vos filtres.';

  @override
  String get error_title => 'Erreur de chargement des agents';

  @override
  String get error_message =>
      'Échec du chargement de la liste des agents. Veuillez réessayer.';

  @override
  String get error_retry => 'Réessayer';

  @override
  String get error_default_message =>
      'Échec du chargement des détails de l\'agent';

  @override
  String get error_try_again => 'Essayer à nouveau';

  @override
  String get notifications_phone_copied =>
      'Numéro de téléphone copié dans le presse-papiers';

  @override
  String get notifications_copy_failed =>
      'Échec de la copie du numéro de téléphone :';

  @override
  String get fallback_agent_name => 'Agent';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Soumettre la propriété';

  @override
  String get navigation_submitting => 'Soumission...';

  @override
  String get navigation_back_to_agents => 'Retour aux agents';

  @override
  String get agent_profile_verified_agent => 'Agent vérifié';

  @override
  String get agent_profile_contact_agent => 'Contacter l\'agent';

  @override
  String get agent_profile_send_message => 'Envoyer un message';

  @override
  String get agent_profile_years_experience => 'Années d\'expérience';

  @override
  String get agent_profile_properties_sold => 'Propriétés vendues';

  @override
  String get agent_profile_active_listings => 'Annonces actives';

  @override
  String get agent_profile_total_properties => 'Propriétés totales';

  @override
  String get tabs_overview => 'aperçu';

  @override
  String get tabs_properties => 'propriétés';

  @override
  String get tabs_reviews => 'avis';

  @override
  String get about_agent_title => 'À propos de l\'agent';

  @override
  String get about_agent_agency => 'Agence';

  @override
  String get about_agent_license_number => 'Numéro de licence';

  @override
  String get about_agent_specialization => 'Spécialisation';

  @override
  String get about_agent_member_since => 'Membre depuis';

  @override
  String get about_agent_verified_since => 'Vérifié depuis';

  @override
  String get performance_metrics_title => 'Mesures de performances';

  @override
  String get performance_metrics_average_rating => 'Note moyenne';

  @override
  String get performance_metrics_properties_sold => 'Propriétés vendues';

  @override
  String get performance_metrics_active_listings => 'Annonces actives';

  @override
  String get performance_metrics_years_experience => 'Années d\'expérience';

  @override
  String get contact_info_title => 'Coordonnées';

  @override
  String get contact_info_contact_via_platform => 'Contact via la plateforme';

  @override
  String get verification_status_title => 'Statut de vérification';

  @override
  String get verification_status_verified_agent => 'Agent vérifié';

  @override
  String get verification_status_pending_verification =>
      'En attente de vérification';

  @override
  String get verification_status_licensed_professional => 'Professionnel agréé';

  @override
  String get verification_status_registered_agency => 'Agence enregistrée';

  @override
  String get quick_actions_title => 'Actions rapides';

  @override
  String get quick_actions_call_now => 'Appelez maintenant';

  @override
  String get quick_actions_send_message => 'Envoyer un message';

  @override
  String get quick_actions_view_properties => 'Afficher les propriétés';

  @override
  String get properties_title => 'Propriétés des agents';

  @override
  String get properties_loading_properties => 'Chargement des propriétés...';

  @override
  String get properties_no_properties_title => 'Aucune propriété trouvée';

  @override
  String get properties_no_properties_message =>
      'Les propriétés de cet agent apparaîtront ici.';

  @override
  String get properties_recent_properties_note =>
      'Affichage des propriétés récentes. Consultez les listes complètes de toutes les propriétés des agents.';

  @override
  String get properties_listed => 'Inscrit';

  @override
  String get properties_bed => 'lit';

  @override
  String get properties_bath => 'bain';

  @override
  String get properties_for_sale => 'À vendre';

  @override
  String get properties_for_rent => 'À louer';

  @override
  String get reviews_title => 'Avis clients';

  @override
  String get reviews_no_reviews_title => 'Aucun avis pour l\'instant';

  @override
  String get reviews_no_reviews_message =>
      'Les avis et recommandations des clients apparaîtront ici.';

  @override
  String get fallbacks_agent_name => 'Agent';

  @override
  String get fallbacks_default_profile_image => '/avatar-par-défaut.png';

  @override
  String get saved_properties_title => 'Propriétés enregistrées';

  @override
  String get saved_properties_subtitle =>
      'Vos propriétés préférées en un seul endroit';

  @override
  String get saved_properties_no_saved_properties =>
      'Aucune propriété enregistrée pour l\'instant';

  @override
  String get saved_properties_start_saving =>
      'Commencez à explorer et enregistrez les propriétés que vous aimez';

  @override
  String get saved_properties_browse_properties => 'Parcourir les propriétés';

  @override
  String get saved_properties_saved_on => 'Enregistré le';

  @override
  String get auth_login_required =>
      'Veuillez vous connecter pour afficher les propriétés enregistrées';

  @override
  String get auth_login => 'Se connecter';

  @override
  String get success_property_unsaved =>
      'Propriété supprimée de la liste enregistrée';

  @override
  String get success_property_saved => 'Propriété enregistrée avec succès';

  @override
  String get success_phone_copied => 'Numéro de téléphone copié !';

  @override
  String get success_property_created_success =>
      'Propriété créée avec succès !';

  @override
  String get success_agent_approved => 'Agent approuvé avec succès';

  @override
  String get success_agent_rejected => 'Agent rejeté avec succès';

  @override
  String get steps_step => 'Étape';

  @override
  String get steps_basic_information => 'Informations de base';

  @override
  String get steps_location_details => 'Détails de l\'emplacement';

  @override
  String get steps_property_details => 'Détails de la propriété';

  @override
  String get steps_property_images => 'Images de la propriété';

  @override
  String get basic_info_tell_us_about_property =>
      'Parlez-nous de votre propriété';

  @override
  String get basic_info_property_type => 'Type de propriété';

  @override
  String get basic_info_listing_type => 'Type d\'annonce';

  @override
  String get basic_info_property_title => 'Titre de propriété';

  @override
  String get basic_info_title_placeholder =>
      'Entrez un titre descriptif pour votre propriété';

  @override
  String get basic_info_description => 'Description';

  @override
  String get basic_info_description_placeholder =>
      'Décrivez votre bien en détail...';

  @override
  String get property_types_apartment => 'Appartement';

  @override
  String get property_types_house => 'Maison';

  @override
  String get property_types_townhouse => 'Maison de ville';

  @override
  String get property_types_villa => 'Villa';

  @override
  String get property_types_commercial => 'Commercial';

  @override
  String get property_types_office => 'Bureau';

  @override
  String get property_types_land => 'Atterrir';

  @override
  String get property_types_warehouse => 'Entrepôt';

  @override
  String get listing_types_for_sale => 'À vendre';

  @override
  String get listing_types_for_rent => 'À louer';

  @override
  String get location_where_is_property => 'Où se situe votre propriété ?';

  @override
  String get location_full_address => 'Adresse complète';

  @override
  String get location_address_placeholder => 'Entrez l\'adresse complète';

  @override
  String get location_region => 'Région';

  @override
  String get location_select_region => 'Sélectionnez une région';

  @override
  String get location_district => 'District';

  @override
  String get location_select_district => 'Sélectionnez le quartier';

  @override
  String get location_city => 'Ville';

  @override
  String get location_city_placeholder => 'Ville';

  @override
  String get location_loading_regions => 'Chargement des régions...';

  @override
  String get location_loading_districts => 'Chargement des quartiers...';

  @override
  String get location_map_coordinates => 'Coordonnées de la carte';

  @override
  String get location_get_coordinates => 'Obtenir les coordonnées';

  @override
  String get location_latitude => 'Latitude';

  @override
  String get location_longitude => 'Longitude';

  @override
  String get location_coordinates_set => 'Ensemble de coordonnées';

  @override
  String get location_location_tips => 'Conseils de localisation';

  @override
  String get location_location_tip_1 =>
      '• Remplissez d\'abord l\'adresse, puis cliquez sur « Obtenir les coordonnées » pour obtenir automatiquement l\'emplacement sur la carte.';

  @override
  String get location_location_tip_2 =>
      '• Vous pouvez également saisir manuellement les coordonnées si vous connaissez l\'emplacement exact';

  @override
  String get location_location_tip_3 =>
      '• Des coordonnées précises aident les acheteurs à trouver votre propriété sur la carte';

  @override
  String get property_details_provide_detailed_info =>
      'Fournissez des informations détaillées sur votre propriété';

  @override
  String get property_details_total_floors => 'Nombre total d\'étages';

  @override
  String get property_details_area_m2 => 'Superficie (m²)';

  @override
  String get property_details_parking_spaces => 'Places de stationnement';

  @override
  String get property_details_price => 'Prix';

  @override
  String get property_details_features => 'Caractéristiques';

  @override
  String get images_add_photos_showcase =>
      'Ajoutez des photos pour mettre en valeur votre propriété';

  @override
  String get images_click_to_upload => 'Cliquez pour télécharger des images';

  @override
  String get images_max_images_info => 'Maximum 10 images, JPG, PNG ou WEBP';

  @override
  String get images_main => 'Principal';

  @override
  String get images_maximum_images_allowed => 'Maximum 10 images autorisées';

  @override
  String get admin_dashboard_title => 'Tableau de bord d\'administration';

  @override
  String get admin_dashboard_subtitle =>
      'Aperçu en temps réel de votre plateforme immobilière';

  @override
  String get admin_last_update => 'Dernière mise à jour';

  @override
  String get admin_total_properties => 'Propriétés totales';

  @override
  String get admin_total_agents => 'Agents totaux';

  @override
  String get admin_total_users => 'Nombre total d\'utilisateurs';

  @override
  String get admin_total_views => 'Vues totales';

  @override
  String get admin_error_loading_dashboard =>
      'Erreur de chargement du tableau de bord';

  @override
  String get admin_failed_to_load_data =>
      'Échec du chargement des données du tableau de bord';

  @override
  String get admin_avg_sale_price => 'Prix ​​de vente moyen';

  @override
  String get admin_avg_sale_price_subtitle => 'Toutes les annonces actives';

  @override
  String get admin_total_portfolio_value => 'Valeur totale du portefeuille';

  @override
  String get admin_total_portfolio_value_subtitle =>
      'Valeur combinée de la propriété';

  @override
  String get admin_avg_price_per_sqm => 'Prix ​​moyen par m²';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Indicateur de taux de marché';

  @override
  String get admin_property_types_distribution =>
      'Répartition des types de propriétés';

  @override
  String get admin_properties_by_city => 'Propriétés par ville';

  @override
  String get admin_properties_by_district => 'Propriétés par quartier';

  @override
  String get admin_inquiry_types_distribution =>
      'Répartition des types de demandes';

  @override
  String get admin_agent_verification_rate => 'Taux de vérification des agents';

  @override
  String get admin_agent_verification_rate_subtitle => 'Contrôle de qualité';

  @override
  String get admin_inquiry_response_rate => 'Taux de réponse aux demandes';

  @override
  String get admin_inquiry_response_rate_subtitle => 'Service client';

  @override
  String get admin_avg_views_per_property =>
      'Nombre moyen de vues par propriété';

  @override
  String get admin_avg_views_per_property_subtitle =>
      'Popularité de la propriété';

  @override
  String get admin_featured_properties => 'Propriétés en vedette';

  @override
  String get admin_featured_properties_subtitle => 'Annonces premium';

  @override
  String get admin_most_viewed_properties => 'Propriétés les plus consultées';

  @override
  String get admin_top_performing_agents => 'Agents les plus performants';

  @override
  String get admin_system_health => 'Santé du système';

  @override
  String get admin_properties_without_images => 'Propriétés sans images';

  @override
  String get admin_missing_location_data =>
      'Données de localisation manquantes';

  @override
  String get admin_pending_agent_verification =>
      'Vérification de l\'agent en attente';

  @override
  String get admin_active => 'actif';

  @override
  String get admin_verified => 'vérifié';

  @override
  String get admin_active_7d => 'actif (7j)';

  @override
  String get admin_this_month => 'ce mois-ci';

  @override
  String get agents_loading_pending_applications =>
      'Chargement des candidatures en attente...';

  @override
  String get agents_error_loading_applications =>
      'Erreur lors du chargement des applications';

  @override
  String get agents_pending_agents => 'Agents en attente';

  @override
  String get agents_total_pending_applications =>
      'Total des demandes en attente :';

  @override
  String get agents_pending_verification => 'En attente de vérification';

  @override
  String get agents_applied_date => 'Appliqué:';

  @override
  String get agents_contact_info => 'Coordonnées';

  @override
  String get agents_license_number => 'Numéro de licence';

  @override
  String get agents_years_experience => 'Années d\'expérience';

  @override
  String get agents_years_suffix => 'années';

  @override
  String get agents_total_sales => 'Ventes totales';

  @override
  String get agents_specialization => 'Spécialisation';

  @override
  String get agents_approve => 'Approuver';

  @override
  String get agents_reject => 'Rejeter';

  @override
  String get agents_no_pending_applications => 'Aucune candidature en attente';

  @override
  String get agents_all_applications_processed =>
      'Toutes les demandes d\'agent ont été traitées';

  @override
  String get general_previous => 'Précédent';

  @override
  String get general_page => 'Page';

  @override
  String get general_next => 'Suivant';

  @override
  String get general_views => 'vues';

  @override
  String get general_sales => 'ventes';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'russe';

  @override
  String get general_language_en => 'Anglais';

  @override
  String get general_super_admin => 'Super administrateur';

  @override
  String get general_staff => 'Personnel';

  @override
  String get general_verified_agent => 'Agent vérifié';

  @override
  String get general_pending_agent => 'Agent en attente';

  @override
  String get general_regular_user => 'Utilisateur régulier';

  @override
  String get general_admin => 'Administrateur';

  @override
  String get general_dashboard => 'Tableau de bord';

  @override
  String get general_manage_users => 'Gérer les utilisateurs';

  @override
  String get general_verified_agents => 'Agents vérifiés';

  @override
  String get general_agent_panel => 'Panneau d\'agent';

  @override
  String get general_create_property => 'Créer une propriété';

  @override
  String get general_my_properties => 'Mes propriétés';

  @override
  String get general_inquiries => 'Demandes de renseignements';

  @override
  String get general_agent_profile => 'Profil d\'agent';

  @override
  String get general_live => 'En direct';

  @override
  String get general_logged_out_successfully => 'Déconnecté avec succès';

  @override
  String get general_logout_completed_with_errors =>
      'Déconnexion terminée (avec erreurs)';

  @override
  String get general_application_under_review => 'Demande en cours d\'examen';

  @override
  String get general_check_status => 'Vérifier l\'état →';

  @override
  String get general_last_updated => 'Dernière mise à jour :';

  @override
  String get general_permissions_may_be_outdated =>
      'Les autorisations peuvent être obsolètes';

  @override
  String get general_permissions_up_to_date => 'Autorisations à jour';

  @override
  String get general_never => 'Jamais';

  @override
  String get general_properties_found => 'Propriétés trouvées';

  @override
  String get general_properties_saved => 'propriétés enregistrées';

  @override
  String get general_saved => 'enregistré';

  @override
  String get general_loading_properties => 'Chargement des propriétés...';

  @override
  String get general_failed_to_load =>
      'Échec du chargement des propriétés. Veuillez réessayer.';

  @override
  String get general_no_properties_found => 'Aucune propriété trouvée';

  @override
  String get general_try_adjusting =>
      'Essayez d\'ajuster vos critères de recherche';

  @override
  String get select_category => 'Sélectionnez la catégorie';

  @override
  String get service_description => 'Description des services';

  @override
  String get product_search_placeholder =>
      'Entrez un terme de recherche pour trouver des produits';

  @override
  String get privacy_policy => 'politique de confidentialité';

  @override
  String get terms_subtitle => 'Politique de confidentialité et conditions';

  @override
  String get last_updated => 'Dernière mise à jour';

  @override
  String get contact_information => 'Coordonnées';

  @override
  String get accept_terms => 'J\'accepte les termes et conditions';

  @override
  String get read_terms => 'Veuillez lire nos termes et conditions';

  @override
  String get inquiries => 'Demandes de renseignements et assistance';

  @override
  String get inquiries_subtitle => 'Contactez-nous pour obtenir de l\'aide';

  @override
  String get help_center => 'Comment pouvons-nous vous aider ?';

  @override
  String get help_subtitle =>
      'Nous sommes là pour vous aider pour toute question';

  @override
  String get contact_us => 'Contactez-nous';

  @override
  String get email_support => 'Assistance par e-mail';

  @override
  String get call_support => 'Appeler l\'assistance';

  @override
  String get send_message => 'Envoyer un message';

  @override
  String get fill_contact_form => 'Remplissez le formulaire de contact';

  @override
  String get contact_form => 'Formulaire de contact';

  @override
  String get name => 'Votre nom';

  @override
  String get name_required => 'Veuillez entrer votre nom';

  @override
  String get email => 'Adresse email';

  @override
  String get email_required => 'Veuillez entrer votre email';

  @override
  String get email_invalid => 'Veuillez entrer un email valide';

  @override
  String get subject => 'Sujet';

  @override
  String get subject_required => 'Veuillez entrer un sujet';

  @override
  String get message => 'Message';

  @override
  String get message_required => 'Veuillez entrer votre message';

  @override
  String get message_too_short =>
      'Le message doit contenir au moins 10 caractères';

  @override
  String get faq => 'Foire aux questions';

  @override
  String get follow_us => 'Suivez-nous';

  @override
  String get faq_how_to_sell => 'Comment vendre des articles sur Tezsell ?';

  @override
  String get faq_how_to_sell_answer =>
      'Pour vendre des articles : 1) Créez un compte, 2) Appuyez sur le bouton « + », 3) Choisissez la catégorie (Produits/Services/Immobilier), 4) Ajoutez des photos et une description, 5) Fixez votre prix, 6) Publiez ! Votre annonce sera visible pour les acheteurs de votre région.';

  @override
  String get faq_is_free => 'L\'utilisation de Tezsell est-elle gratuite ?';

  @override
  String get faq_is_free_answer =>
      'Oui! Tezsell est actuellement 100% gratuit. Pas de frais d\'inscription, pas de commission sur les ventes, pas de frais d\'abonnement. Nous pourrions introduire des fonctionnalités premium à l’avenir, mais nous en informerons les utilisateurs 30 jours à l’avance.';

  @override
  String get faq_safety =>
      'Comment puis-je rester en sécurité lors de l’achat/vente ?';

  @override
  String get faq_safety_answer =>
      'Conseils de sécurité : 1) Rendez-vous dans des lieux publics, 2) Inspectez les articles avant de payer, 3) N\'envoyez jamais d\'argent à des inconnus, 4) Faites confiance à votre instinct, 5) Signalez les utilisateurs suspects, 6) Ne partagez pas d\'informations personnelles trop tôt, 7) Amenez un ami pour des transactions de grande valeur.';

  @override
  String get faq_payment => 'Comment fonctionnent les paiements ?';

  @override
  String get faq_payment_answer =>
      'Tezsell ne traite pas les paiements. Acheteurs et vendeurs organisent directement le paiement (espèces, virement bancaire, etc.). Nous ne sommes qu\'une plateforme pour connecter les gens - vous gérez vous-mêmes la transaction.';

  @override
  String get faq_prohibited => 'Quels sont les articles interdits ?';

  @override
  String get faq_prohibited_answer =>
      'Les articles interdits comprennent : les armes, les drogues, les biens volés, les articles contrefaits, le contenu réservé aux adultes, les animaux vivants (sans permis), les pièces d\'identité gouvernementales et les matières dangereuses. Consultez nos conditions générales pour la liste complète.';

  @override
  String get faq_account_delete => 'Comment supprimer mon compte ?';

  @override
  String get faq_account_delete_answer =>
      'Accédez à Profil → Paramètres → Paramètres du compte → Supprimer le compte. Remarque : Ceci est permanent et ne peut être annulé. Toutes vos annonces seront supprimées.';

  @override
  String get faq_report_user =>
      'Comment signaler un utilisateur ou une annonce ?';

  @override
  String get faq_report_user_answer =>
      'Appuyez sur les trois points (•••) sur n\'importe quelle liste ou profil utilisateur, puis sélectionnez « Signaler ». Choisissez la raison et soumettez. Nous examinons tous les rapports dans les 24 à 48 heures.';

  @override
  String get faq_change_location => 'Comment puis-je changer de localisation ?';

  @override
  String get faq_change_location_answer =>
      'Appuyez sur le bouton de localisation dans le coin supérieur gauche de l\'écran d\'accueil. Vous pouvez sélectionner votre région et votre district pour voir les annonces dans votre région.';

  @override
  String get welcome_customer_center => 'Bienvenue dans l\'Espace Client';

  @override
  String get customer_center_subtitle =>
      'Nous sommes là pour vous aider 24h/24 et 7j/7';

  @override
  String get quick_actions => 'Actions rapides';

  @override
  String get live_chat => 'Chat en direct';

  @override
  String get chat_with_us => 'Discutez avec nous';

  @override
  String get find_answers => 'Trouver des réponses';

  @override
  String get my_tickets => 'Mes billets';

  @override
  String get view_tickets => 'Voir les billets';

  @override
  String get feedback => 'Retour';

  @override
  String get share_feedback => 'Partager vos commentaires';

  @override
  String get contact_methods => 'Méthodes de contact';

  @override
  String get phone_support => 'Assistance téléphonique';

  @override
  String get available_247 => 'Disponible 24h/24 et 7j/7';

  @override
  String get response_24h => 'Réponse sous 24 heures';

  @override
  String get telegram_support => 'Prise en charge des télégrammes';

  @override
  String get instant_replies => 'Réponses instantanées';

  @override
  String get whatsapp_support => 'Assistance WhatsApp';

  @override
  String get quick_response => 'Réponse rapide';

  @override
  String get popular_topics => 'Sujets populaires';

  @override
  String get account_management => 'Gestion des comptes';

  @override
  String get reset_password => 'Réinitialiser le mot de passe';

  @override
  String get update_profile => 'Mettre à jour le profil';

  @override
  String get verify_account => 'Vérifier le compte';

  @override
  String get delete_account => 'Supprimer le compte';

  @override
  String get buying_selling => 'Acheter et vendre';

  @override
  String get how_to_post => 'Comment publier des annonces';

  @override
  String get payment_methods => 'Méthodes de paiement';

  @override
  String get shipping_delivery => 'Expédition et livraison';

  @override
  String get return_policy => 'Politique de retour';

  @override
  String get safety_security => 'Sûreté et sécurité';

  @override
  String get report_scam => 'Signaler une arnaque';

  @override
  String get safe_trading => 'Conseils de trading sécurisé';

  @override
  String get privacy_settings => 'Paramètres de confidentialité';

  @override
  String get blocked_users => 'Utilisateurs bloqués';

  @override
  String get technical_issues => 'Problèmes techniques';

  @override
  String get app_not_working => 'L\'application ne fonctionne pas';

  @override
  String get upload_failed => 'Échec du téléchargement';

  @override
  String get login_problems => 'Problèmes de connexion';

  @override
  String get support_hours => 'Heures d\'assistance';

  @override
  String get mon_fri_9_6 => 'Du lundi au vendredi : de 9h00 à 18h00';

  @override
  String get how_are_we_doing => 'Comment allons-nous ?';

  @override
  String get rate_experience => 'Évaluez votre expérience de service client';

  @override
  String get poor => 'Pauvre';

  @override
  String get okay => 'D\'accord';

  @override
  String get good => 'Bien';

  @override
  String get excellent => 'Excellent';

  @override
  String get account_secure => 'Votre compte est sécurisé';

  @override
  String get password_security => 'Mot de passe et authentification';

  @override
  String get change_password => 'Changer le mot de passe';

  @override
  String get two_factor_auth => 'Authentification à deux facteurs';

  @override
  String get biometric_login => 'Connexion biométrique';

  @override
  String get login_activity => 'Activité de connexion';

  @override
  String get active_sessions => 'Séances actives';

  @override
  String get login_alerts => 'Alertes de connexion';

  @override
  String get account_protection => 'Protection du compte';

  @override
  String get recovery_email => 'E-mail de récupération';

  @override
  String get backup_codes => 'Codes de sauvegarde';

  @override
  String get danger_zone => 'Zone dangereuse';

  @override
  String get improve_security => 'Améliorer la sécurité';

  @override
  String get security_score => 'Score de sécurité';

  @override
  String get last_changed_days => 'Dernière modification il y a 30 jours';

  @override
  String get logout_all_devices => 'Déconnecter tous les appareils';

  @override
  String get end_all_sessions => 'Terminer toutes les sessions';

  @override
  String get permanently_delete => 'Supprimer définitivement';

  @override
  String get verification_code_message =>
      'Nous vous enverrons un code de vérification pour confirmer qu\'il s\'agit bien de vous.';

  @override
  String get send_code => 'Envoyer le code';

  @override
  String get enter_verification_code => 'Entrez le code de vérification';

  @override
  String get verification_code => 'Le code de vérification';

  @override
  String get new_password => 'Nouveau mot de passe';

  @override
  String get confirm_password => 'Confirmez le mot de passe';

  @override
  String get resend_code => 'Renvoyer le code';

  @override
  String get code_sent_to => 'Entrez le code de vérification envoyé à';

  @override
  String get enter_code => 'Entrez le code de vérification';

  @override
  String get code_must_be_6_digits => 'Le code doit être composé de 6 chiffres';

  @override
  String get enter_new_password => 'Entrez le nouveau mot de passe';

  @override
  String get minimum_8_characters => 'Minimum 8 caractères';

  @override
  String get passwords_do_not_match => 'Les mots de passe ne correspondent pas';

  @override
  String get close => 'Fermer';

  @override
  String get current => 'Actuel';

  @override
  String get session_ended => 'Séance terminée';

  @override
  String get update_recovery_email => 'Mettre à jour l\'e-mail de récupération';

  @override
  String get new_email => 'Nouvel e-mail';

  @override
  String get update => 'Mise à jour';

  @override
  String get verification_email_sent => 'E-mail de vérification envoyé';

  @override
  String get generate_emergency_codes => 'Générer des codes d\'urgence';

  @override
  String get copy_all => 'Copier tout';

  @override
  String get code_copied => 'Code copié';

  @override
  String get all_codes_copied => 'Tous les codes copiés';

  @override
  String get logout_all_devices_confirm =>
      'Se déconnecter de tous les appareils ?';

  @override
  String get logout_all_devices_message =>
      'Cela mettra fin à toutes les sessions actives sur tous les appareils.';

  @override
  String get logout_all => 'Tout déconnecter';

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
  String get delete_account_confirm => 'Supprimer le compte ?';

  @override
  String get delete_account_warning =>
      'Cette action est PERMANENTE et irréversible. Toutes vos données seront définitivement supprimées.';

  @override
  String get what_will_be_deleted => 'Ce qui sera supprimé :';

  @override
  String get profile_and_account_info =>
      '• Votre profil et les informations de votre compte';

  @override
  String get all_listings_and_posts => '• Toutes vos annonces et publications';

  @override
  String get messages_and_conversations => 'Messages';

  @override
  String get saved_items_and_preferences =>
      '• Éléments et préférences enregistrés';

  @override
  String get enter_password_to_continue =>
      'Entrez votre mot de passe pour continuer';

  @override
  String get continue_val => 'Continuer';

  @override
  String get please_enter_password => 'Veuillez entrer votre mot de passe';

  @override
  String get enter_confirmation_code => 'Entrez le code de confirmation';

  @override
  String get deletion_confirmation_message =>
      'Nous avons envoyé un code de confirmation sur votre téléphone. Saisissez-le ci-dessous pour supprimer définitivement votre compte.';

  @override
  String get confirmation_code => 'Code de confirmation';

  @override
  String get please_enter_6_digit_code =>
      'Veuillez saisir le code à 6 chiffres';

  @override
  String get account_deleted => 'Votre compte a été supprimé';

  @override
  String get deletion_cancelled => 'Suppression annulée';

  @override
  String get failed_to_load_user_info =>
      'Échec du chargement des informations utilisateur';

  @override
  String get auth_login_to_view_saved =>
      'Veuillez vous connecter pour voir vos propriétés enregistrées';

  @override
  String get authLoginRequired => 'Connexion requise';

  @override
  String get authLoginToViewSaved =>
      'Veuillez vous connecter pour voir vos propriétés enregistrées';

  @override
  String get authLogin => 'Se connecter';

  @override
  String get savedPropertiesTitle => 'Propriétés enregistrées';

  @override
  String get loadingSavedProperties =>
      'Chargement des propriétés enregistrées...';

  @override
  String get errorsFailedToLoadSaved =>
      'Échec du chargement des propriétés enregistrées';

  @override
  String get actionsRetry => 'Réessayer';

  @override
  String get savedPropertiesNoSaved => 'Aucune propriété enregistrée';

  @override
  String get savedPropertiesStartSaving =>
      'Commencez à explorer et enregistrez les propriétés que vous aimez';

  @override
  String get savedPropertiesBrowse => 'Parcourir les propriétés';

  @override
  String get resultsSavedProperties => 'propriétés enregistrées';

  @override
  String get actionsRefresh => 'Rafraîchir';

  @override
  String get resultsNoMoreProperties => 'Plus de propriétés';

  @override
  String get propertyCardFeatured => 'En vedette';

  @override
  String get successPropertyUnsaved =>
      'Propriété supprimée de la liste enregistrée';

  @override
  String get alertsUnsavePropertyFailed =>
      'Échec de la suppression de la propriété';

  @override
  String get propertyCardBed => 'lit';

  @override
  String get propertyCardBath => 'bain';

  @override
  String get savedPropertiesSavedOn => 'Enregistré le';

  @override
  String get propertyCardViewDetails => 'Afficher les détails';

  @override
  String get serviceDetailTitle => 'Détail du service';

  @override
  String get errorLoadingFavorites =>
      'Erreur lors du chargement des éléments favoris';

  @override
  String get noFavoritesFound => 'Aucun article favori trouvé.';

  @override
  String get commentUpdatedSuccess => 'Commentaire mis à jour avec succès !';

  @override
  String get errorUpdatingComment =>
      'Erreur lors de la mise à jour du commentaire';

  @override
  String get replyAddedSuccess => 'Réponse ajoutée avec succès !';

  @override
  String get errorAddingReply => 'Erreur lors de l\'ajout de la réponse';

  @override
  String get commentDeletedSuccess => 'Commentaire supprimé avec succès !';

  @override
  String get errorDeletingComment =>
      'Erreur lors de la suppression du commentaire';

  @override
  String get serviceLikedSuccess => 'Service apprécié avec succès !';

  @override
  String get errorLikingService => 'Erreur en aimant le service';

  @override
  String get serviceDislikedSuccess => 'Service détesté avec succès !';

  @override
  String get errorDislikingService => 'Erreur : je n\'aime pas le service';

  @override
  String get writeYourReply => 'Écrivez votre réponse...';

  @override
  String get postReply => 'Publier une réponse';

  @override
  String get anonymous => 'Anonyme';

  @override
  String get editComment => 'Modifier le commentaire';

  @override
  String get editYourComment => 'Modifiez votre commentaire...';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get propertyOwner => 'Propriétaire foncier';

  @override
  String get errorLoadingServices => 'Erreur lors du chargement des services';

  @override
  String get noRecommendedServicesFound => 'Aucun service recommandé trouvé.';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get passwordRequirements =>
      'Le mot de passe doit contenir des lettres et des chiffres';

  @override
  String get usernameRequired => 'Le nom d\'utilisateur est requis';

  @override
  String get usernameTooShort =>
      'Le nom d\'utilisateur doit comporter au moins 3 caractères';

  @override
  String get confirmPasswordRequired =>
      'Une confirmation du mot de passe est requise';

  @override
  String get passwordHelp => 'Au moins 8 caractères, lettres et chiffres';

  @override
  String get usernameExists => 'Ce nom d\'utilisateur existe déjà';

  @override
  String get phoneExists => 'Ce numéro de téléphone est déjà enregistré';

  @override
  String get networkError =>
      'Erreur de connexion réseau. Veuillez vérifier votre connexion';

  @override
  String get contactSeller => 'Contacter le vendeur';

  @override
  String get callToReveal => 'Appuyez sur \"Appeler\" pour révéler';

  @override
  String get camera => 'Caméra';

  @override
  String get gallery => 'Galerie';

  @override
  String get selectImageSource => 'Sélectionnez la source de l\'image';

  @override
  String get uploading => 'Téléchargement...';

  @override
  String get acceptTermsRequired =>
      'Vous devez accepter les termes et conditions pour continuer';

  @override
  String get iAgreeToTerms => 'J\'accepte le';

  @override
  String get termsAndConditions => 'Termes et conditions';

  @override
  String get zeroToleranceStatement =>
      'et comprenez qu\'il n\'y a aucune tolérance pour les contenus répréhensibles ou les utilisateurs abusifs.';

  @override
  String get viewTerms => 'Voir les termes et conditions';

  @override
  String get reportContent => 'Contenu du rapport';

  @override
  String get selectReportReason =>
      'Veuillez sélectionner un motif de signalement :';

  @override
  String get additionalDetails => 'Détails supplémentaires (facultatif)';

  @override
  String get reportDetailsHint =>
      'Fournissez toute information supplémentaire...';

  @override
  String get reportSubmitted =>
      'Merci pour votre rapport. Nous l\'examinerons dans les 24 heures.';

  @override
  String get reportProduct => 'Produit de rapport';

  @override
  String get reportService => 'Service de rapports';

  @override
  String get reportMessage => 'Message de rapport';

  @override
  String get reportUser => 'Signaler un utilisateur';

  @override
  String get reportErrorNotImplemented =>
      'La fonction de création de rapports n\'est pas encore disponible. Veuillez contacter l\'assistance ou réessayer plus tard.';

  @override
  String get reportAlreadySubmitted =>
      'Vous avez déjà signalé ce contenu. Nous examinons votre rapport précédent.';

  @override
  String get reportFailedGeneric =>
      'Échec de la soumission du rapport. Veuillez réessayer.';

  @override
  String get reportFailedNetwork =>
      'Une erreur réseau s\'est produite. Veuillez vérifier votre connexion et réessayer.';

  @override
  String get becomeAgentTitle => 'Rejoignez-nous en tant qu\'agent immobilier';

  @override
  String get becomeAgentSubtitle =>
      'Répertoriez les propriétés et aidez les clients à trouver la maison de leurs rêves';

  @override
  String get agentBenefits => 'Avantages:';

  @override
  String get agentBenefitVerified => 'Badge d\'agent vérifié';

  @override
  String get agentBenefitAnalytics => 'Accès aux analyses et aux informations';

  @override
  String get agentBenefitClients =>
      'Contact direct avec des clients potentiels';

  @override
  String get agentBenefitReputation =>
      'Construisez votre réputation professionnelle';

  @override
  String get agentApplicationForm => 'Formulaire de candidature';

  @override
  String get agentAgencyName => 'Nom de l\'agence';

  @override
  String get agentAgencyNameHint => 'Entrez le nom de votre agence immobilière';

  @override
  String get agentAgencyNameRequired => 'Le nom de l\'agence est requis';

  @override
  String get agentLicenceNumber => 'Numéro de licence';

  @override
  String get agentLicenceNumberHint =>
      'Entrez votre numéro de licence immobilière';

  @override
  String get agentLicenceNumberRequired => 'Le numéro de licence est requis';

  @override
  String get agentYearsExperience => 'Années d\'expérience';

  @override
  String get agentYearsExperienceHint => 'Entrez le nombre d\'années';

  @override
  String get agentYearsExperienceRequired =>
      'Des années d\'expérience sont requises';

  @override
  String get agentYearsExperienceInvalid => 'Veuillez entrer un numéro valide';

  @override
  String get agentSpecialization => 'Spécialisation';

  @override
  String get agentApplicationNote =>
      'Votre candidature sera examinée par notre équipe. Vous serez informé une fois votre candidature approuvée.';

  @override
  String get agentSubmitApplication => 'Soumettre la candidature';

  @override
  String get agentApplicationSubmitted =>
      'Candidature soumise avec succès ! Nous l\'examinerons bientôt.';

  @override
  String get agentApplicationStatus => 'Statut de la demande';

  @override
  String get agentViewProfile => 'Consultez votre profil d\'agent';

  @override
  String get agentDashboardComingSoon =>
      'Le tableau de bord des agents sera bientôt disponible !';

  @override
  String get property_create_basic_information => 'Informations de base';

  @override
  String get property_create_property_title => 'Titre de la propriété *';

  @override
  String get property_create_property_title_hint =>
      'par exemple, appartement moderne 3BR dans le centre-ville';

  @override
  String get property_create_property_title_required =>
      'Veuillez saisir le titre de propriété';

  @override
  String get property_create_description => 'Description *';

  @override
  String get property_create_description_hint =>
      'Décrivez votre bien en détail...';

  @override
  String get property_create_description_required =>
      'Veuillez saisir une description';

  @override
  String get property_create_property_type => 'Type de propriété';

  @override
  String get property_create_property_type_required => 'Type de propriété *';

  @override
  String get property_create_listing_type_required => 'Type d\'annonce *';

  @override
  String get property_create_pricing => 'Tarifs';

  @override
  String get property_create_price => 'Prix ​​*';

  @override
  String get property_create_price_hint => 'Entrez le prix';

  @override
  String get property_create_price_required => 'Veuillez entrer le prix';

  @override
  String get property_create_currency => 'Devise';

  @override
  String get property_create_property_details => 'Détails de la propriété';

  @override
  String get property_create_square_meters => 'Carré. Mètres *';

  @override
  String get property_create_bedrooms => 'Chambres *';

  @override
  String get property_create_bathrooms => 'Salles de bains *';

  @override
  String get property_create_floor => 'Sol';

  @override
  String get property_create_total_floors => 'Nombre total d\'étages';

  @override
  String get property_create_parking => 'Parking';

  @override
  String get property_create_year_built => 'Année de construction';

  @override
  String get property_create_location => 'Emplacement';

  @override
  String get property_create_address => 'Adresse *';

  @override
  String get property_create_address_hint =>
      'Entrez l\'adresse de la propriété';

  @override
  String get property_create_address_required => 'Veuillez entrer l\'adresse';

  @override
  String get property_create_location_detected => 'Emplacement détecté';

  @override
  String get property_create_get_location => 'Obtenir l\'emplacement actuel';

  @override
  String get property_create_features => 'Caractéristiques';

  @override
  String get property_create_feature_balcony => 'Balcon';

  @override
  String get property_create_feature_garage => 'Garage';

  @override
  String get property_create_feature_garden => 'Jardin';

  @override
  String get property_create_feature_pool => 'Piscine';

  @override
  String get property_create_feature_elevator => 'Ascenseur';

  @override
  String get property_create_feature_furnished => 'Meublé';

  @override
  String get property_create_images => 'Images de la propriété';

  @override
  String get property_create_tap_to_add_images =>
      'Appuyez pour ajouter des images';

  @override
  String get property_create_at_least_one_image => 'Au moins 1 image requise';

  @override
  String get property_create_add_more => 'Ajouter plus';

  @override
  String get property_create_required => 'Requis';

  @override
  String get property_create_location_required =>
      'Veuillez activer les services de localisation pour créer une propriété';

  @override
  String get property_create_image_required =>
      'Au moins une image de propriété est requise';

  @override
  String get emailVerification => 'Vérification par e-mail';

  @override
  String get pleaseEnterYourEmailAddress =>
      'Veuillez entrer votre adresse e-mail';

  @override
  String get enterEmailAddress => 'Entrez l\'adresse e-mail';

  @override
  String get resetYourPassword => 'Réinitialisez votre mot de passe';

  @override
  String get resetPasswordDescription =>
      'Entrez votre adresse e-mail et nous vous enverrons un code de vérification pour réinitialiser votre mot de passe.';

  @override
  String get sendVerificationCode => 'Envoyer le code de vérification';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String enterVerificationCodeSentTo(String email) {
    return 'Saisissez le code de vérification envoyé à $email';
  }

  @override
  String get codeMustBe6Digits => 'Le code doit être composé de 6 chiffres';

  @override
  String get enterNewPassword => 'Entrez le nouveau mot de passe';

  @override
  String get minimum8Characters => 'Minimum 8 caractères';

  @override
  String get sending => 'Envoi...';

  @override
  String get verifying => 'Vérification...';

  @override
  String get new_message => 'Nouveau message';

  @override
  String get messages => 'Messages';

  @override
  String get please_log_in => 'Veuillez vous connecter pour voir les messages';

  @override
  String get pin => 'Épingle';

  @override
  String get unpin => 'Détacher';

  @override
  String get delete_chat => 'Supprimer le chat';

  @override
  String delete_chat_confirm(String name) {
    return 'Êtes-vous sûr de vouloir supprimer le chat avec $name ? Cette action ne peut pas être annulée.';
  }

  @override
  String chat_deleted(String name) {
    return 'Chat avec $name supprimé';
  }

  @override
  String get delete_failed => 'Échec de la suppression du chat';

  @override
  String get no_conversations => 'Aucune conversation pour l\'instant';

  @override
  String get start_conversation_hint =>
      'Démarrez une conversation en appuyant sur le bouton +';

  @override
  String get start_conversation => 'Démarrer une conversation';

  @override
  String get yesterday => 'Hier';

  @override
  String get unknown => 'Inconnu';

  @override
  String get no_messages_yet => 'Pas encore de messages';

  @override
  String get unblock_user => 'Débloquer l\'utilisateur';

  @override
  String get block_user => 'Bloquer l\'utilisateur';

  @override
  String get no_blocked_users => 'Aucun utilisateur bloqué';

  @override
  String get blocked_users_hint =>
      'Les utilisateurs que vous bloquez apparaîtront ici';

  @override
  String unblock_user_confirm(String username) {
    return 'Êtes-vous sûr de vouloir débloquer $username ? Vous pourrez à nouveau recevoir des messages de leur part.';
  }

  @override
  String user_unblocked(String username) {
    return '$username a été débloqué';
  }

  @override
  String user_blocked(String username) {
    return '$username a été bloqué';
  }

  @override
  String get failed_to_unblock => 'Échec du déblocage de l\'utilisateur';

  @override
  String get failed_to_block => 'Échec du blocage de l\'utilisateur';

  @override
  String get chat_info => 'Informations sur le chat';

  @override
  String get delete_message => 'Supprimer le message';

  @override
  String get delete_message_confirm =>
      'Êtes-vous sûr de vouloir supprimer ce message ?';

  @override
  String get typing => 'dactylographie...';

  @override
  String get online => 'en ligne';

  @override
  String get offline => 'hors ligne';

  @override
  String last_seen_at(String time) {
    return 'vu pour la dernière fois $time';
  }

  @override
  String participants(int count) {
    return '$count participants';
  }

  @override
  String get you_are_blocked => 'Vous êtes bloqué';

  @override
  String user_blocked_you(String username) {
    return '$username vous a bloqué. Vous ne pouvez pas envoyer de messages.';
  }

  @override
  String you_blocked_user(String username) {
    return 'Vous avez bloqué $username';
  }

  @override
  String get cannot_send_messages_blocked =>
      'Vous ne pouvez pas envoyer de messages. Vous avez été bloqué.';

  @override
  String get this_message_was_deleted => 'Ce message a été supprimé';

  @override
  String get edit => 'Modifier';

  @override
  String get reply => 'Répondre';

  @override
  String get editing_message => 'Modification du message';

  @override
  String replying_to(String username) {
    return 'Répondre à $username';
  }

  @override
  String get voice => 'Voix';

  @override
  String get emoji => 'Émoji';

  @override
  String get photo => '📷Photos';

  @override
  String get voice_message => '🎤 Message vocal';

  @override
  String get searching => 'Recherche...';

  @override
  String get loading_users => 'Chargement des utilisateurs...';

  @override
  String search_failed(String error) {
    return 'Échec de la recherche : $error';
  }

  @override
  String get invalid_user_data => 'Données utilisateur invalides';

  @override
  String failed_to_start_chat(String error) {
    return 'Échec du démarrage du chat : $error';
  }

  @override
  String get audio_file_not_available => 'Fichier audio non disponible';

  @override
  String failed_to_play_audio(String error) {
    return 'Échec de la lecture audio : $error';
  }

  @override
  String get image_unavailable => 'Image indisponible';

  @override
  String get image_too_large =>
      '❌ L\'image est trop grande. La taille maximale est de 10 Mo';

  @override
  String get image_file_not_found => '❌ Fichier image introuvable';

  @override
  String get uploading_image => 'Téléchargement de l\'image...';

  @override
  String get image_sent => '✅Image envoyée !';

  @override
  String get failed_to_send_image => '❌ Échec de l\'envoi de l\'image';

  @override
  String get uploading_voice_message => 'Téléchargement du message vocal...';

  @override
  String get voice_message_sent => '✅Message vocal envoyé !';

  @override
  String get failed_to_send_voice_message =>
      '❌ Échec de l\'envoi du message vocal';

  @override
  String get recording => '🎙️Enregistrement...';

  @override
  String get microphone_permission_denied =>
      'Autorisation du microphone refusée';

  @override
  String get starting_chat => 'Démarrage du chat...';

  @override
  String get refresh_users => 'Actualiser les utilisateurs';

  @override
  String get search_by_username_or_phone =>
      'Rechercher par nom d\'utilisateur ou numéro de téléphone';

  @override
  String get no_users_found => 'Aucun utilisateur trouvé';

  @override
  String get try_different_search_term => 'Essayez un autre terme de recherche';

  @override
  String get no_users_available => 'Aucun utilisateur disponible';

  @override
  String get chat_exists => 'Le chat existe';

  @override
  String block_user_confirm(String username) {
    return 'Êtes-vous sûr de vouloir bloquer $username ? Vous ne recevrez pas de messages de leur part et ils seront supprimés de votre liste de discussion.';
  }

  @override
  String chat_room_label(String name) {
    return 'Salon de discussion : $name';
  }

  @override
  String id_label(int id) {
    return 'Identifiant : $id';
  }

  @override
  String get participants_label => 'Participants :';

  @override
  String get type_a_message => 'Tapez un message...';

  @override
  String get edit_message_hint => 'Modifier le message...';

  @override
  String error_label(String error) {
    return 'Erreur : $error';
  }

  @override
  String get copy => 'Copie';

  @override
  String comments_title(int count) {
    return 'Commentaires ($count)';
  }

  @override
  String get reply_button => 'Répondre';

  @override
  String replies_count(int count) {
    return '$count répond';
  }

  @override
  String get you_label => 'Toi';

  @override
  String get delete_reply_title => 'Supprimer la réponse';

  @override
  String get delete_comment_title => 'Supprimer le commentaire';

  @override
  String get unknown_date => 'Date inconnue';

  @override
  String get press_enter_to_send => 'Appuyez sur Entrée pour envoyer';

  @override
  String get comment_add_error => 'Échec de l\'ajout d\'un commentaire';

  @override
  String get service_provider => 'Fournisseur de services';

  @override
  String get opening_chat => 'Ouverture du chat...';

  @override
  String get failed_to_refresh => 'Échec de l\'actualisation';

  @override
  String get cannot_chat_with_yourself =>
      'Vous ne pouvez pas discuter avec vous-même';

  @override
  String opening_chat_with(String username) {
    return 'Ouverture du chat avec $username...';
  }

  @override
  String get this_will_only_take_a_moment => 'Cela ne prendra qu\'un instant';

  @override
  String get unable_to_start_chat =>
      'Impossible de démarrer le chat. Veuillez réessayer.';

  @override
  String get profile_listings => 'Annonces';

  @override
  String get profile_followers => 'Abonnés';

  @override
  String get profile_following => 'Suivant';

  @override
  String get profile_no_products => 'Aucun produit';

  @override
  String get profile_no_services => 'Aucun service';

  @override
  String get profile_no_properties => 'Aucune propriété';

  @override
  String get profile_user_no_products =>
      'Cet utilisateur n\'a pas encore publié de produits';

  @override
  String get profile_user_no_services =>
      'Cet utilisateur n\'a pas encore publié de services';

  @override
  String get profile_user_no_properties =>
      'Cet utilisateur n\'a pas encore publié de propriétés';

  @override
  String get profile_error_occurred => 'Une erreur s\'est produite';

  @override
  String get profile_error_loading_products =>
      'Erreur lors du chargement des produits';

  @override
  String get profile_error_loading_services =>
      'Erreur lors du chargement des services';

  @override
  String get profile_no_followers_yet => 'Pas encore d\'abonnés';

  @override
  String get profile_no_following_yet => 'Je ne suis encore personne';

  @override
  String get profile_follow => 'Suivre';

  @override
  String get profile_following_btn => 'Suivant';

  @override
  String get profile_message => 'Message';

  @override
  String get profile_member_since => 'Membre depuis';

  @override
  String get profile_loading_error => 'Erreur de chargement du profil';

  @override
  String get profile_retry => 'Essayer à nouveau';

  @override
  String get profile_share => 'Partager';

  @override
  String get profile_copy_link => 'Copier le lien';

  @override
  String get profile_report => 'Rapport';

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
  String get linkCopied => 'Lien copié dans le presse-papier';

  @override
  String get checkOutProfile => 'Vérifier';

  @override
  String get onTezsell => 'sur TezSell';

  @override
  String get selectCountryFirst => 'Sélectionnez d\'abord le pays';

  @override
  String get countrySelectionHint =>
      'Ensuite, vous pouvez choisir votre région';

  @override
  String get something_went_wrong => 'Quelque chose s\'est mal passé';

  @override
  String get check_connection_and_retry =>
      'Veuillez vérifier votre connexion Internet et réessayer';

  @override
  String get sold_badge => 'VENDU';

  @override
  String get reserved_badge => 'RESERVED';

  @override
  String get recently_viewed_title => 'Recently viewed';

  @override
  String get more_categories => 'Plus';

  @override
  String no_products_in_location(String location) {
    return 'Aucun produit trouvé dans $location';
  }

  @override
  String get no_more_products => 'Plus de produits à charger';

  @override
  String time_days_ago(int count) {
    return 'Il y a ${count}j';
  }

  @override
  String time_hours_ago(int count) {
    return 'Il y a ${count}h';
  }

  @override
  String time_minutes_ago(int count) {
    return 'il y a ${count}m';
  }

  @override
  String get time_just_now => 'Tout à l\' heure';

  @override
  String no_services_in_location(String location) {
    return 'Aucun service trouvé dans $location';
  }

  @override
  String get no_more_services => 'Plus de services à charger';

  @override
  String get error_loading_more_services =>
      'Erreur lors du chargement de plus de services';

  @override
  String get verification_code_length =>
      'Le code de vérification doit être composé de 6 chiffres';

  @override
  String get map_register_title => 'Où  habites-tu?';

  @override
  String get map_register_headline => 'Choisissez votre quartier sur la carte';

  @override
  String get map_register_subtitle =>
      'Nous l\'utilisons pour vous montrer les acheteurs et les vendeurs à proximité. Vous pourrez ajuster votre rayon plus tard.';

  @override
  String get pick_on_map => 'Choisir sur la carte';

  @override
  String get pick_again => 'Choisissez à nouveau';

  @override
  String get resolving_location => 'Résolution de l\'emplacement…';

  @override
  String get use_dropdown_instead => 'Utilisez plutôt la liste déroulante';

  @override
  String country_not_supported(String country) {
    return 'Nous ne prenons pas encore en charge $country.';
  }

  @override
  String get region_not_auto_detected =>
      'Impossible de détecter automatiquement votre région : sélectionnez-la manuellement.';

  @override
  String get district_not_auto_detected =>
      'Impossible de détecter automatiquement votre district : sélectionnez-le manuellement.';

  @override
  String get browse_no_items_with_location =>
      'Aucun élément avec des données de localisation dans cette zone pour l\'instant.';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => 'Définir l\'emplacement';

  @override
  String get location_picker_confirm => 'Confirmer l\'emplacement';

  @override
  String get location_picker_resolve_failed =>
      'Impossible de résoudre l\'adresse : choisissez à nouveau ou confirmez avec les coordonnées uniquement';

  @override
  String get location_picker_selected_fallback => 'Emplacement sélectionné';

  @override
  String get location_permission_denied =>
      'Autorisation de localisation refusée';

  @override
  String get location_permission_denied_settings =>
      'Autorisation de localisation refusée – veuillez l\'activer dans Paramètres';

  @override
  String get location_permission_permanent =>
      'Localisation définitivement refusée : ouvrez les paramètres pour l\'activer.';

  @override
  String gps_error(String error) {
    return 'Erreur GPS : $error';
  }

  @override
  String get verify_neighborhood_title => 'Vérifiez votre quartier';

  @override
  String get verify_neighborhood_subtitle =>
      'Tenez-vous dans votre quartier. Nous vérifierons votre GPS et vous demanderons de confirmer.';

  @override
  String get verify_neighborhood_button => 'Vérifier le quartier';

  @override
  String get verify_neighborhood_low_confidence =>
      'Continuer avec une faible confiance';

  @override
  String get verify_neighborhood_retry => 'Réessayer';

  @override
  String get verify_neighborhood_youre_in => 'Vous êtes dans :';

  @override
  String verify_neighborhood_done(String name) {
    return 'Vérifié ! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'La précision du GPS est de ${meters}m (besoin ≤100m). Déplacez-vous vers une zone dégagée et réessayez.';
  }

  @override
  String get neighborhood_not_identified =>
      'Impossible d\'identifier le quartier correspondant à votre emplacement.';

  @override
  String get unknown_error => 'Erreur inconnue';

  @override
  String get place_search_hint => 'Rechercher une adresse ou un lieu';

  @override
  String get place_search_unavailable =>
      'Recherche indisponible : déposez une épingle à la place';

  @override
  String get radius_slider_city => 'Ville';

  @override
  String radius_slider_km(String value) {
    return '${value}km';
  }

  @override
  String get my_neighborhoods => 'Mes quartiers';

  @override
  String get manage_on_map => 'Gérer sur la carte';

  @override
  String get no_neighborhoods_yet =>
      'Aucun quartier vérifié pour l\'instant. Ouvrez la carte pour vérifier où vous êtes.';

  @override
  String get open_map_to_verify =>
      'Ouvrir la carte pour vérifier un nouveau lieu';

  @override
  String get verify_here => 'Vérifier ici';

  @override
  String get verify_new_location => 'Vérifier un nouveau lieu';

  @override
  String eviction_warning(String name) {
    return 'L\'ajout de ce lieu supprimera $name (votre plus ancien). Cette action est irréversible.';
  }

  @override
  String get verified_today => 'Vérifié aujourd\'hui';

  @override
  String get verified_yesterday => 'Vérifié hier';

  @override
  String verified_n_days_ago(int days) {
    return 'Vérifié il y a $days jours';
  }

  @override
  String get active_neighborhood => 'Actif';

  @override
  String switch_neighborhood_success(String name) {
    return 'Basculé vers $name';
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

  @override
  String get view => 'View';

  @override
  String get more_options => 'More options';

  @override
  String get mark_as_sold => 'Mark as sold';

  @override
  String get back_to_available => 'Back to available';

  @override
  String get hide_listing => 'Hide';

  @override
  String get unhide_listing => 'Unhide';

  @override
  String get hidden_badge => 'HIDDEN';

  @override
  String get who_did_you_sell_to => 'Who did you sell to?';

  @override
  String get sold_elsewhere => 'Sold elsewhere';

  @override
  String get marked_as_sold => 'Marked as sold';

  @override
  String get listing_available_again => 'Listing is available again';

  @override
  String get listing_hidden => 'Listing hidden';

  @override
  String get listing_unhidden => 'Listing is visible again';

  @override
  String get failed_to_update_listing => 'Failed to update listing';

  @override
  String get active_tab => 'Active';

  @override
  String get sold_tab => 'Sold';

  @override
  String get no_active_listings => 'No active listings';

  @override
  String get no_sold_listings => 'No sold items yet';
}
