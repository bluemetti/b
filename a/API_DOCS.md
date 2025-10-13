# 📚 API Documentation

## Base URL
```
Local: http://localhost:3001
Production: https://your-app-domain.com
```

## Response Format

All API responses follow this structure:

### Success Response
```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": {
    // Response data
  }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error description",
  "error": "ERROR_CODE",
  "errors": [
    // Array of detailed errors (when applicable)
  ]
}
```

## Authentication

Protected routes require a JWT token in the Authorization header:
```
Authorization: Bearer <your-jwt-token>
```

## Endpoints

### 🟢 Health Check

**GET** `/health`

Check if the API is running.

**Response (200)**
```json
{
  "success": true,
  "message": "Server is running!",
  "timestamp": "2024-10-13T10:30:00.000Z",
  "environment": "development"
}
```

---

### 🔓 Register User

**POST** `/register`

Create a new user account.

**Request Body**
```json
{
  "name": "string (required, 2-50 chars)",
  "email": "string (required, valid email)",
  "password": "string (required, min 6 chars)"
}
```

**Success Response (201)**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "507f1f77bcf86cd799439011",
      "name": "João Silva",
      "email": "joao.silva@email.com",
      "createdAt": "2024-10-13T10:30:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Error Responses**

**400 - Validation Error**
```json
{
  "success": false,
  "message": "Validation failed",
  "error": "VALIDATION_ERROR",
  "errors": [
    {
      "field": "email",
      "message": "Please provide a valid email address"
    }
  ]
}
```

**409 - Duplicate Email**
```json
{
  "success": false,
  "message": "User with this email already exists",
  "error": "DUPLICATE_EMAIL"
}
```

---

### 🔓 Login User

**POST** `/login`

Authenticate a user and get JWT token.

**Request Body**
```json
{
  "email": "string (required, valid email)",
  "password": "string (required)"
}
```

**Success Response (200)**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "507f1f77bcf86cd799439011",
      "name": "João Silva",
      "email": "joao.silva@email.com",
      "createdAt": "2024-10-13T10:30:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Error Responses**

**400 - Validation Error**
```json
{
  "success": false,
  "message": "Validation failed",
  "error": "VALIDATION_ERROR",
  "errors": [
    {
      "field": "email",
      "message": "Please provide a valid email address"
    }
  ]
}
```

**401 - Invalid Credentials**
```json
{
  "success": false,
  "message": "Invalid email or password",
  "error": "INVALID_CREDENTIALS"
}
```

---

### 🔒 Protected Route

**GET** `/protected`

Access a protected resource (requires authentication).

**Headers**
```
Authorization: Bearer <jwt-token>
```

**Success Response (200)**
```json
{
  "success": true,
  "message": "Acesso autorizado",
  "data": {
    "message": "Você acessou uma rota protegida com sucesso!",
    "user": {
      "userId": "507f1f77bcf86cd799439011",
      "email": "joao.silva@email.com"
    },
    "timestamp": "2024-10-13T10:30:00.000Z"
  }
}
```

**Error Responses**

**401 - Missing Token**
```json
{
  "success": false,
  "message": "Access denied. No token provided.",
  "error": "MISSING_TOKEN"
}
```

**401 - Invalid Token**
```json
{
  "success": false,
  "message": "Access denied. Invalid token.",
  "error": "INVALID_TOKEN"
}
```

---

## Error Codes

| Code | Description |
|------|-------------|
| `VALIDATION_ERROR` | Input validation failed |
| `DUPLICATE_EMAIL` | Email already exists in system |
| `INVALID_CREDENTIALS` | Wrong email or password |
| `MISSING_TOKEN` | Authorization token not provided |
| `INVALID_TOKEN_FORMAT` | Token format is incorrect |
| `INVALID_TOKEN` | Token is invalid or expired |
| `INVALID_JSON` | Request body is not valid JSON |
| `NOT_FOUND` | Route not found |
| `INTERNAL_ERROR` | Server internal error |

## HTTP Status Codes

| Status | Description |
|--------|-------------|
| 200 | OK - Request successful |
| 201 | Created - Resource created successfully |
| 400 | Bad Request - Invalid input data |
| 401 | Unauthorized - Authentication required |
| 404 | Not Found - Route not found |
| 409 | Conflict - Resource already exists |
| 500 | Internal Server Error - Server error |

## Request Examples

### Using cURL

```bash
# Register
curl -X POST http://localhost:3001/register \
  -H "Content-Type: application/json" \
  -d '{"name":"João Silva","email":"joao@email.com","password":"senha123"}'

# Login
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{"email":"joao@email.com","password":"senha123"}'

# Protected route
curl -X GET http://localhost:3000/protected \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Using JavaScript (Fetch)

```javascript
// Register
const registerResponse = await fetch('http://localhost:3000/register', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    name: 'João Silva',
    email: 'joao@email.com',
    password: 'senha123'
  })
});

// Login
const loginResponse = await fetch('http://localhost:3000/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    email: 'joao@email.com',
    password: 'senha123'
  })
});

const { data } = await loginResponse.json();
const token = data.token;

// Protected route
const protectedResponse = await fetch('http://localhost:3000/protected', {
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${token}`
  }
});
```

### Using Python (requests)

```python
import requests

# Register
register_data = {
    "name": "João Silva",
    "email": "joao@email.com",
    "password": "senha123"
}
register_response = requests.post('http://localhost:3000/register', json=register_data)

# Login
login_data = {
    "email": "joao@email.com",
    "password": "senha123"
}
login_response = requests.post('http://localhost:3000/login', json=login_data)
token = login_response.json()['data']['token']

# Protected route
headers = {'Authorization': f'Bearer {token}'}
protected_response = requests.get('http://localhost:3000/protected', headers=headers)
```

## Rate Limiting

Currently, there are no rate limits implemented. For production, consider implementing rate limiting using packages like `express-rate-limit`.

## CORS

The API accepts requests from:
- Development: `http://localhost:3000`, `http://localhost:3001`, `http://127.0.0.1:3000`
- Production: Configure allowed origins in environment variables

## Security Features

- ✅ Password hashing with bcrypt (12 salt rounds)
- ✅ JWT token authentication
- ✅ Input validation and sanitization
- ✅ Security headers with Helmet
- ✅ CORS configuration
- ✅ Error handling without sensitive data exposure

## Data Models

### User Model
```typescript
{
  _id: ObjectId,
  name: string (2-50 chars),
  email: string (unique, valid email),
  password: string (hashed, min 6 chars, not selectable),
  createdAt: Date,
  updatedAt: Date
}
```

### JWT Payload
```typescript
{
  userId: string,
  email: string,
  iat: number,
  exp: number
}
```
