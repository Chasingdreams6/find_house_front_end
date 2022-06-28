import 'package:flutter/material.dart';
import 'house_card.dart';
import 'package:bruno/bruno.dart';

// 地图找房页面 点击某小区后，从下方弹出的房源详情列表 sheet
class HouseDetailBottomSheet extends StatefulWidget {
  const HouseDetailBottomSheet({Key? key}) : super(key: key);

  @override
  State<HouseDetailBottomSheet> createState() => _HouseDetailBottomSheetState();
}

class _HouseDetailBottomSheetState extends State<HouseDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        child: const Text('点击展开 bottom sheet'),
        onPressed: (){_showHouseDetailListSheet(context);},
      ),
    );
  }
}

void _showHouseDetailListSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // set this to true
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5, // 设置父容器的高度 1 ~ 0, initialChildSize必须 <= maxChildSize
        expand: false,
        builder: (_, controller) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                const ListTile(
                  title: Text('小区名称', style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w900),),
                  subtitle: Text('均价·房源套数等信息'),
                  trailing: Icon(Icons.keyboard_arrow_down),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: controller, // set this too
                    // 长度
                    itemCount: 15,
                    itemBuilder: (_, i) => const HouseCard(title: "title", rooms: 3, squares: 33, community: "community", price: 250, url: '',),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}