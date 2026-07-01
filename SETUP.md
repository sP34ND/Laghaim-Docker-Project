# Laghaim Private Server — Full Stack Setup Guide

> **If you only read one file, read [AGENTS.md](AGENTS.md).** It is the authoritative,
> verified runbook for the **Docker** setup. Where this guide and `AGENTS.md` disagree,
> `AGENTS.md` wins. Notably for the Docker bundle: the client logs in to the **start zone
> `:4005`** (not Connector `:4015`), `CLIENT_VERSION` is **`3004`** (not `3034`), and game
> servers bind **`127.0.0.1`** with a socat bridge (NOT `0.0.0.0`). The generic bare-metal
> instructions below still apply when running directly on a Linux VM.

This guide walks through running the **Linux server** (`svlaghaim`), **MySQL databases** (`sql`), and **Windows client** (`Laghaim`) together on one machine or across a VM network.

**Other docs:**

| Doc | Contents |
|-----|----------|
| [docker/DOCKER.md](docker/DOCKER.md) | Docker Compose server stack |
| [CLIENT.md](CLIENT.md) | Windows client: graphics, `SvrList.dta`, login |
| [CHANGELOG.md](CHANGELOG.md) | Session work log and fixes applied |
| [tools/README.md](tools/README.md) | `SvrList.dta` patcher tool |

> **Docker:** For a containerized server stack, see **[docker/DOCKER.md](docker/DOCKER.md)** (`docker compose up`).

---

## Architecture recap

```
Windows Client (Game.exe)
    │
    ├─► Connector :4015        (login + zone routing)
    │
    └─► Zone server :400x      (one LhDebug process per zone)

Connector / Zones / Messenger / Helper
    └─► MySQL :3306 (5 databases)
```

**Important constraints from this bundle:**

| Item | Value |
|------|-------|
| Server binaries | **32-bit Linux ELF** (not Windows) |
| Client | **Windows** `Game.exe` |
| Server `CLIENT_VERSION` | `3004` in `config.json` (change to `3034`) |
| Client build (in `Game.exe`) | **`3034`** |
| Test account in SQL | `testreg` on channel **660** |
| Test character | `test`, level 6, zone **start** (zone 4) |

---

## Part 1 — Prerequisites

### Hardware / OS

| Component | Recommendation |
|-----------|----------------|
| **Server VM** | Ubuntu **16.04 i386** or **18.04** with `i386` multilib |
| **RAM** | 4 GB minimum (22 zone processes use a lot; start minimal first) |
| **Client PC** | Windows 10/11 |
| **MySQL** | 5.5–5.7 (matches `libmysqlclient.so.16` era) |

### Linux packages (Ubuntu 18.04 example)

```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y gdb mysql-server libmysqlclient20:i386 \
  libgmp10:i386 libiconv-hook1:i386 zlib1g:i386 \
  libstdc++6:i386 libgcc1:i386
```

If `libmysqlclient.so.16` is missing, install MySQL 5.5/5.6 client libs or symlink from an older package. The Connector binary requires:

- `libmysqlclient.so.16`
- `libgmp.so.3`
- `libiconv.so.2`

### Network layout (recommended)

Use a **host-only or bridged VM IP** that the Windows client can reach, e.g. `192.168.56.105` (matches the existing config).

| Machine | IP | Role |
|---------|-----|------|
| Linux VM | `192.168.56.105` | Game server + MySQL |
| Windows host | `192.168.56.1` (typical) | Game client |

---

## Part 2 — MySQL setup

### 2.1 Create databases

The SQL dumps do **not** include `CREATE DATABASE`. Create them first:

```sql
CREATE DATABASE kor_ndev_neogeo_user  CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE kor_ndev_neogeo_char  CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE kor_ndev_neogeo_data  CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE kor_ndev_neogeo_event CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE neogeo_web            CHARACTER SET utf8 COLLATE utf8_general_ci;
```

### 2.2 Import dumps (in order)

On the Linux VM, copy `sql/` and run:

```bash
mysql -u root -p kor_ndev_neogeo_user  < kor_ndev_neogeo_userfinal.sql
mysql -u root -p kor_ndev_neogeo_char  < kor_ndev_neogeo_charfinal.sql
mysql -u root -p kor_ndev_neogeo_data  < kor_ndev_neogeo_datafinal.sql
mysql -u root -p kor_ndev_neogeo_event < kor_ndev_neogeo_eventfinal.sql
mysql -u root -p neogeo_web              < neogeo_webfinal.sql
```

The **data** import is large (~1.7M NPC spawns) and may take several minutes.

### 2.3 Set MySQL credentials

Server configs expect:

