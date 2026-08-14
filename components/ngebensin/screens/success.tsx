'use client'

import { Check } from 'lucide-react'
import type { LogEntry } from '@/lib/ngebensin'
import { formatNumber, formatRupiah } from '@/lib/ngebensin'

export function SuccessScreen({
  entry,
  onViewHistory,
  onDone,
}: {
  entry: LogEntry
  onViewHistory: () => void
  onDone: () => void
}) {
  return (
    <div className="flex h-full flex-col items-center justify-center bg-gradient-to-b from-forest-dark via-forest to-forest/75 px-8 pb-12 pt-10">
      <div className="w-full animate-in fade-in-0 zoom-in-95 duration-300">
        <div className="mx-auto flex flex-col items-center rounded-3xl bg-cream px-6 pb-6 pt-8 text-center shadow-xl">
          <span className="grid size-16 place-items-center rounded-full bg-forest text-forest-foreground">
            <Check className="size-9" strokeWidth={3} />
          </span>
          <h1 className="mt-5 text-xl font-extrabold tracking-tight text-card-foreground">
            Berhasil dicatat!
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Catatanmu sudah masuk ke Riwayat.
          </p>

          <div className="mt-6 w-full rounded-2xl bg-secondary px-5 py-4 text-left">
            <div className="flex items-center justify-between">
              <span className="text-sm font-bold text-card-foreground">
                {entry.fuel}
              </span>
              <span className="text-sm font-extrabold text-forest">
                {formatRupiah(entry.total)}
              </span>
            </div>
            <div className="mt-1 flex items-center justify-between text-xs text-muted-foreground">
              <span>{entry.station}</span>
              <span>{formatNumber(entry.liters)} L</span>
            </div>
          </div>

          <div className="mt-6 grid w-full grid-cols-2 gap-3">
            <button
              type="button"
              onClick={onDone}
              className="rounded-2xl border border-border py-3 text-sm font-bold text-card-foreground transition-colors hover:bg-secondary"
            >
              Selesai
            </button>
            <button
              type="button"
              onClick={onViewHistory}
              className="rounded-2xl bg-forest py-3 text-sm font-bold text-forest-foreground transition-transform active:scale-[0.98]"
            >
              Lihat Riwayat
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
