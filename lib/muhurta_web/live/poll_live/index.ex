defmodule MuhurtaWeb.PollLive.Index do
  use MuhurtaWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="mb-6 pb-2 text-2xl font-semibold text-gray-800 md:text-3xl border-b border-gray-300">
      Event Polls
    </h1>

    <div class="grid grid-cols-2 gap-4">
      <div class="px-8 py-4 bg-white rounded-lg shadow-md">
        <div class="flex items-center justify-between">
          <span class="text-sm font-light text-gray-600">Location</span>
        </div>
        <div class="mt-2">
          <a href="#" class="text-xl font-bold text-gray-700 hover:text-gray-600 hover:underline">
            Event name
          </a>
          <p class="mt-2 text-gray-600">Event Description</p>
        </div>
      </div>
    </div>
    """
  end
end
