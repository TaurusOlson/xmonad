-------------------------------------------------------------------------------
-- Taurus Olson's Xmonad config 
--
-- inspired by Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config
-------------------------------------------------------------------------------
 

import System.IO
import System.Exit
import XMonad hiding ( (|||) )

-- Config
import XMonad.Config.Azerty

-- Prompt
import XMonad.Prompt

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.Place

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.LayoutCombinators 
import XMonad.Layout.ResizableTile 
import XMonad.Layout.Grid 
import XMonad.Layout.PerWorkspace (onWorkspace)

-- Utilities
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Scratchpad 

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Graphics.X11.ExtraTypes.XF86

-- Actions
import XMonad.Actions.GridSelect
import XMonad.Actions.CopyWindow (copyToAll, killAllOtherCopies)

------------------------------------------------------------------------
-- Terminal
------------------------------------------------------------------------

myTerminal = "/usr/bin/urxvt -e /usr/bin/zsh"

------------------------------------------------------------------------
-- Workspaces
------------------------------------------------------------------------

myWorkspaces = ["1:term","2:web","3:code","4:games","5:media"]
 
------------------------------------------------------------------------
-- Window rules
------------------------------------------------------------------------

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.

myManageHook = (composeAll . concat $
    [ [ className =? w --> doShift "2:web"   | w <- web    ]
    , [ className =? e --> doShift "3:code"  | e <- editor ]
    , [ className =? v --> doShift "5:media" | v <- viewer ]
    , [ resource  =? "desktop_window" --> doIgnore
    , title =? "mutt" --> doShift "5:media"
    , isFullscreen    --> (doF W.focusDown <+> doFullFloat)
    , isDialog        --> doCenterFloat
    ]])
    where
        web    = ["Firefox", "Uzbl"]  
        viewer = ["Evince", "Gthumb", "Nitrogen"]
        editor = ["Gedit"]

-- <+> manageScratchPad

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
    where
        h = 0.35    -- height
        w = 0.375   -- width
        t = 0.1   -- distance from top edge
        l = 0.6   -- distance from left edge
myScratchPad = scratchpadSpawnActionCustom "urxvt -name scratchpad -e /usr/bin/zsh"

------------------------------------------------------------------------
-- Layouts
------------------------------------------------------------------------

-- myLayout = avoidStruts $
--     tiled        |||
--     tabs         |||
--     Mirror tiled |||
--     Circle       |||
--     Grid         |||
--     Full
--     where 
--         tiled   = ResizableTall nmaster delta ratio []
--         nmaster = 1
--         delta   = 3/100
--         ratio   = 1/2
--         tabs    = tabbed shrinkText tabConfig 

myLayout = smartBorders $ avoidStruts $
    onWorkspace "1:term"  (tiled ||| Grid) $
    onWorkspace "2:web"   (Full ||| Grid ||| tiled) $ 
    onWorkspace "3:code"  (Grid ||| Full) $
    onWorkspace "4:games" (Mirror tiled ||| Full) $
    onWorkspace "5:media" (Full ||| tiled) $ Full
    where 
      tiled   = ResizableTall nmaster delta ratio []
      nmaster = 1
      delta   = 3/100
      ratio   = 1/2

------------------------------------------------------------------------
-- Colors and borders
------------------------------------------------------------------------

myNormalBorderColor  = "#151515"
-- myFocusedBorderColor = "#98a7b6"
myFocusedBorderColor = "#CEFFAC"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor   = "#7C7C7C",
    activeTextColor     = "#CEFFAC",
    activeColor         = "#555555",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor   = "#222222",
    inactiveColor       = "#000000",
    fontName            = "terminus"
}

xmobarTitleColor = "#FFB6B0"
xmobarCurrentWorkspaceColor = "#CEFFAC"

-- Width of the window border in pixels.
myBorderWidth = 3

------------------------------------------------------------------------
-- Key bindings
------------------------------------------------------------------------

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.

myModMask = mod4Mask

