class RemoveFromCartException {
  String command;
  String message;
  String cartId;
  String productId;

  RemoveFromCartException({
    required this.command, required this.message,required this.productId, required this.cartId
  });


}