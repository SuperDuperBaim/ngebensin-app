'use client'

import { Clock, Fuel, HelpCircle, LogOut, Settings, X } from 'lucide-react'

type Item = {
  key: string
  label: string
  icon: typeof Fuel
}

const ITEMS: Item[] = [
  { key: 'home', label: 'Ngebensin', icon: Fuel },
  { key: 'history', label: 'Riwayat', icon: Clock },
  { key: 'settings', label: 'Pengaturan', icon: Settings },
  { key: 'help', label: 'Bantuan', icon: HelpCircle },
]

export function Sidebar({
  open,
  active,
  username,
  onClose,
  onNavigate,
  onLogout,
}: {
  open: boolean
  active: string
  username: string
  onClose: () => void
  onNavigate: (key: string) => void
  onLogout: () => void
}) {
  return (
    <div
      className={`absolute inset-0 z-50 ${open ? '' : 'pointer-events-none'}`}
      aria-hidden={!open}
    >
      {/* Scrim */}
      <div
        onClick={onClose}
        className={`absolute inset-0 bg-forest-dark/40 backdrop-blur-[2px] transition-opacity duration-300 ${
          open ? 'opacity-100' : 'opacity-0'
        }`}
      />
      {/* Panel */}
      <aside
        className={`absolute inset-y-0 left-0 flex w-[76%] max-w-[280px] flex-col bg-forest-dark px-5 pb-8 pt-8 text-forest-foreground transition-transform duration-300 ease-out ${
          open ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <span className="grid size-9 place-items-center rounded-xl bg-forest-foreground/15">
              <Fuel className="size-5" strokeWidth={2.5} />
            </span>
            <span className="text-lg font-extrabold tracking-tight">
              Ngebensin
            </span>
          </div>
          <button
            type="button"
            onClick={onClose}
            aria-label="Tutup menu"
            className="grid size-8 place-items-center rounded-full text-forest-foreground/80 transition-colors hover:bg-white/10"
          >
            <X className="size-5" />
          </button>
        </div>

        <div className="mt-8 rounded-2xl bg-white/10 px-4 py-3">
          <p className="text-[11px] uppercase tracking-wider text-forest-foreground/60">
            Masuk sebagai
          </p>
          <p className="truncate text-sm font-semibold">{username}</p>
        </div>

        <nav className="mt-6 flex flex-col gap-1">
          {ITEMS.map((item) => {
            const Icon = item.icon
            const isActive = active === item.key
            return (
              <button
                key={item.key}
                type="button"
                onClick={() => onNavigate(item.key)}
                className={`flex items-center gap-3 rounded-xl px-4 py-3 text-left text-sm font-semibold transition-colors ${
                  isActive
                    ? 'bg-forest-foreground text-forest-dark'
                    : 'text-forest-foreground/85 hover:bg-white/10'
                }`}
              >
                <Icon className="size-5" strokeWidth={2.4} />
                {item.label}
              </button>
            )
          })}
        </nav>

        <button
          type="button"
          onClick={onLogout}
          className="mt-auto flex items-center gap-3 rounded-xl px-4 py-3 text-left text-sm font-semibold text-forest-foreground/70 transition-colors hover:bg-white/10"
        >
          <LogOut className="size-5" strokeWidth={2.4} />
          Keluar
        </button>
      </aside>
    </div>
  )
}
