# Flatpak for Redot Engine

## Installation

This Flatpak is not yet available on Flathub, but you can install it manually.

To download the file, you can use one of the following:

1. **Download manually** - Use
   [this link](https://github.com/chenasraf/org.redotengine.Redot/releases/tag/v4.3-beta.1), and download the
   artifact called `Redot-x86_64.zip`.
1. **Download using curl**
   ```bash
   curl https://github.com/chenasraf/org.redotengine.Redot/releases/download/v4.3-beta.1/Redot-x86_64.zip > Redot-x86_64.zip
   ```

Then, unzip it and install to flatpak from file:

```bash
unzip Redot-x86_64.zip
flatpak install --user Redot-x86_64.flatpak
```

**Looking to package a Redot project as a Flatpak ?**
See [flathub/org.redotengine.redot.BaseApp](https://github.com/flathub/org.redotengine.redot.BaseApp).

## Updating

This Flatpak follows the latest stable Redot version.
To update it, run the following command in a terminal:

```bash
flatpak update
```

## Using Blender

This version of Redot is built with special
[permissions](https://github.com/flathub/org.redotengine.Redot/blob/394f81c3310b82f5069ea917bb21f49888f818c6/org.redotengine.Redot.yaml#L46)
to be able to run commands on the host system outside of the sandbox via
[flatpak-spawn](https://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-spawn).
This is done by prefixing the command with `flatpak-spawn --host`. For example, if you want to run `gnome-terminal` on
the host system outside of the sandbox, you can do so by running `flatpak-spawn --host gnome-terminal`.

Redot expects the Blender executable to be named `blender` (lowercase), so a script exactly named `blender` that
executes Blender via `flatpak-spawn --host` should be created. Below are two [Bash](https://www.gnu.org/software/bash/)
scripts which may need to be modified depending on your [shell](https://en.wikipedia.org/wiki/Shell_(computing)) and
how Blender is installed.

### Bash script assuming Blender is installed in `PATH` (e.g. using distribution packages)

```bash
#!/bin/bash

flatpak-spawn --host blender "$@"
```

### Bash script assuming Blender is installed from Flathub

```bash
#!/bin/bash

flatpak-spawn --host flatpak run org.blender.Blender "$@"
```

Make sure your script is executable using `chmod +x blender`. Use the directory path containing your script in the
Editor Settings (**Filesystem > Import > Blender > Blender 3 Path**).

## Using an external script editor

This version of Redot is built with special [permissions](https://github.com/flathub/org.redotengine.Redot/blob/394f81c3310b82f5069ea917bb21f49888f818c6/org.redotengine.Redot.yaml#L46) to be able to run commands on the host system outside of the sandbox via [flatpak-spawn](https://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-spawn). This is done by prefixing the command with `flatpak-spawn --host`. For example, if you want to run `gnome-terminal` on the host system outside of the sandbox, you can do so by running `flatpak-spawn --host gnome-terminal`.

To spawn an external editor in Redot, all command line arguments must be split from the commands path in the
[external editor preferences](https://docs.redotengine.org/en/latest/getting_started/editor/external_editor.html) and
because the command needs to be prefixed with `"flatpak-spawn --host"`, the **Exec Path** is replaced by `flatpak-spawn`
and the **Exec Flags** are prefixed by `--host [command path]`.

For example, for Visual Studio Code, where your
[external editor preferences](https://docs.redotengine.org/en/3.2/getting_started/editor/external_editor.html) would
*normally* look like this...

```text
Exec Path:  code
Exec Flags: --reuse-window {project} --goto {file}:{line}:{col}
```

...it should look like this **inside the Flatpak sandbox**:

```text
Exec Path:  flatpak-spawn
Exec Flags: --host code --reuse-window {project} --goto {file}:{line}:{col}
```

## Limitations

- ~For C#/Mono support, install [org.redotengine.RedotSharp](https://flathub.org/apps/org.redotengine.RedotSharp) instead.~ Not yet supported.

## Building from source

Install Git, follow the
[flatpak-builder setup guide](https://docs.flatpak.org/en/latest/first-build.html)
then enter the following commands in a terminal:

```bash
git clone --recursive https://github.com/chenasraf/org.redotengine.Redot.git
cd org.redotengine.Redot/
git submodule init
git submodule update
flatpak install --user flathub org.freedesktop.Sdk//24.08 -y
flatpak-builder --force-clean --install --user -y builddir org.redotengine.Redot.yaml
```

If all goes well, the Flatpak will be installed after building. You can then
run it using your desktop environment's application launcher.

You can speed up incremental builds by installing [ccache](https://ccache.dev/)
and specifying `--ccache` in the flatpak-builder command line (before `builddir`).
