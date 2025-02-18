import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:front_end/resources/auth_methods.dart';
import 'package:front_end/resources/firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  final JitsiMeet _jitsiMeet = JitsiMeet();

  /// Fetch stored authentication token
  Future<String?> _getToken() async {
    return await _authMethods.getToken();
  }

  /// Create and join a Jitsi meeting
  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      // Fetch user role (optional, remove if not needed)
      String? userRole = await _authMethods.getUserRole();
      print("User Role: $userRole");

      // Get authentication token
      String? token = await _getToken();

      // Default username if not provided
      String name = username.isNotEmpty ? username : "Guest User";

      // Jitsi Meet Conference Options
      var options = JitsiMeetConferenceOptions(
        room: roomName,
        userInfo: JitsiMeetUserInfo(
          displayName: name,
          email: "guest@example.com", // No Firebase, use a default or remove
          avatar: null, // No Firebase photoURL
        ),
        featureFlags: {
          "welcomepage.enabled": false,
          "resolution": 360,
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
        },
        token: token, // Pass authentication token
      );

      // Save meeting to history
      _firestoreMethods.addToMeetingHistory(roomName);

      // Join the meeting
      await _jitsiMeet.join(options);
    } catch (error) {
      print("Jitsi Meeting Error: $error");
    }
  }
}
