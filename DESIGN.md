# Design System: مدیریت خودرو (Car Care)

**Stitch project:** `1400264005215370753` ("مدیریت خودرو Vehicle Ledger")
**Stitch design system:** `assets/0c4184bddd454649a726920b972d2a0b`, "مدیریت خودرو (Car Care)"
**Implemented in:** `lib/core/theme/` (`AppTheme.light`, `AppColors`, `AppTextStyles`, `AppTones`, `VehiclePalette`, `ChartPalette`)

This file mirrors the theme the app actually ships. Stitch is the source of truth for screens; when
Stitch and the theme disagree, the theme follows the Stitch design-system *prose* (brand rules), and the
gap is listed under [Known gaps](#known-gaps-stitch-vs-theme). Widgets never hardcode colors: they read
`Theme.of(context).colorScheme`, `AppTones.of(context)` or `VehiclePalette.of(context)`.

## 1. Visual theme and atmosphere

An authoritative, utilitarian **ledger for everything a car costs its owner** (services, fuel,
insurance, fines, tolls, inspection, documents) for Persian-speaking drivers. Scandinavian clarity
meets automotive instrumentation: crisp hairline borders, structured white cards on a pale slate
canvas, one dark navy action per screen, and amber reserved for caution and the dock's add glyph.
Calm, dense-but-glanceable, high contrast in daylight. **Light mode only.**

Car-context rules: glanceable, minimal text, short flows, touch targets at least 48dp (prefer 64dp).

## 2. Color palette and roles

### Brand

| Token (`AppColors`) | Hex | Scheme slot | Role |
|---|---|---|---|
| `navy` (Primary Slate Navy) | `#0F172A` | `primary`, `shadow` | Primary CTA fill, titles, active nav slot, dock add button, shadow tint |
| `slate` (Secondary Slate) | `#1E293B` | `secondary` | Subheadings, outlined-button label, pressed states |
| `amber` (Accent Amber) | `#F59E0B` | `tertiary` | Caution, due-soon status, the dock add glyph (`AppTones.accentOnPrimary`) |
| `white` | `#FFFFFF` | `onPrimary`, `onSecondary`, `surfaceContainerLowest`, `surfaceBright` | Card surface, text on navy |
| — | `#0F172A` | `onTertiary` | Navy label on an amber fill |

Primary is always slate navy, never pure black. Tertiary is always amber, never black.

### Neutrals (Tailwind slate scale)

| Token | Hex | Scheme slot / tone | Role |
|---|---|---|---|
| `canvas` | `#F8FAFC` | `surface`, `surfaceContainerLow`, scaffold | Level-0 page canvas |
| `container` | `#F1F5F9` | `surfaceContainer` | Input fill, intro banners, icon tiles |
| `containerHigh` | `#E2E8F0` | `surfaceContainerHigh`, `outlineVariant`, `surfaceDim` | Structural hairline borders, card borders |
| `containerHighest` | `#CBD5E1` | `surfaceContainerHighest` | Strong borders (outlined button, level-2 cards) |
| `outline` | `#94A3B8` | `outline` | Placeholder text, disabled glyphs |
| `slate500` | `#64748B` | `AppTones.muted` | Muted metadata, hints, inactive dock slots |
| `slate700` | `#334155` | `AppTones.label` | Field labels |
| `onSurface` | `#191C1E` | `onSurface` | Body text |
| `onSurfaceVariant` | `#45464D` | `onSurfaceVariant` | Secondary icons and text |
| `inverseSurface` / `inverseOnSurface` | `#2D3133` / `#EFF1F3` | inverse slots | Snackbars, photo "change" overlay |

### Status tints (the only way status is communicated)

Each tint is a foreground on its container (`AppTones` `ok`, `dueSoon`, `overdue`, `info`, as
`ToneColors.status`). A status is never color alone: it always carries a Persian word and, where
relevant, a number.

| Meaning | Persian label | Foreground | Container |
|---|---|---|---|
| Optimal | `سالم` | Emerald `#10B981` | `#ECFDF5` |
| Due soon | `نزدیک به موعد` | Amber `#F59E0B` | `#FFFBEB` |
| Overdue | `رسیدگی فوری` | Rose `#EF4444` | `#FEF2F2` |
| Informational | — | Sky `#0EA5E9` | `#F0F9FF` |

Extra tone sets (icon tile + chip) used on auth screens: `AppTones.amber` (amber-50/200/600/100/800),
`AppTones.emerald` (emerald-50/200/600/100/800), `AppTones.neutral` (slate container/border, navy
glyph). `AppTones.success` is emerald-600 `#059669` for inline positive feedback.

### Error

| Slot | Hex | Role |
|---|---|---|
| `error` | `#BA1A1A` | Error border, error icon and the one-line error under a field (`AuthErrorText`) |
| `errorContainer` / `onErrorContainer` | `#FFDAD6` / `#93000A` | Error banners |

### Vehicle palette (`VehiclePalette`, real-world colors, not semantic)

| Field | Hex | Use |
|---|---|---|
| `plateBand` / `onPlateBand` | `#1E3A8A` / `#FFFFFF` | Blue `I.R. IRAN` band of the Iranian plate |
| `white`, `black`, `silver`, `blue`, `red`, `beige` | `#FFFFFF`, `#1E293B`, `#94A3B8`, `#1E3A8A`, `#DC2626`, `#D97706` | Body-color swatches of the vehicle form (order = `VehicleColor`) |

### Chart series (`ChartPalette`)

Car identity in charts, fixed order, never a status color: `#2563EB`, `#0891B2`, `#7C3AED`,
`#BE185D`, overflow `#64748B` (`سایر`). `ChartPalette.of(context).colorAt(index)` gives a vehicle's
color by its position in the garage list (the Home spend-chart legend).

## 3. Typography

**Vazirmatn only**, for Persian and Latin (bundled: Regular 400, Medium 500, SemiBold 600, Bold 700;
set once as `ThemeData.fontFamily`). Line heights run looser than Latin to protect diacritics.

| Stitch token | Size / line height / weight | Flutter `TextTheme` slot |
|---|---|---|
| `display-lg` | 32 / 44 / 700 | `displayLarge` |
| `display-lg-mobile` | 26 / 36 / 700 | `displayMedium` |
| `headline-lg` | 22 / 32 / 700 | `headlineLarge` |
| `headline-md` | 18 / 28 / 600 | `headlineMedium` (app bar titles), also `titleLarge` |
| `headline-sm` | 16 / 24 / 600 | `headlineSmall`, also `titleMedium` |
| `body-lg` | 16 / 26 / 400 | `bodyLarge` |
| `body-md` | 14 / 22 / 400 | `bodyMedium` |
| `body-sm` | 12 / 18 / 400 | `bodySmall` (helper and error text) |
| `label-lg` | 14 / 20 / 600 | `labelLarge`, also `titleSmall` |
| `label-md` | 12 / 16 / 500 | `labelMedium` |
| `label-sm` | 10 / 14 / 500 | `labelSmall` |
| `metric-odometer` | 28 / 34 / 800, -0.02em | `AppTextStyles.metricOdometer` (no slot) |

`metric-odometer` is only for mileage and large numeric metrics (odometer, invoice total, yearly
spend). Weight 800 falls back to the bundled Bold.

## 4. Shape, spacing and elevation

**Radii** (`AppTheme`):
- Inputs and buttons (filled, text, outlined, icon): **12px** (`AppTheme.radius`).
- Cards: **16px** (`AppTheme.cardRadius`).
- Small tiles, thumbs and chips inside cards: 8px. Badges and filter chips: full pill.
- Bottom dock and action sheets: 24px, top corners only.

**Spacing** (Stitch tokens; widgets use the literal values): `space-xs` 4, `space-sm` 8,
`space-md` / `gutter` / `margin` 16, `space-lg` 24, `space-xl` 32, `gutter-sm` 12, `margin-tablet` 24.
- Canvas: 16px side inset.
- Form rhythm: 24px between field groups, a label then its field, 32px before a sticky footer.

**Elevation** (shadows tinted with navy `rgba(15,23,42,…)` via `colorScheme.shadow`):
- Level 0: flat canvas `#F8FAFC`.
- Level 1: white card, `1px #E2E8F0` border, shadow `0 1px 3px` at 5%.
- Level 2: floating card, `1px #CBD5E1` border, shadow `0 4px 12px -2px` at 8%.
- Level 3: sticky dock, bottom sheets, the dock add button, shadow `0 -4px 20px` at 8%.

## 5. Components

- **Primary button** (`FilledButton`): navy fill, white bold label, 12px radius, min height 56dp.
  One primary action per screen.
- **Secondary / outline** (`OutlinedButton`): white surface, `1px #CBD5E1`, slate label.
- **Accent action**: amber fill with navy label, for high-urgency entries only.
- **Destructive**: ghost shape with rose label and border (delete, ownership transfer).
- **Inputs** (`InputDecorationTheme`): filled `#F1F5F9`, `1px #E2E8F0` border, 12px radius,
  16 x 20 padding; focus is a 2px navy border; errors turn the border `error` and show a `body-sm`
  error line with an icon below the field (never border color alone). Text is right-aligned (RTL).
- **Digits fields** (`DigitsInputFormatter`): accept any script, show locale digits (`۷۲`),
  grouped mileage (`۳۴٬۵۰۰`) with the unit `کیلومتر` pinned to the field's end; values go to the
  domain in Latin digits.
- **License plate**: a structured component, never one text field: two digits, a letter picker,
  three digits, then the province code in the `ایران` band with the blue `I.R. IRAN` strip.
- **Cards**: white, 16px radius, hairline border, 16px padding. Service rows: 44x44 tinted icon
  tile, title and Jalali date, then a status badge or chevron.
- **Status badge**: pill, 24px tall, 11px weight 600, status tint only, text always present.
- **Bottom dock** (`BottomNavDock`): 68dp + safe area, `1px #E2E8F0` top border, level 3. Slots:
  خانه (`home`), گاراژ من (`directions_car`), raised 56x56 navy add button with amber `add` glyph
  (quick-actions sheet, never active, no label), تاریخچه (`history`), پروفایل (`person`). Active
  slot navy, inactive `#64748B`. Full-screen forms replace the dock with a sticky footer action.
- **App bar** on forms: 64dp, canvas surface, level-1 shadow, back button then the title in
  `headlineMedium`.
- **Garage vehicle card** (`GarageVehicleCard`, Stitch "گاراژ من"): default badge (amber star) or
  "انتخاب به عنوان پیش‌فرض", the `more_vert` options menu (tooltip "تنظیمات خودرو", first action
  "ویرایش خودرو"), nickname and summary with a 32px plate (`PlateBadge(dense: true)`), the odometer row
  ("آخرین ثبت: دیروز"), the service status banner and three 64dp shortcuts. Tapping the card opens
  the vehicle details.
- **Home** (Stitch "داشبورد کلی گاراژ"): avatar + "مدیریت خودرو" over "خانه" app bar, vehicle chip
  strip, three summary tiles, the 6-month spend chart card and the amber "بروزرسانی کیلومتر" action.
- **Empty states**: centred faint illustration, one Persian line, one primary CTA. Never a blank
  screen or a spinner standing in for empty.

## 6. RTL, Persian and content rules

- Default locale `fa`, layout `rtl`; the visual origin is top-right. `chevron-left` means advance,
  `chevron-right` (or `arrow_forward`) means back.
- Numbers on screen use Persian digits with `٬` grouping, formatted with `intl` for
  `l10n.localeName`; storage and the wire always use Latin digits.
- Dates use the Jalali calendar: numeric `۱۴۰۳/۰۸/۲۱` in lists, long form `۲۱ آبان ۱۴۰۳` in headers.
- Currency is always `تومان`, after the figure.
- **No invented metrics**: no health score, percentage, gauge or trend badge the backend does not
  compute. Fines, insurance, tolls and inspection are manual entries; never `استعلام`.
- All user-facing text and semantics labels come from `AppLocalizations` (`fa` + `en`).

## Known gaps (Stitch vs theme)

1. **Generated token set vs brand prose.** The Stitch design system's generated colors (its YAML
   `colors:` block, and the Tailwind config embedded in every screen) are Material-generated:
   `primary #000000`, `secondary #545F73`, `tertiary #000000`, `onTertiary #FFFFFF`, `surface #F7F9FB`,
   `surface-container-low/-/high/highest #F2F4F6/#ECEEF0/#E6E8EA/#E0E3E5`, `outline #76777D`,
   `outline-variant #C6C6CD`, `surface-dim #D8DADC`. The same design system's prose and override
   colors (`#0F172A`, `#1E293B`, `#F59E0B`, `#F8FAFC`) say primary must be navy, never black, and use
   the slate scale. The theme follows the prose.
