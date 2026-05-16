import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:erp_sales/core/widgets/ai_chat_memory.dart';
import 'package:erp_sales/features/ai_assistant/data/models/ai_chat_session.dart';
import 'package:erp_sales/features/ai_assistant/logic/cubit/ai_assistant_cubit.dart';
import 'package:erp_sales/features/ai_assistant/logic/cubit/ai_assistant_state.dart';
import 'package:erp_sales/features/ai_assistant/presentation/widgets/ai_draft_preview_card.dart';
import 'package:erp_sales/features/ai_assistant/presentation/widgets/ai_input_bar.dart';
import 'package:erp_sales/features/ai_assistant/presentation/widgets/ai_message_bubble.dart';
import 'package:erp_sales/features/ai_assistant/presentation/widgets/ai_quick_commands_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final SpeechToText speech = SpeechToText();
  bool showScrollToBottom = false;

  bool isListening = false;
  bool isSpeechReady = false;

  List<AiChatMessage> get messages => AiChatMemory.messages;
  List<String> get suggestions => AiChatMemory.suggestions;

  set suggestions(List<String> value) {
    AiChatMemory.suggestions = value;
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadChatMemory();

    scrollController.addListener(() {
      final isFarFromBottom =
          scrollController.offset <
          scrollController.position.maxScrollExtent - 400;

      if (isFarFromBottom != showScrollToBottom) {
        setState(() {
          showScrollToBottom = isFarFromBottom;
        });
      }
    });
  }

  Future<void> _loadChatMemory() async {
    await AiChatMemory.load();
    controller.text = AiChatMemory.lastInput;

    if (!mounted) return;

    setState(() {});

    _jumpToBottom();
  }

  Future<void> _initSpeech() async {
    isSpeechReady = await speech.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AiChatMemory.lastInput = controller.text;
    controller.dispose();
    scrollController.dispose();
    speech.stop();
    super.dispose();
  }

  Future<void> _toggleVoice() async {
    if (!isSpeechReady) {
      AppToast.error('Voice is unavailable');
      return;
    }

    if (isListening) {
      await speech.stop();
      setState(() => isListening = false);
      return;
    }

    setState(() => isListening = true);

    await speech.listen(
      onResult: (result) {
        controller.text = result.recognizedWords;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
    );
  }

  void _send() {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      suggestions = [];
      AiChatMemory.suggestions = [];

      AiChatMemory.addMessage(AiChatMessage(text: text, isAi: false));

      AiChatMemory.lastInput = '';
    });

    AiChatMemory.save();

    controller.clear();

    context.read<AiAssistantCubit>().sendMessage(text);

    _scrollToBottom();
  }

  void _showChatHistory() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                children: [
                  const Text(
                    'Chat History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  ...AiChatMemory.sessions.map((session) {
                    final selected = session.id == AiChatMemory.activeSessionId;

                    return ListTile(
                      selected: selected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      leading: const Icon(Icons.chat_bubble_outline_rounded),
                      title: Text(
                        session.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        session.messages.isEmpty
                            ? 'No messages'
                            : session.messages.last.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () async {
                          setSheetState(() {
                            AiChatMemory.deleteSession(session.id);
                          });
                          setState(() {});
                          await AiChatMemory.save();
                        },
                      ),
                      onTap: () async {
                        setState(() {
                          AiChatMemory.switchSession(session.id);
                          suggestions = [];
                          controller.clear();
                        });
                        await AiChatMemory.save();
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });

      Future.delayed(const Duration(milliseconds: 900), () {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    });
  }

  void _useSuggestion(String value) {
    controller.text = value;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  void _animateToBottom() {
    if (!scrollController.hasClients) return;

    void scroll() {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }

    scroll();

    Future.delayed(const Duration(milliseconds: 300), scroll);
    Future.delayed(const Duration(milliseconds: 700), scroll);
    Future.delayed(const Duration(milliseconds: 1100), scroll);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF060816)
          : const Color(0xFFF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          AiChatMemory.activeSession.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: _showChatHistory,
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_rounded),
            onPressed: () async {
              setState(() {
                AiChatMemory.createNewSession();
                suggestions = [];
                controller.clear();
              });
              await AiChatMemory.save();
            },
          ),
        ],
      ),
      body: BlocConsumer<AiAssistantCubit, AiAssistantState>(
        listener: (context, state) {
          if (state is AiAssistantLoading) {
            AiChatMemory.addMessage(
              const AiChatMessage(text: 'Thinking...', isAi: true),
            );
            AiChatMemory.save();
            setState(() {});
            _scrollToBottom();
          }

          if (state is AiAssistantSuccess) {
            AiChatMemory.removeLoadingMessages();
            AiChatMemory.addMessage(
              AiChatMessage(
                text: state.message,
                isAi: true,
                isSuccess: true,
                actionLabel: state.actionLabel,
                actionType: state.actionType,
                orderId: state.orderId,
              ),
            );
            AiChatMemory.save();
            AppToast.success(state.message);
            setState(() {});
            _scrollToBottom();
          }

          if (state is AiAssistantDraftReady) {
            AiChatMemory.removeLoadingMessages();
            AiChatMemory.addMessage(
              const AiChatMessage(
                text: 'Draft is ready. Please review and confirm.',
                isAi: true,
                isSuccess: true,
              ),
            );
            AiChatMemory.save();
            setState(() {});
            _scrollToBottom();
          }

          if (state is AiAssistantChatReply) {
            AiChatMemory.removeLoadingMessages();
            suggestions = [];
            AiChatMemory.suggestions = [];
            AiChatMemory.addMessage(
              AiChatMessage(text: state.message, isAi: true),
            );
            AiChatMemory.save();
            setState(() {});
            _scrollToBottom();
          }

          if (state is AiAssistantFailure) {
            AiChatMemory.removeLoadingMessages();

            AiChatMemory.addMessage(
              AiChatMessage(
                text: state.error,
                isAi: true,
                isError: true,
                actionLabel: state.actionLabel,
                actionType: state.actionType,
                orderId: state.orderId,
              ),
            );

            suggestions = state.suggestions;

            if (state.showToast) {
              AppToast.error(state.error);
            }

            AiChatMemory.save();

            setState(() {});
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return AiMessageBubble(
                          message: message,
                        ).animate().fadeIn(duration: 250.ms).slideY(begin: .08);
                      },
                    ),
                  ),

                  if (suggestions.isNotEmpty)
                    Container(
                      height: 44,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final item = suggestions[index];
                          return ActionChip(
                            label: Text(item),
                            avatar: const Icon(Icons.auto_awesome, size: 16),
                            onPressed: () => _useSuggestion(item),
                          );
                        },
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemCount: suggestions.length,
                      ),
                    ),

                  if (state is AiAssistantDraftReady)
                    AiDraftPreviewCard(
                      draft: state.draft,
                      onConfirm: () {
                        context
                            .read<AiAssistantCubit>()
                            .confirmCreateSalesOrder(state.draft);
                      },
                    ),

                  AiQuickCommandsBar(
                    commands: AiChatMemory.quickCommands,
                    onTap: (command) {
                      controller.text = command;
                      controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  AiInputBar(
                    controller: controller,
                    isListening: isListening,
                    onMicTap: _toggleVoice,
                    onSendTap: _send,
                  ),
                ],
              ),
              if (showScrollToBottom)
                Positioned(
                  right: 10,
                  bottom: 170,
                  child: GestureDetector(
                    onTap: _animateToBottom,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .18),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.keyboard_double_arrow_down_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
