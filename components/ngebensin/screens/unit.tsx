'use client'

import { Droplet, Wallet } from 'lucide-react'
import type { Fuel, Station, Unit } from '@/lib/ngebensin'
import { TopBar } from '@/components/ngebensin/top-bar'
import { GreenScreen, Sheet } from '@/components/ngebensin/screen-shell'

export function UnitScreen({
  greeting,
  username,
  station,
  fuel,
  onBack,
  onSelect,
}: {
  greeting: string
  username: string
  station: Station
  fuel: Fuel
  onBack: () => void
  onSelect: (u: Unit) => void
}) {
  const options: {
    id: Unit
    label: string
    hint: string
    icon: typeof Wallet
  }[] = [
    {
      id: 'rupiah',
      label: 'Isi pakai Rupiah',
      hint: 'Masukkan nominal rupiah',
      icon: Wallet,
    },
    {
      id: 'liter',
      label: 'Isi pakai Liter',
      hint: 'Masukkan jumlah liter',
      icon: Droplet,
    },
  ]

  return (
    <GreenScreen>
      <TopBar greeting={greeting} username={username} onBack={onBack} />
      <Sheet
        title="Ukur pakai apa?"
        subtitle={`${fuel.name} di ${station.name}.`}
      >
        <div className="flex flex-col gap-4">
          {options.map(({ id, label, hint, icon: Icon }) => (
            <button
              key={id}
              type="button"
              onClick={() => onSelect(id)}
              className="flex items-center gap-4 rounded-3xl border border-border bg-white/60 px-5 py-5 text-left transition-all hover:border-forest hover:bg-secondary active:scale-[0.99]"
            >
              <span className="grid size-12 shrink-0 place-items-center rounded-2xl bg-forest text-forest-foreground">
                <Icon className="size-6" strokeWidth={2.3} />
              </span>
              <span>
                <span className="block text-base font-bold text-card-foreground">
                  {label}
                </span>
                <span className="block text-xs text-muted-foreground">
                  {hint}
                </span>
              </span>
            </button>
          ))}
        </div>
      </Sheet>
    </GreenScreen>
  )
}
