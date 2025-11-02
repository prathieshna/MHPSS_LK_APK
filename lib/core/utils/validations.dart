String? validateMobile(String? value) {
  String pattern = r'(^\+?[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "Phone number is required";
  } else if (!regExp.hasMatch(value ?? '')) {
    return "Phone number must contain only digits";
  } else if (value!.length != 10) {
    return "Please enter correct number";
  }
  return null;
}

String? validateEmail(String? value) {
  String pattern = r'^[\w\.-]+[+]?[\w\.-]*@[a-zA-Z][\w-]*\.[a-zA-Z]{2,}$';
  final regex = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "Email is required";
  } else if (!regex.hasMatch(value ?? '')) {
    return 'Please enter a valid email address';
  } else {
    return null;
  }
}

String? validateFullName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "Name is required";
  } else if (value!.trim().isEmpty) {
    return "Enter valid name";
  } else if (!regExp.hasMatch(value)) {
    return "Enter valid name";
  }
  return null;
}

String? validateCardHolder(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "Enter cardholder name";
  } else if (value!.trim().isEmpty) {
    return "Enter valid cardholder name";
  } else if (!regExp.hasMatch(value)) {
    return "Enter valid cardholder name";
  }
  return null;
}

String? validateOrganizationName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "Organization name is required";
  } else if (value!.trim().isEmpty) {
    return "Please enter a valid Organization name";
  } else if (!regExp.hasMatch(value)) {
    return "Please enter a valid Organization name";
  }
  return null;
}

String? validateVerifyNumber(String? value) {
  if (value?.isEmpty ?? true) {
    return "Number is required";
  } else if (value!.trim().isEmpty) {
    return "Please enter a valid verify number";
  } else if (value.length < 14) {
    return "Number should have 10 digits only";
  }
  return null;
}
