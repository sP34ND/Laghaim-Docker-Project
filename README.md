# Laghaim Private Server

Self-hosted **Laghaim MMO** — 32-bit Linux game server running in Docker, with a Windows client.

> **Goal:** Log in as `testreg` / `secret`, pick character `test`, enter the world, and travel between zones — with no disconnect and no client freeze.

---

<img width="1913" height="1011" alt="laghaim" src="https://github.com/user-attachments/assets/07b54e58-32b3-45aa-9abe-a9a50baea73d" />

## Quick start (Docker)

### Prerequisites

| Requirement | Notes |
|-------------|-------|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows) | Linux containers mode |
| ~6 GB free disk | MySQL import is large |
| ~2 GB RAM | `minimal` mode; `full` mode needs 4–6 GB |
| Windows client folder `LaghaimClient/` | Compatibles Client [CLIENT.md](CLIENT.md) |
| Node.js 14+ | Only needed to re-patch `SvrList.dta` |

### 1 — Clone / extract

```powershell
# The LaghaimClient/ folder must be present (game binaries + data files)
# The svlaghaim/ folder must be present (32-bit Linux server binaries)
cd D:\Laghaim
```

### 2 — Configure

```powershell
cd docker
copy .env.example .env
# Edit .env — key setting: GAME_HOST_IP
```

| Variable | Default | When to change |
|----------|---------|----------------|
| `GAME_HOST_IP` | `127.0.0.1` | Client on another PC → set to Windows LAN IP (e.g. `192.168.1.50`) |
| `LAGHAIM_MODE` | `minimal` | `full` starts all 22 zones (heavy) |
| `CLIENT_VERSION` | `3004` | Must match `Game.exe` — **do not change for this bundle** |
| `MYSQL_ROOT_PASSWORD` | `laghaimofficial` | Change if exposing MySQL externally |
| `EXPRATE` | `100` | EXP multiplier (100 = 100× base) |
| `EQUIP_DROPRATE` | `100` | Equipment drop multiplier |
| `DROPRATE` | `50` | Misc/consumable drop multiplier |
| `ZONE_DROPRATE` | `10` | Zone-wide loot multiplier |
| `LAGHAIM_MEMORY_LIMIT` | `4g` | Raise to `6g` for `full` mode |

> **Same-PC setup:** `GAME_HOST_IP=127.0.0.1` is correct. No changes needed.

### 3 — Start the server

```powershell
cd D:\Laghaim\docker
docker compose up --build
```

> First start imports all SQL dumps. This takes **10–30 minutes**. Watch:
> ```powershell
> docker compose logs -f mysql
> ```
> Wait until you see:
> ```
> laghaim-server  | ==> Minimal stack running. Connector :4015, zones decard :4001, start :4005
> ```

### 4 — Launch the client

1. Open `LaghaimClient\` folder
2. Run **`Launch Game.bat`** (or `game.exe 1`)
3. Login: **`testreg`** / **`secret`**
4. Select character: **`test`**

> **Graphics:** Install `DDrawCompat` — copy `ddraw.dll` and `DDrawCompat-Game.ini` from `LaghaimClient/` if the game starts with a black screen or "Init 3D fail". See [CLIENT.md](CLIENT.md).

---

## Repository layout

```
├── docker/                   # All server-side Docker files
│   ├── docker-compose.yml
│   ├── Dockerfile            # 32-bit Debian + game server binaries
│   ├── Dockerfile.mysql      # MySQL 5.7 + baked SQL import
│   ├── entrypoint.sh         # Wait for MySQL, patch configs, start servers
│   ├── start-minimal.sh      # Connector + Messenger + Helper + 2 zones
│   ├── apply-exp-rate.sh     # Sets t_npc.a_exp × EXPRATE at start
│   ├── apply-drop-rate.sh    # Sets drop rates × multipliers at start
│   ├── apply-gem-shop-laglamia.sh  # Custom buy shops in Laglamia
│   ├── apply-phewphew-max-money.sh # Sets test account gold/LP cap
│   ├── mysql-init/           # DB creation + import scripts (baked into image)
│   ├── .env.example          # Copy to .env and edit
│   └── DOCKER.md             # Full Docker reference
│
├── LaghaimClient/            # Windows game client (NOT committed if large)
│   ├── game.exe
│   ├── SvrList.dta           # Pre-patched → 127.0.0.1:4015
│   ├── ddraw.dll             # DDrawCompat graphics wrapper
│   ├── config.ini            # Windowed 1, Resolution 2
│   └── data/
│
├── svlaghaim/                # Linux 32-bit server binaries + configs
│   ├── config/config.json
│   └── ...
│
├── sql/                      # MySQL dump files (imported on first docker compose up)
│
├── tools/
│   ├── svrlist-patch.js      # Re-patch SvrList.dta for a different IP/port
│   ├── create-account.ps1    # Create a new game account in MySQL
│   └── README.md
│
├── AGENTS.md                 # Authoritative runbook — read this first
├── SETUP.md                  # Full bare-metal + Docker setup guide
├── CLIENT.md                 # Windows client: graphics, login, SvrList
├── CHANGELOG.md              # Every fix applied and why
└── README.md                 # This file
```

---

## Key facts (critical — do not change)

| Thing | Value | Why |
|-------|-------|-----|
| Client connects to | `127.0.0.1:4015` (Connector) | `SvrList.dta` pre-patched |
| `CLIENT_VERSION` | **`3004`** | Verified from zone login packet; `3034` causes "client version different" disconnect |
| Login zone port | `:4005` (start zone) | NOT `:4015` — Connector speaks an internal protocol, not the client login protocol |
| MySQL password | `laghaimofficial` | Seeded into all configs |
| Test account | `testreg` / `secret` | Seeded in MySQL on first start |
| Graphics wrapper | DDrawCompat `ddraw.dll` | Native D3D7 on Win10/11 = "Init 3D fail" |

---

## Common commands

```powershell
cd D:\Laghaim\docker

