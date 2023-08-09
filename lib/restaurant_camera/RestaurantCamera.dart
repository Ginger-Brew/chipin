import 'package:flutter/material.dart';

class RestaurantCamera extends StatefulWidget {
  const RestaurantCamera({Key? key}) : super(key: key);

  @override
  State<RestaurantCamera> createState() => _RestaurantCameraState();
}

class _RestaurantCameraState extends State<RestaurantCamera>
{
  bool _cameraInitialized = false;
  CameraController _cameraController;

  @override
  void initState()
  {
    // 화면에 처음 진입할 때 카메라 사용을 준비 하도록 합니다.
    super.initState();
    readyToCamera();
  }

  @override
  void dispose()
  {
    // 화면에서 벗어날 때 카메라 제어기를 위해 OS에게 할당 받은 리소스를 정리 합니다.
    if( _cameraController != null )
    {
      _cameraController.dispose();
    }
    super.dispose();
  }

  void readyToCamera() async
  {
    // 사용할 수 있는 카메라 목록을 OS로부터 받아 옵니다.
    final cameras = await availableCameras();
    if( 0 == cameras.length )
    {
      print( "not found any cameras" );
      return;
    }

    CameraDescription frontCamera;
    for( var camera in cameras )
    {
      // 저 같은 경우에는 전면 카메라를 사용해야 했기 때문에
      // 아래와 같이 코딩하여 카메라를 찾았습니다.
      if( camera.lensDirection == CameraLensDirection.front )
      {
        frontCamera = camera;
        break;
      }
    }

    _cameraController =
        CameraController(
            frontCamera,
            ResolutionPreset.max // 가장 높은 해상도의 기능을 쓸 수 있도록 합니다.
        );
    _cameraController.initialize()
        .then(
            ( value )
        {
          // 카메라 준비가 끝나면 카메라 미리보기를 보여주기 위해 앱 화면을 다시 그립니다.
          setState( ()=>_cameraInitialized = true );
        } );
  }
}

