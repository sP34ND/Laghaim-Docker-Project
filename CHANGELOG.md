# Laghaim Setup — Session Changelog

Work log from the initial reverse-engineering and Docker setup session (June 2026). Use this with [SETUP.md](SETUP.md), [CLIENT.md](CLIENT.md), and [docker/DOCKER.md](docker/DOCKER.md).

---

## Tune: split drop multipliers (zone down, equipment up)

**Symptom:** Zone-wide loot too frequent; armor/guns/demolition/cannon MK1 and other gear
still too rare at a single flat `DROPRATE`.

**Fix:** `docker/apply-drop-rate.sh` now uses three env vars in `docker/.env`:
`ZONE_DROPRATE` (lower, for `t_zone_itemrate`), `EQUIP_DROPRATE` (higher, for mob/group
drops where `t_item.a_type_idx` is wear/armor/weapon/sub), and `DROPRATE` for everything
else. Defaults: `ZONE_DROPRATE=10`, `DROPRATE=50`, `EQUIP_DROPRATE=100`. Recreate the
container after editing.

---

## Add: PhewPhew max money + max LP (2.1B each)

**Symptom:** Direct MySQL `UPDATE t_characters SET a_money=2100000000` did not stick —
client still showed ~453k.

**Root cause:** PhewPhew was **in-game** when the DB was edited. The zone keeps money in
memory and writes it back on save/logout, overwriting the SQL change. LP is stored per
**account** in `kor_ndev_neogeo_event.TBL_LaghaimPointUser.lpu_user_lag_point` (same
overwrite risk while online).

**Fix:** `docker/apply-phewphew-max-money.sh` sets `a_money = 2100000000` and
`lpu_user_lag_point = 2100000000` (server cap) at container start. **Fully log out to
character select** (not just zone change), then log back in. While online you can also run
GM chat `sp_money 2100000000` or `sp_lp <amount>` (PhewPhew has `a_admin = 11`; `sp_lp`
adds LP, it does not set).

---

## Add: Gem Shopkeeper NPC in Laglamia

**Request:** Sell gems in Laglamia (starter town).

**Root cause (first attempt):** Shop was inserted with `t_shop.a_world_num = 0`, but the
client login zone is **start :4005** which loads shops where `a_world_num = 4` (`ZONE_START`).
World 0 is the separate **decard :4001** process — the NPC never appeared where players log in.

**Fix:** `docker/apply-gem-shop-laglamia.sh` places shop **1871** at **(6710, 5190)** in
**world 4** (near default spawn ~6701, 5180), stocks legacy Dekaren gem shops **67** and
**180**, and runs at laghaim container start. Uses **Merchant NPC 64** (not vnum 166 —
the Gem Shopkeeper model opens the chip-exchange UI on the client). Shop `a_type=16` with
`a_price=1` per item. **Re-enter the zone** after restart so `LoadShop()` runs again.

---

## Fix: EXPRATE in config.json had no effect on monster EXP

**Symptom:** Setting `EXPRATE` in `config.json` / `docker/.env` did not change monster EXP
(e.g. Pharos `Str_Hammer Genter` still showed 120000).

**Root cause:** This server build never reads `EXPRATE` from `config.json` (`CommonConfig.cpp`
loads many keys but not EXP). Monster EXP is loaded from MySQL `kor_ndev_neogeo_data.t_npc.a_exp`
when each zone starts.

**Fix:** `docker/apply-exp-rate.sh` runs at container start, keeps vanilla values in
`laghaim_npc_exp_base`, and sets `t_npc.a_exp = base_exp * EXPRATE`. Tune via
`docker/.env` (`EXPRATE=4` → 4×, `EXPRATE=100` → 100×), then `docker compose up -d laghaim`.
Re-enter the zone (or relog) so the client picks up the new NPC table.

**Drop rate:** `docker/apply-drop-rate.sh` at container start — three multipliers in `docker/.env`:
`DROPRATE` (misc/material mob + group drops), `EQUIP_DROPRATE` (wear/armor/weapon/sub equipment
via `t_item.a_type_idx` 0/1/2/5 — guns, demolition, cannon MK1, etc.), and `ZONE_DROPRATE`
(zone-wide `t_zone_itemrate`, usually lower). Baselines in `laghaim_*_drop_base` tables; caps
10000 per mob slot and 1000000 for zone/group rolls.

---

## Fix: Client crash hovering LP shop items

**Symptom:** Game.exe exits when hovering an item in the LP (Laghaim Points) shop.

**Root cause:** LP shop uses the special-shop UI (`shop_type` 19). On hover, the client
runs `DrawItemInfo()` and renders a **3D item preview** inside the tooltip (extra
`BeginScene`/`Clear` on the D3D7 device mid-frame). On Windows 10/11 with fullscreen
and high resolution (`Resolution 6`), this often crashes the process.

