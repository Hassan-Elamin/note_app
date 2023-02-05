


bool isPasswordValid (String input){
  if(input.length < 7 ){
    return false;
  }else{
    return true ;
  }
}

bool isPasswordConfirmValid (String password , String input){
  if(input == password){
    return true;
  }else{
    return false;
  }
}
