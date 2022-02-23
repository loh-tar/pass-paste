## pass-paste: an extension for pass - paste passwords by mouse without clipboard

This extension to [pass: the standard unix password manager](https://www.passwordstore.org)
could best be described as a better version of the `pass -c` option/command.

Whereas `pass -c` uses the clipboard, does this extension use `xdotool`, `xprop` and `xwininfo`.

The benefits are:

- No hurry is needed because the clipboard may be cleared before you are ready
- No dbus involved, which was indeed the trigger to write this extension
- No worry if the clipboard kept the secrets due to some malfunction
- No unneeded exposure of secrets to each application or listeners, like KDE-Connect

To be honest, this solution doesn't work as best as it could. Best would be to *"paste"* by
middle mouse button, just as usual. But `xprop`, which is used to select the target window,
doesn't have an option `-button` like `xkill`. This limitation is more bothersome than expected.

## Usage

Run `pass paste` instead of `pass -c`. The secrets will be *"copied "* into the window where you next
click with the mouse, no matter with which button. So, the only thing you have to care for, don't
click the wrong window. Consequently you can't use some task bar to switch to to desired window.

### Requirements

  - Xorg
  - pass
  - xdotool
  - xwininfo
  - xprop

## Installation

### ArchLinux

You can find pass-paste in [AUR](https://aur.archlinux.org/packages/pass-paste)

### Manually

- Get and extract the source
- `cd` into the tree
- `sudo make install`
- For best user experience ensure the `bash` completion file `pass-paste.bash` will be sourced when
a shell is invoked. Depending on your configuration, this may happen automatically or you may need
to add an entry to your *bashrc*
- Ensure the *Requirements* are available on your system

## License

    pass-paste: an extension for pass: the standard unix password manager

    Copyright (C) 2022 loh.tar@googlemail.com

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

## TODO/BUGS

- Find a way to paste with the middle mouse button and make sure that clicking windows with the
left/right button does not cancel the current operation
- No man page yet
- No -h/--help option is provided
- No shell completion other than bash is supported yet, at least nothing was done to support other
- No Wayland support, at least I guess so
- Only tested on ArchLinux with KDE/Plasma, please report when it works for you on another system

## Thanks To

- pass-update where I shamelessly nicked their Makefile and I could study how such pass-extension
has to be done
- stackoverflow.com, stackexchange.com for their great knowledge base
- dict.cc and deepl.com without which my english would be even worse
- github.com for kindly hosting
- Mom&Dad and archlinux.org

## Release History

### Patch version v0.8.1, Feb 2022

  - a58cb89 - Suppress rare error message when bring window to front

### Very first version was v0.8, Feb 2022

  - Hello World!
  - We start with 0.8 because it's feature complete, except the flaws noted at TODO/BUGS.
  - Version 1.0 should support Wayland and at least zsh shell completion
