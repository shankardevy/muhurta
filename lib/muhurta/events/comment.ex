defmodule Muhurta.Events.Comment do
  use Ash.Resource, otp_app: :muhurta, domain: Muhurta.Events, data_layer: AshPostgres.DataLayer

  postgres do
    table "comments"
    repo Muhurta.Repo
  end

  actions do
    defaults [
      :read,
      :destroy,
      create: [:body]
    ]
  end

  attributes do
    uuid_primary_key :id

    attribute :body, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :poll, Muhurta.Events.Poll
    belongs_to :author, Muhurta.Events.User
  end
end
