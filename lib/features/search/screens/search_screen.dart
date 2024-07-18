import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/product-details/screens/product_details_screen.dart';
import 'package:amazon_clone/features/search/services/search_service.dart';
import 'package:amazon_clone/features/search/widgets/searched_product.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  final String searchQuery;
  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchService searchService = SearchService();
  List<Product>? productList;

  fetchSearchedProduct() async {
    productList = await searchService.fetchCategoryProducts(
        context: context, searchQuery: widget.searchQuery);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchSearchedProduct();
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
        body: productList == null
            ? const Loader()
            : Column(
                children: [
                  const AddressBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: productList!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, ProductDetailsScreen.routeName,
                              arguments: productList![index]),
                          child: SearchedProduct(product: productList![index]));
                    },
                  ))
                ],
              ));
  }
}
