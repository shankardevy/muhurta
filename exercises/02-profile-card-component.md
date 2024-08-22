# Extract the profile card template to functional component

1. Profile template is already defined in `lib/muhurta_web/live/profile_live/show.html.heex` as below:

```html
<section class="bg-white">
  <div class="flex">
    <div class="w-3/4 gap-4 pr-4">
      <h1 class="font-semibold text-gray-800 capitalize lg:text-3xl">
        About me
      </h1>

      <p class="max-w-2xl mt-4 text-gray-500">
        Some dummy text. Lorem ipsum dolor sit amet consectetur adipisicing elit.
        Illo incidunt ex placeat modi magni quia error alias, adipisci rem similique,
        at omnis eligendi optio eos harum.
      </p>
    </div>

    <div class="max-w-96">
      <img
        class="object-cover rounded-xl aspect-square"
        src="https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80"
        alt=""
      />

      <h1 class="mt-4 text-2xl font-semibold text-gray-700 capitalize">
        <%= @current_user.name %>
      </h1>

      <p class="mt-2 text-gray-500"><%= @current_user.email %></p>
    </div>
  </div>
</section>
```

2. Extract the profile picture section alone as a separate component and embed it back to this template as functional component tag. The relevant section to be extracted is shown below:

```html
<div class="max-w-96">
    <img
    class="object-cover rounded-xl aspect-square"
    src="https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80"
    alt=""
    />

    <h1 class="mt-4 text-2xl font-semibold text-gray-700 capitalize">
    <%= @current_user.name %>
    </h1>

    <p class="mt-2 text-gray-500"><%= @current_user.email %></p>
</div>
```

3. Use attrs, slots as necessary