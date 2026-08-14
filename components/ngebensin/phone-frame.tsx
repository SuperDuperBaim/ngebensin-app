import type { ReactNode } from 'react'

export function PhoneFrame({ children }: { children: ReactNode }) {
  return (
    <div className="flex min-h-svh items-center justify-center bg-background p-0 sm:p-6">
      <div className="relative h-svh w-full overflow-hidden bg-cream sm:h-[812px] sm:max-w-[390px] sm:rounded-[2.75rem] sm:border-[10px] sm:border-forest-dark sm:shadow-2xl">
        {/* Notch */}
        <div className="pointer-events-none absolute left-1/2 top-0 z-40 hidden h-6 w-36 -translate-x-1/2 rounded-b-2xl bg-forest-dark sm:block" />
        <div className="relative flex h-full flex-col">{children}</div>
      </div>
    </div>
  )
}
