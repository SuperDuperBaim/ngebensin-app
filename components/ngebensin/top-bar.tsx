'use client'

import { ArrowLeft, Menu } from 'lucide-react'

export function TopBar({
  greeting,
  username,
  onMenu,
  onBack,
}: {
  greeting: string
  username: string
  onMenu?: () => void
  onBack?: () => void
}) {
  return (
    <header className="flex items-center gap-3 px-6 pb-4 pt-8">
      {onBack ? (
        <button
          type="button"
          onClick={onBack}
          aria-label="Kembali"
          className="grid size-9 place-items-center rounded-full text-forest-foreground/90 transition-colors hover:bg-white/10"
        >
          <ArrowLeft className="size-5" strokeWidth={2.5} />
        </button>
      ) : (
        <button
          type="button"
          onClick={onMenu}
          aria-label="Buka menu"
          className="grid size-9 place-items-center rounded-full text-forest-foreground/90 transition-colors hover:bg-white/10"
        >
          <Menu className="size-5" strokeWidth={2.5} />
        </button>
      )}
      <div className="min-w-0">
        <p className="truncate text-sm font-semibold leading-tight text-forest-foreground">
          {greeting}
        </p>
        <p className="truncate text-xs leading-tight text-forest-foreground/70">
          {username}
        </p>
      </div>
    </header>
  )
}
