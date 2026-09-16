class LegalTexts {
  static String getPrivacyPolicy(String lang) {
    switch (lang) {
      case 'tr':
        return '''
GİZLİLİK POLİTİKASI

Son Güncelleme: Eylül 2026

Tarih X uygulaması olarak kişisel verilerinizin güvenliğine önem veriyoruz.

1. Toplanan Veriler:
Uygulamamız kullanıcı oturum açtığında Firebase Auth ile e-posta adresi, profil ismi, profil fotoğrafı ve cihazın bildirim jetonunu (FCM Token) güvenli Cloud Firestore veritabanında saklamaktadır.

2. Verilerin Kullanımı:
Kullanıcı verileri yalnızca profil kartını görüntüleme, dil tercihinizi hatırlama ve günlük tarihi bildirimler göndermek amacıyla kullanılır. Verileriniz üçüncü taraflarla satılmaz veya ticari amaçla paylaşılmaz.

3. Reklam ve Analitik:
Uygulamamız Google AdMob reklam servislerini ve Firebase Analytics analiz hizmetlerini kullanmaktadır. Reklam gösterimleri ve anonim kullanım istatistikleri cihaz anonim kimlikleri ile işlenmektedir.

4. İletişim:
Gizlilik politikamız hakkındaki tüm sorularınız için destek ekibimizle iletişime geçebilirsiniz.
''';
      case 'de':
        return '''
DATENSCHUTZERKLÄRUNG

Zuletzt aktualisiert: September 2026

Wir legen großen Wert auf den Schutz Ihrer persönlichen Daten.

1. Erhobene Daten:
Über Firebase Auth speichern wir bei der Anmeldung Ihre E-Mail-Adresse, Ihren Profilnamen, Ihr Profilfoto und Ihr FCM-Benachrichtigungstoken in Cloud Firestore.

2. Verwendung der Daten:
Die Daten werden ausschließlich zur Anzeige Ihres Profils, zur Speicherung von Sprachpräferenzen und zum Senden täglicher historischer Benachrichtigungen verwendet.

3. Werbung & Analysen:
Die App verwendet Google AdMob für Werbung und Firebase Analytics für anonyme Nutzungsstatistiken.
''';
      case 'fr':
        return '''
POLITIQUE DE CONFIDENTIALITÉ

Dernière mise à jour : Septembre 2026

1. Données collectées :
Lors de la connexion, nous enregistrons votre adresse e-mail, nom de profil, photo et jeton FCM via Firebase.

2. Utilisation :
Vos données sont uniquement utilisées pour gérer votre profil, vos préférences linguistiques et vous envoyer des notifications historiques quotidiennes.

3. Publicité et Analyse :
L'application utilise Google AdMob et Firebase Analytics pour diffuser des annonces et mesurer l'utilisation de manière anonyme.
''';
      case 'es':
        return '''
POLÍTICA DE PRIVACIDAD

Última actualización: Septiembre de 2026

1. Datos Recopilados:
Al iniciar sesión, guardamos su correo electrónico, nombre de perfil, foto y token FCM mediante Firebase.

2. Uso de Datos:
Los datos se utilizan exclusivamente para mostrar su perfil, recordar el idioma seleccionado y enviar notificaciones históricas diarias.

3. Publicidad y Analítica:
Utilizamos Google AdMob y Firebase Analytics para mostrar anuncios y analizar el uso de forma anónima.
''';
      case 'it':
        return '''
INFORMATIVA SULLA PRIVACY

Ultimo aggiornamento: Settembre 2026

1. Dati Raccolti:
Durante l'accesso, salviamo la tua email, nome profilo, foto e token FCM utilizzando Firebase.

2. Utilizzo dei Dati:
I dati vengono utilizzati unicamente per gestire il tuo profilo, le preferenze di lingua e inviare notifiche storiche giornaliere.

3. Pubblicità e Analisi:
L'app utilizza Google AdMob e Firebase Analytics in modo anonimo.
''';
      case 'ru':
        return '''
ПОЛИТИКА КОНФИДЕНЦИАЛЬНОСТИ

Последнее обновление: Сентябрь 2026

1. Сбор данных:
При входе в систему мы сохраняем ваш email, имя профиля, фото и токен FCM в Firebase.

2. Использование данных:
Данные используются исключительно для отображения профиля, выбора языка и отправки ежедневных уведомлений.

3. Реклама и аналитика:
Приложение использует Google AdMob и Firebase Analytics для анонимного анализа и рекламы.
''';
      case 'uk':
        return '''
ПОЛІТИКА КОНФІДЕНЦІЙНОСТІ

Останнє оновлення: Вересень 2026

1. Збір даних:
Під час входу ми зберігаємо ваш email, ім'я профілю, фото та токен FCM у Firebase.

2. Використання даних:
Дані використовуються виключно для відображення профілю, вибору мови та надсилання щоденних сповіщень.

3. Реклама та аналітика:
Додаток використовує Google AdMob та Firebase Analytics.
''';
      case 'zh':
        return '''
隐私政策

最后更新：2026年9月

1. 收集的数据：
在登录时，我们通过 Firebase 存储您的电子邮件、个人资料姓名、头像和 FCM 通知令牌。

2. 数据使用：
您的数据仅用于显示个人资料、记住语言偏好以及发送每日历史通知。

3. 广告与分析：
本应用使用 Google AdMob 和 Firebase Analytics 进行匿名分析与广告展示。
''';
      case 'pt':
        return '''
POLÍTICA DE PRIVACIDADE

1. Dados Recolhidos:
Ao iniciar sessão, guardamos o seu e-mail, nome de perfil, foto e token FCM através do Firebase.

2. Uso dos Dados:
Os seus dados são usados exclusivamente para gerir o seu perfil, preferências de idioma e enviar notificações históricas diárias.

3. Publicidade e Análise:
A aplicação utiliza o Google AdMob e o Firebase Analytics.
''';
      case 'sv':
        return '''
INTEGRITETSPOLICY

1. Insamlade data:
När du loggar in sparar vi din e-post, profilnamn, foto och FCM-token via Firebase.

2. Användning:
Dina data används endast för att visa din profil, komma ihåg språkinställningar och skicka dagliga historiska aviseringar.

3. Annonser och Analys:
Appen använder Google AdMob och Firebase Analytics.
''';
      case 'ar':
        return '''
سياسة الخصوصية

1. البيانات المجمعة:
عند تسجيل الدخول، نحفظ بريدك الإلكتروني واسم الملف الشخصي والصورة ورمز FCM بأمان عبر Firebase.

2. استخدام البيانات:
تُستخدم بياناتك فقط لإدارة ملفك الشخصي وتفضيلات اللغة وإرسال إشعارات تاريخية يومية.

3. الإعلانات والتحليلات:
يستخدم التطبيق Google AdMob و Firebase Analytics.
''';
      default:
        return '''
PRIVACY POLICY

Last Updated: September 2026

1. Data Collected:
When you sign in, we securely save your email, profile name, photo URL, and FCM token using Firebase.

2. Data Usage:
Your data is exclusively used for displaying your profile, remembering language preferences, and sending daily historical notifications.

3. Advertising & Analytics:
This app utilizes Google AdMob and Firebase Analytics for anonymous usage stats and ad serving.
''';
    }
  }

  static String getTermsOfUse(String lang) {
    switch (lang) {
      case 'tr':
        return '''
KULLANIM ŞARTLARI

1. Hizmet Tanımı:
Tarih X uygulaması, kullanıcılara tarihte bugün ve yarın yaşanan olaylar hakkında bilgilendirici ve eğitici içerik sunar.

2. Kullanım Kuralları:
Uygulama içeriğinin izinsiz çoğaltılması veya kötüye kullanılması yasaktır. Yapay zeka açıklamaları bilgilendirme amaçlıdır.

3. Değişiklikler:
Tarih X, kullanım şartlarını ve uygulama özelliklerini dilediği zaman güncelleme hakkını saklı tutar.
''';
      case 'de':
        return '''
NUTZUNGSBEDINGUNGEN

1. Dienstbeschreibung:
History X bietet Informationen über historische Ereignisse des heutigen und morgigen Tages.

2. Nutzungsregeln:
Die Inhalte dienen ausschließlich Informations- und Bildungszwecken.
''';
      case 'fr':
        return '''
CONDITIONS D'UTILISATION

1. Description du service :
History X fournit des informations éducatives sur les événements historiques d'aujourd'hui et de demain.

2. Conditions :
Les contenus sont fournis à des fins d'information et d'éducation.
''';
      case 'es':
        return '''
TÉRMINOS DE USO

1. Descripción del servicio:
History X ofrece información educativa sobre los eventos históricos de hoy y mañana.

2. Reglas de uso:
El contenido se proporciona únicamente con fines informativos.
''';
      case 'it':
        return '''
TERMINI DI UTILIZZO

1. Descrizione del servizio:
History X fornisce informazioni educative sugli eventi storici di oggi e domani.

2. Regole:
I contenuti sono forniti a scopo informativo.
''';
      case 'ru':
        return '''
УСЛОВИЯ ИСПОЛЬЗОВАНИЯ

1. Описание услуги:
История X предоставляет информацию об исторических событиях сегодня и завтра.

2. Правила использования:
Материалы предоставляются исключительно в ознакомительных целях.
''';
      case 'uk':
        return '''
УМОВИ ВИКОРИСТАННЯ

1. Опис послуги:
Історія X надає інформацію про історичні події сьогодні та завтра.

2. Правила використання:
Матеріали надаються виключно з ознайомчою метою.
''';
      case 'zh':
        return '''
使用条款

1. 服务说明：
历史 X 提供有关今天和明天历史事件的教育信息。

2. 使用规则：
所有内容仅供参考和教育目的使用。
''';
      case 'pt':
        return '''
TERMOS DE UTILIZAÇÃO

1. Descrição do Serviço:
O História X fornece informações educativas sobre eventos históricos de hoje e amanhã.

2. Termos:
O conteúdo é fornecido apenas para fins informativos e educativos.
''';
      case 'sv':
        return '''
ANVÄNDARVILLKOR

1. Tjänstebeskrivning:
Historia X tillhandahåller utbildningsinformation om historiska händelser idag och imorgon.

2. Villkor:
Innehållet tillhandahålls endast i informations- och utbildningssyfte.
''';
      case 'ar':
        return '''
شروط الاستخدام

1. وصف الخدمة:
يقدم تطبيق تاريخ X معلومات تعليمية وتاريخية حول الأحداث التي وقعت اليوم وغداً في التاريخ.

2. الشروط:
يتم توفير المحتوى لأغراض إعلامية وتعليمية فقط.
''';
      default:
        return '''
TERMS OF USE

1. Service Description:
History X provides educational and historical information about events that occurred today and tomorrow in history.

2. Terms:
Content is provided for informational and educational purposes only.
''';
    }
  }
}
