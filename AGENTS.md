# Laghaim — Agent Runbook (READ THIS FIRST)

You are working on a self-hosted **Laghaim** MMO (legacy Korean game): a **32-bit Linux
ELF server** (`svlaghaim/`) running in **Docker**, plus a **Windows client** (`Laghaim/`),
talking to **MySQL**. The goal that has been achieved and must keep working:

> Log in as **`testreg` / `secret`**, pick character **`test`**, enter the world, and
> travel between zones — with **no "Disconnect from server"** and **no client freeze**.

This file is the distilled, hard-won truth. **Trust it over your instincts** — almost every
"obvious" fix here is wrong and was already tried. When in doubt, read the linked docs and
the source under `Laghaim2018/Server/` before changing anything.

| Doc | What's in it |
|-----|--------------|
| [SETUP.md](SETUP.md) | Full manual (bare-metal + Docker) setup walkthrough |
| [CLIENT.md](CLIENT.md) | Windows client: graphics, `SvrList.dta`, login |
| [docker/DOCKER.md](docker/DOCKER.md) | Docker Compose stack details |
| [CHANGELOG.md](CHANGELOG.md) | Chronological log of every fix and why |
| [tools/README.md](tools/README.md) | `SvrList.dta` patcher + format |

---

## 1. The 60-second mental model

```
Windows Game.exe ──► (login + char select) ──► START zone  :4005  (NOT the connector!)
        │                                          │
        │  zone change ("go_world <ip> <port>")    ▼
        └────────────────────────────────────► other zones :400x
                                                   │
   Messenger :4011  ◄── every zone registers here ─┘   (coordinates zone-to-zone)
   Connector :4015, Helper :4012, PacketSniffing :4018, Battle :4021
                                                   │
                                                   ▼
                                              MySQL :3306
```

Key facts a naive model gets wrong:

- **The client logs in to the START zone `:4005`, not the Connector `:4015`.** The Connector
  speaks an *internal service-registration* protocol (`lh_messenger_service`), not the client
  login protocol. `SvrList.dta` is therefore patched to `127.0.0.1:4005`. Pointing it at
  `:4015` causes a freeze / `BAD VERSION` disconnect. Do not "fix" it back to 4015.
- **`CLIENT_VERSION` for THIS client build is `3004`** (verified from the zone login packet),
  set in `docker/.env`. SETUP.md mentions `3034` generically — ignore that for this bundle.
  If you see MSG 2100 / "client version is different", the value in `.env` is wrong.
- **The Messenger binds `0.0.0.0:4011` itself and ignores `config.json`.** Everything else
  (connector, helper, zones, battle) binds `127.0.0.1` from `config.json`.
- **Zone travel needs a live Messenger.** If the Messenger is down, the client shows
  *"zone cannot be moved, try again in a few minutes"* — that is a **server-side**
  coordination failure, NOT a client or network problem.

---

## 2. Current known-good configuration (do not regress)

| Thing | Value | File |
|-------|-------|------|
| Client login target | `127.0.0.1:4005` (start zone) | `Laghaim/SvrList.dta` (patched) |
| `CLIENT_VERSION` | `3004` | `docker/.env` |
| `GAME_HOST_IP` | `127.0.0.1` (same PC) or Windows LAN IP (remote) | `docker/.env` |
| `LAGHAIM_MODE` | `full` (all 22 zones) or `minimal` (2 zones) | `docker/.env` |
| MySQL password | `laghaimofficial` | `docker/.env` |
| `testreg` password | `PASSWORD('secret')`, `pw_gubun=1`, `chk_service='Y'` | seeded by `docker/mysql-init/01-import.sh` |
| Graphics wrapper | **DDrawCompat** `ddraw.dll`, `config.ini` `Windowed 0` (fullscreen) | `Laghaim/` |

**Networking model inside the container (critical, see §4):** game servers bind `127.0.0.1`
(because a zone's bind IP is *also* the IP it advertises to clients on zone change — so it
must be client-reachable, and `0.0.0.0` is NOT a reachable address). A **socat bridge**
forwards the container's `eth0` IP → `127.0.0.1` for every **loopback-bound** port. The
bridge **must skip `0.0.0.0` services like the Messenger (4011)** or it collides and kills
them. This logic lives in `docker/entrypoint.sh` → `bridge_monitor` / `start_external_bridge`.

---

## 3. Symptom → root cause → fix (the whole history, compressed)

