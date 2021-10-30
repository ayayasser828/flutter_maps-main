import 'package:flutter/material.dart';

class ShowAddressScreen extends StatelessWidget {
  ShowAddressScreen({Key? key, required this.address})
      : super(key: key);

  final String address;

  int? tapped;


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _additionalDetailsController = TextEditingController();
    final _nameController = TextEditingController();
    final _phoneController = TextEditingController();


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(address.toString(),style: TextStyle(color: Colors.black),),
      ),
    );
  }
}
