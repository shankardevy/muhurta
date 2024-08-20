import Muhurta.Events

today = Date.utc_today()

random_day = fn ->
  Date.add(today, Enum.random(1..30))
end

random_time = fn ->
  Time.new(Enum.random(0..23), Enum.random([0, 15, 30, 45]), 0)
end

random_duration = fn ->
  [15, 30, 45, 60, 75, 90, 105, 120] |> Enum.random()
end

random_poll_option = fn ->
  from_time = random_time.()

  %{
    date: random_day.(),
    from_time: from_time,
    to_time: Time.add(from_time, random_duration.())
  }
end

user1 = create_user!(%{name: "Chaaru", email: "chaaru@example.com"})
user2 = create_user!(%{name: "Nittin", email: "nittin@example.com"})

1..5
|> Enum.each(fn id ->
  create_poll(
    %{
      name: "Poll #{id}",
      location: "Location of Poll #{id}",
      description: "Description of Poll #{id}"
    },
    actor: user1
  )
end)

1..3
|> Enum.each(fn id ->
  create_poll(
    %{
      name: "Poll #{id}",
      location: "Location of Poll #{id}",
      description: "Description of Poll #{id}"
    },
    actor: user2
  )
end)
