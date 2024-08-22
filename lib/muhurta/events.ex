defmodule Muhurta.Events do
  use Ash.Domain

  resources do
    resource Muhurta.Events.User do
      define :create_user, action: :create
      define :get_user, action: :read, get?: true, get_by: :id
      define :get_user_by_email, action: :read, get?: true, get_by_identity: :unique_email
    end

    resource Muhurta.Events.Poll do
      define :create_poll, action: :create
      define :update_poll, action: :update
      define :delete_poll, action: :destroy
      define :list_polls, action: :read
      define :get_poll, action: :read, get?: true, get_by: :id
    end

    resource Muhurta.Events.PollOption

    resource Muhurta.Events.Vote do
      define :vote_poll, action: :create
      define :delete_vote, action: :destroy
    end

    resource Muhurta.Events.Comment do
      define :create_comment, action: :create
      define :delete_comment, action: :destroy
      define :list_comment, action: :read
    end
  end
end
