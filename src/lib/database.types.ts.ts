export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          full_name: string
          role: 'digitador' | 'admin_operaciones' | 'comisario'
          cuartel_id: string | null
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email: string
          full_name: string
          role?: 'digitador' | 'admin_operaciones' | 'comisario'
          cuartel_id?: string | null
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          full_name?: string
          role?: 'digitador' | 'admin_operaciones' | 'comisario'
          cuartel_id?: string | null
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      cuarteles: {
        Row: {
          id: string
          nombre: string
          codigo: string
          ubicacion: string | null
          latitud: number | null
          longitud: number | null
          dependiente_de: string | null
          is_active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          nombre: string
          codigo: string
          ubicacion?: string | null
          latitud?: number | null
          longitud?: number | null
          dependiente_de?: string | null
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          nombre?: string
          codigo?: string
          ubicacion?: string | null
          latitud?: number | null
          longitud?: number | null
          dependiente_de?: string | null
          is_active?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      registros_diarios: {
        Row: {
          id: string
          cuartel_id: string
          fecha: string
          turno: 'diurno' | 'nocturno'
          usuario_id: string
          dotacion_efectiva: number
          medios_operativos: Json | null
          procedimientos_relevantes: boolean
          controles_identidad_preventivos: number
          controles_identidad_investigativos: number
          controles_migratorios: number
          controles_vehiculares: number
          infracciones_transito: number
          infracciones_migratorias: number
          infracciones_alcoholes: number
          infracciones_otras: number
          faccion_ejecutora: string | null
          servicios_extraordinarios: Json | null
          cooperacion_bilateral: Json | null
          reuniones_comunitarias: number
          proyectos_activos: number
          conflictos_mediados: number
          lideres_contactados: number
          capacitacion: Json | null
          proyectos: Json | null
          investigaciones: Json | null
          combustible_vehiculos: number | null
          combustible_generador: number | null
          agua_estanques: number | null
          observaciones: string | null
          enviado: boolean
          validado: boolean
          validado_por: string | null
          validado_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          cuartel_id: string
          fecha: string
          turno: 'diurno' | 'nocturno'
          usuario_id: string
          dotacion_efectiva: number
          medios_operativos?: Json | null
          procedimientos_relevantes?: boolean
          controles_identidad_preventivos?: number
          controles_identidad_investigativos?: number
          controles_migratorios?: number
          controles_vehiculares?: number
          infracciones_transito?: number
          infracciones_migratorias?: number
          infracciones_alcoholes?: number
          infracciones_otras?: number
          faccion_ejecutora?: string | null
          servicios_extraordinarios?: Json | null
          cooperacion_bilateral?: Json | null
          reuniones_comunitarias?: number
          proyectos_activos?: number
          conflictos_mediados?: number
          lideres_contactados?: number
          capacitacion?: Json | null
          proyectos?: Json | null
          investigaciones?: Json | null
          combustible_vehiculos?: number | null
          combustible_generador?: number | null
          agua_estanques?: number | null
          observaciones?: string | null
          enviado?: boolean
          validado?: boolean
          validado_por?: string | null
          validado_at?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          cuartel_id?: string
          fecha?: string
          turno?: 'diurno' | 'nocturno'
          usuario_id?: string
          dotacion_efectiva?: number
          medios_operativos?: Json | null
          procedimientos_relevantes?: boolean
          controles_identidad_preventivos?: number
          controles_identidad_investigativos?: number
          controles_migratorios?: number
          controles_vehiculares?: number
          infracciones_transito?: number
          infracciones_migratorias?: number
          infracciones_alcoholes?: number
          infracciones_otras?: number
          faccion_ejecutora?: string | null
          servicios_extraordinarios?: Json | null
          cooperacion_bilateral?: Json | null
          reuniones_comunitarias?: number
          proyectos_activos?: number
          conflictos_mediados?: number
          lideres_contactados?: number
          capacitacion?: Json | null
          proyectos?: Json | null
          investigaciones?: Json | null
          combustible_vehiculos?: number | null
          combustible_generador?: number | null
          agua_estanques?: number | null
          observaciones?: string | null
          enviado?: boolean
          validado?: boolean
          validado_por?: string | null
          validado_at?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      detenciones: {
        Row: {
          id: string
          registro_diario_id: string
          fecha: string
          hora_exacta: string
          tramo_horario: '00:00-05:59' | '06:00-11:59' | '12:00-17:59' | '18:00-23:59'
          cuartel_id: string
          lugar: string
          tipo_delito: string
          modalidad: string | null
          personal_interviniente: string[] | null
          nacionalidad: string | null
          resultado_inicial: string | null
          observaciones: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          registro_diario_id: string
          fecha: string
          hora_exacta: string
          tramo_horario?: '00:00-05:59' | '06:00-11:59' | '12:00-17:59' | '18:00-23:59'
          cuartel_id: string
          lugar: string
          tipo_delito: string
          modalidad?: string | null
          personal_interviniente?: string[] | null
          nacionalidad?: string | null
          resultado_inicial?: string | null
          observaciones?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          registro_diario_id?: string
          fecha?: string
          hora_exacta?: string
          tramo_horario?: '00:00-05:59' | '06:00-11:59' | '12:00-17:59' | '18:00-23:59'
          cuartel_id?: string
          lugar?: string
          tipo_delito?: string
          modalidad?: string | null
          personal_interviniente?: string[] | null
          nacionalidad?: string | null
          resultado_inicial?: string | null
          observaciones?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      alertas: {
        Row: {
          id: string
          tipo: 'combustible_bajo' | 'agua_baja' | 'pnh_no_visitado' | 'investigacion_vencida' | 'brecha_planificacion' | 'otro'
          prioridad: 'baja' | 'media' | 'alta' | 'critica'
          cuartel_id: string | null
          registro_diario_id: string | null
          titulo: string
          descripcion: string
          valor_actual: string | null
          valor_umbral: string | null
          estado: 'activa' | 'resuelta' | 'ignorada'
          fecha_generacion: string
          fecha_resolucion: string | null
          resuelta_por: string | null
          notas_resolucion: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          tipo: 'combustible_bajo' | 'agua_baja' | 'pnh_no_visitado' | 'investigacion_vencida' | 'brecha_planificacion' | 'otro'
          prioridad?: 'baja' | 'media' | 'alta' | 'critica'
          cuartel_id?: string | null
          registro_diario_id?: string | null
          titulo: string
          descripcion: string
          valor_actual?: string | null
          valor_umbral?: string | null
          estado?: 'activa' | 'resuelta' | 'ignorada'
          fecha_generacion?: string
          fecha_resolucion?: string | null
          resuelta_por?: string | null
          notas_resolucion?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          tipo?: 'combustible_bajo' | 'agua_baja' | 'pnh_no_visitado' | 'investigacion_vencida' | 'brecha_planificacion' | 'otro'
          prioridad?: 'baja' | 'media' | 'alta' | 'critica'
          cuartel_id?: string | null
          registro_diario_id?: string | null
          titulo?: string
          descripcion?: string
          valor_actual?: string | null
          valor_umbral?: string | null
          estado?: 'activa' | 'resuelta' | 'ignorada'
          fecha_generacion?: string
          fecha_resolucion?: string | null
          resuelta_por?: string | null
          notas_resolucion?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      recomendaciones: {
        Row: {
          id: string
          fecha: string
          cuartel_id: string | null
          titulo: string
          descripcion: string
          categoria: string | null
          prioridad: 'baja' | 'media' | 'alta' | 'critica'
          fundamento: string | null
          accion_sugerida: string | null
          vista: boolean
          implementada: boolean
          fecha_implementacion: string | null
          resultado_implementacion: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          fecha: string
          cuartel_id?: string | null
          titulo: string
          descripcion: string
          categoria?: string | null
          prioridad?: 'baja' | 'media' | 'alta' | 'critica'
          fundamento?: string | null
          accion_sugerida?: string | null
          vista?: boolean
          implementada?: boolean
          fecha_implementacion?: string | null
          resultado_implementacion?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          fecha?: string
          cuartel_id?: string | null
          titulo?: string
          descripcion?: string
          categoria?: string | null
          prioridad?: 'baja' | 'media' | 'alta' | 'critica'
          fundamento?: string | null
          accion_sugerida?: string | null
          vista?: boolean
          implementada?: boolean
          fecha_implementacion?: string | null
          resultado_implementacion?: string | null
          created_at?: string
          updated_at?: string
        }
      }
    }
    Views: {
      mv_cumplimiento_anual: {
        Row: {
          anio: number
          cuartel_id: string
          cuartel_nombre: string
          tipo_elemento: 'pnh' | 'hito' | 'sitio'
          total_planificado: number
          total_cumplido: number
          porcentaje_cumplimiento: number
        }
      }
      mv_detenciones_tramo: {
        Row: {
          mes: string
          cuartel_id: string
          tramo_horario: '00:00-05:59' | '06:00-11:59' | '12:00-17:59' | '18:00-23:59'
          total_detenciones: number
          dias_con_detenciones: number
        }
      }
    }
    Functions: {
      calcular_tramo_horario: {
        Args: { hora: string }
        Returns: '00:00-05:59' | '06:00-11:59' | '12:00-17:59' | '18:00-23:59'
      }
      refresh_materialized_views: {
        Args: Record<string, never>
        Returns: void
      }
    }
  }
}
