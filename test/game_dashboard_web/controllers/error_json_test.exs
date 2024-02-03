defmodule GameDashboardWeb.ErrorJSONTest do
  use GameDashboardWeb.ConnCase, async: true

  test "renders 404" do
    assert GameDashboardWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert GameDashboardWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