2. **Error text color.** Stitch prose: error text `#DC2626`, error border `#EF4444`. Theme: both use
   `error #BA1A1A`.
3. **Primary button height.** Stitch prose and screens: 48px. Theme: 56dp minimum (car-context
   touch-target rule).
4. **Input style.** Stitch screens: borderless `surface-container-low` fill that turns white with a
   shadow on focus. Stitch prose and theme: `#F1F5F9` fill, hairline `#E2E8F0` border, 2px navy focus
   border.
5. **Field label color.** Stitch prose: `#475569` (slate-600). Theme: `AppTones.label` `#334155`
   (slate-700) for labels, `AppTones.muted` `#64748B` for hints.
6. **Radius scale.** Stitch YAML `rounded`: default 8, md 12, lg 16, xl 24. Screen Tailwind configs:
   default 4, lg 8, xl 12. The theme follows the prose component rules (12 inputs/buttons, 16 cards).
7. **Label-to-field gap.** Stitch prose: 16px. The vehicle form widgets use 8px, like the Stitch
   add/edit screen HTML (`space-sm`).
8. **Not in the theme yet:** spacing tokens as constants, level 1-3 shadows
   as shared values (widgets inline them), the accent and destructive button styles.
9. **Edit vehicle.** Stitch has one shared "افزودن و ویرایش خودرو" screen
   (`bfe6315dd49945ce98c66b6d32383bc3`) drawn in add mode only. The edit-mode title ("ویرایش خودرو"),
   save label ("ذخیره تغییرات") and the garage `more_vert` menu content are not drawn in Stitch.
10. **Values with no data yet.** Home tiles (cost, invoices, attention), the spend bars, the garage
    service banner and the document count are drawn with sample numbers in Stitch. Until their
    phase, the app shows "—" (read as "قابل محاسبه نیست"), an empty chart message and a neutral
    banner, and leaves the document count out. Rows and shortcuts whose page isn't built are shown
    at 45% opacity.
11. **Tailwind tints with no token.** Stitch's `blue-600` (odometer shortcut icon) uses the info
    sky `#0EA5E9`; `amber-700` (attention tile number) uses `amber600`; `secondary-container` pills
    use `surfaceContainerHigh`.
