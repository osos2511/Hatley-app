// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Hatley';

  @override
  String get home_title => 'Home';

  @override
  String get track_orders_title => 'Track Orders';

  @override
  String get contact_us_title => 'Contact Us';

  @override
  String get about_us_title => 'About Us';

  @override
  String get our_team_title => 'Our Team';

  @override
  String get my_orders_title => 'My Orders';

  @override
  String get deliveries_title => 'Deliveries';

  @override
  String get profile_title => 'Profile';

  @override
  String get settings_title => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get language_en => 'English';

  @override
  String get language_ar => 'Arabic';

  @override
  String get add_new_order => 'Add New Order';

  @override
  String get make_order_now => 'Make Order Now';

  @override
  String get order_details => 'Order Details';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get price => 'Price:';

  @override
  String get date => 'Date:';

  @override
  String get time => 'Time:';

  @override
  String get from => 'From:';

  @override
  String get to => 'To:';

  @override
  String get not_found_orders => 'No orders found now';

  @override
  String get order_cancelled_success => 'Order cancelled successfully!';

  @override
  String get offer_accepted_success =>
      'Offer accepted successfully! Redirecting to tracking...';

  @override
  String get offer_declined_success => 'Offer declined successfully!';

  @override
  String failed_to_process_offer(Object error) {
    return 'Failed to process offer: $error';
  }

  @override
  String delete_failed(Object error) {
    return 'Delete failed: $error';
  }

  @override
  String get session_expired =>
      'Your session has expired. Please log in again.';

  @override
  String get logout => 'Logout';

  @override
  String get welcome_to_hatley => 'Welcome to Hatley';

  @override
  String get sign_in_to_continue => 'Sign in to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgot_password => 'Forgot Password?';

  @override
  String get login_failed => 'Login failed. Please try again';

  @override
  String get sign_in => 'Sign In';

  @override
  String get create_your_account => 'Create Your Account';

  @override
  String get sign_up_to_get_started => 'Sign up to get started';

  @override
  String get your_name => 'Your name';

  @override
  String get name_is_required => 'Name is required';

  @override
  String get email_address => 'Email Address';

  @override
  String get email_is_required => 'Email is required';

  @override
  String get enter_valid_email => 'Enter a valid email address';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get phone_number_is_required => 'Phone number is required';

  @override
  String get enter_valid_phone => 'Enter a valid phone number';

  @override
  String get password_min_length => 'Password must be at least 6 characters';

  @override
  String get make_orders => 'Make Orders';

  @override
  String get send_order => 'Send Order';

  @override
  String get send => 'Send';

  @override
  String get contact_us_message =>
      'If you have questions or just want to get in touch, use the form below. We look forward to hearing from you!';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get enter_your_message => 'Enter your message';

  @override
  String get our_team => 'Our Team';

  @override
  String get create_account => 'Create Your Account';

  @override
  String get about_us_message =>
      'At Hatley, we\'re all about delivering convenience to your doorstep. We understand that time is precious, and that\'s why we\'ve created a platform that puts the power in your hands. You can place your order, choose from a variety of delivery offers, and enjoy a hassle-free delivery experience. Your satisfaction is our priority, and we\'re here to make your life easier, one delivery at a time.';

  @override
  String error_message(Object error) {
    return 'Error: $error';
  }

  @override
  String driver_label(Object name) {
    return 'Driver: $name';
  }

  @override
  String get total_orders => 'Total Orders';

  @override
  String get complete_orders => 'Complete Orders';

  @override
  String get incomplete_orders => 'Incomplete Orders';

  @override
  String get pending => 'Pending';

  @override
  String get orders_last_30_days => 'Orders Last 30 Days';

  @override
  String get username => 'Username';

  @override
  String get update_profile => 'Update Profile';

  @override
  String get change_password => 'Change Password';

  @override
  String get forgot_password_title =>
      'Enter your email address to receive a reset code';

  @override
  String get forgot_password_subtitle =>
      'We\'ll send you a password reset code';

  @override
  String get send_reset_link => 'Send Code';

  @override
  String get reset_password_title =>
      'Please enter a new password to reset your account';

  @override
  String get reset_password_subtitle => 'Enter your new password';

  @override
  String get new_password => 'New Password';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get passwords_dont_match => 'Passwords do not match';

  @override
  String get reset_password => 'Reset Password';

  @override
  String get verify_otp_title => 'Email Verification';

  @override
  String get verify_otp_subtitle => 'Enter the 4-digit code';

  @override
  String get resend_code_text => 'Didn\'t receive the code? Resend';

  @override
  String resend_code_in_seconds(Object seconds) {
    return 'Resend code in $seconds s';
  }

  @override
  String get continue_text => 'Continue';

  @override
  String get change_password_title => 'Change Password';

  @override
  String get change_password_subtitle => 'Enter your current and new password';

  @override
  String get current_password => 'Current Password';

  @override
  String get ok => 'OK';

  @override
  String get rate => 'Rate';

  @override
  String get your_session_has_expired =>
      'Your session has expired. Please sign in again.';

  @override
  String get dont_have_account => 'Don\'t have an account? ';

  @override
  String get sign_up => 'Sign Up';

  @override
  String get logout_confirmation => 'Are you sure you want to log out?';

  @override
  String get registration_failed => 'Registration failed. Please try again.';

  @override
  String get already_have_account => 'Already have an account? ';

  @override
  String get back_to_login => 'Back to Login';
}
