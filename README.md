<center>

# Moo

🐄🔨🐄 bonk

<br>
<br>

## ⚠ Foreword
---
This template is according to my prefence on working style.

This acts like [XeroOl](https://github.com/XeroOl/notitg-mirin) and [KyDash](https://github.com/KyDash/nitg-template)'s template. Where, it mostly runs inside a pseudo environment.

<br>

## 🧰 Features
---
- Loading `.lua` files
- The `modreader.lua` addon allows the modder to use any, or multiple, modreaders.
- Compatible with all versions of NotITG, and supports OpenITG.<sup>[1](#compatibility)</sup>
- Supports ditching the rhythm game and turning NotITG into a game engine.
- probably some cows.

<br>

---
## ❓ Branch Info
- `main` - The main branch
- `extras` - Branch for addons
- `engine` - Branch for base engine file

<br>

<h2 id="compatibility">🧓 Compatibility</h2>
<hr>
This template tries its best to be compatible with old NotITG versions *and* OpenITG.

While `simfile.txt` already has what you need for your `.sm` file, you will need to change `#BETTERBGCHANGES` to `#BGCHANGES` for OpenITG.

You will also need to check out `settings.lua` to turn on some settings.

<br>

## 📦 Addons
---
Addons are supported in this template, either in `.xml` or in `.lua` format.
Templates for these are inside the `template/addons` folder.

If you don't want an addon to run but still want it inside the folder, add an underscore prefix. (e.g. `_template.xml`)

<br>

## 📢 Hooks
---
Currently, there are three main hooks in the template.
- `setup_hooks` are for functions that needs to run as soon as the template loads.
- `init_hooks` are for functions that needs to run after `setup_hooks`.
- `update_hooks` are for functions that runs every template update.

</center>