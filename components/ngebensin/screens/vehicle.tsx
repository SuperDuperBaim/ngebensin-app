'use client'

import { Bike, Car } from 'lucide-react'
import type { VehicleId } from '@/lib/ngebensin'
import { TopBar } from '@/components/ngebensin/top-bar'
import { GreenScreen, Sheet } from '@/components/ngebensin/screen-shell'

export function VehicleScreen({
  greeting,
  username,
  onMenu,
  onSelect,
}: {
  greeting: string
  username: string
  onMenu: () => void
  onSelect: (v: VehicleId) => void
}) {
  const options: { id: VehicleId; label: string; icon: typeof Bike }[] = [
    { id: 'motor', label: 'Motor', icon: Bike },
    { id: 'mobil', label: 'Mobil', icon: Car },
  ]

  return (
    <GreenScreen>
      <TopBar greeting={greeting} username={username} onMenu={onMenu} />
      <Sheet
        title="Kamu pakai kendaraan apa?"
        subtitle="Kami sesuaikan pencatatan dengan kendaraanmu."
      >
        <div className="grid grid-cols-2 gap-4">
          {options.map(({ id, label, icon: Icon }) => (
            <button
              key={id}
              type="button"
              onClick={() => onSelect(id)}
              className="group flex flex-col items-center gap-4 rounded-3xl border border-border bg-white/60 px-4 py-8 transition-all hover:border-forest hover:bg-secondary active:scale-[0.98]"
            >
              <span className="grid size-16 place-items-center rounded-2xl bg-forest text-forest-foreground transition-colors">
                <Icon className="size-8" strokeWidth={2.2} />
              </span>
              <span className="text-sm font-bold text-card-foreground">
                {label}
              </span>
            </button>
          ))}
        </div>
      </Sheet>
    </GreenScreen>
  )
}
