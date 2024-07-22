import 'package:intl/intl.dart';

class TFormatter{
  static String formatDate(DateTime ? date){
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date); // Customize the date format as needed
  }

  static String formatCurrency(double amount){
    return NumberFormat.currency(locale: 'hi_IN', symbol: '₹').format(amount); // Customize the currency locale and symbol as needed
  }

  static String formatPhoneNumber(String phoneNumber){
  // Assuming a 10-digit Indian phone number format: 12345 67890
  // Assuming an 11-digit phone number starting with 0: 01234 567890
  // Assuming a 13-digit phone number with country code: +91 12345 67890

  if (phoneNumber.length == 10) {
    return '${phoneNumber.substring(0, 5)} ${phoneNumber.substring(5)}';
  } 
  else if (phoneNumber.length == 11 && phoneNumber.startsWith('0')) {
    return '${phoneNumber.substring(0, 5)} ${phoneNumber.substring(5)}';
  } 
  else if (phoneNumber.length == 13 && phoneNumber.startsWith('+91')) {
    return '${phoneNumber.substring(0, 3)} ${phoneNumber.substring(3, 8)} ${phoneNumber.substring(8)}';
  }

  // Add more custom phone number formatting logic for different formats if needed.
  return phoneNumber;
}

}