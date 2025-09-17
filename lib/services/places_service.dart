import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

class PlacesService {
  static final String _apiKey = dotenv.env['CLOUD_CONSOLE_API'] ?? '';
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  /// Get nearby hospitals and clinics within specified radius
  static Future<List<Map<String, dynamic>>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    int radius = 5000, // 5km in meters
  }) async {
    try {
      final String url = '$_baseUrl/nearbysearch/json'
          '?location=$latitude,$longitude'
          '&radius=$radius'
          '&type=hospital'
          '&key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          List<Map<String, dynamic>> hospitals = [];
          
          for (var place in data['results']) {
            hospitals.add({
              'name': place['name'] ?? 'Unknown Hospital',
              'address': place['vicinity'] ?? 'Address not available',
              'rating': place['rating']?.toDouble() ?? 0.0,
              'latitude': place['geometry']['location']['lat'],
              'longitude': place['geometry']['location']['lng'],
              'placeId': place['place_id'],
              'isOpen': place['opening_hours']?['open_now'] ?? false,
              'types': place['types'] ?? [],
              'photoReference': place['photos']?[0]?['photo_reference'],
            });
          }
          
          // Also search for clinics
          final clinicsUrl = '$_baseUrl/nearbysearch/json'
              '?location=$latitude,$longitude'
              '&radius=$radius'
              '&keyword=clinic'
              '&key=$_apiKey';
          
          final clinicsResponse = await http.get(Uri.parse(clinicsUrl));
          
          if (clinicsResponse.statusCode == 200) {
            final clinicsData = json.decode(clinicsResponse.body);
            
            if (clinicsData['status'] == 'OK') {
              for (var place in clinicsData['results']) {
                hospitals.add({
                  'name': place['name'] ?? 'Unknown Clinic',
                  'address': place['vicinity'] ?? 'Address not available',
                  'rating': place['rating']?.toDouble() ?? 0.0,
                  'latitude': place['geometry']['location']['lat'],
                  'longitude': place['geometry']['location']['lng'],
                  'placeId': place['place_id'],
                  'isOpen': place['opening_hours']?['open_now'] ?? false,
                  'types': place['types'] ?? [],
                  'photoReference': place['photos']?[0]?['photo_reference'],
                });
              }
            }
          }
          
          // Sort by rating (highest first)
          hospitals.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
          
          return hospitals;
        } else {
          throw Exception('Places API error: ${data['status']}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nearby hospitals: $e');
    }
  }

  /// Get current user location
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  /// Get place details including phone number and website
  static Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    try {
      final String url = '$_baseUrl/details/json'
          '?place_id=$placeId'
          '&fields=name,formatted_phone_number,website,opening_hours,rating,reviews'
          '&key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          return data['result'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Calculate distance between two points
  static double calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Get photo URL from photo reference
  static String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photo_reference=$photoReference'
        '&key=$_apiKey';
  }
}
