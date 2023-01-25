{ pkgs, config, lib, ... }:

let
  skinFile = config.lib.stylix.colors {
    templateRepo = pkgs.fetchFromGitHub {
      owner = "krgn";
      repo = "base16-k9s";
      rev = "930124928781551c696a8a08695e6e577adff441";
      sha256 = "Bs/RFm6jRPMNQH36iqlLdgqj0nzy34mUAWP67cBnWug=";
    };
  };

  yaml2attrs = yaml: builtins.fromJSON (builtins.readFile (pkgs.stdenv.mkDerivation {
    name = "fromYAML";
    phases = [ "buildPhase" ];
    buildPhase = "${pkgs.yaml2json}/bin/yaml2json < ${yaml} > $out";
  }));

  skinAttrs = yaml2attrs skinFile;


in {
  options.stylix.targets.k9s.enable =
    config.lib.stylix.mkEnableTarget "k9s" true;

  config = lib.mkIf config.stylix.targets.k9s.enable {

    home-manager.sharedModules = [{
      programs.k9s.skin = skinAttrs;
    }];
  };
}
