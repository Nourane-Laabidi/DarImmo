import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/api_client.dart';
import '../../core/theme.dart';
import 'auth_service.dart';

/// Needs the backend routes POST /auth/forgot-password and /auth/reset-password.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _codeSent = false;
  bool _loading = false;
  bool _hide = true;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _sendCode() async {
    final e = _email.text.trim();
    if (!e.contains('@') || !e.contains('.')) return _msg('Email invalide');
    setState(() => _loading = true);
    try {
      await AuthService().forgotPassword(e);
      if (!mounted) return;
      setState(() => _codeSent = true);
      _msg('Si un compte existe, un code vient d’être envoyé.');
    } catch (err) {
      if (mounted) _msg(apiError(err));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _reset() async {
    if (_code.text.trim().length != 6) {
      return _msg('Entrez le code à 6 chiffres');
    }
    if (_password.text.length < 8) return _msg('8 caractères minimum');
    if (_password.text != _confirm.text) {
      return _msg('Les mots de passe ne correspondent pas');
    }
    setState(() => _loading = true);
    try {
      await AuthService().resetPassword(
          _email.text.trim(), _code.text.trim(), _password.text);
      if (!mounted) return;
      _msg('Mot de passe modifié. Connectez-vous.');
      context.go('/login');
    } catch (err) {
      if (mounted) _msg(apiError(err));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/login'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mot de passe oublié',
                style: GoogleFonts.poppins(
                    fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              _codeSent
                  ? 'Entrez le code reçu par email et choisissez un nouveau mot de passe.'
                  : 'Entrez votre email, nous vous envoyons un code de réinitialisation.',
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _email,
              enabled: !_codeSent,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            if (_codeSent) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _code,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                    labelText: 'Code à 6 chiffres', counterText: ''),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: _hide,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  suffixIcon: IconButton(
                    icon:
                        Icon(_hide ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirm,
                obscureText: _hide,
                decoration: const InputDecoration(
                    labelText: 'Confirmer le mot de passe'),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : (_codeSent ? _reset : _sendCode),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(_codeSent
                      ? 'Changer le mot de passe'
                      : 'Envoyer le code'),
            ),
            if (_codeSent)
              Center(
                child: TextButton(
                  onPressed: _loading ? null : _sendCode,
                  child: const Text('Renvoyer le code'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
