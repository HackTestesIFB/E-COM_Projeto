import 'package:shared_preferences/shared_preferences.dart';

// Remove os dados salvos de um usuário
Future<void> logout() async
{
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('senha');
    await prefs.remove('id_usuario');
}