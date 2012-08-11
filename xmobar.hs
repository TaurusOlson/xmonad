-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config { font         = "xft:Pragmata-10"
       , bgColor      = "#1f1b18"
       , position     = Top
       , fgColor      = "#c3c2c5"
       , lowerOnStart = True
       , commands     = [
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Date "%a %b %_d %H:%M" "date" 10,
        Run Com "mpd.sh" [] "mpd" 30,
        Run DiskU [("/", "Disk: <used>/<size>")]
                  ["-L", "20", "-H", "100", "-m", "1", "-p", "3", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run StdinReader
        ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ %mpd%    %memory%    %disku%    <fc=#FFFFCC>%date%</fc>"
}