- **User:** `root`
- **Password:** `laghaimofficial`

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'laghaimofficial';
FLUSH PRIVILEGES;
```

Or create a dedicated user with full rights on all 5 databases.

### 2.4 Verify seed data

```sql
USE kor_ndev_neogeo_user;
SELECT a_index, a_2p4p_user_id, a_sub_num, a_enable FROM t_users;
-- Expected: user 1 = testreg, channel 660

USE kor_ndev_neogeo_char;
SELECT a_index, a_name, a_level, a_user_index FROM t_characters;
-- Expected: char 1 = test, level 6
```

---

## Part 3 — Server configuration

Copy `svlaghaim` to the Linux VM, e.g. `/home/laghaim/svlaghaim`.

```bash
chmod -R 755 /home/laghaim/svlaghaim
cd /home/laghaim/svlaghaim
```

### 3.1 Edit `config/config.json`

**A. Fix client version** (critical):

```json
"CLIENT_VERSION" : 3034
```

Change `3004` → `3034` to match `Game.exe`.

**B. Set your server IP** — replace every `192.168.56.105` with your VM IP in:

- `ZONE_INFO` → `ZONE_0` and `ZONE_1` (all 50 port entries)
- `PACKETSNIFFING_SERVER` → `IP`
- `BATTLE_ZONE` → `IP`

**C. MySQL** — confirm `MASTER_DB`, `USER_DB`, `CHAR_DB`, `DATA_DB`, `EVENT_DB` blocks point to `127.0.0.1:3306` with your password.

**D. Optional tuning for testing:**

```json
"BILLING_CONNECT" : false,
"EXPRATE" : 25
```

### 3.2 Edit `config/messenger_config.json`

Confirm DB credentials match MySQL:

```json
[999, "127.0.0.1", 3306, "root", "laghaimofficial", "kor_ndev_neogeo_user"],
[1,   "127.0.0.1", 3306, "root", "laghaimofficial", "kor_ndev_neogeo_char"]
```

### 3.3 Edit `config/packet_sniffing.json`

Set your VM IP in `ZONE_IP_LIST`:

```json
"ZONE_IP_LIST" : [["192.168.56.105"]]
```

Add your Windows client IP to `TOOL_IP_LIST` if packet sniffing blocks unknown clients.

### 3.4 Open firewall ports

```bash
# Connector (login)
sudo ufw allow 4015/tcp

# Zone servers channel 0 (all zones)
sudo ufw allow 4001:4036/tcp

# Optional: channel 1
sudo ufw allow 5001:5036/tcp
```

MySQL (`3306`) should stay **localhost-only**.

---

## Part 4 — Start the server

### 4.1 Full stack (all 22 zones)

```bash
cd /home/laghaim/svlaghaim
./serverrestart.sh
```

This runs, in order:

1. `kill.sh` — stops existing processes
2. `messenger/start.sh`
3. `connector/start.sh 692 1 1 1`
4. `helper/start.sh 612 1 1 1`
5. `laghaim/ch0_start.sh` — **22 zone processes**
6. `packetsniffing/start.sh`

### 4.2 Minimal test stack (recommended first)

Start only core services + 1–2 zones to save RAM:

```bash
cd /home/laghaim/svlaghaim
./kill.sh && sleep 3

cd messenger && ./start.sh && cd ..
cd connector && ./start.sh 692 1 1 1 && cd ..
cd helper && ./start.sh 612 1 1 1 && cd ..

