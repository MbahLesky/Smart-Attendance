import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Mock Camera Preview
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: const Center(
              child: Icon(
                PhosphorIconsRegular.camera,
                color: Colors.white24,
                size: 80,
              ),
            ),
          ),
          
          // Scanner Overlay
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
            onPressed: () => setState(() => _isFlashOn = !_isFlashOn),
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
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            // Corners
            _buildCorners(size),
            // Scanning Animation Line (Mock)
            _ScanningLine(width: size),
          ],
        ),
        const Gap(32),
        const Text(
          'Align the QR code within the frame',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCorners(double size) {
    const cornerSize = 40.0;
    const thickness = 4.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Top Left
          Positioned(
            top: 0, left: 0,
            child: Container(width: cornerSize, height: thickness, color: AppColors.primary),
          ),
          Positioned(
            top: 0, left: 0,
            child: Container(width: thickness, height: cornerSize, color: AppColors.primary),
          ),
          // Top Right
          Positioned(
            top: 0, right: 0,
            child: Container(width: cornerSize, height: thickness, color: AppColors.primary),
          ),
          Positioned(
            top: 0, right: 0,
            child: Container(width: thickness, height: cornerSize, color: AppColors.primary),
          ),
          // Bottom Left
          Positioned(
            bottom: 0, left: 0,
            child: Container(width: cornerSize, height: thickness, color: AppColors.primary),
          ),
          Positioned(
            bottom: 0, left: 0,
            child: Container(width: thickness, height: cornerSize, color: AppColors.primary),
          ),
          // Bottom Right
          Positioned(
            bottom: 0, right: 0,
            child: Container(width: cornerSize, height: thickness, color: AppColors.primary),
          ),
          Positioned(
            bottom: 0, right: 0,
            child: Container(width: thickness, height: cornerSize, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            icon: PhosphorIconsRegular.image,
            label: 'Gallery',
            onTap: () {},
          ),
          const Gap(24),
          _buildActionButton(
            context,
            icon: PhosphorIconsRegular.keyboard,
            label: 'Code',
            onTap: () {
              // Simulate finding a code
              context.push(AppRouter.result, extra: true);
            },
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

class _ScanningLine extends StatefulWidget {
  final double width;
  const _ScanningLine({required this.width});

  @override
  State<_ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<_ScanningLine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: _controller.value * widget.width,
          child: Container(
            width: widget.width,
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
    );
  }
}
