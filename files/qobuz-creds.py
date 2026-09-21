import base64
import re
import urllib.request
from collections import OrderedDict

BASE = "https://play.qobuz.com"
UA = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0 Safari/537.36"

SEED_TZ = re.compile(
    r'[a-z]\.initialSeed\("(?P<seed>[\w=]+)",window\.utimezone\.(?P<timezone>[a-z]+)\)'
)
INFO_EXTRAS = r'name:"\w+/(?P<timezone>{timezones})",info:"(?P<info>[\w=]+)",extras:"(?P<extras>[\w=]+)"'
APP_ID = re.compile(r'production:{api:{appId:"(?P<app_id>\d{9})",appSecret:"\w{32}"')
BUNDLE_URL = re.compile(
    r'<script src="(/resources/\d+\.\d+\.\d+-[a-z]\d{3}/bundle\.js)"></script>'
)


def get(url):
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read().decode("utf-8", "replace")


login = get(f"{BASE}/login")
m = BUNDLE_URL.search(login)
if not m:
    raise SystemExit("bundle.js URL not found - Qobuz changed their page layout")
bundle = get(BASE + m.group(1))

app_id = APP_ID.search(bundle)
if not app_id:
    raise SystemExit("app_id not found - regex is stale")
print(f"App ID: {app_id.group('app_id')}")

secrets = OrderedDict()
for match in SEED_TZ.finditer(bundle):
    seed, tz = match.group("seed", "timezone")
    secrets[tz] = [seed]

pairs = list(secrets.items())
secrets.move_to_end(pairs[1][0], last=False)

rx = INFO_EXTRAS.format(timezones="|".join(tz.capitalize() for tz in secrets))
for match in re.finditer(rx, bundle):
    tz, info, extras = match.group("timezone", "info", "extras")
    secrets[tz.lower()] += [info, extras]

print("\nApp Secret candidates (try in order):")
for i, (tz, parts) in enumerate(secrets.items(), 1):
    try:
        decoded = base64.standard_b64decode("".join(parts)[:-44]).decode("utf-8")
    except Exception as e:
        print(f"  {i}. [{tz}] decode failed: {e}")
        continue
    if len(decoded) == 32:
        print(f"  {i}. {decoded}   ({tz})")
    else:
        print(f"  {i}. {decoded}   ({tz}, unexpected length {len(decoded)})")
