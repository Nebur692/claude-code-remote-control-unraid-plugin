<div align="center">

# claude-code-remote-control-unraid-plugin

*Claude Code CLI on Unraid, plus drive a session from your phone — no inbound ports, ever*

![Release](https://img.shields.io/github/v/release/Nebur692/claude-code-remote-control-unraid-plugin?label=release&color=blue)
[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/nebur69265723)

🇬🇧 [English](#english) · 🇪🇸 [Español](#español)

</div>

---

## English

Fork of [brianpugh/unraid-claude-code](https://github.com/brianpugh/unraid-claude-code), an Unraid
plugin that installs [Claude Code](https://github.com/anthropics/claude-code) CLI — Anthropic's
AI-powered coding assistant — on Unraid, with persistent authentication across reboots.

This fork exists to fix a boot-time reliability bug and to make the Settings page bilingual. All
credit for the original plugin design goes to brianpugh. No license was declared on the original
repository, so this fork is published with clear credit to the original author rather than any
claim of authorship over the base plugin.

### ✨ What's new

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
- Fixed the icon shown on the Plugins tab: Unraid's `ShowPlugins.php` never treats `icon=` as a
  URL — it only ever looks for a local file named `plugins/<name>/images/<name>.png`. Upstream's
  remote `icon=` URL therefore always fell through to a generic fallback icon. Removed `icon=` and
  moved the bundled PNG to that exact convention path, so it's now picked up automatically.
- Clicking the plugin's row on the Plugins tab now jumps straight to its Settings page (added
  `launch="Settings/claude-code"`), same as the `unraid-zabbix_agent-6lts` fork.
- Settings page restyled to match `unraid-zabbix_agent-6lts`'s look (bordered sections, a compact
  status bar, inline help notes) instead of the original ad-hoc table/div layout.
- The Plugins tab now shows "Claude Code Remote Control" with a real bilingual description
  instead of the bare word `claude-code` — Unraid renders `plugins/claude-code/README.md` as that
  description, so this fork ships one (separate from this top-level README).
- Added a "Logs" section to the Settings page with a "View live logs" link that streams
  `/var/log/claude-code-install.log` in real time via Unraid's native `openTerminal()` mechanism
  (same one Docker/VMs/NUT use) — no extra scripts needed.
- Fixed that live-log link never showing up in practice: it was hidden until the log file
  existed, which only ever happened on an actual Unraid reboot. Now always shown.
- Added a real "Update Claude Code" action. The original "Reinstall" button is a no-op once
  Claude Code already works, so there was no way to fetch a newer release from the plugin at
  all. The new button runs the CLI's own `claude update` and re-caches the result into
  `APPDATA_PATH`, since the next boot would otherwise silently restore the old cached binary
  over any update. Reinstall and Update now both log to the file the "View live logs" link
  follows.
- **Remote Control**: a new Settings section runs [`claude remote-control`](https://code.claude.com/docs/en/remote-control)
  as a supervised background process, so you can drive a Claude Code session on this NAS from
  claude.ai/code or the Claude mobile app — outbound HTTPS only, nothing opened inbound. It
  always resumes the same ongoing session in its configured directory (`--continue`), falling
  back to a fresh one only the first time, and only ever starts when you click Start — never
  automatically at boot. Requires a claude.ai OAuth login (Pro/Max/Team/Enterprise); API key
  auth isn't supported by this Anthropic feature. Defaults to a dedicated
  `/root/claude-remote-control` directory rather than `/root` itself, since Unraid never
  persists workspace trust for a home directory. Includes session history, reconnect-to-any-past
  session, and auto-recovery if a session gets archived on the claude.ai side.

### ✅ Compatibility

Requires Unraid **6.12.0+** (inherited from upstream). Verified on this fork's own NAS running
**Unraid 7.3.2**. The plugin relies on standard Dynamix webGUI mechanisms (`.page` files,
`/update.php`, `dynamix.cfg`) present throughout the 6.x/7.x line, so it should work on any
reasonably recent install. If you try it on an older or newer release, please open an issue with
the result.

### 📦 Installation

Plugin URL (Unraid → Plugins → Install Plugin):

```
https://raw.githubusercontent.com/Nebur692/claude-code-remote-control-unraid-plugin/main/claude-code.plg
```

See the [releases](https://github.com/Nebur692/claude-code-remote-control-unraid-plugin/releases)
page for the full changelog.

### 🧭 Usage

Open the Unraid terminal and run:

```bash
claude
```

Authentication and settings persist across reboots automatically. Configure the appdata path via
**Settings → Utilities → Claude Code**.

### 🩹 Troubleshooting

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

### 💙 Support

None of this would be possible without the community's support. If this project has been useful to you,
consider [supporting it on Ko-fi](https://ko-fi.com/nebur69265723) — every bit helps keep it maintained.

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

### ✨ Novedades

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
- Arreglado el icono que se veía en la pestaña Plugins: `ShowPlugins.php` de Unraid nunca trata
  `icon=` como una URL — solo busca un fichero local llamado `plugins/<name>/images/<name>.png`.
  Por eso la URL remota del `icon=` original siempre caía en un icono genérico. Se quitó `icon=` y
  se movió el PNG a esa ruta exacta, así que ahora se detecta automáticamente.
- Al hacer clic en la fila del plugin en la pestaña Plugins, ahora lleva directamente a su página
  de Settings (añadido `launch="Settings/claude-code"`), igual que el fork
  `unraid-zabbix_agent-6lts`.
- Rediseñada la página de Settings para seguir el estilo de `unraid-zabbix_agent-6lts` (secciones
  con borde, una barra de estado compacta, notas de ayuda en línea) en vez del layout original de
  tabla/div improvisado.
- La pestaña Plugins ahora muestra "Claude Code Remote Control" con una descripción bilingüe real
  en vez de la palabra pelada `claude-code` — Unraid renderiza `plugins/claude-code/README.md`
  como esa descripción, así que este fork incluye uno (separado de este README principal).
- Añadida una sección "Logs" en la página de Settings con un enlace "Ver logs en vivo" que sigue
  en tiempo real `/var/log/claude-code-install.log` usando el mecanismo nativo `openTerminal()` de
  Unraid (el mismo que usan Docker/VMs/NUT) — sin necesidad de scripts extra.
- Arreglado que ese enlace de log en vivo nunca aparecía en la práctica: estaba oculto hasta que
  existía el fichero de log, y eso solo pasaba tras un reinicio real de Unraid. Ahora siempre se
  muestra.
- Añadida una acción real de "Actualizar Claude Code". El botón original "Reinstalar" no hace nada
  una vez que Claude Code ya funciona, así que no había forma de obtener una versión nueva desde el
  plugin. El nuevo botón ejecuta el propio `claude update` de la CLI y vuelve a cachear el
  resultado en `APPDATA_PATH`, ya que el siguiente arranque, si no, restauraría en silencio el
  binario cacheado antiguo sobre cualquier actualización. Reinstalar y Actualizar ahora escriben
  ambos en el fichero que sigue el enlace "Ver logs en vivo".
- **Control Remoto**: una nueva sección en Settings ejecuta [`claude remote-control`](https://code.claude.com/docs/en/remote-control)
  como un proceso en segundo plano supervisado, para que puedas controlar una sesión de Claude
  Code en este NAS desde claude.ai/code o la app móvil de Claude — solo conexiones HTTPS
  salientes, nada abierto hacia adentro. Siempre retoma la misma sesión en curso en su
  directorio configurado (`--continue`), y solo arranca una sesión nueva la primera vez; nunca
  se inicia solo al arrancar Unraid, solo cuando pulsás Iniciar. Requiere haber iniciado sesión
  con OAuth de claude.ai (Pro/Max/Team/Enterprise); esta función de Anthropic no admite
  autenticación por API key. Por defecto usa un directorio dedicado
  `/root/claude-remote-control` en vez de `/root` directamente, porque Unraid nunca recuerda la
  confianza del workspace para un directorio home. Incluye historial de sesiones, reconexión a
  cualquier sesión pasada, y recuperación automática si una sesión queda archivada en claude.ai.

### ✅ Compatibilidad

Requiere Unraid **6.12.0 o superior** (heredado del original). Verificado en el propio NAS de este
fork, con **Unraid 7.3.2**. El plugin depende de mecanismos estándar del webGUI Dynamix (ficheros
`.page`, `/update.php`, `dynamix.cfg`) presentes en toda la línea 6.x/7.x, así que debería funcionar
en cualquier instalación razonablemente reciente. Si lo pruebas en una versión más antigua o más
nueva, abre un issue contando el resultado.

### 📦 Instalación

URL del plugin (Unraid → Plugins → Install Plugin):

```
https://raw.githubusercontent.com/Nebur692/claude-code-remote-control-unraid-plugin/main/claude-code.plg
```

Consulta la página de
[releases](https://github.com/Nebur692/claude-code-remote-control-unraid-plugin/releases) para el
changelog completo.

### 🧭 Uso

Abre la terminal de Unraid y ejecuta:

```bash
claude
```

La autenticación y la configuración persisten automáticamente entre reinicios. Puedes configurar
la ruta de appdata desde **Settings → Utilities → Claude Code**.

### 🩹 Solución de problemas

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

### 💙 Apoya el proyecto

Sin el apoyo de la comunidad estos proyectos no serían posibles. Si te ha resultado útil, puedes
[apoyarlo en Ko-fi](https://ko-fi.com/nebur69265723) — cualquier aportación ayuda a seguir manteniéndolo.
