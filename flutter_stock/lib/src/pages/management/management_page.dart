import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mystock/src/models/posts.dart';
import 'package:flutter_mystock/src/pages/management/widgets/product_image.dart';
import 'package:flutter_mystock/src/services/network_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({Key? key}) : super(key: key);

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  late bool _isEdit;
  final _spacing = 12.0;
  late Product _product;
  final _form = GlobalKey<FormState>();
  File? _imageFile;

  @override
  void initState() {
    _isEdit = false;
    _product = Product();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Product) {
      _isEdit = true;
      _product = arguments;
    }

    return Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Form(
              key: _form,
              child: Padding(
                padding: EdgeInsets.all(_spacing),
                child: Column(
                  children: <Widget>[
                    _buildNameInput(),
                    SizedBox(height: _spacing),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: _buildPriceInput(),
                        ),
                        SizedBox(width: _spacing),
                        Flexible(
                          flex: 1,
                          child: _buildStockInput(),
                        ),
                      ],
                    ),
                    ProductImage(
                        imageUrl: _product.image,
                        callbackSetImageFile: callbackSetImageFile),
                    const SizedBox(height: 80),
                  ],
                ),
              )),
        ));
  }

  callbackSetImageFile(File? imageFile) {
    if (imageFile != null) {
      _imageFile = imageFile;
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_isEdit ? 'Edit Product' : 'Create Product'),
      actions: [
        if (_isEdit) _buildDeleteButton(),
        TextButton(
          onPressed: () {
            _form.currentState?.save();
            // Dismiss keyboard
            FocusScope.of(context).requestFocus(FocusNode());
            if (_isEdit) {
              // Edit
              editProduct();
            } else {
              // Add
              addProduct();
            }
          },
          child: const Text(
            'submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  InputDecoration inputStyle(label) => InputDecoration(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black12, width: 2),
      ),
      labelText: label);

  TextFormField _buildNameInput() => TextFormField(
        initialValue: _product.name,
        decoration: inputStyle('name'),
        onSaved: (String? value) {
          _product.name = value!.isNotEmpty ? value : '';
        },
      );

  TextFormField _buildPriceInput() => TextFormField(
        initialValue: _product.price?.toString(),
        decoration: inputStyle('price'),
        keyboardType: TextInputType.number,
        onSaved: (value) {
          _product.price = value!.isNotEmpty ? int.parse(value) : 0;
        },
      );

  TextFormField _buildStockInput() => TextFormField(
        initialValue: _product.stock?.toString(),
        decoration: inputStyle('stock'),
        keyboardType: TextInputType.number,
        onSaved: (value) {
          _product.stock = value!.isNotEmpty ? int.parse(value) : 0;
        },
      );

  void addProduct() {
    NetworkService().addProduct(_product, imageFile: _imageFile).then((result) {
      Navigator.pop(context);
      showAlertBar(result);
    }).catchError((error) {
      showAlertBar(
        error.toString(),
        icon: FontAwesomeIcons.circleXmark,
        color: Colors.red,
      );
    });
  }

  void showAlertBar(String message,
      {IconData icon = FontAwesomeIcons.circleCheck,
      Color color = Colors.green}) {
    Flushbar(
      message: message,
      icon: FaIcon(
        icon,
        size: 28.0,
        color: color,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.GROUNDED,
    ).show(context);
  }

  IconButton _buildDeleteButton() => IconButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Delete Product'),
              content: const Text('Are you sure you want to delete'),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
                TextButton(
                  child: const Text('ok'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    deleteProduct();
                    // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.delete_outline));

  void editProduct() {
    NetworkService()
        .editProduct(_product, imageFile: _imageFile)
        .then((result) {
      Navigator.pop(context);
      showAlertBar(result);
    }).catchError((error) {
      showAlertBar(
        error.toString(),
        icon: FontAwesomeIcons.circleXmark,
        color: Colors.red,
      );
    });
  }

  void deleteProduct() {
    NetworkService().deleteProduct(_product.id!).then((result) {
      Navigator.pop(context);
      showAlertBar(result);
    }).catchError((error) {
      showAlertBar(
        error.toString(),
        icon: FontAwesomeIcons.circleXmark,
        color: Colors.red,
      );
    });
  }
}
