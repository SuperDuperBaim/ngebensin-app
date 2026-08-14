export type StationId = 'pertamina' | 'shell' | 'vivo' | 'bp'

export type Station = {
  id: StationId
  name: string
  mono: string
}

export type Fuel = {
  id: string
  name: string
  octane: number
  price: number // per liter, IDR
}

export type VehicleId = 'motor' | 'mobil'

export type Unit = 'rupiah' | 'liter'

export type LogEntry = {
  id: string
  fuel: string
  station: string
  liters: number
  total: number
  date: string
}

export const STATIONS: Station[] = [
  { id: 'pertamina', name: 'Pertamina', mono: 'PT' },
  { id: 'shell', name: 'Shell', mono: 'SH' },
  { id: 'vivo', name: 'Vivo', mono: 'VV' },
  { id: 'bp', name: 'BP', mono: 'BP' },
]

export const FUELS: Record<StationId, Fuel[]> = {
  pertamina: [
    { id: 'pertalite', name: 'Pertalite', octane: 90, price: 10000 },
    { id: 'pertamax', name: 'Pertamax', octane: 92, price: 12500 },
    { id: 'pertamax-green', name: 'Pertamax Green', octane: 95, price: 13700 },
    { id: 'pertamax-turbo', name: 'Pertamax Turbo', octane: 98, price: 14000 },
  ],
  shell: [
    { id: 'shell-super', name: 'Shell Super', octane: 92, price: 12590 },
    { id: 'shell-vpower', name: 'Shell V-Power', octane: 95, price: 13290 },
    { id: 'shell-nitro', name: 'Shell V-Power Nitro+', octane: 98, price: 13890 },
  ],
  vivo: [
    { id: 'revvo-90', name: 'Revvo 90', octane: 90, price: 12000 },
    { id: 'revvo-92', name: 'Revvo 92', octane: 92, price: 12600 },
    { id: 'revvo-95', name: 'Revvo 95', octane: 95, price: 13500 },
  ],
  bp: [
    { id: 'bp-92', name: 'BP 92', octane: 92, price: 12600 },
    { id: 'bp-ultimate', name: 'BP Ultimate', octane: 95, price: 13500 },
  ],
}

export function formatRupiah(value: number): string {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    maximumFractionDigits: 0,
  }).format(Math.round(value))
}

export function formatNumber(value: number): string {
  return new Intl.NumberFormat('id-ID', {
    maximumFractionDigits: 2,
  }).format(value)
}

export function formatDate(iso: string): string {
  return new Intl.DateTimeFormat('id-ID', {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  }).format(new Date(iso))
}

export function greeting(date = new Date()): string {
  const h = date.getHours()
  if (h < 11) return 'Selamat Pagi'
  if (h < 15) return 'Selamat Siang'
  if (h < 19) return 'Selamat Sore'
  return 'Selamat Malam'
}

export const SEED_HISTORY: LogEntry[] = [
  {
    id: 'seed-1',
    fuel: 'Pertamax',
    station: 'Pertamina',
    liters: 12.76,
    total: 159500,
    date: '2026-08-12',
  },
  {
    id: 'seed-2',
    fuel: 'Shell V-Power',
    station: 'Shell',
    liters: 8.27,
    total: 110000,
    date: '2026-08-05',
  },
]
