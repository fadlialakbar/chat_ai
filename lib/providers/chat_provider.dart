
import 'dart:convert';

import 'package:chat_ai/models/chat_message.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatProvider with ChangeNotifier{
  List<ChatMessage> _cm = [];
  bool _isLoading = false;

  List<ChatMessage> get cm => _cm;
  bool get isLoading => _isLoading;


  //Fungsi Kirim Pesan
  Future<void> sendMessage (String message) async {
    cm.add(
      ChatMessage(message: message, isUser: true, time: DateTime.now())
    );
    notifyListeners();

    _isLoading = true;
    notifyListeners();


    try{
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type" :  "application/json",
          "Authorization" : "Bearer ${dotenv.env['OPENAI_API_KEY']}"
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [{
              "role": "user",
              "content": message
          }]
        })
      );

      final data = jsonDecode(response.body);

      print(data);

      if(data.containsKey('error')){
        throw Exception(data['error']['message']);
      }
      
      final aiResponse = data['choices'][0]['message']['content'];

      _cm.add(
        ChatMessage(message: aiResponse, isUser: false, time: DateTime.now())
      );


    }catch(e){

      print(e);

      _cm.add(
        ChatMessage(message: 'Sorry terjadi kesalahan, Coba lagi', isUser: false, time: DateTime.now())
      );
    }

    _isLoading = false;
    notifyListeners();
  }

}