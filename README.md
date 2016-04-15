# PhoenixEmber

Make it easier to user Ember with Phoenix.


## Installation

Right now available only from GitHub untils tests and docs are improved.


## Usage

In your project root create Ember App

```
ember new frontend --skip-git
```


Define app in the config/config.ex

```elixir
config :phoenix_ember,
  apps: [ { "frontend", [ watch: true ] }]
```


**Set watch to true only in dev's config.**

Define route with a wildcard:

``` elixir
# routex.ex
get "/*path", PageController, :index
```


and then in the render's action output ember's `index.html`:

``` elixir
defmodule Example.PageController do
  use Example.Web, :controller

  def index(conn, _params) do
    conn
    |> html(PhoenixEmber.get_index("frontend"))
  end
end

```


Additionaly, for the app to work properly on the `/` path like in this case.
We have to plug in a plug to serve static files:

``` elixir
# endpoint.ex
plug Plug.Static, at: "/", from: PhoenixEmber.Path.dist("frontend")

```


## Watchers (dev)

Define supervisor in ApplicationName if you'd like to have automatic recompilation on dev.

```elixir
  # example.ex
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Example.Endpoint, []),
      supervisor(Example.Repo, []),
      supervisor(PhoenixEmber.Watchers, []) # ADD THIS
    ]

    {:ok, _} = Plug.Adapters.Cowboy.http(Example.StubWebsite, [], port: 3999)

    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)
  end
```


now when you start a server, it will create watchers for those apps which have `watch: true` set in the config.

## CSRF Tokens

For CSRF we have to do a couple of things.

Firstly, we need somehow pass CSRF token to the front-end.
One of the solutions is to pass it in the cookies:

``` elixir
defmodule Example.PageController do
  use Example.Web, :controller

  def index(conn, _params) do
    conn
    |> put_resp_cookie("csrf-token", get_csrf_token(), http_only: false)
    |> html(PhoenixEmber.get_index("frontend"))
  end
end
```

We also have to setup protection from forgery in the API pipeline:

``` elixir
  # routes.ex
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session # ADDED
    plug :protect_from_forgery # ADDED
   end

```

Lastly, we've to add that token to all API requests in the ember's app.



``` javascript
// app/instance-initializers/csrf.js
import Ember from 'ember';
const { $ } = Ember;

export function initialize(_applicationInstance) {
  $.ajaxPrefilter((options, originalOptions, xhr) => {
    if(document && document.cookie) {
      const token = Ember.get(document.cookie.match(/csrf\-token\=([^;]*)/), "1");
      xhr.setRequestHeader('X-CSRF-Token', token);
    }
  });
}

export default {
  name: 'csrf',
  initialize
};

```

## Tasks

 - `mix phoenix_ember.digest` - compiles all defined ember apps
 - `mix phoenix_ember.test` - runs ember's apps tests.



## TODO:

 - tests
 - create example app
 - support ember's apps outside the root directory


## Known to work versions:

  - Phoenix Framework 1.1.*
  - ember-cli: 2.4.*

## LICENSE

MIT
