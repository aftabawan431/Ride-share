import 'package:logger/logger.dart';

class FormValidators {
  static String? validateEmail(String? value) {
    var emptyEmailError = 'Email address is empty';
    var invalidEmailError = 'Invalid email address';

    if (value!.isEmpty) {
      return emptyEmailError;
    } else {
      final emailValidate = RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value);

      if (!emailValidate) {
        return invalidEmailError;
      } else {
        return null;
      }
    }
  }

  static String? validateName(String? value) {
    var emptyNameError = 'Name is empty';
    var invalidNameError = 'Name is not appropriate!';

    if (value!.isEmpty) {
      return emptyNameError;
    } else {
      if (value.length < 3) {
        return "Name is too short";
      }

      final nameValidate = RegExp(r"^[a-zA-Z]+\s?[a-zA-Z ]+$").hasMatch(value);
      if (!nameValidate) {
        return invalidNameError;
      } else {
        return null;
      }
    }
  }

  static String? validateVehicleType(String? value) {
    var emptyNameError = 'Vehicle type is empty';

    if (value!.isEmpty) {
      return emptyNameError;
    } else {
      return null;
    }
  }

  static String? validateVehicleMaker(String? value) {
    var emptyNameError = 'Vehicle maker is empty';

    if (value!.isEmpty) {
      return emptyNameError;
    } else {
      return null;
    }
  }

  static String? validateVehicleModel(String? value) {
    var emptyNameError = 'Vehicle model is empty';

    if (value!.isEmpty) {
      return emptyNameError;
    } else {
      return null;
    }
  }

  static String? validateProvince(String? value) {
    var emptyNameError = 'Province is empty';

    if (value!.isEmpty) {
      return emptyNameError;
    } else {
      return null;
    }
  }

  static String? validateCity(String? value) {
    var emptyNameError = 'City is empty';

    if (value!.isEmpty) {
      return emptyNameError;
    } else {
      return null;
    }
  }

  static String? validateCnic(String? value) {
    String emptyCnicEror = "CNIC is empty";
    String invalidCnicError = "CNIC is invalid";
    RegExp _regExp = RegExp(r'^[1-9]');

    if (value!.isEmpty) {
      return emptyCnicEror;
    } else if (value.length < 13) {
      return invalidCnicError;
    } else if (!_regExp.hasMatch(value)) {
      return invalidCnicError;
    }

    return null;
  }

  static String? validateCorporateCode(String? value) {
    String emptyCnicEror = "Corporate code is empty";
    String invalidCnicError = "Corporate code is invalid";
    RegExp _regExp = RegExp(r'^[1-9]');

    if (value!.isEmpty) {
      return null;
    } else if (value.length < 11) {
      return invalidCnicError;
    }

    return null;
  }

  static String? validateOccupation(String? value) {
    var emptyOccupationError = 'Occupation is empty';
    var invalidOccupationError = 'Occupation name is not appropriate!';

    if (value!.isEmpty) {
      return emptyOccupationError;
    } else {
      final nameValidate =
          RegExp(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$")
              .hasMatch(value);
      if (!nameValidate) {
        return invalidOccupationError;
      } else {
        return null;
      }
    }
  }

  static String? validatePhone(String? value) {
    var emptyPhoneError = 'Phone number is empty';
    var invalidPhoneError = 'Invalid phone number';

    if (value!.isEmpty) {
      return emptyPhoneError;
    } else {
      String pattern = r'^03(\d{2})-(\d{7})';

      RegExp phoneValidate = RegExp(pattern);

      if (!phoneValidate.hasMatch(value)) {
        return invalidPhoneError;
      } else {
        return null;
      }
    }
  }

  static String? validateLoginPassword(String? value) {
    var emptyPasswordError = 'Password is empty';
    var lowLengthPasswordError = "Password must have at least 8 characters";
    

    if (value!.isEmpty) {
      return emptyPasswordError;
    }
    if (value.length < 8) {
      return lowLengthPasswordError;
    }
    return null;
  }

  static String? validateAccountNumber(String? value) {
    var emptyPasswordError = 'Field is empty';

    if (value!.isEmpty) {
      return emptyPasswordError;
    }
    return null;
  }

  static String? validateBank(String? value) {
    var emptyPasswordError = 'No bank is selected';

    if (value!.isEmpty) {
      return emptyPasswordError;
    }
    return null;
  }

  static String? validateIssuance(String? value) {
    var emptyPasswordError = 'Please provide issuance date';

    if (value!.isEmpty) {
      return emptyPasswordError;
    }
    return null;
  }

  static String? validateNetwork(String? value) {
    var emptyPasswordError = 'Please select a mobile network';

    if (value==null) {
      return emptyPasswordError;
    }
    return null;
  }

  static String? validatePostalCode(String? value) {
    var emptyPostalCodeError = 'Postal Code is empty';

    if (value!.isEmpty) {
      return emptyPostalCodeError;
    }
    return null;
  }

  static String? validateDocumentType(String? value) {
    var emptyError = 'Please select document type';

    if (value!.isEmpty) {
      return emptyError;
    }
    return null;
  }

  static String? validateDocumentRemarks(String? value) {
    var emptyError = 'Document Number is empty';
    var invalidRemarksError = 'not appropriate!';
    if (value!.isEmpty) {
      return emptyError;
    } else {
      final docRemarksValidate = RegExp(r'[a-zA-Z0-9]').hasMatch(value);
      if (!docRemarksValidate) {
        return invalidRemarksError;
      } else {
        return null;
      }
    }
  }

  static String? customValue(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }

  static String? registrationNumber(String? value) {
    if (value!.isEmpty) {
      return 'Registration number is empty';
    }
    return null;
  }

  static String? yearValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please choose a year';
    }
    return null;
  }

  static String? avgMileage(String? value) {
    if (value!.isEmpty) {
      return 'Average mileage is empty';
    }
    return null;
  }

  static String? birthdayValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please choose your date of birth';
    }
    return null;
  }

  static String? validateFrontSide(String? value) {
    var emptyError = 'Please select document\'s front side';

    if (value!.isEmpty) {
      return emptyError;
    }
    return null;
  }

  static String? validateBackSide(String? value) {
    var emptyError = 'Please select document\'s back side';

    if (value!.isEmpty) {
      return emptyError;
    }
    return null;
  }

  static String? validateExpiryDate(String? value) {
    var emptyError = 'Please select expiry date';

    if (value!.isEmpty) {
      return emptyError;
    }
    return null;
  }

  static String? validateIssuingAuthority(String? value) {
    var emptyError = 'Issuing Authority is empty';

    if (value!.isEmpty) {
      return emptyError;
    }
    return null;
  }

  static String? validateIssuingCountry(String? value) {
    var emptyError = 'Please select issuing country';

    if (value!.isEmpty) {
      return emptyError;
    }
    return null;
  }

  static String? validateUtility(String? value) {
    var emptyError = 'Please select utility document';

    if (value!.isEmpty) {
      return emptyError;
    }
    return null;
  }

  static String? validateRegistrationPassword(String? value) {
    var emptyPasswordError = 'Password is empty';
    var invalidPasswordError = '';

    if (value!.isEmpty) {
      return emptyPasswordError;
    } else {
      final passwordValidate = RegExp(
              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
          .hasMatch(value);

      if (!passwordValidate) {
        return invalidPasswordError;
      } else {
        return null;
      }
    }
  }

  static String? validateConfirmPassword(String? value, String existing) {
    var emptyPasswordError = 'Password is empty';
    var invalidPasswordError = 'Password does not match';

    if (value!.isEmpty) {
      return emptyPasswordError;
    } else {
      if (value != existing) {
        return invalidPasswordError;
      }
    }
    return null;
  }

  static String? validateDOB(String? value) {
    var emptyDOBError = 'Date of Birth is empty';

    if (value!.isEmpty) {
      return emptyDOBError;
    } else {
      return null;
      // final dobValidate = RegExp(
      //         r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
      //     .hasMatch(value);

      // if (!dobValidate) {
      //   return null;
      // } else {
      //   return null;
      // }
    }
  }

  static String? validateAddress(String? value) {
    var emptyAddressError = 'Address is empty';
    var invalidAddressError = 'Invalid address';

    if (value!.isEmpty) {
      return emptyAddressError;
    } else {
      final addressValidate = RegExp(r'^[#.0-9a-zA-Z\s,-]+$').hasMatch(value);

      if (!addressValidate) {
        return invalidAddressError;
      } else {
        return null;
      }
    }
  }

  static String? validateDescription(String? value) {
    var emptyDescriptionError = 'Description is empty';
    var invalidDescriptionError = 'Please enter at least 3 words';

    if (value!.isEmpty) {
      return emptyDescriptionError;
    } else {
      final int descriptionValidate =
          RegExp(r'[\w-]+').allMatches(value).length;

      if (descriptionValidate < 3) {
        return invalidDescriptionError;
      } else {
        return null;
      }
    }
  }

  static String? validateLink(String? value) {
    var emptyLinkError = 'Link is empty';
    var invalidLinkError = 'Invalid link';

    if (value!.isEmpty) {
      return emptyLinkError;
    } else {
      final nameValidate = RegExp(
              r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)')
          .hasMatch(value);

      if (!nameValidate) {
        return invalidLinkError;
      } else {
        return null;
      }
    }
  }

  static String? validateCountry(String? value) {
    var emptyCountryError = 'Please select country';

    if (value!.isEmpty) {
      return emptyCountryError;
    }
    return null;
  }

  static String? validatePaymentMethod(String? value) {
    var emptyPaymentError = 'Please select payment method';

    if (value!.isEmpty) {
      return emptyPaymentError;
    }
    return null;
  }

  static String? validatePayoutPartner(String? value) {
    var emptyPaymentPartnerError = 'Please select partner';

    if (value!.isEmpty) {
      return emptyPaymentPartnerError;
    }
    return null;
  }

  static String? validateSendMoney(String? value) {
    var emptyMoneyError = 'Please Enter Money';

    if (value!.isEmpty) {
      return emptyMoneyError;
    }
    return null;
  }

  static String? validateReason(String? value) {
    var emptyReasonError = 'Please Enter Reason';
    var lessLengthError = 'Please Enter At least 20 letters long reason';

    if (value!.isEmpty) {
      return emptyReasonError;
    }
    if (value.length < 20) {
      return lessLengthError;
    }
    return null;
  }
}
