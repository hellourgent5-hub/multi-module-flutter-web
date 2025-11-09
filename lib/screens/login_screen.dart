import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool loading = false;

  void _submit(bool isRegister) async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    setState(() => loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      if (isRegister) {
        await auth.register('New User', email, password, 'customer');
      } else {
        await auth.login(email, password);
      }
      if (auth.isAuth) {
        if (auth.userRole == 'store' || auth.userRole == 'vendor') {
          Navigator.of(context).pushReplacementNamed('/vendor');
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Register')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _form,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (v) => email = v!.trim(),
                  validator: (v) => v != null && v.contains('@') ? null : 'Enter valid email',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (v) => password = v!.trim(),
                  validator: (v) => v != null && v.length >= 4 ? null : 'Min 4 chars',
                ),
                const SizedBox(height: 12),
                if (loading) const CircularProgressIndicator(),
                if (!loading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () => _submit(false), child: const Text('Login')),
                      TextButton(onPressed: () => _submit(true), child: const Text('Register (customer)')),
                    ],
                  )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
