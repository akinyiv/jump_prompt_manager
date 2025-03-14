defmodule PromptManagerWeb.TemplateLive do
  use PromptManagerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Load templates from persistent term if exists
      templates = :persistent_term.get(:templates, [])
      {:ok, assign(socket, templates: templates, show_form: false, current_template: nil, model_input: "", final_prompt: nil, error: nil)}
    else
      {:ok, assign(socket, templates: [], show_form: false, current_template: nil, model_input: "", final_prompt: nil, error: nil)}
    end
  end

  @impl true
  def handle_event("new_template", _, socket) do
    {:noreply, assign(socket, show_form: true, error: nil)}
  end

  @impl true
  def handle_event("save_template", %{"name" => name, "body" => body}, socket) do
    with {:ok, _} <- validate_template_name(name),
         {:ok, _} <- validate_template_body(body) do
      template = %{id: System.unique_integer([:positive]), name: name, body: body}
      new_templates = [template | socket.assigns.templates]
      # Store templates in persistent term
      :persistent_term.put(:templates, new_templates)
      
      {:noreply,
       socket
       |> assign(templates: new_templates, show_form: false, error: nil)
       |> put_flash(:info, "Template created successfully!")}
    else
      {:error, message} ->
        {:noreply, assign(socket, error: message)}
    end
  end

  @impl true
  def handle_event("run_template", %{"id" => id}, socket) do
    case find_template(socket.assigns.templates, id) do
      nil ->
        {:noreply, socket |> put_flash(:error, "Template not found")}
      template ->
        {:noreply, assign(socket, current_template: template, model_input: "", final_prompt: nil, error: nil)}
    end
  end

  @impl true
  def handle_event("process_template", %{"model" => model}, socket) do
    with {:ok, _} <- validate_model_name(model),
         template <- socket.assigns.current_template,
         today <- Date.utc_today() |> Calendar.strftime("%Y-%m-%d"),
         final_prompt <- template.body
           |> String.replace("[[today]]", today)
           |> String.replace("[[model]]", model) do
      
      {:noreply, assign(socket, final_prompt: final_prompt, error: nil)}
    else
      {:error, message} ->
        {:noreply, assign(socket, error: message)}
    end
  end

  @impl true
  def handle_event("close_form", _, socket) do
    {:noreply, assign(socket, show_form: false, error: nil)}
  end

  @impl true
  def handle_event("close_run", _, socket) do
    {:noreply, assign(socket, current_template: nil, final_prompt: nil, error: nil)}
  end

  @impl true
  def handle_event("delete_template", %{"id" => id}, socket) do
    new_templates = Enum.reject(socket.assigns.templates, &(&1.id == String.to_integer(id)))
    :persistent_term.put(:templates, new_templates)
    
    {:noreply,
     socket
     |> assign(templates: new_templates)
     |> put_flash(:info, "Template deleted successfully!")}
  end

  # Private functions

  defp validate_template_name(name) do
    cond do
      String.length(name) < 3 ->
        {:error, "Template name must be at least 3 characters long"}
      String.length(name) > 50 ->
        {:error, "Template name must not exceed 50 characters"}
      true ->
        {:ok, name}
    end
  end

  defp validate_template_body(body) do
    cond do
      String.length(body) < 10 ->
        {:error, "Template body must be at least 10 characters long"}
      not (String.contains?(body, "[[") and String.contains?(body, "]]")) ->
        {:error, "Template must contain at least one placeholder"}
      true ->
        {:ok, body}
    end
  end

  defp validate_model_name(model) do
    cond do
      String.length(model) < 2 ->
        {:error, "Model name must be at least 2 characters long"}
      String.length(model) > 30 ->
        {:error, "Model name must not exceed 30 characters"}
      true ->
        {:ok, model}
    end
  end

  defp find_template(templates, id) do
    Enum.find(templates, &(&1.id == String.to_integer(id)))
  end
end 