# 🚀 Next Feature Analysis - Ride Booking System

## 📊 Current Status

### ✅ Completed
- **Authentication Flow** - Fully implemented with Clean Architecture + BLoC
  - Sign Up / Sign In
  - OTP Verification
  - Profile Completion
  - Social Login (UI ready)
  - Token Management

### 🎯 Next Feature: **Ride Booking System**

This is the **core functionality** of the ride-sharing app and should be implemented next.

---

## 📱 Flutter UI Analysis

### Existing Screens (UI Ready, No Backend Integration):

#### 1. **Home Page** (`home_page.dart`)
- ✅ Google Maps integration
- ✅ "Where to?" search bar
- ✅ Quick destination buttons (Home, Office, Apartment, Mom's H)
- ✅ Bottom navigation (Home, Promos, Activity, Account)
- ✅ Map controls
- ❌ **Missing**: Backend integration for location search

#### 2. **Destination Screen** (`destination_screen.dart`)
- ✅ Location search input
- ✅ Recent destinations list
- ✅ Suggested places
- ✅ Recent/Suggested toggle
- ✅ Distance calculation display
- ❌ **Missing**: 
  - Backend API for location search
  - Backend API for recent destinations
  - Navigation to pickup location screen

#### 3. **Pickup Location Screen** (`pickup_location_screen.dart`)
- ✅ Map with location selection
- ✅ Search bar for pickup location
- ✅ Current location button
- ✅ Selected location display
- ❌ **Missing**: Backend integration

#### 4. **Ride Selection Screen** (`ride_selection_screen.dart`)
- ✅ Multiple ride types:
  - GoRide Car ($12.50)
  - GoRide Car XL ($15.00)
  - GoRide Car Plus ($16.50)
- ✅ Promo code selection
- ✅ Payment method selection
- ✅ Schedule ride option
- ✅ Price calculation with discounts
- ✅ "Book Ride" button
- ❌ **Missing**: 
  - Backend API for ride booking
  - Backend API for price estimation
  - Backend API for promo validation

#### 5. **Driver Search Screen** (`driver_search_screen.dart`)
- ✅ Driver searching animation
- ✅ Map with driver location
- ✅ Estimated arrival time
- ❌ **Missing**: 
  - Backend API for driver matching
  - Real-time driver location updates
  - WebSocket/SSE for live updates

#### 6. **Driver En Route Screen** (`driver_en_route_screen.dart`)
- ✅ Driver information display
- ✅ Map with route
- ✅ Contact options (call, chat, video)
- ✅ Cancel ride option
- ❌ **Missing**: 
  - Backend API for ride status
  - Real-time location tracking
  - Route calculation

#### 7. **Trip Completed Screen** (`trip_completed_screen.dart`)
- ✅ Trip summary
- ✅ Rating interface
- ✅ Payment summary
- ❌ **Missing**: 
  - Backend API for trip completion
  - Backend API for rating submission
  - Payment processing

#### 8. **Activity Screen** (`activity_screen.dart`)
- ✅ Ride history list
- ✅ Filter options
- ✅ Ride details view
- ❌ **Missing**: 
  - Backend API for ride history
  - Backend API for ride details

---

## 🎯 Recommended Implementation Order

### **Phase 1: Core Ride Booking** (Priority: HIGHEST)

#### 1.1 Location Services
**Flutter Screens:**
- `destination_screen.dart`
- `pickup_location_screen.dart`

**Backend APIs Needed:**
```
POST /api/rides/estimate-price
  - pickupLocation (lat, lng, address)
  - destinationLocation (lat, lng, address)
  - rideType (CAR, CAR_XL, CAR_PLUS)
  → Returns: estimatedPrice, estimatedDuration, distance

GET /api/locations/search?query={query}
  → Returns: list of locations (name, address, lat, lng)

POST /api/locations/recent
  → Returns: user's recent destinations

POST /api/locations/save
  - name, address, lat, lng, type (HOME, OFFICE, etc.)
  → Saves address to user's saved addresses
```

**Domain Entities:**
- `Location` (lat, lng, address, name)
- `PriceEstimate` (price, duration, distance, rideType)

---

#### 1.2 Ride Booking
**Flutter Screens:**
- `ride_selection_screen.dart`
- `driver_search_screen.dart`

**Backend APIs Needed:**
```
POST /api/rides/book
  - pickupLocation
  - destinationLocation
  - rideType
  - paymentMethodId
  - promoCode (optional)
  - scheduledDateTime (optional)
  → Returns: rideId, estimatedArrival, driver (if available)

GET /api/rides/{rideId}/status
  → Returns: ride status (PENDING, DRIVER_ASSIGNED, DRIVER_EN_ROUTE, 
                          ARRIVED, IN_PROGRESS, COMPLETED, CANCELLED)

GET /api/rides/{rideId}/driver
  → Returns: driver info, current location, ETA

POST /api/rides/{rideId}/cancel
  - reason (optional)
  → Cancels the ride
```

**Domain Entities:**
- `Ride` (id, userId, driverId, pickupLocation, destinationLocation, 
         rideType, status, price, scheduledDateTime, createdAt)
- `Driver` (id, name, phone, rating, vehicleInfo, currentLocation)
- `RideStatus` (enum)

---

#### 1.3 Real-Time Tracking
**Flutter Screens:**
- `driver_en_route_screen.dart`
- `driver_search_screen.dart`

**Backend APIs Needed:**
```
WebSocket: /ws/rides/{rideId}/track
  → Real-time updates:
     - Driver location updates
     - Ride status changes
     - ETA updates

GET /api/rides/{rideId}/route
  → Returns: polyline for route visualization
```

**Technology:**
- WebSocket or Server-Sent Events (SSE)
- Google Maps Directions API integration

---

### **Phase 2: Ride Management** (Priority: HIGH)

#### 2.1 Ride History
**Flutter Screen:**
- `activity_screen.dart`

**Backend APIs Needed:**
```
GET /api/rides/history
  - page, size
  - status filter (optional)
  - date range (optional)
  → Returns: paginated list of rides

GET /api/rides/{rideId}
  → Returns: complete ride details
```

---

#### 2.2 Ride Completion & Rating
**Flutter Screen:**
- `trip_completed_screen.dart`
- `driver_rating_screen.dart`

**Backend APIs Needed:**
```
POST /api/rides/{rideId}/complete
  → Marks ride as completed
  → Processes payment

POST /api/rides/{rideId}/rate
  - rating (1-5)
  - comment (optional)
  → Submits rating for driver
```

---

### **Phase 3: Additional Features** (Priority: MEDIUM)

#### 3.1 Promo Codes
**Flutter Screen:**
- `promos_screen.dart`
- `ride_selection_screen.dart` (promo selection)

**Backend APIs Needed:**
```
GET /api/promos/available
  → Returns: list of available promo codes

POST /api/promos/validate
  - promoCode
  → Returns: discount percentage/amount, validity
```

---

#### 3.2 Scheduled Rides
**Flutter Screen:**
- `schedule_ride_screen.dart`
- `ride_scheduled_confirmation_screen.dart`

**Backend APIs Needed:**
```
POST /api/rides/schedule
  - All booking fields
  - scheduledDateTime
  → Creates scheduled ride

GET /api/rides/scheduled
  → Returns: list of scheduled rides

DELETE /api/rides/scheduled/{rideId}
  → Cancels scheduled ride
```

---

## 🏗️ Architecture Recommendation

### **Feature Structure** (Following Auth Pattern):

```
lib/features/rides/
├── domain/
│   ├── entities/
│   │   ├── ride.dart
│   │   ├── location.dart
│   │   ├── driver.dart
│   │   ├── price_estimate.dart
│   │   └── ride_status.dart
│   ├── repositories/
│   │   └── ride_repository.dart
│   └── usecases/
│       ├── estimate_price.dart
│       ├── book_ride.dart
│       ├── get_ride_status.dart
│       ├── cancel_ride.dart
│       ├── get_ride_history.dart
│       └── rate_driver.dart
├── data/
│   ├── models/
│   │   ├── ride_model.dart
│   │   ├── location_model.dart
│   │   └── driver_model.dart
│   ├── datasources/
│   │   ├── ride_remote_data_source.dart
│   │   └── ride_local_data_source.dart
│   └── repositories_impl/
│       └── ride_repository_impl.dart
└── presentation/
    ├── bloc/
    │   ├── ride_bloc.dart
    │   ├── ride_event.dart
    │   └── ride_state.dart
    └── pages/
        ├── destination_page.dart (refactor from destination_screen.dart)
        ├── pickup_location_page.dart (refactor from pickup_location_screen.dart)
        ├── ride_selection_page.dart (refactor from ride_selection_screen.dart)
        ├── driver_search_page.dart (refactor from driver_search_screen.dart)
        ├── driver_en_route_page.dart (refactor from driver_en_route_screen.dart)
        └── trip_completed_page.dart (refactor from trip_completed_screen.dart)
```

---

## 🔧 Backend Implementation Needed

### **New Spring Boot Controllers:**

1. **RideController**
   - `/api/rides/book` - Book a ride
   - `/api/rides/{id}/status` - Get ride status
   - `/api/rides/{id}/cancel` - Cancel ride
   - `/api/rides/history` - Get ride history
   - `/api/rides/{id}` - Get ride details
   - `/api/rides/{id}/complete` - Complete ride
   - `/api/rides/{id}/rate` - Rate driver

2. **LocationController**
   - `/api/locations/search` - Search locations
   - `/api/locations/recent` - Get recent destinations
   - `/api/locations/save` - Save address

3. **PriceController**
   - `/api/rides/estimate-price` - Estimate ride price

4. **WebSocket Controller**
   - `/ws/rides/{id}/track` - Real-time ride tracking

### **New Database Tables:**

```sql
-- Rides table
CREATE TABLE rides (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    driver_id BIGINT REFERENCES drivers(id),
    pickup_lat DECIMAL(10, 8),
    pickup_lng DECIMAL(11, 8),
    pickup_address TEXT,
    destination_lat DECIMAL(10, 8),
    destination_lng DECIMAL(11, 8),
    destination_address TEXT,
    ride_type VARCHAR(20),
    status VARCHAR(20),
    price DECIMAL(10, 2),
    scheduled_datetime TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Drivers table
CREATE TABLE drivers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    vehicle_type VARCHAR(50),
    vehicle_number VARCHAR(20),
    license_number VARCHAR(50),
    rating DECIMAL(3, 2),
    is_available BOOLEAN,
    current_lat DECIMAL(10, 8),
    current_lng DECIMAL(11, 8)
);

-- Saved addresses table
CREATE TABLE saved_addresses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    name VARCHAR(100),
    address TEXT,
    lat DECIMAL(10, 8),
    lng DECIMAL(11, 8),
    type VARCHAR(20),
    created_at TIMESTAMP
);
```

---

## 📋 Implementation Checklist

### **Phase 1: Core Ride Booking**
- [ ] Backend: Create Ride entity and repository
- [ ] Backend: Create Location entity and repository
- [ ] Backend: Implement price estimation API
- [ ] Backend: Implement location search API
- [ ] Backend: Implement ride booking API
- [ ] Backend: Implement ride status API
- [ ] Flutter: Create rides feature structure (domain, data, presentation)
- [ ] Flutter: Refactor destination_screen.dart to destination_page.dart with BLoC
- [ ] Flutter: Refactor pickup_location_screen.dart to pickup_location_page.dart with BLoC
- [ ] Flutter: Refactor ride_selection_screen.dart to ride_selection_page.dart with BLoC
- [ ] Flutter: Integrate with backend APIs
- [ ] Flutter: Add real-time tracking (WebSocket/SSE)

### **Phase 2: Ride Management**
- [ ] Backend: Implement ride history API
- [ ] Backend: Implement ride completion API
- [ ] Backend: Implement rating API
- [ ] Flutter: Refactor activity_screen.dart to activity_page.dart with BLoC
- [ ] Flutter: Refactor trip_completed_screen.dart to trip_completed_page.dart with BLoC
- [ ] Flutter: Integrate with backend APIs

### **Phase 3: Additional Features**
- [ ] Backend: Implement promo code APIs
- [ ] Backend: Implement scheduled rides APIs
- [ ] Flutter: Refactor remaining screens
- [ ] Flutter: Integrate with backend APIs

---

## 🎯 Next Steps

1. **Start with Phase 1.1: Location Services**
   - This is the foundation for ride booking
   - Relatively simple to implement
   - Can be tested independently

2. **Then Phase 1.2: Ride Booking**
   - Core functionality
   - Requires location services
   - Most critical feature

3. **Finally Phase 1.3: Real-Time Tracking**
   - Enhances user experience
   - Requires WebSocket setup
   - Can be added incrementally

---

## 📝 Notes

- All existing UI screens are well-designed and ready for backend integration
- Follow the same Clean Architecture + BLoC pattern used in authentication
- Consider using Google Maps Places API for location search
- Consider using Google Directions API for route calculation
- Real-time tracking can use WebSocket or Server-Sent Events (SSE)
- Payment processing can be integrated later (stripe, paypal, etc.)

---

**Ready to start with Phase 1.1: Location Services?** 🚀

