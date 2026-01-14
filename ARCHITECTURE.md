# 🏗️ Arquitectura Técnica - SICOF Núcleo

## Visión General

SICOF Núcleo es una aplicación web moderna construida con arquitectura de microservicios utilizando Supabase como Backend-as-a-Service (BaaS).

## Stack Tecnológico

### Frontend
```
React 18.2
├── TypeScript 5.3      # Type safety
├── Vite 5.0           # Build tool & dev server
├── React Router 6.21   # Client-side routing
├── TanStack Query 5.17 # Server state management
├── Zustand 4.5        # Client state management
├── React Hook Form 7.49 # Form handling
├── Zod 3.22           # Schema validation
├── Tailwind CSS 3.4   # Styling
└── Recharts 2.10      # Data visualization
```

### Backend (Supabase)
```
PostgreSQL 15
├── Row Level Security (RLS)
├── Realtime subscriptions
├── Auth & JWT tokens
├── Storage (future)
└── Edge Functions (future)
```

### Deployment
```
Vercel (Frontend)
└── Edge Network
    ├── Global CDN
    ├── Automatic SSL
    └── GitHub integration

Supabase (Backend)
└── Cloud Infrastructure
    ├── AWS (default)
    ├── Automated backups
    └── Point-in-time recovery
```

## Arquitectura de Capas

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER              │
│  (React Components + Tailwind CSS)     │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│         APPLICATION LAYER               │
│  (React Query + Custom Hooks)          │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│         DATA ACCESS LAYER               │
│  (Supabase Client + Services)          │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│         DATABASE LAYER                  │
│  (PostgreSQL + RLS + Functions)        │
└─────────────────────────────────────────┘
```

## Estructura de Directorios

```
sicof-nucleo/
│
├── src/
│   ├── components/          # React components
│   │   ├── ui/             # Reusable UI components
│   │   ├── forms/          # Form components
│   │   ├── dashboard/      # Dashboard widgets
│   │   └── reports/        # Report components
│   │
│   ├── pages/              # Page components (routes)
│   │   ├── Dashboard.tsx
│   │   ├── DailyRegistry.tsx
│   │   ├── Planning.tsx
│   │   └── Reports.tsx
│   │
│   ├── hooks/              # Custom React hooks
│   │   ├── useAuth.ts
│   │   ├── useRegistry.ts
│   │   └── useAlerts.ts
│   │
│   ├── lib/                # Core utilities
│   │   ├── supabase.ts     # Supabase client config
│   │   ├── database.types.ts # Generated types
│   │   └── utils.ts        # Helper functions
│   │
│   ├── services/           # Business logic layer
│   │   ├── registries.ts   # Registry operations
│   │   ├── planning.ts     # Planning operations
│   │   ├── alerts.ts       # Alert engine
│   │   └── recommendations.ts # Recommendation engine
│   │
│   ├── types/              # TypeScript definitions
│   │   ├── registry.ts
│   │   ├── user.ts
│   │   └── common.ts
│   │
│   ├── App.tsx             # Root component
│   ├── main.tsx            # Entry point
│   └── index.css           # Global styles
│
├── supabase/
│   ├── schema.sql          # Complete DB schema
│   ├── seed.sql            # Seed data
│   └── migrations/         # DB migrations
│
├── public/                 # Static assets
├── package.json
├── vite.config.ts
├── tailwind.config.js
└── tsconfig.json
```

## Flujo de Datos

### 1. Registro Diario (Create)

```
Usuario → Formulario → Validación (Zod) → React Hook Form
                                                ↓
                                         React Query mutation
                                                ↓
                                         Supabase Client
                                                ↓
                                    PostgreSQL + RLS check
                                                ↓
                                      Trigger automático
                                      (audit_log, alertas)
                                                ↓
                                         Response → UI
```

### 2. Dashboard (Read)

```
Componente → useQuery hook → Supabase Client
                                    ↓
                            PostgreSQL query
                            (+ RLS filtering)
                                    ↓
                          Materialized views
                          (pre-calculated stats)
                                    ↓
                            Cache (React Query)
                                    ↓
                            Render components
```

### 3. Motor de Alertas (Automated)

```
INSERT/UPDATE registro → Database trigger
                                ↓
                         Check business rules
                                ↓
                         Generate alert (if needed)
                                ↓
                         Store in alertas table
                                ↓
                    Realtime subscription → Frontend
                                ↓
                         Update UI immediately
```

## Seguridad

### Row Level Security (RLS)

Cada tabla tiene políticas RLS que garantizan:

```sql
-- Digitador: solo ve sus registros
CREATE POLICY digitador_select_registros
  ON registros_diarios FOR SELECT
  USING (auth.uid() = usuario_id AND role = 'digitador');

