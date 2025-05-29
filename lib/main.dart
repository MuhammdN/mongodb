import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

const String baseUrl = 'https://716521aa-e0e5-4764-9178-f5458b110f59-00-22sbkdnw63fzr.pike.replit.dev';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Node API',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserPage(),
    );
  }
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<dynamic> users = [];

  Future<void> addUser() async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('User added!');
      fetchUsers();
    } else {
      print('Failed to add user: ${response.body}');
    }
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        users = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch users');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MongoDB Flutter App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addUser,
              child: Text('Add User'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['username']),
                    subtitle: Text(user['password']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
