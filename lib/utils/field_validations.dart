import 'package:regcard/utils/localization_extension.dart';

import '../resources/localization/app_localization.dart';

class FieldValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "please_enter_your_email_address".L();
    }
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );

    if (!emailRegex.hasMatch(value)) {
      return "enter_a_valid_email".L();
    }

    final domainExtensionRegex = RegExp(r'\.(?:[a-zA-Z]{2,})$');
    if (!domainExtensionRegex.hasMatch(value) ||
        RegExp(r'\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})+$').hasMatch(value)) {
      return "enter_a_valid_email".L();
    }

    if (value.contains(RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))) {
      return "emojis_are_not_allowed_in_email_addresses".L();
    }

    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return "please_enter_your_amount".L();
    }
    if (double.parse(value) <= 0) {
      return "amount_must_be_greater_than_zero".L();
    }

    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return "please_enter_title".L();
    }
    return null;
  }

  static String? validateEmailEmpty(String? value) {
    if (value != null) {
      final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      );

      if (!emailRegex.hasMatch(value)) {
        return "enter_a_valid_email".L();
      }

      final domainExtensionRegex = RegExp(r'\.(?:[a-zA-Z]{2,})$');
      if (!domainExtensionRegex.hasMatch(value) ||
          RegExp(r'\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})+$').hasMatch(value)) {
        return "enter_a_valid_email".L();
      }

      if (value.contains(RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))) {
        return "emojis_are_not_allowed_in_email_addresses".L();
      }
    }

    return null;
  }

  static String? validateSpaceSlots(String? value) {
    if (value!.isEmpty) {
      return "please_enter_space_slots".L();
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value!.isEmpty) {
      return "please_enter_otp".L();
    }
    if (value.length < 6) {
      return "invalid_otp".L();
    }
    if (!RegExp(r"([0-9])$").hasMatch(value)) {
      return "invalid_otp".L();
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "please_enter_password".L();
    }
    if (value.length < 8) {
      return "password_should_contain_at_least_eight_character".L();
    }
    if (!RegExp(r"^(?=.*[A-Za-z@#$])(?=.*\d).{8,}$").hasMatch(value)) {
      return "password_should_be_alphanumeric".L();
    }
    if (!RegExp(r"([A-Z])").hasMatch(value)) {
      return "password_should_have_capital_alphabet".L();
    }

    if (!RegExp(r'^(?=.*?[!@#$%^&*()_+\-=\[\]{}€÷×;:"\\|,.<>\/?])')
        .hasMatch(value.trim())) {
      return "password_should_1_special_character".L();
    }

    return null;
  }

  static String? validatePasswordMatch(String? value, String? pass2) {
    if (pass2!.isEmpty) {
      return "please_enter_your_confirm_password".L();
    }
    if (value != pass2) {
      return "password_does_not_match".L();
    }
    return null;
  }

  static String? validateName(
    String? value,
  ) {
    if (value!.isEmpty) {
      return "please_enter_name".L();
    }
    if (value.length <= 2) {
      return "invalid_name".L();
    } else if (!RegExp(r'^[^\s]').hasMatch(value)) {
      return "invalid_name".L();
    }
    if (!RegExp(r"^([ \u00c0-\u01ffa-zA-Z'\-])+$").hasMatch(value)) {
      return "invalid_name".L();
    }
    return null;
  }

  static String? validateLabelName(
    String? value,
  ) {
    if (value!.isEmpty) {
      return "please_enter_item_name".L();
    }
    if (value.length <= 2) {
      return "invalid_item_name".L();
    } else if (!RegExp(r'^[^\s]').hasMatch(value)) {
      return "invalid_item_name".L();
    }
    if (!RegExp(r"^([ \u00c0-\u01ffa-zA-Z'\-])+$").hasMatch(value)) {
      return "invalid_name".L();
    }
    return null;
  }

  static String? validateBankName(String? value) {
    if (value!.isEmpty) {
      return "please_enter_bank_name".L();
    }
    if (value.length <= 2) {
      return "invalid_name".L();
    }
    return null;
  }

  static String? validateBankNum(String? value) {
    if (value!.isEmpty) {
      return "please_enter_bank_num".L();
    }
    if (value.length <= 2) {
      return "invalid_num".L();
    }
    return null;
  }

  static String? validateAccountNum(String? value) {
    if (value!.isEmpty) {
      return "please_enter_account_num".L();
    }
    if (value.length <= 2) {
      return "invalid_num".L();
    }
    return null;
  }

  static String? validateFirstName(String? value) {
    if (value!.isEmpty) {
      return "please_enter_your_first_name".L();
    }

    if (value != value.trim()) {
      return "space_cannot_be_allowed".L();
    }
    if (value.length <= 2) {
      return "invalid_name".L();
    }
    // else if (!RegExp(r'^[^\s]').hasMatch(value)) {
    //   return "invalid_name".L();
    // }
    if (!RegExp(r"^([ \u00c0-\u01ffa-zA-Z'\-])+$").hasMatch(value)) {
      return "invalid_name".L();
    }
    return null;
  }

  static String? validateDocName(String? value) {
    if (value!.isEmpty) {
      return "please_enter_your_doc_name".L();
    }

    if (value != value.trim()) {
      return "space_cannot_be_allowed".L();
    }
    if (value.length <= 2) {
      return "invalid_name".L();
    }
    // else if (!RegExp(r'^[^\s]').hasMatch(value)) {
    //   return "invalid_name".L();
    // }
    if (!RegExp(r"^([ \u00c0-\u01ffa-zA-Z'\-])+$").hasMatch(value)) {
      return "invalid_name".L();
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value!.isEmpty) {
      return "please_enter_your_last_name".L();
    }
    if (value != value.trim()) {
      return "space_cannot_be_allowed".L();
    }
    if (value.length <= 2) {
      return "invalid_name".L();
    } else if (!RegExp(r'^[^\s]').hasMatch(value)) {
      return "invalid_name".L();
    }
    if (!RegExp(r"^([ \u00c0-\u01ffa-zA-Z'\-])+$").hasMatch(value)) {
      return "invalid_name".L();
    }
    return null;
  }

  static String? validateEmptyField(String? value) {
    if (value!.trim().isEmpty) {
      return "field_cant_be_empty".L();
    }
    return null;
  }

  static String? validateChooseDate(String? value) {
    if (value!.trim().isEmpty) {
      return "please_choose_date".L();
    }
    return null;
  }

  static String? validateHelpField(String? value) {
    if (value!.trim().isEmpty) {
      return "Please_describe_your_issue_or_question".L();
    }

    return null;
  }

  static String? validateDeleteAccountResField(String? value) {
    if (value!.trim().isEmpty) {
      return "please_provide_a_reason_for_deleting_an_account".L();
    }
    return null;
  }

  static String? validatePassEmptyField(String? value) {
    if (value!.trim().isEmpty) {
      return "please_enter_your_password".L();
    }
    return null;
  }

  static String? categoryField(String? value) {
    if (value!.isEmpty) {
      return "please_choose_a_category".L();
    }
    return null;
  }

  static String? validateTitleDropdown(value) {
    if (value == null) {
      return "\t\t\t\t\t${"please_select_the_title".L()}";
    }
    return null;
  }

  static String? validateDocDropdown(value) {
    if (value == null) {
      return "select_document_type".L();
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value!.isEmpty) {
      return "enter_quantity".L();
    }
    return null;
  }

  static String? validateMinLevel(String? value) {
    if (value!.isEmpty) {
      return "enter_min_level".L();
    }
    return null;
  }

  static String? validateUnit(String? value) {
    if (value?.isEmpty ?? false) {
      return "please_select_unit".L();
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value!.isEmpty) {
      return "select_date".L();
    }
    return null;
  }

  static String? validateNotes(String? value) {
    if (value!.isEmpty) {
      return "please_enter_notes".L();
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value!.isEmpty) {
      return "please_enter_price".L();
    }
    return null;
  }

  static String? hasValidUrl(String? value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'please_enter_a_web_link'.L();
    } else if (!regExp.hasMatch(value)) {
      return 'invalid_format'.L();
    }
    return null;
  }

  static String? validateLength(String? value, int? fixLength) {
    if (value!.isEmpty) {
      return LocalizationMap.getTranslatedValues("field_cant_be_empty");
    } else if (value.length < (fixLength ?? 0) ||
        value.length > (fixLength ?? 0)) {
      return "${"field_should_be".L()} ${fixLength.toString()} ${"character_long".L()}";
    }
    return null;
  }
}
