# Create a LiveView page to display current user profile page

1. define a route in router.ex for `/me`
2. define a LiveView module to handle the route `/me`
3. load the current user id from session, get the user from db and put it in assigns in the `mount/3` function
4. define a template file for the page
5. use the below html template and replace the two placeholders 
    `[My name goes here]` and 
    `[My email goes here]` 
   with the actual details of the `current_user`.

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
        [My name goes here]
      </h1>

      <p class="mt-2 text-gray-500">[My email goes here]</p>
    </div>
  </div>
</section>
```