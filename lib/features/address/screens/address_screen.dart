import 'package:amazon_clone/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_service.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaStreetController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController cityTownController = TextEditingController();
  final AddressService addressService = AddressService();
  String addressToBeUsed = "";
  List<PaymentItem> paymentItems = [];
  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(context,listen: false).user.address.isEmpty) {
      addressService.saveAddress(context: context, address: addressToBeUsed);
    }
    addressService.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalPrice: double.parse(widget.totalAmount));
  }

  final Future<PaymentConfiguration> _googlePayConfig =
      PaymentConfiguration.fromAsset('gpay.json');

  void payAddress(String address) {
    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaStreetController.text.isNotEmpty ||
        pinCodeController.text.isNotEmpty ||
        cityTownController.text.isNotEmpty;

    if (isForm) {
      if (_formKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaStreetController.text}, ${pinCodeController.text}, ${cityTownController.text}';
      } else {
        throw Exception('Please enter all the values !');
      }
    } else if (address.isNotEmpty) {
      addressToBeUsed = address;
    } else {
      showSnackBar(context, 'error');
    }
    print(addressToBeUsed);
  }

  @override
  void initState() {
    super.initState();
    paymentItems.add(PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price));
  }

  @override
  void dispose() {
    flatBuildingController.dispose();
    areaStreetController.dispose();
    pinCodeController.dispose();
    cityTownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: Text(
                    address,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              if (address.isNotEmpty) const SizedBox(height: 20),
              if (address.isNotEmpty)
                const Text('OR', style: TextStyle(fontSize: 18)),
              if (address.isNotEmpty) const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: areaStreetController,
                      hintText: 'Area, Street',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pinCodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityTownController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 30),
                    FutureBuilder(
                      future: _googlePayConfig,
                      builder: (context, snapshot) => snapshot.hasData
                          ? GooglePayButton(
                              type: GooglePayButtonType.buy,
                              height: 50,
                              cornerRadius: 0,
                              theme: GooglePayButtonTheme.light,
                              width: double.infinity,
                              paymentConfiguration: snapshot.data!,
                              paymentItems: paymentItems,
                              onPressed: () => payAddress,
                              onPaymentResult: onGooglePayResult,
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
