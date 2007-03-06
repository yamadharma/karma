-- look_dusky.lua drawing engine configuration file for Ion.

--if not gr.select_engine("xftde") then return end

--xftde.reset()
de.reset()

mainfont = "xft: Sans-8"
boldfont = "xft: Sans-8:weight=bold"
bigfont = "xft: Sans-14"
bigboldfont = "xft: Sans-14:weight=bold"

-- basic style

xftde.defstyle("*", {
    shadow_colour = "#404040",
    highlight_colour = "#707070",
    background_colour = "#505050",
    foreground_colour = "#a0a0a0",
    padding_pixels = 0,
    highlight_pixels = 2,
    shadow_pixels = 2,
    font = boldfont,
    text_align = "left",
})

xftde.defstyle("frame", {
    based_on = "*",
    background_colour = "#000000",
    foreground_colour = "#ffffff",
    padding_pixels = 0,
    highlight_pixels = 0,
    shadow_pixels = 0,
    bar_inside_border = "false",
})

xftde.defstyle("frame-tiled", {
    based_on = "frame",
--    border_style = "inlaid",
    padding_pixels = 0,
    spacing = 2,
})

xftde.defstyle("frame-floating", {
    based_on = "frame",
    border_style = "ridge"
})

xftde.defstyle("tab", {
    based_on = "*",
    font = boldfont,
    padding_colour = "#563838",
    xftde.substyle("active-selected", {
        shadow_colour = "#452727",
        highlight_colour = "#866868",
        background_colour = "#664848",
        foreground_colour = "#ffffff",
		font = boldfont,
    }),
    xftde.substyle("active-unselected", {
        shadow_colour = "#351818",
        highlight_colour = "#765858",
        background_colour = "#563838",
        foreground_colour = "#a0a0a0",
	font = basefont,
    }),
    xftde.substyle("inactive-selected", {
        shadow_colour = "#404040",
        highlight_colour = "#909090",
        background_colour = "#606060",
        foreground_colour = "#a0a0a0",
	font = boldfont,
    }),
    xftde.substyle("inactive-unselected", {
        shadow_colour = "#404040",
        highlight_colour = "#707070",
        background_colour = "#505050",
        foreground_colour = "#a0a0a0",
	font = boldfont,
    }),
    text_align = "left",

})

xftde.defstyle("tab-frame", {
    based_on = "tab",
    xftde.substyle("*-*-*-*-activity", {
        shadow_colour = "#404040",
        highlight_colour = "#707070",
        background_colour = "#990000",
        foreground_colour = "#eeeeee",
    }),
})

xftde.defstyle("tab-frame-tiled", {
    based_on = "tab-frame",
    spacing = 1,
})

xftde.defstyle("tab-menuentry", {
    based_on = "tab",
    text_align = "left",
    highlight_pixels = 0,
    shadow_pixels = 0,
    font = boldfont,
})

xftde.defstyle("tab-menuentry-big", {
    based_on = "tab-menuentry",
    font = mainfont,
    padding_pixels = 7,
})

xftde.defstyle("input-edln", {
    based_on = "*",
    shadow_colour = "#666666",
    highlight_colour = "#666666",
    background_colour = "#444444",
    padding_colour = "#444444",
    foreground_colour = "#ffffff",
    border_style = "elevated",
	text_align = "right",
	padding_pixels = 5,
	shadow_pixels = 2,
	highlight_pixels = 2,
    xftde.substyle("*-cursor", {
        foreground_colour = "#ffffff",
    }),
--    xftde.substyle("*-selection", {
--        background_colour = "#505050",
--        foreground_colour = "#ffffff",
--    }),
})

xftde.defstyle("input-menu", {
    based_on = "*",
    xftde.substyle("active", {
        shadow_colour = "#452727",
        highlight_colour = "#866868",
        background_colour = "#664848",
        foreground_colour = "#ffffff",
    }),
})

xftde.defstyle("stdisp", {
    based_on = "*",
    shadow_pixels = 0,
    highlight_pixels = 0,
    border_style = "groove",
    background_colour = "#444444",
    foreground_colour = "#ffffff",
	padding_pixels = 2,
	shadow_pixels = 2,
	highlight_pixels = 2,
    text_align = "left",
    font = boldfont,
	outline_style = "none",
})

gr.refresh()

