# Seguridad

## Credenciales
- Nunca credenciales en código
- Nunca crear `.env` con valores reales — solo `.env.example` vacío
- `.env` jamás va a git

## Archivos prohibidos de tocar
- `*.env`, `*.key`, `*.pem`, `*.pfx`
- Logs con datos de usuarios
- Archivos de OAuth tokens

## Producción
- Operaciones destructivas: confirmación + log + rollback documentado
- Nunca ejecutar sin revisión manual previa

## Google Drive API (ValleySave)
- Client ID / Client Secret: solo en `.env`, nunca hardcoded
- Tokens OAuth del usuario: secure storage (no SharedPreferences en Flutter)
- Refresh tokens: nunca loggear, nunca enviar fuera del dispositivo

## AdMob
- Test IDs en desarrollo
- IDs reales solo en producción, vía variables de entorno
- Nunca commitear IDs reales al repo público
