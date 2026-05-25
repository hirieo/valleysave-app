---
name: valleysave-design
description: >
  Sistema de diseño de ValleySave. Úsalo siempre que toques cualquier UI
  de ValleySave: landing page, app UI, componentes, emails, assets.
  Contiene tokens de color, tipografía, componentes y patrones validados.
effort: medium
---

## Identidad visual

**ValleySave** — app open source que sincroniza saves de Stardew Valley via Google Drive.

Estética: **dark editorial nocturno** — atmósfera de granja a medianoche,
luz de luna dorada, bokeh de luciérnagas. Serio pero con alma de videojuego.

No es: pixel art puro, ni dashboard corporativo, ni "app de gaming genérica".

---

## Tokens de color (oklch)

```css
:root {
  /* ── Tier 1: Literales ── */
  --c-gold-300:  oklch(85%  0.14  82);
  --c-gold-400:  oklch(78%  0.17  80);   /* acento principal */
  --c-gold-500:  oklch(68%  0.20  78);
  --c-green-300: oklch(68%  0.18 148);
  --c-green-400: oklch(60%  0.20 148);
  --c-green-500: oklch(50%  0.20 148);
  --c-green-800: oklch(24%  0.09 148);
  --c-green-900: oklch(14%  0.06 148);
  --c-green-950: oklch(9%   0.04 148);   /* bg principal */
  --c-sand-100:  oklch(94%  0.03  80);
  --c-sand-200:  oklch(88%  0.04  80);
  --c-sand-300:  oklch(78%  0.05  80);   /* text muted */

  /* ── Tier 2: Semánticos ── */
  --bg:            var(--c-green-950);
  --bg-alt:        oklch(12% 0.055 148);
  --surface:       oklch(13% 0.05  148);
  --surface-2:     oklch(17% 0.06  148);
  --surface-glass: oklch(16% 0.055 148 / 0.85);
  --text:          var(--c-sand-100);
  --text-muted:    var(--c-sand-300);
  --text-faint:    oklch(55% 0.04   80);
  --accent:        var(--c-gold-400);
  --accent-dim:    oklch(78% 0.17 80 / 0.12);
  --accent-glow:   oklch(78% 0.17 80 / 0.22);
  --green:         var(--c-green-300);
  --green-dim:     oklch(60% 0.20 148 / 0.10);
  --border:        oklch(24% 0.06  148);
  --border-sub:    oklch(18% 0.05  148);
}
```

---

## Tipografía

```css
@import url('https://fonts.googleapis.com/css2?family=Fraunces:opsz,ital,wght@9..144,0,600;9..144,0,700;9..144,1,400;9..144,1,700&family=DM+Sans:opsz,wght@9..40,400;9..40,500;9..40,700&family=DM+Mono:wght@400;500&display=swap');

--f-display: 'Fraunces', Georgia, serif;   /* headlines, hero — usar italic */
--f-body:    'DM Sans',  system-ui, sans-serif;
--f-mono:    'DM Mono',  monospace;        /* stats, badges, código */

/* Escala responsive */
--t-2xs: clamp(0.65rem, 0.55rem + 0.3vw, 0.75rem);
--t-xs:  clamp(0.75rem, 0.65rem + 0.3vw, 0.85rem);
--t-sm:  clamp(0.85rem, 0.75rem + 0.3vw, 1.00rem);
--t-md:  clamp(1.00rem, 0.90rem + 0.3vw, 1.12rem);
--t-lg:  clamp(1.15rem, 0.95rem + 0.7vw, 1.40rem);
--t-xl:  clamp(1.50rem, 1.10rem + 1.2vw, 2.00rem);
--t-2xl: clamp(2.00rem, 1.20rem + 2.5vw, 3.50rem);
--t-3xl: clamp(2.80rem, 1.50rem + 4.5vw, 5.50rem);
--t-4xl: clamp(3.50rem, 1.50rem + 6.5vw, 7.50rem);
```

