'use client'

import { ChevronRight, Plus } from 'lucide-react'
import type { LogEntry } from '@/lib/ngebensin'
import { formatDate, formatRupiah } from '@/lib/ngebensin'
import { TopBar } from '@/components/ngebensin/top-bar'
import { GreenScreen, Sheet } from '@/components/ngebensin/screen-shell'

export function HomeScreen({
  greeting,
  username,
  history,
  onMenu,
  onAdd,
  onViewHistory,
}: {
  greeting: string
  username: string
  history: LogEntry[]
  onMenu: () => void
  onAdd: () => void
  onViewHistory: () => void
}) {
  const total = history.reduce((s, e) => s + e.total, 0)
  const liters = history.reduce((s, e) => s + e.liters, 0)
  const recent = history.slice(0, 3)

  return (
    <GreenScreen>
      <TopBar greeting={greeting} username={username} onMenu={onMenu} />
      <Sheet>
        {/* Summary */}
        <div className="grid grid-cols-2 gap-3">
          <div className="rounded-2xl bg-forest px-4 py-4 text-forest-foreground">
            <p className="text-[11px] uppercase tracking-wider text-forest-foreground/70">
              Total pengeluaran
            </p>
            <p className="mt-1 text-lg font-extrabold leading-tight">
              {formatRupiah(total)}
            </p>
          </div>
          <div className="rounded-2xl border border-border bg-white/60 px-4 py-4">
            <p className="text-[11px] uppercase tracking-wider text-muted-foreground">
              Total liter
            </p>
            <p className="mt-1 text-lg font-extrabold leading-tight text-card-foreground">
              {liters.toFixed(1)} L
            </p>
          </div>
        </div>

        {/* Add CTA */}
        <button
          type="button"
          onClick={onAdd}
          className="mt-5 flex w-full items-center gap-4 rounded-3xl bg-forest px-5 py-5 text-left text-forest-foreground transition-transform active:scale-[0.99]"
        >
          <span className="grid size-12 shrink-0 place-items-center rounded-2xl bg-forest-foreground text-forest-dark">
            <Plus className="size-7" strokeWidth={2.8} />
          </span>
          <span>
            <span className="block text-base font-bold">Catat isi bensin</span>
            <span className="block text-xs text-forest-foreground/70">
              Tambah catatan baru sekarang
            </span>
          </span>
        </button>

        {/* Recent */}
        <div className="mt-7 flex items-center justify-between">
          <h2 className="text-sm font-bold text-card-foreground">
            Riwayat terakhir
          </h2>
          <button
            type="button"
            onClick={onViewHistory}
            className="flex items-center gap-0.5 text-xs font-semibold text-forest"
          >
            Lihat semua
            <ChevronRight className="size-4" />
          </button>
        </div>

        <ul className="mt-3 flex flex-col gap-2.5">
          {recent.length === 0 ? (
            <li className="rounded-2xl border border-dashed border-border px-4 py-8 text-center text-sm text-muted-foreground">
              Belum ada catatan. Yuk mulai catat!
            </li>
          ) : (
            recent.map((e) => (
              <li
                key={e.id}
                className="flex items-center justify-between rounded-2xl border border-border bg-white/60 px-4 py-3"
              >
                <div className="min-w-0">
                  <p className="truncate text-sm font-bold text-card-foreground">
                    {e.fuel}
                  </p>
                  <p className="truncate text-xs text-muted-foreground">
                    {e.station} · {formatDate(e.date)}
                  </p>
                </div>
                <p className="shrink-0 text-sm font-bold text-forest">
                  {formatRupiah(e.total)}
                </p>
              </li>
            ))
          )}
        </ul>
      </Sheet>
    </GreenScreen>
  )
}
