

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMultiChildLatyoutWidget extends StatelessWidget {
  const CustomMultiChildLatyoutWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Layout-6 CustomMultiChildLayout'),
//       ),
//       body: CustomMultiChildLayout(
//         delegate: MyDelegate(),
//         children: [
//           LayoutId(id: 1, child: FlutterLogo(size: 250)),
//           LayoutId(id: 2,
//           child: FlutterLogo()),
//         ],
//        
//       ),
//     );
//   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Layout-6 CustomMultiChildLayout'),
      ),
      body: Container(
        color: Colors.red[200],
        child: CustomMultiChildLayout(
          delegate: UnderLineDelegate(tickness: 2.0),
          children: [
            LayoutId(id: 'underline',
                child: Container(color: Colors.red)),
            LayoutId(id: 'text', child: Text('COME ON', style: TextStyle(fontSize: 70),)),

          ],

        ),
      ),
    );
  }

}


class UnderLineDelegate extends MultiChildLayoutDelegate {
  final double tickness;

  UnderLineDelegate({this.tickness = 8.0});

  @override
  Size getSize(BoxConstraints constraints) {
     return constraints.biggest;
  }

  @override
  void performLayout(Size size) {
    final sizeText = layoutChild("text",
        BoxConstraints.loose(size)
    );
    layoutChild("underline", BoxConstraints.tight(Size(sizeText.width, tickness)));

    final left = (size.width - sizeText.width) / 2;
    final top = (size.height - sizeText.height) / 2;

    positionChild("text", Offset(left, top));
    positionChild("underline", Offset(left, top + sizeText.height));
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;

}
  
  
  
  

class MyDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    var size1, size2;
    print(size);
     if (hasChild(1)) {
       size1 = layoutChild(1, BoxConstraints.loose(size));
       // size1 = layoutChild(1, BoxConstraints(
       //   minWidth: 100,
       //   minHeight: 100,
       //   maxWidth: 100,
       //   maxHeight: 100
       // ));
       positionChild(1, Offset(0, 0));
     }

     if (hasChild(2)) {
       size2 = layoutChild(2, BoxConstraints(
           minWidth: 200,
           minHeight: 200,
           maxWidth: 200,
           maxHeight: 200
       ));
       positionChild(2, Offset(size1.width, size1.height));
     }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
     return true;
  }

}
