'use client'

import { useState } from 'react'
import { ArrowRight } from 'lucide-react'

export function UsernameScreen({
  onSubmit,
}: {
  onSubmit: (name: string) => void
}) {
  const [value, setValue] = useState('')
  const valid = value.trim().length >= 2

  function submit() {
    if (valid) onSubmit(value.trim())
  }

  return (
    <div className="flex h-full flex-col bg-gradient-to-b from-forest-dark via-forest to-forest/75 px-8 pb-12 pt-24 text-forest-foreground">
      <div className="flex flex-1 flex-col justify-center">
        <h1 className="text-3xl font-extrabold tracking-tight">Halo!</h1>
        <p className="mt-2 text-sm leading-relaxed text-forest-foreground/75">
          Siapa nama panggilanmu? Biar sapaannya lebih akrab.
        </p>

        <label
          htmlFor="username"
          className="mt-10 block text-[11px] font-semibold uppercase tracking-wider text-forest-foreground/60"
        >
          Username
        </label>
        <input
          id="username"
          value={value}
          onChange={(e) => setValue(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === 'Enter' && !e.nativeEvent.isComposing) submit()
          }}
          placeholder="cth. Bagas"
          autoComplete="off"
          className="mt-2 w-full rounded-2xl border border-white/15 bg-white/10 px-5 py-4 text-base font-medium text-forest-foreground placeholder:text-forest-foreground/45 outline-none transition-colors focus:border-white/40 focus:bg-white/15"
        />
      </div>

      <button
        type="button"
        onClick={submit}
        disabled={!valid}
        className="flex w-full items-center justify-center gap-2 rounded-2xl bg-forest-foreground py-4 text-base font-bold text-forest-dark transition-all active:scale-[0.98] disabled:cursor-not-allowed disabled:opacity-40"
      >
        Lanjut
        <ArrowRight className="size-5" strokeWidth={2.6} />
      </button>
    </div>
  )
}
