import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final navKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldState> scaffoldKeyMainPage = GlobalKey();

const kInputDecoration = InputDecoration(
  floatingLabelStyle: TextStyle(color: Color(0xFF224081)),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF224081), width: 2),
  ),
);

// final dateFormat = DateFormat('dd MMM yyyy');

String formatMoney(dynamic amount, {String? currency = 'ZMW '}) {
  return NumberFormat.currency(name: currency, decimalDigits: 2).format(amount);
}

const kTitleFontSize = 20.0;
const kSubtitleFontSize = 16.0;
const kAppStoreId = '1609047449';


const baseUrl = 'http://139.84.231.208/'; // uat

enum CurrentStatus {
  initial,
  loading,
  success,
  error,
  gotCurrentPosition,
  locationLoading,
  sending,
  sent,
  sendingError,
  receivingError,
  changePassword,
  other,
  connected,
  signedOut,
  signedIn,
  saved,
}

enum AppEnv {
  prod,
  dev,
  staging,
}

const double fixPadding = 10;

const SizedBox heightSpace = SizedBox(height: fixPadding);

const SizedBox widthSpace = SizedBox(width: fixPadding);

const SizedBox width5Space = SizedBox(width: 5);



const Color blueColor = Colors.blue;
const Color primaryColor = Color(0xffe8700a);
const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color greyColor = Color(0xFF949494);
const Color lightGreyColor = Color(0xFFE6E6E6);
const Color greyShade3 = Color(0xFFB7B7B7);
const Color greyShade2 = Color(0xFFD2D2D2);
const Color secondaryColor = Color(0xFF3F3D56);
const Color redColor = Color(0xFFFF0000);
const Color greyF0Color = Color(0xFFF0F0F0);
const Color yellowColor = Color(0xFFFFAC33);