myMusicPlayer = "/usr/bin/urxvt -e /usr/bin/ncmpcpp"
 
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  ----------------------------------------------------------------------

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

  -- Use this to launch programs without a key binding.
  , ((modMask .|. shiftMask, xK_m), spawn myMusicPlayer)

  -- Use this to launch programs without a key binding.
  , ((modMask, xK_p), spawn "dmenu-xmonad")

  -- Take a screenshot in select mode.
  -- After pressing this key binding, click a window, or draw a rectangle with
  -- the mouse.
  , ((modMask .|. shiftMask, xK_p), spawn "select-screenshot")

  -- Take full screenshot in multi-head mode.
  -- That is, take a screenshot of everything you see.
  , ((modMask .|. controlMask .|. shiftMask, xK_p), spawn "screenshot")

  -- Mute volume.
  -- , ((0, 0x1008FF12), spawn "amixer -q set Front toggle")

  -- Decrease volume.
  , ((0, 0x1008FF11), spawn "amixer -q set Front 10%-")

  -- Increase volume.
  , ((0, 0x1008FF13), spawn "amixer -q set Front 10%+")
  -- , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Front 10%+")

  -- Audio previous.
  -- , ((0, 0x1008FF16), spawn "")

  -- Play/pause.
  -- , ((0, 0x1008FF14), spawn "")

  -- Audio next.
  -- , ((0, 0x1008FF17), spawn "")

  -- Eject CD tray.
  -- , ((0, 0x1008FF2C), spawn "eject -T")

  -- Increase brightness
  , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight +20")

  -- Decrease brightness
  , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -20")

  -- Close focused window.
  , ((modMask, xK_w), kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.  
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n), refresh)

  -- Move focus to the next window.
  , ((modMask, xK_Tab), windows W.focusDown)

  -- Move focus to the next/previous/master window.
  , ((modMask, xK_j), windows W.focusDown)
  , ((modMask, xK_k), windows W.focusUp  )
  , ((modMask, xK_m), windows W.focusMaster  )
  -- Swap the focused window and the master window.
  , ((modMask, xK_Return), windows W.swapMaster)

  -- Swap the focused window with the next/previous window.
  , ((modMask .|. shiftMask, xK_j), windows W.swapDown  )
  , ((modMask .|. shiftMask, xK_k), windows W.swapUp    )

  -- Shrink/expand the master area.
  , ((modMask, xK_h), sendMessage Shrink)
  , ((modMask, xK_l), sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t), withFocused $ windows . W.sink)

  -- Increment/decrement the number of windows in the master area.
  , ((modMask, xK_i), sendMessage (IncMasterN 1))
  , ((modMask, xK_d), sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q), restart "xmonad" True)
 
  -- Display and select workspaces in a grid
  , ((modMask .|. shiftMask, xK_g), goToSelected defaultGSConfig)
 
  -- Display and select applications in a grid
  -- , ((modMask, xK_s), spawnSelected defaultGSConfig ["urxvt", "firefox"])
 
  -- Jump to given layouts with LayoutCombinators 
  , ((modMask, xK_r), sendMessage $ JumpToLayout "ResizableTall")
  , ((modMask, xK_f), sendMessage $ JumpToLayout "Full")
  , ((modMask, xK_g), sendMessage $ JumpToLayout "Grid")

  -- Shrink/expand vertically a window
  , ((modMask, xK_s), sendMessage MirrorShrink)
  , ((modMask, xK_e), sendMessage MirrorExpand)

  -- Spawn a scratchpad terminal
  -- , ((modMask .|. shiftMask, xK_t), scratchpadSpawnAction defaultConfig {terminal = myTerminal})
  , ((modMask .|. shiftMask, xK_t), myScratchPad)

  -- Make focused window always visible
  , (( modMask, xK_v), windows copyToAll)

  -- Toggle window state back
  , (( modMask .|. shiftMask, xK_v), killAllOtherCopies)
  ]

  ++
 
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      -- | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      | (i, k) <- zip (XMonad.workspaces conf) [0x26, 0xe9, 0x22, 0x27, 0x28, 0x2d, 0xe8, 0x5f, 0xe7]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  -- ++

  -- -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  -- [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
  --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
  --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
 
------------------------------------------------------------------------
-- Mouse bindings
------------------------------------------------------------------------

-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
 
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask .|. controlMask, button1), (\w -> focus w >> windows W.swapMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask .|. shiftMask, button1), (\w -> focus w >> mouseResizeWindow w))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]
 
------------------------------------------------------------------------
-- Startup hook
------------------------------------------------------------------------

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.

myStartupHook = return ()

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
------------------------------------------------------------------------

main = do
  -- xmproc <- spawnPipe "~/.cabal/bin/xmobar ~/.xmonad/xmobar.hs"
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
  xmonad $ defaults {
      logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 30
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "}
      , manageHook = manageScratchPad <+> myManageHook <+> manageDocks
      , startupHook = setWMName "LG3D"
  }
 
------------------------------------------------------------------------
-- Combine it all together
------------------------------------------------------------------------

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
 
    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,
 
    -- hooks, layouts
    layoutHook         = myLayout,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}
