defmodule GameDashboardWeb.Riot.LolController do
  use GameDashboardWeb, :controller

  def get_summoner(conn, %{"name" => name}) do
    case GameDashboard.Lol.get_summoner_by_name(name) do
      {:ok, body} -> conn |> put_status(200) |> json(body)
      {:error, reason} -> conn |> put_status(404) |> json(reason)
    end
  end

  def get_summoner_matches(conn, %{"puuid" => puuid}) do
    case GameDashboard.Lol.get_summoner_matches_by_puuid(puuid) do
      {:ok, body} -> conn |> put_status(200) |> json(body)
      {:error, reason} -> conn |> put_status(404) |> json(reason)
    end
  end

  def get_match(conn, %{"id" => id}) do
    case GameDashboard.Lol.get_match_by_id(id) do
      {:ok, body} -> conn |> put_status(200) |> json(body)
      {:error, reason} -> conn |> put_status(404) |> json(reason)
    end
  end

  def get_summoner_total_data(conn, %{"puuid" => puuid}) do
    conn |> put_status(200) |> json(GameDashboard.Lol.get_summoner_total_data(puuid))
  end

end
