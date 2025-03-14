defmodule PromptManagerWeb.TemplateLiveTest do
  use PromptManagerWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "mount" do
    test "renders page with empty templates initially", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")
      assert html =~ "AI Prompt Templates"
      assert view |> element("div.grid") |> has_element?()
    end

    test "loads existing templates from persistent term", %{conn: conn} do
      template = %{id: 1, name: "Test Template", body: "Test with [[model]] and [[today]]"}
      :persistent_term.put(:templates, [template])
      
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "Test Template"
      assert html =~ "Test with [[model]] and [[today]]"
      
      :persistent_term.erase(:templates)
    end
  end

  describe "template creation" do
    test "shows template form on new template button click", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      
      assert view 
             |> element("button", "New Template") 
             |> render_click() =~ "Create New Template"
    end

    test "validates template name length", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      
      view |> element("button", "New Template") |> render_click()
      
      assert view
             |> element("form")
             |> render_submit(%{
               "name" => "ab",
               "body" => "Test template with [[model]]"
             }) =~ "Template name must be at least 3 characters long"
    end

    test "validates template body placeholders", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      
      view |> element("button", "New Template") |> render_click()
      
      assert view
             |> element("form")
             |> render_submit(%{
               "name" => "Valid Name",
               "body" => "Test template without placeholders"
             }) =~ "Template must contain at least one placeholder"
    end

    test "creates template with valid input", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      
      view |> element("button", "New Template") |> render_click()
      
      {:ok, view, _html} = view
                          |> element("form")
                          |> render_submit(%{
                            "name" => "Valid Template",
                            "body" => "Test with [[model]] and [[today]]"
                          })
                          |> follow_redirect(conn)
      
      assert render(view) =~ "Valid Template"
      assert render(view) =~ "Test with [[model]] and [[today]]"
      
      :persistent_term.erase(:templates)
    end
  end

  describe "template processing" do
    setup %{conn: conn} do
      template = %{id: 1, name: "Test Template", body: "Using [[model]] on [[today]]"}
      :persistent_term.put(:templates, [template])
      
      {:ok, view, _html} = live(conn, "/")
      %{view: view, template: template}
    end

    test "shows run modal when clicking run button", %{view: view, template: template} do
      assert view 
             |> element("button", "Run") 
             |> render_click() =~ template.name
    end

    test "validates model name length", %{view: view} do
      view |> element("button", "Run") |> render_click()
      
      assert view
             |> element("#run-modal form")
             |> render_submit(%{"model" => "a"}) =~ "Model name must be at least 2 characters long"
    end

    test "processes template with valid model name", %{view: view} do
      view |> element("button", "Run") |> render_click()
      
      today = Date.utc_today() |> Calendar.strftime("%Y-%m-%d")
      result = view
               |> element("#run-modal form")
               |> render_submit(%{"model" => "GPT-4"})
      
      assert result =~ "Using GPT-4 on #{today}"
    end

    test "closes run modal", %{view: view} do
      view |> element("button", "Run") |> render_click()
      
      refute view
             |> element("button", "Close")
             |> render_click() =~ "Run Template:"
    end
  end

  describe "template deletion" do
    setup %{conn: conn} do
      template = %{id: 1, name: "Test Template", body: "Test template"}
      :persistent_term.put(:templates, [template])
      
      {:ok, view, _html} = live(conn, "/")
      %{view: view, template: template}
    end

    test "deletes template when clicking delete button", %{view: view, template: template} do
      refute view
             |> element("button", "Delete")
             |> render_click() =~ template.name
             
      :persistent_term.erase(:templates)
    end
  end

  describe "error handling" do
    test "shows error message for invalid template name", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      
      view |> element("button", "New Template") |> render_click()
      
      assert view
             |> element("form")
             |> render_submit(%{
               "name" => String.duplicate("a", 51),
               "body" => "Test template with [[model]]"
             }) =~ "Template name must not exceed 50 characters"
    end

    test "shows error message for invalid model name", %{conn: conn} do
      template = %{id: 1, name: "Test Template", body: "Using [[model]]"}
      :persistent_term.put(:templates, [template])
      
      {:ok, view, _html} = live(conn, "/")
      
      view |> element("button", "Run") |> render_click()
      
      assert view
             |> element("#run-modal form")
             |> render_submit(%{
               "model" => String.duplicate("a", 31)
             }) =~ "Model name must not exceed 30 characters"
             
      :persistent_term.erase(:templates)
    end
  end
end 