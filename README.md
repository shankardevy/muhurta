# Muhurta

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Basic Setup

The project comes predefined Ash Domain, Ash Resources and utility scripts so that you can learn LiveView without having to worry about setting the necessary data models, seeding the database with example data etc.

Use of Ash Framework is purely for the convinience of the author of this training material to setup the necessary boilerplate code for the application domain. LiveView doesn't depend on Ash. Infact, LiveView doesn't even depend on Ecto for that matter. However, in practice, you need a data layer. The author believes Ash is an excellent library for real-world production use. 

All the functionalities implemented in Ash can be implemented in plain Phoenix Contexts and Ecto schemas. Should you choose to not use Ash, you are free to replace it without worrying if anything you learned in the LiveView training would become obsolete. No it won't. 

### Ash Domain

This project comes with  Ash Domain `Muhurta.Events` that is configured with the following Ash Resources:

1. `Muhurta.Events.User` 
2. `Muhurta.Events.Poll` 
3. `Muhurta.Events.PollOption` 
4. `Muhurta.Events.Vote` 
5. `Muhurta.Events.Comment` 

`Muhurta.Events` has the following functions defined for various actions

1. `create_user/1` to create or update an user. You can create a new user by calling 

```elixir
{:ok, user} = Muhurta.Events.create_user(%{email: "user@example.com", name: "Chaaru"})
{:ok, updated_user} = Muhurta.Events.create_user(%{email: "user@example.com", name: "Nittin"})
```

2. `get_user/1` to fetch the user from the database by `id`.

```elixir
{:ok, user} = Muhurta.Events.get_user("d170e165-990e-477b-ad4f-31c07d037917")
```

3. `list_polls` to list Polls created by the currently logged in user. When calling this function from a LiveView, the current user information is automatically set. (After configuring the Plug for setting up the actor) However, if you are calling it in IEx or in scripts, you can pass the user as the `actor`

```elixir
{:ok, polls} = Muhurta.Events.list_polls() # in LiveView context, this automatically fetches the polls by the current user

# in IEx or scripts, set the actor manually:
{:ok, user} = Muhurta.Events.get_user("d170e165-990e-477b-ad4f-31c07d037917")
{:ok, polls} = Muhurta.Events.list_polls(actor: user)
```

4. `create_poll/1` to create a poll with the given params.

```elixir
{:ok, poll} = Muhurta.Events.create_poll(%{name: "Elixir Training", description: "Give what date works you", location: "Online"})
```

You can also set the poll_options for your poll when creating it.

```elixir
poll_options = [
  %{date: Date.utc_today(), from_time: "09:30", to_time: "10:30"},
  %{date: Date.utc_today(), from_time: "10:30", to_time: "11:30"}
]

{:ok, poll} = Muhurta.Events.create_poll(
  %{
    name: "Elixir Training", 
    description: "Give what date works you", 
    location: "Online", 
    poll_options: poll_options
  })
```

5. `get_poll/1` to get the poll by  `id`.

```elixir
{:ok, poll} = Muhurta.Events.get_poll("170e1d65-990e-477b-ad4f-7931c07d0317")
```

6. `update_poll/1` to update an existing poll. It accepts the same parameters as `create_poll`. If the `poll_options` have an `id`, the `poll_option` is updated, otherwise created. If an existing `poll_option` is missing in the new update, those options are deleted.


7. `delete_poll/1` deletes an existing poll by `id`. Can be deleted only by the owner of the poll.

```elixir
{:ok, poll} = Muhurta.Events.delete_poll("170e1d65-990e-477b-ad4f-7931c07d0317")
```

8. `vote_poll/1` to vote a poll with the user's answer. Answer can be one of `[:yes, :no, :if_need_be]`. Similar to creating a poll, the current user is automatically set when called in a LiveView. A vote is unique for a `user` to a specific `poll_option`. So setting a new vote for the same `user` to the same `poll_option` would update the previous vote rather than creating a new one.

```elixir
{:ok, user} = Muhurta.Events.get_user("170e1d65-990e-477b-ad4f-30379171c07d")

{:ok, vote} = Muhurta.Events.vote_poll(%{
  poll_option_id: "d170e165-990e-477b-ad4f-31c07d037917", 
  answer: :yes
}, actor: user)

## Casting a vote for the same user, to the same poll_option_id with a different `answer` will update the existing one.
{:ok, updated_vote} = Muhurta.Events.vote_poll(%{
  poll_option_id: "d170e165-990e-477b-ad4f-31c07d037917", 
  answer: :no
}, actor: user)
```

9. `delete_vote/1` deletes an existing vote by `id`. Can be deleted only by the voter.

```elixir
{:ok, voter} = Muhurta.Events.get_user("170e1d65-990e-477b-ad4f-30379171c07d")

{:ok, vote} = Muhurta.Events.delete_vote("170e1d65-990e-477b-ad4f-7931c07d0317", actor: voter)
```

10. `create_comment/1` to create a comment a specific poll, setting the current user as the author.

```elixir
{:ok, user} = Muhurta.Events.get_user("170e1d65-990e-477b-ad4f-30379171c07d")

{:ok, comment} = Muhurta.Events.create_comment(
  %{
    text: "Hello World!", 
    poll_id: "d170e165-990e-477b-ad4f-31c07d037917"
  }, actor: user)
```

11. `list_comments/1` to list comments for a specific poll.

```elixir
{:ok, poll} = Muhurta.Events.get_poll("170e1d65-990e-477b-ad4f-7931c07d0317")

{:ok, comments} = Muhurta.Events.list_comments(poll.id)
```

12. `delete_comment/` to delete a comment as long as the `current_user` is the author of the comment.

```elixir
{:ok, user} = Muhurta.Events.get_user("70e1d165-990e-477b-ad4f-30379171c07d")

{:ok, comment} = Muhurta.Events.delete_comment("170e1d65-990e-477b-ad4f-7931c07d0317", author: user)
```

