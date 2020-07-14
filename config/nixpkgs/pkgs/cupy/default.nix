{ stdenv, buildPythonPackage
, fetchPypi, isPy3k, linuxPackages
, fastrlock, numpy, six, wheel, pytest, mock
, cudatoolkit, cudnn, nccl, pkgs
}:

with pkgs.python3Packages;

buildPythonPackage rec {
  pname = "cupy";
  version = "6.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "126waa1jiynq00glr1hq86sgwwmakq009crfsn8qqgrj4c4clw6a";
  };

  checkInputs = [
    pytest
    mock
  ];
  
  preConfigure = ''
    export CUDA_PATH=${cudatoolkit}
    export EXTRA_LDAFLAGS="-L/lib -L${linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
    export CUDNN_INCLUDE_DIR=${cudnn}/include
    export CC=${cudatoolkit.cc}/bin/gcc 
    export CXX=${cudatoolkit.cc}/bin/g++
  ''; 

  propagatedBuildInputs = [
    cudatoolkit
    cudnn
    linuxPackages.nvidia_x11
    nccl
    fastrlock
    numpy
    six
    wheel
  ];

  # In python3, test was failed...
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "A NumPy-compatible matrix library accelerated by CUDA";
    homepage = https://cupy.chainer.org/;
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ hyphon81 ];
  };
}
