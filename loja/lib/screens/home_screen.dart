import 'package:flutter/material.dart';
import 'package:loja/tabs/home_tab.dart';

import '../tabs/orders_tab.dart';
import '../tabs/places_tab.dart';
import '../tabs/products_tab.dart';
import '../widgets/cart_button.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: const HomeTab(),
          floatingActionButton: const CartButton(),
          drawer: CustomDrawer(pageController: pageController),
        ),
        Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: primaryColor,
            title: const Text("Produtos"),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            centerTitle: true,
          ),
          body: const ProductsTab(),
          floatingActionButton: const CartButton(),
          drawer: CustomDrawer(pageController: pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Lojas'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: const PlacesTab(),
          drawer: CustomDrawer(pageController: pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Meus Pedidos'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: const OrdersTab(),
          drawer: CustomDrawer(pageController: pageController),
        ),
      ],
    );
  }
}
