class AiChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AiChatMessage> messages;

  const AiChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  AiChatSession copyWith({
    String? title,
    DateTime? updatedAt,
    List<AiChatMessage>? messages,
  }) {
    return AiChatSession(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }

  factory AiChatSession.fromJson(Map<String, dynamic> json) {
    return AiChatSession(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      messages: ((json['messages'] as List?) ?? [])
          .map((e) => AiChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AiChatMessage {
  final String text;
  final bool isAi;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String? actionLabel;
  final String? actionType;
  final String? orderId;

  const AiChatMessage({
    required this.text,
    required this.isAi,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.actionLabel,
    this.actionType,
    this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isAi': isAi,
      'isLoading': isLoading,
      'isSuccess': isSuccess,
      'isError': isError,
      'actionLabel': actionLabel,
      'actionType': actionType,
      'orderId': orderId,
    };
  }

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      text: json['text'] as String,
      isAi: json['isAi'] as bool,
      isLoading: json['isLoading'] as bool? ?? false,
      isSuccess: json['isSuccess'] as bool? ?? false,
      isError: json['isError'] as bool? ?? false,
      actionLabel: json['actionLabel'] as String?,
      actionType: json['actionType'] as String?,
      orderId: json['orderId'] as String?,
    );
  }
}