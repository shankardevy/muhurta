defmodule Muhurta.Events.User do
  use Ash.Resource, otp_app: :muhurta, domain: Muhurta.Events, data_layer: AshPostgres.DataLayer

  postgres do
    table "users"
    repo Muhurta.Repo
  end

  actions do
    defaults [:read, create: [:name, :email]]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :email, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    has_many :polls, Muhurta.Events.Poll
  end

  identities do
    identity :unique_email, [:email]
  end
end