# Zone 0 = decard (starter town), Zone 4 = start (where test char lives)
cd laghaim
nohup ./shutdownmonitoring.sh 1 0 660 decard_ch0 > /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh 1 4 660 start_ch0   > /dev/null 2>&1 &
cd ..
```

### 4.3 Verify processes

```bash
ps aux | grep -E 'Connector|Messenger|Helper|LhDebug|PacketSniffing'
```

```bash
ss -tlnp | grep -E '4015|4001|4005'
# 4015 = Connector, 4001 = decard, 4005 = start
```

### 4.4 Check logs if something fails

| Log | Location |
|-----|----------|
| Connector restarts | `connector/rebootlog.txt` |
| Zone crashes | `laghaim/log/bt_{zoneId}_*.log` |
| Zone reboot history | `laghaim/rebootlog` |
| GDB backtraces | `laghaim/log/bt_*.log` |

**Note:** `LhDebug` always launches under **GDB**. If `gdb` is missing, zones will not start.

### 4.5 Stop the server

```bash
cd /home/laghaim/svlaghaim
./kill.sh
```

Graceful zone shutdown: create `laghaim/.shutdown` (watchdog exits).

---

## Part 5 — Client configuration (Windows)

Client path: `Laghaim/`

### 5.1 Fix version mismatch

Server `CLIENT_VERSION` must be **`3034`** (see Part 3.1).

If login shows *"The client version is different"* (MSG 2100), the versions still do not match.

### 5.2 Point client at your server — `SvrList.dta`

`SvrList.dta` is an **encrypted binary** server list. The client reads it at login to find the Connector IP/port.

**Recommended — use the included patcher:**

```powershell
node D:\Laghaim\tools\svrlist-patch.js 127.0.0.1 4015 SavageEden
```

This bundle is already patched for local Docker (`127.0.0.1:4015`). Backup: `SvrList.dta.orig`.

Format and encryption details: [tools/README.md](tools/README.md). Full client guide: [CLIENT.md](CLIENT.md).

**Other options:**

1. Copy a patched `SvrList.dta` from a private-server build matching client **3034**
2. Community tools (LH-DEV Svrlist.dta editor, legacy `ServerList.exe`)

Without a valid `SvrList.dta`, the client cannot reach your Connector even if the server is running.

`Game.exe` also references `SvrListM.dta` (53-byte variant) and `config.ini2` (not present).

### 5.3 Disable CAPTCHA for testing

Edit `Laghaim/data/CONFIG.JSON`:

```json
"CAPTCHA" : false,
"LOGIN_PROCESS" : true
```

### 5.4 Graphics / DirectDraw (Windows 10/11)

Laghaim uses legacy **DirectDraw / Direct3D 7**. On modern Windows you may see:

- `No backbuffer` → `Switching to software rasterizer`
- `Init 3d fail`

These are **graphics compatibility** errors, not server/login issues.

**Fix (in order):**

1. **Remove `dbghelp.dll` from the client folder** (conflicts with compatibility wrappers).  
   Already renamed to `dbghelp.dll.bak` in this bundle if you followed setup.

2. **Install [DDrawCompat](https://github.com/narzoul/DDrawCompat/releases)** — download `DDrawCompat-v0.7.1.zip`, extract **`ddraw.dll`** into `D:\Laghaim\Laghaim\` next to `Game.exe`.

3. **`config.ini`** — try fullscreen first (often more reliable):

```ini
Windowed 0
Resolution 1
```

   For windowed mode later, set `Windowed 1`. Delete `config.ini` to reset defaults.

4. **Windows compatibility** (right-click `Game.exe` → Properties → Compatibility):

   - Run as administrator (optional)
   - Disable fullscreen optimizations
   - Reduced color mode: 16-bit (65536 colors) — if still failing

5. **Retry launch** — the game may need several attempts on first run.

If UI glitches with DDrawCompat on AMD integrated graphics, try an older build (v0.3.1) from the same releases page.

### 5.5 Launch

```bat
cd D:\Laghaim\Laghaim
game.exe 1
```

Or use `Launch Game.bat` (`game.exe 1`). Argument `1` matches `pack.cfg` and server group `SERVER_GROUP_NO: 1`.

### 5.6 Test login credentials

| Field | Value |
|-------|-------|
| Username | `testreg` |
| Password | Try `secret` (MySQL hash in dump matches this) |

If login fails, reset in MySQL:

```sql
UPDATE bg_user SET passwd = PASSWORD('test123') WHERE user_id = 'testreg';
```

Then use `test123` in the client.

### 5.7 Register a new account

There is **no in-game registration** on this private server. Create accounts in MySQL:

```powershell
cd D:\Laghaim\tools
.\create-account.ps1 -User myuser -Password mypass
```

Requires `laghaim-mysql` running (`docker compose up -d` in `docker/`). On first login
the Connector auto-creates `t_users` and `bg_user_game`; then create a character in-game.
Details: [tools/README.md](tools/README.md).

Existing character: **`test`** (Bulkan, level 6, in **start** zone / world 660).

---

## Part 6 — End-to-end verification checklist

| Step | Check | Pass? |
|------|-------|-------|
| 1 | MySQL: 5 DBs imported, `t_users` has `testreg` | ☐ |
| 2 | `config.json`: `CLIENT_VERSION` = `3034`, zone IPs = VM IP | ☐ |
| 3 | Linux: `Connector` listening on `:4015` | ☐ |
| 4 | Linux: at least one `LhDebug` on `:4005` (start zone) | ☐ |
| 5 | Windows: can `ping VM_IP` | ☐ |
| 6 | Windows: `telnet VM_IP 4015` connects | ☐ |
| 7 | Client: patched `SvrList.dta` | ☐ |
| 8 | Client: login with `testreg` | ☐ |
| 9 | Character select: `test` appears | ☐ |
| 10 | Enter world without disconnect | ☐ |

---

## Part 7 — Channel 1 (optional)

Channel 1 uses world **661** and ports **5001–5036**:

```bash
cd /home/laghaim/svlaghaim/laghaim
./ch1_start.sh
```

Players need `a_sub_num = 661` in `t_users` for channel 1.

---

## Part 8 — Troubleshooting

### "Client version is different"

- Set `CLIENT_VERSION` to `3034` in `config/config.json`
- Restart Connector after config change

### Client cannot connect / hangs at login

- `SvrList.dta` not pointing to your VM IP
- Firewall blocking `4015` or zone ports `4001–4036`
- Connector not running — check `connector/rebootlog.txt`

### Login works but disconnect on enter world

- Zone process for that map not running (e.g. need zone 4 `start` for char `test`)
- Zone IP in `ZONE_INFO` wrong — client gets bad IP from Connector
- **Docker:** servers bind `127.0.0.1` and a **socat bridge** forwards `eth0`→`127.0.0.1`
  for loopback-bound ports (see [AGENTS.md](AGENTS.md) §4). Do NOT make them bind `0.0.0.0`
  — that breaks zone travel, because the bind IP is also advertised to clients on zone change.
- `PACKETSNIFFING` blocking client IP — add your IP to `TOOL_IP_LIST` in `packet_sniffing.json`

### "Disconnect from server" / freeze / "zone cannot be moved" (Docker)

The full networking and login chain (loopback bind + socat bridge, `SvrList.dta`→`:4005`,
`CLIENT_VERSION=3004`, `libiconv` shim, live Messenger for zone travel) is documented
authoritatively in **[AGENTS.md](AGENTS.md)** with a symptom→fix table. See also
[CLIENT.md](CLIENT.md) and [CHANGELOG.md](CHANGELOG.md).

### Zone keeps restarting

- Check `laghaim/log/bt_*.log` for GDB backtrace
- Usually missing `.so` library or MySQL connection failure
- Run manually: `cd laghaim && gdb --batch --command=cmd --args ./LhDebug 1 4 660 start_ch0`

### `libmysqlclient.so.16: cannot open shared object`

- Install 32-bit MySQL 5.5/5.6 client libraries
- Or copy `.so` from an old Linux install into `/lib/i386-linux-gnu/`

### MySQL connection errors in logs

- Verify password `laghaimofficial` everywhere
- Confirm all 5 databases exist and are imported
- Check `messenger_config.json` DB_LIST entries

### Character creation blocked

- `char_create_limit.json`: 60-second cooldown between creates
- New users need rows in `bg_user` + `bg_user_game` + `t_users`

### High memory usage

- Do not run all 22 zones until confirmed working
- Use minimal stack (Part 4.2) with 2 zones only

---

## Quick reference — ports & paths

| Service | Port | Config key |
|---------|------|------------|
| Connector | **4015** | `CONNECTOR_SERVER` |
| Messenger | 4011 | `MESSENGER_SERVER` |
| Helper | 4012 | `HELPER_SERVER` |
| Packet sniffing | 4018 | `PACKETSNIFFING_SERVER` |
| Battle zone | 4021 | `BATTLE_ZONE` |
| Zones ch0 | 4001–4036 | `ZONE_INFO.ZONE_0` |
| Zones ch1 | 5001–5036 | `ZONE_INFO.ZONE_1` |
| MySQL | 3306 | `*_DB` blocks |

| Path | Purpose |
|------|---------|
| `svlaghaim/` | Linux server bundle |
| `sql/` | Database dumps |
| `Laghaim/` | Windows client |

---

## Zone ID reference

| ID | Server name | Client zone | Port (ch0) |
|----|-------------|-------------|------------|
| 0 | decard | 로스트렐름 (Neogeo) | 4001 |
| 1 | dekarendungeon | 데카렌 | 4030 |
| 2 | quest | 데카둔 | 4003 |
| 3 | guild | 화이트혼 (base) | 4004 |
| 4 | start | 라그라미아 | 4005 |
| 5 | roost | 시루스트 | 4006 |
| 6 | sky | 천공의성 | 4007 |
| 7 | whitehorn | 화이트혼 | 4008 |
| 8 | white_dungeon | 제누스레버너티 | 4009 |
| 9 | dmitron | 드미트론 | 4010 |
| 11 | battle | 길드배틀 | 4022 |
| 12 | occp | 드미트론 점령전 | 4032 |
| 13–18 | boss_* | Race boss zones | 4023–4028 |
| 20 | disposal_plant | 펄론루인 | 4034 |
| 22–24 | forlorn_zone* | Forlorn zones | 4022, 4035, 4036 |

---

## Recommended first-time order

1. Set up Linux VM + MySQL → import SQL
2. Edit `config.json` (version `3034`, your IP)
3. Start **Connector + Messenger + Helper + 2 zones** only
4. Patch `SvrList.dta` → point at VM `:4015`
5. Disable client CAPTCHA
6. Login as `testreg`, select `test`
7. Once stable, run full `serverrestart.sh`
