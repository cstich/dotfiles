[
(self: super: {
  # Try to force the newest CUDA version everywhere
  # cudatoolkit = super.cudnn_cudatoolkit_11_0;
  # cudnn_cudatoolkit = super.cudnn_cudatoolkit_11;
  # nccl = super.nccl_cudatoolkit_11;

  julia = super.callPackage ./pkgs/julia/default.nix { };
  julia_14 = super.callPackage ./pkgs/julia_14 { };
  julia_15 = super.callPackage ./pkgs/julia_15 { };
  julia_16 = super.callPackage ./pkgs/julia_16 { };
  julia-shell = super.callPackage ./pkgs/julia-shell/default.nix { };
  julia_stable = super.callPackage ./pkgs/julia_stable/default.nix { };
  # jdk = super.jdk14;
  })
]


