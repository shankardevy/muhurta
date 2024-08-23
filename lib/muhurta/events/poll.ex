defmodule Muhurta.Events.Poll do
  use Ash.Resource, otp_app: :muhurta, domain: Muhurta.Events, data_layer: AshPostgres.DataLayer

  postgres do
    table "polls"
    repo Muhurta.Repo
  end

  actions do
    defaults [
      :destroy,
      update: [:name, :description, :location]
    ]

    read :read do
      primary? true
      prepare build(sort: [inserted_at: :desc])
    end

    create :create do
      accept [:name, :description, :location]
      argument :poll_options, {:array, :map}

      change relate_actor(:creator)

      change manage_relationship(:poll_options,
               on_no_match: {:create, :create}
             )
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :description, :string do
      public? true
    end

    attribute :location, :string do
      public? true
    end

    attribute :has_time_option, :boolean do
      allow_nil? false
      default false
    end

    timestamps()
  end

  relationships do
    belongs_to :creator, Muhurta.Events.User do
      source_attribute :user_id
      allow_nil? false
    end

    has_many :poll_options, Muhurta.Events.PollOption
  end
end
