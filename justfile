install:
  nix build
  sudo cp "$(pwd)/result/bin/dwm" /usr/bin/dwm
  sudo cp ./dwm.desktop /usr/share/xsessions/dwm.desktop
  sudo cp ./autostart.sh /usr/bin/autostart.sh

  
