import 'package:flutter/material.dart';
import 'package:front_end/resources/auth_methods.dart';
import 'package:front_end/resources/jitsi_meet_methods.dart';
import 'package:front_end/utils/colors.dart';
import 'package:front_end/widgets/meeting_option.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AuthMethods _authMethods = AuthMethods();
  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();

  late TextEditingController meetingIdController;
  late TextEditingController nameController;

  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    meetingIdController = TextEditingController();
    _initializeUsername();
  }

  /// Initialize name field with stored user role or default "Guest"
  void _initializeUsername() async {
    String? storedName = await _authMethods.getUserRole(); // Example usage
    nameController = TextEditingController(text: storedName ?? "Guest");
    setState(() {}); // Refresh UI after fetching name
  }

  @override
  void dispose() {
    meetingIdController.dispose();
    nameController.dispose();
    super.dispose();
  }

  /// Fetch authentication token
  Future<String?> _getToken() async {
    return await _authMethods.getToken();
  }

  /// Join a meeting
  _joinMeeting() async {
    String roomName = meetingIdController.text.trim();
    String username = nameController.text.trim();

    if (roomName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room ID cannot be empty")),
      );
      return;
    }

    if (username.isEmpty) {
      username = "Guest"; // Default name if empty
    }

    await _getToken(); // Ensure token is fetched

    _jitsiMeetMethods.createMeeting(
      roomName: roomName,
      isAudioMuted: isAudioMuted,
      isVideoMuted: isVideoMuted,
      username: username,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text(
          'Join a Meeting',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: TextField(
              controller: meetingIdController,
              maxLines: 1,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                fillColor: secondaryBackgroundColor,
                filled: true,
                border: InputBorder.none,
                hintText: 'Room ID',
                contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: TextField(
              controller: nameController,
              maxLines: 1,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                fillColor: secondaryBackgroundColor,
                filled: true,
                border: InputBorder.none,
                hintText: 'Name',
                contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: _joinMeeting,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Join',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          MeetingOption(
            text: 'Mute Audio',
            isMute: isAudioMuted,
            onChange: onAudioMuted,
          ),
          MeetingOption(
            text: 'Turn Off My Video',
            isMute: isVideoMuted,
            onChange: onVideoMuted,
          ),
        ],
      ),
    );
  }

  void onAudioMuted(bool val) {
    setState(() {
      isAudioMuted = val;
    });
  }

  void onVideoMuted(bool val) {
    setState(() {
      isVideoMuted = val;
    });
  }
}
