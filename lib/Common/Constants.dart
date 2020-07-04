import 'package:flutter/material.dart';

const String API_URL = "http://evolve.buyinbni.in/BuyinbniAppservice.asmx/";
const String IMG_URL = "http://evolve.buyinbni.in/";
const String API_URL_RazorPay_Order =
    "http://razorpayapi.itfuturz.com/Service.asmx/";
const Inr_Rupee = "₹";

const String whatsAppLink =
    "https://wa.me/#mobile?text=#msg"; //mobile no with country code
const String smsLink = "sms:#mobile?body=#msg"; //mobile no with country code
const String mailLink = "mailto:#mail?subject=#subject&body=#msg";
const String profileUrl = "http://digitalcard.co.in?uid=#id";
const String playstoreUrl = "http://tinyurl.com/y795yrfw";

Map<int, Color> appprimarycolors = {
  50: Color.fromRGBO(227, 17, 140, .1),
  100: Color.fromRGBO(227, 17, 140, .2),
  200: Color.fromRGBO(227, 17, 140, .3),
  300: Color.fromRGBO(227, 17, 140, .4),
  400: Color.fromRGBO(227, 17, 140, .5),
  500: Color.fromRGBO(227, 17, 140, .6),
  600: Color.fromRGBO(227, 17, 140, .7),
  700: Color.fromRGBO(227, 17, 140, .8),
  800: Color.fromRGBO(227, 17, 140, .9),
  900: Color.fromRGBO(227, 17, 140, 1)
};

MaterialColor appPrimaryMaterialColor =
    MaterialColor(0xFFE3118C, appprimarycolors);

class MESSAGES {
  static const String INTERNET_ERROR = "No Internet Connection";
  static const String INTERNET_ERROR_RETRY =
      "No Internet Connection.\nPlease Retry";
}

class Session {
  static const String MemberId = "MemberId";
  static const String guestId = "guestId ";
  static const String company = "company";
  static const String website = "website";
  static const String name = "name";
  static const String mobile = "mobile";
  static const String image = "image";
  static const String companylogo = "companylogo";
  static const String chapterid = "chapterid";
  static const String chapter = "chapter";
  static const String VerificationStatus = "VerificationStatus";
  static const String MembershipType = "MembershipType";
  static const String category = "category";
  static const String categoryName = "categoryName";
  static const String tempChapterName = "tempChapterName";
  static const String MemberType = "Reg_Type";
  static const String eximforum = "eximforum";
  static const String b2b = "b2b";
  static const String conclave = "conclave";
  static const String email = "email";
  static const String city = "city";
  static const String type = "type";
  static const String ChapterName = "ChapterName";
  static const String isFirstTime = "isFirstTime";
  static const String isProfileUpdate = "isProfileUpdate";
  static const String isOnline = "isOnline";
  static const String isData = "isData";
  static const String expdate = "expdate";
  static const String isVerified = "isVerified";
  static const String isPrivate = "isPrivate";
  static const String GSTNumber = "GSTNumber";
  static const String TransactionId = "TransactionId";
  static const String RegAmt = "RegAmt";
}
