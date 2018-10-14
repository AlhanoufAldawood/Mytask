import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../models/user.dart';
import '../models/product.dart';


class ConnectedProductsModel extends Model {

  List<Child> _childern = [];
  int _selProductIndex;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Null> addProduct(
      String name , String gender, double age ,String user ,String password) {
      _isLoading = true;
      notifyListeners();
    final Map<String ,dynamic> childData ={
      'name' : name,
      'gender' : gender,
      'age' : age,
      'user': user,
      'password':password,
      'parentEmail' : _authenticatedUser.email,
      'parentId': _authenticatedUser.id,

    };
     return
       http.post('https://mytask-8c4b1.firebaseio.com/childern.json' ,
        body: json.encode(childData)).then((http.Response response) {
          _isLoading =false;
          final Map<String ,dynamic> responseData = json.decode(response.body);

          final Child newchild = Child(
          id: responseData['name'],
          name: name ,
          gender: gender ,
          age : age,
          user: user,
          password:password ,
          parentEmail: _authenticatedUser.email ,
          parentId: _authenticatedUser.id );

      _childern.add(newchild);
      notifyListeners();

    }
    );



  }

}

class ProductsModel extends ConnectedProductsModel {

  List<Child> get allProducts {
    return List.from(_childern);
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Child get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _childern[selectedProductIndex];
  }



  Future<Null> updateProduct(String name , String gender, double age ,String user ,String password) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'name': name,
      'gender': gender,
      'age': age,
      'user': user,
      'password': password,
      'parentEmail': _authenticatedUser.email,
      'parentId': _authenticatedUser.id,

    };
    return
      http.put('https://mytask-8c4b1.firebaseio.com/childern/${selectedProduct
        .id}.json',
        body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Child updatedChild = Child(
          id: selectedProduct.id,
          name: name,
          gender: gender,
          age: age,
          user: user,
          password: password,
          parentEmail: selectedProduct.parentEmail,
          parentId: selectedProduct.parentId);
      _childern[selectedProductIndex] = updatedChild;
      notifyListeners();
    });
  }



  void deleteProduct() {
    _isLoading =true;

    final deletedChildId = selectedProduct.id;

    _childern.removeAt(selectedProductIndex);
    _selProductIndex = null;
    notifyListeners();

    http.delete('https://mytask-8c4b1.firebaseio.com/childern/${deletedChildId}.json')
    .then((http.Response response){
      _isLoading = false;
      notifyListeners();
    });

  }

  void fetchData(){
    _isLoading = true;
    notifyListeners();
    http.get('https://mytask-8c4b1.firebaseio.com/childern.json')
    .then((http.Response response){
       _isLoading = false;
        notifyListeners();
      final List<Child> fetchedChildList= [];

      final Map<String,dynamic> childListData =
      json.decode(response.body);

      if(childListData == null){
        _isLoading =false;
        notifyListeners();
        return;
      }
      childListData.forEach((String childId ,dynamic childData) {
        final Child child = Child(
            id: childId,
            name: childData['name'],
            gender: childData['gender'],
            age: childData['age'],
            user: childData['user'],
            password: childData['password'],
            parentEmail: childData['parentEmail'],
            parentId: childData['parentId'],);

           fetchedChildList.add(child);

      });
      _childern = fetchedChildList;
      notifyListeners();
    });
  }

  void selectProduct(int index) {
    _selProductIndex = index;
  }
}

class UserModel extends ConnectedProductsModel {


  void login(String email , String password){

    _authenticatedUser = User(id: 'Alhanouf', email: email, password: password);


  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isloading{
    return _isLoading;
  }

}