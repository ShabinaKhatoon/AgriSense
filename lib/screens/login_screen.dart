import 'package:flutter/material.dart';

import '../models/farmer.dart';
import '../services/agri_api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.apiService,
    required this.onLogin,
  });

  final AgriApiService apiService;
  final ValueChanged<Farmer> onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Test Farmer');
  final _phoneController = TextEditingController(text: '9000000001');
  final _passwordController = TextEditingController(text: '1234');
  final _villageController = TextEditingController(text: 'Green Valley');
  final _farmSizeController = TextEditingController(text: '2.5');
  bool _isRegisterMode = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _villageController.dispose();
    _farmSizeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final farmer = _isRegisterMode
          ? await widget.apiService.registerFarmer(
              fullName: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text,
              village: _villageController.text.trim(),
              farmSizeAcres: double.tryParse(_farmSizeController.text) ?? 0,
            )
          : await widget.apiService.loginFarmer(
              phone: _phoneController.text.trim(),
              password: _passwordController.text,
            );

      if (!mounted) return;
      widget.onLogin(farmer);
    } catch (error) {
      if (!mounted) return;
      final details = _formatError(error);
      setState(() {
        _errorMessage = _isRegisterMode
            ? 'Registration failed. $details'
            : 'Login failed. $details';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatError(Object error) {
    final message = error.toString().replaceFirst(
      RegExp(r'^Exception:\s*'),
      '',
    );
    if (message.contains('Invalid phone or password')) {
      return 'Register first or check password.';
    }
    if (message.contains('Farmer with this phone already exists')) {
      return 'This phone is already registered. Switch to login.';
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.agriculture,
                          color: Colors.white,
                          size: 42,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'AgriSense',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Smart farming dashboard for soil health, irrigation alerts, and crop monitoring.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _isRegisterMode
                                  ? 'Create Farmer Account'
                                  : 'Farmer Login',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 16),
                            if (_isRegisterMode) ...[
                              _field(
                                controller: _nameController,
                                label: 'Full Name',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 12),
                              _field(
                                controller: _villageController,
                                label: 'Village',
                                icon: Icons.location_on_outlined,
                              ),
                              const SizedBox(height: 12),
                              _field(
                                controller: _farmSizeController,
                                label: 'Farm Size (acres)',
                                icon: Icons.landscape_outlined,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 12),
                            ],
                            _field(
                              controller: _phoneController,
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 12),
                            _field(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: true,
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFC62828),
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            FilledButton.icon(
                              onPressed: _isLoading ? null : _submit,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      _isRegisterMode
                                          ? Icons.person_add
                                          : Icons.login,
                                    ),
                              label: Text(
                                _isRegisterMode ? 'Register & Login' : 'Login',
                              ),
                            ),
                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _isRegisterMode = !_isRegisterMode;
                                        _errorMessage = null;
                                      });
                                    },
                              child: Text(
                                _isRegisterMode
                                    ? 'Already registered? Login'
                                    : 'New farmer? Create account',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}
