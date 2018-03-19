# CampWithDennis
![Camping is Fun!](https://user-images.githubusercontent.com/3421625/37573274-b067baf6-2adb-11e8-8410-56f729c18d2a.gif)

CampWithDennis is an app to power one-off event websites. It's built in Elixir on the Phoenix Framework.

## Running the server

1. Make sure you have [Elixir 1.5 and OTP 20 installed](https://elixir-lang.org/install.html)
2. Clone the repo onto your local machine: `git clone git@github.com:dnsbty/camp_with_dennis.git`
3. Install the project's dependencies: `cd bull-server && mix deps.get`
4. Create and migrate the database: `mix ecto.create && mix ecto.migrate`
5. Start the server: `mix phx.server`

Now you can connect to [`localhost:2267`](http://localhost:2267)
