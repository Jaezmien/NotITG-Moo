<div align="center">
  
# NotITG-Moo

<img src="https://img.shields.io/badge/Version-v2.2.0-green"> 

> A NotITG + Outfox File Framework
  
</div>

## 📄 Acknowledgements
This framework was originally based from mod templates such as [XeroOl's Mirin Template](https://github.com/XeroOl/notitg-mirin) and [KyDash's Template](https://github.com/KyDash/nitg-template).

## 🧰 Features
- Loading (and caching) `.lua` files
- Lua and XML Addons
- OpenITG + Outfox compatibility
- Supports creating modfiles and minigames

## 🔨 Setting Up
It's recommended to use [NotITG-Init](https://github.com/Jaezmien/NotITG-Init) to easily set up the framework, and the template.

Alternatively, you can clone/download this repository, and the template you'll be using, and merge them to your simfile folder.

- [↖ Modfile Template](https://github.com/Jaezmien/NotITG-Moo-Mods)
- [⚙ Minigame Template](https://github.com/Jaezmien/NotITG-Moo-Engine)

## 🤝 Compatibility
This framework, and templates, tries its best to be compatible with Outfox and OpenITG.

To have compatibility for any of these, you will need to use `#BGCHANGES` instead of `#BETTERBGCHANGES`.

You will also need to check out `settings.lua`.

## 🎣 Hooks
To prevent load order confusion, it's recommended to put functions inside hooks.
- `setup_hooks` - Functions that needs to run as soon as the framework loads *(recommended for addons)*.
- `init_hooks` - Functions that needs to run after `setup_hooks`.
- `update_hooks` - Functions that runs every update.

Example:
```lua
init_hooks{'modfile initialize',function()
	-- Guaranteed to exist when this function is ran.
	local P1 = SCREENMAN:GetTopScreen():GetChild('PlayerP1')
end}
```

<hr>

## 🔗 Additional Links
- [📦 Addons Repository](https://github.com/Jaezmien/NotITG-Moo-Addons)
