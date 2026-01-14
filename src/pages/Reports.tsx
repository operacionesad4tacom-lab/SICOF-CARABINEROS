import { BarChart3, Download, FileText } from 'lucide-react'

export default function Reports() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-display font-bold text-slate-900 dark:text-white mb-2">
            Reportes y Análisis
          </h1>
          <p className="text-slate-600 dark:text-slate-400">
            Visualiza y descarga reportes del sistema
          </p>
        </div>
        <button className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg shadow-lg transition-colors">
          <Download className="h-5 w-5" />
          Exportar Datos
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Reporte Diario */}
        <div className="bg-white dark:bg-slate-800 rounded-xl p-6 shadow-lg border border-slate-200/50 dark:border-slate-700/50 hover:shadow-xl transition-shadow cursor-pointer">
          <div className="p-3 rounded-lg bg-blue-50 dark:bg-blue-900/30 w-fit mb-4">
            <FileText className="h-6 w-6 text-blue-600 dark:text-blue-400" />
          </div>
          <h3 className="text-lg font-semibold text-slate-900 dark:text-white mb-2">
            Reporte Diario
          </h3>
          <p className="text-sm text-slate-600 dark:text-slate-400 mb-4">
            Reporte automático con estado administrativo, labor del día y alertas
          </p>
          <button className="text-blue-600 dark:text-blue-400 text-sm font-medium hover:underline">
            Generar reporte →
          </button>
        </div>

        {/* Reporte Mensual */}
        <div className="bg-white dark:bg-slate-800 rounded-xl p-6 shadow-lg border border-slate-200/50 dark:border-slate-700/50 hover:shadow-xl transition-shadow cursor-pointer">
          <div className="p-3 rounded-lg bg-green-50 dark:bg-green-900/30 w-fit mb-4">
            <BarChart3 className="h-6 w-6 text-green-600 dark:text-green-400" />
          </div>
          <h3 className="text-lg font-semibold text-slate-900 dark:text-white mb-2">
            Reporte Mensual
          </h3>
          <p className="text-sm text-slate-600 dark:text-slate-400 mb-4">
            Consolidado mensual de operaciones y cumplimiento
          </p>
          <button className="text-green-600 dark:text-green-400 text-sm font-medium hover:underline">
            Generar reporte →
          </button>
        </div>

        {/* Reporte Anual (YTD) */}
        <div className="bg-white dark:bg-slate-800 rounded-xl p-6 shadow-lg border border-slate-200/50 dark:border-slate-700/50 hover:shadow-xl transition-shadow cursor-pointer">
          <div className="p-3 rounded-lg bg-purple-50 dark:bg-purple-900/30 w-fit mb-4">
            <BarChart3 className="h-6 w-6 text-purple-600 dark:text-purple-400" />
          </div>
          <h3 className="text-lg font-semibold text-slate-900 dark:text-white mb-2">
            Reporte Anual (YTD)
          </h3>
          <p className="text-sm text-slate-600 dark:text-slate-400 mb-4">
            Acumulado año a la fecha con análisis de tendencias
          </p>
          <button className="text-purple-600 dark:text-purple-400 text-sm font-medium hover:underline">
            Generar reporte →
          </button>
        </div>
      </div>

      <div className="bg-white dark:bg-slate-800 rounded-xl p-8 shadow-lg border border-slate-200/50 dark:border-slate-700/50 text-center">
        <BarChart3 className="h-16 w-16 text-slate-400 mx-auto mb-4" />
        <h2 className="text-xl font-semibold text-slate-900 dark:text-white mb-2">
          Sistema de Reportería
        </h2>
        <p className="text-slate-600 dark:text-slate-400 mb-6">
          El módulo de reportes incluirá:
        </p>
        <ul className="text-left max-w-md mx-auto space-y-2 text-slate-600 dark:text-slate-400">
          <li>✓ Reporte diario automático al Comisario</li>
          <li>✓ Dashboard con indicadores clave</li>
          <li>✓ Análisis de detenciones por tramo horario</li>
          <li>✓ Cumplimiento de planificación anual</li>
          <li>✓ Exportación a PDF y Excel</li>
          <li>✓ Históricos y tendencias</li>
        </ul>
      </div>
    </div>
  )
}
