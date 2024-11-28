import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'mysql.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  // Instansiasi helper MySQL
  final _mySQLHelper = MySQLHelper();

  // Library Warna
  Color hijau_level_one = Color(0XFF1E5631);
  Color hijau_level_three = Color(0XFF76BA1B);
  Color putih = Color(0XFFFEFEFE);
  Color hitam = Color(0XFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kita',
                    style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: hijau_level_one),
                  ),
                  Text(
                    'Sehat',
                    style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: hijau_level_three),
                  )
                ],
              ),
            ),
            Text(
              'Semua bisa sehat mulai sekarang',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 15, color: hitam),
            ),
            SizedBox(height: 32),
            // Form Fields for Registration
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  // Email Field
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "Email",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pastikan bagian ini terisi ya!';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  // Password Field
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "Masukan Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pastikan bagian ini terisi ya!';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  // Login Button
                  SizedBox(
                    width: 360,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(hijau_level_one),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          bool isVerify = await _mySQLHelper.verifyUser(
                            email.text,
                            password.text,
                          );
                          if (isVerify) {
                            // Jika berhasil, simpan data di Hive dan pindah ke halaman berikutnya
                            var box = await Hive.openBox('loginBox');
                            await box.put('username', email.text);
                            // Navigator.pushReplacementNamed(
                            //     context, '/homepage');
                          } else {
                            print('Berhasil terhubung ke MySQL!');
                            // Jika registrasi gagal, tampilkan dialog error
                            _showErrorDialog(
                                'Registrasi gagal. Silakan coba lagi.');
                          }
                        }
                      },
                      child: Text(
                        "Masuk",
                        style: GoogleFonts.poppins(fontSize: 16, color: putih),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
            ),
          ],
        );
      },
    );
  }
}