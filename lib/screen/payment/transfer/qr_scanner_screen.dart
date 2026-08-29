// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paynow/screen/payment/transfer/contact_transfer_screen.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/utils/responsive_helper.dart';
import 'package:paynow/widget/custom_text.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _hasNavigated = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onQrDetected(String rawValue) {
    if (_hasNavigated) return;
    setState(() {
      _hasNavigated = true;
    });

    String name = 'Scanned Merchant';
    String detail = rawValue;
    if (rawValue.startsWith('upi://')) {
      try {
        final uri = Uri.parse(rawValue);
        final pa = uri.queryParameters['pa'];
        final pn = uri.queryParameters['pn'];
        if (pa != null) {
          detail = pa;
          name = pn ?? pa.split('@')[0];
        }
      } catch (_) {}
    } else if (rawValue.contains('@')) {
      detail = rawValue;
      name = rawValue.split('@')[0];
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ContactTransferScreen(
          contactName: name,
          contactDetail: detail,
        ),
      ),
    );
  }

  void _showManualUpiDialog() {
    final TextEditingController upiController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            padding: EdgeInsets.all(Responsive.w(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText.header('Enter UPI ID / Number', fontSize: 18),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(16)),
                TextField(
                  controller: upiController,
                  decoration: InputDecoration(
                    hintText: 'e.g. merchant@upi or 9876543210',
                    hintStyle: const TextStyle(color: AppColors.grayFont, fontSize: 13),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : AppColors.lightGray,
                    contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(14)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(24)),
                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(52),
                  child: ElevatedButton(
                    onPressed: () {
                      final upi = upiController.text.trim();
                      if (upi.isEmpty) return;
                      Navigator.pop(sheetContext);
                      _onQrDetected(upi);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: CustomText.title(
                      'Verify & Pay',
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Real Camera Preview using MobileScanner
          Positioned.fill(
            child: MobileScanner(
              controller: _scannerController,
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? rawValue = barcodes.first.rawValue;
                  if (rawValue != null && rawValue.isNotEmpty) {
                    _onQrDetected(rawValue);
                  }
                }
              },
            ),
          ),

          // Scanner Overlay with viewfinder
          SafeArea(
            child: Column(
              children: [
                // Top Action Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(16.0), vertical: Responsive.h(12.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(Responsive.w(8.0)),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      CustomText.header(
                        'Scan & Pay',
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                      ValueListenableBuilder<MobileScannerState>(
                        valueListenable: _scannerController,
                        builder: (context, state, child) {
                          final isFlashOn = state.torchState == TorchState.on;
                          return GestureDetector(
                            onTap: () => _scannerController.toggleTorch(),
                            child: Container(
                              padding: EdgeInsets.all(Responsive.w(8.0)),
                              decoration: BoxDecoration(
                                color: isFlashOn ? AppColors.white : Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFlashOn ? Icons.flash_on : Icons.flash_off,
                                color: isFlashOn ? AppColors.black : AppColors.white,
                                size: 22,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Center Scanning Square
                Center(
                  child: Container(
                    width: Responsive.w(260),
                    height: Responsive.h(260),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: Stack(
                      children: [
                        // Viewfinder Corner Brackets
                        CustomPaint(
                          size: Size(Responsive.w(260), Responsive.h(260)),
                          painter: ScannerOverlayPainter(),
                        ),
                        // Pulsing Laser Line
                        Center(
                          child: Container(
                            width: Responsive.w(240),
                            height: Responsive.h(2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGradientStart,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryGradientStart.withValues(alpha: 0.8),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Responsive.h(24)),
                CustomText.body(
                  'Align QR code inside the frame to scan',
                  color: Colors.white70,
                  fontSize: 13,
                ),

                const Spacer(),

                // Bottom Action buttons (Gallery + Enter UPI Manually)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24.0), vertical: Responsive.h(20.0)),
                  child: Row(
                    children: [
                      // Upload from Gallery
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Simulate QR selection
                            _onQrDetected('upi://pay?pa=merchant@paynow&pn=Retail%20Merchant');
                          },
                          child: Container(
                            height: Responsive.h(50),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.image_outlined, color: AppColors.white, size: 20),
                                SizedBox(width: Responsive.w(8)),
                                CustomText.title('Upload QR', color: AppColors.white, fontSize: 13),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Responsive.w(12)),
                      // Enter UPI ID Manually
                      Expanded(
                        child: GestureDetector(
                          onTap: _showManualUpiDialog,
                          child: Container(
                            height: Responsive.h(50),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.edit_outlined, color: AppColors.white, size: 20),
                                SizedBox(width: Responsive.w(8)),
                                CustomText.title('Enter UPI ID', color: AppColors.white, fontSize: 13),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.h(80)), // Padding for bottom bar
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGradientStart
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 32.0;

    // Top-Left
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Top-Right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom-Left
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Bottom-Right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
