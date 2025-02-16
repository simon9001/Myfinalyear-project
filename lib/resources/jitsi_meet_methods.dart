import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:front_end/resources/auth_methods.dart';
import 'package:front_end/resources/firestore_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  final JitsiMeet _jitsiMeet = JitsiMeet();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      String name = username.isNotEmpty
          ? username
          : _authMethods.user?.displayName ?? 'Guest';

      String? token = await _getToken();

      var options = JitsiMeetConferenceOptions(
        room: roomName,
        userInfo: JitsiMeetUserInfo(
          displayName: name,
          email: _authMethods.user?.email,
          avatar: _authMethods.user?.photoURL,
        ),
        featureFlags: {
          "welcomepage.enabled": false,
          "resolution": 360,
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
        },
        token: token, // Pass authentication token
      );

      _firestoreMethods.addToMeetingHistory(roomName);

      await _jitsiMeet.join(options);
    } catch (error) {
      print("Error: $error");
    }
  }
}
