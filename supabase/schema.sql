-- ============================================================================
-- SICOF NÚCLEO - SCHEMA COMPLETO SUPABASE
-- Sistema de Control Fronterizo - 4ª Comisaría Chacalluta
-- ============================================================================

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- ENUMS (Tipos enumerados)
-- ============================================================================

-- Roles de usuario
CREATE TYPE user_role AS ENUM ('digitador', 'admin_operaciones', 'comisario');

-- Turnos
CREATE TYPE turno_type AS ENUM ('diurno', 'nocturno');

-- Tramos horarios (para análisis de detenciones)
CREATE TYPE tramo_horario AS ENUM (
  '00:00-05:59',
  '06:00-11:59',
  '12:00-17:59',
  '18:00-23:59'
);

-- Estado de planificación
CREATE TYPE estado_planificacion AS ENUM ('cumplida', 'no_cumplida', 'reagendada');

-- Tipo de elemento preventivo
CREATE TYPE tipo_elemento_preventivo AS ENUM ('pnh', 'hito', 'sitio');

-- Frecuencia de visitas
CREATE TYPE frecuencia_visita AS ENUM ('mensual', 'trimestral', 'semestral', 'anual', 'especifica');

-- Prioridad
CREATE TYPE prioridad_type AS ENUM ('baja', 'media', 'alta', 'critica');

-- Tipo de alerta
CREATE TYPE tipo_alerta AS ENUM (
  'combustible_bajo',
  'agua_baja',
  'pnh_no_visitado',
  'investigacion_vencida',
  'brecha_planificacion',
  'otro'
);

-- Estado de alerta
CREATE TYPE estado_alerta AS ENUM ('activa', 'resuelta', 'ignorada');

