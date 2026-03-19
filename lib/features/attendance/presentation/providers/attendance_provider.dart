import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceState {
  final bool isVerifying;
  final bool isGeoVerified;
  final bool isWifiVerified;
  final String? errorMessage;

  AttendanceState({
    this.isVerifying = false,
    this.isGeoVerified = false,
    this.isWifiVerified = false,
    this.errorMessage,
  });

  AttendanceState copyWith({
    bool? isVerifying,
    bool? isGeoVerified,
    bool? isWifiVerified,
    String? errorMessage,
  }) {
    return AttendanceState(
      isVerifying: isVerifying ?? this.isVerifying,
      isGeoVerified: isGeoVerified ?? this.isGeoVerified,
      isWifiVerified: isWifiVerified ?? this.isWifiVerified,
      errorMessage: errorMessage,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier() : super(AttendanceState());

  Future<void> verifyAttendance(String qrData) async {
    state = state.copyWith(isVerifying: true);
    
    // Simulate API call and verification process
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate successful geolocation verification
    state = state.copyWith(isGeoVerified: true);
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simulate successful Wi-Fi verification
    state = state.copyWith(isWifiVerified: true);
    await Future.delayed(const Duration(milliseconds: 500));
    
    state = state.copyWith(isVerifying: false);
  }

  void reset() {
    state = AttendanceState();
  }
}

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  return AttendanceNotifier();
});
