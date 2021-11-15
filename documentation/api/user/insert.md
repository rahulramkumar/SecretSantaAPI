# Insert User

Insert a User

**URL**: `/api/user/insert`

**Method**: `POST`

**Auth required**: Yes

**Data Constraints**:  
Header: `Content-Type: application/json`
```json
{
  "name": "name to insert"
}
```

## Success Response

**Code**: `201 CREATED`

## Error Response

**Code**: `400` or `500` depending on whether you gave me a garbage request or I'm too dumb to handle it properly.