module("luci.controller.extra", package.seeall)


function index()

  local page
  page = entry({"admin", "extra"}, firstchild(), _("Extra"), 60)
  page.dependent = false

  entry({"admin", "extra", "adguardhome"}, call("fAdGuardHome"),            _("AdGuard Home"),            20).leaf = true
  entry({"admin", "extra", "suricata"},    template("extra/suricata"),      _("Suricata"),                20)
  entry({"admin", "extra", "ayuda"},       call("fAbrirWebDeAyuda"),        _("Ayuda"),                   20)
  entry({"admin", "extra", "mapa"},        call("fDispositivosConectados"), _("Dispositivos conectados"), 20).leaf = true

end


function fAdGuardHome()

  luci.http.redirect("http://10.10.0.1:3333")

end


function fAbrirWebDeAyuda()

  luci.http.redirect("extra/ayuda")
  luci.template.render("extra/ayuda")

end

function fMapaDeRed()
end


function fDispositivosConectados()

  local http = require "luci.http"
  local util = require "luci.util"
  local disp = require "luci.dispatcher"

  local vRutaHTML = "/tmp/MapaDeRed.html"
  local vScript   = "/root/scripts/o-scripts/Sistema/Dispositivos-Conectados-PorInterfaz-Informe-EnHTML.sh"

  -- ¿Primera visita? (sin parámetro "job"): lanza el script y redirige a una URL con job
  local job = http.formvalue("job")
  if not job or #job == 0 then
    -- regenerar siempre
    util.exec("rm -f " .. vRutaHTML)
    -- lanzar en background con entorno limpio (BusyBox /bin/sh)
    util.exec("env -i PATH='/usr/sbin:/usr/bin:/sbin:/bin' /bin/sh " .. vScript .. " >/tmp/MapaDeRed.log 2>&1 &")
    -- redirigir a la misma página con un identificador de job para evitar relanzar
    local url = disp.build_url("admin", "extra", "mapa") .. "?job=" .. tostring(os.time())
    http.redirect(url)
    return
  end

  -- Con "job": esperar hasta que exista el HTML y entonces mostrarlo
  local f = io.open(vRutaHTML, "r")
  if f then
    local content = f:read("*a"); f:close()
    if #content > 0 then
      http.prepare_content("text/html")
      http.write(content)
      return
    end
  end

  -- Aún generando: mostrar pantalla de espera y auto-refresh
  http.prepare_content("text/html")
  http.write([[
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Generando mapa de red</title>
      <meta http-equiv="refresh" content="5">
      <style>
        body {
          font-family: sans-serif;
          background: #f8f8f8;
          text-align: center;
          margin-top: 60px;
        }
        .loader {
          border: 8px solid #ddd;
          border-top: 8px solid #333;
          border-radius: 50%;
          width: 60px;
          height: 60px;
          animation: spin 1s linear infinite;
          margin: 20px auto;
        }
        @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }
      </style>
    </head>
    <body>
      <div class="loader"></div>
      <h2>Generando informe de dispositivos conectados</h2>
      <p>Permanezca a la espera. La página se actualizará automáticamente...</p>
    </body>
    </html>
  ]])

end
