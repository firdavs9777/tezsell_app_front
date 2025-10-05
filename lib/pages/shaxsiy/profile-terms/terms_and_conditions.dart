import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  String _selectedLanguage = 'en'; // Default to English

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Detect current locale
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'ru' || locale == 'uz' || locale == 'en') {
      _selectedLanguage = locale;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor,
                theme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.customer_terms ?? 'Terms and Conditions',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          // Language selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: (String language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    Text('🇬🇧  English'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'ru',
                child: Row(
                  children: [
                    Text('🇷🇺  Русский'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'uz',
                child: Row(
                  children: [
                    Text('🇺🇿  O\'zbek'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor.withOpacity(0.1),
                    theme.primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    width: 68,
                    height: 68,
                    'assets/logo/logo.png',
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if logo doesn't load
                      return Icon(
                        Icons.apps,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'TEZSELL CORPORATION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedLanguage == 'en'
                        ? 'Terms and Conditions'
                        : _selectedLanguage == 'ru'
                            ? 'Условия использования'
                            : 'Foydalanish shartlari',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Updated: October 4, 2025',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content based on selected language
            if (_selectedLanguage == 'en') _buildEnglishContent(theme),
            if (_selectedLanguage == 'ru') _buildRussianContent(theme),
            if (_selectedLanguage == 'uz') _buildUzbekContent(theme),

            const SizedBox(height: 24),

            // Contact Information Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.contact_mail, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        _selectedLanguage == 'en'
                            ? 'Contact Information'
                            : _selectedLanguage == 'ru'
                                ? 'Контактная информация'
                                : 'Aloqa ma\'lumotlari',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.email, 'support@tezsell.uz'),
                  _buildContactRow(Icons.gavel, 'legal@tezsell.uz'),
                  _buildContactRow(Icons.location_on, 'Tashkent, Uzbekistan'),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: Colors.grey[800],
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ENGLISH CONTENT
  Widget _buildEnglishContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('1. ACCEPTANCE OF TERMS', theme),
        _buildParagraph(
          'By accessing or using the Tezsell mobile application ("App"), you agree to be bound by these Terms and Conditions ("Terms"). If you do not agree to these Terms, do not use the App.',
        ),
        _buildParagraph(
          'Tezsell Corporation ("we," "us," "our") reserves the right to modify these Terms at any time. Your continued use of the App after changes constitutes acceptance of the modified Terms.',
        ),
        _buildSectionTitle('2. ELIGIBILITY', theme),
        _buildBulletPoint('You must be at least 13 years old to use this App'),
        _buildBulletPoint(
            'If you are under 18, you must have parental or guardian consent'),
        _buildBulletPoint('You must provide accurate registration information'),
        _buildBulletPoint(
            'You are responsible for maintaining the confidentiality of your account credentials'),
        _buildBulletPoint(
            'One person or business may not maintain more than one account'),
        _buildSectionTitle('3. MARKETPLACE SERVICES', theme),
        _buildSubsectionTitle('Platform Purpose:'),
        _buildParagraph(
          'Tezsell provides a platform connecting buyers and sellers for Products (new and used items), Services (professional and personal services), and Real Estate (property sales and rentals).',
        ),
        _buildSubsectionTitle('Important Limitations:'),
        _buildBulletPoint('Tezsell is a MARKETPLACE PLATFORM ONLY'),
        _buildBulletPoint(
            'We do NOT participate in actual transactions between users'),
        _buildBulletPoint(
            'We do NOT guarantee the quality, safety, or legality of items/services'),
        _buildBulletPoint(
            'We are NOT responsible for user interactions or disputes'),
        _buildBulletPoint(
            'All transactions occur directly between buyers and sellers'),
        _buildSectionTitle('4. PROHIBITED ITEMS', theme),
        _buildSubsectionTitle('Illegal Items:'),
        _buildBulletPoint('Weapons, firearms, ammunition, explosives'),
        _buildBulletPoint('Illegal drugs, controlled substances'),
        _buildBulletPoint('Stolen goods or counterfeit items'),
        _buildBulletPoint('Government-issued IDs or licenses'),
        _buildSubsectionTitle('Regulated Items:'),
        _buildBulletPoint('Tobacco products or smoking accessories'),
        _buildBulletPoint('Alcoholic beverages'),
        _buildBulletPoint('Prescription medications'),
        _buildBulletPoint('Hazardous or dangerous materials'),
        _buildSubsectionTitle('Adult Content:'),
        _buildBulletPoint('Pornography or adult content'),
        _buildBulletPoint('Sexual services or escort services'),
        _buildSubsectionTitle('Other Prohibited:'),
        _buildBulletPoint(
            'Live animals (except verified breeders with permits)'),
        _buildBulletPoint('Human body parts or bodily fluids'),
        _buildBulletPoint('Lottery tickets or gambling services'),
        _buildBulletPoint('Pyramid schemes or MLM'),
        _buildBulletPoint('Hacking tools or malware'),
        _buildSectionTitle('5. USER CONDUCT', theme),
        _buildSubsectionTitle('You agree to:'),
        _buildBulletPoint('Treat other users with respect and professionalism'),
        _buildBulletPoint('Communicate honestly and transparently'),
        _buildBulletPoint('Honor your commitments to buy or sell'),
        _buildBulletPoint('Meet in safe, public locations for transactions'),
        _buildBulletPoint('Report suspicious or inappropriate behavior'),
        _buildSubsectionTitle('You agree NOT to:'),
        _buildBulletPoint('Scam, defraud, or mislead other users'),
        _buildBulletPoint('Use offensive, abusive, or threatening language'),
        _buildBulletPoint(
            'Discriminate based on race, religion, gender, nationality'),
        _buildBulletPoint('Create fake listings or accounts'),
        _buildBulletPoint('Leave false reviews or ratings'),
        _buildSectionTitle('6. PAYMENTS & TRANSACTIONS', theme),
        _buildParagraph(
          'Currently, Tezsell does NOT process payments. All payment arrangements are made directly between buyers and sellers. Users may use cash, bank transfers, or any mutually agreed payment method. Tezsell is NOT responsible for payment disputes.',
        ),
        _buildSubsectionTitle('Transaction Safety:'),
        _buildBulletPoint('Meet in public, well-lit locations'),
        _buildBulletPoint('Inspect items thoroughly before purchasing'),
        _buildBulletPoint('Never send money to someone you haven\'t met'),
        _buildBulletPoint('Trust your instincts'),
        _buildSectionTitle('7. FEES AND CHARGES', theme),
        _buildParagraph(
          'Tezsell is currently FREE to use. No fees for posting listings, no commission on sales, and no subscription charges. We reserve the right to introduce fees in the future with 30 days notice.',
        ),
        _buildSectionTitle('8. DISCLAIMERS', theme),
        _buildParagraph(
          'TO THE MAXIMUM EXTENT PERMITTED BY LAW: The App is provided "AS IS" and "AS AVAILABLE". We make NO WARRANTIES about the App\'s reliability, accuracy, or availability. We are NOT responsible for the quality, safety, legality, or accuracy of listings. You use the App at your own risk.',
        ),
        _buildSectionTitle('9. LIMITATION OF LIABILITY', theme),
        _buildParagraph(
          'Tezsell Corporation shall NOT be liable for indirect, incidental, special, or consequential damages, loss of profits, personal injury, or property damage from transactions. Our total liability shall not exceed the amount you paid to Tezsell in the 12 months prior (currently zero).',
        ),
        _buildSectionTitle('10. DISPUTE RESOLUTION', theme),
        _buildParagraph(
          'These Terms are governed by the laws of the Republic of Uzbekistan. Any disputes shall be resolved in the courts of Tashkent, Uzbekistan. Before filing any legal action, you agree to attempt informal resolution by contacting us at: support@tezsell.uz',
        ),
        _buildSectionTitle('11. TERMINATION', theme),
        _buildParagraph(
          'You may delete your account at any time through the App settings. We may suspend or terminate your account if you violate these Terms, engage in fraudulent activity, or if the account has been inactive for over 12 months.',
        ),
        _buildSectionTitle('12. CONTACT US', theme),
        _buildParagraph(
          'For questions, concerns, or reports, please contact us at support@tezsell.uz or legal@tezsell.uz',
        ),
      ],
    );
  }

  // RUSSIAN CONTENT
  Widget _buildRussianContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('1. ПРИНЯТИЕ УСЛОВИЙ', theme),
        _buildParagraph(
          'Используя мобильное приложение Tezsell ("Приложение"), вы соглашаетесь соблюдать настоящие Условия использования ("Условия"). Если вы не согласны с этими Условиями, не используйте Приложение.',
        ),
        _buildParagraph(
          'Tezsell Corporation ("мы", "нас", "наш") оставляет за собой право изменять эти Условия в любое время. Продолжение использования Приложения после внесения изменений означает принятие измененных Условий.',
        ),
        _buildSectionTitle('2. ПРАВО НА ИСПОЛЬЗОВАНИЕ', theme),
        _buildBulletPoint(
            'Вам должно быть не менее 13 лет для использования этого Приложения'),
        _buildBulletPoint(
            'Если вам меньше 18 лет, необходимо согласие родителей или опекуна'),
        _buildBulletPoint(
            'Вы должны предоставить точную регистрационную информацию'),
        _buildBulletPoint(
            'Вы несете ответственность за сохранность учетных данных'),
        _buildBulletPoint(
            'Одно лицо или компания не может иметь более одного аккаунта'),
        _buildSectionTitle('3. УСЛУГИ МАРКЕТПЛЕЙСА', theme),
        _buildSubsectionTitle('Назначение платформы:'),
        _buildParagraph(
          'Tezsell предоставляет платформу, соединяющую покупателей и продавцов для Товаров (новых и б/у), Услуг (профессиональных и личных) и Недвижимости (продажа и аренда).',
        ),
        _buildSubsectionTitle('Важные ограничения:'),
        _buildBulletPoint('Tezsell - это ТОЛЬКО ПЛАТФОРМА МАРКЕТПЛЕЙСА'),
        _buildBulletPoint(
            'Мы НЕ участвуем в фактических сделках между пользователями'),
        _buildBulletPoint(
            'Мы НЕ гарантируем качество, безопасность или законность товаров/услуг'),
        _buildBulletPoint(
            'Мы НЕ несем ответственности за взаимодействие пользователей или споры'),
        _buildSectionTitle('4. ЗАПРЕЩЕННЫЕ ТОВАРЫ', theme),
        _buildSubsectionTitle('Незаконные товары:'),
        _buildBulletPoint(
            'Оружие, огнестрельное оружие, боеприпасы, взрывчатые вещества'),
        _buildBulletPoint('Наркотики, контролируемые вещества'),
        _buildBulletPoint('Краденое имущество или контрафакт'),
        _buildBulletPoint('Государственные удостоверения личности, лицензии'),
        _buildSubsectionTitle('Регулируемые товары:'),
        _buildBulletPoint('Табачные изделия'),
        _buildBulletPoint('Алкогольные напитки'),
        _buildBulletPoint('Лекарства по рецепту'),
        _buildBulletPoint('Опасные материалы'),
        _buildSubsectionTitle('Контент для взрослых:'),
        _buildBulletPoint('Порнография или контент для взрослых'),
        _buildBulletPoint('Сексуальные услуги'),
        _buildSubsectionTitle('Прочие запреты:'),
        _buildBulletPoint('Живые животные (кроме проверенных заводчиков)'),
        _buildBulletPoint('Части человеческого тела'),
        _buildBulletPoint('Лотерейные билеты, азартные игры'),
        _buildBulletPoint('Финансовые пирамиды'),
        _buildBulletPoint('Инструменты для взлома'),
        _buildSectionTitle('5. ПОВЕДЕНИЕ ПОЛЬЗОВАТЕЛЕЙ', theme),
        _buildSubsectionTitle('Вы соглашаетесь:'),
        _buildBulletPoint('Относиться к другим пользователям с уважением'),
        _buildBulletPoint('Общаться честно и прозрачно'),
        _buildBulletPoint('Выполнять свои обязательства'),
        _buildBulletPoint('Встречаться в безопасных местах'),
        _buildBulletPoint('Сообщать о подозрительном поведении'),
        _buildSubsectionTitle('Вы соглашаетесь НЕ:'),
        _buildBulletPoint('Обманывать других пользователей'),
        _buildBulletPoint('Использовать оскорбительные выражения'),
        _buildBulletPoint('Дискриминировать по любым признакам'),
        _buildBulletPoint('Создавать фальшивые объявления'),
        _buildBulletPoint('Оставлять ложные отзывы'),
        _buildSectionTitle('6. ПЛАТЕЖИ И ТРАНЗАКЦИИ', theme),
        _buildParagraph(
          'В настоящее время Tezsell НЕ обрабатывает платежи. Все платежные договоренности заключаются напрямую между покупателями и продавцами. Tezsell НЕ несет ответственности за платежные споры.',
        ),
        _buildSectionTitle('7. ТАРИФЫ И СБОРЫ', theme),
        _buildParagraph(
          'Tezsell в настоящее время БЕСПЛАТЕН. Мы оставляем за собой право вводить сборы в будущем с уведомлением за 30 дней.',
        ),
        _buildSectionTitle('8. ОТКАЗ ОТ ГАРАНТИЙ', theme),
        _buildParagraph(
          'Приложение предоставляется "КАК ЕСТЬ". Мы НЕ даем НИКАКИХ ГАРАНТИЙ. Вы используете Приложение на свой риск.',
        ),
        _buildSectionTitle('9. ОГРАНИЧЕНИЕ ОТВЕТСТВЕННОСТИ', theme),
        _buildParagraph(
          'Tezsell Corporation НЕ несет ответственности за косвенный ущерб, потерю прибыли или данных. Наша общая ответственность не превышает сумму, которую вы заплатили за 12 месяцев (в настоящее время ноль).',
        ),
        _buildSectionTitle('10. РАЗРЕШЕНИЕ СПОРОВ', theme),
        _buildParagraph(
          'Эти Условия регулируются законами Республики Узбекистан. Споры разрешаются в судах Ташкента. Свяжитесь с нами: support@tezsell.uz',
        ),
        _buildSectionTitle('11. ПРЕКРАЩЕНИЕ', theme),
        _buildParagraph(
          'Вы можете удалить свой аккаунт в любое время. Мы можем закрыть аккаунт при нарушении Условий или неактивности более 12 месяцев.',
        ),
        _buildSectionTitle('12. СВЯЖИТЕСЬ С НАМИ', theme),
        _buildParagraph(
          'По вопросам обращайтесь: support@tezsell.uz или legal@tezsell.uz',
        ),
      ],
    );
  }

  // UZBEK CONTENT
  Widget _buildUzbekContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('1. SHARTLARNI QABUL QILISH', theme),
        _buildParagraph(
          'Tezsell mobil ilovasidan ("Ilova") foydalanish orqali siz ushbu Foydalanish shartlariga ("Shartlar") rioya qilishga rozilik bildirasiz. Agar siz ushbu Shartlarga rozi bo\'lmasangiz, Ilovadan foydalanmang.',
        ),
        _buildParagraph(
          'Tezsell Corporation ("biz", "bizning") ushbu Shartlarni istalgan vaqtda o\'zgartirish huquqini o\'zida saqlab qoladi. O\'zgartirishlardan keyin Ilovadan foydalanishni davom ettirish o\'zgartirilgan Shartlarni qabul qilishni anglatadi.',
        ),
        _buildSectionTitle('2. FOYDALANISH HUQUQI', theme),
        _buildBulletPoint(
            'Ushbu Ilovadan foydalanish uchun kamida 13 yoshda bo\'lishingiz kerak'),
        _buildBulletPoint(
            'Agar 18 yoshdan kichik bo\'lsangiz, ota-ona roziligiga ega bo\'lishingiz kerak'),
        _buildBulletPoint(
            'Ro\'yxatdan o\'tishda aniq ma\'lumot berishingiz kerak'),
        _buildBulletPoint(
            'Hisobingiz ma\'lumotlarini maxfiy saqlash uchun mas\'ulsiz'),
        _buildBulletPoint(
            'Bir shaxs yoki biznes bir nechta hisob yaratishi mumkin emas'),
        _buildSectionTitle('3. BOZOR XIZMATLARI', theme),
        _buildSubsectionTitle('Platformaning maqsadi:'),
        _buildParagraph(
          'Tezsell xaridorlar va sotuvchilarni bog\'lovchi platforma: Mahsulotlar (yangi va ishlatilgan), Xizmatlar (professional va shaxsiy) va Ko\'chmas mulk (sotish va ijara).',
        ),
        _buildSubsectionTitle('Muhim cheklovlar:'),
        _buildBulletPoint('Tezsell faqat BOZOR PLATFORMASI'),
        _buildBulletPoint(
            'Biz foydalanuvchilar o\'rtasidagi bitimlar ishtirok etmaymiz'),
        _buildBulletPoint(
            'Biz mahsulotlar/xizmatlarning sifati, xavfsizligi kafolatlamaymiz'),
        _buildBulletPoint(
            'Foydalanuvchilar o\'rtasidagi muloqot yoki nizolar uchun javobgar emasmiz'),
        _buildSectionTitle('4. TAQIQLANGAN MAHSULOTLAR', theme),
        _buildSubsectionTitle('Noqonuniy buyumlar:'),
        _buildBulletPoint(
            'Qurol, o\'qotar qurollar, o\'q-dorilar, portlovchi moddalar'),
        _buildBulletPoint('Noqonuniy giyohvand moddalar'),
        _buildBulletPoint('O\'g\'irlangan mol-mulk yoki qalbaki mahsulotlar'),
        _buildBulletPoint('Davlat tomonidan berilgan guvohnomalar'),
        _buildSubsectionTitle('Tartibga solinadigan mahsulotlar:'),
        _buildBulletPoint('Tamaki mahsulotlari'),
        _buildBulletPoint('Alkogol ichimliklar'),
        _buildBulletPoint('Retsept bo\'yicha dorilar'),
        _buildBulletPoint('Xavfli materiallar'),
        _buildSubsectionTitle('Kattalar uchun kontent:'),
        _buildBulletPoint('Pornografiya yoki kattalar uchun kontent'),
        _buildBulletPoint('Jinsiy xizmatlar'),
        _buildSubsectionTitle('Boshqa taqiqlar:'),
        _buildBulletPoint(
            'Tirik hayvonlar (tekshirilgan naslchilardan tashqari)'),
        _buildBulletPoint('Inson tanasi qismlari'),
        _buildBulletPoint('Lotereya chiptalari, qimor'),
        _buildBulletPoint('Piramida sxemalari'),
        _buildBulletPoint('Buzish vositalari'),
        _buildSectionTitle('5. FOYDALANUVCHI XULQ-ATVORI', theme),
        _buildSubsectionTitle('Siz quyidagilarga rozisiz:'),
        _buildBulletPoint(
            'Boshqa foydalanuvchilarga hurmat bilan munosabatda bo\'lish'),
        _buildBulletPoint('Halol va ochiq muloqot qilish'),
        _buildBulletPoint('Majburiyatlaringizni bajarish'),
        _buildBulletPoint('Xavfsiz joylarda uchrashish'),
        _buildBulletPoint('Shubhali xatti-harakatlar haqida xabar berish'),
        _buildSubsectionTitle('Siz quyidagilarni QILMASLIKKA rozisiz:'),
        _buildBulletPoint('Boshqa foydalanuvchilarni aldash'),
        _buildBulletPoint('Haqoratli so\'zlardan foydalanish'),
        _buildBulletPoint('Har qanday asosda kamsitish'),
        _buildBulletPoint('Soxta e\'lonlar yaratish'),
        _buildBulletPoint('Yolg\'on sharhlar qoldirish'),
        _buildSectionTitle('6. TO\'LOVLAR VA BITIMLAR', theme),
        _buildParagraph(
          'Hozirda Tezsell to\'lovlarni qayta ishlamaydi. Barcha to\'lov shartnomalari xaridorlar va sotuvchilar o\'rtasida to\'g\'ridan-to\'g\'ri tuziladi. Tezsell to\'lov nizolari uchun javobgar emas.',
        ),
        _buildSectionTitle('7. TARIFLAR VA TO\'LOVLAR', theme),
        _buildParagraph(
          'Tezsell hozirda BEPUL. Kelajakda to\'lovlar kiritish huquqini o\'zimizda saqlab qolamiz (30 kun oldin xabardorlik bilan).',
        ),
        _buildSectionTitle('8. KAFOLATLARDAN VOZ KECHISH', theme),
        _buildParagraph(
          'Ilova "SHUNDAYLIGICHA" taqdim etiladi. Biz HECH QANDAY KAFOLAT bermaymiz. Siz Ilovadan o\'z xavf-xataringiz ostida foydalanasiz.',
        ),
        _buildSectionTitle('9. JAVOBGARLIKNI CHEKLASH', theme),
        _buildParagraph(
          'Tezsell Corporation bilvosita zarar, foyda yo\'qotish yoki ma\'lumotlar uchun javobgar EMAS. Bizning umumiy javobgarligimiz 12 oy ichida to\'lagan summangizdan oshmaydi (hozirda nol).',
        ),
        _buildSectionTitle('10. NIZOLARNI HAL QILISH', theme),
        _buildParagraph(
          'Ushbu Shartlar O\'zbekiston Respublikasi qonunlari bilan tartibga solinadi. Nizolar Toshkent shahri sudlarida hal qilinadi. Biz bilan bog\'laning: support@tezsell.uz',
        ),
        _buildSectionTitle('11. TO\'XTATISH', theme),
        _buildParagraph(
          'Siz hisobingizni istalgan vaqtda o\'chirishingiz mumkin. Biz Shartlarni buzish yoki 12 oydan ortiq faol bo\'lmaslik holatida hisobni yopishimiz mumkin.',
        ),
        _buildSectionTitle('12. BIZ BILAN BOG\'LANING', theme),
        _buildParagraph(
          'Savollar uchun murojaat qiling: support@tezsell.uz yoki legal@tezsell.uz',
        ),
      ],
    );
  }
}
