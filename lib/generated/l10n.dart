// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Steganografy App`
  String get title {
    return Intl.message(
      'Steganografy App',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Additional encryption message?`
  String get additionalEncryptionMessage {
    return Intl.message(
      'Additional encryption message?',
      name: 'additionalEncryptionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Choose image`
  String get chooseImage {
    return Intl.message(
      'Choose image',
      name: 'chooseImage',
      desc: '',
      args: [],
    );
  }

  /// `32 chars A-z0-9@#$%&`
  String get secrethint {
    return Intl.message(
      '32 chars A-z0-9@#\$%&',
      name: 'secrethint',
      desc: '',
      args: [],
    );
  }

  /// `No encryption`
  String get noEncryption {
    return Intl.message(
      'No encryption',
      name: 'noEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Load image`
  String get loadImage {
    return Intl.message(
      'Load image',
      name: 'loadImage',
      desc: '',
      args: [],
    );
  }

  /// `Decode`
  String get decode {
    return Intl.message(
      'Decode',
      name: 'decode',
      desc: '',
      args: [],
    );
  }

  /// `Encode & save`
  String get encodeSave {
    return Intl.message(
      'Encode & save',
      name: 'encodeSave',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru', countryCode: 'RU'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
