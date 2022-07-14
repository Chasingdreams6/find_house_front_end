import 'dart:convert';

import 'package:app/routes/house_detail_page.dart';
import 'package:app/routes/login_page.dart';
import 'package:app/service/backend_service/select_house/house_page_entity.dart';
import 'package:app/service/house_list_service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/storage.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/result.dart';
import '../widgets/house_card.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  late String name;
  late List<HouseDetail> houseList;
  // 私有方法

  @override
  void initState() {
     super.initState();
     name = "游客";
     houseList = [];
  }

  Future<List<void>> _getDatas() async {
    // await _getName();
    // await _getHouse();
    return await Future.wait(
      [
        _getName(),
        _getHouse(),
      ]
    );
  }

  Future<void> _getHouse() async {
    var url = Uri.parse('${Constants.backend}/user/getFavorites');
    final token = await StorageUtil.getStringItem('token');
    var response = await http.post(url, headers: {'Authorization' : 'Bearer $token'});
    if (response.statusCode != 200) {
      print("empty list!");
      houseList = [];
    }
    else {
      List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
      print(responseJson);
      houseList.clear();
      for (var v in responseJson) {
        houseList.add(Content.fromJson(v).toHouseDetail());
      }
    }
  }

  Future<void> _getName() async {
    await StorageUtil.getStringItem('name').then((value) => {
      name = value ?? "游客",
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDatas(),
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: const Text('地图找房'),
              ),
              body: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(20),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage("https://i-1-lanrentuku.52tup.com"
                          "/2020/11/5/8cc3854a-c8bd-456a-8b36-9209de3ccbfb.png?imageV"
                          "iew2/2/w/1024/"),
                    ),
                    title: Text(name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: "login"),
                          builder: (context) => LoginPage(
                            title: "欢迎登录",
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: Color(0xFFE8E8E8),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE8E8E8),
                            offset: Offset(8, 8),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: BrnShadowCard(
                        padding: const EdgeInsets.all(15),
                        circular: 10,
                        color: Colors.white,
                        child: BrnEnhanceNumberCard(
                          rowCount: 2,
                          itemChildren: [
                            BrnNumberInfoItemModel(
                              title: '我的收藏',
                              number: houseList.length.toString(),
                            ),
                            BrnNumberInfoItemModel(
                              title: '最近浏览',
                              number: '180',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    child: const Text(
                      '我的收藏',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Divider(),
                  houseDetailToHouseList(houseList),
                ],
              ),
            );
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
      },
    );
  }
}
