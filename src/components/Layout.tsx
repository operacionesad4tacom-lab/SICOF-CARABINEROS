import { ReactNode, useState } from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import { supabase, getUserProfile } from '@/lib/supabase'
import { useQuery } from '@tanstack/react-query'
import {
  LayoutDashboard,
  FileText,
  Calendar,
  BarChart3,
  LogOut,
  Menu,
  X,
  Bell,
  User,
} from 'lucide-react'

interface LayoutProps {
  children: ReactNode
}

export default function Layout({ children }: LayoutProps) {
  const location = useLocation()
  const navigate = useNavigate()
  const [sidebarOpen, setSidebarOpen] = useState(false)

  const { data: profile } = useQuery({
    queryKey: ['user-profile'],
    queryFn: getUserProfile,
  })

  const handleLogout = async () => {
    await supabase.auth.signOut()
    navigate('/login')
  }

  const navigation = [
    {
      name: 'Dashboard',
      href: '/',
      icon: LayoutDashboard,
      roles: ['digitador', 'admin_operaciones', 'comisario'],
    },
    {
      name: 'Registro Diario',
      href: '/registro',
      icon: FileText,
      roles: ['digitador', 'admin_operaciones'],
    },
    {
      name: 'Planificación',
      href: '/planificacion',
      icon: Calendar,
      roles: ['admin_operaciones'],
    },
    {
      name: 'Reportes',
      href: '/reportes',
      icon: BarChart3,
      roles: ['admin_operaciones', 'comisario'],
    },
  ]

  const filteredNavigation = navigation.filter((item) =>
    profile?.role ? item.roles.includes(profile.role) : false
  )

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-slate-100 dark:from-slate-900 dark:via-blue-950 dark:to-slate-900">
      {/* Mobile sidebar backdrop */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-black/50 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`
          fixed inset-y-0 left-0 z-50 w-64 transform bg-white/80 backdrop-blur-xl 
          shadow-2xl transition-transform duration-300 ease-in-out lg:translate-x-0
          dark:bg-slate-900/80 border-r border-slate-200/50 dark:border-slate-700/50
          ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'}
        `}
      >
        <div className="flex h-full flex-col">
          {/* Logo */}
          <div className="flex h-16 items-center justify-between px-6 border-b border-slate-200/50 dark:border-slate-700/50">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-gradient-to-br from-blue-600 to-blue-400 flex items-center justify-center shadow-lg">
                <span className="text-white font-bold text-lg">S</span>
              </div>
              <div>
                <h1 className="text-lg font-display font-bold text-slate-900 dark:text-white">
                  SICOF
                </h1>
                <p className="text-xs text-slate-500 dark:text-slate-400">Núcleo</p>
              </div>
            </div>
            <button
              onClick={() => setSidebarOpen(false)}
              className="lg:hidden p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800"
            >
              <X className="h-5 w-5" />
            </button>
          </div>

          {/* Navigation */}
          <nav className="flex-1 space-y-1 px-3 py-4 custom-scrollbar overflow-y-auto">
            {filteredNavigation.map((item) => {
              const isActive = location.pathname === item.href
              return (
                <Link
                  key={item.name}
                  to={item.href}
                  className={`
                    flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium
                    transition-all duration-200 group
                    ${
                      isActive
                        ? 'bg-blue-50 text-blue-700 shadow-sm dark:bg-blue-900/30 dark:text-blue-300'
                        : 'text-slate-700 hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800/50'
                    }
                  `}
                >
                  <item.icon
                    className={`h-5 w-5 transition-transform group-hover:scale-110 ${
                      isActive ? 'text-blue-600 dark:text-blue-400' : 'text-slate-500'
                    }`}
                  />
                  {item.name}
                </Link>
              )
            })}
          </nav>

          {/* User info */}
          <div className="border-t border-slate-200/50 dark:border-slate-700/50 p-4">
            <div className="flex items-center gap-3 mb-3 px-2">
              <div className="h-10 w-10 rounded-full bg-gradient-to-br from-slate-200 to-slate-300 dark:from-slate-700 dark:to-slate-600 flex items-center justify-center">
                <User className="h-5 w-5 text-slate-600 dark:text-slate-300" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-slate-900 dark:text-white truncate">
                  {profile?.full_name}
                </p>
                <p className="text-xs text-slate-500 dark:text-slate-400 capitalize">
                  {profile?.role?.replace('_', ' ')}
                </p>
              </div>
            </div>
            <button
              onClick={handleLogout}
              className="flex w-full items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium text-red-700 hover:bg-red-50 dark:text-red-400 dark:hover:bg-red-900/20 transition-colors"
            >
              <LogOut className="h-4 w-4" />
              Cerrar Sesión
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <div className="lg:pl-64">
        {/* Top bar */}
        <header className="sticky top-0 z-30 flex h-16 items-center gap-4 border-b border-slate-200/50 dark:border-slate-700/50 bg-white/80 backdrop-blur-xl px-6 dark:bg-slate-900/80">
          <button
            onClick={() => setSidebarOpen(true)}
            className="lg:hidden p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800"
          >
            <Menu className="h-5 w-5" />
          </button>

          <div className="flex-1" />

          {/* Notifications */}
          <button className="relative p-2 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors">
            <Bell className="h-5 w-5 text-slate-600 dark:text-slate-300" />
            <span className="absolute top-1 right-1 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white dark:ring-slate-900" />
          </button>
        </header>

        {/* Page content */}
        <main className="p-6 lg:p-8">
          <div className="mx-auto max-w-7xl animate-fade-in">{children}</div>
        </main>
      </div>
    </div>
  )
}
