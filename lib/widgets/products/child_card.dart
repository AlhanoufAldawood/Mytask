import 'package:flutter/material.dart';

//import '../ui_elements/title_default.dart';
import '../../models/child.dart';

class ProductCard extends StatelessWidget {
  final Child product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow(BuildContext context) {
    return Container(
   // color: Colors.lightBlue[50],
    child: Column(
    children: <Widget>[

    //Text(
    // kids[index]['name'],
    // style: new TextStyle(fontSize: 30.0 ,color: Colors.blueGrey, fontWeight:FontWeight.bold ),),
    ButtonBar(
    alignment: MainAxisAlignment.center,
    children: <Widget>[

    FlatButton(
    child: Text(product.name,
    style: new TextStyle(fontSize: 30.0 ,color: Colors.blueGrey, fontWeight:FontWeight.bold ),
    ),
    onPressed: () => Navigator.pushNamed<bool>(context, '/product/' + productIndex.toString()),
    ),
  ]
    )
  ]),
    );
    /*return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: FlatButton(
        //mainAxisAlignment: MainAxisAlignment.center,
        child: TitleDefault(product.name),
         onPressed: (){},
         // SizedBox(
           // width: 8.0,
          ),

       // ],
     // ),
    );*/
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product.user),
          _buildTitlePriceRow(context),

        ],
      ),
    );

  }
}
