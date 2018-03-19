# CampWithDennis
![Camping is Fun!](https://user-images.githubusercontent.com/3421625/37573274-b067baf6-2adb-11e8-8410-56f729c18d2a.gif)

CampWithDennis is an app to power one-off event websites. It's built in Elixir on the Phoenix Framework.

## RSVP Flow
These are the steps that a user will go through when RSVPing. Once all boxes are checked, v1 of the application will be complete.

- [ ] When a user lands on the site, they will be able to view all the pertinent information about the camping trip.
- [ ] When the user clicks one of the big RSVP buttons, they will be prompted to connect with Facebook.
- [ ] Connecting with Facebook will check whether or not they were one of the users who received an invitation.
- [ ] If they received an invitation, they will be allowed to select whether or not they plan to attend.
- [ ] If they choose to attend, they will be asked to provide their tshirt size.
- [ ] After providing their tshirt size, they will be asked to send Dennis the cost on venmo.
- [ ] Once they return to the site after having sent the venmo, they will be told they'll receive a confirmation text once the venmo is confirmed.
- [ ] Dennis will enter the venmo confirmation in the admin panel, and that will send them the confirmation text.

## Running the server

1. Make sure you have [Elixir 1.5 and OTP 20 installed](https://elixir-lang.org/install.html)
2. Clone the repo onto your local machine: `git clone git@github.com:dnsbty/camp_with_dennis.git`
3. Install the project's dependencies: `cd bull-server && mix deps.get`
4. Create and migrate the database: `mix ecto.create && mix ecto.migrate`
5. Start the server: `mix phx.server`

Now you can connect to [`localhost:2267`](http://localhost:2267)
