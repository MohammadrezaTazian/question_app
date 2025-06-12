import 'package:flutter/material.dart';
import 'package:question_app/services/auth_service.dart';
import 'package:question_app/providers/user_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'کنکوریان',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'ثبت نام'),
                    Tab(text: 'ورود'),
                  ],
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorWeight: 3,
                  labelColor: Colors.black,
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    RegisterTab(),
                    LoginTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  bool _rememberMe = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            const Text(
              'نام کاربری',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'نام کاربری خود را وارد کنید',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'رمز عبور',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              textAlign: TextAlign.right,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'رمز عبور خود را وارد کنید',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'فراموشی رمز عبور؟',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text('مرا به خاطر بسپار'),
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'ورود به حساب کاربری',
                      style: TextStyle(fontSize: 16),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // In the _login method of _LoginTabState
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'لطفا نام کاربری و رمز عبور را وارد کنید';
        _isLoading = false;
      });
      return;
    }
    
    try {
      final authService = AuthService();
      final userData = await authService.login(username, password);
      
      // Store user data globally
      UserProvider.setUserData(userData);
      
      // If we get here, login was successful
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/field_selection');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'نام کاربری یا رمز عبور اشتباه است';
        _isLoading = false;
      });
    }
  }
}

class RegisterTab extends StatefulWidget {
  const RegisterTab({super.key});

  @override
  State<RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  bool _agreeToTerms = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            const Text(
              'نام کاربری',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'نام کاربری خود را وارد کنید',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ایمیل',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ایمیل خود را وارد کنید',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'رمز عبور',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              textAlign: TextAlign.right,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'رمز عبور خود را وارد کنید',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'تکرار رمز عبور',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmPasswordController,
              textAlign: TextAlign.right,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'رمز عبور را مجددا وارد کنید',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('با قوانین و مقررات موافق هستم'),
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value!;
                    });
                  },
                ),
              ],
            ),
            
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'ثبت نام',
                      style: TextStyle(fontSize: 16),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    // Validate inputs
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'لطفا تمام فیلدها را پر کنید';
        _isLoading = false;
      });
      return;
    }
    
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'رمز عبور و تکرار آن مطابقت ندارند';
        _isLoading = false;
      });
      return;
    }
    
    if (!_agreeToTerms) {
      setState(() {
        _errorMessage = 'لطفا با قوانین و مقررات موافقت کنید';
        _isLoading = false;
      });
      return;
    }
    
    try {
      final authService = AuthService();
      await authService.register(username, email, password);
      
      // Registration successful, switch to login tab
      if (mounted) {
        // Find the parent AuthPage state to switch tabs
        final authPageState = context.findAncestorStateOfType<_AuthPageState>();
        if (authPageState != null) {
          authPageState._tabController.animateTo(1); // Switch to login tab (index 1)
          
          // Show success message or snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ثبت نام با موفقیت انجام شد. لطفا وارد شوید.'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Pre-fill username in login tab (optional)
          // This would require refactoring to share controllers between tabs
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().contains('Username already exists') 
            ? 'این نام کاربری قبلا ثبت شده است' 
            : 'خطا در ثبت نام. لطفا دوباره تلاش کنید';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}