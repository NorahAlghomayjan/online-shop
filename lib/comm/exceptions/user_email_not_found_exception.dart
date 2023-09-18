class UserEmailNotFoundException {
  String command;
  String message;
  String email;

  UserEmailNotFoundException({
    required this.command, required this.message, required this.email
  });


}