defmodule CampWithDennisWeb.RsvpView do
  use CampWithDennisWeb, :view

  @base_text_link "+12107718253"

  def text_me_link do
    @base_text_link
  end

  def text_me_link(body) do
    query = URI.encode(body)
    {:sms, "#{@base_text_link}&body=#{query}"}
  end
end
