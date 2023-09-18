class CartNotFoundException {
  String command;
  String message;
  String userId;

  CartNotFoundException({
    required this.command, required this.message,required this.userId
  });


}