import 'package:amazon_clone/features/cart/services/cart_service.dart';
import 'package:amazon_clone/features/product-details/services/product_details_service.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsService productDetailsService = ProductDetailsService();
  final CartService cartService = CartService();

  void increaseQuantity(Product product) {
    productDetailsService.addToCart(context: context, product: product);
  }

  void decreaseQuantity(Product product) {
    cartService.removeFromCart(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    final productMap = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productMap['product']);
    final quantity = productMap['quantity'];
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.fitHeight,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.name,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '\$ ${product.price}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      'Elligible for free shipping',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.quantity > 0 ? 'In Stock' : 'Hors Stock',
                      style: const TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black12,
                      width: 1.5,
                    )),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => decreaseQuantity(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        ),
                      ),
                    ),
                    Container(
                        width: 35,
                        height: 32,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text(quantity.toString())),
                    InkWell(
                      onTap: () => increaseQuantity(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
