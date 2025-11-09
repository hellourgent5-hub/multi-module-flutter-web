import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    try {
      final res = await ApiService.get('/store/products');
      setState(() { products = res is List ? res : (res['data'] ?? res); loading = false; });
    } catch (err) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: fetch,
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          final p = products[i];
          return ListTile(
            title: Text(p['name'] ?? 'Unnamed'),
            subtitle: Text(p['description'] ?? ''),
            trailing: Text('₹${p['price'] ?? ''}'),
            onTap: () {
              showDialog(context: context, builder: (_) => AlertDialog(
                title: Text(p['name'] ?? ''),
                content: Text('Buy ${p['name']} for ₹${p['price']}?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed (demo)')));
                  }, child: const Text('Buy')),
                ],
              ));
            },
          );
        },
      ),
    );
  }
}
