import 'package:flutter/material.dart';

const String role = "";
bool _clientIsPressed = false;
bool _offerIsPressed = false;

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: Text('CHIPIN'),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top:10)),
          IDInput(),
          PasswordInput(),
          PasswordConfirmInput(),
          NameInput(),
          EmailInput(),
          RegistButton()
        ],
      ),
    );
  }
}


class IDInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'id',
          helperText: '',
        ),
      ),
    );
  }
}


class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'email',
          helperText: '',
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'password',
          helperText: ''
        ),
      ),
    );
  }
}

class PasswordConfirmInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'password confirm',
          helperText: '',
        ),
      ),
    );
  }
}


class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'name',
          helperText: '',
        ),
      ),
    );
  }
}

class RegistButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {},
        child: Text('Regist'),
      ),
    );
  }
}