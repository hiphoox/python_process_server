defmodule PythonProcessServer do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    PythonProcessServer.Supervisor.start_link({:pymath, 2})
  end
end
