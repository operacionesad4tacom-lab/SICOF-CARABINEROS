import { FileText, Plus } from 'lucide-react'

export default function DailyRegistry() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-display font-bold text-slate-900 dark:text-white mb-2">
            Registro Diario
          </h1>
          <p className="text-slate-600 dark:text-slate-400">
            Registra la labor operativa del día
          </p>
        </div>
        <button className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg shadow-lg transition-colors">
          <Plus className="h-5 w-5" />
          Nuevo Registro
        </button>
      </div>

      <div className="bg-white dark:bg-slate-800 rounded-xl p-8 shadow-lg border border-slate-200/50 dark:border-slate-700/50 text-center">
        <FileText className="h-16 w-16 text-slate-400 mx-auto mb-4" />
        <h2 className="text-xl font-semibold text-slate-900 dark:text-white mb-2">
          Formulario de Registro Diario
        </h2>
        <p className="text-slate-600 dark:text-slate-400 mb-6">
          Aquí se implementará el formulario completo de registro con todos los módulos:
        </p>
        <ul className="text-left max-w-md mx-auto space-y-2 text-slate-600 dark:text-slate-400">
          <li>✓ Identificación diaria</li>
          <li>✓ Demanda ciudadana</li>
          <li>✓ Demanda preventiva fronteriza</li>
          <li>✓ Cooperación e integración</li>
          <li>✓ Operaciones internas</li>
          <li>✓ Registro de detenciones por tramo horario</li>
        </ul>
      </div>
    </div>
  )
}
