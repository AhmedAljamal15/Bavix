import 'package:erp_sales/features/ai_assistant/data/local/ai_chat_local_storage.dart';
import 'package:erp_sales/features/ai_assistant/data/models/ai_chat_session.dart';

class AiChatMemory {
  static final AiChatLocalStorage storage = AiChatLocalStorage();

  static List<AiChatSession> sessions = [];
  static String? activeSessionId;

  static final List<String> quickCommands = [
    'Create sales order for customer aa item gg qty 2 rate 500',
    'Search item gg',
    'Find customer aa',
    'Show latest sales orders',
    'Create invoice for sales order SAL-ORD-2026-00001',
  ];

  static String lastInput = '';
  static List<String> suggestions = [];

  static AiChatSession get activeSession {
    if (sessions.isEmpty) {
      createNewSession();
    }

    return sessions.firstWhere(
      (e) => e.id == activeSessionId,
      orElse: () => sessions.first,
    );
  }

  static List<AiChatMessage> get messages => activeSession.messages;

  static Future<void> load() async {
    sessions = await storage.getSessions();
    activeSessionId = await storage.getActiveSessionId();

    if (sessions.isEmpty) {
      createNewSession();
      await save();
    }

    activeSessionId ??= sessions.first.id;
  }

  static AiChatSession createNewSession() {
    final now = DateTime.now();

    final session = AiChatSession(
      id: now.microsecondsSinceEpoch.toString(),
      title: 'New Chat',
      createdAt: now,
      updatedAt: now,
      messages:  [
        AiChatMessage(
          text:
              'Welcome to Bavix AI 🚀\nI can help you create ERP commands using text or voice.',
          isAi: true,
        ),
      ],
    );

    sessions.insert(0, session);
    activeSessionId = session.id;

    return session;
  }

  static void switchSession(String id) {
    activeSessionId = id;
  }

  static void deleteSession(String id) {
    sessions.removeWhere((e) => e.id == id);

    if (sessions.isEmpty) {
      createNewSession();
    } else {
      activeSessionId = sessions.first.id;
    }
  }

  static void addMessage(AiChatMessage message) {
    final session = activeSession;
    final updatedMessages = [...session.messages, message];

    final newTitle = session.title == 'New Chat' && !message.isAi
        ? _generateTitle(message.text)
        : session.title;

    final updatedSession = session.copyWith(
      title: newTitle,
      updatedAt: DateTime.now(),
      messages: updatedMessages,
    );

    final index = sessions.indexWhere((e) => e.id == session.id);
    sessions[index] = updatedSession;
  }

  static void removeLoadingMessages() {
    final session = activeSession;
    final updatedMessages = session.messages
        .where((e) => e.text != 'Thinking...')
        .toList();

    final updatedSession = session.copyWith(messages: updatedMessages);

    final index = sessions.indexWhere((e) => e.id == session.id);
    sessions[index] = updatedSession;
  }

  static Future<void> save() async {
    await storage.saveSessions(sessions);
    if (activeSessionId != null) {
      await storage.saveActiveSessionId(activeSessionId!);
    }
  }

  static String _generateTitle(String text) {
    final clean = text.trim();
    if (clean.length <= 28) return clean;
    return '${clean.substring(0, 28)}...';
  }
}