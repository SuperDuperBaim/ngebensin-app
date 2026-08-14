'use client'

import type { Station } from '@/lib/ngebensin'
import { STATIONS } from '@/lib/ngebensin'
import { TopBar } from '@/components/ngebensin/top-bar'
import { GreenScreen, Sheet } from '@/components/ngebensin/screen-shell'

export function StationScreen({
  greeting,
  username,
  onBack,
  onSelect,
}: {
  greeting: string
  username: string
  onBack: () => void
  onSelect: (s: Station) => void
}) {
  return (
    <GreenScreen>
      <TopBar greeting={greeting} username={username} onBack={onBack} />
      <Sheet
        title="Isi bensin dimana?"
        subtitle="Pilih SPBU tempat kamu mengisi bahan bakar."
      >
        <div className="grid grid-cols-2 gap-4">
          {STATIONS.map((s) => (
            <button
              key={s.id}
              type="button"
              onClick={() => onSelect(s)}
              className="flex flex-col items-center gap-3 rounded-3xl border border-border bg-white/60 px-4 py-6 transition-all hover:border-forest hover:bg-secondary active:scale-[0.98]"
            >
              <span className="grid size-14 place-items-center rounded-2xl bg-forest text-lg font-extrabold tracking-tight text-forest-foreground">
                {s.mono}
              </span>
              <span className="text-sm font-bold text-card-foreground">
                {s.name}
              </span>
            </button>
          ))}
        </div>
      </Sheet>
    </GreenScreen>
  )
}
