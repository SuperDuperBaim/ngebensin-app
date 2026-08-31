'use client'

import { Fuel } from 'lucide-react'

export function SplashScreen({ onStart }: { onStart: () => void }) {
  return (
    <div className="flex h-full flex-col justify-between bg-gradient-to-b from-forest-dark via-forest to-forest/70 px-8 pb-12 pt-24 text-forest-foreground">
      <div className="flex flex-1 flex-col items-center justify-center text-center">
        <span className="mb-8 grid size-16 place-items-center rounded-3xl bg-forest-foreground/12 ring-1 ring-inset ring-white/15">
          <Fuel className="size-8" strokeWidth={2.4} />
        </span>
        <h1 className="text-4xl font-extrabold tracking-tight">Ngebensin</h1>
        <p className="mt-3 max-w-[16rem] text-pretty text-sm leading-relaxed text-forest-foreground/75">
          Catat setiap kali kamu isi bensin. Rapi, ringan, dan enak dilihat.
        </p>
      </div>

      <button
        type="button"
        onClick={onStart}
        className="w-full rounded-2xl bg-forest-foreground py-4 text-base font-bold text-forest-dark transition-transform active:scale-[0.98]"
      >
        Mulai
      </button>
    </div>
  )
}
