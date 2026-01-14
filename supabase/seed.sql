-- ============================================================================
-- SICOF NÚCLEO - DATOS SEMILLA (SEED DATA)
-- Datos iniciales para desarrollo y pruebas
-- ============================================================================

-- Limpiar datos existentes (solo para desarrollo)
TRUNCATE TABLE 
  public.audit_log,
  public.recomendaciones,
  public.alertas,
  public.cooperacion_bilateral,
  public.visitas_preventivas,
  public.planificacion_anual,
  public.detenciones,
  public.registros_diarios,
  public.inventario_sitios,
  public.inventario_hitos,
  public.inventario_pnh,
  public.users,
  public.cuarteles
CASCADE;

-- ============================================================================
-- CUARTELES
-- ============================================================================

INSERT INTO public.cuarteles (id, nombre, codigo, ubicacion, latitud, longitud) VALUES
  ('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', '4ª Comisaría Chacalluta', 'CHAC-001', 'Arica, Región de Arica y Parinacota', -18.4783, -70.3126),
  ('b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'Retén Putre', 'PUTR-001', 'Putre, Región de Arica y Parinacota', -18.1950, -69.5573),
  ('c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', 'Retén Visviri', 'VISV-001', 'Visviri, Región de Arica y Parinacota', -17.5833, -69.4833);

-- ============================================================================
-- INVENTARIOS
-- ============================================================================

-- Pasos No Habilitados (PNH)
INSERT INTO public.inventario_pnh (cuartel_id, nombre, codigo, ubicacion, latitud, longitud, riesgo_asociado) VALUES
  ('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'PNH Chacalluta Norte', 'PNH-001', 'Frontera Norte Chacalluta', -18.4500, -70.3000, 'Tráfico ilegal de mercancías'),
  ('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'PNH Quebrada de Acha', 'PNH-002', 'Quebrada de Acha', -18.5200, -70.2800, 'Ingreso irregular de personas'),
  ('b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'PNH Socoroma', 'PNH-003', 'Socoroma', -18.2833, -69.6167, 'Tráfico de drogas');

-- Hitos Fronterizos
INSERT INTO public.inventario_hitos (cuartel_id, nombre, numero_hito, ubicacion, latitud, longitud, estado_conservacion) VALUES
  ('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Hito Fronterizo 1', 'H-001', 'Frontera Chile-Perú km 0', -18.3500, -70.3300, 'Bueno'),
  ('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Hito Fronterizo 2', 'H-002', 'Frontera Chile-Perú km 5', -18.3600, -70.3400, 'Regular'),
  ('b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'Hito Fronterizo 15', 'H-015', 'Zona Altiplánica', -18.2000, -69.5000, 'Bueno'),
  ('c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', 'Hito Tripartito', 'H-TRI', 'Frontera Chile-Perú-Bolivia', -17.5833, -69.4833, 'Excelente');

-- Sitios de Interés
INSERT INTO public.inventario_sitios (cuartel_id, nombre, tipo, ubicacion, nivel_interes) VALUES
  ('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Terminal Internacional Chacalluta', 'estratégico', 'Chacalluta', 'alta'),
  ('a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'Zona Franca Iquique', 'comercial', 'Alto Hospicio', 'media'),
  ('b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'Parque Nacional Lauca', 'turístico', 'Putre', 'media'),
  ('c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', 'Complejo Minero', 'minero', 'Visviri', 'alta');

-- ============================================================================
-- NOTA: Los usuarios deben crearse a través de Supabase Auth
-- Luego se asocian en la tabla users con su rol y cuartel
-- ============================================================================

-- Ejemplo de cómo asociar usuarios después de crearlos en Supabase Auth:
/*
-- Primero crear el usuario en Supabase Auth Dashboard, luego ejecutar:

INSERT INTO public.users (id, email, full_name, role, cuartel_id)
VALUES 
  -- Reemplaza 'auth-user-uuid-aqui' con el UUID real del usuario de Auth
  ('auth-user-uuid-comisario', 'comisario@test.com', 'Carlos Comisario', 'comisario', 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d'),
  ('auth-user-uuid-admin', 'admin@test.com', 'Ana Administradora', 'admin_operaciones', 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d'),
  ('auth-user-uuid-digitador', 'digitador@test.com', 'Diego Digitador', 'digitador', 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d');
*/

-- ============================================================================
-- PLANIFICACIÓN ANUAL 2026 (Ejemplo)
-- ============================================================================

-- Planificación de visitas a PNH
INSERT INTO public.planificacion_anual (
  anio, 
  cuartel_id, 
  tipo_elemento, 
  elemento_id, 
  frecuencia, 
  prioridad,
  mes_inicio,
  mes_fin,
  objetivo,
  created_by
) VALUES
  (2026, 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'pnh', (SELECT id FROM public.inventario_pnh WHERE codigo = 'PNH-001'), 'mensual', 'alta', 1, 12, 'Control preventivo permanente', (SELECT id FROM public.users LIMIT 1)),
  (2026, 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'pnh', (SELECT id FROM public.inventario_pnh WHERE codigo = 'PNH-002'), 'trimestral', 'media', 1, 12, 'Monitoreo periódico', (SELECT id FROM public.users LIMIT 1)),
  (2026, 'b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'pnh', (SELECT id FROM public.inventario_pnh WHERE codigo = 'PNH-003'), 'mensual', 'critica', 1, 12, 'Prevención de narcotráfico', (SELECT id FROM public.users LIMIT 1));

-- Planificación de visitas a Hitos
INSERT INTO public.planificacion_anual (
  anio, 
  cuartel_id, 
  tipo_elemento, 
  elemento_id, 
  frecuencia, 
  prioridad,
  mes_inicio,
  mes_fin,
  objetivo,
  created_by
) VALUES
  (2026, 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'hito', (SELECT id FROM public.inventario_hitos WHERE numero_hito = 'H-001'), 'semestral', 'media', 1, 12, 'Verificación de demarcación', (SELECT id FROM public.users LIMIT 1)),
  (2026, 'b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'hito', (SELECT id FROM public.inventario_hitos WHERE numero_hito = 'H-015'), 'trimestral', 'media', 1, 12, 'Mantenimiento y registro', (SELECT id FROM public.users LIMIT 1)),
  (2026, 'c3d4e5f6-a7b8-6c7d-0e1f-2a3b4c5d6e7f', 'hito', (SELECT id FROM public.inventario_hitos WHERE numero_hito = 'H-TRI'), 'mensual', 'alta', 1, 12, 'Control tripartito', (SELECT id FROM public.users LIMIT 1));

-- Planificación de visitas a Sitios de Interés
INSERT INTO public.planificacion_anual (
  anio, 
  cuartel_id, 
  tipo_elemento, 
  elemento_id, 
  frecuencia, 
  prioridad,
  mes_inicio,
  mes_fin,
  objetivo,
  created_by
) VALUES
  (2026, 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 'sitio', (SELECT id FROM public.inventario_sitios WHERE nombre = 'Terminal Internacional Chacalluta'), 'mensual', 'alta', 1, 12, 'Coordinación y presencia', (SELECT id FROM public.users LIMIT 1)),
  (2026, 'b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 'sitio', (SELECT id FROM public.inventario_sitios WHERE nombre = 'Parque Nacional Lauca'), 'trimestral', 'media', 3, 11, 'Temporada turística', (SELECT id FROM public.users LIMIT 1));

-- ============================================================================
-- DATOS DE EJEMPLO - REGISTROS Y DETENCIONES (últimos 7 días)
-- ============================================================================

-- Generar registros de los últimos 7 días
DO $$
DECLARE
  fecha_actual DATE := CURRENT_DATE;
  i INTEGER;
  cuartel_id UUID := 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d';
  usuario_id UUID := (SELECT id FROM public.users LIMIT 1);
  registro_id UUID;
BEGIN
  FOR i IN 0..6 LOOP
    -- Registro turno diurno
    INSERT INTO public.registros_diarios (
      cuartel_id,
      fecha,
      turno,
      usuario_id,
      dotacion_efectiva,
      medios_operativos,
      controles_identidad_preventivos,
      controles_identidad_investigativos,
      controles_migratorios,
      controles_vehiculares,
      infracciones_transito,
      combustible_vehiculos,
      agua_estanques,
      enviado,
      validado
    ) VALUES (
      cuartel_id,
      fecha_actual - i,
      'diurno',
      usuario_id,
      12 + (random() * 3)::INTEGER,
      jsonb_build_object('vehiculos', 4, 'motos', 2),
      50 + (random() * 20)::INTEGER,
      10 + (random() * 5)::INTEGER,
      30 + (random() * 15)::INTEGER,
      25 + (random() * 10)::INTEGER,
      5 + (random() * 3)::INTEGER,
      150 + (random() * 50),
      85 + (random() * 10),
      true,
      true
    ) RETURNING id INTO registro_id;

    -- Insertar algunas detenciones de ejemplo
    INSERT INTO public.detenciones (
      registro_diario_id,
      fecha,
      hora_exacta,
      cuartel_id,
      lugar,
      tipo_delito,
      modalidad,
      nacionalidad
    ) VALUES
      (registro_id, fecha_actual - i, '02:30:00', cuartel_id, 'Terminal Chacalluta', 'Tráfico ilegal', 'flagrancia', 'Peruana'),
      (registro_id, fecha_actual - i, '14:15:00', cuartel_id, 'PNH Chacalluta Norte', 'Infracción migratoria', 'flagrancia', 'Boliviana'),
      (registro_id, fecha_actual - i, '20:45:00', cuartel_id, 'Ruta A-15', 'Conducción bajo influencia', 'flagrancia', 'Chilena');

    -- Registro turno nocturno
    INSERT INTO public.registros_diarios (
      cuartel_id,
      fecha,
      turno,
      usuario_id,
      dotacion_efectiva,
      medios_operativos,
      controles_identidad_preventivos,
      controles_migratorios,
      combustible_vehiculos,
      agua_estanques,
      enviado,
      validado
    ) VALUES (
      cuartel_id,
      fecha_actual - i,
      'nocturno',
      usuario_id,
      8 + (random() * 2)::INTEGER,
      jsonb_build_object('vehiculos', 3, 'motos', 1),
      30 + (random() * 10)::INTEGER,
      20 + (random() * 8)::INTEGER,
      120 + (random() * 30),
      82 + (random() * 8),
      true,
      true
    );
  END LOOP;
END $$;

-- ============================================================================
-- ALERTAS DE EJEMPLO
-- ============================================================================

INSERT INTO public.alertas (
  tipo,
  prioridad,
  cuartel_id,
  titulo,
  descripcion,
  valor_actual,
  valor_umbral,
  estado
) VALUES
  ('combustible_bajo', 'media', 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 
   'Combustible bajo umbral', 
   'El nivel de combustible vehicular está por debajo del umbral recomendado',
   '145 litros', '200 litros', 'activa'),
  
  ('pnh_no_visitado', 'alta', 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d',
   'PNH sin visita planificada',
   'El PNH-002 no ha sido visitado según planificación mensual',
   '0 visitas', '1 visita/mes', 'activa');

-- ============================================================================
-- RECOMENDACIONES DE EJEMPLO
-- ============================================================================

INSERT INTO public.recomendaciones (
  fecha,
  cuartel_id,
  titulo,
  descripcion,
  categoria,
  prioridad,
  fundamento,
  accion_sugerida
) VALUES
  (CURRENT_DATE, 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d',
   'Reforzar patrullaje nocturno',
   'Se detecta aumento de detenciones en tramo 18:00-23:59',
   'operativo', 'media',
   'Análisis de detenciones por tramo horario muestra concentración en horario nocturno',
   'Aumentar dotación nocturna en 2 efectivos durante fines de semana'),
  
  (CURRENT_DATE, 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d',
   'Gestionar abastecimiento de combustible',
   'Nivel de combustible por debajo del umbral operativo',
   'logístico', 'alta',
   'Consumo promedio diario: 180 litros. Stock actual: 145 litros',
   'Solicitar reabastecimiento urgente de al menos 300 litros');

-- ============================================================================
-- REFRESH DE VISTAS MATERIALIZADAS
-- ============================================================================

SELECT refresh_materialized_views();

-- ============================================================================
-- VERIFICACIÓN FINAL
-- ============================================================================

-- Contar registros insertados
DO $$
BEGIN
  RAISE NOTICE 'Cuarteles creados: %', (SELECT COUNT(*) FROM public.cuarteles);
  RAISE NOTICE 'PNH creados: %', (SELECT COUNT(*) FROM public.inventario_pnh);
  RAISE NOTICE 'Hitos creados: %', (SELECT COUNT(*) FROM public.inventario_hitos);
  RAISE NOTICE 'Sitios creados: %', (SELECT COUNT(*) FROM public.inventario_sitios);
  RAISE NOTICE 'Registros diarios: %', (SELECT COUNT(*) FROM public.registros_diarios);
  RAISE NOTICE 'Detenciones: %', (SELECT COUNT(*) FROM public.detenciones);
  RAISE NOTICE 'Alertas activas: %', (SELECT COUNT(*) FROM public.alertas WHERE estado = 'activa');
  RAISE NOTICE 'Recomendaciones: %', (SELECT COUNT(*) FROM public.recomendaciones);
  RAISE NOTICE '';
  RAISE NOTICE '✅ Datos semilla insertados correctamente';
END $$;
