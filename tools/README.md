# Laghaim Tools

## `create-account.ps1` — game account creator

Creates a login account in MySQL (`bg_user`, `t_users`, `bg_user_game`). All three tables
are required — the Connector's auto-insert on first login fails on MySQL 5.7 strict mode
(zero dates like `0000-00-00` in `t_users` defaults).

### Requirements

- Docker stack running (`laghaim-mysql` container up)
- PowerShell 5.1+

### Usage

```powershell
cd D:\Laghaim\tools
.\create-account.ps1 -User myuser -Password mypass
.\create-account.ps1 -User alice -Password secret123 -Email alice@example.com
```

| Parameter | Required | Default |
|-----------|----------|---------|
| `-User` | yes | — |
| `-Password` | yes | 4–20 chars, no `'` |
| `-Email` | no | `{user}@local` |
| `-DockerDir` | no | `..\docker` |

Then log in with Game.exe and create a character in-game. Character creation has a
60-second cooldown between attempts.

---

## `svrlist-patch.js` — SvrList.dta patcher

Patches the encrypted client server list so `Game.exe` connects to your Connector.

### Requirements

- Node.js (v14+)

### Usage

```powershell
node svrlist-patch.js [ip] [port] [name] [inFile] [outFile]
```

| Argument | Default | Example |
|----------|---------|---------|
| ip | `127.0.0.1` | `192.168.1.50` |
| port | `4015` | `4015` |
| name | `SavageEden` | `My Server` |
| inFile | `../Laghaim/SvrList.dta` | |
| outFile | same as inFile | |

**Examples:**

```powershell
cd D:\Laghaim\tools

# Local Docker (default)
node svrlist-patch.js

# LAN server
node svrlist-patch.js 192.168.1.39 4015 SavageEden

# Write to separate file
node svrlist-patch.js 127.0.0.1 4015 SavageEden ..\Laghaim\SvrList.dta ..\Laghaim\SvrList.patched.dta
```

Creates `SvrList.dta.orig` backup on first run (if missing).

---

## SvrList.dta file format

Reverse-engineered from `Game.exe` (June 2026).

### Layout (49 bytes in original bundle)

| Offset | Size | Content |
|--------|------|---------|
| 0 | 2 | `00 00` reserved |
| 2 | 1 | `0x0F` max field length (15) |
| 3 | 1 | `0x02` server count |
| 4 | 15 | metadata (do not change when patching IP) |
| 10 | 1 | **cipher key byte** (`0x4B` in this client) |
| 19 | var | encrypted payload |

### Plaintext format

Single line per server group (this client uses one entry):

```
ServerName IP Port
```

Example: `SavageEden 127.0.0.1 4015`

### Chain subtract cipher

Encryption (used when writing):

```javascript
cipher[0] = (plain[0] + key0) % 256
cipher[i] = (plain[i] + cipher[i-1]) % 256
key0 = byte at file offset 10
```

Decryption (used when reading):

```javascript
plain[0] = (cipher[0] - key0 + 256) % 256
plain[i] = (cipher[i] - cipher[i-1] + 256) % 256
```

### Original vs patched hex

**Original** (decrypts to `SavageEden 192.168.56.105 4005`):

```
00000f02488b3b7800004b3c7800005a7800009eff75d63da2e74bb01e3e6fa8da08396fa7d50a406e9fcf04245888b8ed
```

**Patched** (`SavageEden 127.0.0.1 4015`):

```
00000f02488b3b7800004b3c7800005a7800009eff75d63da2e74bb01e3e6fa1d806366494c2f3134777a8dd
```

File length changes with IP/port string length (44 bytes after patch).

### Related client files

| File | Size | Notes |
|------|------|-------|
| `SvrList.dta` | 44–49 | Primary server list |
| `SvrListM.dta` | 53 | Extended variant |
| `pack.cfg` | 1 byte | Server group selector |

Community tools (not in this repo): LH-DEV Svrlist.dta editor, legacy `ServerList.exe` from Chinese PS packs.

---

## `export-mob-drops.ps1` — mob drop list CSV

Exports current drop data from MySQL (includes active `EXPRATE` / `DROPRATE` multipliers).

```powershell
cd D:\Laghaim\tools
.\export-mob-drops.ps1
```

| Output file | Contents |
|-------------|----------|
| `mob-drop-list.csv` | Per-mob drops (`direct` slots + `group` tables) |
| `zone-drop-list.csv` | Zone-wide drops (roll on any kill in that world) |
| `mob-drop-summary.csv` | All 871 mobs — drop slot counts, spawn flag |

`drop_rate` uses `rate_scale`: `roll_0_10000` (direct) or `roll_0_1000000` (group). Higher = more likely.
Zone columns `a_zone0`..`a_zone25` match in-game world numbers (world 6 = Wolf Wing area, world 22 = Pharos).
