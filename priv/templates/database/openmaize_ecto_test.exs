defmodule <%= base %>.OpenmaizeEctoTest do
  use ExUnit.Case
  use Plug.Test

  alias <%= base %>.{OpenmaizeEcto, Repo, User}

  test "easy password results in an error being added to the changeset" do
    user = %{email: "bill@mail.com", username: "bill", password: "123456",
             phone: "081655555", confirmed_at: Ecto.DateTime.utc}
    {:error, changeset} = %User{}<%= if confirm do %>
                          |> User.auth_changeset(user, "lg8UXGNMpb5LUGEDm62PrwW8c20qZmIw")<% else %>
                          |> User.auth_changeset(user)<% end %>
                          |> Repo.insert
    errors = changeset.errors[:password] |> elem(0)
    assert errors =~ "password is too short"
  end<%= if confirm do %>

  test "add_confirm_token" do
    user = Map.merge(%User{},
                     %{username: "bill", confirmation_token: nil, confirmation_sent_at: nil})
    changeset = OpenmaizeEcto.add_confirm_token(user, "lg8UXGNMpb5LUGEDm62PrwW8c20qZmIw")
    assert changeset.changes.confirmation_token
    assert changeset.changes.confirmation_sent_at
  end

  test "add_reset_token" do
    user = Map.merge(%User{},
                     %{email: "reg@mail.com", username: "reg", password: "h4rd2gU3$$",
                       phone: "081755555", confirmed_at: Ecto.DateTime.utc})
    changeset = OpenmaizeEcto.add_reset_token(user, "lg8UXGNMpb5LUGEDm62PrwW8c20qZmIw")
    assert changeset.changes.reset_token
    assert changeset.changes.reset_sent_at
  end<% end %>

  test "check time" do
    assert OpenmaizeEcto.check_time(Ecto.DateTime.utc, 60)
    refute OpenmaizeEcto.check_time(Ecto.DateTime.utc, -60)
    refute OpenmaizeEcto.check_time(nil, 60)
  end

end
