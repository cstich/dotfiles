{pkgs, ...}:

let
    unstable = import <nixos-unstable> {};
in
{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      xorg.fontbh100dpi
      xorg.fontmiscmisc
      xorg.fontcursormisc
      ubuntu_font_family
      powerline-fonts
      font-awesome
      corefonts 
      liberation_ttf
      overpass
      siji 
      fira
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka" "IosevkaTerm"]; })
      source-code-pro
      source-sans-pro
      source-serif-pro
      roboto-slab
    ];
    fontconfig = {
      hinting.autohint = true;
      useEmbeddedBitmaps = true;
      defaultFonts.serif = [ "Source Serif Pro" ];
      defaultFonts.sansSerif = [ "Fira Sans" ];
      defaultFonts.monospace = [ "IosevkaTerm Nerd Font Mono" ];
    };
  };
}

