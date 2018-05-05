defmodule CampWithDennisWeb.Router do
  use CampWithDennisWeb, :router
  import CampWithDennisWeb.Verification
  alias CampWithDennisWeb.Redirect

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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
      get "/index", AdminController, :index
    end

    scope "/rsvp" do
      pipe_through :verified

      post "/accept", RsvpController, :accept
      post "/decline", RsvpController, :decline
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
  end
end
