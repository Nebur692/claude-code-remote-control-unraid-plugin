# Claude Code Remote Control Unraid Plugin

[Read in English](README.md)

![Claude Code Unraid Plugin](assets/banner.jpg)

Instala la CLI de [Claude Code](https://github.com/anthropics/claude-code) en Unraid.

Este proyecto es un fork de [brianpugh/unraid-claude-code](https://github.com/brianpugh/unraid-claude-code); todo el mérito del plugin original es de su autor. Este fork corrige un fallo de fiabilidad: si la descarga por red del icono del plugin fallaba justo después de reiniciar, Unraid podía deshabilitar el plugin de forma permanente (lo movía a `/boot/config/plugins-error` y no volvía a intentarlo nunca más de forma automática). Más detalles en [Cambios](#cambios).

## Instalación

```bash
plugin install https://raw.githubusercontent.com/Nebur692/claude-code-remote-control-unraid-plugin/main/claude-code.plg
```

## Uso

Abre la terminal de Unraid y ejecuta:

```bash
claude
```

La autenticación y la configuración persisten automáticamente entre reinicios. Puedes configurar la ruta de appdata desde **Settings > Utilities > Claude Code**.

## Requisitos

- Unraid 6.12.0 o superior
- El array iniciado, o el appdata en un punto de montaje de [Unassigned Devices](https://forums.unraid.net/topic/92462-unassigned-devices/)
- Conexión a internet (solo en la primera instalación)

## Cambios

- **v1.0.0** — Fork a partir del proyecto original. El icono del plugin ahora va embebido en base64 dentro del propio `.plg`, en lugar de descargarse por red durante el arranque. Antes, si esa única descarga fallaba (por ejemplo, porque la red aún no estaba lista justo después de reiniciar), Unraid abortaba la instalación completa y desterraba el plugin a `/boot/config/plugins-error`, dejándolo deshabilitado silenciosamente en todos los arranques futuros hasta reinstalarlo a mano.

## Solución de problemas

Consulta el log de instalación:

```bash
cat /var/log/claude-code-install.log
```

Vuelve a ejecutar el instalador manualmente:

```bash
/usr/local/emhttp/plugins/claude-code/scripts/install-claude.sh
```

Si el plugin deja de cargar tras un reinicio, comprueba si ha acabado en `/boot/config/plugins-error/claude-code.plg`. Si es así, reinstálalo desde **Plugins** en la interfaz web de Unraid usando la URL de instalación de arriba.

## Desarrollo

```bash
# Servir el plugin en local
cd /ruta/a/claude-code-remote-control-unraid-plugin
python3 -m http.server 8080

# Desde la terminal de Unraid - instalar
plugin install http://TU_IP_DEV:8080/claude-code.plg

# Reinstalar tras hacer cambios
plugin remove claude-code.plg && plugin install http://TU_IP_DEV:8080/claude-code.plg
```

### Publicar una nueva versión

Este plugin usa versionado por fecha (`AAAA.MM.DD`) siguiendo la convención de los plugins de Unraid, gestionado de forma independiente a los tags de git.

```bash
# Actualizar la versión a la fecha de hoy, hacer commit y crear el tag
bump-my-version replace --new-version 2025.12.01

# Subir los cambios con los tags
git push && git push --tags
```

La publicación actualiza automáticamente las cadenas de versión en `claude-code.plg` mediante `.bumpversion.toml`.
