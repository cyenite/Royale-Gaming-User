import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DesignTextType { title, caption, overline, b2, b1 }

class DesignTextStyle {
  static Function _fontFamily = GoogleFonts.nunito;
  static Map<int, FontWeight> _defaultFontWeight = {
    100: FontWeight.w100,
    200: FontWeight.w200,
    300: FontWeight.w300,
    400: FontWeight.w300,
    500: FontWeight.w400,
    600: FontWeight.w500,
    700: FontWeight.w600,
    800: FontWeight.w700,
    900: FontWeight.w800,
  };

  static Map<DesignTextType, double> _defaultTextSize = {
    DesignTextType.title: 22,
    DesignTextType.caption: 12,
    DesignTextType.overline: 10,
    DesignTextType.b1: 16,
    DesignTextType.b2: 14,
  };

  static Map<DesignTextType, int> _defaultTextFontWeight = {
    DesignTextType.title: 800,
    DesignTextType.caption: 500,
    DesignTextType.overline: 500,
    DesignTextType.b1: 500,
    DesignTextType.b2: 500,
  };

  static Map<DesignTextType, double> _defaultLetterSpacing = {
    DesignTextType.title: 0.15,
    DesignTextType.caption: 0.15,
    DesignTextType.overline: 0.15,
    DesignTextType.b1: 0.5,
    DesignTextType.b2: 0.25,
  };

  static TextStyle designStyle(
      {TextStyle? textStyle,
      int? fontWeight = 500,
      bool muted = false,
      bool xMuted = false,
      double letterSpacing = 0.15,
      Color? color,
      TextDecoration decoration = TextDecoration.none,
      double? height,
      double wordSpacing = 0,
      double? fontSize}) {
    double? finalFontSize = fontSize ?? textStyle!.fontSize;
    Color? finalColor;
    if (color == null) {
      Color themeColor = Colors.black87; // edit
      finalColor = xMuted
          ? themeColor.withAlpha(160)
          : (muted ? themeColor.withAlpha(200) : themeColor);
    } else {
      finalColor = xMuted
          ? color.withAlpha(160)
          : (muted ? color.withAlpha(200) : color);
    }

    return _fontFamily(
        fontSize: finalFontSize,
        fontWeight: _defaultFontWeight[fontWeight] ?? FontWeight.w400,
        letterSpacing: letterSpacing,
        color: finalColor,
        decoration: decoration,
        height: height,
        wordSpacing: wordSpacing);
  }

  static TextStyle title(
      {TextStyle? textStyle,
      int fontWeight = 800,
      bool muted = false,
      bool xMuted = false,
      double? letterSpacing = 0,
      Color? color,
      TextDecoration decoration = TextDecoration.none,
      double? height,
      double wordSpacing = 0,
      double? fontSize}) {
    return designStyle(
        fontSize: fontSize ?? _defaultTextSize[DesignTextType.title],
        color: color,
        height: height,
        muted: muted,
        letterSpacing: letterSpacing ??
            _defaultLetterSpacing[DesignTextType.title] ??
            0.25,
        fontWeight: fontWeight,
        decoration: decoration,
        textStyle: textStyle,
        wordSpacing: wordSpacing,
        xMuted: xMuted);
  }

  static TextStyle caption(
      {TextStyle? textStyle,
      int fontWeight = 500,
      bool muted = false,
      bool xMuted = false,
      double? letterSpacing = 0,
      Color? color,
      TextDecoration decoration = TextDecoration.none,
      double? height,
      double wordSpacing = 0,
      double? fontSize}) {
    return designStyle(
        fontSize: fontSize ?? _defaultTextSize[DesignTextType.caption],
        color: color,
        height: height,
        muted: muted,
        letterSpacing: letterSpacing ??
            _defaultLetterSpacing[DesignTextType.caption] ??
            0.15,
        fontWeight: fontWeight,
        decoration: decoration,
        textStyle: textStyle,
        wordSpacing: wordSpacing,
        xMuted: xMuted);
  }

  static TextStyle overline(
      {TextStyle? textStyle,
      int fontWeight = 500,
      bool muted = false,
      bool xMuted = false,
      double? letterSpacing,
      Color? color,
      TextDecoration decoration = TextDecoration.none,
      double? height,
      double wordSpacing = 0,
      double? fontSize}) {
    return designStyle(
        fontSize: fontSize ?? _defaultTextSize[DesignTextType.overline],
        color: color,
        height: height,
        muted: muted,
        letterSpacing: letterSpacing ??
            _defaultLetterSpacing[DesignTextType.overline] ??
            0.15,
        fontWeight: fontWeight,
        decoration: decoration,
        textStyle: textStyle,
        wordSpacing: wordSpacing,
        xMuted: xMuted);
  }

  static TextStyle b1(
      {TextStyle? textStyle,
      int fontWeight = 500,
      bool muted = false,
      bool xMuted = false,
      double? letterSpacing,
      Color? color,
      TextDecoration decoration = TextDecoration.none,
      double? height,
      double wordSpacing = 0,
      double? fontSize}) {
    return designStyle(
        fontSize: fontSize ?? _defaultTextSize[DesignTextType.b1],
        color: color,
        height: height,
        muted: muted,
        letterSpacing:
            letterSpacing ?? _defaultLetterSpacing[DesignTextType.b1] ?? 0.15,
        fontWeight: _defaultTextFontWeight[DesignTextType.b1] ?? 500,
        decoration: decoration,
        textStyle: textStyle,
        wordSpacing: wordSpacing,
        xMuted: xMuted);
  }

  static TextStyle b2(
      {TextStyle? textStyle,
      int fontWeight = 500,
      bool muted = false,
      bool xMuted = false,
      double? letterSpacing,
      Color? color,
      TextDecoration decoration = TextDecoration.none,
      double? height,
      double wordSpacing = 0,
      double? fontSize}) {
    return designStyle(
        fontSize: fontSize ?? _defaultTextSize[DesignTextType.b2],
        color: color,
        height: height,
        muted: muted,
        letterSpacing:
            letterSpacing ?? _defaultLetterSpacing[DesignTextType.b2] ?? 0.15,
        fontWeight: _defaultTextFontWeight[DesignTextType.b2] ?? 700,
        decoration: decoration,
        textStyle: textStyle,
        wordSpacing: wordSpacing,
        xMuted: xMuted);
  }

  static Map<DesignTextType, double> get defaultTextSize => _defaultTextSize;

  static Map<DesignTextType, double> get defaultLetterSpacing =>
      _defaultLetterSpacing;

  static Map<DesignTextType, int> get defaultTextFontWeight =>
      _defaultTextFontWeight;

  static resetFontStyles() {
    _fontFamily = GoogleFonts.nunito;

    _defaultFontWeight = {
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w300,
      500: FontWeight.w400,
      600: FontWeight.w500,
      700: FontWeight.w600,
      800: FontWeight.w700,
      900: FontWeight.w800,
    };

    _defaultTextSize = {
      DesignTextType.title: 22,
      DesignTextType.caption: 12,
      DesignTextType.overline: 10,
      DesignTextType.b1: 16,
      DesignTextType.b2: 14,
    };

    _defaultTextFontWeight = {
      DesignTextType.title: 800,
      DesignTextType.caption: 500,
      DesignTextType.overline: 500,
      DesignTextType.b1: 500,
      DesignTextType.b2: 500,
    };

    _defaultLetterSpacing = {
      DesignTextType.title: 0.25,
      DesignTextType.caption: 0.15,
      DesignTextType.overline: 0.15,
      DesignTextType.b1: 0.5,
      DesignTextType.b2: 0.25,
    };
  }
}
