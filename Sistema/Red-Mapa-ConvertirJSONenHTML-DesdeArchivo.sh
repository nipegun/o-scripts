#!/bin/sh
# Convierte el JSON agrupado del mapa de red en HTML
# Compatible con BusyBox /bin/sh (OpenWrt)

# Verificar argumento
if [ -z "$1" ]; then
  echo "Uso: $0 archivo.json" >&2
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "Error: '$1' no existe." >&2
  exit 1
fi

vInput="$1"

# Comprobar que parece JSON
grep -q '{' "$vInput" || { echo "Error: entrada sin JSON." >&2; exit 1; }

# Emitir HTML
cat <<'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<title>Dispositivos conectados por interfaz</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; margin: 20px; }
  h2 { margin: 28px 0 10px; font-size: 18px; }
  .ifcard { border: 1px solid #ddd; border-radius: 10px; padding: 14px; box-shadow: 0 1px 3px rgba(0,0,0,.06); }
  table { width: 100%; border-collapse: collapse; font-size: 14px; }
  th, td { padding: 8px 10px; border-bottom: 1px solid #eee; text-align: left; white-space: nowrap; }
  th { background: #f7f7f7; position: sticky; top: 0; }
  .hostname { font-weight: 600; }
  .wrap { white-space: normal; }
  .muted { color: #666; }
</style>
</head>
<body>
<h1>Informe de dispositivos conectados por interfaz</h1>
EOF

# Parseo simple del JSON
awk '
function html_escape(s) {
  gsub(/&/, "&amp;", s)
  gsub(/</, "&lt;", s)
  gsub(/>/, "&gt;", s)
  gsub(/"/, "&quot;", s)
  return s
}
BEGIN { in_group = 0 }

# Detecta inicio de grupo: "interfaz (ip)": [
/^[[:space:]]*".*"[[:space:]]*:[[:space:]]*\[/ {
  if (in_group == 1) {
    print "  </tbody></table></div>"
    in_group = 0
  }
  # Extraer nombre de grupo sin usar escapes
  gsub(/^[[:space:]]*"/, "", $0)
  sub(/"[[:space:]]*:[[:space:]]*\[/, "", $0)
  group = html_escape($0)
  print "<div class=\"ifcard\">"
  print "  <h2>" group "</h2>"
  print "  <table><thead><tr><th>IP</th><th>MAC</th><th>Hostname</th><th>Fabricante</th></tr></thead><tbody>"
  in_group = 1
  next
}

# Detecta objeto con "ip":
/"ip"[[:space:]]*:/ {
  ip=""; mac=""; host=""; vend=""
  if (match($0, /"ip"[[:space:]]*:[[:space:]]*"([^"]*)"/, m))   ip = m[1]
  if (match($0, /"mac"[[:space:]]*:[[:space:]]*"([^"]*)"/, m))  mac = m[1]
  if (match($0, /"hostname"[[:space:]]*:[[:space:]]*"([^"]*)"/, m)) host = m[1]
  if (match($0, /"fabricante"[[:space:]]*:[[:space:]]*"([^"]*)"/, m)) vend = m[1]

  ip=html_escape(ip); mac=html_escape(mac); host=html_escape(host); vend=html_escape(vend)
  if (in_group == 1 && ip != "") {
    printf "    <tr><td>%s</td><td class=\"muted\">%s</td><td class=\"hostname\">%s</td><td class=\"wrap\">%s</td></tr>\n", ip, mac, (host!=""?host:"-"), (vend!=""?vend:"-")
  }
  next
}

# Detecta cierre de grupo
/^[[:space:]]*\][[:space:]]*,?$/ {
  if (in_group == 1) {
    print "  </tbody></table></div>"
    in_group = 0
  }
  next
}

END {
  if (in_group == 1)
    print "  </tbody></table></div>"
  print "</body></html>"
}
' "$vInput"
