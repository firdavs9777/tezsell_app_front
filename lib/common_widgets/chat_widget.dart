// // lib/common_widgets/chat_widget.dart
//
// import 'package:app/pages/messages/messages.dart';
// import 'package:app/providers/provider_models/message_model.dart';
// import 'package:app/providers/provider_root/chat_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// // Loading Widget
// class LoadingWidget extends StatelessWidget {
//   final String? message;
//
//   const LoadingWidget({Key? key, this.message}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//           ),
//           if (message != null) ...[
//             const SizedBox(height: 16),
//             Text(
//               message!,
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// // Empty State Widget
// class EmptyStateWidget extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final VoidCallback? onAction;
//   final String? actionText;
//
//   const EmptyStateWidget({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     this.onAction,
//     this.actionText,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 64,
//               color: Colors.grey.shade400,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             if (onAction != null && actionText != null) ...[
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: onAction,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: Text(actionText!),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Chat List Item Widget
// class ChatListItem extends StatelessWidget {
//   final ChatRoom chatRoom;
//
//   const ChatListItem({Key? key, required this.chatRoom}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       elevation: 2,
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.green,
//           child: Text(
//             chatRoom.name[0].toUpperCase(),
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         title: Text(
//           chatRoom.name,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Text(
//           chatRoom.lastMessagePreview ?? 'Hali xabarlar yo\'q',
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 14,
//           ),
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (chatRoom.lastMessageTimestamp != null)
//               Text(
//                 _formatTime(chatRoom.lastMessageTimestamp!),
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//               ),
//             if (chatRoom.unreadCount > 0) ...[
//               const SizedBox(height: 4),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   chatRoom.unreadCount.toString(),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ChatRoomScreen(chatRoom: chatRoom),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   String _formatTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
//
//     if (difference.inDays > 0) {
//       return '${difference.inDays}d';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m';
//     } else {
//       return 'hozir';
//     }
//   }
// }
//
// // Chat Room Screen
// class ChatRoomScreen extends ConsumerStatefulWidget {
//   final ChatRoom chatRoom;
//
//   const ChatRoomScreen({Key? key, required this.chatRoom}) : super(key: key);
//
//   @override
//   ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
// }
//
// class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _messageController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(chatProvider.notifier).connectToChatRoom(widget.chatRoom.id);
//     });
//   }
//
//   @override
//   void dispose() {
//     ref.read(chatProvider.notifier).disconnectFromChatRoom();
//     _scrollController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }
//
//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final chatState = ref.watch(chatProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.chatRoom.name,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//             ),
//             Text(
//               '${widget.chatRoom.participants.length} ishtirokchi',
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         elevation: 2,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: chatState.isLoadingMessages
//                 ? const LoadingWidget(message: 'Xabarlar yuklanmoqda...')
//                 : chatState.messages.isEmpty
//                     ? const EmptyStateWidget(
//                         title: 'Hali xabarlar yo\'q',
//                         subtitle: 'Birinchi xabaringizni yuboring',
//                         icon: Icons.message,
//                       )
//                     : ListView.builder(
//                         controller: _scrollController,
//                         padding: const EdgeInsets.all(8),
//                         itemCount: chatState.messages.length,
//                         itemBuilder: (context, index) {
//                           final message = chatState.messages[index];
//
//                           // Auto-scroll when new messages arrive
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             _scrollToBottom();
//                           });
//
//                           return MessageBubble(
//                             message: message,
//                             currentUserId: chatState.currentUserId ?? 0,
//                           );
//                         },
//                       ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 4,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Xabar yozing...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//               ),
//               maxLines: null,
//               onSubmitted: (_) => _sendMessage(),
//             ),
//           ),
//           const SizedBox(width: 8),
//           FloatingActionButton(
//             mini: true,
//             backgroundColor: Colors.green,
//             onPressed: _sendMessage,
//             child: const Icon(Icons.send, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _sendMessage() {
//     if (_messageController.text.trim().isNotEmpty) {
//       ref
//           .read(chatProvider.notifier)
//           .sendMessage(_messageController.text.trim());
//       _messageController.clear();
//       _scrollToBottom();
//     }
//   }
// }
//
// // Message Bubble Widget
// class MessageBubble extends StatelessWidget {
//   final ChatMessage message;
//   final int currentUserId;
//
//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.currentUserId,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isOwn = message.isOwnMessage(currentUserId);
//
//     return Align(
//       alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: isOwn ? Colors.green : Colors.grey[300],
//           borderRadius: BorderRadius.circular(12),
//         ),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.7,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (!isOwn) ...[
//               Text(
//                 message.sender.displayName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                   color: Colors.black54,
//                 ),
//               ),
//               const SizedBox(height: 2),
//             ],
//             Text(
//               message.content,
//               style: TextStyle(
//                 color: isOwn ? Colors.white : Colors.black,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   _formatTime(message.timestamp),
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: isOwn ? Colors.white70 : Colors.grey[600],
//                   ),
//                 ),
//                 if (isOwn) ...[
//                   const SizedBox(width: 4),
//                   Icon(
//                     message.readBy.length > 1 ? Icons.done_all : Icons.done,
//                     size: 12,
//                     color: message.readBy.length > 1
//                         ? Colors.blue
//                         : Colors.white70,
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatTime(DateTime dateTime) {
//     return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//   }
// }
//
// // Create Chat Dialog
// class RiverpodCreateChatDialog extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<RiverpodCreateChatDialog> createState() =>
//       _RiverpodCreateChatDialogState();
// }
//
// class _RiverpodCreateChatDialogState
//     extends ConsumerState<RiverpodCreateChatDialog> {
//   final TextEditingController _nameController = TextEditingController();
//   List<int> _selectedParticipants = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(chatProvider.notifier).loadUsers();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final chatState = ref.watch(chatProvider);
//
//     return AlertDialog(
//       title: const Text('Yangi suhbat yaratish'),
//       content: SizedBox(
//         width: double.maxFinite,
//         height: 400,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Suhbat nomi',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Ishtirokchilar:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: chatState.users.isEmpty
//                   ? const Center(child: Text('Foydalanuvchilar yuklanmoqda...'))
//                   : ListView.builder(
//                       itemCount: chatState.users.length,
//                       itemBuilder: (context, index) {
//                         final user = chatState.users[index];
//                         if (user.id == chatState.currentUserId)
//                           return const SizedBox();
//
//                         final isSelected =
//                             _selectedParticipants.contains(user.id);
//
//                         return CheckboxListTile(
//                           title: Text(user.displayName),
//                           subtitle: Text('@${user.username}'),
//                           value: isSelected,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               if (value == true) {
//                                 _selectedParticipants.add(user.id);
//                               } else {
//                                 _selectedParticipants.remove(user.id);
//                               }
//                             });
//                           },
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: _isLoading ? null : () => Navigator.pop(context),
//           child: const Text('Bekor qilish'),
//         ),
//         ElevatedButton(
//           onPressed: _isLoading ? null : _createChat,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             foregroundColor: Colors.white,
//           ),
//           child: _isLoading
//               ? const SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : const Text('Yaratish'),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _createChat() async {
//     if (_nameController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Suhbat nomini kiriting')),
//       );
//       return;
//     }
//
//     if (_selectedParticipants.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Kamida bitta ishtirokchi tanlang')),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       final success = await ref.read(chatProvider.notifier).createChatRoom(
//             _nameController.text.trim(),
//             _selectedParticipants,
//           );
//
//       if (success) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Suhbat muvaffaqiyatli yaratildi')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Suhbat yaratishda xatolik yuz berdi')),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
// }