Regla de uso:
- Hero h1: `var(--t-4xl)`, Fraunces italic bold, `letter-spacing: -0.025em`
- Section h2: `var(--t-2xl)`, Fraunces italic, `letter-spacing: -0.015em`
- Body: `var(--t-md)`, DM Sans 400
- Labels/badges: `var(--t-xs)`, DM Mono
- Stats: `var(--t-2xl)`, Fraunces italic, gold

---

## Espaciado

```css
--sp-1: 0.25rem;  --sp-2: 0.5rem;   --sp-3: 0.75rem;
--sp-4: 1rem;     --sp-6: 1.5rem;   --sp-8: 2rem;
--sp-12: 3rem;    --sp-16: 4rem;    --sp-24: 6rem;
--sp-32: 8rem;
```

---

## Radios

```css
--r-sm: 6px;   --r-md: 12px;  --r-lg: 18px;
--r-xl: 24px;  --r-pill: 999px;
```

---

## Componentes validados

### Hero headline
```html
<h1 style="
  font-family: var(--f-display); font-style: italic; font-weight: 700;
  font-size: var(--t-4xl); line-height: 0.92; letter-spacing: -0.025em;
  color: var(--text); text-wrap: balance;
">
  Nunca pierdas<br>tu <em style="font-style:normal;color:var(--accent)">granja</em><br>otra vez.
</h1>
```

### Chip / eyebrow
```html
<div class="chip">✦ Código abierto · MIT · Gratis para siempre</div>
```
```css
.chip {
  display: inline-flex; align-items: center; gap: 6px;
  background: rgba(18,46,18,.85); border: 1px solid oklch(55% 0.10 148 / 0.4);
  color: var(--green); padding: 5px 14px; border-radius: var(--r-pill);
  font-size: var(--t-xs); font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase;
}
```

### Botón primary (gold)
```css
.btn-primary {
  font-family: var(--f-body); font-size: var(--t-md); font-weight: 700;
  padding-inline: var(--sp-8); block-size: 52px; min-block-size: 44px;
  background: var(--accent); color: oklch(9% 0.04 148);
  border: none; border-radius: var(--r-pill); cursor: pointer;
  box-shadow: 0 4px 22px var(--accent-glow);
  transition: filter .2s, transform .1s;
}
.btn-primary:hover { filter: brightness(1.12); }
.btn-primary:active { transform: scale(.97); }
.btn-primary:focus-visible { outline: 3px solid var(--accent); outline-offset: 3px; }
```

### Botón ghost (green)
```css
.btn-ghost {
  font-size: var(--t-md); font-weight: 600;
  padding-inline: var(--sp-6); block-size: 52px; min-block-size: 44px;
  background: transparent; color: var(--text-muted);
  border: 1.5px solid var(--border); border-radius: var(--r-pill); cursor: pointer;
  transition: border-color .2s, color .2s, background .2s;
}
.btn-ghost:hover { border-color: var(--green); color: var(--green); background: var(--green-dim); }
```

### Save card (app UI)
```css
.save-card {
  background: var(--surface); border: 1px solid var(--border);
  border-radius: var(--r-lg); padding: var(--sp-6);
  transition: border-color .2s, box-shadow .2s, transform .2s;
}
.save-card:has(.card-sync:hover) {
  border-color: oklch(50% 0.15 80 / 0.8);
  box-shadow: 0 8px 32px var(--accent-glow);
}
```

### Card stat (monospace)
```css
.cstat { background: var(--bg-alt); border: 1px solid var(--border-sub); border-radius: 7px; padding: 6px 8px; }
.cstat-lbl { font-family: var(--f-mono); font-size: var(--t-2xs); color: var(--text-faint); letter-spacing: 0.08em; text-transform: uppercase; }
.cstat-val  { font-family: var(--f-mono); font-size: var(--t-xs); font-weight: 500; color: var(--text-muted); }
```

