class AddToCartException {
  String command;
  String message;
  String cartId;
  String productId;

  AddToCartException({
    required this.command, required this.message,required this.productId, required this.cartId
  });


}