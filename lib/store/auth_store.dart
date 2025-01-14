import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unityspace/models/auth_models.dart';
import 'package:unityspace/utils/constants.dart';
import 'package:unityspace/utils/http_plugin.dart';
import 'package:unityspace/service/auth_service.dart' as api;
import 'package:unityspace/store/user_store.dart';
import 'package:wstore/wstore.dart';

class AuthStore extends GStore {
  static AuthStore? _instance;

  factory AuthStore() => _instance ??= AuthStore._();

  AuthStore._();

  AuthTokens _currentTokens = const AuthTokens('', '');
  Completer<bool> _refreshUserTokenCompleteEvent = Completer<bool>()
    ..complete(true);

  bool get isAuthenticated => _currentTokens.accessToken.isNotEmpty;

  Future<void> removeUserTokens() async {
    // удалить из локал стореджа
    final sp = await SharedPreferences.getInstance();
    await sp.remove(ConstantPreferenceKeys.accessToken);
    await sp.remove(ConstantPreferenceKeys.refreshToken);
    //
    setStore(() {
      _currentTokens = const AuthTokens('', '');
    });
    // установить заголовки
    _updateHttpAuthorizationHeader('');
  }

  Future<void> setUserTokens(
    final String userToken,
    final String refreshToken,
  ) async {
    if (userToken.isEmpty || refreshToken.isEmpty) return removeUserTokens();

    // сохранить в локалсторедж
    final sp = await SharedPreferences.getInstance();
    await sp.setString(ConstantPreferenceKeys.accessToken, userToken);
    await sp.setString(ConstantPreferenceKeys.refreshToken, refreshToken);

    //
    setStore(() {
      _currentTokens = AuthTokens(userToken, refreshToken);
    });

    // установить заголовки
    _updateHttpAuthorizationHeader(userToken);
  }

  Future<void> loadUserTokens() async {
    final sp = await SharedPreferences.getInstance();
    final userToken = sp.getString(ConstantPreferenceKeys.accessToken) ?? '';
    final refreshToken =
        sp.getString(ConstantPreferenceKeys.refreshToken) ?? '';
    setStore(() {
      _currentTokens = AuthTokens(userToken, refreshToken);
    });
    _updateHttpAuthorizationHeader(userToken);
  }

  Future<bool> refreshUserToken() async {
    if (_refreshUserTokenCompleteEvent.isCompleted == false) {
      return await _refreshUserTokenCompleteEvent.future;
    }
    _refreshUserTokenCompleteEvent = Completer<bool>();
    final refreshToken = _currentTokens.refreshToken;
    if (refreshToken.isEmpty) {
      _refreshUserTokenCompleteEvent.complete(false);
      return false;
    }
    try {
      final tokens = await api.refreshAccessToken(refreshToken: refreshToken);
      await setUserTokens(tokens.accessToken, tokens.refreshToken);
      _refreshUserTokenCompleteEvent.complete(true);
      return true;
    } catch (e, __) {
      if (e is HttpPluginException) {
        if (e.statusCode == 401) {
          // токен протух - удялем - разлогин
          await removeUserTokens();
        }
      }
      _refreshUserTokenCompleteEvent.complete(false);
      return false;
    }
  }

  Future<void> register(final String email, final String password) async {
    await api.register(email: email.toLowerCase(), password: password);
  }

  Future<void> login(final String email, final String password) async {
    final tokens =
        await api.login(email: email.toLowerCase(), password: password);
    await setUserTokens(tokens.accessToken, tokens.refreshToken);
  }

  Future<void> googleAuth(final String credential) async {
    final googleData = await api.googleAuth(credential: credential);
    await setUserTokens(
      googleData.tokens.accessToken,
      googleData.tokens.refreshToken,
    );
  }

  Future<void> restorePasswordByEmail(final String email) async {
    await api.restorePasswordByEmail(email: email.toLowerCase());
  }

  Future<void> confirmEmail(final String email, final String code) async {
    final tokens =
        await api.confirmEmail(email: email.toLowerCase(), code: code);
    await setUserTokens(tokens.accessToken, tokens.refreshToken);
  }

  Future<void> signOut() async {
    final refreshToken = _currentTokens.refreshToken;
    final globalUserId = UserStore().user?.globalId;
    if (refreshToken.isNotEmpty && globalUserId != null) {
      await api.signOut(
        refreshToken: refreshToken,
        globalUserId: globalUserId,
      );
    }
    await removeUserTokens();
  }

  void _updateHttpAuthorizationHeader(final String token) {
    if (token.isEmpty) {
      HttpPlugin().setAuthorizationHeader('');
    } else {
      HttpPlugin().setAuthorizationHeader('${ConstantStrings.bearer} $token');
    }
  }
}
