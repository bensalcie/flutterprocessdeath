import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RestorationScope(
      restorationId: 'root',
      child: MaterialApp(
        restorationScopeId: 'app',
        title: 'Dala Foods',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: const MyHomePage(title: 'Dala Foods'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with RestorationMixin<MyHomePage> {
  final ValueNotifier<List> cartFoods = ValueNotifier([]);
  final dalaFoods = [
    {
      'id': 1,
      'title': 'Rice fried fish',
      'image':
          'https://media-cdn.tripadvisor.com/media/photo-s/13/b5/c6/54/2018-07-15-15-19-21-largejpg.jpg',
      'cost': 345.00,
      'description': 'Rice fried fish served with Salad',
    },
    {
      'id': 2,
      'title': 'Chapati Fish, Wet fry',
      'image':
          'https://media-cdn.tripadvisor.com/media/photo-p/16/55/95/ea/photo0jpg.jpg',
      'cost': 432.00,
      'description': 'Chapati Fish, Wet fry served with Salad',
    },
    {
      'id': 3,
      'title': 'Chicken Vegan With Fish',
      'image':
          'https://sunsethotel.co.ke/wp-content/uploads/elementor/thumbs/food-close-up-1-pu31r2fuo1fi996nlczwiojyhjlx1mhpgwn6yz333w.png',
      'cost': 240.00,
      'description': 'Chicken Vegan With Fish served with Salad',
    },
    {
      'id': 3,
      'title': 'Chicken Vegan With Fish',
      'image':
          'https://sunsethotel.co.ke/wp-content/uploads/elementor/thumbs/food-close-up-1-pu31r2fuo1fi996nlczwiojyhjlx1mhpgwn6yz333w.png',
      'cost': 100.00,
      'description': 'Chicken Vegan With Fish served with Salad',
    },
    {
      'id': 3,
      'title': 'Chicken Vegan With Fish',
      'image':
          'https://sunsethotel.co.ke/wp-content/uploads/elementor/thumbs/food-close-up-1-pu31r2fuo1fi996nlczwiojyhjlx1mhpgwn6yz333w.png',
      'cost': 400.00,
      'description': 'Chicken Vegan With Fish served with Salad',
    },
    {
      'id': 3,
      'title': 'Chicken Vegan With Fish',
      'image':
          'https://sunsethotel.co.ke/wp-content/uploads/elementor/thumbs/food-close-up-1-pu31r2fuo1fi996nlczwiojyhjlx1mhpgwn6yz333w.png',
      'cost': 300.00,
      'description': 'Chicken Vegan With Fish served with Salad',
    },
  ];

  RestorableString cartItems = RestorableString('[]');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.75),
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (context, index) {
            final dalaFood = dalaFoods[index];
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: dalaFood['image'].toString(),
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(dalaFood['title'].toString()),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("${dalaFood['cost']} Ksh"),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          cartFoods.value = List.from(cartFoods.value)
                            ..add(dalaFood);
                          cartItems.value =
                              jsonEncode(cartFoods.value).toString();
                        });
                      },
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text('Add to Cart'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            );
          },
          itemCount: dalaFoods.length),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: cartFoods,
        builder: (context, value, child) {
          return FloatingActionButton.extended(
            onPressed: () {
              final itemsOnCart = cartItems.value;

              final myCart = jsonDecode(itemsOnCart) as List;

              final totalCosts = myCart.map((e) => e['cost']).toList();

              double sum = totalCosts.fold(0, (a, b) => a + b);

              showDialog(
                  context: context,
                  builder: (ctxt) => CupertinoAlertDialog(
                        title: const Text("Checkout Items"),
                        content: Column(
                          children: [
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return CupertinoListTile(
                                    title: Text(myCart[index]['title']),
                                    subtitle:
                                        Text('${myCart[index]['cost']}Ksh.'),
                                    leading: CachedNetworkImage(
                                      imageUrl: myCart[index]['image'],
                                      height: 45,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                                itemCount: myCart.length,
                              ),
                            ),
                            Text("Total Ksh $sum",
                                style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);

                                cartItems.value.isNotEmpty
                                    ? QuickAlert.show(
                                        confirmBtnColor: Colors.cyan,
                                        context: context,
                                        type: QuickAlertType.success,
                                        text:
                                            'Transaction Completed Successfully!',
                                      )
                                    : QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.warning,
                                        text:
                                            'Soryy , No items are on the Cart',
                                      );

                                setState(() {
                                  cartFoods.value.clear();
                                  cartItems.value = '[]';
                                });
                              },
                              color: Colors.amber,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Center(
                                child: Text('Complete Order'),
                              ),
                            ),
                          ],
                        ),
                      ));
            },
            tooltip: 'Checkout',
            label: Text(
                'Checkout (${(jsonDecode(cartItems.value) as List).length})'),
            icon: const Icon(Icons.shopping_basket),
          );
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  String get restorationId => 'dalafoods';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(cartItems, restorationId);
  }
}
