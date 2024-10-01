import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:huehue/presentation/widgets/GradientScaffold.dart';

class LocationDeniedPermission extends StatelessWidget {
  static const routeName = '/location-denied-permission';

  const LocationDeniedPermission({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Access to your place data was denied
            const SizedBox(height: 78),
             Text(
              'Se negó el acceso a los datos de su lugar',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),

            /// Go to Settings
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onGoToSettingsPressed,
              child: const Text("Ir a Configuración"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Regresar"),
            ),
          ],
        ),
      ),
    );
  }

  void _onGoToSettingsPressed() {
    AppSettings.openAppSettings();
  }
}
