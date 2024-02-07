defmodule GameDashboard.Lol do

  def make_request(url) do
    token = Application.fetch_env!(:game_dashboard, :riot_api_key)

    HTTPoison.start()
    case HTTPoison.get(url <> "?api_key=#{token}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode!(body)}
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        %{"status" => %{"message" => message}} = Poison.decode!(body)
        {:error, message}
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        {:ok, "Not found"}
      {:ok, %HTTPoison.Response{status_code: 429, body: body}} ->
        %{"status" => %{"message" => message}} = Poison.decode!(body)
        {:error, message}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def get_summoner_by_name(name) do
    make_request("https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{name}")
  end

  def get_summoner_matches_by_puuid(puuid) do
    make_request("https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids")
  end

  def get_match_by_id(id) do
    make_request("https://americas.api.riotgames.com/lol/match/v5/matches/#{id}")
  end

  def get_summoner_total_data(puuid) do
    {:ok, matches} = get_summoner_matches_by_puuid(puuid)
    get_summoner_data(matches, puuid)
      |> select_fields()
      |> merge_data()
  end

  def get_summoner_data(matches, puuid) do
    Enum.map(matches, fn matchInstance ->
      {:ok, %{"info" => %{"participants" => participants}}} = get_match_by_id(matchInstance)
      [summoner_data] = Enum.filter(participants, fn x -> x["puuid"] == puuid end)
      summoner_data
    end)
  end

  def select_fields(summoner_data_array) do
    Enum.map(summoner_data_array, fn map ->
      Map.take(map, ["kills", "totalDamageDealt", "assists", "goldEarned", "visionScore"])
    end)
  end

  def merge_data(summoner_data_array) do
    Enum.reduce(summoner_data_array, %{}, fn map, acc ->
      Map.merge(acc, map, fn _, val1, val2 -> val1 + val2 end)
    end)
  end
end
