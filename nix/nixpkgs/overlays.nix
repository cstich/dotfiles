[
(self: super: {
  cudatoolkit = super.cudatoolkit_10;
  cudnn_cudatoolkit = super.cudnn_cudatoolkit_10;
  julia = super.callPackage ./pkgs/julia/default.nix { };
  julia_14 = super.callPackage ./pkgs/julia_14 { };
  julia_15 = super.callPackage ./pkgs/julia_15 { };
  })
]
