<center>

# Moo

🐄🔨🐄 bonk

<br>
<br>

## ⚠ Foreword
This template is according to my prefence on working style.

This acts like [XeroOl](https://github.com/XeroOl/notitg-mirin) and [KyDash](https://github.com/KyDash/nitg-template)'s template. Where, it mostly runs inside a pseudo environment.

<br>

## 🧰 Features
- Loading `.lua` files
- Addons!
- The `modreader.lua` addon allows the modder to use any, or multiple, modreaders.
- Supports OpenITG<sup>[1](#compatibility)</sup>
- Also supports Outfox as well!
- Supports ditching the rhythm game and turning NotITG into a game engine<sup>[2](https://github.com/Jaezmien/NotITG-Moo-Engine)</sup>.
- probably some cows.

<br>

<h2 id="compatibility">🧓 Compatibility</h2>
This template tries its best to be compatible with Outfox, and OpenITG.

To have the file be compatible for all three, you'll need to change `#BETTERBGCHANGES` to `#BGCHANGES`.

You will also need to check out `settings.lua` and turn on some settings.

<br>

## 📦 Addons
[Addons](https://github.com/Jaezmien/NotITG-Moo-Addons) are supported in this template, either in `.xml` or in `.lua` format.
Templates for these are inside the `template/addons` folder.

If you don't want an addon to run but still want it inside the folder, add an underscore prefix. (e.g. `_template.xml`)

If an addon can only be ran in either NotITG or Outfox. You'll need to add `.notitg` or `.outfox` before the file extension. (e.g. `addon.notitg.lua`, `addon.outfox.lua`)
Otherwise, it can be left out and both versions will load the file. (e.g. `addon.lua`)

<br>

## 📢 Hooks
Currently, there are three main hooks in the template.
- `setup_hooks` are for functions that needs to run as soon as the template loads.
- `init_hooks` are for functions that needs to run after `setup_hooks`.
- `update_hooks` are for functions that runs every template update.

</center>

## 🔨 Setting Up
It's recommended to use [NotITG-Init](https://github.com/Jaezmien/NotITG-Init) to set up this template.

Otherwise, you'll need to manually clone, or download, the repositories you'll use (including this one), and add them to your simfile folder.

[🍺 Mods](https://github.com/Jaezmien/NotITG-Moo-Mods)
[⚙ Engine](https://github.com/Jaezmien/NotITG-Moo-Engine)
[📦 Addons](https://github.com/Jaezmien/NotITG-Moo-Addons)
