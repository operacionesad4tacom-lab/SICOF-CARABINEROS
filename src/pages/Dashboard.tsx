import { useQuery } from '@tanstack/react-query'
import { supabase, getUserProfile } from '@/lib/supabase'
import {
  TrendingUp,
  Users,
  AlertTriangle,
  CheckCircle,
  Calendar,
  Activity,
  ArrowUpRight,
  ArrowDownRight,
} from 'lucide-react'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts'

export default function Dashboard() {
  const { data: profile } = useQuery({
    queryKey: ['user-profile'],
    queryFn: getUserProfile,
  })

  const { data: alertas } = useQuery({
    queryKey: ['alertas-activas'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('alertas')
        .select('*')
        .eq('estado', 'activa')
        .order('prioridad', { ascending: false })
        .limit(5)
      
      if (error) throw error
      return data
    },
  })

  const { data: stats } = useQuery({
    queryKey: ['dashboard-stats'],
    queryFn: async () => {
      // Obtener estadísticas básicas
      const today = new Date().toISOString().split('T')[0]
      
      const { count: registrosHoy } = await supabase
        .from('registros_diarios')
        .select('*', { count: 'exact', head: true })
        .eq('fecha', today)
      
      const { count: detencionesHoy } = await supabase
        .from('detenciones')
        .select('*', { count: 'exact', head: true })
        .eq('fecha', today)
      
      return {
        registrosHoy: registrosHoy || 0,
        detencionesHoy: detencionesHoy || 0,
        alertasActivas: alertas?.length || 0,
        cumplimiento: 87.5, // Esto vendría de mv_cumplimiento_anual
      }
    },
    enabled: !!alertas,
  })

  // Datos de ejemplo para gráficos
  const detencionesPorTramo = [
    { tramo: '00-06', detenciones: 12 },
    { tramo: '06-12', detenciones: 8 },
    { tramo: '12-18', detenciones: 15 },
    { tramo: '18-24', detenciones: 22 },
  ]

  const cumplimientoPorTipo = [
    { name: 'PNH', value: 85, color: '#3b82f6' },
    { name: 'Hitos', value: 92, color: '#10b981' },
    { name: 'Sitios', value: 78, color: '#f59e0b' },
  ]

  const StatCard = ({ 
    title, 
    value, 
    change, 
    icon: Icon, 
    trend = 'up' 
  }: { 
    title: string
    value: string | number
    change?: string
    icon: any
    trend?: 'up' | 'down' | 'neutral'
  }) => (
    <div className="bg-white dark:bg-slate-800 rounded-xl p-6 shadow-lg border border-slate-200/50 dark:border-slate-700/50 hover:shadow-xl transition-shadow">
      <div className="flex items-start justify-between mb-4">
        <div className="p-3 rounded-lg bg-blue-50 dark:bg-blue-900/30">
          <Icon className="h-6 w-6 text-blue-600 dark:text-blue-400" />
        </div>
        {change && (
          <div className={`flex items-center gap-1 text-sm font-medium ${
            trend === 'up' ? 'text-green-600' : trend === 'down' ? 'text-red-600' : 'text-slate-600'
          }`}>
            {trend === 'up' ? (
              <ArrowUpRight className="h-4 w-4" />
            ) : trend === 'down' ? (
              <ArrowDownRight className="h-4 w-4" />
            ) : null}
            {change}
          </div>
        )}
      </div>
      <h3 className="text-2xl font-display font-bold text-slate-900 dark:text-white mb-1">
        {value}
      </h3>
      <p className="text-sm text-slate-600 dark:text-slate-400">{title}</p>
    </div>
  )

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-display font-bold text-slate-900 dark:text-white mb-2">
          Dashboard Operativo
        </h1>
        <p className="text-slate-600 dark:text-slate-400">
          Bienvenido, {profile?.full_name} | {new Date().toLocaleDateString('es-CL', { 
            weekday: 'long', 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
          })}
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Registros Hoy"
          value={stats?.registrosHoy || 0}
          change="+12%"
          icon={Activity}
          trend="up"
        />
        <StatCard
          title="Detenciones Hoy"
          value={stats?.detencionesHoy || 0}
          change="-8%"
          icon={Users}
          trend="down"
        />
        <StatCard
          title="Alertas Activas"
          value={stats?.alertasActivas || 0}
          icon={AlertTriangle}
          trend="neutral"
        />
        <StatCard
          title="Cumplimiento Anual"
          value={`${stats?.cumplimiento || 0}%`}
          change="+2.5%"
          icon={CheckCircle}
          trend="up"
        />
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Detenciones por Tramo Horario */}
        <div className="bg-white dark:bg-slate-800 rounded-xl p-6 shadow-lg border border-slate-200/50 dark:border-slate-700/50">
          <h2 className="text-lg font-display font-semibold text-slate-900 dark:text-white mb-4">
            Detenciones por Tramo Horario
          </h2>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={detencionesPorTramo}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
              <XAxis dataKey="tramo" stroke="#64748b" />
              <YAxis stroke="#64748b" />
              <Tooltip 
                contentStyle={{ 
                  backgroundColor: '#fff', 
                  border: '1px solid #e2e8f0',
                  borderRadius: '8px'
                }}
              />
              <Bar dataKey="detenciones" fill="#3b82f6" radius={[8, 8, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Cumplimiento por Tipo */}
        <div className="bg-white dark:bg-slate-800 rounded-xl p-6 shadow-lg border border-slate-200/50 dark:border-slate-700/50">
          <h2 className="text-lg font-display font-semibold text-slate-900 dark:text-white mb-4">
            Cumplimiento por Tipo
          </h2>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie
                data={cumplimientoPorTipo}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ name, value }) => `${name}: ${value}%`}
                outerRadius={100}
                fill="#8884d8"
                dataKey="value"
              >
                {cumplimientoPorTipo.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Alertas Activas */}
      <div className="bg-white dark:bg-slate-800 rounded-xl p-6 shadow-lg border border-slate-200/50 dark:border-slate-700/50">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-display font-semibold text-slate-900 dark:text-white">
            Alertas Activas
          </h2>
          <span className="text-sm text-slate-600 dark:text-slate-400">
            {alertas?.length || 0} alertas
          </span>
        </div>
        
        {!alertas || alertas.length === 0 ? (
          <div className="text-center py-8">
            <CheckCircle className="h-12 w-12 text-green-500 mx-auto mb-3" />
            <p className="text-slate-600 dark:text-slate-400">
              No hay alertas activas en este momento
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {alertas.map((alerta) => (
              <div
                key={alerta.id}
                className="flex items-start gap-4 p-4 rounded-lg bg-slate-50 dark:bg-slate-900/50 border border-slate-200 dark:border-slate-700"
              >
                <div className={`p-2 rounded-lg ${
                  alerta.prioridad === 'critica' ? 'bg-red-100 dark:bg-red-900/30' :
                  alerta.prioridad === 'alta' ? 'bg-orange-100 dark:bg-orange-900/30' :
                  alerta.prioridad === 'media' ? 'bg-yellow-100 dark:bg-yellow-900/30' :
                  'bg-blue-100 dark:bg-blue-900/30'
                }`}>
                  <AlertTriangle className={`h-5 w-5 ${
                    alerta.prioridad === 'critica' ? 'text-red-600' :
                    alerta.prioridad === 'alta' ? 'text-orange-600' :
                    alerta.prioridad === 'media' ? 'text-yellow-600' :
                    'text-blue-600'
                  }`} />
                </div>
                <div className="flex-1">
                  <h3 className="font-medium text-slate-900 dark:text-white mb-1">
                    {alerta.titulo}
                  </h3>
                  <p className="text-sm text-slate-600 dark:text-slate-400">
                    {alerta.descripcion}
                  </p>
                </div>
                <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                  alerta.prioridad === 'critica' ? 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400' :
                  alerta.prioridad === 'alta' ? 'bg-orange-100 text-orange-700 dark:bg-orange-900/30 dark:text-orange-400' :
                  alerta.prioridad === 'media' ? 'bg-yellow-100 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-400' :
                  'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400'
                }`}>
                  {alerta.prioridad}
                </span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
