# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"{@9JSD.@7or`IhNh[;HC]^7A%6.C$7Jy.1mGO~bDHBt(9Su}LSikK~3)bn0v?=Ge"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"pS=6mIv2``*TNBf6?90P<Qa&Ym}Synv;YBsveh1>f%U`u^_8/X;gq>WnPNS6{3|D"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :camp_with_dennis do
  set version: current_version(:camp_with_dennis)
  set applications: [
    :parse_trans,
    :runtime_tools
  ]

  set commands: [
    "seed": "rel/commands/seed.sh",
    "migrate": "rel/commands/migrate.sh",
    "rollback": "rel/commands/rollback.sh",
  ]
end
