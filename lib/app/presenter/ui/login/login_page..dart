import 'package:flutter/material.dart';
import 'package:login_and_signup_with_sqflite/app/presenter/ui/home/home_page.dart';
import 'package:login_and_signup_with_sqflite/app/presenter/ui/widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/user_model.dart';
import '../../../infra/datasource/local/database_helper.dart';
import '../../logic/alert_dialog.dart';
import '../sign-up/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //preferencias de usuário
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  //form key
  final _formKey = GlobalKey<FormState>();
  //controllers para pegar o email e a senha
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //variável da base de dados
  var dbHelper;

  //função que realiza a verificação do email e da senha no banco de dados
  login() async {
    FocusManager.instance.primaryFocus?.unfocus;
    String email = emailController.text;
    String pass = passwordController.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await dbHelper.getLoginUser(email, pass).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomePage(userData)),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Erro, usuário não encontrado!");
        }
      }).catchError((error) {
        alertDialog(context, "Erro ao fazer login!");
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;
    sp.setString("userName", user.userName);
    sp.setString("email", user.email);
    sp.setString("password", user.password);
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                CustomTextFormField(
                  controller: emailController,
                  icon: Icons.person,
                  hintName: 'Email',
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: passwordController,
                  icon: Icons.lock,
                  hintName: 'Senha',
                  isObscureText: true,
                ),
                ElevatedButton(
                  onPressed: login,
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem uma conta? '),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text('Registre-se'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
