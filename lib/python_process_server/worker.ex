defmodule PythonProcessServer.Worker do
  use GenServer

  #############
  # Public  API
  #############
  def start_link(python_module) do
    GenServer.start_link(__MODULE__, python_module, [])
  end

  def call_python(worker, function, args) do
    GenServer.call(worker, {:call_python, function, args})
  end

  ###################
  # Private Functions
  ###################
  def init(python_module) do
    {:ok, pp} = :python.start([{:python_path, to_char_list(Path.expand("lib/python_scripts"))},{:python, 'python'}])
    state = {python_module, pp}
    {:ok, state}
  end

  def handle_call({:call_python, function, args}, _from, state) do
    {py_module, py_pid} = state
    result = :python.call(py_pid, py_module, function, args)
    reply = {:ok, result}
    {:reply, reply, state}
  end

  def handle_call(_request, _from, state) do
    {:stop, :error, :bad_call, state}
  end

  def terminate(_reason, {_, py_pid}) do
    :python.stop(py_pid)
    :ok
  end

end
