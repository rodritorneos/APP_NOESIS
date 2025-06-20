import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/signup_viewmodel.dart';

class LogupScreen extends StatefulWidget {
  @override
  _LogupScreenState createState() => _LogupScreenState();
}

class _LogupScreenState extends State<LogupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';

  bool _isPasswordVisible = false;

  late SignupViewModel _signupViewModel;

  @override
  void initState() {
    super.initState();
    _signupViewModel = SignupViewModel();
  }

  void _validateEmail() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailErrorMessage = 'Ingrese su correo electrónico';
      });
    } else if (!email.endsWith('@gmail.com')) {
      setState(() {
        _emailErrorMessage = 'Ingrese un correo Gmail válido';
      });
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _emailErrorMessage = 'Ingrese un correo electrónico válido';
      });
    } else {
      setState(() {
        _emailErrorMessage = '';
      });
    }
  }

  void _validatePassword() {
    String password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() {
        _passwordErrorMessage = 'Ingrese una contraseña';
      });
    } else if (password.length < 4) {
      setState(() {
        _passwordErrorMessage = 'La contraseña debe tener al menos 4 caracteres';
      });
    } else {
      setState(() {
        _passwordErrorMessage = '';
      });
    }
  }

  // Función para manejar el registro
  Future<void> _handleSignup() async {
    // Validar campos antes de proceder
    _validateEmail();
    _validatePassword();

    // Si hay errores, no proceder
    if (_emailErrorMessage.isNotEmpty || _passwordErrorMessage.isNotEmpty) {
      return;
    }

    // Actualizar los valores en la capa de ViewModel
    _signupViewModel.email = _emailController.text.trim();
    _signupViewModel.password = _passwordController.text.trim();

    // Intentar registrar el usuario
    Map<String, dynamic> result = await _signupViewModel.registrarUsuario();

    if (result['success']) {
      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Navegar al login después de un breve delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      // Error en el registro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildResponsiveContent(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Calcular dimensiones responsivas
    double contentWidth = isLargeScreen
        ? screenWidth * 0.35
        : isTablet
        ? screenWidth * 0.6
        : screenWidth * 0.85;

    double maxContentWidth = isLargeScreen ? 400 : 350;
    contentWidth = contentWidth > maxContentWidth ? maxContentWidth : contentWidth;

    double fieldWidth = contentWidth * 0.85;
    double buttonWidth = contentWidth * 0.9;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Espaciador superior flexible
                    Flexible(
                      flex: isTablet ? 2 : 1,
                      child: SizedBox(height: screenHeight * 0.05),
                    ),

                    // Logo Noesis
                    Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.04),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: isTablet ? 100 : 80,
                            height: isTablet ? 100 : 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/logo_log.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback en caso de error cargando la imagen
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC96B0D),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white,
                                        size: isTablet ? 40 : 32,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Noesis',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 32 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // Contenido principal en tarjeta
                    Container(
                      width: contentWidth,
                      constraints: BoxConstraints(
                        maxWidth: maxContentWidth,
                      ),
                      padding: EdgeInsets.all(isTablet ? 32 : 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Pestañas Log in / Sign Up
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: Container(
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "Log in",
                                          style: TextStyle(
                                            fontSize: isTablet ? 18 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC96B0D),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontSize: isTablet ? 18 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Mensaje de bienvenida
                          Text(
                            "Registrarse a Noesis",
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Campo de correo electrónico
                          Container(
                            width: fieldWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'E mail',
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFC96B0D)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                                  onChanged: (value) {
                                    _validateEmail();
                                  },
                                ),
                                if (_emailErrorMessage.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      _emailErrorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Campo de contraseña
                          Container(
                            width: fieldWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFC96B0D)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey[600],
                                        size: isTablet ? 24 : 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                                  onChanged: (value) {
                                    _validatePassword();
                                  },
                                ),
                                if (_passwordErrorMessage.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      _passwordErrorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Botón Sign Up
                          SizedBox(
                            width: buttonWidth,
                            height: isTablet ? 65 : 55,
                            child: Consumer<SignupViewModel>(
                              builder: (context, viewModel, _) => ElevatedButton(
                                onPressed: viewModel.isLoading ? null : _handleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFC96B0D),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(27),
                                  ),
                                  elevation: 3,
                                ),
                                child: viewModel.isLoading
                                    ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Espaciador inferior flexible
                    Flexible(
                      flex: 1,
                      child: SizedBox(height: screenHeight * 0.05),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _signupViewModel,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8B4513).withOpacity(0.8),
                Color(0xFF654321).withOpacity(0.9),
                Color(0xFF5D4037),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: _buildResponsiveContent(context),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}