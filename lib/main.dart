import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const CopyDemoScreen(),
    );
  }
}

class CopyDemoScreen extends StatelessWidget {
  const CopyDemoScreen({super.key});

  // Hàm xử lý việc copy lập trình qua nút bấm
  void _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    // Kiểm tra xem Widget còn gắn trên cây không trước khi hiện SnackBar
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép: "$text"'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Text Copy Demo'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // 💡 KÍCH HOẠT: Bọc toàn bộ Body bằng SelectionArea để kích hoạt bôi đen copy toàn màn hình
      body: SelectionArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cách 1: Chọn và sao chép tự do (UI-Driven)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nhờ có SelectionArea bọc ở ngoài, bạn có thể nhấn giữ (hoặc kéo chuột) '
                'để bôi đen đoạn văn bản này. Hãy thử bôi đen từ dòng này sang dòng tiếp theo bên dưới xem sao!',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Thậm chí chữ nằm bên trong một Container đã được trang trí '
                  'vẫn có thể bôi đen và copy như thường, không cần SelectableText nữa.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Divider(),
              ),

              const Text(
                'Cách 2: Nút bấm sao chép nhanh (Programmatic)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Thường dùng cho mã giảm giá, link chia sẻ hoặc mã định danh.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),

              // Widget hiển thị mã giảm giá kèm nút copy công nghiệp
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MÃ GIẢM GIÁ',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            'FLUTTER2026',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      // Nút bấm kích hoạt Clipboard API
                      IconButton.filledTonal(
                        onPressed: () =>
                            _copyToClipboard(context, 'FLUTTER2026'),
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy mã',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
