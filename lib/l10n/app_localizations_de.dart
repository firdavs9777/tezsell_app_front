// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get sessionExpired =>
      'Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.';

  @override
  String get welcome => 'Willkommen';

  @override
  String get welcomeBack => 'Willkommen zurück!';

  @override
  String get loginToYourAccount => 'Melden Sie sich an, um fortzufahren';

  @override
  String get or => 'ODER';

  @override
  String get dontHaveAccount => 'Sie haben noch kein Konto?';

  @override
  String get chooseLanguage => 'Wählen Sie Ihre Sprache';

  @override
  String get selectPreferredLanguage =>
      'Wählen Sie Ihre bevorzugte Sprache für die App aus';

  @override
  String get continueButton => 'Weitermachen';

  @override
  String get continueWithGoogle => 'Weiter mit Google';

  @override
  String get continueWithApple => 'Weiter mit Apple';

  @override
  String get continueWithEmail => 'Fahren Sie mit E-Mail fort';

  @override
  String get sellAndBuyProducts =>
      'Verkaufen und kaufen Sie Ihre Produkte nur bei uns';

  @override
  String get usedProductsMarket => 'Gebrauchte Produkte oder Gebrauchtmarkt';

  @override
  String get home_welcome_title => 'Ihr Marktplatz in der Nachbarschaft';

  @override
  String get home_welcome_subtitle =>
      'Kaufen und verkaufen Sie mit Menschen in der Nähe.\nSicher, einfach und lokal.';

  @override
  String get home_get_started => 'Legen Sie los';

  @override
  String get home_sign_in => 'Ich habe bereits ein Konto';

  @override
  String get home_terms_notice =>
      'Wenn Sie fortfahren, stimmen Sie unseren Nutzungsbedingungen und Datenschutzrichtlinien zu';

  @override
  String get register => 'Registrieren';

  @override
  String get alreadyHaveAccount => 'Habe bereits ein Konto';

  @override
  String get login => 'Login';

  @override
  String get loginToAccount => 'Melden Sie sich bei Ihrem Konto an';

  @override
  String get enterPhoneNumber => 'Geben Sie die Telefonnummer ein';

  @override
  String get password => 'Passwort';

  @override
  String get enterPassword => 'Passwort eingeben';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get registerNow => 'Registrieren Sie sich jetzt';

  @override
  String get loading => 'Laden...';

  @override
  String get pleaseEnterPhoneNumber => 'Bitte geben Sie Ihre Telefonnummer ein';

  @override
  String get pleaseEnterPassword => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get unexpectedError =>
      'Es ist ein unerwarteter Fehler aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get forgotPasswordComingSoon =>
      'Die Funktion „Passwort vergessen“ ist bald verfügbar';

  @override
  String get selectedCountryLabel => 'Ausgewählt:';

  @override
  String get fullPhoneLabel => 'Voll:';

  @override
  String get home => 'Heim';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Suchen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get error => 'Fehler';

  @override
  String get retry => 'Wiederholen';

  @override
  String get cancel => 'Stornieren';

  @override
  String get save => 'Speichern';

  @override
  String get appTitle => 'Tezsell';

  @override
  String get selectRegion => 'Bitte wählen Sie Ihre Region aus';

  @override
  String get searchHint => 'Bezirk oder Stadt suchen';

  @override
  String get apiError => 'Beim Aufruf der API ist ein Problem aufgetreten';

  @override
  String get ok => 'OK';

  @override
  String get emptyList => 'Leere Liste';

  @override
  String get dataLoadingError =>
      'Beim Laden der Daten ist ein Fehler aufgetreten';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'NEIN';

  @override
  String confirmRegionSelection(Object regionName) {
    return 'Möchten Sie die Region $regionName auswählen?';
  }

  @override
  String get selectDistrictOrCity =>
      'Bitte wählen Sie Ihren Bezirk oder Ihre Stadt aus';

  @override
  String confirmDistrictSelection(String regionName, String districtName) {
    return 'Möchten Sie die Region $regionName - $districtName auswählen?';
  }

  @override
  String get noResultsFound => 'Keine Ergebnisse gefunden.';

  @override
  String errorWithCode(String errorCode) {
    return 'Fehler: $errorCode';
  }

  @override
  String failedToLoadData(String error) {
    return 'Daten konnten nicht geladen werden. Fehler: $error';
  }

  @override
  String get phoneVerification => 'Überprüfung der Telefonnummer';

  @override
  String get enterPhonePrompt => 'Bitte geben Sie Ihre Telefonnummer ein';

  @override
  String get enterPhoneNumberHint => 'Geben Sie die Telefonnummer ein';

  @override
  String selectedCountry(String countryName, String countryCode) {
    return 'Ausgewählt: $countryName ($countryCode)';
  }

  @override
  String get selectCountry => 'Wählen Sie Ihr Land aus';

  @override
  String get changeCountry => 'Land ändern';

  @override
  String get country => 'Land';

  @override
  String get allCountries => 'Alle Länder';

  @override
  String get currencyRUB => 'Russischer Rubel';

  @override
  String get currencyUAH => 'Ukrainische Griwna';

  @override
  String get currencyBYN => 'Weißrussischer Rubel';

  @override
  String get currencyMDL => 'Moldauischer Leu';

  @override
  String get currencyGEL => 'Georgischer Lari';

  @override
  String get currencyAMD => 'Armenischer Dram';

  @override
  String get currencyAZN => 'Aserbaidschanisches Manat';

  @override
  String get currencyKZT => 'Kasachischer Tenge';

  @override
  String get currencyTMT => 'Turkmenisches Manat';

  @override
  String get currencyKGS => 'Kirgisischer Som';

  @override
  String get currencyTJS => 'Tadschikistanische Somoni';

  @override
  String get currencyUZS => 'Usbekischer Som';

  @override
  String get currencyUSD => 'US-Dollar';

  @override
  String get currencyEUR => 'Euro';

  @override
  String fullNumber(String phoneNumber) {
    return 'Vollständige Nummer: $phoneNumber';
  }

  @override
  String get sendCode => 'Code senden';

  @override
  String get enterVerificationCode => 'Geben Sie den Bestätigungscode ein';

  @override
  String get verificationCodeHint => '123456';

  @override
  String get resendCode => 'Code erneut senden';

  @override
  String expires(String time) {
    return 'Läuft ab: $time';
  }

  @override
  String get verifyAndContinue => 'Überprüfen und fortfahren';

  @override
  String get invalidVerificationCode => 'Ungültiger Bestätigungscode';

  @override
  String get verificationCodeSent => 'Bestätigungscode erfolgreich gesendet';

  @override
  String get failedToSendCode =>
      'Der Bestätigungscode konnte nicht gesendet werden';

  @override
  String get verificationCodeResent =>
      'Bestätigungscode erfolgreich erneut gesendet';

  @override
  String get failedToResendCode =>
      'Der Bestätigungscode konnte nicht erneut gesendet werden';

  @override
  String get passwordVerification => 'Passwortüberprüfung';

  @override
  String get completeRegistrationPrompt =>
      'Geben Sie Benutzernamen und Passwort ein, um die Registrierung abzuschließen';

  @override
  String get username => 'Benutzername';

  @override
  String get username_required => 'Benutzername ist erforderlich';

  @override
  String get username_min_length =>
      'Der Benutzername muss mindestens 2 Zeichen lang sein';

  @override
  String get usernameHint => 'Benutzername123';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get profileImage => 'Profilbild';

  @override
  String get imageInstructions =>
      'Bilder werden hier angezeigt, bitte drücken Sie auf Profilbild';

  @override
  String get finish => 'Beenden';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get registrationError => 'Registrierungsfehler';

  @override
  String get about => 'Über uns';

  @override
  String get chat => 'Chatten';

  @override
  String get realEstate => 'Immobilie';

  @override
  String get language => 'ENG';

  @override
  String get languageEn => 'Englisch';

  @override
  String get languageRu => 'Russisch';

  @override
  String get languageUz => 'Usbekisch';

  @override
  String get serviceLiked => 'Der Service hat mir gefallen';

  @override
  String get support => 'Unterstützung';

  @override
  String get service => 'Unternehmensdienstleistungen';

  @override
  String get aboutContent =>
      'TezSell ist ein schneller und einfacher Marktplatz für den Kauf und Verkauf neuer und gebrauchter Produkte. Unsere Mission ist es, für jeden Benutzer die bequemste und effizienteste Plattform zu schaffen und so reibungslose Transaktionen und ein benutzerfreundliches Erlebnis zu gewährleisten. Ganz gleich, ob Sie verkaufen oder kaufen möchten, mit TezSell können Sie ganz einfach eine Verbindung herstellen und Transaktionen in nur wenigen Schritten abschließen. Wir legen großen Wert auf die Sicherheit und den Datenschutz unserer Benutzer. Alle Transaktionen werden sorgfältig überwacht, um Sicherheit und Compliance zu gewährleisten und sowohl Käufern als auch Verkäufern Sicherheit zu geben. Unsere einfache und intuitive Benutzeroberfläche ermöglicht es Benutzern, Produkte schnell aufzulisten und zu finden, was sie benötigen. Wir ermöglichen auch die Kommunikation in Echtzeit über Telegram, was den Kauf- und Verkaufsprozess noch reibungsloser macht.';

  @override
  String get errorMessage =>
      'Es ist ein Fehler aufgetreten. Bitte überprüfen Sie den Server';

  @override
  String get searchLocation => 'Standort';

  @override
  String get searchCategory => 'Kategorien';

  @override
  String get searchProductPlaceholder => 'Nach Produkten suchen';

  @override
  String get searchServicePlaceholder => 'Suche nach Dienstleistungen';

  @override
  String get search_products_subtitle =>
      'Finden Sie tolle Angebote in Ihrer Nähe';

  @override
  String get search_services_subtitle => 'Finden Sie Fachkräfte in Ihrer Nähe';

  @override
  String get search_products_error => 'Fehler bei der Produktsuche';

  @override
  String get search_services_error => 'Fehler bei der Suche nach Diensten';

  @override
  String get load_more_products_error => 'Fehler beim Laden weiterer Produkte';

  @override
  String get load_more_services_error => 'Fehler beim Laden weiterer Dienste';

  @override
  String get try_different_keywords =>
      'Probieren Sie verschiedene Schlüsselwörter aus';

  @override
  String get searchText => 'Suchen';

  @override
  String get selectedCategory => 'Ausgewählte Kategorie:';

  @override
  String get selectedLocation => 'Ausgewählter Standort:';

  @override
  String get productError => 'Keine Produkte verfügbar';

  @override
  String get serviceError => 'Keine Dienste verfügbar';

  @override
  String get locationHeader => 'Wählen Sie einen Standort aus';

  @override
  String get locationPlaceholder => 'Region hier suchen';

  @override
  String get categoryHeader => 'Wählen Sie eine Kategorie aus';

  @override
  String get categoryPlaceholder => 'Kategorien durchsuchen';

  @override
  String get categoryError => 'Keine Kategorien verfügbar';

  @override
  String get paginationFirst => 'Erste';

  @override
  String get paginationPrevious => 'Vorherige';

  @override
  String get pageInfo => 'Seite von';

  @override
  String get pageNext => 'Nächste';

  @override
  String get pageLast => 'Zuletzt';

  @override
  String get loadingMessageProduct => 'Produkte werden geladen ...';

  @override
  String get loadingMessageError => 'Fehler beim Laden';

  @override
  String get likeProductError =>
      'Beim Liken des Produkts ist ein Fehler aufgetreten';

  @override
  String get dislikeProductError =>
      'Beim Ablehnen des Produkts ist ein Fehler aufgetreten';

  @override
  String get loadingMessageLocation => 'Ladeort ...';

  @override
  String get loadingLocationError => 'Fehler beim Laden des Standorts';

  @override
  String get loadingMessageCategory => 'Kategorien werden geladen ...';

  @override
  String get loadingCategoryError => 'Fehler beim Laden der Kategorien:';

  @override
  String get profileUpdateSuccessMessage => 'Profil erfolgreich aktualisiert';

  @override
  String get profileUpdateFailMessage =>
      'Profil konnte nicht aktualisiert werden';

  @override
  String get seeMoreBtn => 'Mehr anzeigen';

  @override
  String get profilePageTitle => 'Profilseite';

  @override
  String get editProfileModalTitle => 'Profil bearbeiten';

  @override
  String get usernameLabel => 'Benutzername';

  @override
  String get locationLabel => 'Aktueller Standort';

  @override
  String get profileImageLabel => 'Profilbild';

  @override
  String get chooseFileLabel => 'Wählen Sie eine Datei';

  @override
  String get uploadBtnLabel => 'Aktualisieren';

  @override
  String get uploadingBtnLabel => 'Aktualisierung ...';

  @override
  String get cancelBtnLabel => 'Stornieren';

  @override
  String get productsTitle => 'Produkte';

  @override
  String get servicesTitle => 'Dienstleistungen';

  @override
  String get myProductsTitle => 'Meine Produkte';

  @override
  String get myServicesTitle => 'Meine Dienste';

  @override
  String get favoriteProductsTitle => 'Lieblingsprodukte';

  @override
  String get favoriteServicesTitle => 'Lieblingsdienste';

  @override
  String get noFavorites => 'Keine Favoriten';

  @override
  String get addNewProductBtn => 'Neues Produkt hinzufügen';

  @override
  String get addNew => 'Neu';

  @override
  String get addNewServiceBtn => 'Neuen Dienst hinzufügen';

  @override
  String get downloadMobileApp => 'Laden Sie die mobile App herunter';

  @override
  String get registerPhoneNumberSuccess =>
      'Telefonnummer verifiziert! Sie können mit dem nächsten Schritt fortfahren.';

  @override
  String get regionSelectedMessage => 'Ausgewählte Region:';

  @override
  String get districtSelectMessage => 'Ausgewählter Bezirk:';

  @override
  String get phoneNumberEmptyMessage =>
      'Bitte überprüfen Sie Ihre Telefonnummer, bevor Sie fortfahren';

  @override
  String get regionEmptyMessage => 'Bitte wählen Sie zunächst die Region aus';

  @override
  String get districtEmptyMessage => 'Bitte wählen Sie den Bezirk aus';

  @override
  String get usernamePasswordEmptyMessage =>
      'Bitte geben Sie Benutzernamen und Passwort ein';

  @override
  String get registerTitle => 'Registrieren';

  @override
  String get previousButton => 'Vorherige';

  @override
  String get nextButton => 'Nächste';

  @override
  String get completeButton => 'Vollständig';

  @override
  String stepIndicator(int currentStep) {
    return 'Schritt $currentStep von 4';
  }

  @override
  String get districtSelectTitle => 'Bezirksliste';

  @override
  String get districtSelectParagraph => 'Wählen Sie einen Bezirk:';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get sendOtp => 'OTP senden';

  @override
  String get sendAgain => 'Nochmals senden';

  @override
  String get verify => 'Verifizieren';

  @override
  String get failedToSendOtp =>
      'OTP konnte nicht gesendet werden. Der Server hat „false“ zurückgegeben.';

  @override
  String get errorSendingOtp =>
      'Beim Senden des OTP ist ein Fehler aufgetreten.';

  @override
  String get invalidPhoneNumber =>
      'Bitte geben Sie eine gültige Telefonnummer ein.';

  @override
  String get verificationSuccess => 'Erfolgreich verifiziert';

  @override
  String get verificationError =>
      'Es ist ein Fehler aufgetreten. Bitte versuchen Sie es später noch einmal.';

  @override
  String get regionsList => 'Liste der Regionen';

  @override
  String get enterUsername => 'Geben Sie Ihren Benutzernamen ein';

  @override
  String get welcomeMessage =>
      'Willkommen bei Tezsell, melden Sie sich mit Ihrer Telefonnummer an';

  @override
  String get noAccount => 'Noch kein Konto? Registrieren Sie sich hier';

  @override
  String get successLogin => 'Erfolgreich angemeldet';

  @override
  String get myProfile => 'Mein Profil';

  @override
  String get logout => 'Abmelden';

  @override
  String get newProductTitle => 'Titel';

  @override
  String get newProductDescription => 'Beschreibung';

  @override
  String get newProductPrice => 'Preis';

  @override
  String get newProductCondition => 'Zustand';

  @override
  String get newProductCategory => 'Kategorie';

  @override
  String get newProductImages => 'Bilder';

  @override
  String get addNewService => 'Neuen Dienst hinzufügen';

  @override
  String get creating => 'Erstellen...';

  @override
  String get serviceName => 'Dienstname';

  @override
  String get serviceNamePlaceholder => 'Geben Sie den Diensttitel ein';

  @override
  String get serviceDescription => 'Servicebeschreibung';

  @override
  String get serviceDescriptionPlaceholder =>
      'Geben Sie eine Servicebeschreibung ein';

  @override
  String get serviceCategory => 'Servicekategorie';

  @override
  String get selectCategory => 'Kategorie auswählen';

  @override
  String get loadingCategories => 'Laden...';

  @override
  String get errorLoadingCategories => 'Fehler beim Laden der Kategorien';

  @override
  String get serviceImages => 'Servicebilder';

  @override
  String get imageUploadHelper =>
      'Klicken Sie auf das +-Symbol, um Bilder hinzuzufügen (maximal 10).';

  @override
  String get maxImagesError => 'Sie können maximal 10 Bilder hochladen';

  @override
  String get categoryNotFound => 'Kategorie nicht gefunden';

  @override
  String get productCreatedSuccess => 'Produkt erfolgreich erstellt';

  @override
  String get productLikeSuccess => 'Produkt hat mir gut gefallen';

  @override
  String get productDislikeSuccess => 'Produkt wurde erfolgreich abgelehnt';

  @override
  String get errorCreatingService => 'Fehler beim Erstellen des Dienstes';

  @override
  String get errorCreatingProduct => 'Fehler beim Erstellen des Produkts';

  @override
  String get unknownError =>
      'Beim Erstellen des Dienstes ist ein unbekannter Fehler aufgetreten';

  @override
  String get submit => 'Einreichen';

  @override
  String get selectCategoryAction => 'Kategorie auswählen';

  @override
  String get selectCondition => 'Wählen Sie Bedingung aus';

  @override
  String get sum => 'Summe';

  @override
  String get noComments =>
      'Noch keine Kommentare. Seien Sie der Erste, der einen Kommentar abgibt!';

  @override
  String get commentLikeSuccess => 'Kommentar erfolgreich geliked';

  @override
  String get commentLikeError => 'Fehler beim Liken des Kommentars';

  @override
  String get unknownErrorMessage => 'Es ist ein unbekannter Fehler aufgetreten';

  @override
  String get commentDislikeSuccess => 'Kommentar wurde erfolgreich abgelehnt';

  @override
  String get commentDislikeError => 'Fehler beim Ablehnen des Kommentars';

  @override
  String get replyInfo => 'Bitte geben Sie zunächst eine Antwort ein';

  @override
  String get replySuccessMessage => 'Antwort erfolgreich hinzugefügt';

  @override
  String get replyErrorMessage =>
      'Beim Erstellen der Antwort ist ein Fehler aufgetreten';

  @override
  String get commentUpdateSuccess => 'Kommentar erfolgreich aktualisiert';

  @override
  String get commentUpdateError =>
      'Fehler beim Aktualisieren des Kommentarelements';

  @override
  String get deleteConfirmationMessage =>
      'Sind Sie sicher, dass Sie diesen Kommentar löschen möchten?';

  @override
  String get commentDeleteSuccess => 'Kommentar erfolgreich gelöscht';

  @override
  String get commentDeleteError => 'Fehler beim Löschen des Kommentars';

  @override
  String get editLabel => 'Bearbeiten';

  @override
  String get deleteLabel => 'Löschen';

  @override
  String get saveLabel => 'Speichern';

  @override
  String get replyLabel => 'Antwort';

  @override
  String get replyTitle => 'Antworten';

  @override
  String get replyPlaceholder => 'Schreibe eine Antwort...';

  @override
  String get chatLoginMessage =>
      'Sie müssen angemeldet sein, um einen Chat zu starten';

  @override
  String get chatYourselfMessage => 'Du kannst nicht mit dir selbst chatten.';

  @override
  String get chatRoomMessage => 'Chatraum erstellt!';

  @override
  String get chatRoomError => 'Chat konnte nicht erstellt werden!';

  @override
  String get chatCreationError => 'Chat-Erstellung fehlgeschlagen!';

  @override
  String get productsTotal => 'Produkte insgesamt';

  @override
  String get perPage => 'Artikel';

  @override
  String get clearAllFilters => 'Alle Filter löschen';

  @override
  String get clickToUpload => 'Klicken Sie zum Hochladen';

  @override
  String get productInStock => 'Auf Lager';

  @override
  String get productOutStock => 'Ausverkauft';

  @override
  String get productBack => 'Zurück zu den Produkten';

  @override
  String get messageSeller => 'Chatten';

  @override
  String get recommendedProducts => 'Empfohlene Produkte';

  @override
  String get deleteConfirmationProduct =>
      'Sind Sie sicher, dass Sie dieses Produkt löschen möchten?';

  @override
  String get productDeleteSuccess => 'Produkt erfolgreich gelöscht';

  @override
  String get productDeleteError => 'Fehler beim Löschen des Produkts';

  @override
  String get newCondition => 'Neu';

  @override
  String get used => 'Gebraucht';

  @override
  String get imageValidType =>
      'Einige Dateien wurden nicht hinzugefügt. Bitte verwenden Sie JPG-, PNG-, GIF- oder WebP-Dateien unter 5 MB.';

  @override
  String get imageConfirmMessage =>
      'Möchten Sie dieses Bild wirklich entfernen?';

  @override
  String get titleRequiredMessage => 'Titel ist erforderlich';

  @override
  String get descRequiredMessage => 'Beschreibung ist erforderlich';

  @override
  String get priceRequiredMessage => 'Preis ist erforderlich';

  @override
  String get conditionRequiredMessage => 'Kondition ist erforderlich';

  @override
  String get pleaseFillAllRequired =>
      'Bitte füllen Sie die erforderlichen Felder aus';

  @override
  String get oneImageConfirmMessage =>
      'Es ist mindestens ein Produktbild erforderlich';

  @override
  String get categoryRequiredMessage => 'Kategorie ist erforderlich';

  @override
  String get locationInfoError => 'Informationen zum Benutzerstandort fehlen';

  @override
  String get editProductTitle => 'Produkt bearbeiten';

  @override
  String get imageUploadRequirements =>
      'Es ist mindestens ein Bild erforderlich. Sie können bis zu 10 Bilder hochladen (JPG, PNG, GIF, WebP jeweils unter 5 MB).';

  @override
  String get productUpdatedSuccess => 'Produkt erfolgreich aktualisiert';

  @override
  String get productUpdateFailed => 'Produktaktualisierung fehlgeschlagen';

  @override
  String get errorUpdatingProduct =>
      'Beim Aktualisieren des Produkts ist ein Fehler aufgetreten';

  @override
  String get serviceBack => 'Zurück zu den Dienstleistungen';

  @override
  String get likeLabel => 'Wie';

  @override
  String get commentsLabel => 'Kommentare';

  @override
  String get writeComment => 'Schreiben Sie einen Kommentar ...';

  @override
  String get postingLabel => 'Posten...';

  @override
  String get commentCreated => 'Kommentar erstellt';

  @override
  String get postCommentLabel => 'Kommentar posten';

  @override
  String get loginPrompt =>
      'Bitte melden Sie sich an, um Kommentare anzuzeigen und zu posten.';

  @override
  String get recommendedServices => 'Empfohlene Dienstleistungen';

  @override
  String get commentsVisibilityNotice =>
      'Kommentare sind nur für eingeloggte Benutzer sichtbar.';

  @override
  String get comingSoon => 'Kommt bald';

  @override
  String get serviceUpdateSuccess => 'Dienst erfolgreich aktualisiert';

  @override
  String get serviceUpdateError =>
      'Fehler beim Aktualisieren des Serviceartikels';

  @override
  String get editServiceModalTitle => 'Dienst bearbeiten';

  @override
  String get enterPhoneNumberWithoutCode => 'Telefonnummer ohne Code eingeben';

  @override
  String get heroTitle => 'TezSell';

  @override
  String get heroSubtitle =>
      'Ihr schneller und einfacher Marktplatz für Usbekistan';

  @override
  String get startSelling => 'Beginnen Sie mit dem Verkaufen';

  @override
  String get browseProducts => 'Produkte durchsuchen';

  @override
  String get featuresTitle => 'Warum TezSell wählen?';

  @override
  String get listingTitle => 'Einfache Produktauflistung';

  @override
  String get listingDescription =>
      'Listen Sie Ihre Artikel mit nur wenigen Klicks auf. Fügen Sie Fotos hinzu, legen Sie Ihren Preis fest und treten Sie sofort mit Käufern in Kontakt.';

  @override
  String get locationTitle => 'Standortbasiertes Surfen';

  @override
  String get locationDescription =>
      'Finden Sie Angebote in Ihrer Nähe. Unser standortbasiertes System hilft Ihnen, Gegenstände in Ihrer Nachbarschaft zu entdecken.';

  @override
  String get location_subtitle =>
      'Wählen Sie Ihre Region und Ihren Bezirk aus, um Einträge in der Nähe anzuzeigen';

  @override
  String get categoryTitle => 'Kategoriefilterung';

  @override
  String get categoryDescription =>
      'Navigieren Sie einfach durch die verschiedenen Kategorien, um genau das zu finden, was Sie suchen.';

  @override
  String get inspirationTitle => 'Inspiriert vom koreanischen Karottenmarkt';

  @override
  String get inspirationDescription1 =>
      'Wir haben TezSell mit Inspiration vom erfolgreichen koreanischen Karottenmarkt (당근마켓) entwickelt, es aber speziell auf die besonderen Bedürfnisse der lokalen Gemeinschaften Usbekistans zugeschnitten.';

  @override
  String get inspirationDescription2 =>
      'Unsere Mission ist es, eine vertrauenswürdige Plattform zu schaffen, auf der Nachbarn problemlos kaufen, verkaufen und miteinander in Kontakt treten können.';

  @override
  String get comingSoonTitle => 'Demnächst bei TezSell erhältlich';

  @override
  String get inAppChat => 'In-App-Chat';

  @override
  String get secureTransactions => 'Sichere Transaktionen';

  @override
  String get realEstateListings => 'Immobilienanzeigen';

  @override
  String get stayUpdated => 'Bleiben Sie auf dem Laufenden';

  @override
  String get comingSoonBadge => 'Demnächst erhältlich';

  @override
  String get ctaTitle => 'Treten Sie noch heute der TezSell-Community bei!';

  @override
  String get ctaDescription =>
      'Seien Sie Teil des Aufbaus eines besseren Marktplatzerlebnisses für Usbekistan. Teilen Sie Ihr Feedback und helfen Sie uns zu wachsen!';

  @override
  String get createAccount => 'Benutzerkonto erstellen';

  @override
  String get learnMore => 'Erfahren Sie mehr';

  @override
  String get replyUpdateSuccess => 'Antwort erfolgreich aktualisiert';

  @override
  String get replyUpdateError => 'Die Antwort konnte nicht aktualisiert werden';

  @override
  String get replyDeleteSuccess => 'Antwort erfolgreich gelöscht';

  @override
  String get replyDeleteError => 'Die Antwort konnte nicht gelöscht werden';

  @override
  String get replyDeleteConfirmation =>
      'Sind Sie sicher, dass Sie diese Antwort löschen möchten?';

  @override
  String get authenticationRequired => 'Authentifizierung erforderlich';

  @override
  String get enterValidReply =>
      'Bitte geben Sie einen gültigen Antworttext ein';

  @override
  String get saving => 'Sparen...';

  @override
  String get deleting => 'Löschen...';

  @override
  String get properties => 'Eigenschaften';

  @override
  String get agents => 'Agenten';

  @override
  String get becomeAgent => 'Werden Sie Agent';

  @override
  String get main => 'Hauptsächlich';

  @override
  String get upload => 'Hochladen';

  @override
  String get filtered_products => 'Gefilterte Produkte';

  @override
  String get filtered_services => 'Gefilterte Dienste';

  @override
  String get productDetail => 'Produktdetails';

  @override
  String get unknownUser => 'Unbekannter Benutzer';

  @override
  String get locationNotAvailable => 'Standort nicht verfügbar';

  @override
  String get noTitle => 'Kein Titel';

  @override
  String get noCategory => 'Keine Kategorie';

  @override
  String get noDescription => 'Keine Beschreibung';

  @override
  String get som => 'Som';

  @override
  String get about_me => 'Über mich';

  @override
  String get my_name => 'Mein Name';

  @override
  String get customer_support => 'Kundensupport';

  @override
  String get customer_center => 'Kundencenter';

  @override
  String get customer_inquiries => 'Anfragen';

  @override
  String get customer_terms => 'Geschäftsbedingungen';

  @override
  String get region => 'Region';

  @override
  String get district => 'Bezirk';

  @override
  String get tap_change_profile => 'Tippen Sie, um das Foto zu ändern';

  @override
  String get language_settings => 'Spracheinstellungen';

  @override
  String get selectLanguage => 'Wählen Sie eine Sprache aus';

  @override
  String get select_theme => 'Wählen Sie Thema aus';

  @override
  String get theme => 'Thema';

  @override
  String get location_settings => 'Standorteinstellungen';

  @override
  String get security => 'Sicherheit';

  @override
  String get data_storage => 'Daten & Speicherung';

  @override
  String get accessibility => 'Barrierefreiheit';

  @override
  String get privacy => 'Privatsphäre';

  @override
  String get light_theme => 'Licht';

  @override
  String get dark_theme => 'Dunkel';

  @override
  String get system_theme => 'Systemstandard';

  @override
  String get my_products => 'Meine Produkte';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get delete_product => 'Produkt löschen';

  @override
  String get delete_confirmation =>
      'Sind Sie sicher, dass Sie dieses Produkt löschen möchten?';

  @override
  String get delete => 'Löschen';

  @override
  String error_loading_products(String error) {
    return 'Fehler beim Laden der Produkte: $error';
  }

  @override
  String get product_deleted_success => 'Produkt erfolgreich gelöscht';

  @override
  String error_deleting_product(String error) {
    return 'Fehler beim Löschen des Produkts: $error';
  }

  @override
  String get no_products_found => 'Keine Produkte gefunden';

  @override
  String get add_first_product => 'Fügen Sie zunächst Ihr erstes Produkt hinzu';

  @override
  String get no_title => 'Kein Titel';

  @override
  String get no_description => 'Keine Beschreibung';

  @override
  String get in_stock => 'Auf Lager';

  @override
  String get out_of_stock => 'Ausverkauft';

  @override
  String get new_condition => 'NEU';

  @override
  String get edit_product => 'Produkt bearbeiten';

  @override
  String get delete_product_tooltip => 'Produkt löschen';

  @override
  String get sum_currency => 'Summe';

  @override
  String get edit_product_title => 'Produkt bearbeiten';

  @override
  String get product_name => 'Produktname';

  @override
  String get product_description => 'Produktbeschreibung';

  @override
  String get price => 'Preis';

  @override
  String get condition => 'Zustand';

  @override
  String get condition_new => 'Neu';

  @override
  String get condition_used => 'Gebraucht';

  @override
  String get condition_refurbished => 'Renoviert';

  @override
  String get currency => 'Währung';

  @override
  String get category => 'Kategorie';

  @override
  String get images => 'Bilder';

  @override
  String get existing_images => 'Vorhandene Bilder';

  @override
  String get new_images => 'Neue Bilder';

  @override
  String get image_instructions =>
      'Bilder werden hier angezeigt. Bitte klicken Sie oben auf das Upload-Symbol.';

  @override
  String get update_button => 'Aktualisieren';

  @override
  String loading_category_error(String error) {
    return 'Fehler beim Laden der Kategorien: $error';
  }

  @override
  String error_picking_images(String error) {
    return 'Fehler beim Auswählen von Bildern: $error';
  }

  @override
  String get please_fill_all_required => 'Bitte füllen Sie alle Felder aus';

  @override
  String get invalid_price_message =>
      'Ungültiger Preis eingegeben. Bitte geben Sie eine gültige Nummer ein.';

  @override
  String get category_required_message =>
      'Bitte wählen Sie eine gültige Kategorie aus.';

  @override
  String get one_image_required_message =>
      'Es ist mindestens ein Produktbild erforderlich';

  @override
  String get product_updated_success => 'Produkt erfolgreich aktualisiert';

  @override
  String error_updating_product(String error) {
    return 'Fehler beim Aktualisieren des Produkts: $error';
  }

  @override
  String get my_services => 'Meine Dienste';

  @override
  String get delete_service => 'Dienst löschen';

  @override
  String get delete_service_confirmation =>
      'Sind Sie sicher, dass Sie diesen Dienst löschen möchten?';

  @override
  String get no_services_found => 'Keine Dienste gefunden';

  @override
  String get add_first_service =>
      'Beginnen Sie mit dem Hinzufügen Ihres ersten Dienstes';

  @override
  String get edit_service => 'Dienst bearbeiten';

  @override
  String get delete_service_tooltip => 'Dienst löschen';

  @override
  String get service_deleted_successfully => 'Dienst erfolgreich gelöscht';

  @override
  String get error_deleting_service => 'Fehler beim Löschen des Dienstes';

  @override
  String get error_loading_services => 'Fehler beim Laden der Dienste';

  @override
  String get service_name => 'Dienstname';

  @override
  String get enter_service_name => 'Geben Sie den Dienstnamen ein';

  @override
  String get service_name_required => 'Dienstname ist erforderlich';

  @override
  String get service_name_min_length =>
      'Der Dienstname muss mindestens 3 Zeichen lang sein';

  @override
  String get enter_service_description =>
      'Geben Sie eine Servicebeschreibung ein';

  @override
  String get service_description_required =>
      'Eine Leistungsbeschreibung ist erforderlich';

  @override
  String get service_description_min_length =>
      'Die Beschreibung muss mindestens 10 Zeichen lang sein';

  @override
  String get category_required => 'Bitte wählen Sie eine Kategorie aus';

  @override
  String get no_categories_available => 'Keine Kategorien verfügbar';

  @override
  String get location => 'Standort';

  @override
  String get select_location => 'Standort auswählen';

  @override
  String get location_required => 'Bitte wählen Sie einen Standort aus';

  @override
  String get no_locations_available => 'Keine Standorte verfügbar';

  @override
  String get add_images => 'Bilder hinzufügen';

  @override
  String get current_images => 'Aktuelle Bilder';

  @override
  String get no_images_selected => 'Keine Bilder ausgewählt';

  @override
  String get save_changes => 'Änderungen speichern';

  @override
  String get map_main => 'Karte & Eigenschaften';

  @override
  String get agent_status => 'Agentenstatus';

  @override
  String get admin_panel => 'Admin-Panel';

  @override
  String get propertiesFound => 'Eigenschaften gefunden';

  @override
  String get propertiesSaved => 'Eigenschaften gespeichert';

  @override
  String get saved => 'gespeichert';

  @override
  String get loadingProperties => 'Eigenschaften werden geladen...';

  @override
  String get failedToLoad =>
      'Eigenschaften konnten nicht geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get noPropertiesFound => 'Keine Eigenschaften gefunden';

  @override
  String get tryAdjusting => 'Versuchen Sie, Ihre Suchkriterien anzupassen';

  @override
  String get search_placeholder => 'Nach Titel oder Ort suchen...';

  @override
  String get search_filters => 'Filter';

  @override
  String get search_button => 'Suchen';

  @override
  String get search_clear_filters => 'Filter löschen';

  @override
  String get filter_options_sale_and_rent => 'Verkauf und Vermietung';

  @override
  String get filter_options_for_sale => 'Zu verkaufen';

  @override
  String get filter_options_for_rent => 'Zu vermieten';

  @override
  String get filter_options_all_types => 'Alle Typen';

  @override
  String get filter_options_apartment => 'Wohnung';

  @override
  String get filter_options_house => 'Haus';

  @override
  String get filter_options_townhouse => 'Stadthaus';

  @override
  String get filter_options_villa => 'Villa';

  @override
  String get filter_options_commercial => 'Kommerziell';

  @override
  String get filter_options_office => 'Büro';

  @override
  String get property_card_featured => 'Hervorgehoben';

  @override
  String get property_card_bed => 'Schlafzimmer';

  @override
  String get property_card_bath => 'Badezimmer';

  @override
  String get property_card_parking => 'Parken';

  @override
  String get property_card_view_details => 'Details anzeigen';

  @override
  String get property_card_contact => 'Kontakt';

  @override
  String get property_card_balcony => 'Balkon';

  @override
  String get property_card_garage => 'Garage';

  @override
  String get property_card_garden => 'Garten';

  @override
  String get property_card_pool => 'Pool';

  @override
  String get property_card_elevator => 'Aufzug';

  @override
  String get property_card_furnished => 'Möbliert';

  @override
  String get property_card_sales => 'Verkäufe';

  @override
  String get pricing_month => '/Monat';

  @override
  String get results_properties_found => 'Eigenschaften gefunden';

  @override
  String get results_properties_saved => 'Eigenschaften gespeichert';

  @override
  String get results_saved => 'gespeichert';

  @override
  String get results_loading_properties => 'Eigenschaften werden geladen...';

  @override
  String get results_failed_to_load =>
      'Eigenschaften konnten nicht geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get results_no_properties_found => 'Keine Eigenschaften gefunden';

  @override
  String get results_try_adjusting =>
      'Versuchen Sie, Ihre Suchkriterien anzupassen';

  @override
  String get no_properties_found => 'Keine Eigenschaften gefunden';

  @override
  String get no_category_properties =>
      'Keine Eigenschaften in dieser Kategorie';

  @override
  String get properties_loading => 'Eigenschaften werden geladen...';

  @override
  String get all_properties_loaded => 'Alle Eigenschaften geladen';

  @override
  String n_properties(int count) {
    return '$count Eigenschaften';
  }

  @override
  String get in_area => 'im Bereich';

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
  String get pagination_previous => 'Vorherige';

  @override
  String get pagination_next => 'Nächste';

  @override
  String get pagination_page => 'Seite';

  @override
  String get pagination_page_of => 'Seite 1 von';

  @override
  String get contact_modal_title => 'Kontaktinformationen';

  @override
  String get contact_modal_agent_contact => 'Agentenkontakt';

  @override
  String get contact_modal_property_owner => 'Immobilieneigentümer';

  @override
  String get contact_modal_agent_phone_number => 'Telefonnummer des Agenten';

  @override
  String get contact_modal_owner_phone_number =>
      'Telefonnummer des Eigentümers';

  @override
  String get contact_modal_license => 'Lizenz';

  @override
  String get contact_modal_rating => 'Bewertung';

  @override
  String get contact_modal_call_now => 'Rufen Sie jetzt an';

  @override
  String get contact_modal_copy_number => 'Nummer kopieren';

  @override
  String get contact_modal_close => 'Schließen';

  @override
  String get contact_modal_contact_hours => 'Kontaktzeiten: 9:00 – 20:00 Uhr';

  @override
  String get contact_modal_agent => 'Agent';

  @override
  String get errors_toggle_save_failed =>
      'Eigenschaftsspeicherung konnte nicht umgeschaltet werden:';

  @override
  String get errors_copy_failed => 'Telefonnummer konnte nicht kopiert werden:';

  @override
  String get errors_phone_copied =>
      'Telefonnummer in die Zwischenablage kopiert';

  @override
  String get errors_error_occurred_regions =>
      'Bei den Regionen ist ein Fehler aufgetreten';

  @override
  String get errors_error_occurred_districts =>
      'Bei den Bezirken ist ein Fehler aufgetreten';

  @override
  String get errors_please_fill_all_required_fields =>
      'Bitte füllen Sie alle erforderlichen Felder aus';

  @override
  String get errors_authentication_required => 'Authentifizierung erforderlich';

  @override
  String get errors_user_info_missing => 'Benutzerinformationen fehlen';

  @override
  String get errors_validation_error =>
      'Bitte überprüfen Sie Ihre Eingabedaten';

  @override
  String get errors_permission_denied => 'Zugriff verweigert';

  @override
  String get errors_server_error => 'Es ist ein Serverfehler aufgetreten';

  @override
  String get errors_network_error => 'Fehler bei der Netzwerkverbindung';

  @override
  String get errors_timeout_error =>
      'Anforderungszeitüberschreitung überschritten';

  @override
  String get errors_custom_error => 'Es ist ein Fehler aufgetreten';

  @override
  String get errors_error_creating_property =>
      'Fehler beim Erstellen der Eigenschaft';

  @override
  String get errors_unknown_error_message =>
      'Es ist ein unbekannter Fehler aufgetreten';

  @override
  String get errors_coordinates_not_found =>
      'Für diese Adresse konnten keine Koordinaten gefunden werden. Bitte geben Sie diese manuell ein.';

  @override
  String get errors_coordinates_error =>
      'Fehler beim Abrufen der Koordinaten. Bitte geben Sie diese manuell ein.';

  @override
  String get property_info_views => 'Ansichten';

  @override
  String get property_info_listed => 'Gelistet';

  @override
  String get property_info_price_per_sqm => '/qm';

  @override
  String get property_info_saved => 'Gespeichert';

  @override
  String get property_info_save => 'Speichern';

  @override
  String get property_info_share => 'Aktie';

  @override
  String get loading_loading => 'Laden...';

  @override
  String get loading_loading_details =>
      'Details zur Immobilie werden geladen...';

  @override
  String get loading_property_not_found => 'Eigenschaft nicht gefunden';

  @override
  String get loading_property_not_found_message =>
      'Die gesuchte Immobilie existiert nicht oder wurde entfernt.';

  @override
  String get loading_back_to_properties => 'Zurück zu Eigenschaften';

  @override
  String get loading_title => 'Agenten werden geladen...';

  @override
  String get loading_message =>
      'Bitte warten Sie, während wir die Liste der Agenten laden.';

  @override
  String get loading_agent_not_found => 'Agent nicht gefunden';

  @override
  String get property_details_title => 'Details zur Immobilie';

  @override
  String get property_details_bedrooms => 'Schlafzimmer';

  @override
  String get property_details_bathrooms => 'Badezimmer';

  @override
  String get property_details_floor_area => 'Grundfläche';

  @override
  String get property_details_parking => 'Parken';

  @override
  String get property_details_basic_information => 'Grundlegende Informationen';

  @override
  String get property_details_property_type => 'Immobilientyp:';

  @override
  String get property_details_listing_type => 'Eintragstyp:';

  @override
  String get property_details_for_sale => 'Zu verkaufen';

  @override
  String get property_details_for_rent => 'Zu vermieten';

  @override
  String get property_details_year_built => 'Baujahr:';

  @override
  String get property_details_floor => 'Boden:';

  @override
  String get property_details_of => 'von';

  @override
  String get property_details_features_amenities =>
      'Funktionen und Annehmlichkeiten';

  @override
  String get sections_description => 'Beschreibung';

  @override
  String get sections_nearby_amenities => 'Annehmlichkeiten in der Nähe';

  @override
  String get sections_similar_properties => 'Ähnliche Eigenschaften';

  @override
  String get amenities_metro => 'Metro';

  @override
  String get amenities_school => 'Schule';

  @override
  String get amenities_hospital => 'Krankenhaus';

  @override
  String get amenities_shopping => 'Einkaufen';

  @override
  String get amenities_away => 'weg';

  @override
  String get contact_title => 'Kontaktinformationen';

  @override
  String get contact_professional_listing => 'Professionelle Auflistung';

  @override
  String get contact_listed_by_agent =>
      'Gelistet von einem verifizierten Agenten';

  @override
  String get contact_by_owner => 'Vom Eigentümer';

  @override
  String get contact_direct_contact =>
      'Direkter Kontakt zum Grundstückseigentümer';

  @override
  String get contact_property_owner => 'Immobilieneigentümer';

  @override
  String get contact_call_agent => 'Rufen Sie den Agenten an';

  @override
  String get contact_email_agent => 'E-Mail-Agent';

  @override
  String get contact_call_owner => 'Rufen Sie den Eigentümer an';

  @override
  String get contact_email_owner => 'E-Mail-Besitzer';

  @override
  String get contact_send_inquiry => 'Anfrage senden';

  @override
  String get property_status_title => 'Eigentumsstatus';

  @override
  String get property_status_availability => 'Verfügbarkeit:';

  @override
  String get property_status_available => 'Verfügbar';

  @override
  String get property_status_not_available => 'Nicht verfügbar';

  @override
  String get property_status_featured => 'Hervorgehoben:';

  @override
  String get property_status_featured_property => 'Ausgewählte Eigenschaft';

  @override
  String get property_status_property_id => 'Objekt-ID:';

  @override
  String get inquiry_title => 'Anfrage senden';

  @override
  String get inquiry_inquiry_type => 'Anfragetyp';

  @override
  String get inquiry_request_info => 'Informationen anfordern';

  @override
  String get inquiry_schedule_viewing => 'Planen Sie die Besichtigung';

  @override
  String get inquiry_make_offer => 'Angebot machen';

  @override
  String get inquiry_request_callback => 'Rückruf anfordern';

  @override
  String get inquiry_message => 'Nachricht';

  @override
  String get inquiry_message_placeholder =>
      'Teilen Sie uns Ihr Interesse an dieser Immobilie mit...';

  @override
  String get inquiry_offered_price => 'Angebotspreis';

  @override
  String get inquiry_enter_offer => 'Geben Sie Ihr Angebot ein';

  @override
  String get inquiry_preferred_contact_time =>
      'Bevorzugte Kontaktzeit (optional)';

  @override
  String get inquiry_contact_time_placeholder =>
      'z. B. werktags 9:00–17:00 Uhr';

  @override
  String get inquiry_cancel => 'Stornieren';

  @override
  String get inquiry_sending => 'Senden...';

  @override
  String get inquiry_send_inquiry => 'Anfrage senden';

  @override
  String get inquiry_inquiry_sent_success => 'Anfrage erfolgreich gesendet!';

  @override
  String get inquiry_inquiry_sent_error =>
      'Anfrage konnte nicht gesendet werden. Bitte versuchen Sie es erneut.';

  @override
  String get alerts_link_copied =>
      'Immobilienlink in die Zwischenablage kopiert!';

  @override
  String get alerts_phone_copied => 'Telefonnummer in Zwischenablage kopiert!';

  @override
  String get alerts_save_property_failed =>
      'Eigenschaft konnte nicht gespeichert werden:';

  @override
  String get alerts_email_subject => 'Anfrage zu:';

  @override
  String alerts_email_body(Object address, Object title) {
    return 'Hallo,\\n\\nIch interessiere mich für Ihre Immobilie „$title“ in $address.\\n\\nBitte kontaktieren Sie mich für weitere Informationen.\\n\\nMit freundlichen Grüßen';
  }

  @override
  String get related_properties_view_details => 'Details anzeigen';

  @override
  String get header_property => 'Finden Sie Ihre Traumimmobilie';

  @override
  String get header_sub_property =>
      'Entdecken Sie erstklassige Immobilienmöglichkeiten in den begehrtesten Vierteln Taschkents';

  @override
  String get header_title => 'Immobilienmakler';

  @override
  String get header_subtitle =>
      'Finden Sie erfahrene Makler, die Sie bei Ihren Immobilienbedürfnissen unterstützen';

  @override
  String get header_agents_found => 'Agenten gefunden';

  @override
  String get filters_all_specializations => 'Alle Spezialisierungen';

  @override
  String get filters_residential => 'Wohnen';

  @override
  String get filters_commercial => 'Kommerziell';

  @override
  String get filters_luxury => 'Luxus';

  @override
  String get filters_investment => 'Investition';

  @override
  String get filters_any_rating => 'Jede Bewertung';

  @override
  String get filters_four_stars => '4+ Sterne';

  @override
  String get filters_four_half_stars => '4,5+ Sterne';

  @override
  String get filters_five_stars => '5 Sterne';

  @override
  String get filters_highest_rated => 'Höchste Bewertung';

  @override
  String get filters_lowest_rated => 'Niedrigste Bewertung';

  @override
  String get filters_most_sales => 'Die meisten Verkäufe';

  @override
  String get filters_most_experience => 'Die meiste Erfahrung';

  @override
  String get agent_card_verified_agent => 'Verifizierter Agent';

  @override
  String get agent_card_years_experience => 'Jahre Erfahrung';

  @override
  String get agent_card_years => 'Jahre';

  @override
  String get agent_card_license => 'Lizenz';

  @override
  String get agent_card_specialization => 'Spezialisierung';

  @override
  String get agent_card_view_profile => 'Profil anzeigen';

  @override
  String get agent_card_contact => 'Kontakt';

  @override
  String get agent_card_verified => 'Verifiziert';

  @override
  String get no_results_title => 'Keine Agenten gefunden';

  @override
  String get no_results_message =>
      'Versuchen Sie, Ihre Suchkriterien oder Filter anzupassen.';

  @override
  String get error_title => 'Fehler beim Laden der Agenten';

  @override
  String get error_message =>
      'Agentenliste konnte nicht geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get error_retry => 'Wiederholen';

  @override
  String get error_default_message =>
      'Agentendetails konnten nicht geladen werden';

  @override
  String get error_try_again => 'Versuchen Sie es erneut';

  @override
  String get notifications_phone_copied =>
      'Telefonnummer in die Zwischenablage kopiert';

  @override
  String get notifications_copy_failed =>
      'Telefonnummer konnte nicht kopiert werden:';

  @override
  String get fallback_agent_name => 'Agent';

  @override
  String get fallback_default_phone => '+998 90 123 45 67';

  @override
  String get navigation_submit_property => 'Eigentum einreichen';

  @override
  String get navigation_submitting => 'Einreichen...';

  @override
  String get navigation_back_to_agents => 'Zurück zu den Agenten';

  @override
  String get agent_profile_verified_agent => 'Verifizierter Agent';

  @override
  String get agent_profile_contact_agent => 'Kontaktieren Sie den Agenten';

  @override
  String get agent_profile_send_message => 'Nachricht senden';

  @override
  String get agent_profile_years_experience => 'Jahre Erfahrung';

  @override
  String get agent_profile_properties_sold => 'Immobilien verkauft';

  @override
  String get agent_profile_active_listings => 'Aktive Einträge';

  @override
  String get agent_profile_total_properties => 'Gesamteigenschaften';

  @override
  String get tabs_overview => 'Überblick';

  @override
  String get tabs_properties => 'Eigenschaften';

  @override
  String get tabs_reviews => 'Bewertungen';

  @override
  String get about_agent_title => 'Über den Agenten';

  @override
  String get about_agent_agency => 'Agentur';

  @override
  String get about_agent_license_number => 'Amtliches Kennzeichen';

  @override
  String get about_agent_specialization => 'Spezialisierung';

  @override
  String get about_agent_member_since => 'Mitglied seit';

  @override
  String get about_agent_verified_since => 'Verifiziert seit';

  @override
  String get performance_metrics_title => 'Leistungskennzahlen';

  @override
  String get performance_metrics_average_rating =>
      'Durchschnittliche Bewertung';

  @override
  String get performance_metrics_properties_sold => 'Immobilien verkauft';

  @override
  String get performance_metrics_active_listings => 'Aktive Einträge';

  @override
  String get performance_metrics_years_experience => 'Jahre Erfahrung';

  @override
  String get contact_info_title => 'Kontaktinformationen';

  @override
  String get contact_info_contact_via_platform => 'Kontakt über Plattform';

  @override
  String get verification_status_title => 'Verifizierungsstatus';

  @override
  String get verification_status_verified_agent => 'Verifizierter Agent';

  @override
  String get verification_status_pending_verification =>
      'Ausstehende Überprüfung';

  @override
  String get verification_status_licensed_professional =>
      'Lizenzierter Fachmann';

  @override
  String get verification_status_registered_agency => 'Registrierte Agentur';

  @override
  String get quick_actions_title => 'Schnelle Aktionen';

  @override
  String get quick_actions_call_now => 'Rufen Sie jetzt an';

  @override
  String get quick_actions_send_message => 'Nachricht senden';

  @override
  String get quick_actions_view_properties => 'Eigenschaften anzeigen';

  @override
  String get properties_title => 'Agenteneigenschaften';

  @override
  String get properties_loading_properties => 'Eigenschaften werden geladen...';

  @override
  String get properties_no_properties_title => 'Keine Eigenschaften gefunden';

  @override
  String get properties_no_properties_message =>
      'Die Eigenschaften dieses Agenten werden hier angezeigt.';

  @override
  String get properties_recent_properties_note =>
      'Aktuelle Eigenschaften anzeigen. Sehen Sie sich die vollständigen Einträge aller Maklerimmobilien an.';

  @override
  String get properties_listed => 'Gelistet';

  @override
  String get properties_bed => 'Bett';

  @override
  String get properties_bath => 'Bad';

  @override
  String get properties_for_sale => 'Zu verkaufen';

  @override
  String get properties_for_rent => 'Zu vermieten';

  @override
  String get reviews_title => 'Kundenrezensionen';

  @override
  String get reviews_no_reviews_title => 'Noch keine Bewertungen';

  @override
  String get reviews_no_reviews_message =>
      'Kundenrezensionen und Empfehlungen werden hier angezeigt.';

  @override
  String get fallbacks_agent_name => 'Agent';

  @override
  String get fallbacks_default_profile_image => '/default-avatar.png';

  @override
  String get saved_properties_title => 'Gespeicherte Eigenschaften';

  @override
  String get saved_properties_subtitle =>
      'Ihre Lieblingsimmobilien an einem Ort';

  @override
  String get saved_properties_no_saved_properties =>
      'Noch keine gespeicherten Eigenschaften';

  @override
  String get saved_properties_start_saving =>
      'Beginnen Sie mit der Erkundung und speichern Sie die Immobilien, die Ihnen gefallen';

  @override
  String get saved_properties_browse_properties =>
      'Durchsuchen Sie die Eigenschaften';

  @override
  String get saved_properties_saved_on => 'Gespeichert am';

  @override
  String get auth_login_required =>
      'Bitte melden Sie sich an, um gespeicherte Eigenschaften anzuzeigen';

  @override
  String get auth_login => 'Login';

  @override
  String get success_property_unsaved =>
      'Eigenschaft aus der gespeicherten Liste entfernt';

  @override
  String get success_property_saved => 'Eigenschaft erfolgreich gespeichert';

  @override
  String get success_phone_copied => 'Telefonnummer kopiert!';

  @override
  String get success_property_created_success =>
      'Immobilie erfolgreich erstellt!';

  @override
  String get success_agent_approved => 'Agent erfolgreich genehmigt';

  @override
  String get success_agent_rejected => 'Der Agent wurde erfolgreich abgelehnt';

  @override
  String get steps_step => 'Schritt';

  @override
  String get steps_basic_information => 'Grundlegende Informationen';

  @override
  String get steps_location_details => 'Standortdetails';

  @override
  String get steps_property_details => 'Details zur Immobilie';

  @override
  String get steps_property_images => 'Immobilienbilder';

  @override
  String get basic_info_tell_us_about_property =>
      'Erzählen Sie uns von Ihrer Immobilie';

  @override
  String get basic_info_property_type => 'Immobilientyp';

  @override
  String get basic_info_listing_type => 'Auflistungstyp';

  @override
  String get basic_info_property_title => 'Eigentumstitel';

  @override
  String get basic_info_title_placeholder =>
      'Geben Sie einen beschreibenden Titel für Ihre Immobilie ein';

  @override
  String get basic_info_description => 'Beschreibung';

  @override
  String get basic_info_description_placeholder =>
      'Beschreiben Sie Ihre Immobilie im Detail...';

  @override
  String get property_types_apartment => 'Wohnung';

  @override
  String get property_types_house => 'Haus';

  @override
  String get property_types_townhouse => 'Stadthaus';

  @override
  String get property_types_villa => 'Villa';

  @override
  String get property_types_commercial => 'Kommerziell';

  @override
  String get property_types_office => 'Büro';

  @override
  String get property_types_land => 'Land';

  @override
  String get property_types_warehouse => 'Lager';

  @override
  String get listing_types_for_sale => 'Zu verkaufen';

  @override
  String get listing_types_for_rent => 'Zu vermieten';

  @override
  String get location_where_is_property => 'Wo befindet sich Ihre Immobilie?';

  @override
  String get location_full_address => 'Vollständige Adresse';

  @override
  String get location_address_placeholder =>
      'Geben Sie die vollständige Adresse ein';

  @override
  String get location_region => 'Region';

  @override
  String get location_select_region => 'Region auswählen';

  @override
  String get location_district => 'Bezirk';

  @override
  String get location_select_district => 'Bezirk auswählen';

  @override
  String get location_city => 'Stadt';

  @override
  String get location_city_placeholder => 'Stadt';

  @override
  String get location_loading_regions => 'Regionen werden geladen...';

  @override
  String get location_loading_districts => 'Bezirke werden geladen...';

  @override
  String get location_map_coordinates => 'Kartenkoordinaten';

  @override
  String get location_get_coordinates => 'Koordinaten abrufen';

  @override
  String get location_latitude => 'Breite';

  @override
  String get location_longitude => 'Länge';

  @override
  String get location_coordinates_set => 'Koordinaten festgelegt';

  @override
  String get location_location_tips => 'Standorttipps';

  @override
  String get location_location_tip_1 =>
      '• Geben Sie zuerst die Adresse ein und klicken Sie dann auf „Koordinaten abrufen“, um den Kartenstandort automatisch abzurufen';

  @override
  String get location_location_tip_2 =>
      '• Sie können Koordinaten auch manuell eingeben, wenn Sie den genauen Standort kennen';

  @override
  String get location_location_tip_3 =>
      '• Genaue Koordinaten helfen Käufern, Ihre Immobilie auf der Karte zu finden';

  @override
  String get property_details_provide_detailed_info =>
      'Geben Sie detaillierte Informationen zu Ihrer Immobilie an';

  @override
  String get property_details_total_floors => 'Gesamtanzahl der Etagen';

  @override
  String get property_details_area_m2 => 'Fläche (m²)';

  @override
  String get property_details_parking_spaces => 'Parkplätze';

  @override
  String get property_details_price => 'Preis';

  @override
  String get property_details_features => 'Merkmale';

  @override
  String get images_add_photos_showcase =>
      'Fügen Sie Fotos hinzu, um Ihre Immobilie zu präsentieren';

  @override
  String get images_click_to_upload =>
      'Klicken Sie hier, um Bilder hochzuladen';

  @override
  String get images_max_images_info => 'Maximal 10 Bilder, JPG, PNG oder WEBP';

  @override
  String get images_main => 'Hauptsächlich';

  @override
  String get images_maximum_images_allowed => 'Maximal 10 Bilder erlaubt';

  @override
  String get admin_dashboard_title => 'Admin-Dashboard';

  @override
  String get admin_dashboard_subtitle =>
      'Echtzeit-Überblick über Ihre Immobilienplattform';

  @override
  String get admin_last_update => 'Letztes Update';

  @override
  String get admin_total_properties => 'Gesamteigenschaften';

  @override
  String get admin_total_agents => 'Gesamtzahl der Agenten';

  @override
  String get admin_total_users => 'Gesamtzahl der Benutzer';

  @override
  String get admin_total_views => 'Gesamtansichten';

  @override
  String get admin_error_loading_dashboard =>
      'Fehler beim Laden des Dashboards';

  @override
  String get admin_failed_to_load_data =>
      'Das Laden der Dashboard-Daten ist fehlgeschlagen';

  @override
  String get admin_avg_sale_price => 'Durchschnittlicher Verkaufspreis';

  @override
  String get admin_avg_sale_price_subtitle => 'Alle aktiven Einträge';

  @override
  String get admin_total_portfolio_value => 'Gesamtwert des Portfolios';

  @override
  String get admin_total_portfolio_value_subtitle =>
      'Kombinierter Immobilienwert';

  @override
  String get admin_avg_price_per_sqm => 'Durchschnittlicher Preis pro m²';

  @override
  String get admin_avg_price_per_sqm_subtitle => 'Marktzinsindikator';

  @override
  String get admin_property_types_distribution =>
      'Verteilung der Immobilientypen';

  @override
  String get admin_properties_by_city => 'Immobilien nach Stadt';

  @override
  String get admin_properties_by_district => 'Immobilien nach Bezirk';

  @override
  String get admin_inquiry_types_distribution => 'Verteilung der Anfragetypen';

  @override
  String get admin_agent_verification_rate => 'Agentenüberprüfungsrate';

  @override
  String get admin_agent_verification_rate_subtitle => 'Qualitätskontrolle';

  @override
  String get admin_inquiry_response_rate => 'Antwortrate auf Anfragen';

  @override
  String get admin_inquiry_response_rate_subtitle => 'Kundendienst';

  @override
  String get admin_avg_views_per_property =>
      'Durchschnittliche Aufrufe pro Objekt';

  @override
  String get admin_avg_views_per_property_subtitle =>
      'Beliebtheit von Immobilien';

  @override
  String get admin_featured_properties => 'Ausgewählte Eigenschaften';

  @override
  String get admin_featured_properties_subtitle => 'Premium-Angebote';

  @override
  String get admin_most_viewed_properties => 'Meistgesehene Eigenschaften';

  @override
  String get admin_top_performing_agents => 'Top-Agenten';

  @override
  String get admin_system_health => 'Systemgesundheit';

  @override
  String get admin_properties_without_images => 'Eigenschaften ohne Bilder';

  @override
  String get admin_missing_location_data => 'Fehlende Standortdaten';

  @override
  String get admin_pending_agent_verification =>
      'Ausstehende Agentenüberprüfung';

  @override
  String get admin_active => 'aktiv';

  @override
  String get admin_verified => 'verifiziert';

  @override
  String get admin_active_7d => 'aktiv (7d)';

  @override
  String get admin_this_month => 'diesen Monat';

  @override
  String get agents_loading_pending_applications =>
      'Ausstehende Bewerbungen werden geladen...';

  @override
  String get agents_error_loading_applications =>
      'Fehler beim Laden der Anwendungen';

  @override
  String get agents_pending_agents => 'Ausstehende Agenten';

  @override
  String get agents_total_pending_applications =>
      'Gesamtzahl der ausstehenden Anträge:';

  @override
  String get agents_pending_verification => 'Ausstehende Überprüfung';

  @override
  String get agents_applied_date => 'Angewandt:';

  @override
  String get agents_contact_info => 'Kontaktinformationen';

  @override
  String get agents_license_number => 'Amtliches Kennzeichen';

  @override
  String get agents_years_experience => 'Jahre Erfahrung';

  @override
  String get agents_years_suffix => 'Jahre';

  @override
  String get agents_total_sales => 'Gesamtumsatz';

  @override
  String get agents_specialization => 'Spezialisierung';

  @override
  String get agents_approve => 'Genehmigen';

  @override
  String get agents_reject => 'Ablehnen';

  @override
  String get agents_no_pending_applications => 'Keine ausstehenden Bewerbungen';

  @override
  String get agents_all_applications_processed =>
      'Alle Agentenanträge wurden bearbeitet';

  @override
  String get general_previous => 'Vorherige';

  @override
  String get general_page => 'Seite';

  @override
  String get general_next => 'Nächste';

  @override
  String get general_views => 'Ansichten';

  @override
  String get general_sales => 'Verkäufe';

  @override
  String get general_language_uz => 'O\'zbekcha';

  @override
  String get general_language_ru => 'Russisch';

  @override
  String get general_language_en => 'Englisch';

  @override
  String get general_super_admin => 'Super Admin';

  @override
  String get general_staff => 'Personal';

  @override
  String get general_verified_agent => 'Verifizierter Agent';

  @override
  String get general_pending_agent => 'Ausstehender Agent';

  @override
  String get general_regular_user => 'Normaler Benutzer';

  @override
  String get general_admin => 'Admin';

  @override
  String get general_dashboard => 'Armaturenbrett';

  @override
  String get general_manage_users => 'Benutzer verwalten';

  @override
  String get general_verified_agents => 'Verifizierte Agenten';

  @override
  String get general_agent_panel => 'Agentenpanel';

  @override
  String get general_create_property => 'Immobilie erstellen';

  @override
  String get general_my_properties => 'Meine Eigenschaften';

  @override
  String get general_inquiries => 'Anfragen';

  @override
  String get general_agent_profile => 'Agentenprofil';

  @override
  String get general_live => 'Live';

  @override
  String get general_logged_out_successfully => 'Erfolgreich abgemeldet';

  @override
  String get general_logout_completed_with_errors =>
      'Abmeldung abgeschlossen (mit Fehlern)';

  @override
  String get general_application_under_review => 'Antrag wird geprüft';

  @override
  String get general_check_status => 'Status prüfen →';

  @override
  String get general_last_updated => 'Letzte Aktualisierung:';

  @override
  String get general_permissions_may_be_outdated =>
      'Berechtigungen sind möglicherweise veraltet';

  @override
  String get general_permissions_up_to_date =>
      'Berechtigungen auf dem neuesten Stand';

  @override
  String get general_never => 'Niemals';

  @override
  String get general_properties_found => 'Eigenschaften gefunden';

  @override
  String get general_properties_saved => 'Eigenschaften gespeichert';

  @override
  String get general_saved => 'gespeichert';

  @override
  String get general_loading_properties => 'Eigenschaften werden geladen...';

  @override
  String get general_failed_to_load =>
      'Eigenschaften konnten nicht geladen werden. Bitte versuchen Sie es erneut.';

  @override
  String get general_no_properties_found => 'Keine Eigenschaften gefunden';

  @override
  String get general_try_adjusting =>
      'Versuchen Sie, Ihre Suchkriterien anzupassen';

  @override
  String get select_category => 'Kategorie auswählen';

  @override
  String get service_description => 'Servicebeschreibung';

  @override
  String get product_search_placeholder =>
      'Geben Sie einen Suchbegriff ein, um Produkte zu finden';

  @override
  String get privacy_policy => 'Datenschutzrichtlinie';

  @override
  String get terms_subtitle => 'Datenschutzbestimmungen und Bedingungen';

  @override
  String get last_updated => 'Zuletzt aktualisiert';

  @override
  String get contact_information => 'Kontaktinformationen';

  @override
  String get accept_terms =>
      'Ich akzeptiere die Allgemeinen Geschäftsbedingungen';

  @override
  String get read_terms =>
      'Bitte lesen Sie unsere Allgemeinen Geschäftsbedingungen';

  @override
  String get inquiries => 'Anfragen & Support';

  @override
  String get inquiries_subtitle => 'Kontaktieren Sie uns für Hilfe';

  @override
  String get help_center => 'Wie können wir Ihnen helfen?';

  @override
  String get help_subtitle =>
      'Wir sind für Sie da, um Ihnen bei allen Fragen behilflich zu sein';

  @override
  String get contact_us => 'Kontaktieren Sie uns';

  @override
  String get email_support => 'E-Mail-Support';

  @override
  String get call_support => 'Rufen Sie den Support an';

  @override
  String get send_message => 'Nachricht senden';

  @override
  String get fill_contact_form => 'Füllen Sie das Kontaktformular aus';

  @override
  String get contact_form => 'Kontaktformular';

  @override
  String get name => 'Ihr Name';

  @override
  String get name_required => 'Bitte geben Sie Ihren Namen ein';

  @override
  String get email => 'E-Mail-Adresse';

  @override
  String get email_required => 'Bitte geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get email_invalid => 'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get subject => 'Thema';

  @override
  String get subject_required => 'Bitte geben Sie einen Betreff ein';

  @override
  String get message => 'Nachricht';

  @override
  String get message_required => 'Bitte geben Sie Ihre Nachricht ein';

  @override
  String get message_too_short =>
      'Die Nachricht muss mindestens 10 Zeichen lang sein';

  @override
  String get faq => 'Häufig gestellte Fragen';

  @override
  String get follow_us => 'Folgen Sie uns';

  @override
  String get faq_how_to_sell => 'Wie verkaufe ich Artikel auf Tezsell?';

  @override
  String get faq_how_to_sell_answer =>
      'So verkaufen Sie Artikel: 1) Erstellen Sie ein Konto, 2) Tippen Sie auf die Schaltfläche „+“, 3) Wählen Sie eine Kategorie (Produkte/Dienstleistungen/Immobilien), 4) Fügen Sie Fotos und Beschreibung hinzu, 5) Legen Sie Ihren Preis fest, 6) Veröffentlichen! Ihr Eintrag wird für Käufer in Ihrer Nähe sichtbar sein.';

  @override
  String get faq_is_free => 'Ist die Nutzung von Tezsell kostenlos?';

  @override
  String get faq_is_free_answer =>
      'Ja! Tezsell ist derzeit 100 % kostenlos. Keine Listungsgebühren, keine Verkaufsprovision, keine Abonnementgebühren. Möglicherweise führen wir in Zukunft Premium-Funktionen ein, benachrichtigen die Benutzer jedoch 30 Tage im Voraus.';

  @override
  String get faq_safety => 'Wie kann ich beim Kauf/Verkauf sicher bleiben?';

  @override
  String get faq_safety_answer =>
      'Sicherheitstipps: 1) Treffen Sie sich an öffentlichen Orten, 2) Überprüfen Sie die Gegenstände vor dem Bezahlen, 3) Senden Sie niemals Geld an Fremde, 4) Vertrauen Sie Ihrem Instinkt, 5) Melden Sie verdächtige Benutzer, 6) Geben Sie persönliche Daten nicht zu früh weiter, 7) Bringen Sie einen Freund für Transaktionen mit hohem Betrag mit.';

  @override
  String get faq_payment => 'Wie funktionieren Zahlungen?';

  @override
  String get faq_payment_answer =>
      'Tezsell verarbeitet keine Zahlungen. Käufer und Verkäufer vereinbaren die Bezahlung direkt (Barzahlung, Banküberweisung etc.). Wir sind lediglich eine Plattform, um Menschen miteinander zu verbinden – Sie wickeln die Transaktion selbst ab.';

  @override
  String get faq_prohibited => 'Welche Gegenstände sind verboten?';

  @override
  String get faq_prohibited_answer =>
      'Zu den verbotenen Gegenständen gehören: Waffen, Drogen, gestohlene Waren, gefälschte Gegenstände, Inhalte für Erwachsene, lebende Tiere (ohne Genehmigung), Regierungsausweise und gefährliche Materialien. Die vollständige Liste finden Sie in unseren Allgemeinen Geschäftsbedingungen.';

  @override
  String get faq_account_delete => 'Wie lösche ich mein Konto?';

  @override
  String get faq_account_delete_answer =>
      'Gehen Sie zu Profil → Einstellungen → Kontoeinstellungen → Konto löschen. Hinweis: Dies ist dauerhaft und kann nicht rückgängig gemacht werden. Alle Ihre Einträge werden entfernt.';

  @override
  String get faq_report_user => 'Wie melde ich einen Benutzer oder Eintrag?';

  @override
  String get faq_report_user_answer =>
      'Tippen Sie auf die drei Punkte (•••) in einem beliebigen Eintrag oder Benutzerprofil und wählen Sie dann „Melden“. Wählen Sie den Grund und senden Sie ihn ab. Wir überprüfen alle Berichte innerhalb von 24–48 Stunden.';

  @override
  String get faq_change_location => 'Wie ändere ich meinen Standort?';

  @override
  String get faq_change_location_answer =>
      'Tippen Sie auf die Standortschaltfläche in der oberen linken Ecke des Startbildschirms. Sie können Ihre Region und Ihren Bezirk auswählen, um Einträge in Ihrer Nähe anzuzeigen.';

  @override
  String get welcome_customer_center => 'Willkommen im Kundencenter';

  @override
  String get customer_center_subtitle => 'Wir sind rund um die Uhr für Sie da';

  @override
  String get quick_actions => 'Schnelle Aktionen';

  @override
  String get live_chat => 'Live-Chat';

  @override
  String get chat_with_us => 'Chatten Sie mit uns';

  @override
  String get find_answers => 'Finden Sie Antworten';

  @override
  String get my_tickets => 'Meine Tickets';

  @override
  String get view_tickets => 'Tickets ansehen';

  @override
  String get feedback => 'Rückmeldung';

  @override
  String get share_feedback => 'Teilen Sie Feedback';

  @override
  String get contact_methods => 'Kontaktmethoden';

  @override
  String get phone_support => 'Telefonsupport';

  @override
  String get available_247 => 'Rund um die Uhr verfügbar';

  @override
  String get response_24h => 'Antwort innerhalb von 24 Stunden';

  @override
  String get telegram_support => 'Telegram-Unterstützung';

  @override
  String get instant_replies => 'Sofortige Antworten';

  @override
  String get whatsapp_support => 'WhatsApp-Unterstützung';

  @override
  String get quick_response => 'Schnelle Antwort';

  @override
  String get popular_topics => 'Beliebte Themen';

  @override
  String get account_management => 'Kontoverwaltung';

  @override
  String get reset_password => 'Passwort zurücksetzen';

  @override
  String get update_profile => 'Profil aktualisieren';

  @override
  String get verify_account => 'Konto bestätigen';

  @override
  String get delete_account => 'Konto löschen';

  @override
  String get buying_selling => 'Kaufen und Verkaufen';

  @override
  String get how_to_post => 'So veröffentlichen Sie Anzeigen';

  @override
  String get payment_methods => 'Zahlungsmethoden';

  @override
  String get shipping_delivery => 'Versand & Lieferung';

  @override
  String get return_policy => 'Rückgaberecht';

  @override
  String get safety_security => 'Sicherheit und Schutz';

  @override
  String get report_scam => 'Betrug melden';

  @override
  String get safe_trading => 'Tipps für den sicheren Handel';

  @override
  String get privacy_settings => 'Datenschutzeinstellungen';

  @override
  String get blocked_users => 'Blockierte Benutzer';

  @override
  String get technical_issues => 'Technische Probleme';

  @override
  String get app_not_working => 'App funktioniert nicht';

  @override
  String get upload_failed => 'Hochladen fehlgeschlagen';

  @override
  String get login_problems => 'Anmeldeprobleme';

  @override
  String get support_hours => 'Support-Stunden';

  @override
  String get mon_fri_9_6 => 'Mo-Fr: 9:00 - 18:00 Uhr';

  @override
  String get how_are_we_doing => 'Wie geht es uns?';

  @override
  String get rate_experience => 'Bewerten Sie Ihr Kundenservice-Erlebnis';

  @override
  String get poor => 'Arm';

  @override
  String get okay => 'Okay';

  @override
  String get good => 'Gut';

  @override
  String get excellent => 'Exzellent';

  @override
  String get account_secure => 'Ihr Konto ist sicher';

  @override
  String get password_security => 'Passwort und Authentifizierung';

  @override
  String get change_password => 'Kennwort ändern';

  @override
  String get two_factor_auth => 'Zwei-Faktor-Authentifizierung';

  @override
  String get biometric_login => 'Biometrische Anmeldung';

  @override
  String get login_activity => 'Anmeldeaktivität';

  @override
  String get active_sessions => 'Aktive Sitzungen';

  @override
  String get login_alerts => 'Login-Benachrichtigungen';

  @override
  String get account_protection => 'Kontoschutz';

  @override
  String get recovery_email => 'Wiederherstellungs-E-Mail';

  @override
  String get backup_codes => 'Backup-Codes';

  @override
  String get danger_zone => 'Gefahrenzone';

  @override
  String get improve_security => 'Verbessern Sie die Sicherheit';

  @override
  String get security_score => 'Sicherheitsbewertung';

  @override
  String get last_changed_days => 'Letzte Änderung vor 30 Tagen';

  @override
  String get logout_all_devices => 'Alle Geräte abmelden';

  @override
  String get end_all_sessions => 'Beenden Sie alle Sitzungen';

  @override
  String get permanently_delete => 'Endgültig löschen';

  @override
  String get verification_code_message =>
      'Wir senden Ihnen einen Bestätigungscode, um Ihre Identität zu bestätigen.';

  @override
  String get send_code => 'Code senden';

  @override
  String get enter_verification_code => 'Geben Sie den Bestätigungscode ein';

  @override
  String get verification_code => 'Bestätigungscode';

  @override
  String get new_password => 'Neues Passwort';

  @override
  String get confirm_password => 'Passwort bestätigen';

  @override
  String get resend_code => 'Code erneut senden';

  @override
  String get code_sent_to => 'Geben Sie den an gesendeten Bestätigungscode ein';

  @override
  String get enter_code => 'Geben Sie den Bestätigungscode ein';

  @override
  String get code_must_be_6_digits => 'Der Code muss 6-stellig sein';

  @override
  String get enter_new_password => 'Geben Sie ein neues Passwort ein';

  @override
  String get minimum_8_characters => 'Mindestens 8 Zeichen';

  @override
  String get passwords_do_not_match => 'Passwörter stimmen nicht überein';

  @override
  String get close => 'Schließen';

  @override
  String get current => 'Aktuell';

  @override
  String get session_ended => 'Sitzung beendet';

  @override
  String get update_recovery_email => 'Wiederherstellungs-E-Mail aktualisieren';

  @override
  String get new_email => 'Neue E-Mail';

  @override
  String get update => 'Aktualisieren';

  @override
  String get verification_email_sent => 'Bestätigungs-E-Mail gesendet';

  @override
  String get generate_emergency_codes => 'Notfallcodes generieren';

  @override
  String get copy_all => 'Alles kopieren';

  @override
  String get code_copied => 'Code kopiert';

  @override
  String get all_codes_copied => 'Alle Codes kopiert';

  @override
  String get logout_all_devices_confirm => 'Alle Geräte abmelden?';

  @override
  String get logout_all_devices_message =>
      'Dadurch werden alle aktiven Sitzungen auf allen Geräten beendet.';

  @override
  String get logout_all => 'Alle abmelden';

  @override
  String get delete_account_confirm => 'Konto löschen?';

  @override
  String get delete_account_warning =>
      'Diese Aktion ist DAUERHAFT und kann nicht rückgängig gemacht werden. Alle Ihre Daten werden dauerhaft gelöscht.';

  @override
  String get what_will_be_deleted => 'Was wird gelöscht:';

  @override
  String get profile_and_account_info =>
      '• Ihre Profil- und Kontoinformationen';

  @override
  String get all_listings_and_posts => '• Alle Ihre Einträge und Beiträge';

  @override
  String get messages_and_conversations => 'Nachrichten';

  @override
  String get saved_items_and_preferences =>
      '• Gespeicherte Elemente und Einstellungen';

  @override
  String get enter_password_to_continue =>
      'Geben Sie Ihr Passwort ein, um fortzufahren';

  @override
  String get continue_val => 'Weitermachen';

  @override
  String get please_enter_password => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get enter_confirmation_code => 'Geben Sie den Bestätigungscode ein';

  @override
  String get deletion_confirmation_message =>
      'Wir haben einen Bestätigungscode an Ihr Telefon gesendet. Geben Sie es unten ein, um Ihr Konto dauerhaft zu löschen.';

  @override
  String get confirmation_code => 'Bestätigungscode';

  @override
  String get please_enter_6_digit_code =>
      'Bitte geben Sie den 6-stelligen Code ein';

  @override
  String get account_deleted => 'Ihr Konto wurde gelöscht';

  @override
  String get deletion_cancelled => 'Löschung abgebrochen';

  @override
  String get failed_to_load_user_info =>
      'Benutzerinformationen konnten nicht geladen werden';

  @override
  String get auth_login_to_view_saved =>
      'Bitte melden Sie sich an, um Ihre gespeicherten Eigenschaften anzuzeigen';

  @override
  String get authLoginRequired => 'Anmeldung erforderlich';

  @override
  String get authLoginToViewSaved =>
      'Bitte melden Sie sich an, um Ihre gespeicherten Eigenschaften anzuzeigen';

  @override
  String get authLogin => 'Einloggen';

  @override
  String get savedPropertiesTitle => 'Gespeicherte Eigenschaften';

  @override
  String get loadingSavedProperties =>
      'Gespeicherte Eigenschaften werden geladen...';

  @override
  String get errorsFailedToLoadSaved =>
      'Gespeicherte Eigenschaften konnten nicht geladen werden';

  @override
  String get actionsRetry => 'Wiederholen';

  @override
  String get savedPropertiesNoSaved => 'Keine gespeicherten Eigenschaften';

  @override
  String get savedPropertiesStartSaving =>
      'Beginnen Sie mit der Erkundung und speichern Sie die Immobilien, die Ihnen gefallen';

  @override
  String get savedPropertiesBrowse => 'Durchsuchen Sie die Eigenschaften';

  @override
  String get resultsSavedProperties => 'gespeicherte Eigenschaften';

  @override
  String get actionsRefresh => 'Aktualisieren';

  @override
  String get resultsNoMoreProperties => 'Keine weiteren Eigenschaften';

  @override
  String get propertyCardFeatured => 'Hervorgehoben';

  @override
  String get successPropertyUnsaved =>
      'Eigenschaft aus der gespeicherten Liste entfernt';

  @override
  String get alertsUnsavePropertyFailed =>
      'Die Eigenschaft konnte nicht entfernt werden';

  @override
  String get propertyCardBed => 'Bett';

  @override
  String get propertyCardBath => 'Bad';

  @override
  String get savedPropertiesSavedOn => 'Gespeichert am';

  @override
  String get propertyCardViewDetails => 'Details anzeigen';

  @override
  String get serviceDetailTitle => 'Servicedetails';

  @override
  String get errorLoadingFavorites => 'Fehler beim Laden der Lieblingsartikel';

  @override
  String get noFavoritesFound => 'Keine Lieblingsartikel gefunden.';

  @override
  String get commentUpdatedSuccess => 'Kommentar erfolgreich aktualisiert!';

  @override
  String get errorUpdatingComment => 'Fehler beim Aktualisieren des Kommentars';

  @override
  String get replyAddedSuccess => 'Antwort erfolgreich hinzugefügt!';

  @override
  String get errorAddingReply => 'Fehler beim Hinzufügen der Antwort';

  @override
  String get commentDeletedSuccess => 'Kommentar erfolgreich gelöscht!';

  @override
  String get errorDeletingComment => 'Fehler beim Löschen des Kommentars';

  @override
  String get serviceLikedSuccess => 'Service hat mir gut gefallen!';

  @override
  String get errorLikingService => 'Fehler beim Liken des Dienstes';

  @override
  String get serviceDislikedSuccess => 'Service erfolgreich abgelehnt!';

  @override
  String get errorDislikingService => 'Fehler beim Ablehnen des Dienstes';

  @override
  String get writeYourReply => 'Schreiben Sie Ihre Antwort...';

  @override
  String get postReply => 'Antwort posten';

  @override
  String get anonymous => 'Anonym';

  @override
  String get editComment => 'Kommentar bearbeiten';

  @override
  String get editYourComment => 'Bearbeiten Sie Ihren Kommentar...';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get propertyOwner => 'Immobilieneigentümer';

  @override
  String get errorLoadingServices => 'Fehler beim Laden der Dienste';

  @override
  String get noRecommendedServicesFound =>
      'Keine empfohlenen Dienste gefunden.';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get passwordTooShort =>
      'Das Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get passwordRequirements =>
      'Das Passwort muss Buchstaben und Zahlen enthalten';

  @override
  String get usernameRequired => 'Benutzername ist erforderlich';

  @override
  String get usernameTooShort =>
      'Der Benutzername muss mindestens 3 Zeichen lang sein';

  @override
  String get confirmPasswordRequired =>
      'Eine Passwortbestätigung ist erforderlich';

  @override
  String get passwordHelp => 'Mindestens 8 Zeichen, Buchstaben und Zahlen';

  @override
  String get usernameExists => 'Dieser Benutzername existiert bereits';

  @override
  String get phoneExists => 'Diese Telefonnummer ist bereits registriert';

  @override
  String get networkError =>
      'Fehler bei der Netzwerkverbindung. Bitte überprüfen Sie Ihre Verbindung';

  @override
  String get contactSeller => 'Verkäufer kontaktieren';

  @override
  String get callToReveal => 'Tippen Sie zum Anzeigen auf „Anrufen“.';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galerie';

  @override
  String get selectImageSource => 'Wählen Sie Bildquelle';

  @override
  String get uploading => 'Hochladen...';

  @override
  String get acceptTermsRequired =>
      'Sie müssen die Allgemeinen Geschäftsbedingungen akzeptieren, um fortfahren zu können';

  @override
  String get iAgreeToTerms => 'Ich stimme dem zu';

  @override
  String get termsAndConditions => 'Geschäftsbedingungen';

  @override
  String get zeroToleranceStatement =>
      'und verstehen Sie, dass es keine Toleranz für anstößige Inhalte oder missbräuchliche Benutzer gibt.';

  @override
  String get viewTerms => 'Allgemeine Geschäftsbedingungen ansehen';

  @override
  String get reportContent => 'Inhalt melden';

  @override
  String get selectReportReason =>
      'Bitte wählen Sie einen Grund für die Meldung aus:';

  @override
  String get additionalDetails => 'Zusätzliche Details (optional)';

  @override
  String get reportDetailsHint => 'Geben Sie weitere Informationen an...';

  @override
  String get reportSubmitted =>
      'Vielen Dank für Ihren Bericht. Wir werden es innerhalb von 24 Stunden überprüfen.';

  @override
  String get reportProduct => 'Produkt melden';

  @override
  String get reportService => 'Meldedienst';

  @override
  String get reportMessage => 'Nachricht melden';

  @override
  String get reportUser => 'Benutzer melden';

  @override
  String get reportErrorNotImplemented =>
      'Die Berichtsfunktion ist noch nicht verfügbar. Bitte wenden Sie sich an den Support oder versuchen Sie es später erneut.';

  @override
  String get reportAlreadySubmitted =>
      'Sie haben diesen Inhalt bereits gemeldet. Wir überprüfen Ihren vorherigen Bericht.';

  @override
  String get reportFailedGeneric =>
      'Fehler beim Senden des Berichts. Bitte versuchen Sie es erneut.';

  @override
  String get reportFailedNetwork =>
      'Es ist ein Netzwerkfehler aufgetreten. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get becomeAgentTitle => 'Werden Sie Immobilienmakler';

  @override
  String get becomeAgentSubtitle =>
      'Listen Sie Immobilien auf und helfen Sie Kunden, ihr Traumhaus zu finden';

  @override
  String get agentBenefits => 'Vorteile:';

  @override
  String get agentBenefitVerified => 'Verifizierter Agentenausweis';

  @override
  String get agentBenefitAnalytics => 'Zugriff auf Analysen und Erkenntnisse';

  @override
  String get agentBenefitClients => 'Direkter Kontakt mit potenziellen Kunden';

  @override
  String get agentBenefitReputation => 'Bauen Sie Ihren beruflichen Ruf auf';

  @override
  String get agentApplicationForm => 'Antragsformular';

  @override
  String get agentAgencyName => 'Name der Agentur';

  @override
  String get agentAgencyNameHint =>
      'Geben Sie den Namen Ihrer Immobilienagentur ein';

  @override
  String get agentAgencyNameRequired => 'Der Name der Agentur ist erforderlich';

  @override
  String get agentLicenceNumber => 'Amtliches Kennzeichen';

  @override
  String get agentLicenceNumberHint =>
      'Geben Sie Ihre Immobilienlizenznummer ein';

  @override
  String get agentLicenceNumberRequired => 'Lizenznummer ist erforderlich';

  @override
  String get agentYearsExperience => 'Jahrelange Erfahrung';

  @override
  String get agentYearsExperienceHint => 'Geben Sie die Anzahl der Jahre ein';

  @override
  String get agentYearsExperienceRequired =>
      'Langjährige Erfahrung ist erforderlich';

  @override
  String get agentYearsExperienceInvalid =>
      'Bitte geben Sie eine gültige Nummer ein';

  @override
  String get agentSpecialization => 'Spezialisierung';

  @override
  String get agentApplicationNote =>
      'Ihre Bewerbung wird von unserem Team geprüft. Sie werden benachrichtigt, sobald Ihr Antrag genehmigt wurde.';

  @override
  String get agentSubmitApplication => 'Bewerbung einreichen';

  @override
  String get agentApplicationSubmitted =>
      'Bewerbung erfolgreich eingereicht! Wir werden es bald überprüfen.';

  @override
  String get agentApplicationStatus => 'Bewerbungsstatus';

  @override
  String get agentViewProfile => 'Sehen Sie sich Ihr Agentenprofil an';

  @override
  String get agentDashboardComingSoon => 'Agenten-Dashboard bald verfügbar!';

  @override
  String get property_create_basic_information => 'Grundlegende Informationen';

  @override
  String get property_create_property_title => 'Eigentumstitel *';

  @override
  String get property_create_property_title_hint =>
      'z. B. Modernes 3-Zimmer-Apartment im Stadtzentrum';

  @override
  String get property_create_property_title_required =>
      'Bitte geben Sie den Eigentumstitel ein';

  @override
  String get property_create_description => 'Beschreibung *';

  @override
  String get property_create_description_hint =>
      'Beschreiben Sie Ihre Immobilie im Detail...';

  @override
  String get property_create_description_required =>
      'Bitte geben Sie eine Beschreibung ein';

  @override
  String get property_create_property_type => 'Immobilientyp';

  @override
  String get property_create_property_type_required => 'Immobilientyp *';

  @override
  String get property_create_listing_type_required => 'Eintragstyp *';

  @override
  String get property_create_pricing => 'Preise';

  @override
  String get property_create_price => 'Preis *';

  @override
  String get property_create_price_hint => 'Geben Sie den Preis ein';

  @override
  String get property_create_price_required => 'Bitte geben Sie den Preis ein';

  @override
  String get property_create_currency => 'Währung';

  @override
  String get property_create_property_details => 'Details zur Immobilie';

  @override
  String get property_create_square_meters => 'Quadrat. Meter *';

  @override
  String get property_create_bedrooms => 'Schlafzimmer *';

  @override
  String get property_create_bathrooms => 'Badezimmer *';

  @override
  String get property_create_floor => 'Boden';

  @override
  String get property_create_total_floors => 'Gesamtanzahl der Etagen';

  @override
  String get property_create_parking => 'Parken';

  @override
  String get property_create_year_built => 'Baujahr';

  @override
  String get property_create_location => 'Standort';

  @override
  String get property_create_address => 'Adresse *';

  @override
  String get property_create_address_hint =>
      'Geben Sie die Adresse der Unterkunft ein';

  @override
  String get property_create_address_required => 'Bitte Adresse eingeben';

  @override
  String get property_create_location_detected => 'Standort erkannt';

  @override
  String get property_create_get_location => 'Aktuellen Standort abrufen';

  @override
  String get property_create_features => 'Merkmale';

  @override
  String get property_create_feature_balcony => 'Balkon';

  @override
  String get property_create_feature_garage => 'Garage';

  @override
  String get property_create_feature_garden => 'Garten';

  @override
  String get property_create_feature_pool => 'Pool';

  @override
  String get property_create_feature_elevator => 'Aufzug';

  @override
  String get property_create_feature_furnished => 'Möbliert';

  @override
  String get property_create_images => 'Immobilienbilder';

  @override
  String get property_create_tap_to_add_images =>
      'Tippen Sie, um Bilder hinzuzufügen';

  @override
  String get property_create_at_least_one_image =>
      'Mindestens 1 Bild erforderlich';

  @override
  String get property_create_add_more => 'Weitere hinzufügen';

  @override
  String get property_create_required => 'Erforderlich';

  @override
  String get property_create_location_required =>
      'Bitte aktivieren Sie die Ortungsdienste, um eine Immobilie zu erstellen';

  @override
  String get property_create_image_required =>
      'Es ist mindestens ein Immobilienbild erforderlich';

  @override
  String get emailVerification => 'E-Mail-Verifizierung';

  @override
  String get pleaseEnterYourEmailAddress =>
      'Bitte geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get enterEmailAddress => 'Geben Sie die E-Mail-Adresse ein';

  @override
  String get resetYourPassword => 'Setzen Sie Ihr Passwort zurück';

  @override
  String get resetPasswordDescription =>
      'Geben Sie Ihre E-Mail-Adresse ein und wir senden Ihnen einen Bestätigungscode zum Zurücksetzen Ihres Passworts.';

  @override
  String get sendVerificationCode => 'Bestätigungscode senden';

  @override
  String get backToLogin => 'Zurück zum Anmelden';

  @override
  String get resetPassword => 'Passwort zurücksetzen';

  @override
  String enterVerificationCodeSentTo(String email) {
    return 'Geben Sie den an $email gesendeten Bestätigungscode ein.';
  }

  @override
  String get codeMustBe6Digits => 'Der Code muss 6-stellig sein';

  @override
  String get enterNewPassword => 'Geben Sie ein neues Passwort ein';

  @override
  String get minimum8Characters => 'Mindestens 8 Zeichen';

  @override
  String get sending => 'Senden...';

  @override
  String get verifying => 'Überprüfung...';

  @override
  String get new_message => 'Neue Nachricht';

  @override
  String get messages => 'Nachrichten';

  @override
  String get please_log_in =>
      'Bitte melden Sie sich an, um Nachrichten anzuzeigen';

  @override
  String get pin => 'Stift';

  @override
  String get unpin => 'Lösen';

  @override
  String get delete_chat => 'Chat löschen';

  @override
  String delete_chat_confirm(String name) {
    return 'Sind Sie sicher, dass Sie den Chat mit $name löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String chat_deleted(String name) {
    return 'Chat mit $name gelöscht';
  }

  @override
  String get delete_failed => 'Der Chat konnte nicht gelöscht werden';

  @override
  String get no_conversations => 'Noch keine Gespräche';

  @override
  String get start_conversation_hint =>
      'Starten Sie ein Gespräch, indem Sie auf die Schaltfläche „+“ tippen';

  @override
  String get start_conversation => 'Starten Sie ein Gespräch';

  @override
  String get yesterday => 'Gestern';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get no_messages_yet => 'Noch keine Nachrichten';

  @override
  String get unblock_user => 'Benutzer entsperren';

  @override
  String get block_user => 'Benutzer blockieren';

  @override
  String get no_blocked_users => 'Keine blockierten Benutzer';

  @override
  String get blocked_users_hint =>
      'Von Ihnen blockierte Benutzer werden hier angezeigt';

  @override
  String unblock_user_confirm(String username) {
    return 'Sind Sie sicher, dass Sie $username entsperren möchten? Sie können wieder Nachrichten von ihnen empfangen.';
  }

  @override
  String user_unblocked(String username) {
    return '$username wurde entsperrt';
  }

  @override
  String user_blocked(String username) {
    return '$username wurde blockiert';
  }

  @override
  String get failed_to_unblock => 'Benutzer konnte nicht entsperrt werden';

  @override
  String get failed_to_block => 'Benutzer konnte nicht blockiert werden';

  @override
  String get chat_info => 'Chat-Informationen';

  @override
  String get delete_message => 'Nachricht löschen';

  @override
  String get delete_message_confirm =>
      'Sind Sie sicher, dass Sie diese Nachricht löschen möchten?';

  @override
  String get typing => 'tippe...';

  @override
  String get online => 'online';

  @override
  String get offline => 'offline';

  @override
  String last_seen_at(String time) {
    return 'zuletzt gesehen $time';
  }

  @override
  String participants(int count) {
    return '$count Teilnehmer';
  }

  @override
  String get you_are_blocked => 'Du bist blockiert';

  @override
  String user_blocked_you(String username) {
    return '$username hat dich blockiert. Sie können keine Nachrichten senden.';
  }

  @override
  String you_blocked_user(String username) {
    return 'Sie haben $username blockiert';
  }

  @override
  String get cannot_send_messages_blocked =>
      'Sie können keine Nachrichten senden. Sie wurden blockiert.';

  @override
  String get this_message_was_deleted => 'Diese Nachricht wurde gelöscht';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get reply => 'Antwort';

  @override
  String get editing_message => 'Nachricht wird bearbeitet';

  @override
  String replying_to(String username) {
    return 'Auf $username antworten';
  }

  @override
  String get voice => 'Stimme';

  @override
  String get emoji => 'Emoji';

  @override
  String get photo => '📷 Foto';

  @override
  String get voice_message => '🎤 Sprachnachricht';

  @override
  String get searching => 'Suche...';

  @override
  String get loading_users => 'Benutzer werden geladen...';

  @override
  String search_failed(String error) {
    return 'Suche fehlgeschlagen: $error';
  }

  @override
  String get invalid_user_data => 'Ungültige Benutzerdaten';

  @override
  String failed_to_start_chat(String error) {
    return 'Chat konnte nicht gestartet werden: $error';
  }

  @override
  String get audio_file_not_available => 'Audiodatei nicht verfügbar';

  @override
  String failed_to_play_audio(String error) {
    return 'Audio konnte nicht abgespielt werden: $error';
  }

  @override
  String get image_unavailable => 'Bild nicht verfügbar';

  @override
  String get image_too_large =>
      '❌ Bild ist zu groß. Die maximale Größe beträgt 10 MB';

  @override
  String get image_file_not_found => '❌ Bilddatei nicht gefunden';

  @override
  String get uploading_image => 'Bild wird hochgeladen...';

  @override
  String get image_sent => '✅ Bild gesendet!';

  @override
  String get failed_to_send_image => '❌ Bild konnte nicht gesendet werden';

  @override
  String get uploading_voice_message => 'Sprachnachricht wird hochgeladen...';

  @override
  String get voice_message_sent => '✅ Sprachnachricht gesendet!';

  @override
  String get failed_to_send_voice_message =>
      '❌ Sprachnachricht konnte nicht gesendet werden';

  @override
  String get recording => '🎙️ Aufnahme...';

  @override
  String get microphone_permission_denied => 'Mikrofonberechtigung verweigert';

  @override
  String get starting_chat => 'Chat wird gestartet...';

  @override
  String get refresh_users => 'Benutzer aktualisieren';

  @override
  String get search_by_username_or_phone =>
      'Suchen Sie nach Benutzername oder Telefonnummer';

  @override
  String get no_users_found => 'Keine Benutzer gefunden';

  @override
  String get try_different_search_term =>
      'Versuchen Sie es mit einem anderen Suchbegriff';

  @override
  String get no_users_available => 'Keine Benutzer verfügbar';

  @override
  String get chat_exists => 'Chat existiert';

  @override
  String block_user_confirm(String username) {
    return 'Sind Sie sicher, dass Sie $username blockieren möchten? Sie erhalten keine Nachrichten von ihnen und sie werden aus Ihrer Chat-Liste entfernt.';
  }

  @override
  String chat_room_label(String name) {
    return 'Chatraum: $name';
  }

  @override
  String id_label(int id) {
    return 'ID: $id';
  }

  @override
  String get participants_label => 'Teilnehmer:';

  @override
  String get type_a_message => 'Geben Sie eine Nachricht ein...';

  @override
  String get edit_message_hint => 'Nachricht bearbeiten...';

  @override
  String error_label(String error) {
    return 'Fehler: $error';
  }

  @override
  String get copy => 'Kopie';

  @override
  String comments_title(int count) {
    return 'Kommentare ($count)';
  }

  @override
  String get reply_button => 'Antwort';

  @override
  String replies_count(int count) {
    return '$count antwortet';
  }

  @override
  String get you_label => 'Du';

  @override
  String get delete_reply_title => 'Antwort löschen';

  @override
  String get delete_comment_title => 'Kommentar löschen';

  @override
  String get unknown_date => 'Unbekanntes Datum';

  @override
  String get press_enter_to_send => 'Drücken Sie zum Senden die Eingabetaste';

  @override
  String get comment_add_error => 'Kommentar konnte nicht hinzugefügt werden';

  @override
  String get service_provider => 'Dienstleister';

  @override
  String get opening_chat => 'Chat wird geöffnet...';

  @override
  String get failed_to_refresh => 'Aktualisierung fehlgeschlagen';

  @override
  String get cannot_chat_with_yourself =>
      'Sie können nicht mit sich selbst chatten';

  @override
  String opening_chat_with(String username) {
    return 'Chat mit $username eröffnen...';
  }

  @override
  String get this_will_only_take_a_moment =>
      'Dies wird nur einen Moment dauern';

  @override
  String get unable_to_start_chat =>
      'Der Chat kann nicht gestartet werden. Bitte versuchen Sie es erneut.';

  @override
  String get profile_listings => 'Einträge';

  @override
  String get profile_followers => 'Anhänger';

  @override
  String get profile_following => 'Nachfolgend';

  @override
  String get profile_no_products => 'Keine Produkte';

  @override
  String get profile_no_services => 'Keine Dienstleistungen';

  @override
  String get profile_no_properties => 'Keine Eigenschaften';

  @override
  String get profile_user_no_products =>
      'Dieser Benutzer hat noch keine Produkte gepostet';

  @override
  String get profile_user_no_services =>
      'Dieser Benutzer hat noch keine Dienste gepostet';

  @override
  String get profile_user_no_properties =>
      'Dieser Benutzer hat noch keine Eigenschaften gepostet';

  @override
  String get profile_error_occurred => 'Es ist ein Fehler aufgetreten';

  @override
  String get profile_error_loading_products => 'Fehler beim Laden der Produkte';

  @override
  String get profile_error_loading_services => 'Fehler beim Laden der Dienste';

  @override
  String get profile_no_followers_yet => 'Noch keine Follower';

  @override
  String get profile_no_following_yet => 'Ich folge noch niemandem';

  @override
  String get profile_follow => 'Folgen';

  @override
  String get profile_following_btn => 'Nachfolgend';

  @override
  String get profile_message => 'Nachricht';

  @override
  String get profile_member_since => 'Mitglied seit';

  @override
  String get profile_loading_error => 'Fehler beim Laden des Profils';

  @override
  String get profile_retry => 'Versuchen Sie es erneut';

  @override
  String get profile_share => 'Aktie';

  @override
  String get profile_copy_link => 'Link kopieren';

  @override
  String get profile_report => 'Bericht';

  @override
  String get linkCopied => 'Link in die Zwischenablage kopiert';

  @override
  String get checkOutProfile => 'Kasse';

  @override
  String get onTezsell => 'auf TezSell';

  @override
  String get selectCountryFirst => 'Wählen Sie zuerst das Land aus';

  @override
  String get countrySelectionHint =>
      'Anschließend können Sie Ihre Region auswählen';

  @override
  String get something_went_wrong => 'Etwas ist schief gelaufen';

  @override
  String get check_connection_and_retry =>
      'Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut';

  @override
  String get sold_badge => 'VERKAUFT';

  @override
  String get more_categories => 'Mehr';

  @override
  String no_products_in_location(String location) {
    return 'Keine Produkte gefunden in $location';
  }

  @override
  String get no_more_products => 'Es müssen keine Produkte mehr geladen werden';

  @override
  String time_days_ago(int count) {
    return 'Vor ${count}d';
  }

  @override
  String time_hours_ago(int count) {
    return 'Vor ${count}h';
  }

  @override
  String time_minutes_ago(int count) {
    return 'Vor ${count}M';
  }

  @override
  String get time_just_now => 'Soeben';

  @override
  String no_services_in_location(String location) {
    return 'Keine Dienste in $location gefunden';
  }

  @override
  String get no_more_services =>
      'Es müssen keine weiteren Dienste geladen werden';

  @override
  String get error_loading_more_services =>
      'Fehler beim Laden weiterer Dienste';

  @override
  String get verification_code_length =>
      'Der Bestätigungscode muss 6-stellig sein';

  @override
  String get map_register_title => 'Wo wohnst du?';

  @override
  String get map_register_headline =>
      'Wählen Sie Ihr Viertel auf der Karte aus';

  @override
  String get map_register_subtitle =>
      'Wir nutzen es, um Ihnen Käufer und Verkäufer in Ihrer Nähe anzuzeigen. Sie können Ihren Radius später anpassen.';

  @override
  String get pick_on_map => 'Auf der Karte auswählen';

  @override
  String get pick_again => 'Wählen Sie noch einmal';

  @override
  String get resolving_location => 'Standort wird aufgelöst...';

  @override
  String get use_dropdown_instead =>
      'Verwenden Sie stattdessen das Dropdown-Menü';

  @override
  String country_not_supported(String country) {
    return 'Wir unterstützen $country noch nicht.';
  }

  @override
  String get region_not_auto_detected =>
      'Ihre Region konnte nicht automatisch erkannt werden. Wählen Sie sie manuell aus.';

  @override
  String get district_not_auto_detected =>
      'Ihr Bezirk konnte nicht automatisch erkannt werden. Wählen Sie ihn manuell aus.';

  @override
  String get browse_no_items_with_location =>
      'In diesem Bereich gibt es noch keine Artikel mit Standortdaten.';

  @override
  String get mapLoadError => 'Could not load properties on the map';

  @override
  String get location_picker_title => 'Standort festlegen';

  @override
  String get location_picker_confirm => 'Standort bestätigen';

  @override
  String get location_picker_resolve_failed =>
      'Adresse konnte nicht aufgelöst werden. Wählen Sie sie erneut aus oder bestätigen Sie nur mit Koordinaten';

  @override
  String get location_picker_selected_fallback => 'Ausgewählter Ort';

  @override
  String get location_permission_denied => 'Standortberechtigung verweigert';

  @override
  String get location_permission_denied_settings =>
      'Standortberechtigung verweigert – bitte in den Einstellungen aktivieren';

  @override
  String get location_permission_permanent =>
      'Standort dauerhaft verweigert – öffnen Sie die Einstellungen, um ihn zu aktivieren';

  @override
  String gps_error(String error) {
    return 'GPS-Fehler: $error';
  }

  @override
  String get verify_neighborhood_title => 'Überprüfen Sie Ihre Nachbarschaft';

  @override
  String get verify_neighborhood_subtitle =>
      'Stehen Sie in Ihrer Nachbarschaft. Wir überprüfen Ihr GPS und bitten Sie um eine Bestätigung.';

  @override
  String get verify_neighborhood_button => 'Nachbarschaft überprüfen';

  @override
  String get verify_neighborhood_low_confidence =>
      'Fahren Sie mit geringem Selbstvertrauen fort';

  @override
  String get verify_neighborhood_retry => 'Wiederholen';

  @override
  String get verify_neighborhood_youre_in => 'Sie befinden sich in:';

  @override
  String verify_neighborhood_done(String name) {
    return 'Verifiziert! $name';
  }

  @override
  String gps_accuracy_too_low(String meters) {
    return 'Die GPS-Genauigkeit beträgt ${meters}m (Benötigung ≤100 m). Gehen Sie zu einem freien Bereich und versuchen Sie es erneut.';
  }

  @override
  String get neighborhood_not_identified =>
      'Die Nachbarschaft für Ihren Standort konnte nicht identifiziert werden.';

  @override
  String get unknown_error => 'Unbekannter Fehler';

  @override
  String get place_search_hint =>
      'Suchen Sie nach einer Adresse oder einem Ort';

  @override
  String get place_search_unavailable =>
      'Suche nicht verfügbar – hinterlassen Sie stattdessen eine Stecknadel';

  @override
  String get radius_slider_city => 'Stadt';

  @override
  String radius_slider_km(String value) {
    return '$value km';
  }

  @override
  String get my_neighborhoods => 'Meine Stadtteile';

  @override
  String get manage_on_map => 'Auf Karte verwalten';

  @override
  String get no_neighborhoods_yet =>
      'Noch keine verifizierten Stadtteile. Öffne die Karte, um deinen Standort zu verifizieren.';

  @override
  String get open_map_to_verify =>
      'Karte öffnen, um neuen Standort zu verifizieren';

  @override
  String get verify_here => 'Hier verifizieren';

  @override
  String get verify_new_location => 'Neuen Standort verifizieren';

  @override
  String eviction_warning(String name) {
    return 'Das Hinzufügen dieses Standorts entfernt $name (deinen ältesten). Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get verified_today => 'Heute verifiziert';

  @override
  String get verified_yesterday => 'Gestern verifiziert';

  @override
  String verified_n_days_ago(int days) {
    return 'Vor $days Tagen verifiziert';
  }

  @override
  String get active_neighborhood => 'Aktiv';

  @override
  String switch_neighborhood_success(String name) {
    return 'Zu $name gewechselt';
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
