import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// // lib/pages/messages/messages.dart
//
// import 'package:app/common_widgets/chat_widget.dart';
// import 'package:app/providers/provider_root/chat_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class MessagesPage extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<MessagesPage> createState() => _MessagesPageState();
// }
//
// class _MessagesPageState extends ConsumerState<MessagesPage> {
//   @override
//   void initState() {
//     super.initState();
//     print('🔥 MessagesPage: initState called');
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       print('🔥 MessagesPage: Initializing chat provider');
//       ref.read(chatProvider.notifier).initialize();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final chatState = ref.watch(chatProvider);
//
//     print('🔥 MessagesPage: Building with state:');
//     print('  - authenticated: ${chatState.isAuthenticated}');
//     print('  - loading: ${chatState.isLoading}');
//     print('  - chatRooms: ${chatState.chatRooms.length}');
//     print('  - error: ${chatState.error}');
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Suhbatlar',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.green,
//         elevation: 2,
//         actions: [
//           if (chatState.isAuthenticated) ...[
//             IconButton(
//               icon: const Icon(Icons.add, color: Colors.white),
//               onPressed: () => _showCreateChatDialog(),
//             ),
//             PopupMenuButton<String>(
//               icon: const Icon(Icons.more_vert, color: Colors.white),
//               onSelected: (value) {
//                 switch (value) {
//                   case 'refresh':
//                     ref.read(chatProvider.notifier).loadChatRooms();
//                     break;
//                   case 'logout':
//                     _showLogoutDialog();
//                     break;
//                 }
//               },
//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: 'refresh',
//                   child: ListTile(
//                     leading: Icon(Icons.refresh),
//                     title: Text('Yangilash'),
//                     contentPadding: EdgeInsets.zero,
//                   ),
//                 ),
//                 const PopupMenuItem(
//                   value: 'logout',
//                   child: ListTile(
//                     leading: Icon(Icons.logout),
//                     title: Text('Chiqish'),
//                     contentPadding: EdgeInsets.zero,
//                   ),
//                 ),
//               ],
//             ),
//           ] else ...[
//             IconButton(
//               icon: const Icon(Icons.login, color: Colors.white),
//               onPressed: () => _showLoginDialog(),
//             ),
//           ],
//         ],
//       ),
//       body: _buildBody(chatState),
//     );
//   }
//
//   Widget _buildBody(ChatState chatState) {
//     // Show error if exists
//     if (chatState.error != null) {
//       return EmptyStateWidget(
//         title: 'Xatolik yuz berdi',
//         subtitle: chatState.error!,
//         icon: Icons.error_outline,
//         actionText: 'Qayta urinish',
//         onAction: () {
//           if (chatState.isAuthenticated) {
//             ref.read(chatProvider.notifier).loadChatRooms();
//           } else {
//             ref.read(chatProvider.notifier).initialize();
//           }
//         },
//       );
//     }
//
//     // Not authenticated
//     if (!chatState.isAuthenticated) {
//       return EmptyStateWidget(
//         title: 'Tizimga kiring',
//         subtitle: 'Suhbatlarga kirish uchun hisobingizga kiring',
//         icon: Icons.login,
//         actionText: 'Kirish',
//         onAction: () => _showLoginDialog(),
//       );
//     }
//
//     // Loading
//     if (chatState.isLoading) {
//       return const LoadingWidget(message: 'Suhbatlar yuklanmoqda...');
//     }
//
//     // Empty chat rooms
//     if (chatState.chatRooms.isEmpty) {
//       return EmptyStateWidget(
//         title: 'Hali suhbatlar yo\'q',
//         subtitle: 'Yangi suhbat yaratish uchun + tugmasini bosing',
//         icon: Icons.chat_bubble_outline,
//         actionText: 'Yangi suhbat',
//         onAction: () => _showCreateChatDialog(),
//       );
//     }
//
//     // Chat rooms list
//     return RefreshIndicator(
//       onRefresh: () => ref.read(chatProvider.notifier).loadChatRooms(),
//       child: ListView.builder(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         itemCount: chatState.chatRooms.length,
//         itemBuilder: (context, index) {
//           final chatRoom = chatState.chatRooms[index];
//           return ChatListItem(chatRoom: chatRoom);
//         },
//       ),
//     );
//   }
//
//   void _showCreateChatDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => RiverpodCreateChatDialog(),
//     );
//   }
//
//   void _showLoginDialog() {
//     final usernameController = TextEditingController();
//     final passwordController = TextEditingController();
//     bool isLoading = false;
//
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Tizimga kirish'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: usernameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Foydalanuvchi nomi yoki email',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 enabled: !isLoading,
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Parol',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.lock),
//                 ),
//                 obscureText: true,
//                 enabled: !isLoading,
//                 onSubmitted: (_) => _performLogin(
//                   setState,
//                   usernameController.text,
//                   passwordController.text,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: isLoading ? null : () => Navigator.pop(context),
//               child: const Text('Bekor qilish'),
//             ),
//             ElevatedButton(
//               onPressed: isLoading
//                   ? null
//                   : () => _performLogin(
//                         setState,
//                         usernameController.text,
//                         passwordController.text,
//                       ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//               ),
//               child: isLoading
//                   ? const SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                   : const Text('Kirish'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _performLogin(
//     StateSetter setState,
//     String username,
//     String password,
//   ) async {
//     if (username.trim().isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Iltimos, barcha maydonlarni to\'ldiring')),
//       );
//       return;
//     }
//
//     // setState(() => isLoading = true);
//
//     try {
//       final success = await ref.read(chatProvider.notifier).login(
//             username.trim(),
//             password,
//           );
//
//       Navigator.pop(context);
//
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Muvaffaqiyatli tizimga kirdingiz'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Login yoki parol noto\'g\'ri'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Xatolik: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Chiqish'),
//         content: const Text('Haqiqatan ham tizimdan chiqmoqchimisiz?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Bekor qilish'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await ref.read(chatProvider.notifier).logout();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Tizimdan muvaffaqiyatli chiqdingiz'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Chiqish'),
//           ),
//         ],
//       ),
//     );
//   }
// }