| Symptom | Root cause | Fix |
|---------|-----------|-----|
| `Init 3d fail` / `No backbuffer` | Legacy DirectDraw/D3D7 on modern Windows; `dbghelp.dll` conflicts | Rename `dbghelp.dll`→`.bak`; use **DDrawCompat** `ddraw.dll`; `config.ini` `Windowed 0`. Native windowed mode is **broken** (flip-chain backbuffer in a window) — don't chase it. |
| `BAD VERSION` in connector log, freeze | `SvrList.dta` pointed at Connector `:4015` (wrong protocol) | Patch `SvrList.dta` → `127.0.0.1:4005` via `tools/svrlist-patch.js` |
| "client version is different" (MSG 2100) | `CLIENT_VERSION` mismatch | Set `CLIENT_VERSION=3004` in `docker/.env`, recreate |
| "Disconnect from server" right after login | Servers bound loopback-only; or password hash wrong | See §4 networking; ensure `testreg` = `PASSWORD('secret')`, `pw_gubun=1` |
| Client **freeze** on login click | Connector crash: `undefined symbol: libiconv_open` (a2u cp949→utf-8) | `Dockerfile` compiles a `libiconv.so.2` **shim** over glibc `iconv` exporting the GNU names. Do NOT symlink `libiconv.so.2`→`libiconv_hook`. |
| PacketSniffing crash loop | needs `libexpat.so.0` | `Dockerfile`: `ln -sf libexpat.so.1 libexpat.so.0` |
| **"zone cannot be moved, try again in a few minutes"** | **Messenger dead** — socat bridge grabbed `eth0:4011` before the messenger could bind `0.0.0.0:4011` | Bridge starts **after** servers and only bridges **127.0.0.1-bound** ports (skips 4011). Self-healing `bridge_monitor` in `entrypoint.sh`. |
| Container exits in full mode | `serverrestart.sh` doesn't block | `hold_container()` (`tail -F`) at end of `entrypoint.sh` |
| Empty MySQL tables on restart | volume-mount init flaky on Windows | SQL baked into image via `docker/Dockerfile.mysql` |

---

## 4. The networking trap (the #1 thing not to break)

A Laghaim zone uses **one IP** for two purposes at once:
1. the address it **binds** its listener to, and
2. the address it **hands the client** on zone change (`go_world <ip> <port>`, see
   `Laghaim2018/Server/lh/Server/kor/ndev/Laghaim/World.cpp`).

So the bind IP must be **client-reachable**. `0.0.0.0` is not a reachable address →
clients can't follow a zone change → "cannot move". Therefore:

- Game servers bind **`127.0.0.1`** (reachable from the host via Docker's published-port proxy).
- Docker publishes ports on the container's **external interface (`eth0`)**, not loopback,
  so a userspace **socat** bridge forwards `eth0:<port>` → `127.0.0.1:<port>`.
- The bridge **only** touches ports a server bound to `127.0.0.1`. Ports already on
  `0.0.0.0` (Messenger 4011) are reachable directly and **must be skipped** — bridging them
  causes `bind: Address already in use` and kills the service.

Do **not** "simplify" this by making everything bind `0.0.0.0` — that re-breaks zone travel.
Do **not** reintroduce `iptables`/`NET_ADMIN`/`sysctl route_localnet` — `/proc/sys` is
read-only in the container and that path was abandoned in favor of socat.

---

## 5. Operate the stack

```powershell
cd D:\Laghaim\docker
docker compose build laghaim          # after editing Dockerfile/entrypoint/scripts
docker compose up -d laghaim          # start/recreate
docker compose logs -f laghaim        # watch
docker compose down                   # stop
```

Switch zone scope by editing `docker/.env` (`LAGHAIM_MODE=minimal|full`) then `up -d`.

---

## 6. Verify it's healthy (copy-paste, in order)

```powershell
cd D:\Laghaim\docker

# Messenger MUST be alive and receiving zone registrations (this is what enables zone travel):
docker compose exec -T laghaim tail -5 /opt/laghaim/log/Messenger.log
docker compose exec -T laghaim grep -c "Connect from server_num" /opt/laghaim/log/Messenger.log
# full mode expectation: ~22

# Listeners: server on 127.0.0.1:<port> + socat on <eth0-ip>:<port>; 4011 should be 0.0.0.0 ONLY (no socat)
docker compose exec -T laghaim ss -ltnH | Select-String -Pattern ':4011 ',':4005 ',':4001 ',':4015 '
```

Good output looks like: `0.0.0.0:4011` (messenger, no socat twin), and for 4001/4005/4015
both a `127.0.0.1:<port>` line (server) **and** a `172.x.x.x:<port>` line (socat bridge).

---

## 7. Shell gotchas on this machine (Windows + PowerShell + docker)

- The outer shell is **PowerShell**. Piping into `Select-String`/`Select-Object` is fine.
- **Do NOT put `|` inside a regex passed through `docker compose exec sh -c '...'`** — the
  pipe gets re-interpreted across the PowerShell→docker→sh layers and either runs garbage
  commands or leaves a `grep` **hanging on stdin** (this happened; it had to be killed,
  exit 137). Instead: run a plain command in the container and filter on the host with
  `Select-String -Pattern 'a','b','c'`, or grep a **single** term with no alternation.
- Use `docker compose exec -T` (no TTY) for non-interactive one-shot commands.

---

## 8. Where to look in the source

The decompiled/original server source is under `Laghaim2018/Server/lh/` (and `LH160902/`).
Useful spots already mapped:

- Zone-change logic & the IP advertised to clients: `.../Laghaim/World.cpp`
  (`go_WordlCheckTargetWorld`, `go_WorldCheckNowWorld`, `response_GoWorld`, `m_GoWorld`).
- Client-facing strings: `Laghaim/data/MSG_TABLE.TXT` (e.g. 240 "Moving to another zone").

---

## 9. Golden rules

1. **Reproduce before fixing.** Read the live logs (`Messenger.log`, `Connect_*.log`,
   `laghaim/log/`) and confirm the actual error. Most "obvious" guesses here are wrong.
2. **Change one thing, then verify with §6.** Don't stack speculative changes.
3. **Never regress the networking model in §4** (loopback bind + socat, skip 0.0.0.0 ports).
4. **Keep `SvrList.dta`→`:4005` and `CLIENT_VERSION=3004`.**
5. **Document every fix in [CHANGELOG.md](CHANGELOG.md)** with symptom → cause → fix.
