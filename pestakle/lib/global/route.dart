String baseUrl = baseUrlClassic;
String baseUrlClassic = 'http://localhost:3000';
String baseUrlDev = 'http://10.57.133.81:3000';
String uPostRegister = '$baseUrl/api/register';
String uPostLogin = '$baseUrl/api/authenticate';
String uGetPost = '$baseUrl/api/posts';
String uPutUser = '$baseUrl/api/user/modify';
String uPostPost = '$baseUrl/api/post';
String uGetConversation = '$baseUrl/api/conversations';
String uPostConversation = '$baseUrl/api/conversations';
String uGetUsers = '$baseUrl/api/post';

String uPostMessageConversation(String id) {
  return '$baseUrl/api/conversations/$id/messages';
}

String uPostMessage(String id) {
  return "$baseUrl/posts/$id/messages";
}
