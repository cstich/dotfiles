{pkgs, ...}:

# Setup font rendering
{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      xorg.fontbh100dpi
      xorg.fontmiscmisc
      xorg.fontcursormisc
      ubuntu_font_family
      powerline-fonts
      corefonts 
      liberation_ttf
      overpass
      siji 
      fira
      nerdfonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      roboto-slab
    ];
    fontconfig = {
      hinting.autohint = true;
      useEmbeddedBitmaps = true;
      defaultFonts.serif = ["Source Serif Pro"];
      defaultFonts.sansSerif = [ "Fira Sans" ];
      defaultFonts.monospace = [ "FuraCode Nerd Font Mono" ];
    };
  };
}