**Fix (`LaghaimClient/DDrawCompat-Game.ini`, `config.ini`):** DDrawCompat stability settings
(`DpiAwareness=unaware`, `RenderColorDepth=16`, `VertexBufferMemoryType=sysmem`,
`SoftwareDevice=rgb`, `CrashDump=on`) plus **windowed 1024×768** (`Windowed 1`,
`Resolution 2`) — fullscreen `Resolution 6` still crashed with the same
`Game.exe+0x000fdbd8` access violation after the first ini-only attempt.

**Workarounds if it still crashes:** avoid hovering shop slots (click to buy), or
remove item 3814 (LP strengthen Jewelry) from `t_shopitem` if that specific icon
is the trigger.

---

## Fix: "Zone cannot move, try again in a few minutes" (messenger killed by bridge)

**Symptom:** After enabling full mode + the socat zone-change bridge, changing zones
failed in-game with "zone cannot be moved, try again in a few minutes".

**Root cause:** The `socat` bridge in `entrypoint.sh` was started *before* the game
servers and bound `eth0:<port>` for the whole 4001–4036 range — including `:4011`.
The **Messenger** ignores `config.json` and binds `0.0.0.0:4011` itself. Because
`0.0.0.0:4011` overlaps `eth0:4011`, the messenger failed with
`bind error [Address already in use]` and never came up. With no messenger, zones
can't register/coordinate, so inter-zone moves are rejected with the retry message.

**Fix (`docker/entrypoint.sh`, `docker/start-minimal.sh`):**
- Bridge now starts *after* the servers (`start-minimal.sh` no longer blocks on `tail`).
- Replaced the blind bridge with a self-healing `bridge_monitor` that only bridges
  ports actually bound to `127.0.0.1` (skips `0.0.0.0` services like the messenger),
  and re-scans every 10s so watchdog-restarted/slow zones get bridged too.

**Verified:** Messenger stays up on `0.0.0.0:4011`; all 22 zones register
(`world_num[0]/4001` = Lost Realm Castle … `world_num[4]/4005` = start); bridge
binds `eth0` only for loopback-bound ports (4001/4005/4015/…), never 4011.

---

## Bundle overview (reverse-engineered)

| Path | Role |
|------|------|
| `svlaghaim/` | Linux **32-bit ELF** game server (Connector, Messenger, Helper, LhDebug zones) |
| `Laghaim/` | Windows **client** (`Game.exe` + partial assets) |
| `sql/` | MySQL dumps — 5 databases, 261 tables (Jan 2017 era) |
| `docker/` | Docker Compose stack (MySQL + game server) |
| `tools/` | Utilities (e.g. `SvrList.dta` patcher) |

**Architecture:** Client → Connector `:4015` → zone servers `:400x` → MySQL `:3306`.

**Version:** Client `Game.exe` build **3034**; original server `config.json` had **3004** — must be **3034**.

**Test account:** `testreg` / `secret` (channel **660**), character **`test`** (level 6, zone **start** / zone ID 4, port **4005**).

---

## Files created

### Documentation

| File | Purpose |
|------|---------|
| `SETUP.md` | Full manual VM + MySQL + server + client guide |
| `CLIENT.md` | Windows client: graphics, `SvrList.dta`, login |
| `docker/DOCKER.md` | Docker Compose quick start and troubleshooting |
| `CHANGELOG.md` | This file |

### Docker stack (`docker/`)

| File | Purpose |
|------|---------|
| `Dockerfile` | `i386/debian:bookworm` + 32-bit game binaries + MySQL 5.1 client lib |
| `Dockerfile.mysql` | MySQL 5.7 with baked-in SQL init (fixes Windows volume-mount import) |
| `docker-compose.yml` | `laghaim-mysql` + `laghaim-server` |
| `entrypoint.sh` | Wait for MySQL, patch configs, start server |
| `start-minimal.sh` | Connector + Messenger + Helper + PacketSniffing + zones 0 & 4 |
| `install-mysql-client.sh` | Extract `libmysqlclient.so.16` from Debian archive |
| `mysql-init/00-create-databases.sql` | Create 5 databases |
| `mysql-init/01-import.sh` | Import all SQL dumps on first run |
| `.env.example` | Environment template |
| `.dockerignore` | Exclude client from build context |

### Tools

| File | Purpose |
|------|---------|
| `tools/svrlist-patch.js` | Patch `SvrList.dta` IP/port (Node.js) |
| `tools/README.md` | Patcher usage and file format |
| `Laghaim/Install DDrawCompat.bat` | One-shot download `ddraw.dll` for graphics |

### Client changes

| File | Change |
|------|--------|
| `Laghaim/SvrList.dta` | Patched → `SavageEden 127.0.0.1 4015` |
| `Laghaim/SvrList.dta.orig` | Backup of original |
| `Laghaim/dbghelp.dll` → `dbghelp.dll.bak` | Removed conflict with DDrawCompat |
| `Laghaim/config.ini` | `Windowed 1` (windowed mode) |
| `Laghaim/data/CONFIG.JSON` | `CAPTCHA: false` |

### Server config

| File | Change |
|------|--------|
| `svlaghaim/config/packet_sniffing.json` | Added `127.0.0.1` to `TOOL_IP_LIST` |

---

## Docker issues fixed

