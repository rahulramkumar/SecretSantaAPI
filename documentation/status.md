# Status

Status endpoint, always returns 200.

**URL** : `/status`

**Method** : `GET`

**Auth required** : No

## Success Response

**Code** : `200 OK`

**Content example**

```json
"OK"
```

## Error Response

**Condition** : Lambda is unreachable

**Code** : Probably something non 200, depends on why the Lambda is unreachable