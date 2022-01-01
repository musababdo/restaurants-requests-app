import 'package:flutter/cupertino.dart';
import 'package:talabat/models/product.dart';

class CartItem extends ChangeNotifier{

  List<Product> products=[];
  int qua;

  addProduct(Product product,int qu){
    products.add(product);
    qua=qu;
    notifyListeners();
  }

  deleteProduct(Product product) {
    products.remove(product);
    notifyListeners();
  }

  deleteAll(){
    products.clear();
    notifyListeners();
  }

}