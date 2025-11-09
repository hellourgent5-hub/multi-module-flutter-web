import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success Marketplace'),
        actions: [
          IconButton(onPressed: () { auth.logout(); Navigator.of(context).pushReplacementNamed('/'); }, icon: const Icon(Icons.logout))
        ],
      ),
      body: const ProductListScreen(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.shopping_cart_checkout),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart placeholder')));
        },
      ),
    );
  }
}
