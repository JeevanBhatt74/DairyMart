/// API Service Documentation
/// 
/// This document describes all the API services integrated between the DairyMart backend and frontend.

// =============================================================================
// 1. CONNECTIVITY SERVICE
// =============================================================================
// File: lib/core/services/connectivity/connectivity_service.dart
// 
// Purpose: Checks internet connectivity before making API calls
// 
// Usage:
//   final connectivity = ref.read(connectivityServiceProvider);
//   final hasInternet = await connectivity.hasInternetConnection();
//   
//   if (!hasInternet) {
//     // Show offline error to user
//   }

// =============================================================================
// 2. API CLIENT
// =============================================================================
// File: lib/core/api/api_client.dart
// 
// Purpose: Handles HTTP requests with interceptors, token management, and logging
// 
// Features:
// - Automatic token injection in Authorization header
// - Auto-logout on 401 (Unauthorized) responses
// - Request/response logging in debug mode
// - Automatic retry on network failures
// 
// Usage:
//   final apiClient = ref.read(apiClientProvider);
//   final response = await apiClient.post('/login', data: {...});

// =============================================================================
// 3. API ENDPOINTS
// =============================================================================
// File: lib/core/api/api_endpoints.dart
//
// Base URL: http://YOUR_IP:5000/api/v1/users
//
// IMPORTANT: Update the IP address to your backend machine's IP
// Current IP: 10.12.35.23 (CHANGE THIS TO YOUR LAPTOP'S IP)
// Port: 5000
//
// Endpoints:
//   - POST /login
//     Request: { email: string, password: string }
//     Response: { success: true, token: string, data: {...user} }
//
//   - POST /register
//     Request: { 
//       fullName: string, 
//       email: string, 
//       password: string,
//       phoneNumber: string,
//       address: string,
//       locationId: string
//     }
//     Response: { success: true, token: string, data: {...user} }

// =============================================================================
// 4. AUTH REMOTE DATA SOURCE
// =============================================================================
// File: lib/features/auth/data/data_sources/auth_remote_data_source.dart
//
// Purpose: Handles all authentication API calls
//
// Methods:
//   - login(email, password) -> AuthApiModel
//   - register(user) -> AuthApiModel
//
// These methods:
// 1. Make HTTP requests to backend
// 2. Parse responses
// 3. Save tokens to secure storage
// 4. Handle errors and throw exceptions

// =============================================================================
// 5. AUTH API MODEL
// =============================================================================
// File: lib/features/auth/data/models/auth_api_model.dart
//
// Purpose: Maps backend API responses to Flutter models
//
// Key methods:
//   - fromJson() - Parse backend response
//   - toJson() - Serialize for backend request
//   - toEntity() - Convert to domain entity
//   - fromEntity() - Create from domain entity

// =============================================================================
// 6. USER SESSION SERVICE
// =============================================================================
// File: lib/core/services/storage/user_session_service.dart
//
// Purpose: Manages user authentication tokens securely
//
// Methods:
//   - saveUserSession(token) - Store token in secure storage
//   - getToken() - Retrieve token
//   - clearSession() - Logout (remove token)
//
// Uses: FlutterSecureStorage for encrypted storage

// =============================================================================
// 7. AUTHENTICATION FLOW
// =============================================================================
//
// SIGNUP FLOW:
// 1. User fills signup form with all required fields
// 2. SignupPage validates form and creates UserEntity
// 3. AuthViewModel calls SignupUseCase
// 4. UseCase calls AuthRepository.registerUser()
// 5. Repository converts entity to AuthApiModel
// 6. Remote data source sends POST /register request
// 7. Backend validates and creates user
// 8. Backend returns token and user data
// 9. Frontend saves token to secure storage
// 10. Frontend navigates to Dashboard
//
// LOGIN FLOW:
// 1. User enters email and password on LoginPage
// 2. LoginPage validates and calls AuthViewModel.loginUser()
// 3. AuthViewModel calls LoginUseCase
// 4. UseCase calls AuthRepository.loginUser()
// 5. Remote data source sends POST /login request
// 6. Backend validates credentials
// 7. Backend returns token and user data
// 8. Frontend saves token to secure storage
// 9. Frontend navigates to Dashboard
//
// TOKEN USAGE:
// 1. After login/signup, token is saved in secure storage
// 2. API client automatically adds token to every request header
// 3. Backend validates token on protected routes
// 4. If token is invalid (401), API client clears session and logs out user

// =============================================================================
// 8. ERROR HANDLING
// =============================================================================
//
// Error types:
//   - DioException: Network/HTTP errors from API
//   - Failure: Domain-level errors (mapped from DioException)
//   - Caught in repositories and converted to Either<Failure, Success>
//
// User-facing errors:
//   - Shown in SnackBar on login/signup failure
//   - Extracted from backend response: response.data['message']

// =============================================================================
// 9. SETUP INSTRUCTIONS
// =============================================================================
//
// 1. UPDATE API ENDPOINT IP:
//    File: lib/core/api/api_endpoints.dart
//    Change _ipAddress to your laptop's IP address
//    You can find it by running: ipconfig (Windows) or ifconfig (Mac/Linux)
//
// 2. ENSURE BACKEND IS RUNNING:
//    $ cd backend
//    $ npm run dev
//    Backend will start on http://YOUR_IP:5000
//
// 3. VERIFY NETWORK:
//    - Your phone/emulator must be on the same WiFi as your laptop
//    - Or use Android emulator host IP: 10.0.2.2 (for local development)
//
// 4. TEST LOGIN/SIGNUP:
//    - Navigate to LoginPage or SignupPage
//    - Submit the form
//    - Check console logs for API requests/responses

// =============================================================================
// 10. DEBUGGING
// =============================================================================
//
// Enable detailed logging:
// - API client logs all requests/responses in debug console
// - Check terminal where backend is running for server-side logs
// - Dio logger shows: request body, response body, and errors
//
// Common issues:
// 1. "Connection refused" - Backend not running or wrong IP
// 2. "400 Validation Error" - Frontend sending wrong field names
// 3. "401 Unauthorized" - Token expired or invalid
// 4. "No internet" - Device not on same network as backend
