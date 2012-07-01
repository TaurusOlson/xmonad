-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config {
    font = "xft:Pragmata-10",
    -- bgColor = "#151515",
    bgColor = "#222222",
    fgColor = "#c3c2c5",
    -- position = Static { xpos = 1920, ypos = 0, width = 1800, height = 16 },
    lowerOnStart = True,
    commands = [
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        -- Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        -- Run Network "eth0" ["-t","Net: <rx>, <tx>","-H","200","-L","10","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Date "%a %b %_d %H:%M" "date" 10,
        Run DiskU [("/", "Disk: <used>/<size>")]
                  ["-L", "20", "-H", "100", "-m", "1", "-p", "3", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    -- template = "%StdinReader% }{  %memory% %disku%  %swap%   %eth0%   <fc=#FFFFCC>%date%</fc>"
    template = "%StdinReader% }{  %memory%    %disku%    <fc=#FFFFCC>%date%</fc>"
}
