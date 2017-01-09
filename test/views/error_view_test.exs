defmodule Peep.ErrorViewTest do
  use Peep.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(Peep.ErrorView, "404.json", []) ==
           %{"errors" => [%{code: 500, title: "Internal Server Error"}], "jsonapi" => %{"version" => "1.0"}}
  end

  test "render 500.json" do
    assert render(Peep.ErrorView, "500.json", []) ==
            %{"errors" => [%{code: 500, title: "Internal Server Error"}], "jsonapi" => %{"version" => "1.0"}}
  end

  test "render any other" do
    assert render(Peep.ErrorView, "505.json", []) ==
           %{"errors" => [%{code: 500, title: "Internal Server Error"}], "jsonapi" => %{"version" => "1.0"}}
  end
end
