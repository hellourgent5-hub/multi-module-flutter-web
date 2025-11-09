import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});
  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  final _form = GlobalKey<FormState>();
  String name = '';
  String desc = '';
  String price = '';

  Future<void> _create() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final headers = auth.isAuth ? auth.authHeader : {};
      final res = await ApiService.post('/store/products', {
        'name': name,
        'description': desc,
        'price': double.tryParse(price) ?? 0
      }, headers: headers);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product created')));
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        actions: [
          IconButton(onPressed: () { auth.logout(); Navigator.of(context).pushReplacementNamed('/'); }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Text('Logged in as: ${auth.userEmail ?? 'unknown'}'),
          const SizedBox(height: 12),
          Form(
            key: _form,
            child: Column(children: [
              TextFormField(decoration: const InputDecoration(labelText: 'Product name'), onSaved: (v) => name = v ?? '', validator: (v) => v?.isEmpty ?? true ? 'Required' : null),
              TextFormField(decoration: const InputDecoration(labelText: 'Description'), onSaved: (v) => desc = v ?? ''),
              TextFormField(decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number, onSaved: (v) => price = v ?? '', validator: (v) => (v != null && double.tryParse(v) != null) ? null : 'Invalid price'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _create, child: const Text('Create Product')),
            ]),
          )
        ]),
      ),
    );
  }
}
