# Instalar ValleySave en Linux (Ubuntu/Debian)

## Opción recomendada: terminal con `apt`

El Centro de Software (GNOME Software) a veces se niega a instalar un `.deb`
descargado a mano, incluso cuando el paquete está bien — es un problema
conocido de esa app con paquetes locales sin firma, no necesariamente un
fallo del propio `.deb`. La vía fiable es la terminal:

```bash
cd ~/Descargas   # o donde hayas guardado el archivo
sudo apt install ./valleysave_0.3.0_amd64.deb
```

Usa `apt install ./archivo.deb` y no `dpkg -i archivo.deb` — `apt` resuelve
las dependencias que falten automáticamente; `dpkg -i` no, y puede dejar el
paquete a medio instalar si falta alguna.

Para desinstalar más adelante:

```bash
sudo apt remove valleysave
```

## Opción alternativa: versión portable (sin instalar nada)

Si prefieres no tocar el sistema, usa el `.tar.gz` en vez del `.deb`:

```bash
tar -xzf valleysave-linux-x64.tar.gz
cd bundle
./valleysave
```

No deja icono en el menú ni entrada en `apt`, pero funciona igual — puedes
moverlo a cualquier carpeta y ejecutarlo desde ahí.

## Si `apt install` da error de dependencias

Actualiza la lista de paquetes antes de instalar:

```bash
sudo apt update
sudo apt install ./valleysave_0.3.0_amd64.deb
```

Si el error menciona una librería concreta que falta (por ejemplo
`libgtk-3-0` o `libsecret-1-0`), es señal de que tu distro empaqueta esa
librería con un nombre distinto — abre un
[issue](https://github.com/hirieo/valleysave-app/issues) indicando tu
distro y versión (`lsb_release -a`) para que se pueda ajustar.
