class Conversation {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final String avatarInitials;
  const Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    required this.avatarInitials,
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

final mockConversations = <Conversation>[
  const Conversation(
    id: '1',
    name: 'Ahmed Ben Ali',
    lastMessage: 'Est-ce que la villa est toujours disponible ?',
    time: '10:45',
    unread: 2,
    avatarInitials: 'AB',
  ),
  const Conversation(
    id: '2',
    name: 'Sami Trabelsi',
    lastMessage: 'Je peux visiter demain à 15h ?',
    time: '09:12',
    unread: 1,
    avatarInitials: 'ST',
  ),
  const Conversation(
    id: '3',
    name: 'Leila Mansour',
    lastMessage: 'Merci pour les photos !',
    time: 'Hier',
    avatarInitials: 'LM',
  ),
  const Conversation(
    id: '4',
    name: 'Karim Jebali',
    lastMessage: 'Le prix est-il négociable ?',
    time: 'Hier',
    avatarInitials: 'KJ',
  ),
];

final mockMessages = <ChatMessage>[
  const ChatMessage(
      text: 'Bonjour ! Je suis intéressé par votre villa à La Marsa.',
      isMe: false,
      time: '10:30'),
  const ChatMessage(
      text: 'Bonjour Ahmed, oui elle est toujours disponible 👍',
      isMe: true,
      time: '10:32'),
  const ChatMessage(text: 'Quel est le prix final ?', isMe: false, time: '10:40'),
  const ChatMessage(
      text: '485 000 DT, légèrement négociable.', isMe: true, time: '10:42'),
  const ChatMessage(
      text: 'Est-ce que la villa est toujours disponible ?',
      isMe: false,
      time: '10:45'),
];