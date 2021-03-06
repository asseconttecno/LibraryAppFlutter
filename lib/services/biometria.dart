import 'package:flutter/material.dart';

import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

import '../enums/enums.dart';
import '../config.dart';

class BiometriaServices {
  final LocalAuthentication localAuth = LocalAuthentication();

  void supportedBio() {
    if(!Config.isWin){
      localAuth.isDeviceSupported().then((isSupported) {
        Config.bioState = isSupported ? BioSupportState.supported : BioSupportState.unsupported;
      });
    }
  }


  Future<bool> checkBio() async {
    if(Config.bioState == BioSupportState.supported) {
      try {
        bool canCheckBiometrics = await localAuth.canCheckBiometrics;
        if (canCheckBiometrics) {
          List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
          if (availableBiometrics.isNotEmpty) {
            return true;
          } 
        } 
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return false;
  }

  Future<bool> authbiometria() async {
    if(Config.bioState == BioSupportState.supported){
      bool didAuthenticate = false;
      try{
        bool canCheckBiometrics = await localAuth.canCheckBiometrics;
        if(canCheckBiometrics){

          List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
          if (availableBiometrics.isNotEmpty){
            const iosStrings =  IOSAuthMessages(
                cancelButton :  'Cancelar' ,
                goToSettingsButton :  'Configurações' ,
                goToSettingsDescription :  'Configure seu ID' ,
                lockOut :  ' Reative seu ID' );

            const andStrings = AndroidAuthMessages(
              cancelButton: 'Cancelar',
              goToSettingsButton: 'Ir para definir',
              biometricNotRecognized: 'Falha ao autenticar',
              goToSettingsDescription: 'Por favor, defina sua autenticação.',
              biometricHint: '',
              biometricSuccess: 'Autenticado com Sucesso',
              signInTitle: 'Aguardando..',
              biometricRequiredTitle: 'Realize sua autenticação',
            );

            didAuthenticate = await localAuth.authenticate(
                localizedReason: 'Por favor autentique-se para continuar',
                useErrorDialogs :  true,
                stickyAuth: true,
                iOSAuthStrings : iosStrings,
                androidAuthStrings: andStrings
            );
          }
        }
        return didAuthenticate;
      }catch(e){
        debugPrint(e.toString());
      }
    }
    return false;
  }
}