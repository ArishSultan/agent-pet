
String emailValidator(String value){
  if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
    return 'Please provide a valid email';
  }
  return null;
}

String emptyValidator(String value,String label){
  return value.isEmpty ? 'Please provide $label' :null;
}

String passwordValidator(String value){
  return value.isEmpty ? 'Please provide password' : (value.length < 8) ? 'Password must be at least 8 characters' : null;
}