### Status badge
```css
.status { display: flex; align-items: center; gap: 6px; font-family: var(--f-mono); font-size: var(--t-xs); font-weight: 700; }
.status::before { content: ''; display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
.status.ok   { color: oklch(62% 0.22 145); }
.status.pend { color: var(--c-gold-400); }
.status.err  { color: oklch(62% 0.22 30); }
```

### App sidebar nav item
```css
.nav-item {
  display: flex; align-items: center; gap: 10px;
  padding: 9px 10px; border-radius: var(--r-md);
  font-size: var(--t-sm); font-weight: 500; color: var(--text-faint);
  text-decoration: none; min-block-size: 40px;
  transition: background .15s, color .15s;
}
.nav-item[aria-current="page"] { background: var(--accent-dim); color: var(--accent); }
.nav-item:hover:not([aria-current]) { background: var(--surface-2); color: var(--text-muted); }
```

---

## Fondos atmosféricos

```css
/* Hero bg estándar */
.hero {
  background:
    radial-gradient(ellipse 75% 60% at 70% 38%, oklch(24% 0.09 148 / 0.7), transparent 65%),
    radial-gradient(ellipse 65% 80% at 50% 108%, var(--bg), transparent 65%),
    var(--bg);
}

/* Dot grid */
.dot-grid {
  background-image: radial-gradient(circle, oklch(30% 0.06 148 / 0.28) 1px, transparent 1px);
  background-size: 30px 30px;
  mask-image: radial-gradient(ellipse 85% 85% at 50% 50%, black 30%, transparent 72%);
}

/* Grain texture */
.grain::before {
  content: '';
  position: absolute; inset: 0; pointer-events: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='200' height='200'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.75' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.07'/%3E%3C/svg%3E");
}
```

---

## Monetización (ya validado en UI)

### Ko-fi card
- Fondo: `linear-gradient(135deg, var(--surface) 0%, oklch(17% 0.06 80) 100%)`
- Border: `1px solid oklch(from var(--accent) l c h / 0.28)`
- Tiers: 3€ café / 10€ pizza / 25€ supporter
- Texto: "100% voluntario · Sin presión"

### AdMob banner (app UI)
- Altura mínima: 52px, fijo en parte inferior
- Label "Anuncio" en DM Mono 9px
- Botón "Abrir" en azul `rgba(60,160,220,.14)` / `#60c0e8`
- Siempre con botón ✕ para cerrar

### Native ad card
- Mismo estilo visual que save cards pero con border azul sutil
- Label "Patrocinado" en DM Mono
- Integrado en el grid de saves (no interrumpe el flujo)

---

## Estaciones (landing hero)

Cada estación tiene: bg gradient, accent color, partículas Canvas 2D.

| Estación | Bg from | Accent | Partículas |
|----------|---------|--------|------------|
| 🌸 Primavera | `#0a1e14` | `#f0b8c8` | Pétalos + lluvia fina |
| ☀️ Verano | `#0a1628` | `#f0d060` | Luciérnagas + sol |
| 🍂 Otoño | `#1a0c08` | `#e8783a` | Hojas + viento + calabazas |
| ❄️ Invierno | `#08081e` | `#90c8f0` | Nieve + estrellas |

Auto-ciclo: 9 segundos. Ver `canvas-seasons` skill para implementación.

---

## Gotchas del proyecto

- La fuente Fraunces en italic es el elemento visual más reconocible — úsala siempre en headlines
- El acento gold (`--c-gold-400`) va en CTAs, stats y highlights — no abusar
- El green (`--c-green-300`) va en chips, status ok, elementos de naturaleza
- Los fondos nunca son sólidos — siempre gradiente radial + algo más
- App bar: `backdrop-filter: blur(12px)` + `background: rgba(10,22,11,.95)` — sticky siempre
- Progress bar: elemento `<progress>` nativo, nunca div disfrazado
