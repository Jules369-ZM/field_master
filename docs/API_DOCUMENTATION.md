# Field Master - API Documentation

## Overview

This document describes the API endpoints and data structures used by the Field Master application. The application uses Firebase services as the backend, with local repositories for offline functionality.

## Authentication APIs

### Firebase Authentication

#### Login
- **Endpoint**: Firebase Auth REST API
- **Method**: POST
- **Purpose**: User authentication
- **Request Body**:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "returnSecureToken": true
}
```

#### Register
- **Endpoint**: Firebase Auth REST API
- **Method**: POST
- **Purpose**: User registration
- **Request Body**:
```json
{
  "email": "newuser@example.com",
  "password": "password123",
  "displayName": "John Doe"
}
```

#### Password Reset
- **Endpoint**: Firebase Auth REST API
- **Method**: POST
- **Purpose**: Send password reset email

## Firestore Collections

### 1. Users Collection (`/users/{userId}`)

#### User Document Structure
```json
{
  "id": "user123",
  "email": "user@example.com",
  "displayName": "John Doe",
  "role": "technician|admin|customer",
  "phoneNumber": "+1234567890",
  "profileImageUrl": "https://example.com/image.jpg",
  "isActive": true,
  "createdAt": "2023-01-01T00:00:00Z",
  "updatedAt": "2023-01-01T00:00:00Z",
  "lastLocation": {
    "latitude": -15.3875,
    "longitude": 28.3228,
    "timestamp": "2023-01-01T00:00:00Z"
  },
  "skills": ["electrical", "plumbing", "hvac"],
  "certifications": ["license123", "cert456"]
}
```

### 2. Service Requests Collection (`/serviceRequests/{requestId}`)

#### Service Request Document Structure
```json
{
  "id": "req123",
  "title": "Water Heater Repair",
  "description": "Hot water not working in master bathroom",
  "status": "pending|assigned|in_progress|completed|cancelled",
  "priority": "low|medium|high|urgent",
  "customerId": "customer123",
  "technicianId": "tech456",
  "assignedAt": "2023-01-01T10:00:00Z",
  "scheduledFor": "2023-01-02T09:00:00Z",
  "completedAt": "2023-01-02T11:30:00Z",
  "location": {
    "address": "123 Main St, Lusaka, Zambia",
    "latitude": -15.3875,
    "longitude": 28.3228,
    "instructions": "Ring doorbell twice"
  },
  "attachments": [
    {
      "type": "image|document|signature",
      "url": "https://storage.googleapis.com/bucket/file.jpg",
      "uploadedAt": "2023-01-01T12:00:00Z"
    }
  ],
  "notes": [
    {
      "content": "Customer reported no hot water",
      "authorId": "customer123",
      "createdAt": "2023-01-01T11:00:00Z"
    }
  ],
  "estimatedDuration": 120,
  "actualDuration": 90,
  "cost": {
    "labor": 150.00,
    "materials": 75.50,
    "total": 225.50,
    "currency": "ZMW"
  },
  "rating": {
    "score": 5,
    "feedback": "Excellent service, very professional",
    "ratedAt": "2023-01-02T12:00:00Z"
  },
  "createdAt": "2023-01-01T10:00:00Z",
  "updatedAt": "2023-01-02T12:00:00Z"
}
```

### 3. Analytics Collection (`/analytics/{date}`)

#### Analytics Document Structure
```json
{
  "date": "2023-01-01",
  "totalRequests": 45,
  "completedRequests": 42,
  "pendingRequests": 3,
  "averageCompletionTime": 2.5,
  "technicianStats": {
    "tech1": {
      "requestsCompleted": 8,
      "averageRating": 4.8,
      "totalEarnings": 1200.00
    }
  },
  "revenue": {
    "total": 8750.00,
    "byService": {
      "electrical": 3200.00,
      "plumbing": 2800.00,
      "hvac": 2750.00
    }
  },
  "customerSatisfaction": {
    "averageRating": 4.6,
    "totalRatings": 42
  }
}
```

## Local Data Models

### 1. Offline Service Requests
- **Storage**: Local SQLite database
- **Purpose**: Enable offline functionality
- **Sync**: Automatic sync when connection restored

### 2. Cached User Data
- **Storage**: Shared Preferences / Local Storage
- **Purpose**: Quick app startup and offline access
- **Encryption**: Sensitive data encrypted

## Repository Interfaces

### AuthRepository
```dart
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String displayName);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<User> getCurrentUser();
  Stream<User> get user;
}
```

### ServiceRequestRepository
```dart
abstract class ServiceRequestRepository {
  Future<List<ServiceRequest>> getServiceRequests();
  Future<ServiceRequest> getServiceRequest(String id);
  Future<ServiceRequest> createServiceRequest(ServiceRequest request);
  Future<ServiceRequest> updateServiceRequest(ServiceRequest request);
  Future<void> deleteServiceRequest(String id);
  Stream<List<ServiceRequest>> getServiceRequestsStream();
}
```

### LocationRepository
```dart
abstract class LocationRepository {
  Future<Position> getCurrentLocation();
  Stream<Position> getLocationStream();
  Future<bool> checkLocationPermission();
  Future<bool> requestLocationPermission();
}
```

## Error Handling

### Standard Error Response Format
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": {
      "field": "specific_field",
      "issue": "specific_issue"
    }
  }
}
```

### Common Error Codes
- `AUTH_INVALID_CREDENTIALS`: Invalid email or password
- `AUTH_USER_NOT_FOUND`: User account not found
- `AUTH_EMAIL_ALREADY_EXISTS`: Email already registered
- `PERMISSION_DENIED`: Insufficient permissions
- `NOT_FOUND`: Requested resource not found
- `NETWORK_ERROR`: Network connectivity issues
- `VALIDATION_ERROR`: Invalid data provided

## Real-time Updates

### Firestore Listeners
- **Users**: Listen for profile updates
- **Service Requests**: Real-time status updates
- **Location**: Technician location tracking
- **Analytics**: Live dashboard updates

### Push Notifications
- **Service Updates**: Status changes, assignments
- **Messages**: Customer-technician communication
- **Reminders**: Scheduled service alerts

## File Upload

### Firebase Storage Structure
```
field-master/
├── profile-images/
│   └── {userId}/
├── service-attachments/
│   └── {requestId}/
└── signatures/
    └── {requestId}/
```

### Upload Limits
- **Images**: Max 10MB per file
- **Documents**: Max 25MB per file
- **Total Attachments**: Max 10 files per request

## Rate Limiting

### API Limits
- **Authentication**: 10 requests per minute
- **Data Operations**: 100 requests per minute
- **File Uploads**: 50 uploads per hour

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2023-01-01 | Initial API version |
| 1.1.0 | 2023-03-01 | Added analytics endpoints |

---

*This API documentation is maintained alongside the application code and should be updated with any backend changes.*
