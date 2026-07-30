import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/ai_answers.dart';
import 'widgets/chat_bubble.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiMessage {
  const _AiMessage.user(this.text)
      : isUser = true,
        warning = null;
  const _AiMessage.ai(this.text, this.warning) : isUser = false;
  final String text;
  final bool isUser;
  final String? warning;
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_AiMessage> _messages = [];
  bool _isTyping = false;
  int _freeQuestionsUsed = 0;
  static const _freeLimit = 3;
  bool _subscribed = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _ask(String question) async {
    if (question.trim().isEmpty) return;
    if (!_subscribed && _freeQuestionsUsed >= _freeLimit) {
      _showPaywall();
      return;
    }
    setState(() {
      _messages.add(_AiMessage.user(question));
      _controller.clear();
      _isTyping = true;
      if (!_subscribed) _freeQuestionsUsed++;
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 700));
    final answer = AiAnswers.answers[question] ?? AiAnswers.fallback(question);
    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _messages.add(_AiMessage.ai(answer.body, answer.warning));
    });
    _scrollToBottom();
  }

  void _showPaywall() {
    setState(() {
      _messages.add(const _AiMessage.ai(
        'وصلت للحد المجاني هذا الشهر. اشترك للمتابعة بأسئلة غير محدودة.',
        null,
      ));
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final quotaLabel = _subscribed
        ? 'اشتراك نشط · أسئلة غير محدودة'
        : 'لديك ${_freeLimit - _freeQuestionsUsed} أسئلة مجانية هذا الشهر';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: ScreenHeader(
                title: 'المساعد الذكي',
                subtitle: quotaLabel,
                trailing: GestureDetector(
                  onTap: () async {
                    final subscribed = await Navigator.pushNamed(context, Routes.aiPlan);
                    if (subscribed == true) setState(() => _subscribed = true);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.themeColor,
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Text('اشترك',
                        style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _messages.isEmpty
                  ? _EmptyState(onPick: _ask)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == _messages.length) {
                          return const ChatBubble.ai('يكتب…');
                        }
                        final m = _messages[i];
                        return m.isUser
                            ? ChatBubble.user(m.text)
                            : ChatBubble.ai(m.text, warning: m.warning);
                      },
                    ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: AppColors.cardColor.themeColor,
                  border: Border.all(color: AppColors.dividerColor.themeColor),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _ask,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'اسأل عن نتائجك أو تقاريرك…',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _ask(_controller.text),
                      child: Container(
                        width: 36.r,
                        height: 36.r,
                        margin: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.themeColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onPick});
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 66.r,
                height: 66.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.primaryLightColor.themeColor,
                    AppColors.primaryDarkColor.themeColor,
                  ]),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
              ),
              14.height,
              AppText('المساعد الذكي',
                  isHeading: true,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor),
              6.height,
              AppText('اسألني عن نتائجك وتقاريرك وأدويتك — أشرحها بلغة بسيطة',
                  fontSize: 11.5,
                  textAlign: TextAlign.center,
                  color: AppColors.mutedColor.themeColor),
            ],
          ),
        ),
        22.height,
        Text('اقتراحات للبدء',
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor)),
        10.height,
        for (final s in AiAnswers.suggestions)
          AppCard(
            margin: EdgeInsets.only(bottom: 8.h),
            onTap: () => onPick(s),
            child: AppText(s, fontSize: 12, color: AppColors.textPrimaryColor.themeColor),
          ),
      ],
    );
  }
}
