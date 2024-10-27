import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resource_tracker/modules/authentication/blocs/authentication_bloc.dart';
import 'package:resource_tracker/modules/authentication/blocs/authentication_state.dart';

import '../blocs/authentication_event.dart';
import '../models/auth_form_data.dart';
import '../../../route_generator.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formkey = GlobalKey<FormState>();
  final _formData = AuthFormData();
  bool _isSignInMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, state) {
          if (state is AuthenticationLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthenticationSuccess) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(RouteGenerator.home);
          } else if (state is AuthenticationFailure) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.water_drop_outlined,
                    size: 96,
                  ),
                  Text(
                    "Resource Tracker",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12)),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 200),
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
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
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
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
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
                                  if (!_isSignInMode)
                                    const SizedBox(height: 16),
                                  AnimatedOpacity(
                                    opacity: _isSignInMode ? 0 : 1,
                                    duration: const Duration(milliseconds: 400),
                                    child: Visibility(
                                      visible: !_isSignInMode,
                                      child: TextFormField(
                                        autofillHints: const [
                                          AutofillHints.password
                                        ],
                                        validator:
                                            confirmationPasswordValidator,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Confirmar senha',
                                          hintText:
                                              'Repita a senha super secreta',
                                          icon: Icon(Icons.key),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                    ),
                                    child: FilledButton(
                                      onPressed: () async {
                                        if (!_formkey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        final email = _formData.email.trim();
                                        final password =
                                            _formData.password.trim();
                                        if (_isSignInMode) {
                                          context
                                              .read<AuthenticationBloc>()
                                              .add(
                                                SignInRequested(
                                                  email: email,
                                                  password: password,
                                                ),
                                              );
                                        } else {
                                          context
                                              .read<AuthenticationBloc>()
                                              .add(
                                                SignUpRequested(
                                                  email: email,
                                                  password: password,
                                                ),
                                              );
                                        }
                                      },
                                      child: Text(_isSignInMode
                                          ? 'Entrar'
                                          : 'Cadastrar-se'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSignInMode = !_isSignInMode;
                                });
                              },
                              child: Text(
                                _isSignInMode
                                    ? 'Sem conta? Cadastre-se!'
                                    : 'Já possui uma conta?',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
