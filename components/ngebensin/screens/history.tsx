'use client'

import { Fuel } from 'lucide-react'
import type { LogEntry } from '@/lib/ngebensin'
import { formatDate, formatNumber, formatRupiah } from '@/lib/ngebensin'
import { TopBar } from '@/components/ngebensin/top-bar'
import { GreenScreen, Sheet } from '@/components/ngebensin/screen-shell'

export function HistoryScreen({
  greeting,
  username,
  history,
  onBack,
}: {
  greeting: string
  username: string
  history: LogEntry[]
  onBack: () => void
}) {
  const total = history.reduce((s, e) => s + e.total, 0)

  return (
    <GreenScreen>
      <TopBar greeting={greeting} username={username} onBack={onBack} />
      <Sheet
        title="Riwayat"
        subtitle={`${history.length} catatan · total ${formatRupiah(total)}`}
      >
        {history.length === 0 ? (
          <div className="flex flex-1 flex-col items-center justify-center rounded-2xl border border-dashed border-border py-16 text-center">
            <span className="grid size-12 place-items-center rounded-2xl bg-secondary text-forest">
              <Fuel className="size-6" strokeWidth={2.3} />
            </span>
            <p className="mt-4 text-sm font-semibold text-card-foreground">
              Belum ada catatan
            </p>
            <p className="mt-1 text-xs text-muted-foreground">
              Catatan isi bensinmu akan muncul di sini.
            </p>
          </div>
        ) : (
          <ul className="flex flex-col gap-3">
            {history.map((e) => (
              <li
                key={e.id}
                className="rounded-2xl border border-border bg-white/60 px-4 py-3.5"
              >
                <div className="flex items-center justify-between">
                  <p className="text-sm font-bold text-card-foreground">
                    {e.fuel}
                  </p>
                  <p className="text-sm font-extrabold text-forest">
                    {formatRupiah(e.total)}
                  </p>
                </div>
                <div className="mt-1 flex items-center justify-between text-xs text-muted-foreground">
                  <span>
                    {e.station} · {formatNumber(e.liters)} L
                  </span>
                  <span>{formatDate(e.date)}</span>
                </div>
              </li>
            ))}
          </ul>
        )}
      </Sheet>
    </GreenScreen>
  )
}
