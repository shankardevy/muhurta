defmodule Muhurta.Events.Vote do
  use Ash.Resource, otp_app: :muhurta, domain: Muhurta.Events, data_layer: AshPostgres.DataLayer

  postgres do
    table "votes"
    repo Muhurta.Repo
  end

  actions do
    defaults [
      :read,
      :destroy,
      create: [:poll_option_id, :user_id, :answer],
      update: [:answer]
    ]
  end

  attributes do
    uuid_primary_key :id

    attribute :answer, :string do
      allow_nil? false
    end

    timestamps()
  end

  relationships do
    belongs_to :poll_option, Muhurta.Events.PollOption do
      allow_nil? false
    end

    belongs_to :user, Muhurta.Events.User do
      allow_nil? false
    end
  end
end