-- Admin Operaciones: ve todo
CREATE POLICY admin_select_all
  ON registros_diarios FOR SELECT
  USING (role = 'admin_operaciones');

-- Comisario: solo lectura
CREATE POLICY comisario_select_all
  ON registros_diarios FOR SELECT
  USING (role = 'comisario');
```

### Autenticación

```
JWT Token (Supabase Auth)
├── Stored in httpOnly cookie
├── Auto-refresh on expiry
├── Role-based claims
└── Session management
```

### Validación en Capas

```
1. Frontend (Zod schemas)
   ↓
2. Supabase RLS policies
   ↓
3. Database constraints
   ↓
4. Triggers & functions
```

## Performance

### Optimizaciones Implementadas

1. **Vistas Materializadas**
   ```sql
   -- Pre-calculadas para queries complejas
   mv_cumplimiento_anual
   mv_detenciones_tramo
   
   -- Refresh automático (cron job)
   SELECT cron.schedule('refresh-mv', '0 2 * * *', 
     'SELECT refresh_materialized_views()');
   ```

2. **Índices Estratégicos**
   ```sql
   CREATE INDEX idx_registros_fecha ON registros_diarios(fecha);
   CREATE INDEX idx_detenciones_tramo ON detenciones(tramo_horario);
   CREATE INDEX idx_alertas_estado ON alertas(estado);
   ```

3. **React Query Caching**
   ```typescript
   {
     staleTime: 1000 * 60 * 5, // 5 min cache
     cacheTime: 1000 * 60 * 30, // 30 min in memory
   }
   ```

4. **Code Splitting**
   ```typescript
   // Lazy loading de páginas
   const Dashboard = lazy(() => import('./pages/Dashboard'));
   ```

## Escalabilidad

### Horizontal Scaling

```
Frontend (Vercel)
└── Edge Functions
    ├── Auto-scaling
    └── Global CDN

Backend (Supabase)
└── Database
    ├── Connection pooling (PgBouncer)
    ├── Read replicas (Pro plan)
    └── Point-in-time recovery
```

### Límites Actuales (Plan Free)

| Recurso | Límite | Escalamiento |
|---------|--------|--------------|
| Storage | 500 MB | Pro: 8 GB |
| Bandwidth | 2 GB/month | Pro: 50 GB |
| MAU | 50,000 | Pro: 100,000 |
| Database | 500 MB | Pro: 8 GB |
| API requests | Sin límite | Sin límite |

### Cuando Escalar

Considerar upgrade a Pro cuando:
- Database > 400 MB
- Bandwidth > 1.5 GB/month
- Necesidad de read replicas
- Requerimiento de backups point-in-time

## Monitoreo

### Métricas Clave

```
Application Level
├── Response time (p50, p95, p99)
├── Error rate
├── Cache hit ratio (React Query)
└── Bundle size

Database Level
├── Query performance
├── Connection pool usage
├── Disk usage
└── Replication lag (Pro)

Business Level
├── Registros diarios completados
├── Alertas activas
├── Cumplimiento planificación
└── Usuarios activos
```

### Herramientas

```
Supabase Dashboard
├── Real-time metrics
├── Query performance
└── Error logs

Vercel Analytics
├── Web vitals
├── Audience insights
└── Performance score
```

## Disaster Recovery

### Backup Strategy

```
Automated (Supabase)
├── Daily snapshots (7 days retention)
├── Point-in-time recovery (Pro)
└── Geographic redundancy (Pro)

Manual
├── SQL exports (weekly)
├── GitHub code backups (every commit)
└── Documentation backups
```

### Recovery Procedure

```
1. Assess damage
2. Restore from latest Supabase snapshot
3. Verify data integrity
4. Redeploy frontend (if needed)
5. Test critical flows
6. Notify users
```

## CI/CD Pipeline

```
GitHub Push
    ↓
GitHub Actions
    ↓
Run Tests
    ↓
Build (Vite)
    ↓
Deploy to Vercel
    ↓
Health Check
    ↓
✅ Live
```

## Future Enhancements

### Phase 2
- [ ] Real-time collaboration
- [ ] Mobile app (React Native)
- [ ] Advanced analytics (ML)
- [ ] PDF report generation
- [ ] Email notifications

### Phase 3
- [ ] Integration with external systems
- [ ] Public API
- [ ] Multi-tenancy
- [ ] Advanced permissions (ABAC)
- [ ] Audit trail viewer

## Referencias Técnicas

- [Supabase Documentation](https://supabase.com/docs)
- [React Query Documentation](https://tanstack.com/query/latest)
- [Vite Documentation](https://vitejs.dev/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Última actualización**: Enero 2026
**Versión de arquitectura**: 1.0.0
