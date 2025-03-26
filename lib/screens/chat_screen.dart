import 'package:chat_ai/providers/chat_provider.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController pesanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat AI Assistance'),),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, value, child){
                return ListView.builder(
                  reverse: true,
                  itemCount: value.cm.length,
                  itemBuilder: (context, index){
                    final chat = value.cm[value.cm.length - index - 1];
                    return BubbleSpecialThree(
                      text: chat.message,
                      color: chat.isUser ? Colors.blue : Colors.grey[300]!,
                      tail: true,
                      isSender: chat.isUser,
                      textStyle: TextStyle(color: chat.isUser ? Colors.white : Colors.black),
                    );
                  }
                );
              }
            )
          ),
          Consumer<ChatProvider>(
            builder:(context, value, child) {
              return value.isLoading == true ? LinearProgressIndicator() : const SizedBox();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: pesanController,
                    decoration: InputDecoration(
                      hintText: 'Input pesan Anda ...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value){
                      context.read<ChatProvider>().sendMessage(value);
                      pesanController.clear();
                    },
                  ),
                ),
                IconButton(
                  onPressed: (){
                    context.read<ChatProvider>().sendMessage(pesanController.text);
                    pesanController.clear();
                  }, 
                  icon:  Icon(Icons.send)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}