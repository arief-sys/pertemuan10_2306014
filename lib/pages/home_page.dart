import 'package:flutter/material.dart';
import 'package:pertemuan10_2306014/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString("username") ?? "";
    });
  }

  Future<void> logout() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const .all(20),
            child: Container(
              height: 100,
              padding: .symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: .circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.withAlpha(100),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage("https://picsum.photos/200"),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "Hai, Selamat Datang",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified,
                              color: Colors.amberAccent,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: .all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: .circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(100),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.logout,
                          size: 28,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
