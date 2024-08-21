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

polls = [
  %{
    name: "Team Sync: Best Time?",
    location: "Zoom",
    description:
      "Sync up with the entire team to discuss upcoming projects, status updates, and address any blockers for the week."
  },
  %{
    name: "Quarterly Review Options",
    location: "Headquarters Conference Room A",
    description:
      "Planning the quarterly review meeting to discuss company performance, achievements, and future strategy with key stakeholders."
  },
  %{
    name: "Coffee Catch-up Poll",
    location: "Cafe Blue",
    description:
      "A casual get-together over coffee to catch up with teammates and discuss non-work-related topics."
  },
  %{
    name: "Client Presentation Scheduling",
    location: "Client's Office - Downtown",
    description:
      "Finding the best time to present our latest project deliverables to the client and gather their feedback."
  },
  %{
    name: "Strategy Brainstorming Slots",
    location: "Parkside Co-working Space",
    description:
      "Brainstorming session to explore new strategies and creative approaches for our upcoming marketing campaign."
  },
  %{
    name: "Monthly Project Debrief",
    location: "Main Office - Conference Room B",
    description:
      "Debriefing the team on completed projects, lessons learned, and improvements for future work."
  },
  %{
    name: "Weekend Team Outing?",
    location: "Sunnyvale Park",
    description:
      "Planning a fun weekend outing for the team to relax, unwind, and build stronger connections outside of the work environment."
  },
  %{
    name: "Budget Planning Session",
    location: "Finance Office - 3rd Floor",
    description:
      "Meeting to review the budget and allocate resources for upcoming projects and initiatives within the organization."
  },
  %{
    name: "One-on-One Meeting Availability",
    location: "Cafe Java",
    description:
      "Scheduling one-on-one meetings with team members to discuss their progress, address concerns, and offer support."
  },
  %{
    name: "All-Hands Meeting Time",
    location: "Virtual (Google Meet)",
    description:
      "Company-wide meeting to share updates, achievements, and future goals with all employees, fostering transparency and collaboration."
  },
  %{
    name: "Holiday Party Date!",
    location: "Rooftop Bar - Midtown",
    description:
      "Planning the company holiday party where everyone can celebrate the year’s successes and enjoy time together outside of work."
  },
  %{
    name: "Product Launch Prep",
    location: "Design Studio",
    description:
      "Coordinating a meeting to finalize preparations for the upcoming product launch, ensuring everything is on track for a successful rollout."
  },
  %{
    name: "Remote Work Check-In",
    location: "Virtual (Microsoft Teams)",
    description:
      "Checking in with the remote team members to see how they’re managing, offer support, and ensure productivity is maintained."
  },
  %{
    name: "Sprint Planning Meeting",
    location: "Agile Conference Room",
    description:
      "Organizing the sprint planning meeting to assign tasks, prioritize backlog items, and set goals for the next sprint cycle."
  },
  %{
    name: "Workshop Time Preferences",
    location: "Innovation Hub",
    description:
      "Deciding on the best time for an internal workshop aimed at upskilling employees and fostering a culture of continuous learning."
  }
]

polls
|> Enum.each(fn poll_params ->
  create_poll(
    poll_params,
    actor: Enum.random([user1, user2])
  )
end)
