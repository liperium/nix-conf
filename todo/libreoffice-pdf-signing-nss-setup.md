# LibreOffice / Okular PDF Signing — NSS Cert Setup

Guideline for porting this into declarative Nix (home-manager). Everything below
was done imperatively on 2026-08-21; nothing here is applied via Nix yet.

Both LibreOffice and Okular sign against the same NSS DB (`~/.pki/nssdb`) —
one cert, no duplication needed.

## What LibreOffice needs

1. `certutil`/`pk12util` available at provisioning time (not needed at runtime).
2. An NSS cert DB (sql format: `cert9.db`, `key4.db`, `pkcs11.txt`) containing a
   cert + private key with `digitalSignature`/`nonRepudiation` usage.
3. `MOZILLA_CERTIFICATE_FOLDER` pointed at that DB directory, exported into
   whatever environment LibreOffice actually launches in (desktop menu vs shell
   are separate environments — both need covering).

## 1. Package

```nix
home.packages = [ pkgs.nss.tools ];
```

Note: the tools (`certutil`, `pk12util`) live in the `tools` output —
`pkgs.nss` alone (the lib/dev output) does **not** provide them.
`nix-shell -p nss` will silently give you a shell without `certutil`;
use `nix-shell -p nss.tools`.

## 2. NSS DB location

`~/.pki/nssdb` — the conventional shared NSS DB path (also used by Chrome).
LibreOffice does not scan this by default; it must be told about it via
`MOZILLA_CERTIFICATE_FOLDER` (step 4).

## 3. Provisioning commands (imperative reference — becomes an activation script)

```bash
NSSDB="$HOME/.pki/nssdb"
mkdir -p "$NSSDB"

# init DB (idempotent — skip if cert9.db already exists)
certutil -N -d sql:"$NSSDB" --empty-password

# generate self-signed signing cert
head -c 1024 /dev/urandom > /tmp/nss-noise.bin
certutil -S -x -n 'PDF Signing' \
  -s 'CN=Mattys Gervais,E=mattysgervais@gmail.com' \
  -t 'C,C,C' -v 120 -k rsa -g 2048 \
  -d sql:"$NSSDB" \
  --keyUsage digitalSignature,nonRepudiation \
  -z /tmp/nss-noise.bin
rm -f /tmp/nss-noise.bin

# verify
certutil -L -d sql:"$NSSDB"
```

`-t 'C,C,C'` marks it trusted-CA for SSL/S-MIME/JAR since it's self-signed with
no external CA to vouch for it. `-v 120` = 10-year validity.

## 4. Environment variable wiring

Desktop-launched apps and shell-launched apps get their environment from
different places — cover both:

**systemd user session (covers desktop-menu launches):**

```nix
xdg.configFile."environment.d/nss-certs.conf".text = ''
  MOZILLA_CERTIFICATE_FOLDER=%h/.pki/nssdb
'';
```

Takes effect on next login (systemd imports `environment.d/*.conf` at session
start — no way to make it apply to an already-running graphical session).

**Shell sessions**, if you also want it in interactive shells immediately:

```nix
home.sessionVariables.MOZILLA_CERTIFICATE_FOLDER = "$HOME/.pki/nssdb";
```

(This user's `.zshrc` is home-manager-managed/read-only — don't hand-edit the
generated symlink, only the source Nix config.)

## 5. Secrets: storing the cert+key in the repo

The NSS DB's `key4.db` holds the private key. Two options for getting it into
a repo as a secret:

**Option A — export to PKCS#12, encrypt that single file (recommended)**

```bash
pk12util -o pdf-signing.p12 -n 'PDF Signing' -d sql:"$HOME/.pki/nssdb"
```

Encrypt `pdf-signing.p12` with sops-nix or agenix, decrypt it during Home
Manager activation, then import on first run:

```bash
# idempotent import in an activation script
certutil -L -d sql:"$NSSDB" -n 'PDF Signing' >/dev/null 2>&1 || \
  pk12util -i /run/secrets/pdf-signing.p12 -d sql:"$NSSDB" -W "$P12_PASSWORD"
```

This is the cleaner path — one portable file, standard format, no raw NSS
internals in the repo.

**Option B — store the raw NSS DB files as secrets**

Encrypt `cert9.db` + `key4.db` directly and place them at `~/.pki/nssdb/` via
activation. Works, but couples you to NSS's on-disk format and to whatever
DB password (or lack thereof) was set when they were generated — more
fragile than option A for no real benefit.

## 6. Okular

Okular (via Poppler/NSS) auto-detects a cert store in this priority order:

1. The current Firefox default profile's NSS store.
2. `/etc/pki/nssdb` (system-wide).
3. `$HOME/.pki/nssdb`.

This machine has Firefox profiles, so Okular would try the Firefox profile
*before* ever reaching `~/.pki/nssdb` — the cert wouldn't show up by default.
Override it explicitly (found via Okular's `pdfsettings.kcfg` schema, group
`Signatures`):

```ini
# ~/.config/okular-generator-popplerrc
[Signatures]
UseDefaultCertDB=false
DBCertificatePath=/home/liperium/.pki/nssdb
```

As home-manager config:

```nix
xdg.configFile."okular-generator-popplerrc".text = ''
  [Signatures]
  UseDefaultCertDB=false
  DBCertificatePath=${config.home.homeDirectory}/.pki/nssdb
'';
```

(Same underlying NSS DB as LibreOffice — no separate cert generation needed
for Okular.)

## Open decision for the nix-conf version

- Pick a PKCS#12 password and where it comes from (sops secret vs prompted).
- `--empty-password` was used above for convenience; decide if the deployed
  DB should have a password (would need `certutil`/LibreOffice to be handed
  it, e.g. via `NSS_DEFAULT_DB_TYPE`/pinfile — adds complexity, skip unless
  the machine's disk isn't already encrypted).
