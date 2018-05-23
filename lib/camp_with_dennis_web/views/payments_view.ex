defmodule CampWithDennisWeb.PaymentsView do
  use CampWithDennisWeb, :view

  def payment_methods do
    [
      "Venmo": "venmo",
      "Square Cash": "square_cash",
      "Apple Pay Cash": "apple_pay_cash"
    ]
  end
end
