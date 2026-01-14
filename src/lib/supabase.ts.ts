import { createClient } from '@supabase/supabase-js'
import type { Database } from './database.types'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error(
    'Missing Supabase environment variables. Please check your .env file.'
  )
}

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
  },
  db: {
    schema: 'public',
  },
  global: {
    headers: {
      'X-Client-Info': 'sicof-nucleo',
    },
  },
})

// Helper para verificar autenticación
export const getCurrentUser = async () => {
  const { data: { user }, error } = await supabase.auth.getUser()
  if (error) throw error
  return user
}

// Helper para obtener perfil completo del usuario
export const getUserProfile = async () => {
  const user = await getCurrentUser()
  if (!user) return null

  const { data, error } = await supabase
    .from('users')
    .select('*, cuarteles(*)')
    .eq('id', user.id)
    .single()

  if (error) throw error
  return data
}

// Helper para verificar permisos por rol
export const hasRole = async (role: 'digitador' | 'admin_operaciones' | 'comisario') => {
  const profile = await getUserProfile()
  return profile?.role === role
}

export const hasAnyRole = async (roles: Array<'digitador' | 'admin_operaciones' | 'comisario'>) => {
  const profile = await getUserProfile()
  return profile?.role ? roles.includes(profile.role) : false
}
