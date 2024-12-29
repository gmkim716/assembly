import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocationScreen extends StatelessWidget {
  // 지도 초기화 위치 등록
  static const LatLng companyLatLng = LatLng(37.5233273, 126.932353);
  static const Marker marker =
      Marker(markerId: MarkerId('company'), position: companyLatLng);

  static Circle circle = Circle(
      circleId: const CircleId('위치정보'),
      center: companyLatLng,
      fillColor: Colors.blue.withOpacity(0.5),
      radius: 100, // 반지름 (미터 단위)
      strokeWidth: 1, // 원의 테두리 두께
      strokeColor: Colors.blue); // 원의 테두리 색

  const GeoLocationScreen({super.key}); // 생성자

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          // 로딩 상태
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 권한 허가된 상태
          if (snapshot.data == '위치 권한이 허가되었습니다') {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: companyLatLng,
                      zoom: 16,
                    ),
                    myLocationEnabled: true, // 내 위치 지도에 보여주기
                    myLocationButtonEnabled: true, // 내 위치로 이동하는 버튼 추가
                    zoomControlsEnabled: false, // 기본 줌 컨트롤 숨기기
                    markers: {marker},
                    circles: {circle},
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timelapse_outlined,
                          color: Colors.blue, size: 50.0),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          print('[출근하기] 버튼 클릭!');
                          final curPosition =
                              await Geolocator.getCurrentPosition(); // 현재 위치

                          final distance = Geolocator.distanceBetween(
                            curPosition.latitude,
                            curPosition.longitude,
                            companyLatLng.latitude,
                            companyLatLng.longitude,
                          );
                          bool canCheck =
                              distance < 100; // 100미터 이내에 있으면 출근이 가능

                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("출근하기"),
                                  content: Text(
                                    canCheck
                                        ? '출근을 하시겠습니까?'
                                        : '출근할 수 없는 위치입니다.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('취소'),
                                    ),
                                    if (canCheck)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('출근하기'),
                                      ),
                                  ],
                                );
                              });
                        },
                        child: const Text('출근하기!'),
                      )
                    ],
                  ),
                )
              ],
            );
          }

          // 권한 없는 상태
          return Center(child: Text(snapshot.data ?? '위치 권한이 없습니다.'));
        },
      ),
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        '지도 위치 찾기',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    // 위치 서비스 활성화 여부 확인
    if (!isLocationEnabled) {
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    // 위치 권한 확인
    if (checkedPermission == LocationPermission.denied) {
      // 위치 권한 요청 하기
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요';
      }
    }

    // 위치 권한 거절됨 (앱에서 재요청 불가)
    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정해서 허가해주세요';
    }

    // 위 조건이 모두 통과되면 위치 권한 허가 완료
    return '위치 권한이 허가되었습니다';
  }
}