# Start (background)
docker compose up -d --build

# View live logs
docker compose logs -f laghaim

# Stop
docker compose down

# Stop and wipe database (re-import on next up — takes 10-30 min again)
docker compose down -v

# Shell into game server
docker compose exec laghaim bash

# Verify zones are up
docker compose exec -T laghaim ss -ltnH | Select-String ':4015',':4005',':4011',':4001'

# Check Messenger is alive and zones registered (full mode expects ~22)
docker compose exec -T laghaim tail -5 /opt/laghaim/log/Messenger.log

# Restart (reloads shop/rate changes)
docker compose restart laghaim
```

---

## Custom shops in Laglamia (start zone)

These shops are applied automatically at container start by `apply-gem-shop-laglamia.sh`:

| Shop | NPC | Position | Items |
|------|-----|----------|-------|
| Gem Merchant (1871) | Magic Shopkeeper | (6720, 5135) | 17 gems — Rough Amethyst → Regent Diamond |
| Magic Stone Merchant (1873) | Magic Shopkeeper | (6720, 5143) | Gnome / Nymph / Sylph / Salamander Rune Stone |
| Machine Dealer (142) | Machine Dealer | (6729, 5129) | 18 guns — Killer Rifle → Naegling |

All items priced at **1 lime** each. After any shop change, `docker compose restart laghaim` is required — shops are loaded once at zone process start, re-entering the zone alone is not enough.

---

## Rates & multipliers

Rates are set in `docker/.env` and applied to MySQL at container start:

| Variable | Applies to | Default |
|----------|-----------|---------|
| `EXPRATE` | `t_npc.a_exp` (monster EXP) | `100` (100× base) |
| `PETEXPRATE` | Pet EXP | `40` |
| `EQUIP_DROPRATE` | Equipment drops (weapons, armor, guns) | `100` |
| `DROPRATE` | Misc / consumable mob drops | `50` |
| `ZONE_DROPRATE` | Zone-wide loot (`t_zone_itemrate`) | `10` |

Edit `.env`, then `docker compose up -d laghaim` (or `restart laghaim`). Relog to see EXP changes.

> Note: `EXPRATE` in `config.json` has no effect — this server build does not read it. The `apply-exp-rate.sh` script patches MySQL directly.

---

## Create a new account

```powershell
cd D:\Laghaim\tools
.\create-account.ps1 -User myplayer -Password mypassword
```

Then log in with `Game.exe` and create a character in-game (60-second creation cooldown).

---

## Change server IP (LAN / remote)

If the game client is on a **different machine** from Docker:

1. Edit `docker/.env`:
   ```env
   GAME_HOST_IP=192.168.1.50   # your Windows host LAN IP
   ```
2. Re-patch `SvrList.dta`:
   ```powershell
   cd D:\Laghaim\tools
   node svrlist-patch.js 192.168.1.50 4015 SavageEden
   ```
3. Restart: `docker compose up -d laghaim`

---

## Troubleshooting

### Black screen / "Init 3D fail"
- Check `ddraw.dll` (DDrawCompat) is in the `LaghaimClient/` folder
- Check `config.ini` has `Windowed 1` and `Resolution 2`
- Rename `dbghelp.dll` → `dbghelp.dll.bak` if present
- See [CLIENT.md](CLIENT.md)

### "Disconnect from server" after login
- `SvrList.dta` must point to `127.0.0.1:4015` — run `node tools\svrlist-patch.js`
- `CLIENT_VERSION` must be `3004` in `docker/.env`
- Verify Connector is listening: `Test-NetConnection 127.0.0.1 -Port 4015`
- Check `docker compose logs laghaim` for `bnf accepted` (successful login)

### "client version is different" (MSG 2100)
- Set `CLIENT_VERSION=3004` in `docker/.env`, then `docker compose up -d laghaim`

### "Zone cannot be moved, try again"
- Messenger is down — check: `docker compose exec -T laghaim tail -10 /opt/laghaim/log/Messenger.log`
- Should show zone registrations. If empty, restart: `docker compose restart laghaim`

### Client freeze on login click
- Old symptom from `libiconv` crash — fixed in current `Dockerfile`. Rebuild: `docker compose build laghaim`

### Shops not showing new items
- Shops load only at zone process boot. Must `docker compose restart laghaim` after any shop SQL change, then relog.

### First start very slow
- MySQL is importing ~1.7 M rows across 5 databases. Normal. Watch: `docker compose logs -f mysql`

### ARM / Apple Silicon host
```powershell
docker run --privileged --rm tonistiigi/binfmt --install all
docker compose build --no-cache
```

### Reset everything (wipe database and reimport)
```powershell
docker compose down -v
docker compose up --build
```

---

## Further reading

| File | Contents |
|------|----------|
| [AGENTS.md](AGENTS.md) | Hard-won runbook — authoritative on every trap and fix |
| [docker/DOCKER.md](docker/DOCKER.md) | Full Docker reference |
| [CLIENT.md](CLIENT.md) | Windows client graphics, windowed mode, SvrList |
| [SETUP.md](SETUP.md) | Bare-metal (non-Docker) server setup |
| [CHANGELOG.md](CHANGELOG.md) | Every bug, root cause, and fix from this session |
| [tools/README.md](tools/README.md) | Account creator, SvrList patcher, drop exporter |
