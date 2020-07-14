{
  mkDerivation, lib, makeWrapper,
  extra-cmake-modules, kdoctools,
  kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kguiaddons,
  ki18n, kiconthemes, kinit, kdelibs4support, kio, knotifications,
  mkDerivation {
    kbookmarks kcompletion kconfig kconfigwidgets kcoreaddons kdelibs4support
    kguiaddons ki18n kiconthemes kinit kio knotifications knotifyconfig kparts kpty
    kservice ktextwidgets kwidgetsaddons kwindowsystem kxmlgui qtscript knewstuff
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/konsole --prefix XDG_DATA_DIRS ":" $out/share
  '';

  propagatedUserEnvPkgs = [ (lib.getBin kinit) ];
}
