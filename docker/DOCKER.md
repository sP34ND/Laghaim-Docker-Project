# Laghaim Docker Setup

Run the **MySQL databases** and **Linux game server** with Docker Compose. The Windows client (`Laghaim/`) still runs on your host — only the server side is containerized.

**See also:** [CLIENT.md](../CLIENT.md) (client login/graphics), [CHANGELOG.md](../CHANGELOG.md) (fixes applied), [tools/README.md](../tools/README.md) (`SvrList.dta` patcher).

## Requirements

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows) with **Linux containers**
- Enable **386 emulation** if prompted (game binaries are 32-bit; image uses `i386/debian:bookworm`)
- ~6 GB free disk (MySQL data import is large)
- ~2 GB RAM for `minimal` mode, ~4 GB+ for `full` mode

First MySQL start imports all SQL dumps and can take **10–30 minutes**.

## Quick start

```powershell
cd D:\Laghaim\docker
copy .env.example .env
# Edit .env — set GAME_HOST_IP if client is not on the same machine

docker compose up --build
```

Wait until you see:

```
laghaim-server  | ==> Minimal stack running. Connector :4015, zones decard :4001, start :4005
```

## Services

| Container | Image | Purpose |
|-----------|-------|---------|
| `laghaim-mysql` | `mysql:5.7` | 5 game databases + seed data |
| `laghaim-server` | built from `docker/Dockerfile` | Connector, Messenger, Helper, zones |

## Configuration (`.env`)

| Variable | Default | Description |
|----------|---------|-------------|
| `GAME_HOST_IP` | `127.0.0.1` | IP clients use for zone connections (in `ZONE_INFO`) |
| `BIND_IP` | `0.0.0.0` | IP game servers **listen** on inside the container (do not change unless you know why) |
| `MYSQL_ROOT_PASSWORD` | `laghaimofficial` | DB password (patched into server configs) |
| `LAGHAIM_MODE` | `minimal` | `minimal` or `full` |
| `CLIENT_VERSION` | `3034` | Must match `Game.exe` |
| `MYSQL_PUBLISH_PORT` | `3307` | Host port for MySQL (optional debug access) |

### `GAME_HOST_IP` guide

| Scenario | Value |
|----------|-------|
| Client on same PC as Docker | `127.0.0.1` |
| Client on another PC on LAN | Windows host LAN IP (e.g. `192.168.1.50`) |

Use `ipconfig` on Windows to find your IPv4 address.

## Client setup

1. Patch `Laghaim\SvrList.dta` — use `node tools\svrlist-patch.js 127.0.0.1 4015 SavageEden` (already done in this bundle)
2. Set `Laghaim\data\CONFIG.JSON` → `"CAPTCHA" : false`
3. Graphics: install `ddraw.dll` (DDrawCompat) — see [CLIENT.md](../CLIENT.md)
4. Launch `game.exe 1`
5. Login: `testreg` / `secret` (or reset password via MySQL)

See [CLIENT.md](../CLIENT.md) for graphics, windowed mode, and disconnect troubleshooting.

## Commands

```powershell
# Start in background
docker compose up -d --build

# View logs
docker compose logs -f laghaim

# Stop
docker compose down

# Stop and wipe database (re-import on next up)
docker compose down -v

# Shell into game server
docker compose exec laghaim bash

# Check processes inside container
docker compose exec laghaim ps aux | grep -E 'Connector|LhDebug|Messenger'
```

## Modes

### `minimal` (default)

- Connector, Messenger, Helper, PacketSniffing (when `libexpat` available)
- Zones **0** (decard) and **4** (start) only
- Enough for test character `test` to log in

### `full`

Set in `.env`:

```env
LAGHAIM_MODE=full
LAGHAIM_MEMORY_LIMIT=6g
```

Starts all 22 channel-0 zones via `serverrestart.sh` plus PacketSniffing.

## Published ports

| Port(s) | Service |
|---------|---------|
| 4015 | Connector (login) |
| 4001–4036 | Channel 0 zone servers |
| 5001–5036 | Channel 1 zone servers (`full` mode) |
| 4011 | Messenger |
| 4012 | Helper |
| 3307 | MySQL on host (default) |

## Troubleshooting

### First start is very slow

MySQL is importing ~1.7M NPC rows. Watch progress:

```powershell
docker compose logs -f mysql
```

### `platform linux/386` / exec format errors

On Apple Silicon or some hosts, install QEMU:

```powershell
docker run --privileged --rm tonistiigi/binfmt --install all
```

Then rebuild:

```powershell
docker compose build --no-cache
```

### Game server exits / zones restart loop

```powershell
docker compose logs laghaim
docker compose exec laghaim cat laghaim/log/bt_4_*.log
```

Common causes:

1. **Empty MySQL tables** — databases exist but import never ran. Reset and re-import:

```powershell
docker compose down -v
docker compose up --build
```

Wait until MySQL logs show all 5 dumps imported before expecting zones to stay up.

2. **Missing libraries** — `libmysqlclient_16` (fixed in current game image)

3. **Missing `procps`** — watchdog needs `/bin/ps` (fixed in current `Dockerfile`)

4. **Missing log dirs** — `LogFiles/` and `log/` are created by entrypoint

### Client connects but disconnects after login

**Symptom:** Client shows *"Disconnect from server"* right after entering username/password.

**Cause (Docker):** Game servers bound to `127.0.0.1` inside the container. Docker port-forwarding delivers connections from `172.18.0.1` (host gateway), which never reached the Connector.

**Fix:** `entrypoint.sh` sets `BIND_IP=0.0.0.0` so Connector and zones listen on all interfaces. Rebuild and restart:

```powershell
docker compose up -d --build laghaim
```

**Verify** (while launching client):

```powershell
docker compose logs -f laghaim
# Expect: bnf accepted - ip : 172.18.0.1
```

Also check:

- `SvrList.dta` points to `127.0.0.1:4015` (`node tools\svrlist-patch.js`)
- `Test-NetConnection 127.0.0.1 -Port 4015` → `True`
- `CLIENT_VERSION=3034` in `.env`
- Character `test` is in zone **start** (port 4005) — included in `minimal` mode

### Client disconnects when entering world

- Confirm `GAME_HOST_IP` is reachable from Windows
- Test zone port: `Test-NetConnection 127.0.0.1 -Port 4005`
- Ensure `LAGHAIM_MODE=minimal` includes zone 4 (`start`)

### Reset everything

```powershell
docker compose down -v
docker compose up --build
```

## File layout

```
docker/
  Dockerfile           # 32-bit Debian + game server binaries
  Dockerfile.mysql     # MySQL 5.7 + baked-in SQL import scripts
  docker-compose.yml
  entrypoint.sh        # Wait for MySQL, patch configs, BIND_IP=0.0.0.0, start server
  start-minimal.sh     # Connector + Messenger + Helper + PacketSniffing + 2 zones
  mysql-init/          # DB creation + import scripts
  .env.example
  DOCKER.md            # This file
```

## Architecture

```
Windows (Game.exe)
    │  :4015, :400x
    ▼
┌─────────────────────────────────┐
│  laghaim-server (linux/386)   │
│  Connector / Messenger / Helper │
│  LhDebug zone processes         │
└──────────────┬──────────────────┘
               │ mysql:3306
               ▼
┌─────────────────────────────────┐
│  laghaim-mysql (mysql:5.7)      │
│  kor_ndev_neogeo_* + neogeo_web │
└─────────────────────────────────┘
```
