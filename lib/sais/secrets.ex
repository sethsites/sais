defmodule Sais.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Sais.Accounts.User, _opts, _context) do
    Application.fetch_env(:sais, :token_signing_secret)
  end
end
