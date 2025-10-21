# Firebase App Distribution - Taller de Distribución

## 📋 Información del Proyecto

**Nombre de la App:** Talleres Móviles - Star Wars API  
**Application ID:** `com.example.talleresmoviles`  
**Versión Inicial:** 1.0.0+1  
**Estudiante:** Cristopher Arias Contreras  
**Código:** 230222032  
**Tester Principal:** dduran@uceva.edu.co  

---

## 🚀 Flujo de Distribución

```
Generar APK → Firebase App Distribution → Grupo de Testers → Instalación → Actualización
```

---

## 📦 Paso 1: Preparación del APK

### 1.1 Configuración de Permisos

**Archivo:** `android/app/src/main/AndroidManifest.xml`

Se agregó el permiso de INTERNET necesario para consumir la Star Wars API:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### 1.2 Versionado

**Archivo:** `pubspec.yaml`

```yaml
version: 1.0.0+1
```

Donde:
- `1.0.0` = versionName (visible para usuarios)
- `1` = versionCode (número interno incremental)

### 1.3 Generar APK de Release

```bash
flutter build apk --release
```

**Ubicación del APK generado:**
```
build/app/outputs/flutter-apk/app-release.apk
```

**Tamaño:** ~45.5MB

---

## 🔥 Paso 2: Configurar Firebase App Distribution

### 2.1 Acceder a Firebase Console

1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Seleccionar o crear un proyecto
3. Nombre del proyecto sugerido: `TalleresMoviles-QA`

### 2.2 Registrar la App Android

1. En la consola de Firebase, click en **"Agregar app" → Android**
2. Ingresar datos:
   - **Nombre del paquete de Android:** `com.example.talleresmoviles`
   - **Alias de la app:** Talleres Móviles
   - **SHA-1:** (Opcional para esta fase)
3. Descargar `google-services.json` (si se requiere)
4. Click en **"Registrar app"**

### 2.3 Configurar App Distribution

#### A. Crear Grupo de Testers

1. En Firebase Console → **App Distribution**
2. Click en **"Testers & Groups"**
3. Click en **"Add Group"**
4. Configuración del grupo:
   - **Nombre:** `QA_Clase`
   - **Descripción:** Grupo de testing para la clase de desarrollo móvil

#### B. Agregar Testers al Grupo

1. En el grupo `QA_Clase`, click en **"Add testers"**
2. Agregar email: `dduran@uceva.edu.co`
3. Click en **"Add"**

### 2.4 Subir el Primer Release (v1.0.0+1)

1. En **App Distribution → Releases**
2. Click en **"Distribute"**
3. Arrastrar o seleccionar: `app-release.apk`
4. **Release notes** para versión 1.0.0+1:

```
🌟 Release v1.0.0 - Primera versión
📅 Fecha: [Fecha actual]
👨‍💻 Responsable: Cristopher Arias Contreras

✨ Características principales:
- Consumo de Star Wars API (SWAPI)
- Listado completo de 82 personajes
- Búsqueda en tiempo real
- Detalles de personajes con información del planeta natal
- Scroll infinito con paginación
- Tema visual Star Wars con efectos de neón
- Imágenes de personajes principales

🔧 Aspectos técnicos:
- Arquitectura limpia (Clean Architecture)
- Manejo robusto de errores de red
- Estados de carga optimizados

📋 Para probar:
1. Instalar la aplicación desde el enlace
2. Permitir instalación de fuentes desconocidas
3. Explorar la lista de personajes
4. Usar la búsqueda para filtrar
5. Ver detalles de cualquier personaje
```

5. Seleccionar grupo: **QA_Clase**
6. Click en **"Distribute"**

### 2.5 Copiar Enlace de Instalación

1. Después de distribuir, aparecerá un enlace
2. Copiar el enlace de instalación
3. Formato: `https://appdistribution.firebase.google.com/testerapps/[APP_ID]`
4. Guardar este enlace para compartir

---

## 👥 Paso 3: Proceso de Testing

### 3.1 Invitación al Tester

El tester (`dduran@uceva.edu.co`) recibirá:
- **Email de invitación** de Firebase App Distribution
- **Enlace directo** a la app para instalar

### 3.2 Instalación en Dispositivo Android

**Instrucciones para el tester:**

1. **Abrir el email** de Firebase App Distribution
2. Click en **"Accept invitation"**
3. En el dispositivo Android:
   - Ir a **Configuración → Seguridad**
   - Habilitar **"Instalar apps desconocidas"** para Chrome/navegador
4. **Descargar** la app desde el enlace
5. **Instalar** el APK
6. **Abrir** la aplicación

### 3.3 Escenarios de Prueba

**Lista de verificación para el tester:**

- [ ] La app se instala correctamente
- [ ] Se muestra la pantalla principal con el logo
- [ ] Al hacer click en "Ver Personajes" carga la lista
- [ ] Los personajes se muestran con imágenes
- [ ] La búsqueda funciona correctamente
- [ ] Al hacer scroll, carga más personajes
- [ ] Al hacer click en un personaje, muestra sus detalles
- [ ] La información del planeta se carga correctamente
- [ ] El botón de volver regresa a la lista
- [ ] No hay crashes o errores visuales

---

## 🔄 Paso 4: Actualización (v1.0.0 → v1.0.1)

### 4.1 Incrementar Versión

**Archivo:** `pubspec.yaml`

```yaml
# Cambiar de:
version: 1.0.0+1

# A:
version: 1.0.1+2
```

### 4.2 Realizar Cambios en el Código

