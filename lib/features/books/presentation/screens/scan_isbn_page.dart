import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/utils/isbn.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Opens the scanner and returns the ISBN-13 it read, or null if cancelled.
/// A provider so tests can swap in a fake scan (there's no camera there).
typedef IsbnScanLauncher = Future<String?> Function(BuildContext context);

final isbnScannerProvider = Provider<IsbnScanLauncher>(
  (ref) =>
      (context) => Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (_) => const ScanIsbnPage(),
          fullscreenDialog: true,
        ),
      ),
);

class ScanIsbnPage extends StatefulWidget {
  const ScanIsbnPage({super.key});

  @override
  State<ScanIsbnPage> createState() => _ScanIsbnPageState();
}

class _ScanIsbnPageState extends State<ScanIsbnPage> {
  // Book ISBNs are printed as EAN-13 barcodes.
  final _controller = MobileScannerController(formats: [BarcodeFormat.ean13]);
  bool _done = false;
  String? _hint;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    for (final barcode in capture.barcodes) {
      final isbn = toIsbn13(barcode.rawValue);
      if (isbn != null) {
        _done = true;
        Navigator.of(context).pop(isbn);
        return;
      }
    }
    if (_hint == null && capture.barcodes.isNotEmpty) {
      setState(
        () => _hint =
            "That doesn't look like a book's ISBN barcode. Try the one on "
            'the back cover.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: const Text('Scan barcode'),
      titleTextStyle: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(color: Colors.white),
      actions: [
        ValueListenableBuilder<MobileScannerState>(
          valueListenable: _controller,
          builder: (context, state, _) =>
              state.torchState == TorchState.unavailable
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Toggle flashlight',
                  icon: Icon(
                    state.torchState == TorchState.on
                        ? Icons.flashlight_on
                        : Icons.flashlight_off,
                  ),
                  onPressed: _controller.toggleTorch,
                ),
        ),
      ],
    ),
    body: Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
          errorBuilder: (context, error) => _CameraProblem(error: error),
        ),
        const Center(child: _Viewfinder()),
        Positioned(
          left: 24,
          right: 24,
          bottom: 40,
          child: SafeArea(
            child: Semantics(
              liveRegion: true,
              child: Text(
                _hint ??
                    'Point the camera at the barcode on the back of the book.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _Viewfinder extends StatelessWidget {
  const _Viewfinder();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: 280,
      height: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

class _CameraProblem extends StatelessWidget {
  const _CameraProblem({required this.error});
  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final denied = error.errorCode == MobileScannerErrorCode.permissionDenied;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              size: 56,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              denied
                  ? 'BookSwap needs camera access to scan barcodes. Allow it '
                        "in your phone's settings for BookSwap, then try again."
                  : "The camera isn't available right now. You can type the "
                        'ISBN instead.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Go back',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
