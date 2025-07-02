# Herafi App - Server Endpoints Documentation

This document outlines the required API endpoints for the Herafi application backend server.

## Authentication Endpoints

### 1. User Registration
- **Endpoint**: `/api/auth/register`
- **Method**: POST
- **Description**: Register a new user in the system
- **Request Body**:
  ```json
  {
    "fullName": "string",
    "email": "string",
    "password": "string",
    "phoneNumber": "string",
    "userType": "string" // "craftsman" or "customer"
  }
  ```
- **Response**: 
  ```json
  {
    "status": "success",
    "message": "User registered successfully",
    "data": {
      "userId": "string",
      "token": "string"
    }
  }
  ```

### 2. User Login
- **Endpoint**: `/api/auth/login`
- **Method**: POST
- **Description**: Authenticate user and return access token
- **Request Body**:
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```
- **Response**:
  ```json
  {
    "status": "success",
    "data": {
      "token": "string",
      "user": {
        "id": "string",
        "fullName": "string",
        "email": "string",
        "userType": "string"
      }
    }
  }
  ```

## Craftsman Profile Endpoints

### 3. Create/Update Craftsman Profile
- **Endpoint**: `/api/craftsman/profile`
- **Method**: POST/PUT
- **Description**: Create or update craftsman's professional profile
- **Request Body**:
  ```json
  {
    "userId": "string",
    "profession": "string",
    "experience": "number",
    "description": "string",
    "skills": ["string"],
    "location": {
      "latitude": "number",
      "longitude": "number",
      "address": "string"
    },
    "workingHours": {
      "start": "string",
      "end": "string"
    },
    "pricing": {
      "hourlyRate": "number",
      "minimumHours": "number"
    }
  }
  ```

### 4. Get Craftsman Profile
- **Endpoint**: `/api/craftsman/profile/{craftsmanId}`
- **Method**: GET
- **Description**: Retrieve craftsman's profile information
- **Response**: Returns the complete craftsman profile

## Service Request Endpoints

### 5. Create Service Request
- **Endpoint**: `/api/services/request`
- **Method**: POST
- **Description**: Create a new service request
- **Request Body**:
  ```json
  {
    "customerId": "string",
    "craftsmanId": "string",
    "serviceType": "string",
    "description": "string",
    "location": {
      "latitude": "number",
      "longitude": "number",
      "address": "string"
    },
    "preferredDate": "string",
    "preferredTime": "string"
  }
  ```

### 6. Get Service Requests
- **Endpoint**: `/api/services/requests`
- **Method**: GET
- **Description**: Get list of service requests
- **Query Parameters**:
  - `userId`: string (optional)
  - `status`: string (optional)
  - `page`: number
  - `limit`: number

## Review and Rating Endpoints

### 7. Submit Review
- **Endpoint**: `/api/reviews`
- **Method**: POST
- **Description**: Submit a review for a completed service
- **Request Body**:
  ```json
  {
    "serviceId": "string",
    "rating": "number",
    "comment": "string",
    "userId": "string"
  }
  ```

### 8. Get Reviews
- **Endpoint**: `/api/reviews/{craftsmanId}`
- **Method**: GET
- **Description**: Get reviews for a specific craftsman
- **Query Parameters**:
  - `page`: number
  - `limit`: number

## Search and Discovery Endpoints

### 9. Search Craftsmen
- **Endpoint**: `/api/craftsmen/search`
- **Method**: GET
- **Description**: Search for craftsmen based on various criteria
- **Query Parameters**:
  - `profession`: string
  - `location`: string
  - `rating`: number
  - `priceRange`: string
  - `page`: number
  - `limit`: number

### 10. Get Available Services
- **Endpoint**: `/api/services/available`
- **Method**: GET
- **Description**: Get list of available service categories
- **Response**: Returns list of service categories and their descriptions

## Error Responses

All endpoints should return appropriate error responses in the following format:
```json
{
  "status": "error",
  "message": "Error description",
  "code": "ERROR_CODE"
}
```

## Authentication

- All endpoints except login and registration require a valid JWT token
- Include the token in the Authorization header: `Authorization: Bearer <token>`

## Rate Limiting

- Implement rate limiting for all endpoints
- Suggested limits:
  - Authentication endpoints: 5 requests per minute
  - Other endpoints: 60 requests per minute

## Security Considerations

1. All endpoints must use HTTPS
2. Implement input validation for all requests
3. Sanitize all user inputs
4. Implement proper CORS policies
5. Use secure password hashing (bcrypt recommended)
6. Implement proper session management
7. Regular security audits and monitoring 