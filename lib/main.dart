import 'package:flutter/material.dart';

void main() {
  runApp(const ComplexCopyApp());
}

class ComplexCopyApp extends StatelessWidget {
  const ComplexCopyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const ComplexArticleScreen(),
    );
  }
}

class ComplexArticleScreen extends StatelessWidget {
  const ComplexArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xử Lý Copy Giao Diện Phức Tạp'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // AppBar không bọc SelectionArea nên tiêu đề không thể bị bôi đen lỗi
      ),
      // Bọc SelectionArea xung quanh toàn bộ phần thân, NHƯNG sẽ khoá (disable) ở những chỗ cần thiết
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. Vùng Nội Dung (ĐƯỢC bôi đen)
            const Text(
              'Hướng dẫn tối ưu SelectionArea trong Flutter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 2. Vùng Tương Tác: KHÔNG ĐƯỢC bôi đen để tránh lỗi khi click
            SelectionContainer.disabled(
              child: Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tác giả: Dev Flutter',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Đăng 2 giờ trước',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Theo dõi'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Nội dung bài viết (ĐƯỢC bôi đen)
            const Text(
              'Đây là nội dung chính của bài viết. Ở đây bạn có thể thoải mái bôi đen để copy. '
              'Tuy nhiên, khi kéo chuột xuống phần Danh mục hoặc Nút bấm, công cụ bôi đen sẽ tự động '
              'bỏ qua chúng vì chúng ta đã dùng SelectionContainer.disabled.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // 3. Vùng Cuộn Ngang (Horizontal Scroll): KHÔNG ĐƯỢC bôi đen
            // Nếu không disable, khi người dùng vuốt ngang qua Text, nó sẽ nhầm thành kéo bôi đen chữ
            const Text(
              'Danh mục liên quan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectionContainer.disabled(
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        label: Text('Tag ${index + 1}'),
                        onPressed: () {},
                      ),
                    );
                  },
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(),
            ),

            // 4. Danh Sách Bình Luận Động (ListView.builder)
            const Text(
              'Bình luận (Có thể bôi đen nội dung):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ShrinkWrap dùng cho demo để nhúng ListView vào trong ListView cha
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildCommentItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị từng bình luận
  Widget _buildCommentItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar (Không thể bôi đen)
          SelectionContainer.disabled(
            child: CircleAvatar(
              backgroundColor: Colors.teal.shade100,
              child: Text('${index + 1}'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên người dùng và nút thao tác (Không thể bôi đen)
                SelectionContainer.disabled(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User_00${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, size: 20),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // Nội dung bình luận (ĐƯỢC PHÉP bôi đen)
                // Nằm trong SelectionArea tổng nên vẫn copy được bình thường!
                Text(
                  'Đây là nội dung bình luận số ${index + 1}. Bạn có thể bôi đen phần này để trích dẫn lại nếu muốn. Mã lỗi: ERR_${index}99X',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
