defmodule BuscaLargura do
  @moduledoc """
  Implementação de um algoritmo para busca em largura utilizando flat_maps e filtros

  NOTAS:
  - Caso a sequencia seja muito grande, ela pode começar a causar lentidao pois na implementação a rota é adicionada como append, uma solução para este problema é adicionar como prepend e tratar a lista de forma invertida
  - Talvez seja possivel adicionar paralelização neste algoritmo com o Stream em vez do Enum
  """

  @doc """
  Dado um mapa de vertices, buscar o nó mais proximo com o valor x
  NOTA: Se houver 2 nos na mesma distancia, ele trara o caminho para ambos

  ## EXAMPLE

      iex> v = BuscaLargura.seed
      iex> BuscaLargura.melhores_caminhos v, 2
      [[0, 1, 2], [0, 3, 2]]

      iex> v = BuscaLargura.seed
      iex> BuscaLargura.melhores_caminhos(v, 1)
      [[0, 1]]
      iex> BuscaLargura.melhores_caminhos(v, 4)
      [[0, 3, 4]]
  """
  def melhores_caminhos(map, x) do
    caminhos = get_caminhos(map, x)

    menor =
      caminhos
      |> Enum.map(&length/1)
      |> Enum.sort()
      |> List.first()

    caminhos
    |> Enum.filter(fn x -> length(x) == menor end)
  end

  @doc """
  Dado um mapa de vertices, busca todos os caminhos para um valor determinado

  ## EXAMPLE
  
      iex> v = BuscaLargura.seed
      iex> BuscaLargura.get_caminhos(v, 1)
      [[0, 1], [0, 3, 4, 1]]
      iex> BuscaLargura.get_caminhos(v, 4)
      [[0, 3, 4]]
  """
  def get_caminhos(map, x) do
    if is_this?(map, x) do
      [[x]]
    else
      Enum.map(map.children, fn pai -> melhor_caminho(pai, x, [map.value]) end)
      |> Enum.filter(fn l -> length(l) != 0 end)
    end
  end

  defp melhor_caminho(map, x, sequence) do
    new_sequence = sequence ++ [map.value]

    if is_this?(map, x) do
      new_sequence
    else
      Enum.flat_map(map.children, fn pai -> melhor_caminho(pai, x, new_sequence) end)
    end
  end

  defp is_this?(map, x) do
    map.value == x
  end

  ###################
  ### PARA TESTES ###
  ###################
  @doc """
  Para testes, gera uma estrutura basica para ser usada nas funções deste modulo
  """
  def seed() do
    gen_node(0, [
      gen_node(1, [
        gen_node(2, [])
      ]),
      gen_node(3, [
        gen_node(4, [
          gen_node(1, [])
        ]),
        gen_node(2, [])
      ])
    ])
  end

  @doc """
  Gera um nó para este modulo
  (utilizado no seed/0)
  """
  def gen_node(value, children) do
    %{value: value, children: children}
  end
end
