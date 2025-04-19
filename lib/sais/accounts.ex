defmodule Sais.Accounts do
  use Ash.Domain, otp_app: :sais, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Sais.Accounts.Token
    resource Sais.Accounts.User
  end
end
