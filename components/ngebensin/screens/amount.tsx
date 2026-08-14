'use client'

import { useMemo, useState } from 'react'
import type { Fuel, Station, Unit } from '@/lib/ngebensin'
import { formatNumber, formatRupiah } from '@/lib/ngebensin'
import { TopBar } from '@/components/ngebensin/top-bar'
import { GreenScreen, Sheet } from '@/components/ngebensin/screen-shell'

export function AmountScreen({
  greeting,
  username,
  station,
  fuel,
  unit,
  onBack,
  onConfirm,
}: {
  greeting: string
  username: string
  station: Station
  fuel: Fuel
  unit: Unit
  onBack: () => void
  onConfirm: (data: { liters: number; total: number }) => void
}) {
  const [raw, setRaw] = useState('')
  const isRupiah = unit === 'rupiah'

  const amount = useMemo(() => {
    const n = Number(raw.replace(/[^\d.]/g, ''))
    return Number.isFinite(n) ? n : 0
  }, [raw])

  const { liters, total } = useMemo(() => {
    if (amount <= 0) return { liters: 0, total: 0 }
    if (isRupiah) return { total: amount, liters: amount / fuel.price }
    return { liters: amount, total: amount * fuel.price }
  }, [amount, isRupiah, fuel.price])

  const valid = amount > 0

  const quickChips = isRupiah
    ? [20000, 50000, 100000, 150000]
    : [1, 5, 10, 20]

  return (
    <GreenScreen>
      <TopBar greeting={greeting} username={username} onBack={onBack} />
      <Sheet
        title={isRupiah ? 'Berapa rupiah?' : 'Berapa liter?'}
        subtitle={`${fuel.name} · ${formatRupiah(fuel.price)}/liter`}
        footer={
          <button
            type="button"
            onClick={() => valid && onConfirm({ liters, total })}
            disabled={!valid}
            className="w-full rounded-2xl bg-forest py-4 text-base font-bold text-forest-foreground transition-all active:scale-[0.98] disabled:cursor-not-allowed disabled:opacity-40"
          >
            Simpan catatan
          </button>
        }
      >
        {/* Input */}
        <div className="flex items-center gap-3 rounded-2xl border border-border bg-white/70 px-5 py-4 focus-within:border-forest">
          {isRupiah ? (
            <span className="text-lg font-bold text-muted-foreground">Rp</span>
          ) : null}
          <input
            inputMode="decimal"
            value={raw}
            onChange={(e) => setRaw(e.target.value)}
            placeholder="0"
            autoFocus
            className="w-full bg-transparent text-2xl font-extrabold tracking-tight text-card-foreground outline-none placeholder:text-muted-foreground/50"
          />
          {!isRupiah ? (
            <span className="text-lg font-bold text-muted-foreground">L</span>
          ) : null}
        </div>

        {/* Quick chips */}
        <div className="mt-4 flex flex-wrap gap-2">
          {quickChips.map((c) => (
            <button
              key={c}
              type="button"
              onClick={() => setRaw(String(c))}
              className="rounded-full border border-border bg-white/60 px-4 py-1.5 text-xs font-semibold text-card-foreground transition-colors hover:border-forest hover:bg-secondary"
            >
              {isRupiah ? formatRupiah(c) : `${c} L`}
            </button>
          ))}
        </div>

        {/* Conversion preview */}
        <div className="mt-6 rounded-2xl bg-secondary px-5 py-4">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted-foreground">
              {isRupiah ? 'Perkiraan liter' : 'Perkiraan total'}
            </span>
            <span className="text-lg font-extrabold text-forest">
              {isRupiah
                ? `${formatNumber(liters)} L`
                : formatRupiah(total)}
            </span>
          </div>
        </div>
      </Sheet>
    </GreenScreen>
  )
}
