# Laghaim Windows Client Guide

Server must be running first — see [docker/DOCKER.md](docker/DOCKER.md) or [SETUP.md](SETUP.md).

---

## Quick login

| Step | Action |
|------|--------|
| 1 | Start Docker: `cd docker && docker compose up -d` |
| 2 | Launch: `game.exe 1` or `Launch Game.bat` |
| 3 | Username | `testreg` |
| 4 | Password | `secret` |
| 5 | Character | `test` |

---

## Server list — `SvrList.dta`

The client reads encrypted **`SvrList.dta`** at login for Connector IP/port.

**Current patch (local Docker):**

```
SavageEden 127.0.0.1 4015
```

**Backup:** `SvrList.dta.orig`

### Patch with included tool

Requires [Node.js](https://nodejs.org/) on Windows:

```powershell
node D:\Laghaim\tools\svrlist-patch.js [ip] [port] [name]

# Examples
node D:\Laghaim\tools\svrlist-patch.js
node D:\Laghaim\tools\svrlist-patch.js 192.168.1.50 4015 SavageEden
```

Restore original:

```powershell
copy D:\Laghaim\Laghaim\SvrList.dta.orig D:\Laghaim\Laghaim\SvrList.dta
```

See [tools/README.md](tools/README.md) for file format details.

### Related files

| File | Notes |
|------|-------|
| `SvrListM.dta` | 53-byte variant (not required for basic login) |
| `pack.cfg` | `1` — must match `game.exe 1` and server `SERVER_GROUP_NO` |
| `data/MAT_SVR.TXT` | Display names only (not connection IP) |

---

## Client config — `data/CONFIG.JSON`

For local testing:

```json
"CAPTCHA" : false,
"LOGIN_PROCESS" : true
```

Already set in this bundle.

---

## Windowed / fullscreen — `config.ini`

| Setting | Value | Effect |
|---------|-------|--------|
| `Windowed 1` | Window mode | Current setting |
| `Windowed 0` | Fullscreen | Often more stable with DDrawCompat |
| `Resolution 1` | Resolution preset | Safe default |

Delete `config.ini` to reset to game defaults.

---

## Graphics — DirectDraw (Windows 10/11)

### Symptoms

1. `No backbuffer` → `Switching to software rasterizer`
2. `Init 3d fail`

These are **not** server errors.

### Fix checklist

1. **Rename `dbghelp.dll`** → `dbghelp.dll.bak` (already done in this bundle)
2. **Install DDrawCompat** — extract `ddraw.dll` into the client folder next to `Game.exe`  
   - Run `Install DDrawCompat.bat`, or  
   - Download [DDrawCompat v0.7.1](https://github.com/narzoul/DDrawCompat/releases/download/v0.7.1/DDrawCompat-v0.7.1.zip)
3. **Compatibility** (right-click `Game.exe` → Properties → Compatibility):
   - Disable fullscreen optimizations
   - Optional: 16-bit color mode
4. Retry launch — first run may need several attempts

### AMD integrated GPU UI glitches

Try DDrawCompat **v0.3.1** instead of latest.

---

## Launch

```bat
cd D:\Laghaim\Laghaim
game.exe 1
```

Argument `1` matches `pack.cfg` and server group 1.

**Kill stuck client:**

```powershell
Get-Process -Name Game -ErrorAction SilentlyContinue | Stop-Process -Force
```

Or use `kill Game.bat`.

---

## Login errors

### "Disconnect from server" after login

| Cause | Fix |
|-------|-----|
| Docker: server bound `127.0.0.1` only inside container | Rebuild server image (`docker compose up --build`) — fixed in `entrypoint.sh` with `BIND_IP=0.0.0.0` |
| Wrong `SvrList.dta` IP/port | Re-patch with `svrlist-patch.js` |
| Server not running | `docker compose ps` |
| Version mismatch | Server `CLIENT_VERSION` must be **3034** |
| Wrong password | Use `testreg` / `secret` |

**Test connectivity:**

```powershell
Test-NetConnection 127.0.0.1 -Port 4015
Test-NetConnection 127.0.0.1 -Port 4005
```

**Watch login on server:**

```powershell
cd D:\Laghaim\docker
docker compose logs -f laghaim
```

You should see `bnf accepted` when the client connects.

### "The client version is different"

Server `CLIENT_VERSION` in `config.json` must be **3034** (Docker `.env` sets this automatically).

### CAPTCHA / login blocked

Set `"CAPTCHA" : false` in `data/CONFIG.JSON`.

### Password reset (MySQL)

```sql
UPDATE kor_ndev_neogeo_user.bg_user
SET passwd = PASSWORD('test123')
WHERE user_id = 'testreg';
```

---

## Test account reference

| Field | Value |
|-------|-------|
| Login | `testreg` |
| Password | `secret` |
| Channel | 660 (`a_sub_num` in `t_users`) |
| Character | `test` |
| Level | 6 |
| Zone | **start** (zone ID 4, port **4005**) |

Minimal Docker mode runs zones **0** (decard, `:4001`) and **4** (start, `:4005`).

---

## Compatible Client

Download [LaghaimClient](https://drive.google.com/file/d/1iTF5GZSP1eJqf0WjNdcJbssZ_HQ6ovWr/view?usp=sharing)

## See also

- [CHANGELOG.md](CHANGELOG.md) — full session work log  
- [SETUP.md](SETUP.md) — complete stack guide  
- [docker/DOCKER.md](docker/DOCKER.md) — Docker server  
