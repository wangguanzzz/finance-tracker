class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker , presence: true

  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:public_key],
      secret_token: Rails.application.credentials.iex_client[:secret_key],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    begin
      price = client.price(ticker_symbol)
      company = client.company(ticker_symbol)
      Stock.new(ticker: ticker_symbol, name:  company.company_name, last_price: price)
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
