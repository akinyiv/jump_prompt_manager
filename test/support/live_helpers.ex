defmodule PromptManagerWeb.LiveHelpers do
  @moduledoc """
  Test helpers for LiveView tests.
  """

  import Phoenix.LiveViewTest

  @doc """
  Creates a test template with the given attributes.
  """
  def create_test_template(attrs \\ %{}) do
    default_attrs = %{
      id: System.unique_integer([:positive]),
      name: "Test Template",
      body: "Test with [[model]] and [[today]]"
    }

    Map.merge(default_attrs, attrs)
  end

  @doc """
  Sets up test templates in persistent term.
  """
  def setup_templates(templates) when is_list(templates) do
    :persistent_term.put(:templates, templates)
    on_exit(fn -> :persistent_term.erase(:templates) end)
    templates
  end

  @doc """
  Asserts that a flash message is present.
  """
  def assert_flash_message(view, type, message) do
    assert render(view) =~ message
    assert_flash(view, type, message)
  end

  @doc """
  Creates a template through the LiveView interface.
  """
  def create_template_through_form(view, attrs) do
    view |> element("button", "New Template") |> render_click()

    view
    |> element("form")
    |> render_submit(%{
      "name" => attrs.name,
      "body" => attrs.body
    })
  end

  @doc """
  Runs a template through the LiveView interface.
  """
  def run_template(view, model_name) do
    view |> element("button", "Run") |> render_click()

    view
    |> element("#run-modal form")
    |> render_submit(%{"model" => model_name})
  end

  @doc """
  Gets today's date in the format used by the application.
  """
  def today_string do
    Date.utc_today() |> Calendar.strftime("%Y-%m-%d")
  end
end 