import 'dart:ui';

class ConstColors{
 static final ConstColors _constColors = ConstColors._internal();

 factory ConstColors(){
   return _constColors;
 }
 ConstColors._internal();

 Color themeColor = Color(0xFFFF2800);
 Color whiteColor = Color(0xFFFFFFFF);
 Color blackColor = Color(0xFF333333);
}