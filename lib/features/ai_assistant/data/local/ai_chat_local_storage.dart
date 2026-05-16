import 'dart:convert';

import 'package:erp_sales/features/ai_assistant/data/models/ai_chat_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiChatLocalStorage {
  static const _sessionsKey = 'ai_chat_sessions';
  static const _activeSessionKey = 'ai_active_chat_session';

  Future<List<AiChatSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionsKey);

    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List;

    return decoded
        .map((e) => AiChatSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveSessions(List<AiChatSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(sessions.map((e) => e.toJson()).toList());
    await prefs.setString(_sessionsKey, encoded);
  }

  Future<String?> getActiveSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeSessionKey);
  }

  Future<void> saveActiveSessionId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeSessionKey, id);
  }
}