#!/usr/bin/env bash
# Points robconery.com at GitHub Pages through Cloudflare's API.
#
# Needs a Cloudflare API token with Zone.DNS:Edit on the robconery.com zone:
#   CLOUDFLARE_API_TOKEN=... scripts/dns.sh
#
# Records are created DNS-only (grey cloud) so GitHub can issue and renew the
# TLS certificate itself. Safe to re-run: existing records are updated in place.

set -euo pipefail

ZONE="e5cfc1a1a4f36706a00b20e0125595c9"   # robconery.com
API="https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records"
: "${CLOUDFLARE_API_TOKEN:?set CLOUDFLARE_API_TOKEN}"

auth=(-H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type: application/json")

upsert() { # type name content
  local type="$1" name="$2" content="$3"
  local existing
  existing=$(curl -sS "$API?type=$type&name=$name&content=$content" "${auth[@]}" | python3 -c 'import sys,json; r=json.load(sys.stdin).get("result") or []; print(r[0]["id"] if r else "")')
  local body
  body=$(printf '{"type":"%s","name":"%s","content":"%s","ttl":1,"proxied":false}' "$type" "$name" "$content")
  if [ -n "$existing" ]; then
    curl -sS -X PUT "$API/$existing" "${auth[@]}" --data "$body" | python3 -c 'import sys,json; d=json.load(sys.stdin); print("updated" if d["success"] else d["errors"])'
  else
    curl -sS -X POST "$API" "${auth[@]}" --data "$body" | python3 -c 'import sys,json; d=json.load(sys.stdin); print("created" if d["success"] else d["errors"])'
  fi
}

echo "Apex A records (GitHub Pages)"
for ip in 185.199.108.153 185.199.109.153 185.199.110.153 185.199.111.153; do
  printf '  A    robconery.com -> %s: ' "$ip"; upsert A robconery.com "$ip"
done

echo "Apex AAAA records"
for ip in 2606:50c0:8000::153 2606:50c0:8001::153 2606:50c0:8002::153 2606:50c0:8003::153; do
  printf '  AAAA robconery.com -> %s: ' "$ip"; upsert AAAA robconery.com "$ip"
done

echo "www"
printf '  CNAME www.robconery.com -> robconery.github.io: '; upsert CNAME www.robconery.com robconery.github.io

if [ -n "${GITHUB_PAGES_CHALLENGE:-}" ]; then
  echo "GitHub domain verification"
  printf '  TXT _github-pages-challenge-robconery.robconery.com: '; upsert TXT _github-pages-challenge-robconery.robconery.com "$GITHUB_PAGES_CHALLENGE"
fi

echo
echo "Done. Check with: dig +short robconery.com A; dig +short www.robconery.com CNAME"
