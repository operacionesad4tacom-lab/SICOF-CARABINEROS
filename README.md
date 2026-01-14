# 🛡️ SICOF Núcleo - Sistema de Control Fronterizo

> Sistema de registro, control, monitoreo y análisis operativo-administrativo para la 4ª Comisaría Chacalluta (F) y cuarteles dependientes.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![React](https://img.shields.io/badge/React-20232A?logo=react&logoColor=61DAFB)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?logo=typescript&logoColor=white)](https://www.typescriptlang.org/)

## 📋 Descripción

SICOF es una plataforma web diseñada para:

- ✅ **Registro simple** de labor diaria por cuartel
- 📊 **Análisis automático** de operaciones y tendencias
- 🎯 **Reporte diario** automatizado al Comisario
- 📈 **Dashboard estratégico** con indicadores clave
- 🔔 **Alertas** operativas y administrativas
- 🧠 **Recomendaciones** basadas en reglas de negocio

## 🎯 Producto Principal

**Reporte Diario Automático** que consolida:
- Estado administrativo general
- Labor del día por cuartel
- Acumulados anuales (YTD)
- Alertas activas
- Recomendaciones estratégicas

## 🏗️ Arquitectura Tecnológica

### Frontend
- **Framework**: React 18 + TypeScript
- **UI Library**: Tailwind CSS + shadcn/ui
- **Gráficos**: Recharts
- **Estado**: React Query + Zustand
- **Formularios**: React Hook Form + Zod

### Backend
- **BaaS**: Supabase (PostgreSQL + Auth + Storage + Realtime)
- **ORM**: Supabase JavaScript Client
- **Auth**: Row Level Security (RLS) + JWT

### Deployment
- **Frontend**: Vercel / Netlify
- **Database**: Supabase Cloud
- **CI/CD**: GitHub Actions

## 🚀 Inicio Rápido

### Prerrequisitos

```bash
node >= 18.0.0
npm >= 9.0.0
```

### Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/tu-usuario/sicof-nucleo.git
cd sicof-nucleo
```

2. **Instalar dependencias**
```bash
npm install
```

3. **Configurar variables de entorno**
```bash
cp .env.example .env.local
```

Editar `.env.local` con tus credenciales de Supabase:
```env
VITE_SUPABASE_URL=tu_supabase_url
VITE_SUPABASE_ANON_KEY=tu_supabase_anon_key
```

4. **Inicializar base de datos Supabase**
```bash
# Ejecutar el script SQL en el SQL Editor de Supabase
# Ubicado en: /supabase/schema.sql
```

5. **Ejecutar en desarrollo**
```bash
npm run dev
```

La aplicación estará disponible en `http://localhost:5173`

## 👥 Roles y Permisos (RBAC)

### 1. DIGITADOR (Operador)
- ✅ Crear registro diario de su cuartel
- ✅ Ver solo sus propios registros
- ❌ No editar registros enviados
- ❌ No ver análisis consolidados

### 2. ADMINISTRADOR DE OPERACIONES
- ✅ Crear/editar planificación anual
- ✅ Ver todos los registros
- ✅ Validar registros diarios
- ✅ Editar registros (con auditoría)
- ✅ Administrar usuarios
- ✅ Exportar datos

### 3. COMISARIO (Analista Estratégico)
- ✅ Acceso a dashboards
- ✅ Ver reportes diarios/históricos
- ✅ Ver alertas y recomendaciones
- ❌ No registra datos
- ❌ No planifica

## 📊 Módulos Funcionales

### 1. Identificación Diaria
- Cuartel, fecha, turno
- Dotación efectiva
- Medios operativos

### 2. Registro de Labor Diaria

#### A. Demanda Ciudadana
- Procedimientos relevantes
- Fiscalización (controles, detenidos, infracciones)
- Servicios extraordinarios

#### B. Demanda Preventiva Fronteriza
- Pasos No Habilitados (PNH)
- Hitos Fronterizos
- Sitios de Interés

#### C. Cooperación e Integración
- Cooperación bilateral
- Integración comunitaria

#### D. Operaciones Internas
- Capacitación
- Proyectos
- Investigaciones
- Logística

### 3. Planificación Anual
- Planificación preventiva (PNH, Hitos, Sitios)
- Planificación de cooperación internacional
- Frecuencias y prioridades

### 4. Motor de Alertas
- Combustible bajo umbral
- Agua bajo umbral
- PNH no visitados
- Investigaciones con plazos vencidos
- Brechas planificación vs ejecución

### 5. Motor de Recomendaciones
- Análisis de tendencias
- Sugerencias operativas
- Máximo 3 recomendaciones/día

## 🗄️ Estructura de Base de Datos

```
├── users (autenticación y roles)
├── cuarteles (unidades policiales)
├── registros_diarios (labor diaria)
├── detenciones (registro por tramo horario)
├── inventario_pnh (pasos no habilitados)
├── inventario_hitos (hitos fronterizos)
├── inventario_sitios (sitios de interés)
├── planificacion_anual (estrategia anual)
├── visitas_preventivas (ejecución diaria)
├── cooperacion_bilateral (coordinación internacional)
├── alertas (alertas automáticas)
├── recomendaciones (sugerencias del sistema)
└── audit_log (trazabilidad completa)
```

## 🔐 Seguridad

- **Row Level Security (RLS)**: Políticas a nivel de fila por rol
- **JWT Auth**: Autenticación segura con Supabase Auth
- **Audit Log**: Registro completo de acciones
- **HTTPS**: Comunicación encriptada
- **Input Validation**: Zod schemas en frontend y backend

## 📁 Estructura del Proyecto

```
sicof-nucleo/
├── src/
│   ├── components/          # Componentes React
│   │   ├── ui/             # Componentes base (shadcn/ui)
│   │   ├── forms/          # Formularios específicos
│   │   ├── dashboard/      # Widgets del dashboard
│   │   └── reports/        # Generadores de reportes
│   ├── hooks/              # Custom React hooks
│   ├── lib/                # Utilidades y helpers
│   │   ├── supabase.ts    # Cliente Supabase
│   │   └── schemas.ts     # Zod validation schemas
│   ├── pages/              # Páginas principales
│   │   ├── Dashboard.tsx
│   │   ├── DailyRegistry.tsx
│   │   ├── Planning.tsx
│   │   └── Reports.tsx
│   ├── services/           # Lógica de negocio
│   │   ├── registries.ts
│   │   ├── planning.ts
│   │   ├── alerts.ts
│   │   └── recommendations.ts
│   ├── types/              # TypeScript types
│   └── App.tsx
├── supabase/
│   ├── schema.sql          # Schema completo de DB
│   ├── migrations/         # Migraciones
│   └── seed.sql           # Datos iniciales
├── public/
└── package.json
```

## 🧪 Testing

```bash
# Unit tests
npm run test

# E2E tests
npm run test:e2e

# Coverage
npm run test:coverage
```

## 📦 Deployment

### Supabase

1. Crear proyecto en [Supabase](https://app.supabase.com)
2. Ejecutar `supabase/schema.sql` en SQL Editor
3. Configurar RLS policies
4. Obtener credenciales (URL + Anon Key)

### Frontend (Vercel)

```bash
npm run build
vercel --prod
```

O conectar el repositorio GitHub en Vercel Dashboard.

## 🔄 Flujo de Trabajo

1. **Digitador** registra labor diaria al finalizar turno
2. **Sistema** valida y almacena datos
3. **Motor de análisis** procesa información
4. **Motor de alertas** detecta anomalías
5. **Motor de recomendaciones** genera sugerencias
6. **Reporte automático** se genera para el Comisario
7. **Dashboard** actualiza indicadores en tiempo real

## 📈 Roadmap

### Fase 1 - MVP (Actual)
- [x] Registro diario básico
- [x] Roles y permisos
- [x] Planificación anual
- [x] Reporte diario

### Fase 2 - Análisis
- [ ] Motor de alertas completo
- [ ] Motor de recomendaciones
- [ ] Dashboard interactivo
- [ ] Exportación de datos

### Fase 3 - Expansión
- [ ] Integración con otros sistemas
- [ ] API REST pública
- [ ] App móvil
- [ ] ML predictivo (opcional)

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## 👨‍💻 Autor

**Damián** - Sistema desarrollado para la 4ª Comisaría Chacalluta (F)

## 🙏 Agradecimientos

- Equipo de la 4ª Comisaría Chacalluta
- Carabineros de Chile
- Comunidad open source

---

**Principio de Diseño**: "Si una función no aporta información clara al control diario del Comisario, no debe desarrollarse."
