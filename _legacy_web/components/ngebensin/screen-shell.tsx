import type { ReactNode } from 'react'

export function GreenScreen({ children }: { children: ReactNode }) {
  return (
    <div className="flex h-full flex-col bg-gradient-to-b from-forest-dark via-forest to-forest/80">
      {children}
    </div>
  )
}

export function Sheet({
  title,
  subtitle,
  children,
  footer,
}: {
  title?: string
  subtitle?: string
  children: ReactNode
  footer?: ReactNode
}) {
  return (
    <div className="flex flex-1 flex-col overflow-hidden rounded-t-[2rem] bg-cream">
      <div className="flex flex-1 flex-col overflow-y-auto px-6 pb-6 pt-7">
        {title ? (
          <div className="mb-6">
            <h1 className="text-balance text-xl font-extrabold tracking-tight text-card-foreground">
              {title}
            </h1>
            {subtitle ? (
              <p className="mt-1 text-sm leading-relaxed text-muted-foreground">
                {subtitle}
              </p>
            ) : null}
          </div>
        ) : null}
        {children}
      </div>
      {footer ? (
        <div className="border-t border-border/70 bg-cream px-6 pb-8 pt-4">
          {footer}
        </div>
      ) : null}
    </div>
  )
}
