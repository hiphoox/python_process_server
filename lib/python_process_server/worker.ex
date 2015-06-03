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
    IO.puts "Iniciando worker"
    {:ok, pp} = :python.start_link([{:python_path, to_char_list(Path.expand("lib/python_scripts"))},{:python, 'python'}])
    state = {python_module, pp}
    {:ok, state}
  end

  def handle_call({:call_python, function, args}, _from, state) do
    IO.puts "Procesando petición"
    {py_module, py_pid} = state
    result = :python.call(py_pid, py_module, function, args)
    reply = {:ok, result}
    {:reply, reply, state}
  end

  def handle_call(_request, _from, state) do
    IO.puts "Procesando otros mensajes"
    {:stop, :error, :bad_call, state}
  end

  def handle_info(_msg, {module,py_pid}) do
    IO.puts "Adios"
    {:stop, :error, {module,py_pid}}
  end

  def terminate(_reason, {_, py_pid}) do
    IO.puts "Algo salio mal"
    :python.stop(py_pid)
    :ok
  end

end
