import 'package:flutter_neumorphic/flutter_neumorphic.dart';

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;

// const Color backGroundBlack = Color(0xFF222229);
// const Color backGroundBlack = Color(0xFF292C31);

//origanel
const Color backGroundBlack = Color(0xFF1C1C1E);
const Color primaryLight = Color.fromRGBO(111, 171, 195, 1);
const Color blueGrey = Color(0xff7a94b1);

const Color darkBlueGrey = Color(0xFF576474);
const Color darkBlueGrey3 = Color(0xFF343B43);

const Color lightBrown = Color(0xFFA77979);
const Color pinkLite = Color(0xfffc5185);
const Color navItemBlue = Color(0xFF828A94);
const Color cardBlack = Color(0xFF94ADDB);
// const Color cardBlack = Color(0xFF9DBAE0);
const Color cardLight = Color(0xFF9FAED4);
const Color cardLight2 = Color(0xFFAEB0B6);
// const Color lightBlue = Color(0xFF1877F2);
const Color lightBlue = Color(0xFF194F96);
const Color whiteSmoke = Color(0xFFF5F5F5);
// const Color whiteSmoke = Color(0xFFDDDDDD);
const whiteBackground = Color(0xFFf0f2f4);

// const whiteBackground = Color(0xFFE5EAEE);
// const sheetBackground = Color(0xFFE5EAEE);
// const whiteBackground = Color(0xFFECF0F3);

//new colors
const sheetBackground = Color(0xFFf0f2f4);
const Color lightGrey = Color(0xFF9b9b9b);
const Color lightBrown2 = Color(0xFFa79571);
const Color blueGrey2 = Color(0xFF7d8ca3);
const Color brown = Color(0xFF540C11);

neoRadioStyle() => const NeumorphicRadioStyle(unselectedColor: whiteBackground);
neoRadioStyleChoose() => const NeumorphicRadioStyle(
      border: NeumorphicBorder(
        color: Colors.black12,
        width: 0.1,
      ),
      unselectedColor: Colors.white70,
      selectedColor: primaryLight,
      shape: NeumorphicShape.concave,
      boxShape: NeumorphicBoxShape.stadium(),
    );
