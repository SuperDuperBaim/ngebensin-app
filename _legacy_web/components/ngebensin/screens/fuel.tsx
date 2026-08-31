'use client'

import type { Fuel, Station } from '@/lib/ngebensin'
import { FUELS, formatRupiah } from '@/lib/ngebensin'
import { TopBar } from '@/components/ngebensin/top-bar'
import { GreenScreen, Sheet } from '@/components/ngebensin/screen-shell'

export function FuelScreen({
  greeting,
  username,
  station,
  onBack,
  onSelect,
}: {
  greeting: string
  username: string
  station: Station
  onBack: () => void
  onSelect: (f: Fuel) => void
}) {
  const fuels = FUELS[station.id]

  return (
    <GreenScreen>
      <TopBar greeting={greeting} username={username} onBack={onBack} />
      <Sheet
        title="Mau bensin yang mana?"
        subtitle={`Pilihan bahan bakar di ${station.name}.`}
      >
        <ul className="flex flex-col gap-3">
          {fuels.map((f) => (
            <li key={f.id}>
              <button
                type="button"
                onClick={() => onSelect(f)}
                className="flex w-full items-center justify-between rounded-2xl border border-border bg-white/60 px-5 py-4 text-left transition-all hover:border-forest hover:bg-secondary active:scale-[0.99]"
              >
                <span className="flex items-center gap-3">
                  <span className="grid size-11 place-items-center rounded-xl bg-forest text-xs font-extrabold text-forest-foreground">
                    RON
                    <br />
                    {f.octane}
                  </span>
                  <span>
                    <span className="block text-sm font-bold text-card-foreground">
                      {f.name}
                    </span>
                    <span className="block text-xs text-muted-foreground">
                      {formatRupiah(f.price)}/liter
                    </span>
                  </span>
                </span>
              </button>
            </li>
          ))}
        </ul>
      </Sheet>
    </GreenScreen>
  )
}
