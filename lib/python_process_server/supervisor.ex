defmodule PythonProcessServer.Supervisor do
  use Supervisor

  def start_link({python_module, num_processes}) do
    Supervisor.start_link(__MODULE__, {python_module, num_processes})
  end

  def init({python_module, num_processes}) do
    pool_options = [
      name: {:local, :python_pool},
      worker_module: PythonProcessServer.Worker,
      size: num_processes,
      max_overflow: num_processes * 2
    ]

    children = [
      :poolboy.child_spec(:python_pool, pool_options, python_module)
    ]

    supervise(children, strategy: :one_for_all, max_restarts: 1000, max_seconds: 3600)
  end

end
