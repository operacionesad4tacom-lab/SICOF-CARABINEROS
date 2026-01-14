import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { Toaster } from 'sonner'
import { useEffect, useState } from 'react'
import { supabase } from './lib/supabase'
import type { Session } from '@supabase/supabase-js'

// Pages (to be created)
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'
import DailyRegistry from './pages/DailyRegistry'
import Planning from './pages/Planning'
import Reports from './pages/Reports'
import Layout from './components/Layout'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      retry: 1,
    },
  },
})

function App() {
  const [session, setSession] = useState<Session | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session)
      setLoading(false)
    })

    // Listen for auth changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
    })

    return () => subscription.unsubscribe()
  }, [])

  if (loading) {
    return (
      <div className="flex h-screen items-center justify-center">
        <div className="text-center">
          <div className="mb-4 h-12 w-12 animate-spin rounded-full border-4 border-primary border-t-transparent mx-auto"></div>
          <p className="text-muted-foreground">Cargando SICOF...</p>
        </div>
      </div>
    )
  }

  return (
    <QueryClientProvider client={queryClient}>
      <Router>
        <Routes>
          <Route path="/login" element={!session ? <Login /> : <Navigate to="/" />} />
          
          <Route
            path="/"
            element={
              session ? (
                <Layout>
                  <Dashboard />
                </Layout>
              ) : (
                <Navigate to="/login" />
              )
            }
          />
          
          <Route
            path="/registro"
            element={
              session ? (
                <Layout>
                  <DailyRegistry />
                </Layout>
              ) : (
                <Navigate to="/login" />
              )
            }
          />
          
          <Route
            path="/planificacion"
            element={
              session ? (
                <Layout>
                  <Planning />
                </Layout>
              ) : (
                <Navigate to="/login" />
              )
            }
          />
          
          <Route
            path="/reportes"
            element={
              session ? (
                <Layout>
                  <Reports />
                </Layout>
              ) : (
                <Navigate to="/login" />
              )
            }
          />
        </Routes>
      </Router>
      
      <Toaster position="top-right" richColors />
    </QueryClientProvider>
  )
}

export default App