-- ============================================================================
-- TABLA: users (extendiendo auth.users de Supabase)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  role user_role NOT NULL DEFAULT 'digitador',
  cuartel_id UUID REFERENCES public.cuarteles(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- TABLA: cuarteles
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.cuarteles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nombre TEXT NOT NULL,
  codigo TEXT UNIQUE NOT NULL,
  ubicacion TEXT,
  latitud DECIMAL(10, 8),
  longitud DECIMAL(11, 8),
  dependiente_de UUID REFERENCES public.cuarteles(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- TABLA: registros_diarios (módulo base + identificación)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.registros_diarios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cuartel_id UUID NOT NULL REFERENCES public.cuarteles(id),
  fecha DATE NOT NULL,
  turno turno_type NOT NULL,
  usuario_id UUID NOT NULL REFERENCES public.users(id),
  
  -- Identificación diaria
  dotacion_efectiva INTEGER NOT NULL,
  medios_operativos JSONB, -- { "vehiculos": 3, "motos": 2, etc. }
  
  -- Labor diaria - Demanda ciudadana
  procedimientos_relevantes BOOLEAN DEFAULT false,
  controles_identidad_preventivos INTEGER DEFAULT 0,
  controles_identidad_investigativos INTEGER DEFAULT 0,
  controles_migratorios INTEGER DEFAULT 0,
  controles_vehiculares INTEGER DEFAULT 0,
  infracciones_transito INTEGER DEFAULT 0,
  infracciones_migratorias INTEGER DEFAULT 0,
  infracciones_alcoholes INTEGER DEFAULT 0,
  infracciones_otras INTEGER DEFAULT 0,
  faccion_ejecutora TEXT,
  servicios_extraordinarios JSONB, -- [{ tipo, recursos, tiempo_respuesta, observaciones }]
  
  -- Cooperación e integración
  cooperacion_bilateral JSONB, -- [{ tipo, institucion, tema, resultado }]
  reuniones_comunitarias INTEGER DEFAULT 0,
  proyectos_activos INTEGER DEFAULT 0,
  conflictos_mediados INTEGER DEFAULT 0,
  lideres_contactados INTEGER DEFAULT 0,
  
  -- Operaciones internas
  capacitacion JSONB, -- { cursos_programados, personal_capacitado, horas, temas }
  proyectos JSONB, -- { solicitados, aprobados, estado, responsable }
  investigaciones JSONB, -- { activas, estado, plazos_vigentes }
  
  -- Logística
  combustible_vehiculos DECIMAL(10, 2), -- litros
  combustible_generador DECIMAL(10, 2), -- litros
  agua_estanques DECIMAL(10, 2), -- m³ o %
  
  -- Observaciones generales
  observaciones TEXT,
  
  -- Control
  enviado BOOLEAN DEFAULT false,
  validado BOOLEAN DEFAULT false,
  validado_por UUID REFERENCES public.users(id),
  validado_at TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Constraint: un registro por cuartel/fecha/turno
  UNIQUE(cuartel_id, fecha, turno)
);

-- Índices para registros_diarios
CREATE INDEX idx_registros_fecha ON public.registros_diarios(fecha);
CREATE INDEX idx_registros_cuartel ON public.registros_diarios(cuartel_id);
CREATE INDEX idx_registros_usuario ON public.registros_diarios(usuario_id);

-- ============================================================================
-- TABLA: detenciones (registro por tramo horario - MANDATORIO)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.detenciones (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  registro_diario_id UUID NOT NULL REFERENCES public.registros_diarios(id) ON DELETE CASCADE,
  
  fecha DATE NOT NULL,
  hora_exacta TIME NOT NULL,
  tramo_horario tramo_horario NOT NULL, -- CAMPO OBLIGATORIO
  
  cuartel_id UUID NOT NULL REFERENCES public.cuarteles(id),
  lugar TEXT NOT NULL,
  
  tipo_delito TEXT NOT NULL,
  modalidad TEXT, -- flagrancia / orden judicial
  personal_interviniente TEXT[],
  nacionalidad TEXT,
  resultado_inicial TEXT,
  
  observaciones TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para análisis por tramo horario
CREATE INDEX idx_detenciones_tramo ON public.detenciones(tramo_horario);
CREATE INDEX idx_detenciones_fecha ON public.detenciones(fecha);
CREATE INDEX idx_detenciones_cuartel ON public.detenciones(cuartel_id);

-- Función para autocalcular tramo horario
CREATE OR REPLACE FUNCTION calcular_tramo_horario(hora TIME)
RETURNS tramo_horario AS $$
BEGIN
  CASE
    WHEN hora >= '00:00:00' AND hora < '06:00:00' THEN RETURN '00:00-05:59'::tramo_horario;
    WHEN hora >= '06:00:00' AND hora < '12:00:00' THEN RETURN '06:00-11:59'::tramo_horario;
    WHEN hora >= '12:00:00' AND hora < '18:00:00' THEN RETURN '12:00-17:59'::tramo_horario;
    ELSE RETURN '18:00-23:59'::tramo_horario;
  END CASE;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Trigger para autocalcular tramo antes de insertar/actualizar
CREATE OR REPLACE FUNCTION auto_calcular_tramo()
RETURNS TRIGGER AS $$
BEGIN
  NEW.tramo_horario := calcular_tramo_horario(NEW.hora_exacta);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auto_tramo
BEFORE INSERT OR UPDATE ON public.detenciones
FOR EACH ROW EXECUTE FUNCTION auto_calcular_tramo();

-- ============================================================================
-- TABLA: inventario_pnh (Pasos No Habilitados)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.inventario_pnh (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cuartel_id UUID NOT NULL REFERENCES public.cuarteles(id),
  nombre TEXT NOT NULL,
  codigo TEXT UNIQUE,
  ubicacion TEXT,
  latitud DECIMAL(10, 8),
  longitud DECIMAL(11, 8),
  descripcion TEXT,
  riesgo_asociado TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_pnh_cuartel ON public.inventario_pnh(cuartel_id);

-- ============================================================================
-- TABLA: inventario_hitos (Hitos Fronterizos)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.inventario_hitos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cuartel_id UUID NOT NULL REFERENCES public.cuarteles(id),
  nombre TEXT NOT NULL,
  numero_hito TEXT UNIQUE,
  ubicacion TEXT,
  latitud DECIMAL(10, 8),
  longitud DECIMAL(11, 8),
  descripcion TEXT,
  estado_conservacion TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_hitos_cuartel ON public.inventario_hitos(cuartel_id);

-- ============================================================================
-- TABLA: inventario_sitios (Sitios de Interés Estratégico)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.inventario_sitios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cuartel_id UUID NOT NULL REFERENCES public.cuarteles(id),
  nombre TEXT NOT NULL,
  tipo TEXT, -- minero, turístico, conflictivo, etc.
  ubicacion TEXT,
  latitud DECIMAL(10, 8),
  longitud DECIMAL(11, 8),
  descripcion TEXT,
  nivel_interes prioridad_type DEFAULT 'media',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_sitios_cuartel ON public.inventario_sitios(cuartel_id);

-- ============================================================================
-- TABLA: planificacion_anual (ESTRATÉGICA - ANUAL)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.planificacion_anual (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  anio INTEGER NOT NULL,
  cuartel_id UUID NOT NULL REFERENCES public.cuarteles(id),
  
  tipo_elemento tipo_elemento_preventivo NOT NULL,
  elemento_id UUID NOT NULL, -- ID genérico (PNH, Hito o Sitio)
  
  frecuencia frecuencia_visita NOT NULL,
  prioridad prioridad_type DEFAULT 'media',
  
  -- Ventana temporal (opcional según frecuencia)
  mes_inicio INTEGER CHECK (mes_inicio BETWEEN 1 AND 12),
  mes_fin INTEGER CHECK (mes_fin BETWEEN 1 AND 12),
  
  objetivo TEXT,
  observaciones TEXT,
  
  created_by UUID NOT NULL REFERENCES public.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Constraint: una planificación por elemento/año
  UNIQUE(anio, cuartel_id, tipo_elemento, elemento_id)
);

CREATE INDEX idx_planificacion_anio ON public.planificacion_anual(anio);
CREATE INDEX idx_planificacion_cuartel ON public.planificacion_anual(cuartel_id);

-- ============================================================================
-- TABLA: visitas_preventivas (EJECUCIÓN DIARIA)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.visitas_preventivas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  registro_diario_id UUID NOT NULL REFERENCES public.registros_diarios(id) ON DELETE CASCADE,
  planificacion_id UUID REFERENCES public.planificacion_anual(id),
  
  tipo_elemento tipo_elemento_preventivo NOT NULL,
  elemento_id UUID NOT NULL,
  
  fecha DATE NOT NULL,
  fue_planificada BOOLEAN DEFAULT false,
  estado estado_planificacion NOT NULL,
  
  detecta_procedimiento BOOLEAN DEFAULT false,
  personal_interviniente TEXT[],
  observaciones TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_visitas_fecha ON public.visitas_preventivas(fecha);
CREATE INDEX idx_visitas_planificacion ON public.visitas_preventivas(planificacion_id);

-- ============================================================================
-- TABLA: cooperacion_bilateral (PLANIFICACIÓN + EJECUCIÓN)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.cooperacion_bilateral (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  registro_diario_id UUID REFERENCES public.registros_diarios(id) ON DELETE CASCADE,
  
  tipo_actividad TEXT NOT NULL, -- reunión / operativo / intercambio
  institucion_contraparte TEXT NOT NULL,
  pais TEXT,
  
  fecha DATE NOT NULL,
  tema TEXT,
  resultado TEXT,
  participantes TEXT[],
  
  fue_planificada BOOLEAN DEFAULT false,
  observaciones TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_cooperacion_fecha ON public.cooperacion_bilateral(fecha);

-- ============================================================================
-- TABLA: alertas (MOTOR DE ALERTAS)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.alertas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tipo tipo_alerta NOT NULL,
  prioridad prioridad_type DEFAULT 'media',
  
  cuartel_id UUID REFERENCES public.cuarteles(id),
  registro_diario_id UUID REFERENCES public.registros_diarios(id),
  
  titulo TEXT NOT NULL,
  descripcion TEXT NOT NULL,
  valor_actual TEXT,
  valor_umbral TEXT,
  
  estado estado_alerta DEFAULT 'activa',
  fecha_generacion TIMESTAMPTZ DEFAULT NOW(),
  fecha_resolucion TIMESTAMPTZ,
  
  resuelta_por UUID REFERENCES public.users(id),
  notas_resolucion TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_alertas_estado ON public.alertas(estado);
CREATE INDEX idx_alertas_cuartel ON public.alertas(cuartel_id);
CREATE INDEX idx_alertas_fecha ON public.alertas(fecha_generacion);

-- ============================================================================
-- TABLA: recomendaciones (MOTOR DE RECOMENDACIONES)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.recomendaciones (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  fecha DATE NOT NULL,
  cuartel_id UUID REFERENCES public.cuarteles(id),
  
  titulo TEXT NOT NULL,
  descripcion TEXT NOT NULL,
  categoria TEXT, -- operativo / administrativo / logístico / estratégico
  prioridad prioridad_type DEFAULT 'media',
  
  fundamento TEXT, -- Por qué se genera esta recomendación
  accion_sugerida TEXT,
  
  vista BOOLEAN DEFAULT false,
  implementada BOOLEAN DEFAULT false,
  fecha_implementacion TIMESTAMPTZ,
  resultado_implementacion TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_recomendaciones_fecha ON public.recomendaciones(fecha);
CREATE INDEX idx_recomendaciones_vista ON public.recomendaciones(vista);

-- ============================================================================
-- TABLA: audit_log (TRAZABILIDAD COMPLETA)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.audit_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID NOT NULL REFERENCES public.users(id),
  
  tabla TEXT NOT NULL,
  registro_id UUID NOT NULL,
  accion TEXT NOT NULL, -- INSERT / UPDATE / DELETE
  
  datos_antes JSONB,
  datos_despues JSONB,
  
  ip_address INET,
  user_agent TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_audit_usuario ON public.audit_log(usuario_id);
CREATE INDEX idx_audit_tabla ON public.audit_log(tabla);
CREATE INDEX idx_audit_fecha ON public.audit_log(created_at);

-- ============================================================================
-- FUNCIONES AUXILIARES
-- ============================================================================

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger a todas las tablas relevantes
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_cuarteles_updated_at BEFORE UPDATE ON public.cuarteles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_registros_updated_at BEFORE UPDATE ON public.registros_diarios FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_detenciones_updated_at BEFORE UPDATE ON public.detenciones FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_pnh_updated_at BEFORE UPDATE ON public.inventario_pnh FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_hitos_updated_at BEFORE UPDATE ON public.inventario_hitos FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_sitios_updated_at BEFORE UPDATE ON public.inventario_sitios FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_planificacion_updated_at BEFORE UPDATE ON public.planificacion_anual FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_alertas_updated_at BEFORE UPDATE ON public.alertas FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_recomendaciones_updated_at BEFORE UPDATE ON public.recomendaciones FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Habilitar RLS en todas las tablas
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cuarteles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.registros_diarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.detenciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventario_pnh ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventario_hitos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventario_sitios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.planificacion_anual ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.visitas_preventivas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cooperacion_bilateral ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alertas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recomendaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- POLÍTICAS RLS - DIGITADOR
-- ============================================================================

-- Digitador: puede ver solo sus registros
CREATE POLICY digitador_select_registros ON public.registros_diarios
  FOR SELECT USING (
    auth.uid() = usuario_id AND
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'digitador'
  );

-- Digitador: puede insertar solo en su cuartel
CREATE POLICY digitador_insert_registros ON public.registros_diarios
  FOR INSERT WITH CHECK (
    auth.uid() = usuario_id AND
    cuartel_id = (SELECT cuartel_id FROM public.users WHERE id = auth.uid()) AND
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'digitador'
  );

-- Digitador: no puede editar registros enviados
CREATE POLICY digitador_update_registros ON public.registros_diarios
  FOR UPDATE USING (
    auth.uid() = usuario_id AND
    enviado = false AND
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'digitador'
  );

-- ============================================================================
-- POLÍTICAS RLS - ADMIN OPERACIONES
-- ============================================================================

-- Admin Operaciones: puede ver todo
CREATE POLICY admin_select_all ON public.registros_diarios
  FOR SELECT USING (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'admin_operaciones'
  );

-- Admin Operaciones: puede editar cualquier registro
CREATE POLICY admin_update_all ON public.registros_diarios
  FOR UPDATE USING (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'admin_operaciones'
  );

-- Admin Operaciones: puede insertar planificación
CREATE POLICY admin_insert_planificacion ON public.planificacion_anual
  FOR INSERT WITH CHECK (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'admin_operaciones'
  );

-- ============================================================================
-- POLÍTICAS RLS - COMISARIO
-- ============================================================================

-- Comisario: puede ver todo en modo lectura
CREATE POLICY comisario_select_all ON public.registros_diarios
  FOR SELECT USING (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'comisario'
  );

CREATE POLICY comisario_select_alertas ON public.alertas
  FOR SELECT USING (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'comisario'
  );

CREATE POLICY comisario_select_recomendaciones ON public.recomendaciones
  FOR SELECT USING (
    (SELECT role FROM public.users WHERE id = auth.uid()) = 'comisario'
  );

-- ============================================================================
-- VISTAS MATERIALIZADAS (PARA PERFORMANCE)
-- ============================================================================

-- Vista: Cumplimiento anual de planificación
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_cumplimiento_anual AS
SELECT 
  pa.anio,
  pa.cuartel_id,
  c.nombre AS cuartel_nombre,
  pa.tipo_elemento,
  COUNT(DISTINCT pa.id) AS total_planificado,
  COUNT(DISTINCT CASE WHEN vp.estado = 'cumplida' THEN vp.id END) AS total_cumplido,
  ROUND(
    COUNT(DISTINCT CASE WHEN vp.estado = 'cumplida' THEN vp.id END)::NUMERIC / 
    NULLIF(COUNT(DISTINCT pa.id), 0) * 100, 
    2
  ) AS porcentaje_cumplimiento
FROM public.planificacion_anual pa
LEFT JOIN public.visitas_preventivas vp ON vp.planificacion_id = pa.id
LEFT JOIN public.cuarteles c ON c.id = pa.cuartel_id
GROUP BY pa.anio, pa.cuartel_id, c.nombre, pa.tipo_elemento;

CREATE UNIQUE INDEX ON mv_cumplimiento_anual (anio, cuartel_id, tipo_elemento);

-- Vista: Detenciones por tramo horario
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_detenciones_tramo AS
SELECT 
  DATE_TRUNC('month', fecha) AS mes,
  cuartel_id,
  tramo_horario,
  COUNT(*) AS total_detenciones,
  COUNT(DISTINCT fecha) AS dias_con_detenciones
FROM public.detenciones
GROUP BY DATE_TRUNC('month', fecha), cuartel_id, tramo_horario;

CREATE UNIQUE INDEX ON mv_detenciones_tramo (mes, cuartel_id, tramo_horario);

-- Función para refrescar vistas materializadas
CREATE OR REPLACE FUNCTION refresh_materialized_views()
RETURNS void AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_cumplimiento_anual;
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_detenciones_tramo;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- COMENTARIOS (DOCUMENTACIÓN)
-- ============================================================================

COMMENT ON TABLE public.registros_diarios IS 'Registro único diario por cuartel/turno';
COMMENT ON TABLE public.detenciones IS 'Detenciones registradas por tramo horario (MANDATORIO para análisis)';
COMMENT ON TABLE public.planificacion_anual IS 'Planificación estratégica anual (NO diaria)';
COMMENT ON TABLE public.visitas_preventivas IS 'Ejecución diaria vs planificación anual';
COMMENT ON COLUMN public.detenciones.tramo_horario IS 'Tramo horario autocalculado - OBLIGATORIO para análisis';
COMMENT ON VIEW mv_cumplimiento_anual IS 'Vista materializada: cumplimiento planificación vs ejecución';

-- ============================================================================
-- FIN DEL SCHEMA
-- ============================================================================
