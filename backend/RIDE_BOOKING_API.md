# Ride Booking API Documentation

## Overview

This document describes the ride booking APIs implemented in the OurRide backend.

## Base URL
```
http://localhost:8080/api
```

---

## Location APIs

### 1. Search Locations
**Endpoint:** `POST /api/locations/search`  
**Authentication:** Not required (but can be enhanced with Google Places API)

**Request Body:**
```json
{
  "query": "New York University",
  "latitude": 40.7295,
  "longitude": -73.9965
}
```

**Response:**
```json
[
  {
    "name": "New York University",
    "address": "70 Washington Square S, New York, NY 10012",
    "latitude": 40.7295,
    "longitude": -73.9965,
    "distance": 0.4
  }
]
```

**Note:** Currently returns empty array. In production, integrate with Google Places API.

---

### 2. Get Recent Destinations
**Endpoint:** `GET /api/locations/recent`  
**Authentication:** Required (Bearer token)

**Response:**
```json
[
  {
    "name": "Home",
    "address": "85 4th Ave, New York, NY 10003",
    "latitude": 40.7295,
    "longitude": -73.9965
  }
]
```

---

### 3. Save Address
**Endpoint:** `POST /api/locations/save`  
**Authentication:** Required (Bearer token)

**Request Body:**
```json
{
  "name": "Home",
  "address": "85 4th Ave, New York, NY 10003, United States",
  "latitude": 40.7295,
  "longitude": -73.9965,
  "type": "HOME"
}
```

**Response:**
```json
{
  "id": 1,
  "name": "Home",
  "address": "85 4th Ave, New York, NY 10003, United States",
  "latitude": 40.7295,
  "longitude": -73.9965,
  "type": "HOME",
  "createdAt": "2024-12-08T10:00:00"
}
```

**Address Types:** `HOME`, `OFFICE`, `APARTMENT`, `OTHER`

---

### 4. Get Saved Addresses
**Endpoint:** `GET /api/locations/saved`  
**Authentication:** Required (Bearer token)

**Response:**
```json
[
  {
    "id": 1,
    "name": "Home",
    "address": "85 4th Ave, New York, NY 10003",
    "latitude": 40.7295,
    "longitude": -73.9965,
    "type": "HOME",
    "createdAt": "2024-12-08T10:00:00"
  }
]
```

---

### 5. Delete Saved Address
**Endpoint:** `DELETE /api/locations/saved/{id}`  
**Authentication:** Required (Bearer token)

**Response:**
```json
{
  "message": "Address deleted successfully"
}
```

---

## Ride APIs

### 1. Estimate Price
**Endpoint:** `POST /api/rides/estimate-price`  
**Authentication:** Not required

**Request Body:**
```json
{
  "pickupLatitude": 40.7295,
  "pickupLongitude": -73.9965,
  "destinationLatitude": 40.7308,
  "destinationLongitude": -73.9973,
  "rideType": "CAR"
}
```

**Response:**
```json
{
  "price": 12.50,
  "distanceKm": 0.15,
  "estimatedDurationMinutes": 3,
  "rideType": "CAR"
}
```

**Ride Types:** `CAR`, `CAR_XL`, `CAR_PLUS`

**Pricing:**
- CAR: $1.50/km (minimum $5.00)
- CAR_XL: $2.00/km (minimum $5.00)
- CAR_PLUS: $2.25/km (minimum $5.00)

---

### 2. Book Ride
**Endpoint:** `POST /api/rides/book`  
**Authentication:** Required (Bearer token)

**Request Body:**
```json
{
  "pickupLatitude": 40.7295,
  "pickupLongitude": -73.9965,
  "pickupAddress": "85 4th Ave, New York, NY 10003",
  "destinationLatitude": 40.7308,
  "destinationLongitude": -73.9973,
  "destinationAddress": "Washington Square Park, New York, NY",
  "rideType": "CAR",
  "price": 12.50,
  "scheduledDateTime": null
}
```

**Response:**
```json
{
  "id": 1,
  "userId": 1,
  "driverId": 1,
  "pickupLatitude": 40.7295,
  "pickupLongitude": -73.9965,
  "pickupAddress": "85 4th Ave, New York, NY 10003",
  "destinationLatitude": 40.7308,
  "destinationLongitude": -73.9973,
  "destinationAddress": "Washington Square Park, New York, NY",
  "rideType": "CAR",
  "status": "DRIVER_ASSIGNED",
  "price": 12.50,
  "distanceKm": 0.15,
  "estimatedDurationMinutes": 3,
  "scheduledDateTime": null,
  "startedAt": null,
  "completedAt": null,
  "cancelledAt": null,
  "cancellationReason": null,
  "createdAt": "2024-12-08T10:00:00",
  "updatedAt": "2024-12-08T10:00:00",
  "driver": {
    "id": 1,
    "name": "John Driver",
    "phoneNumber": "+11234567890",
    "rating": 4.8,
    "vehicleType": "CAR",
    "vehicleNumber": "ABC-1234",
    "currentLatitude": 40.7300,
    "currentLongitude": -73.9960
  }
}
```

