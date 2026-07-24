# claude-code-remote-control-unraid-plugin

🇬🇧 [English](#english) | 🇪🇸 [Español](#español)

---

## English

Fork of [brianpugh/unraid-claude-code](https://github.com/brianpugh/unraid-claude-code), an Unraid
plugin that installs [Claude Code](https://github.com/anthropics/claude-code) CLI — Anthropic's
AI-powered coding assistant — on Unraid, with persistent authentication across reboots.

This fork exists to fix a boot-time reliability bug and to make the Settings page bilingual. All
credit for the original plugin design goes to brianpugh. No license was declared on the original
repository, so this fork is published with clear credit to the original author rather than any
claim of authorship over the base plugin.

### What changed from upstream

- Fixed a bug where the plugin could become permanently disabled after a reboot: the plugin icon
  was fetched over the network via a native `FILE`/`URL` directive processed synchronously during
  Unraid's boot-time plugin install pass — before the author's own network-readiness checks (used
  for the actual Claude install) ever ran. If that single `wget` failed (e.g. network not up yet
  right after a reboot), Unraid aborted the *entire* plugin install and permanently moved the
  `.plg` to `/boot/config/plugins-error`, silently skipping it on every future boot until manually
  reinstalled. The icon is now embedded as inline base64 in the `.plg` itself, removing that
  network dependency entirely.
- Added a bilingual Settings page (Unraid → Settings → Utilities → Claude Code): it shows English
  or Spanish automatically based on Unraid's webGUI language (any `es_*` locale shows Spanish,
  everything else falls back to English) — same approach as this author's
  [unraid-zabbix_agent-6lts](https://github.com/Nebur692/unraid-zabbix_agent-6lts) fork.

### Compatibility

Requires Unraid **6.12.0+** (inherited from upstream). Verified on this fork's own NAS running
**Unraid 7.3.2**. The plugin relies on standard Dynamix webGUI mechanisms (`.page` files,
`/update.php`, `dynamix.cfg`) present throughout the 6.x/7.x line, so it should work on any
reasonably recent install. If you try it on an older or newer release, please open an issue with
the result.

### Installing

Plugin URL (Unraid → Plugins → Install Plugin):

```
https://raw.githubusercontent.com/Nebur692/claude-code-remote-control-unraid-plugin/main/claude-code.plg
```

See the [releases](https://github.com/Nebur692/claude-code-remote-control-unraid-plugin/releases)
page for the full changelog.

### Usage

Open the Unraid terminal and run:

```bash
claude
```

Authentication and settings persist across reboots automatically. Configure the appdata path via
**Settings → Utilities → Claude Code**.

### Troubleshooting

Check the install log:

```bash
cat /var/log/claude-code-install.log
```

Manually re-run the installer:

```bash
/usr/local/emhttp/plugins/claude-code/scripts/install-claude.sh
```

If the plugin ever stops loading after a reboot, check whether it landed in
`/boot/config/plugins-error/claude-code.plg` — if so, reinstall it from **Plugins** in the Unraid
web UI using the install URL above.

---

## Español

Fork de [brianpugh/unraid-claude-code](https://github.com/brianpugh/unraid-claude-code), un plugin
de Unraid que instala la CLI de [Claude Code](https://github.com/anthropics/claude-code) —el
asistente de programación con IA de Anthropic— en Unraid, con autenticación persistente entre
reinicios.

Este fork existe para arreglar un fallo de fiabilidad en el arranque y para hacer bilingüe la
página de configuración. Todo el crédito del diseño original del plugin es de brianpugh. El
repositorio original no declara ninguna licencia, así que este fork se publica dejando el crédito
claro al autor original, sin reclamar autoría del plugin base.

### Qué cambia respecto al original

- Arreglado un bug por el que el plugin podía quedar deshabilitado de forma permanente tras un
  reinicio: el icono del plugin se descargaba por red mediante una directiva nativa `FILE`/`URL`
  procesada de forma síncrona durante el paso de instalación de plugins en el arranque de Unraid
  —antes incluso de que se ejecutaran las propias comprobaciones de red del autor original (usadas
  para instalar Claude). Si ese único `wget` fallaba (por ejemplo, porque la red aún no estaba
  lista justo después de reiniciar), Unraid abortaba la instalación *completa* del plugin y movía
  permanentemente el `.plg` a `/boot/config/plugins-error`, saltándoselo silenciosamente en todos
  los arranques futuros hasta reinstalarlo a mano. Ahora el icono va embebido en base64 dentro del
  propio `.plg`, eliminando por completo esa dependencia de red.
- Añadida una página de Settings bilingüe (Unraid → Settings → Utilities → Claude Code): muestra
  inglés o español automáticamente según el idioma del webGUI de Unraid (cualquier locale `es_*`
  muestra español, el resto cae a inglés) — mismo enfoque que el fork de este mismo autor
  [unraid-zabbix_agent-6lts](https://github.com/Nebur692/unraid-zabbix_agent-6lts).

### Compatibilidad

Requiere Unraid **6.12.0 o superior** (heredado del original). Verificado en el propio NAS de este
fork, con **Unraid 7.3.2**. El plugin depende de mecanismos estándar del webGUI Dynamix (ficheros
`.page`, `/update.php`, `dynamix.cfg`) presentes en toda la línea 6.x/7.x, así que debería funcionar
en cualquier instalación razonablemente reciente. Si lo pruebas en una versión más antigua o más
nueva, abre un issue contando el resultado.

### Instalación

URL del plugin (Unraid → Plugins → Install Plugin):

```
https://raw.githubusercontent.com/Nebur692/claude-code-remote-control-unraid-plugin/main/claude-code.plg
```

Consulta la página de
[releases](https://github.com/Nebur692/claude-code-remote-control-unraid-plugin/releases) para el
changelog completo.

### Uso

Abre la terminal de Unraid y ejecuta:

```bash
claude
```

La autenticación y la configuración persisten automáticamente entre reinicios. Puedes configurar
la ruta de appdata desde **Settings → Utilities → Claude Code**.

### Solución de problemas

Consulta el log de instalación:

```bash
cat /var/log/claude-code-install.log
```

Vuelve a ejecutar el instalador manualmente:

```bash
/usr/local/emhttp/plugins/claude-code/scripts/install-claude.sh
```

Si el plugin deja de cargar tras un reinicio, comprueba si ha acabado en
`/boot/config/plugins-error/claude-code.plg`. Si es así, reinstálalo desde **Plugins** en la
interfaz web de Unraid usando la URL de instalación de arriba.
