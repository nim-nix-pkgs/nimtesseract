{
  description = ''A wrapper to Tesseract OCR library for Nim'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-nimtesseract-master.flake = false;
  inputs.src-nimtesseract-master.ref   = "refs/heads/master";
  inputs.src-nimtesseract-master.owner = "DavideGalilei";
  inputs.src-nimtesseract-master.repo  = "nimtesseract";
  inputs.src-nimtesseract-master.type  = "github";
  
  inputs."pixie".owner = "nim-nix-pkgs";
  inputs."pixie".ref   = "master";
  inputs."pixie".repo  = "pixie";
  inputs."pixie".dir   = "5_0_1";
  inputs."pixie".type  = "github";
  inputs."pixie".inputs.nixpkgs.follows = "nixpkgs";
  inputs."pixie".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-nimtesseract-master"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-nimtesseract-master";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}