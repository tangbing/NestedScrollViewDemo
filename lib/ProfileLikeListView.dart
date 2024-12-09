

import 'package:flutter/material.dart';

class ProfileLikeListView extends StatelessWidget {
  const ProfileLikeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: 100,
      itemBuilder: (context, index) {
        // var item = provider.majlisDataModelList[index];
        // return MajlisItemCell(itemModel: item, itemCellType: MajlisType.postAndLike);
        return ListTile(leading: Text('this is the ${index} row'));
      },
    );
  }
}
