import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petprojectsbookingapp/main.dart';
import 'package:petprojectsbookingapp/src/features/auth/presentation/pages/user_scree.dart';

class LogRegScreen extends StatefulWidget {
  const LogRegScreen({super.key});

  @override
  State<LogRegScreen> createState() => _LogRegScreenState();
}

class _LogRegScreenState extends State<LogRegScreen>
    with TickerProviderStateMixin {
  bool isLogin = true;
  bool rememberme = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String errorMessage = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      errorMessage = '';
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigationWrapper()),
      );
    } catch (e) {
      MyApp();
      setState(() => errorMessage = _getErrorMessage(e.toString()));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      errorMessage = '';
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Update display name
      if (_nameController.text.isNotEmpty) {
        await _auth.currentUser?.updateDisplayName(_nameController.text.trim());
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigationWrapper()),
      );
    } catch (e) {
      MyApp();
      setState(() => errorMessage = _getErrorMessage(e.toString()));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found'))
      return 'No user found with this email.';
    if (error.contains('wrong-password')) return 'Wrong password provided.';
    if (error.contains('email-already-in-use'))
      return 'Email is already registered.';
    if (error.contains('weak-password')) return 'Password is too weak.';
    if (error.contains('invalid-email')) return 'Invalid email address.';
    return 'An error occurred. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SizedBox(
        height: size.height,
        child: Column(
          children: [
            Container(
              height: size.height * 0.36,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF16213E), Color(0xFF1A1A2E)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Welcome to\nBooking Hub',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Discover and manage your bookings with ease",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Tab Selector
                        _buildTabSelector(),
                        const SizedBox(height: 22),
                        if (errorMessage.isNotEmpty) _buildErrorMessage(),

                        // Form Content
                        Flexible(
                          child:
                              isLogin
                                  ? _buildLoginForm()
                                  : _buildRegisterForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => isLogin = true);
                _clearForm();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isLogin ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:
                      isLogin
                          ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                margin: const EdgeInsets.all(2),
                alignment: Alignment.center,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isLogin ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => isLogin = false);
                _clearForm();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isLogin ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:
                      !isLogin
                          ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                margin: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: !isLogin ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildEmailField(),
        const SizedBox(height: 3),
        _buildPasswordField(),
        const SizedBox(height: 3),
        _buildRememberMeAndForgotPassword(),
        const SizedBox(height: 3),
        _buildMainButton('Sign In', handleLogin),
        const Spacer(),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildNameField(),
        const SizedBox(height: 9),
        _buildEmailField(),
        const SizedBox(height: 9),
        _buildPasswordField(),
        const SizedBox(height: 9),
        _buildMainButton('Create Account', handleRegister),
        const Spacer(),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration(
        icon: Icons.email_outlined,
        label: 'Email Address',
        hint: 'Enter your email',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: _inputDecoration(
        icon: Icons.lock_outline,
        label: 'Password',
        hint: isLogin ? 'Enter your password' : 'Create a password',
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade600,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your password';
        if (!isLogin && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: _inputDecoration(
        icon: Icons.person_outline,
        label: 'Full Name',
        hint: 'Enter your full name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your name';
        return null;
      },
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 3,
                width: 20,
                child: Checkbox(
                  value: rememberme,
                  onChanged:
                      (value) => setState(() => rememberme = value ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 3),
              Text(
                'Remember me',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement forgot password
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton(String text, VoidCallback onPressed) {
    return SingleChildScrollView(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : onPressed,

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child:
              _isLoading
                  ? const SizedBox(
                    height: 3,
                    width: 4,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required IconData icon,
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      suffixIcon: suffixIcon,
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade700),
      hintStyle: TextStyle(color: Colors.grey.shade500),
    );
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    setState(() {
      errorMessage = '';
      rememberme = false;
    });
  }
}
