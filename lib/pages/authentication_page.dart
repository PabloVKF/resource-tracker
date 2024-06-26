import 'package:flutter/material.dart';

import '../models/auth_form_data.dart';
import '../route_generator.dart';
import '../services/authentication_service.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formkey = GlobalKey<FormState>();
  final _formData = AuthFormData();
  bool _isSignup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Form(
                          key: _formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                validator: emailValidator,
                                onChanged: (String text) {
                                  _formData.email = text;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'E-mail',
                                  hintText: 'exemplo@exemplo.com',
                                  icon: Icon(Icons.mail),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                validator: passwordValidator,
                                onChanged: (String text) {
                                  _formData.password = text;
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Senha',
                                  hintText: 'senha super secreta',
                                  icon: Icon(Icons.key),
                                ),
                              ),
                              if (_isSignup) const SizedBox(height: 16),
                              if (_isSignup)
                                TextFormField(
                                  validator: confirmationPasswordValidator,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirmar senha',
                                    hintText: 'Repita a senha super secreta',
                                    icon: Icon(Icons.key),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                ),
                                child: FilledButton(
                                  onPressed: () async {
                                    if (!_formkey.currentState!.validate()) {
                                      return;
                                    }

                                    try {
                                      if (_isSignup) {
                                        await AuthenticationService()
                                            .createWithEmailAndPassword(
                                          email: _formData.email,
                                          password: _formData.password,
                                        );
                                      } else {
                                        await AuthenticationService()
                                            .signInWithEmailAndPassword(
                                          email: _formData.email,
                                          password: _formData.password,
                                        );
                                      }

                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                            RouteGenerator.home);
                                      }
                                    } on Exception catch (_) {
                                      rethrow;
                                    }
                                  },
                                  child: Text(
                                      _isSignup ? 'Cadastrar-se' : 'Entrar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isSignup = !_isSignup;
                            });
                          },
                          child: Text(
                            _isSignup
                                ? 'Já possui uma conta?'
                                : 'Sem conta? Cadastre-se!',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Campo obrigatório';
    }
    if (!email.contains('@')) {
      return 'E-mail invalido';
    }
    return null;
  }

  String? passwordValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Campo obrigatório';
    }
    if (email.length < 8) {
      return 'Senha deve ter pelo menos 8 caracteres';
    }
    return null;
  }

  String? confirmationPasswordValidator(String? text) {
    if (text == null || text.isEmpty) {
      return 'Campo obrigatório';
    }
    if (text != _formData.password) {
      return 'Deve ser igual ao campo de senha';
    }
    return null;
  }
}
