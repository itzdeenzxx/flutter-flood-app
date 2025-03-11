import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  
  factory LocationService() {
    return _instance;
  }
  
  LocationService._internal();
  
  // แคชข้อมูลตำแหน่งล่าสุด
  Position? _lastKnownPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  final _locationUpdateController = StreamController<Position>.broadcast();
  
  Stream<Position> get locationUpdateStream => _locationUpdateController.stream;
  
  // ขอสิทธิ์การเข้าถึงตำแหน่ง
  Future<bool> requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    // ตรวจสอบว่าบริการระบุตำแหน่งเปิดใช้งานอยู่หรือไม่
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    
    // ตรวจสอบสิทธิ์การเข้าถึง
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }
  
  // รับตำแหน่งปัจจุบัน
  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        return null;
      }
      
      _lastKnownPosition = await Geolocator.getCurrentPosition();
      return _lastKnownPosition;
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }
  
  // เริ่มการติดตามตำแหน่ง
  Future<void> startLocationTracking() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      return;
    }
    
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // ระยะทางในหน่วยเมตรที่ต้องเปลี่ยนแปลงก่อนรับอัพเดต
      ),
    ).listen((Position position) {
      _lastKnownPosition = position;
      _locationUpdateController.add(position);
    });
  }
  
  // หยุดการติดตามตำแหน่ง
  void stopLocationTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }
  
  // รับตำแหน่งล่าสุดที่รู้จาก cache
  Position? getLastKnownLocation() {
    return _lastKnownPosition;
  }
  
  // คำนวณระยะทางระหว่างจุดสองจุด (เมตร)
  double calculateDistance(
    double startLatitude, 
    double startLongitude, 
    double endLatitude, 
    double endLongitude
  ) {
    return Geolocator.distanceBetween(
      startLatitude, 
      startLongitude, 
      endLatitude, 
      endLongitude
    );
  }
  
  // ดิสโพส
  void dispose() {
    stopLocationTracking();
    _locationUpdateController.close();
  }
}