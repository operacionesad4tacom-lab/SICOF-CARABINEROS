import { Calendar, Plus } from 'lucide-react'

export default function Planning() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-display font-bold text-slate-900 dark:text-white mb-2">
            Planificación Anual
          </h1>
          <p className="text-slate-600 dark:text-slate-400">
            Gestiona la planificación estratégica anual
          </p>
        </div>
        <button className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg shadow-lg transition-colors">
          <Plus className="h-5 w-5" />
          Nueva Planificación
        </button>
      </div>

      <div className="bg-white dark:bg-slate-800 rounded-xl p-8 shadow-lg border border-slate-200/50 dark:border-slate-700/50 text-center">
        <Calendar className="h-16 w-16 text-slate-400 mx-auto mb-4" />
        <h2 className="text-xl font-semibold text-slate-900 dark:text-white mb-2">
          Módulo de Planificación Anual
        </h2>
        <p className="text-slate-600 dark:text-slate-400 mb-6">
          Aquí se implementará la gestión de planificación anual:
        </p>
        <ul className="text-left max-w-md mx-auto space-y-2 text-slate-600 dark:text-slate-400">
          <li>✓ Planificación de visitas a PNH</li>
          <li>✓ Planificación de visitas a Hitos Fronterizos</li>
          <li>✓ Planificación de visitas a Sitios de Interés</li>
          <li>✓ Planificación de cooperación bilateral</li>
          <li>✓ Frecuencias y prioridades</li>
          <li>✓ Seguimiento de cumplimiento</li>
        </ul>
        <div className="mt-6 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
          <p className="text-sm text-blue-700 dark:text-blue-400 font-medium">
            ℹ️ Recuerda: La planificación es anual y estratégica; la ejecución es diaria y declarativa.
          </p>
        </div>
      </div>
    </div>
  )
}
