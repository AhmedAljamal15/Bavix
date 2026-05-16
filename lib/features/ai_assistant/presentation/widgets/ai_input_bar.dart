import 'package:erp_sales/core/widgets/ai_chat_memory.dart';
import 'package:flutter/material.dart';

class AiInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isListening;
  final VoidCallback onMicTap;
  final VoidCallback onSendTap;

  const AiInputBar({
    super.key,
    required this.controller,
    required this.isListening,
    required this.onMicTap,
    required this.onSendTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121826) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onMicTap,
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isListening
                      ? const Color(0xFFE74C3C)
                      : const Color(0xFF6366F1),
                ),
                child: Icon(
                  isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: TextField(
                controller: controller,
                onChanged: (value) {
                  AiChatMemory.lastInput = value;
                },
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled: false,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Type ERP command...',
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onSendTap,
              child: Container(
                height: 42,
                width: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                  ),
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
