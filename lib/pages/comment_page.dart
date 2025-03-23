import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../services/comment_service.dart';

class CommentPage extends StatefulWidget {
  final String questionId;
  final String questionText;
  final String currentUsername; // Add this parameter

  const CommentPage({
    Key? key,
    required this.questionId,
    required this.questionText,
    required this.currentUsername, // Add this parameter
  }) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final CommentService _commentService = CommentService();
  
  List<Comment> _comments = [];
  bool _isLoading = true;
  String? _error;

  String? _replyingTo;
  String? _replyingToMessage;
  
  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final comments = await _commentService.getCommentsByQuestionId(widget.questionId);
      
      // Mark comments from the current user
      final List<Comment> updatedComments = comments.map((comment) {
        if (comment.sender == widget.currentUsername) { // Use currentUsername instead of hardcoded 'reza'
          return Comment(
            id: comment.id,
            questionId: comment.questionId,
            sender: comment.sender,
            message: comment.message,
            time: comment.time,
            isSentByMe: true,
            avatar: comment.avatar,
            replyTo: comment.replyTo,
          );
        }
        return comment;
      }).toList();
      
      setState(() {
        _comments = updatedComments;
        _isLoading = false;
      });
      
      // Scroll to bottom after loading comments
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final now = DateTime.now();
    final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      questionId: widget.questionId,
      sender: widget.currentUsername, // Use currentUsername instead of hardcoded 'reza'
      message: _messageController.text,
      time: time,
      isSentByMe: true,
      avatar: 'assets/images/avatar4.jpg', // You might want to make this dynamic based on user
      replyTo: _replyingTo != null ? Reply(
        sender: _replyingTo!,
        message: _replyingToMessage!,
      ) : null,
    );

    try {
      setState(() {
        _comments.add(newComment);
        _messageController.clear();
        _replyingTo = null;
        _replyingToMessage = null;
      });

      // Scroll to bottom after sending message
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      // Save to server
      await _commentService.addComment(newComment);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ارسال پیام: ${e.toString()}')),
      );
    }
  }

  void _setReplyTo(String sender, String message) {
    setState(() {
      _replyingTo = sender;
      _replyingToMessage = message;
      _focusNode.requestFocus();
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
      _replyingToMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.questionText.length > 40 
              ? widget.questionText.substring(0, 40) + '...' 
              : widget.questionText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          textAlign: TextAlign.right,
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                ? Center(child: Text('خطا: $_error'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return _buildMessageBubble(comment, index);
                    },
                  ),
          ),
          
          // Reply indicator
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'در پاسخ به $_replyingTo',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        Text(
                          _replyingToMessage!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: _cancelReply,
                  ),
                ],
              ),
            ),
          
          // Message input field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.grey),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      hintText: 'پیام خود را بنویسید...',
                      hintTextDirection: TextDirection.rtl,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Comment comment, int index) {
    final bool isSentByMe = comment.isSentByMe;
    
    return GestureDetector(
      onLongPress: () {
        if (comment.replyTo == null) {
          _setReplyTo(comment.sender, comment.message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          // Always align to the end (right in RTL)
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                // Always align to the end (right in RTL)
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Sender name
                  Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 4),
                    child: Text(
                      comment.sender,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSentByMe ? Colors.grey[700] : Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  
                  // Message container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSentByMe ? const Color(0xFFE8F5E9) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Reply reference
                        if (comment.replyTo != null)
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey[400]!,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  comment.replyTo!.sender,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  comment.replyTo!.message,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                        
                        // Message text
                        Text(
                          comment.message,
                          style: const TextStyle(fontSize: 14),
                          textDirection: TextDirection.rtl,
                        ),
                        
                        // Time and Reply button row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Reply icon button
                            InkWell(
                              onTap: () {
                                _setReplyTo(comment.sender, comment.message);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.reply,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            // Time
                            Text(
                              comment.time,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Show avatar for all users on the right
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(comment.avatar),
            ),
          ],
        ),
      ),
    );
  }
}