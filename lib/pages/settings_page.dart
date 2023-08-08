import 'package:chat_app/services/network_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/user.dart' as app_user;
import '../notifiers/settings_notifier.dart';
import 'share_profile.dart';

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getIt = GetIt.instance;

    final TextEditingController controller = TextEditingController();
    // final TextEditingController controller = ref.watch(settingsNotifierProvider.select((settings) => settings.controller));

    final isEdit = ref.watch(settingsNotifierProvider.select((settings) => settings.isEdit));
    final isAvatar = ref.watch(settingsNotifierProvider.select((settings) => settings.isAvatar));
    final avatarURL = ref.watch(settingsNotifierProvider.select((settings) => settings.avatarURL));
    final displayName = ref.watch(settingsNotifierProvider.select((settings) => settings.displayName));
    final position = ref.watch(settingsNotifierProvider.select((settings) => settings.position));
    final id = ref.watch(settingsNotifierProvider.select((settings) => settings.id));

    void edit() {
      ref.read(settingsNotifierProvider.notifier).setIsEdit(true);
    }

    void done() async {
      print(controller.text);
      ref.read(settingsNotifierProvider.notifier).setIsEdit(false);
      ref.read(settingsNotifierProvider.notifier).setDisplayName(controller.text);

      print(ref.read(settingsNotifierProvider).displayName);

      await getIt<NetworkUserService>().updateUserDisplayName(controller.text);
    }

    void loadUser() {
      app_user.User user = getIt<NetworkUserService>().getCurrentUser();

      if (user.photoUrl != null) {
        ref.read(settingsNotifierProvider.notifier).setIsAvatar(true);
        ref.read(settingsNotifierProvider.notifier).setAvatarURL(user.photoUrl);
      }

      // print(user.displayName);

      ref.read(settingsNotifierProvider.notifier).setDisplayName(user.displayName);
      ref.read(settingsNotifierProvider.notifier).setId(user.id);
      controller.text = user.displayName.toString();
    }

    void pickImage() async {
      final ImagePicker picker = ImagePicker();
      // Pick an image.
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        return;
      }

      await getIt<NetworkUserService>().updateUserPhotoUrl(image.path, image.name);

      loadUser();
    }

    void determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      final position = await Geolocator.getCurrentPosition();
      // ref.read(settingsProvider.notifier).update(newPosition: position);
    }

    void shareProfile() async {
      // Navigator.pushNamed(
      //   context,
      //   ShareProfile.routeName,
      //   arguments: ShareArguments(id),
      // );
    }

    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, '/sign-in');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUser();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          isEdit
              ? TextButton(onPressed: done, child: const Text('Done'))
              : TextButton(onPressed: edit, child: const Text('Edit')),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 32.0,
                backgroundImage: (isAvatar && avatarURL != null)
                    ? NetworkImage(avatarURL) as ImageProvider<Object>
                    : const AssetImage('assets/images/avatar.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            isEdit
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: TextField(
                controller: controller,
                style: const TextStyle(fontSize: 16.0),
              ),
            )
                : Text(
              displayName.toString(),
              style: const TextStyle(fontSize: 24.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: shareProfile,
                  child: const Text('Share profile'),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  onPressed: signOut,
                  child: const Text('Sign out'),
                )
              ],
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    try {
                      determinePosition();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('View in map'),
                ),
              ],
            ),
            position != null
                ? Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center:
                  LatLng(position.latitude, position.longitude),
                  zoom: 5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                    'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                        width: 40,
                        height: 40,
                        point: LatLng(
                            position.latitude, position.longitude),
                        builder: (ctx) =>
                        const Icon(Icons.location_pin, size: 40),
                        key: const ValueKey('marker')),
                  ]),
                ],
              ),
            )
                : const Text(
                'Click on the button to determine the coordinates'),
          ],
        ),
      ),
    );
  }
}
