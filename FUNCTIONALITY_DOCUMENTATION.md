# GoRide Mobile App - Complete Functionality Documentation

## Table of Contents
1. [Authentication Flow](#authentication-flow)
2. [Main Application](#main-application)
3. [Account Management](#account-management)
4. [Payment & Top-Up](#payment--top-up)

---

## 1. Authentication Flow

### 1.1 Splash Screen (`splash_screen.dart`)
**Purpose**: Initial screen displayed when the app launches

**Functionality**:
- Displays GoRide logo with custom painter (green background with white logo)
- Shows animated circular progress indicator
- Automatically navigates to Onboarding Screen after 3 seconds
- Responsive design with clamped sizing for different screen sizes
- Custom logo painter creates a "D" shape with inner circle and horizontal lines extending left, plus a target icon below

**Key Features**:
- Auto-navigation after delay
- Custom logo rendering
- Responsive UI scaling

---

### 1.2 Onboarding Screen (`onboarding_screen.dart`)
**Purpose**: Introduces users to the app features through a multi-page walkthrough

**Functionality**:
- **3-Page Onboarding Flow**:
  - **Page 1**: Welcome message - "Welcome to GoRide - Your Journey, Your Way"
  - **Page 2**: Choose Your Ride - Explains ride selection (motorbike/scooter or car)
  - **Page 3**: Secure Payments - Explains payment options (Wallet, PayPal, Google Pay, Apple Pay, card, cash)
- Page indicators showing current page
- Skip button (available on pages 1-2)
- Continue button to move to next page
- "Let's Get Started" button on final page
- Curved bottom design on map section
- Navigates to Auth Screen after completion or skip

**Key Features**:
- PageView with smooth transitions
- Animated page indicators
- Skip functionality
- Responsive text and spacing

---

### 1.3 Auth Screen (`auth_screen.dart`)
**Purpose**: Main authentication entry point with multiple login options

**Functionality**:
- **Social Login Options**:
  - Continue with Google (custom Google icon painter)
  - Continue with Apple
  - Continue with Facebook
  - Continue with X (Twitter)
- **Primary Actions**:
  - Sign Up button (navigates to Sign Up Screen)
  - Sign In button (navigates to Sign In Screen)
- Footer links: Privacy Policy and Terms of Service
- GoRide logo display
- "Let's Get Started!" title with subtitle

**Key Features**:
- Multiple authentication methods
- Custom social media icons
- Clean, centered layout
- Responsive design

---

### 1.4 Sign In Screen (`signin_screen.dart`)
**Purpose**: Allows existing users to sign in to their account

**Functionality**:
- **Phone Number Input**:
  - Country code selector (dropdown with +1, +44, +91)
  - Flag icon display
  - Phone number text field
- **Remember Me Checkbox**: Option to remember user credentials
- **Social Login Options** (same as Auth Screen):
  - Google, Apple, Facebook, X
- **Sign In Button**: 
  - Enabled only when phone number is entered
  - Navigates to OTP Screen with phone number and country code
- "Welcome Back!" title with waving hand emoji
- "or" separator between phone and social login

**Key Features**:
- Phone-based authentication
- Country code selection
- Remember me functionality
- Social login alternatives
- Form validation

---

### 1.5 Sign Up Screen (`signup_screen.dart`)
**Purpose**: Allows new users to create an account

**Functionality**:
- **Phone Number Input**:
  - Country code selector (dropdown with +1, +44, +91)
  - Flag icon display
  - Phone number text field
- **Terms & Conditions Checkbox**: 
  - Required to proceed
  - Clickable "Terms & Conditions" link
- **Social Login Options**: Google, Apple, Facebook, X
- **Sign Up Button**:
  - Enabled only when terms are agreed and phone is entered
  - Navigates to OTP Screen with `isSignUp: true` flag
- "Join GoRide Today" title with sparkle icons
- "Already have an account? Sign in" link
- "or" separator

**Key Features**:
- Terms acceptance requirement
- Phone number validation
- Social sign-up alternatives
- Link to sign in screen

---

### 1.6 OTP Screen (`otp_screen.dart`)
**Purpose**: Verifies user phone number with one-time password

**Functionality**:
- **4-Digit OTP Input**:
  - 4 separate text fields (one digit each)
  - Auto-focus on first field
  - Auto-advance to next field on input
  - Auto-backspace to previous field
  - Auto-verification when all 4 digits entered
- **Resend Code**:
  - 60-second countdown timer
  - "Resend code" link (enabled after timer expires)
  - Timer display: "You can resend the code in X seconds"
- **Navigation Logic**:
  - If `isSignUp: true` → Navigates to Profile Completion Screen
  - If `isSignUp: false` → Navigates to Home Page
- Phone number display (formatted: (XXX) XXX-XXXX)
- "Enter OTP Code" title with lock icon
- Instructions text with phone number

**Key Features**:
- Multi-field OTP input
- Auto-focus and navigation
- Resend timer functionality
- Conditional navigation based on flow

---

### 1.7 Profile Completion Screen (`profile_completion_screen.dart`)
**Purpose**: Collects additional user information after sign-up

**Functionality**:
- **Profile Picture Section**:
  - Circular avatar placeholder
  - Edit icon overlay (green circle with edit icon)
- **Form Fields**:
  - **Full Name**: Text input
  - **Email**: Text input with email icon
  - **Phone Number**: Pre-filled from sign-up, with country code selector
  - **Gender**: Dropdown (Male, Female, Other, Prefer not to say)
  - **Date of Birth**: Date picker (MM/dd/yyyy format)
- **Continue Button**:
  - Enabled only when all fields are filled
  - Navigates to Home Page upon completion
- Form validation (all fields required)
- Date picker with green theme
- Responsive layout

**Key Features**:
- Complete profile setup
- Date picker integration
- Gender selection
- Form validation
- Pre-filled phone number

---

## 2. Main Application

### 2.1 Main Entry Point (`main.dart`)
**Purpose**: Application entry point and theme configuration

**Functionality**:
- MaterialApp setup with GoRide theme
- Green color scheme (Color(0xFF4CAF50))
- Material 3 design
- Initial route: Splash Screen
- Debug banner disabled

---

### 2.2 Home Page (`home_page.dart`)
**Purpose**: Main application interface with map and ride booking

**Functionality**:
- **Google Maps Integration**:
  - Initial position: New York University (40.7295, -73.9965)
  - User location marker (green)
  - POI markers (Washington Square Park, NYU)
  - Map controls disabled (custom UI)
- **Top Promotional Banner**:
  - "Save 50% Off Additional Pairs" message
  - Dismissible (close icon)
- **Map Control Button**:
  - Circular white button with location icon
  - Centers map on user location
- **Content Overlay** (bottom sheet):
  - "Where to?" heading
  - Search bar with location icon
  - Opens Destination Screen modal on tap
  - Quick destination buttons:
    - Home
    - Office
    - Apartment
    - Mom's H
  - Selected destination highlighted in green
- **Bottom Navigation Bar**:
  - Home (selected by default)
  - Promos
  - Activity (shows Activity Screen)
  - Account (shows Account Screen)
  - Active tab highlighted in green

**Key Features**:
- Interactive map
- Location search
- Quick destination selection
- Bottom navigation
- Promotional banner

---

## 3. Account Management

### 3.1 Account Screen (`account_screen.dart`)
**Purpose**: Main account management hub

**Functionality**:
- **Profile Card**:
  - Profile picture (circular, clickable)
  - User name: "Andrew Ainsley"
  - Phone number: "+1 (646) 555-4099"
  - Navigates to Personal Info Screen on tap
- **Balance Section**:
  - Wallet icon with green background
  - Available balance: "$2,069.50"
  - "Top Up" button (navigates to Top Up Screen)
- **Account Settings List**:
  - **Saved Addresses** (navigates to Saved Addresses Screen)
  - Notifications
  - Payment Methods
  - Account & Security
  - Linked Accounts
  - App Appearance
  - Data & Analytics
  - Help & Support
  - Rate us
  - Each item has colored icon and chevron
- **Logout Option**:
  - Red logout icon
  - Confirmation dialog before logout
  - Shows snackbar on logout

**Key Features**:
- Profile management access
- Wallet balance display
- Settings navigation
- Logout functionality

---

### 3.2 Personal Info Screen (`personal_info_screen.dart`)
**Purpose**: Edit personal information

**Functionality**:
- **Profile Picture**:
  - Large circular avatar
  - Edit icon overlay (green circle)
  - Tap to edit (shows snackbar)
- **Editable Fields**:
  - **Full Name**: Pre-filled "Andrew Ainsley"
  - **Email**: Pre-filled "andrew.ainsley@yourdomain.com" with email icon
  - **Phone Number**: Pre-filled "+1 (646) 555-4099" with flag icon
  - **Gender**: Dropdown with bottom sheet picker (Male, Female, Other)
  - **Date of Birth**: Date picker (MM-dd-yyyy format, pre-filled: 12-27-1995)
- All fields use grey background with green focus border
- Date picker themed in green
- Gender picker with checkmarks

**Key Features**:
- Profile picture editing
- All personal info editable
- Date picker
- Gender selection
- Form styling

---

### 3.3 Saved Addresses Screen (`saved_addresses_screen.dart`)
**Purpose**: Manage saved addresses

**Functionality**:
- **Address List** (pre-populated):
  - Home: "85 4th Ave, New York, NY 10003, United States"
  - Office: "303 Mercer St, New York, NY 10003, United States"
  - Apartment: "69 E 9th St, New York, NY 10003, United States"
  - Mom's House: "100 Bleecker St, New York, NY 10012, United States"
- **Address Card Actions**:
  - Share icon (shows snackbar)
  - More options menu (3-dot icon)
- **More Options Menu** (bottom sheet):
  - Edit (navigates to Add Address Screen with existing address)
  - Delete (shows confirmation dialog)
- **Delete Confirmation Dialog**:
  - Shows address name and full address
  - Cancel and "Yes, Delete" buttons
  - Removes address from list on confirmation
- **Add Address Button** (bottom):
  - Green button with plus icon
  - Navigates to Add Address Screen
- Empty state: "No saved addresses" message

**Key Features**:
- Address list management
- Edit functionality
- Delete with confirmation
- Share functionality
- Add new addresses

---

### 3.4 Add Address Screen (`add_address_screen.dart`)
**Purpose**: Add or edit a saved address

**Functionality**:
- **Map Section** (top 2/3 of screen):
  - Google Map with selected location marker (red)
  - Default location: "The Bleecker" (100 Bleecker St, New York, NY 10012)
  - Search bar overlay (top) for location search
  - Back button (bottom left, circular)
  - My Location button (bottom right, circular)
- **Form Section** (bottom 1/3):
  - **Selected Address Card**: Shows address name and full address
  - **Name Input**: Address name (e.g., "Mom's House")
  - **Address Details Input**: Optional details (floor, unit number)
- **Action Buttons**:
  - Cancel (outlined, green border)
  - Save Address (filled, green background)
- **Edit Mode**: 
  - Pre-fills name and address if editing existing address
- **Validation**: 
  - Name is required
  - Shows snackbar on save

**Key Features**:
- Interactive map
- Location search
- Address naming
- Edit existing addresses
- Form validation

---

## 4. Payment & Top-Up

### 4.1 Top Up Screen (`top_up_screen.dart`)
**Purpose**: Add money to GoRide Wallet

**Functionality**:
- **Amount Input Area**:
  - Large amount display with blinking cursor
  - Dollar sign ($) prefix
  - Default amount: $250.00
  - Available balance display: "$2,069.50"
- **Preset Amount Buttons**:
  - Quick select buttons: $5.00, $10.00, $20.00, $25.00, $50.00, $75.00, $100.00, $150.00, $200.00
  - Tap to set amount
- **Numeric Keypad** (bottom):
  - Numbers 0-9
  - Backspace button (deletes last digit)
  - Real-time amount calculation
  - Decimal formatting (always shows .00)
- **Continue Button**:
  - Enabled when amount > 0
  - Navigates to Choose Top Up Method Screen with amount
- Amount formatting with decimal places
- Cursor blinking animation

**Key Features**:
- Custom numeric keypad
- Preset amount selection
- Real-time amount display
- Amount validation

---

### 4.2 Choose Top Up Method Screen (`choose_top_up_method_screen.dart`)
**Purpose**: Select payment method for top-up

**Functionality**:
- **Payment Methods List**:
  - **PayPal**: andrew.ainsley@yourdomain.com
  - **Google Pay**: andrew.ainsley@yourdomain.com
  - **Apple Pay**: andrew.ainsley@yourdomain.com
  - **Mastercard**: .... .... .... 4679 (selected by default)
  - **Visa**: .... .... .... 5567
  - **American Express**: .... .... .... 8456
- **Selection**:
  - Tap to select payment method
  - Selected method shows green border and checkmark
  - Each method has colored icon background
- **Add Payment Method**:
  - Plus icon in app bar
  - Shows snackbar (placeholder)
- **Confirm Button**:
  - "Confirm Top Up - $X.XX" (shows amount)
  - Shows success dialog on confirmation
- **Success Dialog**:
  - Green checkmark icon
  - "Top Up Successful!" message
  - Amount confirmation
  - OK button (navigates back to Account screen)

**Key Features**:
- Multiple payment methods
- Visual selection
- Success confirmation
- Add new payment method option

---

### 4.3 Top Up Details Screen (`top_up_details_screen.dart`)
**Purpose**: View detailed information about a top-up transaction

**Functionality**:
- **Top Up Amount Card**:
  - Large green plus icon in circle
  - Amount display (large font)
  - "GoRide Wallet" label
  - Payment method source (e.g., "From Mastercard (.... 4679)")
- **Transaction Details Card**:
  - **Status**: "Completed" (green badge)
  - **Payment**: Payment method used
  - **Date**: Formatted date (MMM d, yyyy)
  - **Time**: Formatted time (hh:mm a)
  - **Transaction ID**: With copy icon (shows snackbar on copy)
- **Share Receipt Button**:
  - Opens share modal bottom sheet
- **Share Receipt Modal**:
  - **File Preview**: Shows receipt filename (IMG-{transactionId}.jpg)
  - **Recent People Section**: 
    - Horizontal scrollable list
    - Profile pictures with social media icons
    - Tap to share (shows snackbar)
  - **Social Media Section**:
    - WhatsApp, Facebook, Instagram, Telegram, X
    - Colored icons
    - Tap to share (shows snackbar)
  - Drag handle at top
  - Backdrop blur effect

**Key Features**:
- Transaction details display
- Copy transaction ID
- Share receipt functionality
- Social media integration
- Recent contacts

---

## Summary of Complete User Flow

### New User Journey:
1. **Splash Screen** → Auto-navigate after 3 seconds
2. **Onboarding** → 3 pages, skip or continue
3. **Auth Screen** → Choose Sign Up
4. **Sign Up Screen** → Enter phone, accept terms
5. **OTP Screen** → Enter 4-digit code
6. **Profile Completion** → Fill personal info
7. **Home Page** → Main app interface

### Existing User Journey:
1. **Splash Screen** → Auto-navigate
2. **Onboarding** → Skip or view
3. **Auth Screen** → Choose Sign In
4. **Sign In Screen** → Enter phone (or social login)
5. **OTP Screen** → Enter 4-digit code
6. **Home Page** → Main app interface

### Account Management Flow:
1. **Home Page** → Tap Account tab
2. **Account Screen** → View profile, balance, settings
3. **Personal Info** → Edit profile details
4. **Saved Addresses** → Manage addresses
5. **Add Address** → Add/edit address with map
6. **Top Up** → Add money to wallet
7. **Choose Payment Method** → Select payment
8. **Top Up Details** → View transaction details

---

## Technical Features

### Design System:
- **Primary Color**: Green (#4CAF50)
- **Responsive Sizing**: Clamped values for different screen sizes
- **Material 3**: Modern Material Design
- **Custom Painters**: Logo and Google icon rendering

### Navigation:
- Stack-based navigation
- Modal bottom sheets
- Page transitions
- Conditional routing based on user state

### Form Handling:
- Text input controllers
- Validation logic
- Date pickers
- Dropdowns
- Checkboxes

### Maps Integration:
- Google Maps Flutter
- Markers and custom icons
- Location selection
- Map controls

### State Management:
- StatefulWidget for local state
- Form controllers
- Focus nodes for OTP
- Timer management

---

## Notes

- All screens use responsive design with clamped sizing
- Social login buttons are placeholders (no actual integration)
- Payment methods are mock data
- Addresses are pre-populated for demonstration
- OTP verification is simulated (no actual SMS)
- All navigation uses Material routes
- Snackbars used for user feedback
- Dialogs for confirmations
- Bottom sheets for selections and sharing

