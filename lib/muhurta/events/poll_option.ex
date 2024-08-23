defmodule Muhurta.Events.PollOption do
  use Ash.Resource, otp_app: :muhurta, domain: Muhurta.Events, data_layer: AshPostgres.DataLayer

  postgres do
    table "poll_options"
    repo Muhurta.Repo
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true
      accept [:date, :from_time, :to_time, :poll_id]
    end

    update :update do
      accept [:date, :from_time, :to_time]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :date, :date do
      allow_nil? false
    end

    attribute :from_time, :time do
      public? true
    end

    attribute :to_time, :time do
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :poll, Muhurta.Events.Poll
    has_many :votes, Muhurta.Events.Vote

    many_to_many :voters, Muhurta.Events.User do
      through Muhurta.Events.Vote
      source_attribute_on_join_resource :poll_option_id
      destination_attribute_on_join_resource :user_id
    end
  end
end
