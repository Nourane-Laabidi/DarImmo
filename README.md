# DarImmo - Flutter `lib` folder

How to use it:

1. Create the project (in the folder where you want it):
   flutter create darimmo_flutter --org com.darimmo --platforms web,android
   cd darimmo_flutter

2. Install the packages (ONE line, do not interrupt it). Do NOT install supabase_flutter:
   flutter pub add go_router google_fonts flutter_riverpod cached_network_image dio flutter_secure_storage image_picker flutter_map latlong2

3. Delete the sample test:
   del test\widget_test.dart

4. Delete the `lib` folder of the new project and copy the `lib` folder of this zip in its place.

5. Start the backend (in the backend folder): npm start
   Then run the app:
   flutter run -d chrome
   Log in with an account created by the Register screen.

API address (lib/core/api_client.dart):
  - Chrome:            http://localhost:5000/api
  - Android emulator:  http://10.0.2.2:5000/api
  For a real phone or Google Play, the backend must be hosted online (HTTPS) and this address changed.

Screens included: Splash, Login (client), Register, Admin login, Forgot password,
Home, Results + filters, Detail, Favorites, Profile, Publish (4 steps, map, photos).
Placeholders: Map, Messages, Admin dashboard.

Needs backend work (later):
  - Forgot password: POST /auth/forgot-password and /auth/reset-password
  - Photos: Cloudinary keys in the backend .env
  - Admin moderation screen: uses /admin/properties/pending, /approve, /reject