**Ejemplo de mejoras para v1.0.1:**
- Optimización de rendimiento
- Mejora en mensajes de error
- Corrección de bugs reportados
- Mejoras visuales menores

### 4.3 Generar Nuevo APK

```bash
flutter clean
flutter build apk --release
```

### 4.4 Distribuir Nueva Versión

1. En Firebase App Distribution → **Releases**
2. Click en **"Distribute"**
3. Subir el nuevo `app-release.apk`
4. **Release notes** para versión 1.0.1+2:

```
🔄 Release v1.0.1 - Actualización incremental
📅 Fecha: [Fecha actual]
👨‍💻 Responsable: Cristopher Arias Contreras

🐛 Correcciones:
- [Listar bugs corregidos]

⚡ Mejoras:
- [Listar mejoras implementadas]

🔧 Cambios técnicos:
- Actualización de versión 1.0.0+1 → 1.0.1+2
- [Otros cambios técnicos]
```

5. Seleccionar grupo: **QA_Clase**
6. Click en **"Distribute"**

### 4.5 Verificar Actualización

El tester recibirá notificación de nueva versión disponible y podrá actualizar directamente.

---

## 📊 Bitácora de QA

### Release v1.0.0+1

| Fecha | Tester | Dispositivo | Estado | Incidencias |
|-------|--------|-------------|--------|-------------|
| [Fecha] | dduran@uceva.edu.co | [Modelo] | ✅ Aprobado | Ninguna |

**Notas:**
- Primera instalación exitosa
- Todas las funcionalidades verificadas
- Sin crashes reportados

### Release v1.0.1+2

| Fecha | Tester | Dispositivo | Estado | Incidencias |
|-------|--------|-------------|--------|-------------|
| [Fecha] | dduran@uceva.edu.co | [Modelo] | ⏳ En prueba | - |

**Notas:**
- Actualización desde v1.0.0
- [Pendiente completar tras testing]

---

## 📸 Evidencias

### Panel de Firebase App Distribution

**Screenshots requeridos:**

1. **Releases Dashboard:**
   - Lista de versiones distribuidas
   - Métricas de adopción

2. **Grupo de Testers:**
   - Configuración del grupo QA_Clase
   - Lista de testers agregados

3. **Release Details:**
   - Información de v1.0.0+1
   - Release notes completas
   - Estado de distribución

4. **Instalación en Dispositivo:**
   - Email de invitación
   - Proceso de descarga
   - App instalada y funcionando

---

## 🔧 Buenas Prácticas Implementadas

### 1. Versionado Semántico

```
MAJOR.MINOR.PATCH+BUILD

Ejemplo: 1.0.1+2
- 1 = MAJOR (cambios incompatibles)
- 0 = MINOR (nuevas funcionalidades compatibles)
- 1 = PATCH (correcciones de bugs)
- 2 = BUILD (número de build interno)
```

### 2. Release Notes Estructuradas

**Formato estándar:**
```
🎯 Versión
📅 Fecha
👨‍💻 Responsable
✨ Nuevas características
🐛 Bugs corregidos
⚡ Mejoras de rendimiento
🔧 Cambios técnicos
```

### 3. Proceso de Testing

- **Pre-release:** Testing interno antes de distribuir
- **Release:** Distribución al grupo QA
- **Post-release:** Recolección de feedback
- **Hotfix:** Corrección rápida si es necesario

### 4. Gestión de Testers

- Grupos organizados por rol (QA, Beta, Producción)
- Comunicación clara de cambios
- Tracking de instalaciones y feedback

---

## 🔄 Cómo Replicar el Proceso

### Para el Equipo de Desarrollo

1. **Desarrollo local:**
   ```bash
   # Hacer cambios en el código
   # Incrementar versión en pubspec.yaml
   ```

2. **Testing local:**
   ```bash
   flutter test
   flutter run --release
   ```

3. **Generar APK:**
   ```bash
   flutter clean
   flutter build apk --release
   ```

4. **Distribuir:**
   - Acceder a Firebase Console
   - App Distribution → Distribute
   - Subir APK y agregar release notes
   - Seleccionar grupo de testers
   - Distribuir

5. **Verificar:**
   - Revisar métricas de instalación
   - Recopilar feedback de testers
   - Documentar incidencias

### Comandos Útiles

```bash
# Ver versión actual
flutter --version

# Limpiar build anterior
flutter clean

# Generar APK de release
flutter build apk --release

# Generar APK dividido por arquitectura (más liviano)
flutter build apk --split-per-abi

# Ver información de build
flutter build apk --release --verbose
```

---

## 📞 Contacto y Soporte

**Desarrollador:** Cristopher Arias Contreras  
**Email:** cristopher.arias01@uceva.edu.co  
**Tester Principal:** dduran@uceva.edu.co  

---

## ✅ Checklist de Distribución

- [ ] Configurar permisos en AndroidManifest.xml
- [ ] Incrementar versión en pubspec.yaml
- [ ] Generar APK de release
- [ ] Crear/configurar proyecto en Firebase
- [ ] Registrar app Android en Firebase
- [ ] Crear grupo de testers (QA_Clase)
- [ ] Agregar testers al grupo
- [ ] Subir APK a App Distribution
- [ ] Escribir release notes descriptivas
- [ ] Distribuir a grupo de testers
- [ ] Copiar enlace de instalación
- [ ] Verificar instalación en dispositivo físico
- [ ] Documentar incidencias encontradas
- [ ] Realizar actualización incremental
- [ ] Verificar flujo de actualización
- [ ] Tomar capturas de evidencia
- [ ] Completar bitácora de QA
- [ ] Actualizar documentación

---

**Última actualización:** [Fecha actual]
