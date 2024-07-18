import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/product-details/services/product_details_service.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  static const String routeName = '/product-details';
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductDetailsService productDetailsService = ProductDetailsService();
  double avgRating = 0;
  double myRating = 0;

  void addToCart(Product product) {
    productDetailsService.addToCart(context: context, product: product);
  }

  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    margin: const EdgeInsets.only(left: 15),
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        onFieldSubmitted: (value) => Navigator.pushNamed(
                            context, SearchScreen.routeName,
                            arguments: value),
                        decoration: InputDecoration(
                            hintText: 'Seach Amazon.in',
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide.none),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                    color: Colors.black38, width: 1)),
                            prefixIcon: InkWell(
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 23,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(
                    Icons.mic,
                    size: 23,
                  ),
                )
              ],
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(widget.product.id!), Stars(rating: avgRating)],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.product.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              CarouselSlider(
                  items: widget.product.images.map((e) {
                    return Builder(
                      builder: (context) => Image.network(
                        e,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(viewportFraction: 1, height: 300)),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Deal Price :  ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${widget.product.price}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.product.description,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rate The Product :',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  RatingBar.builder(
                    itemSize: 30,
                    itemCount: 5,
                    initialRating: myRating,
                    minRating: 1,
                    allowHalfRating: true,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: GlobalVariables.secondaryColor,
                    ),
                    onRatingUpdate: (value) {
                      productDetailsService.rateProduct(
                          context: context,
                          product: widget.product,
                          rating: value);
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(text: 'Buy Now', onPressed: () {}),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: 'Add To Cart',
                onPressed: () {
                  addToCart(widget.product);
                  showSnackBar(context, 'Product added to cart');
                },
                color: const Color.fromRGBO(254, 216, 19, 1),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
