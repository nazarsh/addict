defmodule Addict.Repository do
  @moduledoc """
  Addict Repository is responsible for interacting with the DB on the query
  level in order to manipulate user data.
  """
  require Logger

  import Ecto.Query

  @user Application.get_env(:addict, :user)
  @db Application.get_env(:addict, :db)

  @doc """
  Creates a new user on the database with the given parameters.

  It either returns a tuple with `{:ok, user}` or, in case an error
  happens, a tuple with `{:error, error_message}`
  """
  def create(user_params) do
    try do
      user_params = for {key, val} <- user_params, into: %{}, do: {String.to_atom(key), val}
      new_user = @db.insert(struct(@user,user_params))
      {:ok, new_user}
    rescue
      e in Postgrex.Error -> PostgresErrorHandler.handle_error(__MODULE__, e)
    end
  end

  @doc """
  Retrieves a single user from the database based on the user's e-mail.

  It either returns the `user` or, in case an error occurs, a tuple with
  `{:error, error_message}`. If no user exists, `nil` will be returned.
  """
  def find_by_email(email) do
    try do
      query = from u in @user, where: u.email == ^email
      @db.one query
    rescue
      e in Postgrex.Error -> PostgresErrorHandler.handle_error(__MODULE__, e)
    end
  end

end
