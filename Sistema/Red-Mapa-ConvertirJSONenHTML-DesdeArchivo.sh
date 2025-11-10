#!/bin/sh

# Convierte el JSON agrupado del mapa de red en HTML
# Requiere jq (instalado en OpenWrt)

# Verificar argumento
if [ -z "$1" ]; then
  echo "Uso: $0 archivo.json" >&2
  exit 1
fi

vInput="$1"

if [ ! -f "$vInput" ]; then
  echo "Error: '$vInput' no existe." >&2
  exit 1
fi

grep -q '{' "$vInput" || { echo "Error: entrada sin JSON." >&2; exit 1; }

# Emitir cabecera HTML
cat <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<title>Dispositivos conectados por interfaz</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
  body {
    font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    margin: 30px;
    background-color: #f4f6f8;
    color: #333;
  }

  h1 {
    text-align: center;
    margin-bottom: 40px;
    font-size: 24px;
    color: #222;
  }

  h2 {
    margin: 20px 0 15px;
    font-size: 18px;
    text-align: center;
    color: #1a1a1a;
  }

  .ifcard {
    background: #fff;
    border-radius: 12px;
    padding: 20px 25px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    margin: 0 auto 40px;
    max-width: 900px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }

  .ifcard:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 18px rgba(0,0,0,0.12);
  }

  table {
    width: 90%;
    margin: 0 auto;
    border-collapse: collapse;
    font-size: 15px;
    table-layout: fixed;
    border-radius: 8px;
    overflow: hidden;
  }

  thead {
    background: linear-gradient(135deg, #0078d4, #005ea6);
    color: #fff;
  }

  th, td {
    padding: 12px 14px;
    border-bottom: 1px solid #e0e0e0;
    word-wrap: break-word;
  }

  th {
    text-align: center;
    font-weight: 600;
    letter-spacing: 0.5px;
  }

  td {
    text-align: left;
    background-color: #fff;
  }

  /* Anchos específicos por columna */
  th:nth-child(1), td:nth-child(1) { width: 15%; }  /* IP */
  th:nth-child(2), td:nth-child(2) { width: 20%; }  /* MAC */
  th:nth-child(3), td:nth-child(3) { width: 20%; }  /* Hostname */
  th:nth-child(4), td:nth-child(4) { width: 45%; }  /* Fabricante */

  tr:nth-child(even) td {
    background-color: #f9fafb;
  }

  tr:hover td {
    background-color: #eaf4ff;
  }

  .hostname {
    font-weight: 600;
    color: #004c91;
  }

  .wrap {
    white-space: normal;
  }

  .muted {
    color: #666;
    font-size: 0.95em;
  }

  @media (max-width: 700px) {
    table {
      width: 100%;
      font-size: 13px;
    }
    th, td {
      padding: 8px;
    }
    h2 {
      font-size: 16px;
    }
  }
</style>

</head>
<body>
<h1>Informe de dispositivos conectados por interfaz ($(date +"a%Ym%md%dh%Hm%Ms%S"))</h1>
EOF

# Generar HTML agrupado correctamente
jq -r '
  to_entries[]
  | (
      "<div class=\"ifcard\">\n" +
      "  <h2>" + .key + "</h2>\n" +
      "  <table><thead><tr><th>IP</th><th>MAC</th><th>Hostname</th><th>Fabricante</th></tr></thead><tbody>\n" +
      (
        .value
        | map(
            "    <tr><td>" + (.ip // "-") + "</td><td class=\"muted\">" + (.mac // "-") +
            "</td><td class=\"hostname\">" + (.hostname // "-") +
            "</td><td class=\"wrap\">" + (.fabricante // "-") + "</td></tr>\n"
          )
        | join("")
      ) +
      "  </tbody></table></div>\n"
    )
' "$vInput"

# Cierre HTML
cat <<EOF
</body></html>
EOF
