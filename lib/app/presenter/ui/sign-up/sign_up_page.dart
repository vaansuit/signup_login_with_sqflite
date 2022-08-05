import 'package:flutter/material.dart';
import 'package:login_and_signup_with_sqflite/app/domain/entities/user_model.dart';
import 'package:login_and_signup_with_sqflite/app/presenter/ui/widgets/custom_text_form_field.dart';

import '../../../infra/datasource/local/database_helper.dart';
import '../../logic/alert_dialog.dart';
import '../login/login_page..dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //nossa key
  final _formKey = GlobalKey<FormState>();
  //nossos controllers para escutar o que o usuário está digitando nos texts fields
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  //variavel do nosso banco de dados
  var dbHelper;

  //função que insere um novo usuário na nossa tabela
  signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    String userName = userNameController.text;
    String email = emailController.text;
    String pass = passController.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      UserModel? uModel = UserModel(
        userName,
        email,
        pass,
      );
      await dbHelper.saveData(uModel).then((userData) {
        alertDialog(context, "Usuário cadastrado com sucesso!");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }).catchError((error) {
        alertDialog(context, "Erro ao realizar cadastro");
      });
    }
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
                  controller: userNameController,
                  icon: Icons.person_outline,
                  inputType: TextInputType.name,
                  hintName: 'Nome do usuário',
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: emailController,
                  icon: Icons.email,
                  inputType: TextInputType.emailAddress,
                  hintName: 'Email',
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: passController,
                  icon: Icons.password,
                  inputType: TextInputType.name,
                  hintName: 'Senha',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: signUp,
                  child: const Text('Registrar!'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já possui um cadastro?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text('Faça login!'),
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
