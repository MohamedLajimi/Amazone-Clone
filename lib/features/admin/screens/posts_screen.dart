import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_service.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? productList;
  AdminService adminService = AdminService();

  fetchAllProducts() async {
    productList = await adminService.fetchAllProducts(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  deleteProduct(int index, Product product) async {
    await adminService.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          productList!.removeAt(index);
          setState(() {});
          showSnackBar(context, 'Product deleted successfully');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: productList == null
          ? const Loader()
          : GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: productList?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = productList![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: SingleProduct(image: productData.images[0]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Text(
                            productData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )),
                          GestureDetector(
                            onTap: () => deleteProduct(index, productData),
                            child: const Icon(
                              Icons.delete_outline,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddProductScreen.routeName);
        },
        backgroundColor: GlobalVariables.selectedNavBarColor,
        tooltip: 'Add a product',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
