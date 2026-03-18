import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  late AnimationController _scanningController;
  bool _isFlashOn = false;
  bool _isScanned = false;

  @override
  void initState() {
    super.initState();
    _scanningController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    _scanningController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          _isScanned = true;
        });
        debugPrint('Barcode found! ${barcode.rawValue}');
        context.pushReplacement(AppRouter.verification, extra: barcode.rawValue);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                const Spacer(),
                _buildScannerFrame(context),
                const Spacer(),
                _buildBottomControls(context),
                const Gap(40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(PhosphorIconsRegular.x, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.black38),
          ),
          const Text(
            'Scan QR Code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              controller.toggleTorch();
              setState(() => _isFlashOn = !_isFlashOn);
            },
            icon: Icon(
              _isFlashOn ? PhosphorIconsFill.flashlight : PhosphorIconsRegular.flashlight,
              color: Colors.white,
            ),
            style: IconButton.styleFrom(backgroundColor: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerFrame(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.7;
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              ..._buildCorners(size),
              AnimatedBuilder(
                animation: _scanningController,
                builder: (context, child) {
                  return Positioned(
                    top: _scanningController.value * size,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0),
                            AppColors.primary,
                            AppColors.primary.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const Gap(32),
        const Text(
          'Align the QR code within the frame',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  List<Widget> _buildCorners(double size) {
    const cornerSize = 40.0;
    const thickness = 4.0;
    return [
      Positioned(
        top: 0, left: 0,
        child: Container(width: cornerSize, height: thickness, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
      ),
      Positioned(
        top: 0, left: 0,
        child: Container(width: thickness, height: cornerSize, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
      ),
      Positioned(
        top: 0, right: 0,
        child: Container(width: cornerSize, height: thickness, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
      ),
      Positioned(
        top: 0, right: 0,
        child: Container(width: thickness, height: cornerSize, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
      ),
      Positioned(
        bottom: 0, left: 0,
        child: Container(width: cornerSize, height: thickness, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
      ),
      Positioned(
        bottom: 0, left: 0,
        child: Container(width: thickness, height: cornerSize, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
      ),
      Positioned(
        bottom: 0, right: 0,
        child: Container(width: cornerSize, height: thickness, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
      ),
      Positioned(
        bottom: 0, right: 0,
        child: Container(width: thickness, height: cornerSize, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
      ),
    ];
  }

  Widget _buildBottomControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            context,
            icon: PhosphorIconsRegular.image,
            label: 'Gallery',
            onTap: () {},
          ),
          const Gap(48),
          _buildActionButton(
            context,
            icon: PhosphorIconsRegular.arrowsClockwise,
            label: 'Flip',
            onTap: () => controller.switchCamera(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const Gap(8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
