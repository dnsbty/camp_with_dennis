defmodule CampWithDennisWeb.Router do
  use CampWithDennisWeb, :router
  use Honeybadger.Plug
  import CampWithDennisWeb.Verification

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :ensure_admin
    plug :put_layout, {CampWithDennisWeb.LayoutView, :admin}
  end

  pipeline :verified do
    plug :ensure_verified
  end

  pipeline :unverified do
    plug :ensure_unverified
  end

  scope "/", CampWithDennisWeb do
    pipe_through :browser

    scope "/admin" do
      pipe_through :admin

      scope "/invitations" do
        get "/", InvitationsController, :index
        get "/accepted", InvitationsController, :accepted
        get "/declined", InvitationsController, :declined
        get "/new", InvitationsController, :new
        post "/create", InvitationsController, :create
        put "/:invitation_id/sent", InvitationsController, :sent
      end

      scope "/payments" do
        get "/:invitation_id", PaymentsController, :new
        put "/:invitation_id", PaymentsController, :save
      end

      get "/", Redirect, to: "/admin/invitations"
    end

    scope "/rsvp" do
      pipe_through :verified

      post "/accept", RsvpController, :accept
      get "/accepted", RsvpController, :accepted
      post "/decline", RsvpController, :decline
      get "/declined", RsvpController, :declined
      post "/size", RsvpController, :size
      get "/pay", RsvpController, :pay

      get "/", RsvpController, :index
    end

    scope "/" do
      pipe_through :unverified

      post "/code", PhoneController, :code
      post "/verify", PhoneController, :verify
      get "/", PhoneController, :index
    end

    get "/logout", PhoneController, :logout
  end
end
