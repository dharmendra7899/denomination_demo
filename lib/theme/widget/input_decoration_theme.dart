part of "../theme.dart";

final _inputDecorationTheme = InputDecorationTheme(
  iconColor: appColors.editTextColor,
  errorStyle: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: appColors.error,
    fontFamily: 'Montserrat',
  ),
  errorMaxLines: 3,
  fillColor: appColors.appWhite,
  prefixIconColor: appColors.editTextColor,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: appColors.editTextColor, width: 2),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: appColors.editTextColor, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: appColors.editTextColor, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: appColors.error, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: appColors.error, width: 2),
  ),
);
