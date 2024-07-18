import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AdminService adminService = AdminService();

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliences',
    'Books',
    'Fashion'
  ];
  String category = 'Mobiles';

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    priceController.dispose();
  }

  List<File> images = [];

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient,
                ),
              ),
              title: const Text(
                'Add Product',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    images.isNotEmpty
                        ? CarouselSlider(
                            options: CarouselOptions(
                                viewportFraction: 1, height: 200),
                            items: images
                                .map((e) => Builder(
                                      builder: (context) => Image.file(
                                        e,
                                        fit: BoxFit.cover,
                                        height: 200,
                                      ),
                                    ))
                                .toList(),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImages();
                            },
                            child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_outlined,
                                        size: 50,
                                      ),
                                      Text(
                                        'Select Product Image',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                        controller: nameController, hintText: 'Product Name'),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Description',
                      maxLines: 7,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        controller: priceController, hintText: 'Price'),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        controller: quantityController, hintText: 'Quantity'),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButton(
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                        value: category,
                        items: productCategories.map(
                          (e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        text: 'Sell',
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              images.isNotEmpty) {
                            adminService.sellProduct(
                                context: context,
                                name: nameController.text,
                                description: descriptionController.text,
                                price: double.parse(priceController.text),
                                quantity: double.parse(quantityController.text),
                                category: category,
                                images: images);
                          }
                        })
                  ],
                ),
              )),
        ));
  }
}
