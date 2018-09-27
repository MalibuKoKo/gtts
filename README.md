# Google Text To Speech API

## REST API

Créer un projet sur [Google Cloud Platform](https://console.cloud.google.com), activer l'[API Text To Speech](https://console.cloud.google.com/apis/library/texttospeech.googleapis.com), créer un accès de type OAuth et télécharger les [credentials](https://console.cloud.google.com/apis/dashboard).

### Détails des credentials

```json
{
  "installed": {
    "client_id": "1234567890",
    "project_id": "micros-1-1",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://www.googleapis.com/oauth2/v3/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_secret": "secret",
    "redirect_uris": [
      "urn:ietf:wg:oauth:2.0:oob",
      "http://localhost"
    ]
  }
}
```


### Autorisation d'accès

#### Obtention du code d'accès (`code`)

Visiter le lien pour obtenir le code :
[https://accounts.google.com/o/oauth2/auth?scope=https://www.googleapis.com/auth/cloud-platform&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&access_type=offline&client_id=1234567890](https://accounts.google.com/o/oauth2/auth?scope=https://www.googleapis.com/auth/cloud-platform&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&access_type=offline&client_id=1234567890)

##### Détails des paramètres

```json
{
    "client_id": "1234567890",
    "access_type": "offline",
    "scope": "https://www.googleapis.com/auth/cloud-platform",
    "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
    "response_type": "code"
}
```



#### Obtention du jeton d'accès (`access_token` & `refresh_token`)

```http
POST /oauth2/v4/token?grant_type=authorization_code&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=1234567890&client_secret=secret&code=azerty123 HTTP/1.1
Host: googleapis.com
Content-Type: application/json; charset=utf-8
Content-Length: 197

{
  "access_token": "1djdik8f5gft4",
  "expires_in": 3600,
  "refresh_token": "azertyuiop123456789",
  "scope": "https://www.googleapis.com/auth/cloud-platform",
  "token_type": "Bearer"
}
```

##### Détails des paramètres

```json
{
    "grant_type":"authorization_code",
    "client_id":"1234567890",
    "client_secret":"secret",
    "redirect_uri":"urn:ietf:wg:oauth:2.0:oob",
    "code":"azerty123"
}
```

#### Renouvellement du jeton d'accès (`access_token`)

```http
POST /oauth2/v4/token?grant_type=refresh_token&client_id=1234567890&client_secret=secret&refresh_token=azertyuiop123456789 HTTP/1.1
Host: googleapis.com
Content-Type: application/json; charset=utf-8
Content-Length: 160

{
  "access_token": "9d554kfiufuk2d5f58",
  "expires_in": 3600,
  "scope": "https://www.googleapis.com/auth/cloud-platform",
  "token_type": "Bearer"
}
```

##### Détails des paramètres

```json
{
    "grant_type":"refresh_token",
    "client_id":"1234567890",
    "client_secret":"secret",
    "refresh_token":"azertyuiop123456789"
}
```

