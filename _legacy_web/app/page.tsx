'use client'

import { useMemo, useState } from 'react'
import type {
  Fuel,
  LogEntry,
  Station,
  Unit,
  VehicleId,
} from '@/lib/ngebensin'
import { greeting as getGreeting, SEED_HISTORY } from '@/lib/ngebensin'
import { PhoneFrame } from '@/components/ngebensin/phone-frame'
import { Sidebar } from '@/components/ngebensin/sidebar'
import { SplashScreen } from '@/components/ngebensin/screens/splash'
import { UsernameScreen } from '@/components/ngebensin/screens/username'
import { VehicleScreen } from '@/components/ngebensin/screens/vehicle'
import { HomeScreen } from '@/components/ngebensin/screens/home'
import { StationScreen } from '@/components/ngebensin/screens/station'
import { FuelScreen } from '@/components/ngebensin/screens/fuel'
import { UnitScreen } from '@/components/ngebensin/screens/unit'
import { AmountScreen } from '@/components/ngebensin/screens/amount'
import { SuccessScreen } from '@/components/ngebensin/screens/success'
import { HistoryScreen } from '@/components/ngebensin/screens/history'

type Step =
  | 'splash'
  | 'username'
  | 'vehicle'
  | 'home'
  | 'station'
  | 'fuel'
  | 'unit'
  | 'amount'
  | 'success'
  | 'history'

export default function Page() {
  const [step, setStep] = useState<Step>('splash')
  const [username, setUsername] = useState('')
  const [, setVehicle] = useState<VehicleId | null>(null)
  const [station, setStation] = useState<Station | null>(null)
  const [fuel, setFuel] = useState<Fuel | null>(null)
  const [unit, setUnit] = useState<Unit>('rupiah')
  const [lastEntry, setLastEntry] = useState<LogEntry | null>(null)
  const [history, setHistory] = useState<LogEntry[]>(SEED_HISTORY)
  const [menuOpen, setMenuOpen] = useState(false)

  const greeting = useMemo(() => getGreeting(), [])
  const displayName = username || 'Kawan'

  function navigate(key: string) {
    setMenuOpen(false)
    if (key === 'history') setStep('history')
    else setStep('home')
  }

  function logout() {
    setMenuOpen(false)
    setUsername('')
    setVehicle(null)
    setStep('splash')
  }

  function confirmEntry({ liters, total }: { liters: number; total: number }) {
    if (!station || !fuel) return
    const entry: LogEntry = {
      id: `log-${Date.now()}`,
      fuel: fuel.name,
      station: station.name,
      liters,
      total,
      date: new Date().toISOString(),
    }
    setHistory((prev) => [entry, ...prev])
    setLastEntry(entry)
    setStep('success')
  }

  return (
    <PhoneFrame>
      {step === 'splash' && (
        <SplashScreen onStart={() => setStep('username')} />
      )}

      {step === 'username' && (
        <UsernameScreen
          onSubmit={(name) => {
            setUsername(name)
            setStep('vehicle')
          }}
        />
      )}

      {step === 'vehicle' && (
        <VehicleScreen
          greeting={greeting}
          username={displayName}
          onMenu={() => setMenuOpen(true)}
          onSelect={(v) => {
            setVehicle(v)
            setStep('home')
          }}
        />
      )}

      {step === 'home' && (
        <HomeScreen
          greeting={greeting}
          username={displayName}
          history={history}
          onMenu={() => setMenuOpen(true)}
          onAdd={() => setStep('station')}
          onViewHistory={() => setStep('history')}
        />
      )}

      {step === 'station' && (
        <StationScreen
          greeting={greeting}
          username={displayName}
          onBack={() => setStep('home')}
          onSelect={(s) => {
            setStation(s)
            setStep('fuel')
          }}
        />
      )}

      {step === 'fuel' && station && (
        <FuelScreen
          greeting={greeting}
          username={displayName}
          station={station}
          onBack={() => setStep('station')}
          onSelect={(f) => {
            setFuel(f)
            setStep('unit')
          }}
        />
      )}

      {step === 'unit' && station && fuel && (
        <UnitScreen
          greeting={greeting}
          username={displayName}
          station={station}
          fuel={fuel}
          onBack={() => setStep('fuel')}
          onSelect={(u) => {
            setUnit(u)
            setStep('amount')
          }}
        />
      )}

      {step === 'amount' && station && fuel && (
        <AmountScreen
          greeting={greeting}
          username={displayName}
          station={station}
          fuel={fuel}
          unit={unit}
          onBack={() => setStep('unit')}
          onConfirm={confirmEntry}
        />
      )}

      {step === 'success' && lastEntry && (
        <SuccessScreen
          entry={lastEntry}
          onViewHistory={() => setStep('history')}
          onDone={() => setStep('home')}
        />
      )}

      {step === 'history' && (
        <HistoryScreen
          greeting={greeting}
          username={displayName}
          history={history}
          onBack={() => setStep('home')}
        />
      )}

      <Sidebar
        open={menuOpen}
        active={step === 'history' ? 'history' : 'home'}
        username={displayName}
        onClose={() => setMenuOpen(false)}
        onNavigate={navigate}
        onLogout={logout}
      />
    </PhoneFrame>
  )
}
