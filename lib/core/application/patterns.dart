class Patterns {
  static RegExp patternEmail() {
    String email =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return RegExp(email);
  }

  static RegExp patternPassword() {
    //TODO: arreglar expresión regular
    String password = r'([A-Za-z\\d$@$!%*?&.]|[^ ]){8,15}$';
    return RegExp(password);
  }

  static RegExp patternNumbers() {
    return RegExp('^([1-9]\\d{8,48})\$', caseSensitive: false);
  }

  static RegExp patternName() {
    String valueName = r"[a-zA-Z0-9À-ÿ]$";
    return RegExp(valueName);
  }

  static String? validateField(String field, int minLength, int maxLength, RegExp pattern, String msgErrorPattern){

    if((field.length - 1) > maxLength){
      return 'El campo es demasiado largo';
    }
    if((field.length - 1) < minLength){
      return 'El campo es demasiado corto';
    }
    if(!pattern.hasMatch(field)){
      return msgErrorPattern;
    }
    return null;
  }
}