**Ride Statuses:**
- `PENDING` - Ride booked, waiting for driver
- `DRIVER_ASSIGNED` - Driver assigned to ride
- `DRIVER_EN_ROUTE` - Driver heading to pickup
- `ARRIVED` - Driver arrived at pickup
- `IN_PROGRESS` - Ride in progress
- `COMPLETED` - Ride completed
- `CANCELLED` - Ride cancelled

---

### 3. Get Ride by ID
**Endpoint:** `GET /api/rides/{id}`  
**Authentication:** Required (Bearer token)

**Response:**
```json
{
  "id": 1,
  "userId": 1,
  "driverId": 1,
  "status": "DRIVER_ASSIGNED",
  ...
}
```

---

### 4. Get Ride History
**Endpoint:** `GET /api/rides/history?page=0&size=20`  
**Authentication:** Required (Bearer token)

**Query Parameters:**
- `page` (default: 0) - Page number
- `size` (default: 20) - Page size

**Response:**
```json
[
  {
    "id": 1,
    "status": "COMPLETED",
    "price": 12.50,
    ...
  }
]
```

---

### 5. Cancel Ride
**Endpoint:** `POST /api/rides/{id}/cancel`  
**Authentication:** Required (Bearer token)

**Request Body (optional):**
```json
{
  "reason": "Change of plans"
}
```

**Response:**
```json
{
  "id": 1,
  "status": "CANCELLED",
  "cancelledAt": "2024-12-08T10:05:00",
  "cancellationReason": "Change of plans",
  ...
}
```

---

## Error Responses

All endpoints return standard error responses:

```json
{
  "success": false,
  "message": "Error message here"
}
```

**Common HTTP Status Codes:**
- `200` - Success
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (missing/invalid token)
- `404` - Not Found
- `500` - Internal Server Error

---

## Database Schema

### saved_addresses
- `id` (BIGSERIAL PRIMARY KEY)
- `user_id` (BIGINT, FK to users)
- `name` (VARCHAR(100))
- `address` (TEXT)
- `latitude` (DECIMAL(10,8))
- `longitude` (DECIMAL(11,8))
- `type` (VARCHAR(20): HOME, OFFICE, APARTMENT, OTHER)
- `created_at`, `updated_at` (TIMESTAMP)

### rides
- `id` (BIGSERIAL PRIMARY KEY)
- `user_id` (BIGINT, FK to users)
- `driver_id` (BIGINT, FK to drivers, nullable)
- `pickup_latitude`, `pickup_longitude` (DECIMAL)
- `pickup_address` (TEXT)
- `destination_latitude`, `destination_longitude` (DECIMAL)
- `destination_address` (TEXT)
- `ride_type` (VARCHAR(20): CAR, CAR_XL, CAR_PLUS, MOTORBIKE, SCOOTER)
- `status` (VARCHAR(20): PENDING, DRIVER_ASSIGNED, etc.)
- `price` (DECIMAL(10,2))
- `distance_km` (DECIMAL(10,2))
- `estimated_duration_minutes` (INTEGER)
- `scheduled_datetime` (TIMESTAMP, nullable)
- `started_at`, `completed_at`, `cancelled_at` (TIMESTAMP, nullable)
- `cancellation_reason` (TEXT, nullable)
- `created_at`, `updated_at` (TIMESTAMP)

### drivers
- `id` (BIGSERIAL PRIMARY KEY)
- `user_id` (BIGINT, FK to users, UNIQUE)
- `vehicle_type` (VARCHAR(50))
- `vehicle_number` (VARCHAR(20))
- `license_number` (VARCHAR(50), UNIQUE)
- `rating` (DECIMAL(3,2), default 0.00)
- `total_rides` (INTEGER, default 0)
- `is_available` (BOOLEAN, default true)
- `current_latitude`, `current_longitude` (DECIMAL, nullable)
- `created_at`, `updated_at` (TIMESTAMP)

---

## Notes

1. **Location Search**: Currently returns empty array. In production, integrate with Google Places API.
2. **Driver Assignment**: Automatically assigns nearest available driver matching vehicle type.
3. **Price Calculation**: Uses Haversine formula for distance calculation and applies base price per km.
4. **Scheduled Rides**: Support for scheduled rides (set `scheduledDateTime` in book request).

---

## Next Steps

1. Integrate Google Places API for location search
2. Implement real-time tracking (WebSocket/SSE)
3. Add payment processing
4. Add rating system
5. Add ride completion flow

