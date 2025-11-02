import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class AiAssitantScreen extends ConsumerStatefulWidget {
  const AiAssitantScreen({super.key});

  @override
  ConsumerState<AiAssitantScreen> createState() => _AiAssitantScreenState();
}

class _AiAssitantScreenState extends ConsumerState<AiAssitantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  String _response = "";

  @override
  void initState() {
    super.initState();
    // Add initial bot message
    _addMessage(
      "bot_greeting".tr(),
      false,
    );
  }

  void _addMessage(String message, bool isUser) {
    setState(() {
      _messages.add(
        ChatMessage(
          message: message,
          isUser: isUser,
          timestamp: DateTime.now(),
        ),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    _addMessage(text, true);

    setState(() => _isTyping = true);

    await Future.delayed(const Duration(seconds: 1));

    //----------// flutter gemini //
    // await _sendQuery(text);
    // String botResponse = _response;

    String botResponse = "bot_greeting".tr();
    // "I understand you're asking about '$text'. How can I assist you further?";
    
    setState(() => _isTyping = false);
    _addMessage(botResponse, false);
  }

  Future<void> _sendQuery(String query) async {
    print("query: $query");
    try {
      // final result = await Gemini.instance.text(query);
      // setState(() {
      //   _response = result?.output ?? "";
      //   print("response: $_response");
      // });
    } catch (error) {
      setState(() {
        _response = "Error: $error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        isRemoveBottom: true,
      ),
      body: Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.appWhiteColor,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                    gradient:
                        LinearGradient(colors: AppColors.appGradientColors)),
                child: ListTile(
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: SvgPicture.asset(
                          AppImages.aiVector,
                          height: 20.h,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MHPSS-Bot',
                            style: TextStyle(
                                color: AppColors.appWhiteColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'status_online'.tr(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      ref.read(bottomNavProvider.notifier).setIndex(0);
                    },
                    child:
                        const Icon(Icons.close, color: AppColors.appWhiteColor),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              if (_isTyping)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'bot_typing'.tr(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              _buildMessageComposer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            Padding(
              padding: EdgeInsets.only(
                  right: 8.0,
                  left: context.locale.languageCode == 'ar' ? 8.0 : 0),
              child: CircleAvatar(
                backgroundColor: AppColors.appBlueColor.withOpacity(.3),
                child: SvgPicture.asset(
                  AppImages.aiVector,
                  height: 20.h,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.textBlueColor
                    : AppColors.messageGreyColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                message.message,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: message.isUser
                        ? Colors.white
                        : AppColors.textBlackColor),
              ),
            ),
          ),
          // if (message.isUser)
          //   Padding(
          //     padding: const EdgeInsets.only(left: 8.0),
          //     child: CircleAvatar(
          //       backgroundColor: Colors.blue[700],
          //       child: const Icon(Icons.person, size: 20, color: Colors.white),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(minHeight: 45.0, maxHeight: 45.0),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'ask_your_question'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTitleColor,
                  ),
                ),
                onSubmitted: _handleSubmitted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            color: AppColors.textBlueColor,
            onPressed: () => _handleSubmitted(_messageController.text),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}
