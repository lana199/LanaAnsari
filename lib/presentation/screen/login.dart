import 'package:assitant2/manager/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _obscureText = true;
  String _email;
  String _password;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<AuthBloc>().add(AuthStateChecked());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('تسجيل الدخول'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(AuthGoogleAccountLoggedIn());
                      },
                      icon: Icon(Icons.android),
                      label: Text('تسجيل الدخول باستخدام حساب Google')),
                  SizedBox(
                    height: 16.0,
                  ),
                  Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        child: Divider(thickness: 0.9),
                        flex: 2,
                      ),
                      Flexible(
                        child: Text('OR'),
                      ),
                      Flexible(
                        child: Divider(
                          thickness: 0.9,
                        ),
                        flex: 2,
                      )
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'البريد الالكتروني',
                    ),
                    // style: TextStyle(color: Colors.black),
                    onSaved: (email) => _email = email,
                    validator: (value) {
                      value = value ?? '';
                      if (value.trim().isEmpty) {
                        return 'الرجاء إدخال البريد الالكتروني';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    // style: TextStyle(color: Colors.black),
                    validator: (value) {
                      value = value ?? '';
                      if (value.trim().isEmpty) {
                        return 'الرجاء إدخال كلمة السر';
                      } else if (value.length < 6)
                        return 'يجب ان تكون كلمة السر اكبر من 6 محارف';
                      return null;
                    },
                    onSaved: (password) => _password = password,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.visibility_rounded,
                            // color: Colors.blueGrey,
                          ),
                          onPressed: () => setState(() {
                            _obscureText = !_obscureText;
                          }),
                        ),
                        labelText: 'كلمة السر'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.msg)));
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthInProgress) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: null,
                                child: Text('إنشاء حساب جديد')),
                            CircularProgressIndicator(),
                          ],
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/create-account');
                              },
                              child: Text('إنشاء حساب جديد')),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  context.read<AuthBloc>().add(
                                      AuthAccountLoggedIn(_email, _password));
                                }
                              },
                              child: Text('تسجيل الدخول'))
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
