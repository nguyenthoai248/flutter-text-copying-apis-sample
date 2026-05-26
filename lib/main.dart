import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Data Table',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const AdvanceTableScreen(),
    );
  }
}

// Configure horizontal scrolling by allowing click-and-drag with the mouse
class MouseDraggableScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class AdvanceTableScreen extends StatefulWidget {
  const AdvanceTableScreen({super.key});

  @override
  State<AdvanceTableScreen> createState() => _AdvanceTableScreenState();
}

class _AdvanceTableScreenState extends State<AdvanceTableScreen> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double tableWidth = 1300.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics Table (Selection Area)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade100,
      ),
      // Wrap everything in SelectionArea to manage global text selection
      body: SelectionArea(
        child: ScrollConfiguration(
          behavior: MouseDraggableScrollBehavior(),
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Column(
                children: [
                  _buildTableHeader(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 50,
                      itemBuilder: (context, index) {
                        return ExpandableRowWidget(index: index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        child: const Row(
          children: [
            SizedBox(width: 80, child: Text('ID')),
            SizedBox(width: 250, child: Text('Company Name')),
            SizedBox(width: 180, child: Text('Revenue (USD)')),
            SizedBox(width: 150, child: Text('Growth')),
            SizedBox(width: 300, child: Text('Report Document (Link)')),
            Expanded(child: Text('System Notes')),
          ],
        ),
      ),
    );
  }
}

class ExpandableRowWidget extends StatefulWidget {
  final int index;

  const ExpandableRowWidget({super.key, required this.index});

  @override
  State<ExpandableRowWidget> createState() => _ExpandableRowWidgetState();
}

class _ExpandableRowWidgetState extends State<ExpandableRowWidget> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          // Tap row to expand
          onTap: _toggleExpand,
          child: Container(
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.teal.shade50.withOpacity(0.3) : null,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 0.8),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                // Use standard Text widgets because SelectionArea handles text selection
                SizedBox(width: 80, child: Text('#${1000 + widget.index}')),
                SizedBox(
                  width: 250,
                  child: Text('VinTech Technology Group ${widget.index + 1}'),
                ),
                SizedBox(
                  width: 180,
                  child: Text('\$${(widget.index + 1) * 14500}'),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    '+${(widget.index * 1.5).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Text.rich(
                    TextSpan(
                      text: 'Download file bieu_mau_bc_${widget.index}.pdf',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _openLinkSimulation(context, widget.index);
                        },
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'System data is automatically synchronized from the APAC main server.',
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expanded detail area
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.teal.shade200, width: 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ADDITIONAL CATEGORY DETAILS - ITEM NUMBER ${widget.index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columnWidths: const {
                          0: FixedColumnWidth(150),
                          1: FixedColumnWidth(200),
                          2: FixedColumnWidth(250),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                            ),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Warehouse Code',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Location',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Verification Status',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text('WH-NINHBINH-${widget.index}'),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Area A, Floor 3'),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Approved Successfully ✓',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _openLinkSimulation(BuildContext context, int index) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔗 Opening report document page #$index...'),
        backgroundColor: Colors.teal.shade700,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
