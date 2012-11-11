all:
	cat startup/xinitrc >> ${HOME}/.xinitrc
	cp startup/xmonad-startup.sh ${HOME}/bin

help:
	@echo "Set the xinitrc file and copy xmonad-startup.sh to ${HOME}/bin"
	
