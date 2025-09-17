import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/places_service.dart';
import '../theme/app_theme.dart';

class NearbyHospitalsPage extends StatefulWidget {
  const NearbyHospitalsPage({super.key});

  @override
  State<NearbyHospitalsPage> createState() => _NearbyHospitalsPageState();
}

class _NearbyHospitalsPageState extends State<NearbyHospitalsPage> {
  Position? _currentPosition;
  List<Map<String, dynamic>> _hospitals = [];
  Set<Marker> _markers = {};
  bool _isLoading = true;
  String? _errorMessage;
  bool _showList = false;

  @override
  void initState() {
    super.initState();
    _loadNearbyHospitals();
  }

  Future<void> _loadNearbyHospitals() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Get current location
      _currentPosition = await PlacesService.getCurrentLocation();

      // Get nearby hospitals
      _hospitals = await PlacesService.getNearbyHospitals(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        radius: 5000, // 5km
      );

      // Create markers
      _createMarkers();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      String errorMessage = 'Error loading nearby hospitals';
      
      if (e.toString().contains('Location services are disabled')) {
        errorMessage = 'Please enable location services to find nearby hospitals';
      } else if (e.toString().contains('Location permissions are denied')) {
        errorMessage = 'Please grant location permission to find nearby hospitals';
      } else if (e.toString().contains('API key')) {
        errorMessage = 'Maps service is currently unavailable. Please try again later.';
      } else if (e.toString().contains('Network')) {
        errorMessage = 'No internet connection. Please check your network and try again.';
      }
      
      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });
    }
  }

  void _createMarkers() {
    _markers.clear();

    // Add current location marker
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current position',
          ),
        ),
      );
    }

    // Add hospital markers
    for (int i = 0; i < _hospitals.length; i++) {
      final hospital = _hospitals[i];
      _markers.add(
        Marker(
          markerId: MarkerId('hospital_$i'),
          position: LatLng(hospital['latitude'], hospital['longitude']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: hospital['name'],
            snippet: '${hospital['rating']} ⭐ • ${hospital['address']}',
          ),
          onTap: () => _showHospitalDetails(hospital),
        ),
      );
    }
  }

  void _showHospitalDetails(Map<String, dynamic> hospital) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildHospitalDetailsSheet(hospital),
    );
  }

  Widget _buildHospitalDetailsSheet(Map<String, dynamic> hospital) {
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
            decoration: BoxDecoration(
              color: AppTheme.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hospital name and rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hospital['name'],
                          style: AppTheme.headingMedium,
                        ),
                      ),
                      if (hospital['rating'] > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingS,
                            vertical: AppTheme.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor,
                            borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                hospital['rating'].toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.textSecondary),
                      const SizedBox(width: AppTheme.spacingS),
                      Expanded(
                        child: Text(
                          hospital['address'],
                          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Distance
                  if (_currentPosition != null)
                    Row(
                      children: [
                        const Icon(Icons.directions, color: AppTheme.textSecondary),
                        const SizedBox(width: AppTheme.spacingS),
                        Text(
                          '${(PlacesService.calculateDistance(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                            hospital['latitude'],
                            hospital['longitude'],
                          ) / 1000).toStringAsFixed(1)} km away',
                          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Open status
                  Row(
                    children: [
                      Icon(
                        hospital['isOpen'] ? Icons.access_time : Icons.access_time_filled,
                        color: hospital['isOpen'] ? AppTheme.successColor : AppTheme.errorColor,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        hospital['isOpen'] ? 'Open now' : 'Closed',
                        style: AppTheme.bodyMedium.copyWith(
                          color: hospital['isOpen'] ? AppTheme.successColor : AppTheme.errorColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openDirections(hospital),
                          icon: const Icon(Icons.directions),
                          label: const Text('Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: AppTheme.textOnPrimary,
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _callHospital(hospital),
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: const BorderSide(color: AppTheme.primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDirections(Map<String, dynamic> hospital) async {
    final url = 'https://www.google.com/maps/dir/?api=1'
        '&destination=${hospital['latitude']},${hospital['longitude']}'
        '&travelmode=driving';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callHospital(Map<String, dynamic> hospital) async {
    // Try to get detailed info with phone number
    final details = await PlacesService.getPlaceDetails(hospital['placeId']);
    
    if (details != null && details['formatted_phone_number'] != null) {
      final phoneUrl = 'tel:${details['formatted_phone_number']}';
      if (await canLaunchUrl(Uri.parse(phoneUrl))) {
        await launchUrl(Uri.parse(phoneUrl));
      }
    } else {
      // Show message that phone number is not available
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number not available for this hospital'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      }
    }
  }

  Future<void> _openGoogleMapsSearch() async {
    const url = 'https://www.google.com/maps/search/hospitals+near+me';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Google Maps'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Nearby Hospitals',
          style: AppTheme.headingSmall.copyWith(color: AppTheme.textOnPrimary),
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: AppTheme.textOnPrimary),
        elevation: AppTheme.elevationS,
        actions: [
          IconButton(
            icon: Icon(_showList ? Icons.map : Icons.list),
            onPressed: () {
              setState(() {
                _showList = !_showList;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNearbyHospitals,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.primaryColor),
                  SizedBox(height: AppTheme.spacingM),
                  Text('Finding nearby hospitals...'),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      Text(
                        'Error loading hospitals',
                        style: AppTheme.headingSmall,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      ElevatedButton(
                        onPressed: _loadNearbyHospitals,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: AppTheme.textOnPrimary,
                        ),
                        child: const Text('Retry'),
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      OutlinedButton(
                        onPressed: () {
                          // Fallback: Open Google Maps with hospital search
                          _openGoogleMapsSearch();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: const BorderSide(color: AppTheme.primaryColor),
                        ),
                        child: const Text('Open Google Maps'),
                      ),
                    ],
                  ),
                )
              : _showList
                  ? _buildHospitalsList()
                  : _buildMap(),
    );
  }

  Widget _buildMap() {
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        // Map controller can be used for programmatic map control if needed
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 13.0,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: true,
    );
  }

  Widget _buildHospitalsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: _hospitals.length,
      itemBuilder: (context, index) {
        final hospital = _hospitals[index];
        final distance = _currentPosition != null
            ? PlacesService.calculateDistance(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                hospital['latitude'],
                hospital['longitude'],
              ) / 1000
            : 0.0;

        return Card(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
          elevation: AppTheme.elevationS,
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppTheme.spacingM),
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(
                Icons.local_hospital,
                color: AppTheme.textOnPrimary,
              ),
            ),
            title: Text(
              hospital['name'],
              style: AppTheme.headingSmall,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingXS),
                Text(hospital['address']),
                const SizedBox(height: AppTheme.spacingXS),
                Row(
                  children: [
                    if (hospital['rating'] > 0) ...[
                      const Icon(Icons.star, size: 16, color: AppTheme.warningColor),
                      const SizedBox(width: 4),
                      Text('${hospital['rating']}'),
                      const SizedBox(width: AppTheme.spacingS),
                    ],
                    Text('${distance.toStringAsFixed(1)} km'),
                    const SizedBox(width: AppTheme.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingXS,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: hospital['isOpen'] ? AppTheme.successColor : AppTheme.errorColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Text(
                        hospital['isOpen'] ? 'Open' : 'Closed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showHospitalDetails(hospital),
          ),
        );
      },
    );
  }
}
