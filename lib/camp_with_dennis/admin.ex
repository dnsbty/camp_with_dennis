defmodule CampWithDennis.Admin do
  alias CampWithDennis.Repo
  alias CampWithDennis.Admin.User

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def find(id) do
    Repo.get(User, id)
  end
end
