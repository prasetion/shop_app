import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = "/edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: "",
    title: "",
    desc: "",
    price: 0,
    imageUrl: "",
  );

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState!.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.desc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                      id: "",
                      title: newValue as String,
                      desc: _editedProduct.desc,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onSaved: (newValue) {
                  _editedProduct = Product(
                      id: "",
                      title: _editedProduct.title,
                      desc: _editedProduct.desc,
                      price: double.parse(newValue!),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                      id: "",
                      title: _editedProduct.title,
                      desc: newValue as String,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageURLController.text.isEmpty
                        ? Text("Enter a URL")
                        : FittedBox(
                            child: Image.network(
                              _imageURLController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Image Url"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageURLController,
                      focusNode: _imageURLFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: "",
                          title: _editedProduct.title,
                          desc: _editedProduct.desc,
                          price: _editedProduct.price,
                          imageUrl: newValue as String,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
