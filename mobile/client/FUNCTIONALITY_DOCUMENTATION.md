# GoRide Mobile Application - Complete Functionality Documentation

## Table of Contents
1. [Application Entry & Initialization](#1-application-entry--initialization)
2. [Authentication Flow](#2-authentication-flow)
3. [Onboarding](#3-onboarding)
4. [Home Screen & Navigation](#4-home-screen--navigation)
5. [Ride Booking Flow](#5-ride-booking-flow)
6. [Ride Management](#6-ride-management)
7. [Activity & History](#7-activity--history)
8. [Account Management](#8-account-management)
9. [Payment & Top-Up](#9-payment--top-up)
10. [Address Management](#10-address-management)

---

## 1. Application Entry & Initialization

### 1.1 Main Application (`main.dart`)
**Purpose**: Application entry point and theme configuration

**Functionality**:
- Initializes Flutter application with Material Design 3
- Sets primary color scheme to green (`#4CAF50`)
- Configures app title as "GoRide"
- Sets `SplashScreen` as the initial home screen
- Disables debug banner

**Navigation Flow**: `main.dart` → `SplashScreen`

---

## 2. Authentication Flow

### 2.1 Splash Screen (`splash_screen.dart`)
**Purpose**: Initial app loading screen with branding

**Functionality**:
- Displays custom GoRide logo (green "D" shape with lines and target icon)
- Shows "GoRide" title in white text
- Displays circular progress indicator
- Auto-navigates to `OnboardingScreen` after 3 seconds
- Responsive design with height scaling
- Green background (`#4CAF50`)

**Custom Components**:
- `GoRideLogoPainter`: Custom painter for app logo

**Navigation Flow**: `SplashScreen` → `OnboardingScreen` (after 3 seconds)

---

### 2.2 Onboarding Screen (`onboarding_screen.dart`)
**Purpose**: Introduce users to app features through 3-page walkthrough

**Functionality**:
- **Page 1 - Welcome**: 
  - Title: "Welcome to GoRide - Your Journey, Your Way"
  - Description about hassle-free transportation
- **Page 2 - Choose Your Ride**:
  - Title: "Choose Your Ride - Tailored to Your Needs"
  - Description about selecting motorbike/scooter or car
- **Page 3 - Secure Payments**:
  - Title: "Secure Payments & Seamless Transactions"
  - Description about payment methods (Wallet, PayPal, Google Pay, Apple Pay, card, cash)

**Features**:
- PageView with 3 pages
- Animated pagination indicators (green for active, grey for inactive)
- "Skip" button (outlined green) on pages 1-2
- "Continue" button (solid green) on pages 1-2
- "Let's Get Started" button (solid green) on page 3
- Curved bottom clipper for green background section
- Responsive layout with scrollable content

**Navigation Flow**: 
- `OnboardingScreen` → `AuthScreen` (on Continue/Skip/Let's Get Started)

---

### 2.3 Auth Screen (`auth_screen.dart`)
**Purpose**: Main authentication hub with social login options

**Functionality**:
- Displays GoRide logo
- Title: "Let's Get Started!"
- Subtitle: "Let's dive in into your account"
- **Social Login Buttons** (outlined, full-width):
  1. Continue with Google (custom Google icon painter)
  2. Continue with Apple (black apple icon)
  3. Continue with Facebook (blue circle with "f")
  4. Continue with X (black X icon)
- **Primary Actions**:
  - "Sign up" button (solid green) → navigates to `SignUpScreen`
  - "Sign in" button (light green with green text) → navigates to `SignInScreen`
- Footer links: Privacy Policy • Terms of Service

**Custom Components**:
- `GoRideLogoPainter`: Reused logo painter
- `GoogleIconPainter`: Custom painter for Google logo (4-color arc design)

**Navigation Flow**: 
- `AuthScreen` → `SignUpScreen` (Sign up button)
- `AuthScreen` → `SignInScreen` (Sign in button)

---

### 2.4 Sign Up Screen (`signup_screen.dart`)
**Purpose**: User registration with phone number

**Functionality**:
- Title: "Join GoRide Today" with sparkle icons (⭐)
- Subtitle: Instructions for creating account
- **Phone Number Input**:
  - Country code selector (dropdown with flag emoji)
  - Default: +1 (US)
  - Options: +1, +44, +91
  - Phone number text field
- **Terms & Conditions**:
  - Checkbox to agree to Terms & Conditions
  - Clickable "Terms & Conditions" text (green)
- **Social Login Options** (same as Auth Screen):
  - Google, Apple, Facebook, X
- **Navigation Links**:
  - "Already have an account? Sign in" → navigates to `SignInScreen`
- **Sign Up Button**:
  - Enabled only when terms are agreed and phone is entered
  - Navigates to `OtpScreen` with `isSignUp: true`

**Validation**:
- Phone number must not be empty
- Terms & Conditions must be checked

**Navigation Flow**: 
- `SignUpScreen` → `OtpScreen` (with `isSignUp: true`)
- `SignUpScreen` → `SignInScreen` (via link)

---

### 2.5 Sign In Screen (`signin_screen.dart`)
**Purpose**: User login with phone number

**Functionality**:
- Title: "Welcome Back!" with waving hand emoji (👋)
- Subtitle: Instructions for signing in
- **Phone Number Input**:
  - Country code selector (same as Sign Up)
  - Phone number text field
- **Remember Me Checkbox**:
  - Green checkbox to remember user
- **Social Login Options**:
  - Google, Apple, Facebook, X
- **Sign In Button**:
  - Enabled when phone number is entered
  - Navigates to `OtpScreen` with `isSignUp: false`

**Navigation Flow**: 
- `SignInScreen` → `OtpScreen` (with `isSignUp: false`)

---

### 2.6 OTP Screen (`otp_screen.dart`)
**Purpose**: Verify phone number with 4-digit OTP code

**Functionality**:
- Title: "Enter OTP Code" with lock icon (🔒)
- Instructions: Shows formatted phone number where OTP was sent
- **OTP Input Fields**:
  - 4 separate text fields (one digit each)
  - Auto-focus on first field
  - Auto-advance to next field on input
  - Auto-focus previous field on backspace
  - Green border when focused
  - Auto-verifies when 4 digits entered
- **Resend Code**:
  - 60-second countdown timer
  - "Resend code" link (green, underlined when available)
  - Disabled during countdown

**Navigation Logic**:
- If `isSignUp: true` → navigates to `ProfileCompletionScreen`
- If `isSignUp: false` → navigates to `MyHomePage`

**Features**:
- Phone number formatting: (XXX) XXX-XXXX
- Input formatters: digits only
- Auto-verification on completion

**Navigation Flow**: 
- `OtpScreen` → `ProfileCompletionScreen` (if sign up)
- `OtpScreen` → `MyHomePage` (if sign in)

---

### 2.7 Profile Completion Screen (`profile_completion_screen.dart`)
**Purpose**: Complete user profile after sign up

**Functionality**:
- Title: "Fill Personal Info"
- **Profile Picture**:
  - Circular avatar with edit icon overlay (green circle)
  - Tappable to change picture
- **Input Fields**:
  1. **Full Name**: Text input
  2. **Email**: Text input with email icon
  3. **Phone Number**: Pre-filled from sign up, country code selector
  4. **Gender**: Dropdown (Male, Female, Other, Prefer not to say)
  5. **Date of Birth**: Date picker (MM/dd/yyyy format)
     - Green-themed date picker
     - Minimum age: 18 years
     - Date range: 1950 to today
- **Continue Button**:
  - Enabled when all fields are filled
  - Navigates to `MyHomePage`

**Validation**:
- All fields required
- Date of birth must be selected
- Gender must be selected

**Navigation Flow**: 
- `ProfileCompletionScreen` → `MyHomePage` (on Continue)

---

## 3. Home Screen & Navigation

### 3.1 Home Page (`home_page.dart`)
**Purpose**: Main map interface with ride booking

**Functionality**:
- **Google Maps Integration**:
  - Full-screen map background
  - Initial position: New York University (40.7295, -73.9965)
  - Markers:
    - User location (green marker)
    - Washington Square Park (blue marker)
    - New York University (orange marker)
  - Map controls (compass/target button)
- **Top Promotional Banner**:
  - Green banner with promotional content
  - Positioned at top with safe area
- **Content Overlay** (bottom):
  - Quick destination buttons (Home, Office, Apartment, Mom's H)
  - Selected destination highlighted
  - Tappable to set quick destinations
- **Bottom Navigation Bar** (4 tabs):
  1. **Home** (house icon) - Map view
  2. **Promos** (tag icon) - Promotions screen
  3. **Activity** (document icon) - Activity/History screen
  4. **Account** (person icon) - Account settings screen
  - Active tab highlighted in green
  - Inactive tabs in grey

**Navigation**:
- Tapping Activity tab → shows `ActivityScreen`
- Tapping Account tab → shows `AccountScreen`
- Tapping destination area → navigates to `DestinationScreen`

**Features**:
- Responsive design
- Web support (requires Google Maps API key in `web/index.html`)

---

## 4. Ride Booking Flow

### 4.1 Destination Screen (`destination_screen.dart`)
**Purpose**: Select or search for destination

**Functionality**:
- **Search Bar**:
  - Location pin icon
  - Text input for searching destinations
  - "Recent" and "Saved" tabs
- **Recent Destinations List**:
  - Shows 6 recent destinations with:
    - Location name
    - Address (truncated)
    - Distance from current location
  - Tappable items
- **Saved Destinations**:
  - List of saved addresses (if any)
- **Action**: Tapping a destination navigates to `PickupLocationScreen`

**Navigation Flow**: 
- `DestinationScreen` → `PickupLocationScreen` (on destination selection)

---

### 4.2 Pickup Location Screen (`pickup_location_screen.dart`)
**Purpose**: Confirm or change pickup location

**Functionality**:
- Displays selected destination
- Pickup location input/selection
- Confirmation to proceed to ride selection

**Navigation Flow**: 
- `PickupLocationScreen` → `RideSelectionScreen`

---

### 4.3 Ride Selection Screen (`ride_selection_screen.dart`)
**Purpose**: Choose ride type, apply promos, select payment, schedule rides

**Functionality**:
- **Ride Options** (3 types):
  1. **GoRide Car**: $12.50, 3-5 mins, 4 passengers
  2. **GoRide Car XL**: $15.00, 4-6 mins, 6 passengers
  3. **GoRide Car Plus**: $16.50, 4-5 mins, 4 passengers
- **Price Display**:
  - Shows original price (crossed out) when promo applied
  - Shows discounted price in green
  - Default 20% discount when promo selected
- **Promos/Vouchers Section**:
  - Tappable to open `PromosScreen`
  - Shows selected promo as green pill
- **Payment Method Section**:
  - Tappable to open `PaymentMethodScreen`
  - Shows selected payment method
- **Schedule Ride Button**:
  - Opens `ScheduleRideScreen` modal
  - Shows scheduled date/time when set
  - Format: "Jan 22, 04:00 PM"
- **Book Button**:
  - Changes to "Schedule GoRide Car" when ride is scheduled
  - Navigates to `DriverSearchScreen` (immediate booking)
  - Navigates to `RideScheduledConfirmationScreen` (scheduled booking)

**Features**:
- Dynamic pricing based on selected promo
- Ride type selection with visual indicators
- Schedule functionality

**Navigation Flow**: 
- `RideSelectionScreen` → `PromosScreen` (promo section)
- `RideSelectionScreen` → `PaymentMethodScreen` (payment section)
- `RideSelectionScreen` → `ScheduleRideScreen` (schedule button)
- `RideSelectionScreen` → `DriverSearchScreen` (Book button - immediate)
- `RideSelectionScreen` → `RideScheduledConfirmationScreen` (Schedule button - scheduled)

---

### 4.4 Promos Screen (`promos_screen.dart`)
**Purpose**: Browse and select promotional codes

**Functionality**:
- List of available promo codes
- Each promo shows:
  - Discount percentage
  - Title/description
  - Validity period
- Selection returns to `RideSelectionScreen` with selected promo

**Navigation Flow**: 
- `PromosScreen` → `RideSelectionScreen` (with selected promo)

---

### 4.5 Payment Method Screen (`payment_method_screen.dart`)
**Purpose**: Select payment method for ride

**Functionality**:
- List of payment methods:
  - GoRide Wallet
  - PayPal
  - Google Pay
  - Apple Pay
  - Credit/Debit Cards
  - Cash
- Selection returns to `RideSelectionScreen` with selected payment

**Navigation Flow**: 
- `PaymentMethodScreen` → `RideSelectionScreen` (with selected payment)

---

### 4.6 Schedule Ride Screen (`schedule_ride_screen.dart`)
**Purpose**: Schedule a ride for future date/time

**Functionality**:
- **Blurred Map Background**
- **Date Selection Tabs**:
  - "Today"
  - "Tomorrow"
  - "Select Date" (opens date picker)
- **Time Picker**:
  - Scrollable hour picker (12-hour format: 1-12)
  - Scrollable minute picker (00-59)
  - AM/PM selector
- **Action Buttons**:
  - "Cancel" - closes modal
  - "Set Schedule" - saves schedule and returns to `RideSelectionScreen`

**Features**:
- Modal bottom sheet presentation
- Backdrop blur effect
- Auto-applies default promo when scheduled

**Navigation Flow**: 
- `ScheduleRideScreen` → `RideSelectionScreen` (with scheduled date/time)

---

### 4.7 Ride Scheduled Confirmation Screen (`ride_scheduled_confirmation_screen.dart`)
**Purpose**: Confirm successful ride scheduling

**Functionality**:
- Blurred map background
- Blue calendar icon
- Title: "Ride scheduled!"
- Formatted scheduled date/time display
- Instruction message
- "Got It" button → navigates to `MyHomePage`

**Navigation Flow**: 
- `RideScheduledConfirmationScreen` → `MyHomePage`

---

## 5. Ride Management

### 5.1 Driver Search Screen (`driver_search_screen.dart`)
**Purpose**: Show driver search progress after booking

**Functionality**:
- **Map View**:
  - Shows pickup and dropoff locations
  - Route visualization
- **User Profile Picture**:
  - Circular profile with pulsating circles animation
  - Indicates search in progress
- **Search Indicator**:
  - Animated "Finding you a nearby driver..." text
- **Cancel Ride Button**:
  - Red button to cancel search
- **Auto-Navigation**:
  - After 3 seconds → navigates to `DriverEnRouteScreen`

**Navigation Flow**: 
- `DriverSearchScreen` → `DriverEnRouteScreen` (after 3 seconds)
- `DriverSearchScreen` → `CancelRideReasonScreen` (on cancel)

---

### 5.2 Driver En Route Screen (`driver_en_route_screen.dart`)
**Purpose**: Show driver information and route while driver is heading to pickup

**Functionality**:
- **Map Display**:
  - Driver's car marker (moving)
  - Green route polyline
  - User location marker
  - Pickup location marker (green)
  - Dropoff location marker (red)
- **Driver Information Card**:
  - Profile picture (tappable)
  - Name and rating
  - Vehicle details (make, model, color, license plate)
  - ETA to pickup
- **Contact Options**:
  - Message button → `DriverChatScreen`
  - Call button → `DriverVoiceCallScreen`
- **Ride Details Card**:
  - Pickup and dropoff addresses
  - Ride type
  - Estimated fare
- **Fare Breakdown Card**:
  - Trip fare
  - Discounts (if any)
  - Total paid
- **Cancel Ride Button**:
  - Navigates to `CancelRideReasonScreen`
- **Auto-Navigation**:
  - After 10 seconds → navigates to `TripCompletedScreen`

**Features**:
- Real-time driver tracking visualization
- Safe price parsing (handles double, String, int types)

**Navigation Flow**: 
- `DriverEnRouteScreen` → `DriverInformationScreen` (on driver profile tap)
- `DriverEnRouteScreen` → `DriverChatScreen` (on message)
- `DriverEnRouteScreen` → `DriverVoiceCallScreen` (on call)
- `DriverEnRouteScreen` → `CancelRideReasonScreen` (on cancel)
- `DriverEnRouteScreen` → `TripCompletedScreen` (after 10 seconds)

---

### 5.3 Driver Information Screen (`driver_information_screen.dart`)
**Purpose**: Detailed driver profile view

**Functionality**:
- **Driver Profile**:
  - Large profile picture
  - Name and phone number
  - Copy phone number button
- **Statistics**:
  - Rating (stars)
  - Total ride orders
  - Years of experience
- **Vehicle Details**:
  - Vehicle make/model
  - Color
  - License plate
- **Action Buttons**:
  - Call button → `DriverVoiceCallScreen`
  - Chat button → `DriverChatScreen`

**Navigation Flow**: 
- `DriverInformationScreen` → `DriverChatScreen` (on chat)
- `DriverInformationScreen` → `DriverVoiceCallScreen` (on call)

---

### 5.4 Driver Chat Screen (`driver_chat_screen.dart`)
**Purpose**: Text messaging with driver

**Functionality**:
- **Top Bar**:
  - Driver name
  - Call icon → `DriverVoiceCallScreen`
  - Video call icon → `DriverVideoCallScreen`
- **Message List**:
  - Pre-loaded messages (driver and user)
  - Image messages support
  - Timestamp display
- **Input Bar**:
  - Emoji button
  - Attachment button
  - Text input
  - Send button

**Navigation Flow**: 
- `DriverChatScreen` → `DriverVoiceCallScreen` (on phone icon)
- `DriverChatScreen` → `DriverVideoCallScreen` (on video icon)

---

### 5.5 Driver Voice Call Screen (`driver_voice_call_screen.dart`)
**Purpose**: Voice call interface with driver

**Functionality**:
- Gradient background
- Circular driver profile picture
- Call duration timer
- **Control Buttons**:
  - End call (red, center)
  - Speaker toggle
  - Microphone mute toggle

**Features**:
- Full-screen call interface
- Call timer display

---

### 5.6 Driver Video Call Screen (`driver_video_call_screen.dart`)
**Purpose**: Video call interface with driver

**Functionality**:
- Dark background
- **Main Video Feed**: Driver's video (full screen)
- **Picture-in-Picture**: User's video (small, bottom-right)
- Call duration timer
- **Control Buttons**:
  - End call (red)
  - Video toggle
  - Speaker toggle
  - Mute microphone

**Features**:
- Dual video feed display
- Floating controls

---

### 5.7 Trip Completed Screen (`trip_completed_screen.dart`)
**Purpose**: Show trip completion summary

**Functionality**:
- **Blurred Map Background**:
  - Destination pin visible
- **Destination Details**:
  - Destination name and address
- **Trip Statistics**:
  - Duration
  - Distance traveled
  - Average speed
- **Mood Rating**:
  - 5 emoji options (😊, 😄, 😐, 😕, 😢)
  - Tappable to rate trip mood
- **Finish Button**:
  - Navigates to `DriverRatingScreen`

**Navigation Flow**: 
- `TripCompletedScreen` → `DriverRatingScreen` (on Finish)

---

### 5.8 Driver Rating Screen (`driver_rating_screen.dart`)
**Purpose**: Rate driver and provide feedback

**Functionality**:
- **Driver Profile**:
  - Profile picture
  - Name
- **Rating System**:
  - 5-star rating (tappable)
  - Rating prompt text
- **Ride Details**:
  - Pickup and dropoff
  - Payment method
  - Collapsible fare breakdown
- **Fare Breakdown**:
  - Trip fare
  - Discounts (if any)
  - Total paid
- **Give Rate Button**:
  - Navigates to `FeedbackConfirmationScreen`

**Features**:
- Safe price parsing (handles multiple types)

**Navigation Flow**: 
- `DriverRatingScreen` → `FeedbackConfirmationScreen` (on Give Rate)

---

### 5.9 Feedback Confirmation Screen (`feedback_confirmation_screen.dart`)
**Purpose**: Confirm successful feedback submission

**Functionality**:
- Green checkmark icon
- Title: "Thanks for your feedback!"
- Confirmation message
- "OK" button → navigates to `MyHomePage`

**Navigation Flow**: 
- `FeedbackConfirmationScreen` → `MyHomePage`

---

### 5.10 Cancel Ride Reason Screen (`cancel_ride_reason_screen.dart`)
**Purpose**: Select reason for ride cancellation

**Functionality**:
- Title: "Cancel Ride"
- **11 Radio Button Options**:
  1. Driver is taking too long
  2. I found another ride
  3. I don't need the ride anymore
  4. Wrong destination
  5. Wrong pickup location
  6. Price is too high
  7. Driver cancelled
  8. Emergency
  9. Other reason
  10. (Additional options)
  11. (Additional options)
- **Confirm Button**:
  - Navigates to `RideCancellationConfirmationScreen`

**Navigation Flow**: 
- `CancelRideReasonScreen` → `RideCancellationConfirmationScreen` (on Confirm)

---

### 5.11 Ride Cancellation Confirmation Screen (`ride_cancellation_confirmation_screen.dart`)
**Purpose**: Confirm successful ride cancellation

**Functionality**:
- Green checkmark icon
- Title: "Ride has been canceled!"
- Cancellation message
- Refund information
- "OK" button → navigates to `MyHomePage`

**Navigation Flow**: 
- `RideCancellationConfirmationScreen` → `MyHomePage`

---

## 6. Activity & History

### 6.1 Activity Screen (`activity_screen.dart`)
**Purpose**: View ride history and transactions

**Functionality**:
- **App Bar**:
  - Green "Go" logo
  - "Activity" title
  - Menu icon (three dots)
- **Tab Navigation** (5 tabs):
  1. **Ongoing**: Active rides
  2. **Scheduled**: Upcoming scheduled rides
  3. **Completed**: Completed rides
  4. **Cancelled**: Cancelled rides
  5. **Top Up**: Wallet top-up transactions
- **Ongoing Tab**:
  - Shows active ride card (if any)
  - Displays: car icon, destination, fare, date, payment method, pickup/dropoff
  - "Track Route" button → `DriverEnRouteScreen`
  - "No ongoing rides" message if empty
- **Scheduled Tab**:
  - List of scheduled rides
  - Each item shows: ride type icon, destination, booked date, scheduled time/date
  - Tappable → `RideDetailsScreen`
- **Completed Tab**:
  - List of completed rides
  - Each item shows: ride type icon (green), destination, completion date/time, fare, payment method
  - Tappable → `RideDetailsScreen` (with completed status)
- **Cancelled Tab**:
  - List of cancelled rides
  - Each item shows: ride type icon (green), destination, cancellation date/time, fare
  - Status: "Canceled & Refunded" (red text)
  - Tappable → `RideDetailsScreen` (with cancelled status)
- **Top Up Tab**:
  - List of top-up transactions
  - Each item shows: green plus icon, "Top Up" label, date/time, amount, payment method
  - Tappable → `TopUpDetailsScreen`

**Features**:
- Date formatting for different tabs
- Empty state messages
- Scrollable lists

**Navigation Flow**: 
- `ActivityScreen` → `DriverEnRouteScreen` (Track Route)
- `ActivityScreen` → `RideDetailsScreen` (scheduled/completed/cancelled items)
- `ActivityScreen` → `TopUpDetailsScreen` (top-up items)

---

### 6.2 Ride Details Screen (`ride_details_screen.dart`)
**Purpose**: Detailed view of a ride (scheduled, completed, or cancelled)

**Functionality**:
- **Conditional Display Based on Status**:
  - **Scheduled Rides**:
    - "Your Scheduled Ride" card with scheduled date/time
    - "We'll notify you when a driver's found" button
    - Changes to "Driver is found" after 10 seconds (auto-triggered)
    - Driver information card appears when driver found
    - Driver found modal (auto-shows after 10 seconds)
  - **Completed Rides**:
    - Status badge: "Completed" (green)
    - Driver information always visible
    - Fare breakdown includes driver tip
    - Only "Share Receipt" button
  - **Cancelled Rides**:
    - Status badge: "Canceled & Refunded" (red)
    - Driver information visible
    - Fare breakdown (no tip)
    - Only "Share Receipt" button
- **Ride Type Card**:
  - Ride name (varies by type and status)
  - Duration and passenger count
  - Price with green checkmark (for cancelled/completed)
  - Original price (crossed out) if discounted
- **Locations Card**:
  - Pickup location (green pin)
  - Dropoff location (red pin)
  - Dashed line connecting them
- **Driver Information Card** (when applicable):
  - Profile picture
  - Name and rating
  - Vehicle details
  - Chat button
- **Ride Details Information Card**:
  - Status badge
  - Payment method
  - Date and time
  - Transaction ID (with copy icon)
  - Booking ID (with copy icon)
- **Fare Breakdown Card**:
  - Trip fare
  - Discounts (with percentage)
  - Driver tip (completed rides only)
  - Total paid
- **Action Buttons**:
  - Share Receipt (green outlined) → opens share modal
  - Cancel Ride (red outlined, scheduled only) → `CancelRideReasonScreen`

**Share Receipt Modal**:
- File preview: "IMG-TRX-BKG.jpg"
- Recent people section (5 contacts with social icons)
- Social media section (WhatsApp, Facebook, Instagram, Telegram, X)
- All items tappable with snackbar feedback

**Features**:
- Dynamic UI based on ride status
- Auto-driver found notification (10-second delay)
- Safe price type handling
- Responsive layout with overflow prevention

**Navigation Flow**: 
- `RideDetailsScreen` → `CancelRideReasonScreen` (Cancel Ride button)
- `RideDetailsScreen` → Share Receipt Modal (Share Receipt button)

---

## 7. Account Management

### 7.1 Account Screen (`account_screen.dart`)
**Purpose**: User account dashboard and settings

**Functionality**:
- **App Bar**:
  - Green "Go" logo
  - "Account" title
  - Menu icon
- **Profile and Balance Card**:
  - **Profile Section** (tappable):
    - Circular profile picture
    - Name: "Andrew Ainsley"
    - Phone: "+1 (646) 555-4099" with phone icon
    - Chevron icon → `PersonalInfoScreen`
  - **Balance Section**:
    - Green wallet icon
    - Balance: "$2,069.50" (bold)
    - "Available balance" text
    - "Top Up" button → `TopUpScreen`
- **Account Settings List** (9 items):
  1. **Saved Addresses** (blue icon) → `SavedAddressesScreen`
  2. **Notifications** (orange icon)
  3. **Payment Methods** (purple icon)
  4. **Account & Security** (green icon)
  5. **Linked Accounts** (teal icon)
  6. **App Appearance** (indigo icon)
  7. **Data & Analytics** (blue icon)
  8. **Help & Support** (grey icon)
  9. **Rate us** (amber icon)
  - Each item has colored icon, title, and chevron
  - Tappable (shows snackbar for non-navigated items)
- **Logout Option**:
  - Red logout icon
  - "Logout" text (red)
  - Shows confirmation dialog
  - Dialog: "Are you sure you want to logout?"
  - Cancel and Logout buttons

**Navigation Flow**: 
- `AccountScreen` → `PersonalInfoScreen` (profile section)
- `AccountScreen` → `TopUpScreen` (Top Up button)
- `AccountScreen` → `SavedAddressesScreen` (Saved Addresses)

---

### 7.2 Personal Info Screen (`personal_info_screen.dart`)
**Purpose**: View and edit personal information

**Functionality**:
- **App Bar**: "Personal Info" title with back button
- **Profile Picture**:
  - Large circular profile picture
  - Green edit icon overlay (bottom-right)
  - Tappable to change picture
- **Input Fields**:
  1. **Full Name**: "Andrew Ainsley" (pre-filled)
  2. **Email**: "andrew.ainsley@yourdomain.com" with envelope icon
  3. **Phone Number**: "+1 (646) 555-4099" with flag and dropdown
  4. **Gender**: "Male" (dropdown with chevron)
     - Options: Male, Female, Other (modal bottom sheet)
  5. **Date of Birth**: "12-27-1995" (MM-dd-yyyy format)
     - Calendar icon on right
     - Opens date picker on tap
- All fields have light grey backgrounds
- Labels in bold dark text

**Features**:
- Date picker with green theme
- Gender selection modal
- Profile picture edit functionality

**Navigation Flow**: 
- `PersonalInfoScreen` → `AccountScreen` (back button)

---

### 7.3 Saved Addresses Screen (`saved_addresses_screen.dart`)
**Purpose**: Manage saved addresses

**Functionality**:
- **App Bar**: "Saved Addresses" title
- **Address List** (4 saved addresses):
  1. **Home**: 85 4th Ave, New York, NY 10003
  2. **Office**: 303 Mercer St, New York, NY 10003
  3. **Apartment**: 69 E 9th St, New York, NY 10003
  4. **Mom's House**: 100 Bleecker St, New York, NY 10012
- **Each Address Card**:
  - Green location pin icon (left)
  - Address name (bold)
  - Full address (grey text)
  - Share icon (right)
  - Three dots menu (right)
- **Menu Options** (from three dots):
  - Edit → `AddAddressScreen` (with existing address data)
  - Delete → Delete confirmation dialog
- **Delete Confirmation Dialog**:
  - Blurred background
  - Title: "Delete Address" (red)
  - Question: "Sure you want to delete this address?"
  - Address card showing address to delete
  - Cancel button (light green outlined)
  - "Yes, Delete" button (solid green)
- **Add Address Button**:
  - Green button with plus icon
  - "Add Address" text
  - Navigates to `AddAddressScreen`

**Navigation Flow**: 
- `SavedAddressesScreen` → `AddAddressScreen` (Add Address button or Edit menu)
- `SavedAddressesScreen` → Delete Dialog (Delete menu)

---

### 7.4 Add Address Screen (`add_address_screen.dart`)
**Purpose**: Add or edit a saved address

**Functionality**:
- **Map Section** (top half):
  - Google Map with red location pin
  - Search bar: "Search for a location" with location icon
  - Back button (circular white, bottom-left)
  - Location button (circular white, bottom-right)
- **Form Section** (bottom half):
  - Title: "Add an Address" (centered, bold)
  - **Selected Address Card**:
    - Red location pin icon
    - "The Bleecker" (bold)
    - "100 Bleecker St, New York, NY 10012, United States"
  - **Name Input**:
    - Label: "Name"
    - Pre-filled: "Mom's House" (for new) or existing name (for edit)
  - **Address Details Input**:
    - Label: "Address Details"
    - Placeholder: "e.g. Floor, unit number"
  - **Action Buttons**:
    - Cancel (light green outlined) → closes screen
    - Save Address (solid green) → saves and returns

**Features**:
- Google Maps integration
- Location search functionality
- Edit mode when existing address provided

**Navigation Flow**: 
- `AddAddressScreen` → `SavedAddressesScreen` (on Save/Cancel)

---

## 8. Payment & Top-Up

### 8.1 Top Up Screen (`top_up_screen.dart`)
**Purpose**: Add funds to GoRide Wallet

**Functionality**:
- **App Bar**: "Top Up" title with back button
- **Amount Input Area**:
  - Large amount display: "250.00" (default, editable)
  - Blinking green cursor
  - Dollar sign on right
  - "Available balance: $2,069.50" (grey text below)
- **Preset Amount Buttons** (9 buttons, 3x3 grid):
  - $5.00, $10.00, $20.00
  - $25.00, $50.00, $75.00
  - $100.00, $150.00, $200.00
  - White buttons with grey borders
  - Tappable to set amount
- **Continue Button**:
  - Green, full-width
  - Enabled when amount > 0
  - Navigates to `ChooseTopUpMethodScreen`
- **Numeric Keypad** (bottom):
  - 4 rows: 1-3, 4-6, 7-9, *-0-backspace
  - Light grey background
  - White buttons with grey borders
  - Backspace icon for deletion
  - Real-time amount calculation

**Features**:
- Amount input with numeric keypad
- Preset quick-select buttons
- Blinking cursor animation
- Amount validation

**Navigation Flow**: 
- `TopUpScreen` → `ChooseTopUpMethodScreen` (on Continue)

---

### 8.2 Choose Top Up Method Screen (`choose_top_up_method_screen.dart`)
**Purpose**: Select payment method for top-up

**Functionality**:
- **App Bar**:
  - "Choose Top Up Method" title
  - Plus icon (add payment method)
- **Payment Methods List** (6 options):
  1. **PayPal**: Blue icon, email address
  2. **Google Pay**: Blue icon, email address
  3. **Apple Pay**: Black icon, email address
  4. **Mastercard**: Orange icon, card ending 4679 (selected by default)
  5. **Visa**: Blue icon, card ending 5567
  6. **American Express**: Blue icon, card ending 8456
- **Selection**:
  - Green border and checkmark for selected method
  - Tappable to change selection
- **Confirm Button** (bottom):
  - Green, full-width
  - Text: "Confirm Top Up - $250.00"
  - Opens success dialog

**Navigation Flow**: 
- `ChooseTopUpMethodScreen` → Top Up Success Dialog (on Confirm)

---

### 8.3 Top Up Success Dialog
**Purpose**: Confirm successful top-up transaction

**Functionality**:
- Blurred background overlay
- White dialog with rounded corners
- **Success Icon**: Green circle with white checkmark
- **Title**: "Top Up Successful!" (bold)
- **Message**: "You've successfully added $250.00 to your GoRide Wallet."
- **OK Button**:
  - Green, full-width
  - Closes dialog and navigates back to Account screen

**Navigation Flow**: 
- Success Dialog → `AccountScreen` (on OK, via back navigation)

---

### 8.4 Top Up Details Screen (`top_up_details_screen.dart`)
**Purpose**: View details of a top-up transaction

**Functionality**:
- **App Bar**: "Top Up Details" title
- **Top Up Amount Card**:
  - Large green plus icon in circle
  - Amount: "$250.00" (large, bold)
  - "GoRide Wallet" text
  - "From Mastercard (.... 4679)" payment source
- **Transaction Details Card**:
  - Status: "Completed" (green badge)
  - Payment: Payment method with card details
  - Date: "Dec 18, 2024"
  - Time: "20:35 PM"
  - Transaction ID: "TRX1218242035" with copy icon
- **Share Receipt Button**:
  - Green outlined button
  - Opens share receipt modal (same as ride details)

**Navigation Flow**: 
- `TopUpDetailsScreen` → Share Receipt Modal (Share Receipt button)

---

## 9. Technical Features

### 9.1 Responsive Design
- All screens use `clampDouble` function for responsive sizing
- Font sizes, spacing, and dimensions scale based on screen size
- Minimum and maximum constraints for consistency

### 9.2 Navigation Patterns
- **Push Navigation**: For forward navigation (e.g., Auth → Sign Up)
- **Push Replacement**: For replacing current screen (e.g., Splash → Onboarding)
- **Push and Remove Until**: For clearing navigation stack (e.g., after login)
- **Modal Bottom Sheets**: For overlays (e.g., Schedule Ride, Share Receipt)

### 9.3 State Management
- Uses `StatefulWidget` for local state
- `setState` for UI updates
- Controllers for text inputs
- Focus nodes for OTP fields

### 9.4 Data Handling
- Safe type parsing for prices (double, String, int)
- Date formatting with `intl` package
- Sample data for demonstration

### 9.5 Custom Components
- Custom painters for logos (GoRide, Google)
- Custom clippers for curved shapes
- Custom painters for dashed lines
- Reusable UI components

### 9.6 Platform Support
- Mobile (Android/iOS) with `google_maps_flutter`
- Web support with `google_maps_flutter_web`
- Requires Google Maps API key in `web/index.html`

---

## 10. Complete User Journey

### 10.1 New User Flow
1. **Splash Screen** (3 seconds) → Onboarding
2. **Onboarding** (3 pages) → Auth Screen
3. **Auth Screen** → Sign Up
4. **Sign Up** → OTP Verification
5. **OTP Screen** → Profile Completion
6. **Profile Completion** → Home Page

### 10.2 Returning User Flow
1. **Splash Screen** (3 seconds) → Onboarding (if first time) or Auth
2. **Auth Screen** → Sign In
3. **Sign In** → OTP Verification
4. **OTP Screen** → Home Page

### 10.3 Ride Booking Flow
1. **Home Page** → Tap destination area
2. **Destination Screen** → Select destination
3. **Pickup Location Screen** → Confirm pickup
4. **Ride Selection Screen** → Select ride, promo, payment, schedule (optional)
5. **Driver Search Screen** (3 seconds) → Driver En Route
6. **Driver En Route Screen** (10 seconds) → Trip Completed
7. **Trip Completed Screen** → Rate Driver
8. **Driver Rating Screen** → Feedback Confirmation
9. **Feedback Confirmation** → Home Page

### 10.4 Scheduled Ride Flow
1. **Ride Selection Screen** → Schedule Ride
2. **Schedule Ride Screen** → Set date/time
3. **Ride Selection Screen** → Schedule GoRide Car button
4. **Ride Scheduled Confirmation** → Home Page
5. **Activity Screen** → Scheduled tab → View details
6. **Ride Details Screen** → Driver found (after 10 seconds) → Continue as normal ride

### 10.5 Account Management Flow
1. **Home Page** → Account tab
2. **Account Screen** → Profile section → Personal Info
3. **Account Screen** → Saved Addresses → Add/Edit Address
4. **Account Screen** → Top Up → Choose Method → Success

---

## 11. Key Features Summary

### Authentication & Onboarding
✅ Splash screen with branding
✅ 3-page onboarding walkthrough
✅ Social login (Google, Apple, Facebook, X)
✅ Phone number sign up/sign in
✅ OTP verification with auto-advance
✅ Profile completion after sign up

### Ride Booking
✅ Destination search and selection
✅ Pickup location confirmation
✅ Multiple ride types (Car, Car XL, Car Plus)
✅ Promo code application
✅ Payment method selection
✅ Ride scheduling for future
✅ Real-time driver search
✅ Driver tracking and information
✅ In-app messaging with driver
✅ Voice and video calls with driver

### Ride Management
✅ Ongoing ride tracking
✅ Scheduled rides management
✅ Completed rides history
✅ Cancelled rides with refund info
✅ Ride details with status badges
✅ Share receipt functionality
✅ Driver rating and feedback

### Account Features
✅ Personal information management
✅ Profile picture editing
✅ Saved addresses (add, edit, delete)
✅ Wallet balance display
✅ Top-up with multiple payment methods
✅ Transaction history
✅ Account settings navigation

### UI/UX Features
✅ Responsive design across screen sizes
✅ Consistent green theme (#4CAF50)
✅ Smooth navigation transitions
✅ Modal bottom sheets for overlays
✅ Blurred backgrounds for modals
✅ Loading states and animations
✅ Empty state messages
✅ Confirmation dialogs
✅ Snackbar notifications

---

## 12. File Structure

```
lib/
├── main.dart                          # App entry point
├── splash_screen.dart                 # Initial loading screen
├── onboarding_screen.dart             # Feature walkthrough
├── auth_screen.dart                   # Authentication hub
├── signup_screen.dart                 # User registration
├── signin_screen.dart                 # User login
├── otp_screen.dart                    # OTP verification
├── profile_completion_screen.dart     # Complete profile
├── home_page.dart                     # Main map interface
├── destination_screen.dart            # Destination selection
├── pickup_location_screen.dart        # Pickup confirmation
├── ride_selection_screen.dart         # Choose ride type
├── promos_screen.dart                 # Browse promos
├── payment_method_screen.dart         # Select payment
├── schedule_ride_screen.dart          # Schedule future ride
├── ride_scheduled_confirmation_screen.dart
├── driver_search_screen.dart          # Finding driver
├── driver_en_route_screen.dart        # Driver heading to pickup
├── driver_information_screen.dart     # Driver profile
├── driver_chat_screen.dart            # Text messaging
├── driver_voice_call_screen.dart      # Voice call
├── driver_video_call_screen.dart      # Video call
├── trip_completed_screen.dart         # Trip summary
├── driver_rating_screen.dart          # Rate driver
├── feedback_confirmation_screen.dart  # Feedback confirmation
├── cancel_ride_reason_screen.dart     # Cancel reason selection
├── ride_cancellation_confirmation_screen.dart
├── activity_screen.dart               # Ride history
├── ride_details_screen.dart           # Detailed ride view
├── account_screen.dart                # Account dashboard
├── personal_info_screen.dart          # Personal information
├── saved_addresses_screen.dart        # Address management
├── add_address_screen.dart            # Add/edit address
├── top_up_screen.dart                 # Add funds
├── choose_top_up_method_screen.dart   # Select payment for top-up
└── top_up_details_screen.dart         # Top-up transaction details
```

---

## 13. Data Models & State

### Ride Data Structure
```dart
{
  'destination': String,
  'rideType': String ('car' or 'scooter'),
  'bookedDate': DateTime,
  'scheduledDate': DateTime?,
  'completedDate': DateTime?,
  'cancelledDate': DateTime?,
  'fare': double,
  'originalFare': double?,
  'driverTip': double?,
  'totalPaid': double?,
  'paymentMethod': String,
  'pickup': String,
  'transactionId': String,
  'bookingId': String,
  'status': String ('scheduled', 'completed', 'cancelled'),
  'driver': Map<String, dynamic>? {
    'name': String,
    'rating': double,
    'vehicle': String,
    'vehicleColor': String,
    'licensePlate': String,
  }
}
```

### Top-Up Transaction Structure
```dart
{
  'amount': double,
  'date': DateTime,
  'paymentMethod': String,
  'cardLast4': String?,
  'transactionId': String,
  'status': String ('completed'),
}
```

### Address Structure
```dart
{
  'name': String,
  'address': String,
  'id': String,
}
```

---

## 14. Navigation Map

```
SplashScreen
    ↓
OnboardingScreen
    ↓
AuthScreen
    ├─→ SignUpScreen → OtpScreen → ProfileCompletionScreen → MyHomePage
    └─→ SignInScreen → OtpScreen → MyHomePage

MyHomePage
    ├─→ DestinationScreen → PickupLocationScreen → RideSelectionScreen
    │       ├─→ PromosScreen
    │       ├─→ PaymentMethodScreen
    │       ├─→ ScheduleRideScreen
    │       ├─→ DriverSearchScreen → DriverEnRouteScreen
    │       │       ├─→ DriverInformationScreen
    │       │       │   ├─→ DriverChatScreen
    │       │       │   │   ├─→ DriverVoiceCallScreen
    │       │       │   │   └─→ DriverVideoCallScreen
    │       │       │   └─→ DriverVoiceCallScreen
    │       │       ├─→ DriverChatScreen
    │       │       ├─→ DriverVoiceCallScreen
    │       │       ├─→ CancelRideReasonScreen → RideCancellationConfirmationScreen
    │       │       └─→ TripCompletedScreen → DriverRatingScreen → FeedbackConfirmationScreen
    │       └─→ RideScheduledConfirmationScreen
    ├─→ ActivityScreen
    │   ├─→ DriverEnRouteScreen (Track Route)
    │   ├─→ RideDetailsScreen
    │   └─→ TopUpDetailsScreen
    └─→ AccountScreen
        ├─→ PersonalInfoScreen
        ├─→ TopUpScreen → ChooseTopUpMethodScreen → (Success Dialog)
        └─→ SavedAddressesScreen
            └─→ AddAddressScreen
```

---

This documentation covers all functionalities from authentication through account management. Each screen includes detailed descriptions of features, navigation flows, and user interactions.

