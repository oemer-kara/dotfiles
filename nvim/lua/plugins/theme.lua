return {
	-- Theme collection
	-- Provides kanagawa-wave/dragon/lotus, referenced by the Themery list
	-- below but never actually declared as a dependency until now.
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "slugbyte/lackluster.nvim", lazy = true },
	{ "catppuccin/nvim", name = "catppuccin", lazy = true },
	{ "folke/tokyonight.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
	{ "sainnhe/gruvbox-material", lazy = true },
	{ "EdenEast/nightfox.nvim", lazy = true },
	{ "navarasu/onedark.nvim", lazy = true, config = function() require("onedark").setup({ style = "dark" }) end },
	{ "sainnhe/everforest", lazy = true },
	{ "bluz71/vim-nightfly-colors", name = "nightfly", lazy = true },
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = true },
	{ "projekt0n/github-nvim-theme", lazy = true, config = function() require("github-theme").setup({}) require("github-theme").compile() end },
	{ "Mofiqul/dracula.nvim", lazy = true },
	{ "blazkowolf/gruber-darker.nvim", lazy = true },
	{ "sainnhe/sonokai", lazy = true },
	{ "nyoom-engineering/oxocarbon.nvim", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "scottmckendry/cyberdream.nvim", lazy = true },
	{ "Mofiqul/vscode.nvim", lazy = true },
	{ "nordtheme/vim", name = "nord", lazy = true },
	{ "shaunsingh/solarized.nvim", lazy = true },
	{ "marko-cerovac/material.nvim", lazy = true },
	{ "AlexvZyl/nordic.nvim", lazy = true },
	{ "neanias/everforest-nvim", name = "everforest-nvim", lazy = true, config = function() require("everforest").setup({}) end },
	{ "craftzdog/solarized-osaka.nvim", lazy = true },
	{
		"0xstepit/flow.nvim",
		lazy = true,
		config = function()
			require("flow").setup({})
		end,
		init = function()
			vim.api.nvim_create_autocmd("ColorSchemePre", {
				pattern = "flow",
				once = false,
				callback = function()
					local cfg = require("flow.config")
					if vim.tbl_isempty(cfg.options) then
						cfg._setup({})
					end
				end,
			})
		end,
	},
	{ "HoNamDuong/hybrid.nvim", lazy = true },
	{ "ribru17/bamboo.nvim", lazy = true, config = function() require("bamboo").setup({}) end },
	{ "kepano/flexoki-neovim", name = "flexoki", lazy = true },
	{ "savq/melange-nvim", lazy = true },
	{ "mcchrish/zenbones.nvim", dependencies = "rktjmp/lush.nvim", lazy = true },
	{ "ramojus/mellifluous.nvim", lazy = true },
	{ "dgox16/oldworld.nvim", lazy = true },
	{ "olivercederborg/poimandres.nvim", lazy = true },
	{ "miikanissi/modus-themes.nvim", lazy = true },
	{ "sainnhe/edge", lazy = true },
	{ "tanvirtin/monokai.nvim", lazy = true },
	{ "shaunsingh/moonlight.nvim", lazy = true },
	{ "ray-x/aurora", lazy = true },
	{ "tiagovla/tokyodark.nvim", lazy = true },
	{ "Shatur/neovim-ayu", lazy = true },
	{ "kvrohit/rasmus.nvim", lazy = true },
	{ "lewpoly/sherbet.nvim", lazy = true },
	{ "dasupradyumna/midnight.nvim", lazy = true },
	{ "Abstract-IDE/Abstract-cs", lazy = true },
	{ "rockyzhang24/arctic.nvim", dependencies = "rktjmp/lush.nvim", lazy = true },
	{ "decaycs/decay.nvim", name = "decay", lazy = true },
	{ "kaiuri/nvim-juliana", lazy = true },
	{ "lmburns/kimbox", lazy = true },
	{ "maxmx03/fluoromachine.nvim", lazy = true },
	{ "uloco/bluloco.nvim", dependencies = "rktjmp/lush.nvim", lazy = true },
	{ "loctvl842/monokai-pro.nvim", lazy = true },
	{ "olimorris/onedarkpro.nvim", lazy = true },
	{ "Tsuzat/NeoSolarized.nvim", lazy = true },
	{ "water-sucks/darkrose.nvim", lazy = true },
	{ "titanzero/zephyrium", lazy = true },
	{ "2nthony/vitesse.nvim", dependencies = "MunifTanjim/nui.nvim", lazy = true },
	{ "xero/miasma.nvim", lazy = true },
	{ "ficcdaf/ashen.nvim", lazy = true },
	{ "comfysage/evergarden", lazy = true },
	{ "eldritch-theme/eldritch.nvim", lazy = true },
	{ "sho-87/kanagawa-paper.nvim", lazy = true },
	{ "nyngwang/nvimgelion", lazy = true },
	{ "luisiacc/gruvbox-baby", lazy = true },
	{ "sam4llis/nvim-tundra", lazy = true },
	{ "zootedb0t/citruszest.nvim", lazy = true },
	{ "Yazeed1s/oh-lucy.nvim", lazy = true },
	{ "AlphaTechnolog/pywal.nvim", name = "pywal", lazy = true },
	{ "kartikp10/noctis.nvim", dependencies = "rktjmp/lush.nvim", lazy = true },
	{ "RRethy/base16-nvim", lazy = true },
	{ "kdheepak/monochrome.nvim", lazy = true },
	{ "mhartington/oceanic-next", lazy = true },
	{ "rafamadriz/neon", lazy = true },
	{ "yashguptaz/calvera-dark.nvim", lazy = true },
	{ "Everblush/nvim", name = "everblush", lazy = true },
	{ "kvrohit/substrata.nvim", lazy = true },
	{ "fenetikm/falcon", lazy = true },
	{ "embark-theme/vim", name = "embark", lazy = true },
	{ "jim-at-jibba/ariake.nvim", lazy = true },
	{ "adisen99/apprentice.nvim", dependencies = "rktjmp/lush.nvim", lazy = true },
	{ "rmehri01/onenord.nvim", lazy = true },
	{ "cpea2506/one_monokai.nvim", lazy = true },
	{ "AstroNvim/astrotheme", lazy = true, config = function() require("astrotheme").setup() end },
	{ "Mofiqul/adwaita.nvim", lazy = true },
	{ "hardhackerlabs/theme-vim", name = "hardhacker", lazy = true },
	{ "metalelf0/jellybeans-nvim", dependencies = "rktjmp/lush.nvim", lazy = true },
	{ "NTBBloodbath/doom-one.nvim", lazy = true },
	{ "jesseleite/nvim-noirbuddy", dependencies = "tjdevries/colorbuddy.nvim", lazy = true },
	{ "mellow-theme/mellow.nvim", lazy = true },
	{ "Yazeed1s/minimal.nvim", lazy = true },
	-- Additional themes
	{ "vague2k/vague.nvim", lazy = true },
	{ "webhooked/kanso.nvim", lazy = true },
	{ "cryptomilk/nightcity.nvim", lazy = true },
	{ "darkvoid-theme/darkvoid.nvim", lazy = true },
	{ "aktersnurra/no-clown-fiesta.nvim", lazy = true },
	{ "oxfist/night-owl.nvim", lazy = true },
	{ "datsfilipe/vesper.nvim", lazy = true },
	{ "xero/evangelion.nvim", lazy = true },
	{ "ofirgall/ofirkai.nvim", lazy = true },
	{ "judaew/ronny.nvim", lazy = true },
	{ "xiantang/darcula-dark.nvim", lazy = true },
	{ "polirritmico/monokai-nightasty.nvim", lazy = true },
	{ "sontungexpt/witch", lazy = true, config = function() require("witch").setup({}) end },
	{ "ptdewey/darkearth-nvim", lazy = true },
	{ "everviolet/nvim", name = "evergarden-violet", lazy = true, dependencies = "rktjmp/lush.nvim" },
	{ "ilof2/posterpole.nvim", lazy = true },
	{ "casedami/neomodern.nvim", lazy = true },
	{ "yorumicolors/yorumi.nvim", lazy = true },
	{ "wnkz/monoglow.nvim", lazy = true },
	{ "Verf/deepwhite.nvim", lazy = true },
	{ "idr4n/github-monochrome.nvim", lazy = true },
	{ "ntk148v/komau.vim", lazy = true },
	-- { "rileytwo/kiss", lazy = true }, -- broken/unmaintained
	{ "yorik1984/newpaper.nvim", lazy = true },
	{ "zenbones-theme/zenbones.nvim", name = "zenbones-theme", lazy = true, dependencies = "rktjmp/lush.nvim" },
	{ "metalelf0/black-metal-theme-neovim", lazy = true },
	{ "oonamo/ef-themes.nvim", lazy = true },
	{ "ray-x/starry.nvim", lazy = true, config = function() require("starry").setup({}) end },
	{ "maxmx03/solarized.nvim", name = "maxmx03-solarized", lazy = true },
	{ "RedsXDD/neopywal.nvim", lazy = true },
	{ "askfiy/visual_studio_code", lazy = true },
	{ "tomasiser/vim-code-dark", lazy = true },
	{ "nickkadutskyi/jb.nvim", lazy = true },
	{ "felipeagc/fleet-theme-nvim", lazy = true },
	{ "thallada/farout.nvim", lazy = true },
	{ "jacoborus/tender.vim", lazy = true },
	{ "hyperb1iss/silkcircuit-nvim", lazy = true },
	{ "rockerBOO/boo-colorscheme-nvim", lazy = true, dependencies = "tjdevries/colorbuddy.nvim", config = function() require("boo-colorscheme").setup({}) end },
	{ "nvimdev/zephyr-nvim", lazy = true },
	{ "Iron-E/nvim-highlite", lazy = true },
	{ "lalitmee/cobalt2.nvim", lazy = true, dependencies = "tjdevries/colorbuddy.nvim" },
	{ "phha/zenburn.nvim", lazy = true },
	{ "Luxed/ayu-vim", lazy = true },
	{ "AhmedAbdulrahman/aylin.vim", lazy = true },
	{ "talha-akram/noctis.nvim", name = "talha-noctis", lazy = true },
	{ "shrikecode/kyotonight.vim", lazy = true },
	{ "Alexis12119/nightly.nvim", lazy = true },
	{ "humanoid-colors/vim-humanoid-colorscheme", lazy = true },
	{ "uhs-robert/oasis.nvim", lazy = true },
	{ "FrenzyExists/aquarium-vim", lazy = true },
	{ "hachy/eva01.vim", lazy = true },
	{ "gbprod/nord.nvim", name = "gbprod-nord", lazy = true },
	{ "shaunsingh/nord.nvim", name = "shaunsingh-nord", lazy = true },
	{ "fynnfluegge/monet.nvim", lazy = true },
	{ "samharju/synthweave.nvim", lazy = true },
	{ "thesimonho/kanagawa-paper.nvim", name = "kanagawa-paper-simon", lazy = true },

	-- Theme switcher
	{
		"zaldih/themery.nvim",
		lazy = false,
		keys = {
			{ "<leader>tt", "<cmd>Themery<cr>", desc = "Theme switcher" },
		},
		config = function(_, opts)
			vim.api.nvim_create_autocmd("ColorSchemePre", {
				group = vim.api.nvim_create_augroup("ThemerySwitchReset", { clear = true }),
				callback = function()
					pcall(vim.cmd, "hi clear")
					if vim.fn.exists("syntax_on") == 1 then
						pcall(vim.cmd, "syntax reset")
					end
				end,
			})

			-- Themery always prints "themeConfigFile is deprecated" on
			-- Windows: its check requires the (unset) option to
			-- fnamemodify(..., ":p") into a path containing "v:null", but on
			-- Windows that adds a "v:\" drive prefix instead, so the
			-- substring never survives and the print fires unconditionally.
			-- There's no config-side fix; swallow just this one message.
			local real_print = _G.print
			_G.print = function(...)
				local msg = table.concat(vim.tbl_map(tostring, { ... }), " ")
				if not msg:find("themeConfigFile", 1, true) then
					real_print(...)
				end
			end
			local ok, err = pcall(require("themery").setup, opts)
			_G.print = real_print
			if not ok then
				error(err)
			end
		end,
		opts = {
			themes = {
				-- Kanagawa
				{ name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
				{ name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
				{ name = "Kanagawa Lotus", colorscheme = "kanagawa-lotus" },
				-- Lackluster
				{ name = "Lackluster", colorscheme = "lackluster" },
				{ name = "Lackluster Hack", colorscheme = "lackluster-hack" },
				{ name = "Lackluster Mint", colorscheme = "lackluster-mint" },
				-- Catppuccin
				{ name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
				{ name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
				{ name = "Catppuccin Frappe", colorscheme = "catppuccin-frappe" },
				{ name = "Catppuccin Latte", colorscheme = "catppuccin-latte" },
				-- Tokyo Night
				{ name = "Tokyo Night", colorscheme = "tokyonight-night" },
				{ name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
				{ name = "Tokyo Night Moon", colorscheme = "tokyonight-moon" },
				{ name = "Tokyo Night Day", colorscheme = "tokyonight-day" },
				-- Rose Pine
				{ name = "Rose Pine", colorscheme = "rose-pine-main" },
				{ name = "Rose Pine Moon", colorscheme = "rose-pine-moon" },
				{ name = "Rose Pine Dawn", colorscheme = "rose-pine-dawn" },
				-- Gruvbox Material
				{ name = "Gruvbox Material", colorscheme = "gruvbox-material" },
				-- Nightfox
				{ name = "Nightfox", colorscheme = "nightfox" },
				{ name = "Dawnfox", colorscheme = "dawnfox" },
				{ name = "Carbonfox", colorscheme = "carbonfox" },
				{ name = "Nordfox", colorscheme = "nordfox" },
				-- OneDark
				{ name = "OneDark", colorscheme = "onedark" },
				-- Everforest
				{ name = "Everforest", colorscheme = "everforest" },
				-- Nightfly / Moonfly
				{ name = "Nightfly", colorscheme = "nightfly" },
				{ name = "Moonfly", colorscheme = "moonfly" },
				-- GitHub
				{ name = "GitHub Dark", colorscheme = "github_dark" },
				{ name = "GitHub Dark Dimmed", colorscheme = "github_dark_dimmed" },
				{ name = "GitHub Light", colorscheme = "github_light" },
				-- Dracula
				{ name = "Dracula", colorscheme = "dracula" },
				-- Gruber Darker
				{ name = "Gruber Darker", colorscheme = "gruber-darker" },
				-- Sonokai
				{ name = "Sonokai", colorscheme = "sonokai" },
				-- Oxocarbon
				{ name = "Oxocarbon", colorscheme = "oxocarbon" },
				-- Gruvbox
				{ name = "Gruvbox Dark", colorscheme = "gruvbox" },
				-- Cyberdream
				{ name = "Cyberdream", colorscheme = "cyberdream" },
				{ name = "Cyberdream Light", colorscheme = "cyberdream-light" },
				-- VSCode
				{ name = "VSCode Dark", colorscheme = "vscode" },
				-- Nord
				{ name = "Nord", colorscheme = "nord" },
				-- Solarized
				{ name = "Solarized", colorscheme = "solarized" },
				-- Material
				{ name = "Material Deep Ocean", colorscheme = "material-deep-ocean" },
				{ name = "Material Oceanic", colorscheme = "material-oceanic" },
				{ name = "Material Palenight", colorscheme = "material-palenight" },
				{ name = "Material Darker", colorscheme = "material-darker" },
				-- Nordic
				{ name = "Nordic", colorscheme = "nordic" },
				-- Solarized Osaka
				{ name = "Solarized Osaka", colorscheme = "solarized-osaka" },
				-- Flow
				{ name = "Flow", colorscheme = "flow" },
				-- Hybrid
				{ name = "Hybrid", colorscheme = "hybrid" },
				-- Bamboo
				{ name = "Bamboo", colorscheme = "bamboo" },
				-- Flexoki
				{ name = "Flexoki Dark", colorscheme = "flexoki-dark" },
				{ name = "Flexoki Light", colorscheme = "flexoki-light" },
				-- Melange
				{ name = "Melange", colorscheme = "melange" },
				-- Zenbones
				{ name = "Zenbones", colorscheme = "zenbones" },
				{ name = "Tokyobones", colorscheme = "tokyobones" },
				{ name = "Rosebones", colorscheme = "rosebones" },
				-- Mellifluous
				{ name = "Mellifluous", colorscheme = "mellifluous" },
				-- Old World
				{ name = "Old World", colorscheme = "oldworld" },
				-- Poimandres
				{ name = "Poimandres", colorscheme = "poimandres" },
				-- Modus
				{ name = "Modus Vivendi", colorscheme = "modus_vivendi" },
				{ name = "Modus Operandi", colorscheme = "modus_operandi" },
				-- Edge
				{ name = "Edge", colorscheme = "edge" },
				-- Monokai
				{ name = "Monokai", colorscheme = "monokai" },
				{ name = "Monokai Soda", colorscheme = "monokai_soda" },
				{ name = "Monokai Pro", colorscheme = "monokai-pro" },
				{ name = "Monokai Pro Machine", colorscheme = "monokai-pro-machine" },
				{ name = "Monokai Pro Octagon", colorscheme = "monokai-pro-octagon" },
				{ name = "Monokai Pro Spectrum", colorscheme = "monokai-pro-spectrum" },
				{ name = "Monokai Pro Ristretto", colorscheme = "monokai-pro-ristretto" },
				{ name = "Monokai Pro Classic", colorscheme = "monokai-pro-classic" },
				-- Moonlight
				{ name = "Moonlight", colorscheme = "moonlight" },
				-- Aurora
				{ name = "Aurora", colorscheme = "aurora" },
				-- Tokyo Dark
				{ name = "Tokyo Dark", colorscheme = "tokyodark" },
				-- Ayu
				{ name = "Ayu Dark", colorscheme = "ayu-dark" },
				{ name = "Ayu Mirage", colorscheme = "ayu-mirage" },
				{ name = "Ayu Light", colorscheme = "ayu-light" },
				-- Rasmus
				{ name = "Rasmus", colorscheme = "rasmus" },
				-- Sherbet
				{ name = "Sherbet", colorscheme = "sherbet" },
				-- Midnight
				{ name = "Midnight", colorscheme = "midnight" },
				-- Abstract
				{ name = "Abstract", colorscheme = "abscs" },
				-- Arctic
				{ name = "Arctic", colorscheme = "arctic" },
				-- Decay
				{ name = "Decay", colorscheme = "decay" },
				-- Juliana
				{ name = "Juliana", colorscheme = "juliana" },
				-- Kimbox
				{ name = "Kimbox", colorscheme = "kimbox" },
				-- Fluoromachine
				{ name = "Fluoromachine", colorscheme = "fluoromachine" },
				-- Bluloco
				{ name = "Bluloco Dark", colorscheme = "bluloco-dark" },
				{ name = "Bluloco Light", colorscheme = "bluloco-light" },
				-- OneDarkPro
				{ name = "OneDark Pro Light", colorscheme = "onelight" },
				{ name = "OneDark Pro Vaporwave", colorscheme = "vaporwave" },
				{ name = "OneDark Pro Vivid", colorscheme = "onedark_vivid" },
				{ name = "OneDark Pro Dark", colorscheme = "onedark_dark" },
				-- NeoSolarized
				{ name = "NeoSolarized", colorscheme = "NeoSolarized" },
				-- Darkrose
				{ name = "Darkrose", colorscheme = "darkrose" },
				-- Zephyrium
				{ name = "Zephyrium", colorscheme = "zephyrium" },
				-- Vitesse
				{ name = "Vitesse", colorscheme = "vitesse" },
				-- Miasma
				{ name = "Miasma", colorscheme = "miasma" },
				-- Ashen
				{ name = "Ashen", colorscheme = "ashen" },
				-- Evergarden
				{ name = "Evergarden", colorscheme = "evergarden" },
				-- Eldritch
				{ name = "Eldritch", colorscheme = "eldritch" },
				-- Kanagawa Paper
				{ name = "Kanagawa Paper", colorscheme = "kanagawa-paper" },
				-- Nvimgelion
				{ name = "Nvimgelion", colorscheme = "nvimgelion" },
				-- Gruvbox Baby
				{ name = "Gruvbox Baby", colorscheme = "gruvbox-baby" },
				-- Tundra
				{ name = "Tundra", colorscheme = "tundra" },
				-- Citruszest
				{ name = "Citruszest", colorscheme = "citruszest" },
				-- Oh Lucy
				{ name = "Oh Lucy", colorscheme = "oh-lucy" },
				{ name = "Oh Lucy Evening", colorscheme = "oh-lucy-evening" },
				-- Pywal: needs the external `wal` tool to have generated
				-- ~/.cache/wal/colors-wal.vim. Without it the scheme aborts with E484,
				-- so it is not listed. Re-add it if you start using pywal.
				-- Noctis
				{ name = "Noctis", colorscheme = "noctis" },
				-- Monochrome
				{ name = "Monochrome", colorscheme = "monochrome" },
				-- Oceanic Next
				{ name = "Oceanic Next", colorscheme = "OceanicNext" },
				-- Neon
				{ name = "Neon", colorscheme = "neon" },
				-- Calvera
				{ name = "Calvera Dark", colorscheme = "calvera" },
				-- Everblush
				{ name = "Everblush", colorscheme = "everblush" },
				-- Substrata
				{ name = "Substrata", colorscheme = "substrata" },
				-- Falcon
				{ name = "Falcon", colorscheme = "falcon" },
				-- Embark
				{ name = "Embark", colorscheme = "embark" },
				-- Ariake
				{ name = "Ariake", colorscheme = "ariake" },
				-- Apprentice
				{ name = "Apprentice", colorscheme = "apprentice" },
				-- OneNord
				{ name = "OneNord", colorscheme = "onenord" },
				-- One Monokai
				{ name = "One Monokai", colorscheme = "one_monokai" },
				-- AstroTheme
				{ name = "AstroDark", colorscheme = "astrodark" },
				{ name = "AstroLight", colorscheme = "astrolight" },
				{ name = "AstroMars", colorscheme = "astromars" },
				-- Adwaita
				{ name = "Adwaita Dark", colorscheme = "adwaita" },
				-- HardHacker
				{ name = "HardHacker", colorscheme = "hardhacker" },
				-- Jellybeans
				{ name = "Jellybeans", colorscheme = "jellybeans-nvim" },
				-- Doom One
				{ name = "Doom One", colorscheme = "doom-one" },
				-- Noirbuddy
				{ name = "Noirbuddy", colorscheme = "noirbuddy" },
				-- Mellow
				{ name = "Mellow", colorscheme = "mellow" },
				-- Minimal
				{ name = "Minimal", colorscheme = "minimal" },
				{ name = "Minimal Base16", colorscheme = "minimal-base16" },
				-- Vague
				{ name = "Vague", colorscheme = "vague" },
				-- Kanso
				{ name = "Kanso Zen", colorscheme = "kanso-zen" },
				{ name = "Kanso Ink", colorscheme = "kanso-ink" },
				{ name = "Kanso Mist", colorscheme = "kanso-mist" },
				{ name = "Kanso Pearl", colorscheme = "kanso-pearl" },
				-- Night City
				{ name = "Night City", colorscheme = "nightcity" },
				-- Darkvoid
				{ name = "Darkvoid", colorscheme = "darkvoid" },
				-- No Clown Fiesta
				{ name = "No Clown Fiesta", colorscheme = "no-clown-fiesta" },
				-- Night Owl
				{ name = "Night Owl", colorscheme = "night-owl" },
				-- Vesper
				{ name = "Vesper", colorscheme = "vesper" },
				-- Evangelion
				{ name = "Evangelion", colorscheme = "evangelion" },
				-- Ofirkai
				{ name = "Ofirkai", colorscheme = "ofirkai" },
				{ name = "Ofirkai Dark Blue", colorscheme = "ofirkai-darkblue" },
				-- Ronny
				{ name = "Ronny", colorscheme = "ronny" },
				-- Darcula
				{ name = "Darcula Dark", colorscheme = "darcula-dark" },
				-- Monokai NighTasty
				{ name = "Monokai NighTasty", colorscheme = "monokai-nightasty" },
				-- Witch
				{ name = "Witch Dark", colorscheme = "witch-dark" },
				{ name = "Witch Light", colorscheme = "witch-light" },
				-- Darkearth
				{ name = "Darkearth", colorscheme = "darkearth" },
				{ name = "Lightearth", colorscheme = "lightearth" },
				-- everviolet/nvim registers the same names as comfysage/evergarden,
				-- so point this at a seasonal variant that was otherwise unreachable.
				{ name = "Evergarden Winter", colorscheme = "evergarden-winter" },
				-- Posterpole
				{ name = "Posterpole", colorscheme = "posterpole" },
				-- Neomodern
				{ name = "Neomodern Iceclimber", colorscheme = "iceclimber" },
				{ name = "Neomodern Roseprime", colorscheme = "roseprime" },
				{ name = "Neomodern Gyokuro", colorscheme = "gyokuro" },
				{ name = "Neomodern Hojicha", colorscheme = "hojicha" },
				{ name = "Neomodern Moon", colorscheme = "moon" },
				-- Yorumi
				{ name = "Yorumi", colorscheme = "yorumi" },
				-- Monoglow
				{ name = "Monoglow", colorscheme = "monoglow" },
				-- Deepwhite
				{ name = "Deepwhite", colorscheme = "deepwhite" },
				-- GitHub Monochrome
				{ name = "GitHub Monochrome", colorscheme = "github-monochrome" },
				-- Komau
				{ name = "Komau", colorscheme = "komau" },
				-- Newpaper
				{ name = "Newpaper", colorscheme = "newpaper" },
				-- Zenbones extras (theme variants)
				{ name = "Zenwritten", colorscheme = "zenwritten" },
				{ name = "Neobones", colorscheme = "neobones" },
				{ name = "Vimbones", colorscheme = "vimbones" },
				{ name = "Forestbones", colorscheme = "forestbones" },
				{ name = "Nordbones", colorscheme = "nordbones" },
				{ name = "Seoulbones", colorscheme = "seoulbones" },
				{ name = "Duckbones", colorscheme = "duckbones" },
				{ name = "Zenburned", colorscheme = "zenburned" },
				{ name = "Kanagawabones", colorscheme = "kanagawabones" },
				-- Black Metal
				{ name = "Black Metal Bathory", colorscheme = "bathory" },
				{ name = "Black Metal Burzum", colorscheme = "burzum" },
				{ name = "Black Metal Darkthrone", colorscheme = "darkthrone" },
				{ name = "Black Metal Emperor", colorscheme = "emperor" },
				{ name = "Black Metal Gorgoroth", colorscheme = "gorgoroth" },
				{ name = "Black Metal Immortal", colorscheme = "immortal" },
				{ name = "Black Metal Marduk", colorscheme = "marduk" },
				{ name = "Black Metal Mayhem", colorscheme = "mayhem" },
				{ name = "Black Metal Nile", colorscheme = "nile" },
				{ name = "Black Metal Venom", colorscheme = "venom" },
				-- Ef-Themes
				{ name = "Ef Autumn", colorscheme = "ef-autumn" },
				{ name = "Ef Cherie", colorscheme = "ef-cherie" },
				{ name = "Ef Dark", colorscheme = "ef-dark" },
				{ name = "Ef Dream", colorscheme = "ef-dream" },
				{ name = "Ef Night", colorscheme = "ef-night" },
				{ name = "Ef Owl", colorscheme = "ef-owl" },
				{ name = "Ef Winter", colorscheme = "ef-winter" },
				{ name = "Ef Day", colorscheme = "ef-day" },
				{ name = "Ef Spring", colorscheme = "ef-spring" },
				{ name = "Ef Summer", colorscheme = "ef-summer" },
				{ name = "Ef Frost", colorscheme = "ef-frost" },
				{ name = "Ef Light", colorscheme = "ef-light" },
				-- Starry
				{ name = "Starry Mariana", colorscheme = "mariana" },
				{ name = "Starry Emerald", colorscheme = "emerald" },
				{ name = "Starry Middlenight Blue", colorscheme = "middlenight_blue" },
				{ name = "Starry Earlysummer", colorscheme = "earlysummer" },
				{ name = "Starry Darksolar", colorscheme = "darksolar" },
				{ name = "Starry Ukraine", colorscheme = "ukraine" },
				{ name = "Starry Deep Ocean", colorscheme = "deepocean" },
				{ name = "Starry Palenight", colorscheme = "palenight" },
				{ name = "Starry Limestone", colorscheme = "limestone" },
				{ name = "Starry Oceanic", colorscheme = "oceanic" },
				-- maxmx03-solarized also registers "solarized", colliding with
				-- shaunsingh/solarized.nvim above; it cannot be selected separately.
				-- Neopywal
				{ name = "Neopywal", colorscheme = "neopywal" },
				{ name = "Neopywal Dark", colorscheme = "neopywal-dark" },
				{ name = "Neopywal Light", colorscheme = "neopywal-light" },
				-- Visual Studio Code (askfiy)
				{ name = "VS Code (askfiy)", colorscheme = "visual_studio_code" },
				-- Code Dark
				{ name = "Code Dark", colorscheme = "codedark" },
				-- jb.nvim
				{ name = "JetBrains", colorscheme = "jb" },
				-- Fleet
				{ name = "Fleet", colorscheme = "fleet" },
				-- Farout
				{ name = "Farout", colorscheme = "farout" },
				-- Tender
				{ name = "Tender", colorscheme = "tender" },
				-- Silk Circuit
				{ name = "Silk Circuit", colorscheme = "silkcircuit" },
				-- Boo
				{ name = "Boo", colorscheme = "boo" },
				{ name = "Boo Radioactive", colorscheme = "radioactive_waste" },
				{ name = "Boo Sunset Cloud", colorscheme = "sunset_cloud" },
				{ name = "Boo Crimson Moonlight", colorscheme = "crimson_moonlight" },
				{ name = "Boo Forest Stream", colorscheme = "forest_stream" },
				-- Zephyr
				{ name = "Zephyr", colorscheme = "zephyr" },
				-- Highlite
				{ name = "Highlite", colorscheme = "highlite" },
				{ name = "Highlite Molokai", colorscheme = "highlite-molokai" },
				{ name = "Highlite Iceberg", colorscheme = "highlite-iceberg" },
				-- Cobalt2
				{ name = "Cobalt2", colorscheme = "cobalt2" },
				-- Zenburn
				{ name = "Zenburn", colorscheme = "zenburn" },
				-- Ayu (Luxed)
				{ name = "Ayu (Luxed)", colorscheme = "ayu" },
				-- Aylin
				{ name = "Aylin", colorscheme = "aylin" },
				-- Noctis (talha-akram)
				{ name = "Noctis Minimus", colorscheme = "noctis_minimus" },
				{ name = "Noctis Uva", colorscheme = "noctis_uva" },
				{ name = "Noctis Azureus", colorscheme = "noctis_azureus" },
				{ name = "Noctis Bordo", colorscheme = "noctis_bordo" },
				{ name = "Noctis Obscuro", colorscheme = "noctis_obscuro" },
				{ name = "Noctis Hibernus", colorscheme = "noctis_hibernus" },
				{ name = "Noctis Lilac", colorscheme = "noctis_lilac" },
				{ name = "Noctis Lux", colorscheme = "noctis_lux" },
				{ name = "Noctis Sereno", colorscheme = "noctis_sereno" },
				{ name = "Noctis Viola", colorscheme = "noctis_viola" },
				-- Kyotonight
				{ name = "Kyotonight", colorscheme = "kyotonight" },
				-- Nightly
				{ name = "Nightly", colorscheme = "nightly" },
				-- Humanoid
				{ name = "Humanoid", colorscheme = "humanoid" },
				-- Oasis
				{ name = "Oasis", colorscheme = "oasis" },
				-- Aquarium
				{ name = "Aquarium", colorscheme = "aquarium" },
				-- Eva-01
				{ name = "Eva-01", colorscheme = "eva01" },
				-- Monet
				{ name = "Monet", colorscheme = "monet" },
				-- Synthweave
				{ name = "Synthweave", colorscheme = "synthweave" },
				{ name = "Synthweave Transparent", colorscheme = "synthweave-transparent" },
				-- Kanagawa Paper (thesimonho)
				{ name = "Kanagawa Paper Ink", colorscheme = "kanagawa-paper-ink" },
				{ name = "Kanagawa Paper Canvas", colorscheme = "kanagawa-paper-canvas" },
			},
			livePreview = true,
		},
	},
}
