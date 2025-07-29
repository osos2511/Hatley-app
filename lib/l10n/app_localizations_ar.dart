// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get app_title => 'هاتلي';

  @override
  String get home_title => 'الرئيسية';

  @override
  String get track_orders_title => 'تتبع الطلبات';

  @override
  String get contact_us_title => 'تواصل معنا';

  @override
  String get about_us_title => 'من نحن';

  @override
  String get our_team_title => 'فريقنا';

  @override
  String get my_orders_title => 'طلباتي';

  @override
  String get deliveries_title => 'التوصيلات';

  @override
  String get profile_title => 'الملف الشخصي';

  @override
  String get settings_title => 'الإعدادات';

  @override
  String get theme => 'السمة';

  @override
  String get theme_light => 'فاتح';

  @override
  String get theme_dark => 'غامق';

  @override
  String get language => 'اللغة';

  @override
  String get language_en => 'الإنجليزية';

  @override
  String get language_ar => 'العربية';

  @override
  String get add_new_order => 'إضافة طلب جديد';

  @override
  String get make_order_now => 'اطلب الآن';

  @override
  String get order_details => 'تفاصيل الطلب';

  @override
  String get edit => 'تعديل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get price => 'السعر:';

  @override
  String get date => 'التاريخ:';

  @override
  String get time => 'الوقت:';

  @override
  String get from => 'من:';

  @override
  String get to => 'إلى:';

  @override
  String get not_found_orders => 'لا توجد طلبات حالياً';

  @override
  String get order_cancelled_success => 'تم إلغاء الطلب بنجاح!';

  @override
  String get offer_accepted_success => 'تم قبول العرض! سيتم تحويلك للتتبع...';

  @override
  String get offer_declined_success => 'تم رفض العرض!';

  @override
  String failed_to_process_offer(Object error) {
    return 'فشل في معالجة العرض: $error';
  }

  @override
  String delete_failed(Object error) {
    return 'فشل الحذف: $error';
  }

  @override
  String get session_expired =>
      'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مجدداً.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get welcome_to_hatley => 'مرحبًا بك في هاتلي';

  @override
  String get sign_in_to_continue => 'سجل الدخول للمتابعة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgot_password => 'نسيت كلمة المرور؟';

  @override
  String get login_failed => 'فشل تسجيل الدخول. حاول مرة أخرى';

  @override
  String get sign_in => 'تسجيل الدخول';

  @override
  String get create_your_account => 'أنشئ حسابك';

  @override
  String get sign_up_to_get_started => 'سجل للبدء';

  @override
  String get your_name => 'اسمك';

  @override
  String get name_is_required => 'الاسم مطلوب';

  @override
  String get email_address => 'البريد الإلكتروني';

  @override
  String get email_is_required => 'البريد الإلكتروني مطلوب';

  @override
  String get enter_valid_email => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get phone_number => 'رقم الهاتف';

  @override
  String get phone_number_is_required => 'رقم الهاتف مطلوب';

  @override
  String get enter_valid_phone => 'أدخل رقم هاتف صحيح';

  @override
  String get password_min_length => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get make_orders => 'إنشاء طلب';

  @override
  String get send_order => 'إرسال الطلب';

  @override
  String get send => 'إرسال';

  @override
  String get contact_us_message =>
      'إذا كان لديك أي استفسار أو ترغب بالتواصل معنا، استخدم النموذج أدناه. نتطلع لسماعك!';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'الهاتف';

  @override
  String get enter_your_message => 'أدخل رسالتك';

  @override
  String get our_team => 'فريقنا';

  @override
  String get create_account => 'أنشئ حسابك';

  @override
  String get about_us_message =>
      'في هاتلي، نحن هنا لنقدم لك الراحة حتى باب منزلك. ندرك أن الوقت ثمين، ولهذا أنشأنا منصة تضع القوة بين يديك. يمكنك تقديم طلبك، واختيار العرض المناسب من بين العديد من عروض التوصيل، والاستمتاع بتجربة توصيل خالية من المتاعب. رضاك هو أولويتنا، ونحن هنا لجعل حياتك أسهل، طلب توصيل بعد الآخر.';

  @override
  String error_message(Object error) {
    return 'خطأ: $error';
  }

  @override
  String driver_label(Object name) {
    return 'السائق: $name';
  }

  @override
  String get total_orders => 'إجمالي الطلبات';

  @override
  String get complete_orders => 'الطلبات المكتملة';

  @override
  String get incomplete_orders => 'الطلبات غير المكتملة';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get orders_last_30_days => 'الطلبات في آخر 30 يوم';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get update_profile => 'تحديث الملف الشخصي';

  @override
  String get change_password => 'تغيير كلمة المرور';

  @override
  String get forgot_password_title =>
      'أدخل بريدك الإلكتروني لاستلام رمز إعادة التعيين';

  @override
  String get forgot_password_subtitle => 'سنرسل لك رمز إعادة تعيين كلمة المرور';

  @override
  String get send_reset_link => 'إرسال الرمز';

  @override
  String get reset_password_title =>
      'يرجى إدخال كلمة مرور جديدة لإعادة تعيين حسابك';

  @override
  String get reset_password_subtitle => 'أدخل كلمة المرور الجديدة';

  @override
  String get new_password => 'كلمة المرور الجديدة';

  @override
  String get confirm_password => 'تأكيد كلمة المرور';

  @override
  String get passwords_dont_match => 'كلمات المرور غير متطابقة';

  @override
  String get reset_password => 'إعادة تعيين كلمة المرور';

  @override
  String get verify_otp_title => 'التحقق من البريد الإلكتروني';

  @override
  String get verify_otp_subtitle => 'أدخل الرمز المكون من 4 أرقام';

  @override
  String get resend_code_text => 'لم تستلم الرمز؟ إعادة الإرسال';

  @override
  String resend_code_in_seconds(Object seconds) {
    return 'إعادة إرسال الرمز خلال $seconds ثانية';
  }

  @override
  String get continue_text => 'متابعة';

  @override
  String get change_password_title => 'تغيير كلمة المرور';

  @override
  String get change_password_subtitle => 'أدخل كلمة المرور الحالية والجديدة';

  @override
  String get current_password => 'كلمة المرور الحالية';

  @override
  String get ok => 'موافق';

  @override
  String get rate => 'تقييم';

  @override
  String get your_session_has_expired =>
      'انتهت صلاحية جلستك. يرجى تسجيل الدخول مجدداً.';

  @override
  String get dont_have_account => 'ليس لديك حساب؟ ';

  @override
  String get sign_up => 'إنشاء حساب';

  @override
  String get logout_confirmation => 'هل أنت متأكد من أنك تريد تسجيل الخروج؟';

  @override
  String get registration_failed => 'فشل التسجيل. حاول مرة أخرى.';

  @override
  String get already_have_account => 'لديك حساب بالفعل؟ ';

  @override
  String get back_to_login => 'العودة لتسجيل الدخول';
}
