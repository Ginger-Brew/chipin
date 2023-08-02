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
        title: Text('REMIND DIARY'),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top:10)),
          EmailInput(),
          PasswordInput(),
          PasswordConfirmInput(),
          ChoiceRole(),
          RegistButton()
        ],
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

class ChoiceRole extends StatefulWidget {
  const ChoiceRole({super.key});

  @override
  _ChoiceRoleState createState() => _ChoiceRoleState();
}

class _ChoiceRoleState extends State<ChoiceRole> {
  void _clientToggleButton() {
    setState(() {
      _clientIsPressed = !_clientIsPressed;
      _offerIsPressed = false;
    });
  }

  void _offerToggleButton() {
    setState(() {
      _offerIsPressed = !_offerIsPressed;
      _clientIsPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Text("유형을 선택해주세요",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),),
        ),
        Container(
        margin: EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3.0,
                    spreadRadius: 5.0,
                  ),],
              ),
              child:ElevatedButton(
                onPressed: _clientToggleButton,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (_clientIsPressed) {
                        return Colors.indigoAccent; // 선택시
                    }
                        return Colors.white; // 그 외에는 흰색
                    }),
                  ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Image.asset('images/client.png'),
                        width: 100,
                        height: 100,
                      ),
                      Text(
                          "내담자",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3.0,
                    spreadRadius: 5.0,
                  ),],
              ),
              child:ElevatedButton(
                onPressed: _offerToggleButton,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (_offerIsPressed) {
                      return Colors.amber; // 선택시
                    }
                    return Colors.white; // 그 외에는 흰색
                  }),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Image.asset('images/offer.png'),
                        width: 100,
                        height: 100,
                      ),
                      Text("상담가",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      )],
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