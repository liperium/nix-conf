{ godot_4
, callPackage
, mkNugetDeps
, mkNugetSource
, mono
, dotnet-sdk
, writeText
}:

godot_4.overrideAttrs (self: base: {
  pname = "godot4-mono";

  godotBuildDescription = "mono build";

  nativeBuildInputs = base.nativeBuildInputs ++ [ mono dotnet-sdk ];

  nugetDeps = mkNugetDeps { name = "deps"; nugetDeps = import ./deps.nix; };

  nugetSource =
    mkNugetSource {
      name = "${self.pname}-nuget-source";
      description = "A Nuget source with dependencies for ${self.pname}";
      deps = [ self.nugetDeps ];
    };

  nugetConfig = writeText "NuGet.Config" ''
    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
      <packageSources>
        <add key="${self.pname}-deps" value="${self.nugetSource}/lib" />
      </packageSources>
    </configuration>
  '';

  sconsFlags = base.sconsFlags ++ [
    "module_mono_enabled=true"
    "mono_prefix=${mono}"
  ];

  shouldConfigureNuget = true;

  postConfigure = ''
    echo "Setting up buildhome."
    mkdir buildhome
    export HOME="$PWD"/buildhome

    if [ -n "$shouldConfigureNuget" ]; then
      echo "Configuring NuGet."
      mkdir -p ~/.nuget/NuGet
      ln -s "$nugetConfig" ~/.nuget/NuGet/NuGet.Config
    fi
  '';

  installedGodotShortcutFileName = "org.godotengine.GodotMono4.desktop";
  installedGodotShortcutDisplayName = "Godot Engine 4 (Mono)";

  passthru = {
    make-deps = callPackage ./make-deps.nix {};
  };
})