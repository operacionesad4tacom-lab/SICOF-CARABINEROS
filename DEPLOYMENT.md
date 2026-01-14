# 🚀 Guía de Despliegue - SICOF Núcleo

Esta guía te llevará paso a paso desde cero hasta tener SICOF Núcleo completamente desplegado en producción.

## 📋 Prerrequisitos

### Herramientas Necesarias
- Node.js >= 18.0.0
- npm >= 9.0.0
- Git
- Cuenta en GitHub
- Cuenta en Supabase (gratuita)
- Cuenta en Vercel (gratuita)

## Paso 1: Configurar Supabase

### 1.1 Crear Proyecto

1. Ve a [https://app.supabase.com](https://app.supabase.com)
2. Haz clic en "New Project"
3. Completa:
   - **Name**: `sicof-nucleo`
   - **Database Password**: (genera una contraseña segura y guárdala)
   - **Region**: Selecciona la más cercana (Brazil - São Paulo recomendado para Chile)
   - **Pricing Plan**: Free (suficiente para empezar)
4. Espera ~2 minutos mientras se crea el proyecto

### 1.2 Configurar Base de Datos

1. En el panel de Supabase, ve a **SQL Editor**
2. Crea una nueva query
3. Copia todo el contenido de `/supabase/schema.sql`
4. Pega en el editor SQL
5. Haz clic en **Run** (▶️)
6. Verifica que se ejecutó sin errores (deberías ver "Success")

### 1.3 Obtener Credenciales

1. Ve a **Settings** → **API**
2. Copia y guarda:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

### 1.4 Crear Usuario de Prueba

1. Ve a **Authentication** → **Users**
2. Haz clic en **Add user** → **Create new user**
3. Completa:
   - Email: `admin@test.com`
   - Password: `Test123456!`
   - Auto Confirm User: ✅
4. Haz clic en **Create user**

### 1.5 Insertar Datos Iniciales

En **SQL Editor**, ejecuta esto para crear datos de prueba:

```sql
-- Insertar cuartel de prueba
INSERT INTO public.cuarteles (nombre, codigo, ubicacion)
VALUES ('4ª Comisaría Chacalluta', 'CHAC-001', 'Arica, Región de Arica y Parinacota');

-- Obtener el ID del cuartel recién creado
DO $$
DECLARE
  cuartel_uuid UUID;
  user_uuid UUID;
BEGIN
  SELECT id INTO cuartel_uuid FROM public.cuarteles WHERE codigo = 'CHAC-001';
  SELECT id INTO user_uuid FROM auth.users WHERE email = 'admin@test.com';
  
  -- Actualizar usuario con rol y cuartel
  INSERT INTO public.users (id, email, full_name, role, cuartel_id)
  VALUES (user_uuid, 'admin@test.com', 'Administrador de Prueba', 'comisario', cuartel_uuid)
  ON CONFLICT (id) DO UPDATE 
  SET role = 'comisario', cuartel_id = cuartel_uuid;
END $$;

-- Insertar inventarios de ejemplo
INSERT INTO public.inventario_pnh (cuartel_id, nombre, codigo, ubicacion)
SELECT id, 'PNH Chacalluta Norte', 'PNH-001', 'Frontera Norte'
FROM public.cuarteles WHERE codigo = 'CHAC-001';

INSERT INTO public.inventario_hitos (cuartel_id, nombre, numero_hito, ubicacion)
SELECT id, 'Hito Fronterizo 1', 'H-001', 'Frontera Chile-Perú'
FROM public.cuarteles WHERE codigo = 'CHAC-001';

INSERT INTO public.inventario_sitios (cuartel_id, nombre, tipo, ubicacion)
SELECT id, 'Terminal Internacional', 'estratégico', 'Chacalluta'
FROM public.cuarteles WHERE codigo = 'CHAC-001';
```

## Paso 2: Configurar Proyecto Local

### 2.1 Clonar Repositorio

```bash
# Clona el repositorio
git clone https://github.com/tu-usuario/sicof-nucleo.git
cd sicof-nucleo

# Instala dependencias
npm install
```

### 2.2 Configurar Variables de Entorno

```bash
# Copia el archivo de ejemplo
cp .env.example .env.local

# Edita .env.local con tus credenciales
nano .env.local  # o usa tu editor favorito
```

Reemplaza con tus valores de Supabase:

```env
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 2.3 Probar Localmente

```bash
npm run dev
```

Abre [http://localhost:5173](http://localhost:5173)

**Credenciales de prueba:**
- Email: `admin@test.com`
- Password: `Test123456!`

## Paso 3: Desplegar en Vercel

### 3.1 Preparar para Producción

```bash
# Construir el proyecto
npm run build

# Probar build localmente
npm run preview
```

### 3.2 Desplegar en Vercel

**Opción A: Desde GitHub (Recomendado)**

1. Sube tu código a GitHub:
```bash
git add .
git commit -m "Initial commit"
git push origin main
```

2. Ve a [https://vercel.com](https://vercel.com)
3. Haz clic en **Add New** → **Project**
4. Importa tu repositorio de GitHub
5. Configura el proyecto:
   - **Framework Preset**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
6. Agrega las variables de entorno:
   - `VITE_SUPABASE_URL`: tu URL de Supabase
   - `VITE_SUPABASE_ANON_KEY`: tu anon key
7. Haz clic en **Deploy**
8. Espera ~2 minutos

**Opción B: Desde CLI**

```bash
# Instalar Vercel CLI
npm i -g vercel

# Desplegar
vercel

# Seguir las instrucciones interactivas
```

### 3.3 Configurar Dominio (Opcional)

1. En Vercel, ve a tu proyecto → **Settings** → **Domains**
2. Agrega tu dominio personalizado (ej: `sicof.carabineros.cl`)
3. Sigue las instrucciones para configurar DNS

## Paso 4: Configuración de Seguridad

### 4.1 Configurar Políticas de Seguridad en Supabase

1. En Supabase, ve a **Authentication** → **URL Configuration**
2. Agrega tu dominio de Vercel a **Site URL**: `https://tu-app.vercel.app`
3. Agrega a **Redirect URLs**: `https://tu-app.vercel.app/**`

### 4.2 Configurar CORS (si es necesario)

En **Settings** → **API** → **CORS**:
- Agrega: `https://tu-app.vercel.app`

### 4.3 Revisar RLS (Row Level Security)

Verifica que todas las políticas RLS estén activas:

```sql
-- Verificar tablas con RLS habilitado
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' AND rowsecurity = true;
```

## Paso 5: Crear Usuarios Reales

### 5.1 Desde Panel de Supabase

1. **Authentication** → **Users** → **Add user**
2. Completa datos del usuario
3. Asigna rol y cuartel en tabla `users`

### 5.2 Script SQL para Múltiples Usuarios

```sql
-- Crear usuario digitador
INSERT INTO public.users (id, email, full_name, role, cuartel_id)
SELECT 
  auth.uid(),
  'digitador@carabineros.cl',
  'Juan Pérez',
  'digitador',
  (SELECT id FROM public.cuarteles WHERE codigo = 'CHAC-001')
WHERE NOT EXISTS (
  SELECT 1 FROM public.users WHERE email = 'digitador@carabineros.cl'
);
```

## Paso 6: Monitoreo y Mantenimiento

### 6.1 Configurar Backups

Supabase hace backups automáticos en el plan gratuito, pero puedes:
1. **Database** → **Backups**
2. Configurar backups adicionales (plan Pro)

### 6.2 Monitorear Uso

1. **Home** → Ver métricas de uso
2. Monitorear:
   - Database size
   - Bandwidth
   - Monthly Active Users (MAU)

### 6.3 Actualizar Vistas Materializadas

Crea un cron job en Supabase:

1. **Database** → **Cron Jobs** (requiere extensión pg_cron)
2. Agregar job diario:

```sql
SELECT cron.schedule(
  'refresh-materialized-views',
  '0 2 * * *', -- Ejecutar a las 2 AM diariamente
  $$SELECT refresh_materialized_views()$$
);
```

## 📊 Verificación Post-Despliegue

Checklist final:

- [ ] Aplicación accesible en URL de producción
- [ ] Login funciona correctamente
- [ ] Dashboard carga sin errores
- [ ] Base de datos responde correctamente
- [ ] RLS funciona (usuarios solo ven sus datos)
- [ ] Variables de entorno configuradas
- [ ] SSL/HTTPS habilitado
- [ ] Backups configurados
- [ ] Usuarios creados y pueden acceder

## 🆘 Solución de Problemas

### Error: "Invalid API key"
- Verifica que copiaste correctamente `VITE_SUPABASE_ANON_KEY`
- Revisa que las variables de entorno estén en Vercel

### Error: "Row Level Security violated"
- Ejecuta nuevamente las políticas RLS del schema.sql
- Verifica que el usuario tenga rol asignado en tabla `users`

### Error 404 en rutas
- En Vercel, agrega `vercel.json`:
```json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/" }]
}
```

### Base de datos lenta
- Revisa índices en tablas principales
- Considera plan Pro de Supabase para mejor performance
- Refresca vistas materializadas regularmente

## 🎉 ¡Listo!

Tu sistema SICOF Núcleo está ahora desplegado y listo para usar.

**Próximos pasos:**
1. Capacitar a usuarios
2. Cargar datos iniciales (cuarteles, inventarios)
3. Configurar planificación anual
4. Comenzar registros diarios

**Soporte:**
- Documentación: Ver README.md
- Issues: GitHub Issues del proyecto
- Email: soporte@proyecto.cl
