import 'package:flutter/material.dart';
import 'package:login_and_signup_with_sqflite/app/presenter/ui/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/user_model.dart';
import '../../../infra/datasource/local/database_helper.dart';
import '../../logic/alert_dialog.dart';

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
  final passController = TextEditingController();
  //variável da base de dados
  var dbHelper;

  //função que realiza a verificação do email e da senha no banco de dados
  login() async {
    FocusManager.instance.primaryFocus?.unfocus;
    String email = emailController.text;
    String pass = passController.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await dbHelper.getLoginUser(email, pass).than((userData) {
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
      body: Container(),
    );
  }
}