| Issue | Cause | Fix |
|-------|--------|-----|
| `apt` 404 on build | Debian Buster EOL | Base image → `i386/debian:bookworm` |
| `libmysqlclient_16 not found` | MariaDB symlink wrong | Bundle MySQL 5.1 `libmysqlclient16` deb |
| Watchdog crash loop | Missing `/bin/ps` | Added `procps` to Dockerfile |
| Empty MySQL tables | Init script on Windows mount failed | `Dockerfile.mysql` bakes SQL into image |
| Container exits (full mode) | `serverrestart.sh` doesn't block | `hold_container()` tail/sleep in entrypoint |
| **Disconnect after login** | Servers bound `127.0.0.1` inside container; Docker forwards from `172.x` | `BIND_IP=0.0.0.0` in `entrypoint.sh` |
| PacketSniffing crash loop | Missing `libexpat.so.0` | Symlink `libexpat.so.1` → `libexpat.so.0` in Dockerfile |
| PacketSniffing connect errors | Zones tried `0.0.0.0:4018` | Keep `PACKETSNIFFING_SERVER` at `127.0.0.1` for loopback |
| **Login freeze / Connector crash** | `libiconv.so.2` was symlinked to `libiconv_hook`, which lacks `libiconv_open`/`libiconv`/`libiconv_close`. Connector dies with `symbol lookup error: undefined symbol: libiconv_open` on the first login (`a2u()` cp949→utf-8 DB query) | Compile a real `libiconv.so.2` shim over glibc `iconv` in the Dockerfile (exports the GNU libiconv symbols) |
| **Zone change fails (e.g. to Lost Realm Castle)** | `ZONE_INFO` IP is used both to *bind* the zone listener (needs `0.0.0.0` in Docker) and as the address sent to the client on `go_world` zone change (needs a client-reachable IP). Binding to `0.0.0.0` made the server tell the client to connect to `0.0.0.0:<port>`, which is unreachable | Bind all servers to `127.0.0.1` (so the advertised address is reachable) and run a userspace `socat` bridge in `entrypoint.sh` from the container's `eth0` IP → `127.0.0.1` for every zone/service port. No `NET_ADMIN`/sysctls required |

---

## SvrList.dta — reverse-engineered format

Discovered by analyzing `Game.exe` (`loginpage.cpp`, chain-subtract loop at file offset `0x323440`).

```
Bytes 0-3:   00 00 0F 02     header (max name len 15, server count 2)
Bytes 4-18:  metadata        unchanged when patching IP
Byte 10:     key byte        initial cipher key (0x4B in this bundle)
Bytes 19+:   encrypted       "ServerName IP Port" (chain cipher)
```

**Encryption (chain subtract):**

```
plain[0] = cipher[0] - key0
plain[i] = cipher[i] - cipher[i-1]   (mod 256)
key0 = file byte at offset 10
```

**Original plaintext:** `SavageEden 192.168.56.105 4005`  
**Patched plaintext:** `SavageEden 127.0.0.1 4015`

**Patch command:**

```powershell
node D:\Laghaim\tools\svrlist-patch.js 127.0.0.1 4015 SavageEden
```

---

## Client graphics (Windows 10/11)

Errors: `No backbuffer` / `Switching to software rasterizer` → `Init 3d fail`.

**Cause:** Legacy DirectDraw/D3D7 incompatible with modern Windows.

**Fix:** Install [DDrawCompat](https://github.com/narzoul/DDrawCompat/releases) `ddraw.dll` next to `Game.exe`; remove/rename `dbghelp.dll`.

---

## Login flow (working state)

1. `docker compose up -d --build` in `docker/`
2. `SvrList.dta` → `127.0.0.1:4015`
3. `CONFIG.JSON` → `CAPTCHA: false`
4. `game.exe 1` (matches `pack.cfg` = 1)
5. Login `testreg` / `secret`, select char `test`

**Verify server accepts connections:**

```powershell
Test-NetConnection 127.0.0.1 -Port 4015
docker compose logs -f laghaim
# Expect: bnf accepted - ip : 172.18.0.1 (or 127.0.0.1)
```

---

## Useful commands

```powershell
# Docker
cd D:\Laghaim\docker
docker compose ps
docker compose logs -f laghaim
docker compose exec laghaim ps -elf | findstr Connector
docker compose exec mysql mysql -uroot -plaghaimofficial -e "SELECT user_id FROM kor_ndev_neogeo_user.bg_user;"

# Client
cd D:\Laghaim\Laghaim
game.exe 1
Get-Process Game -ErrorAction SilentlyContinue | Stop-Process -Force

# SvrList
node D:\Laghaim\tools\svrlist-patch.js 127.0.0.1 4015 SavageEden
```

---

## Recommended doc reading order

1. [docker/DOCKER.md](docker/DOCKER.md) — run server with Docker  
2. [CLIENT.md](CLIENT.md) — client setup and login  
3. [SETUP.md](SETUP.md) — full manual / VM setup  
4. [tools/README.md](tools/README.md) — `SvrList.dta` patcher  
