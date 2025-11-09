module("luci.controller.extra", package.seeall)

function index()
  entry({"admin", "extra"},             template(""),               _("Extra"),  90)
  entry({"admin", "extra", "suricata"}, template("extra/suricata"), _("Suricata"), 80)
  entry({"admin", "extra", "ayuda"},    call("fAbrirWebDeAyuda"),   _("Ayuda"),    90)
end

function fAbrirWebDeAyuda()
  luci.http.redirect("extra/ayuda")
  luci.template.render("extra/ayuda")
end
