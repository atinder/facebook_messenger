# ExFacebookMessenger
[![Build Status](https://travis-ci.org/atinder/facebook_messenger.svg?branch=master)](https://travis-ci.org/atinder/facebook_messenger)
[![Hex.pm](https://img.shields.io/hexpm/v/facebook_messenger.svg)](https://hex.pm/packages/facebook_messenger)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/facebook_messenger/)
[![Coverage Status](https://coveralls.io/repos/github/atinder/facebook_messenger/badge.svg?branch=master)](https://coveralls.io/github/atinder/facebook_messenger?branch=master)
[![Inline docs](http://inch-ci.org/github/atinder/facebook_messenger.svg?branch=master)](http://inch-ci.org/github/atinder/facebook_messenger)

ExFacebookMessenger is a library that helps you create facebook messenger bots easily.

## Installation

```
def deps do
  [{:facebook_messenger, "~> 0.3.0"}]
end
```


## Usage

### With plug
To create an echo back bot, do the following:

In your `Plug.Router` define a `forward` with a route to `FacebookMessenger.Router`

```
defmodule Sample.Router do
  use Plug.Router
  ...

  forward "/messenger/webhook",
    to: FacebookMessenger.Router,
    message_received: &Sample.Router.message/1

  def message(msg) do
    text = FacebookMessenger.Response.message_texts(msg) |> hd
    sender = FacebookMessenger.Response.message_senders(msg) |> hd
    FacebookMessenger.Sender.send(sender, text)
  end
enda

```

This defines a webhook endpoint at:
`http://your-app-url/messenger/webhook`

Go to your `config/config.exs` and add the required configurations
```
config :facebook_messenger,
      facebook_page_token: "Your facebook page token",
      challenge_verification_token: "the challenge verify token"
```

To get the `facebook_page_token` and `challenge_verification_token` follow the instructions [here ](https://developers.facebook.com/docs/messenger-platform/quickstart)

For the webhook endpoint use `http://your-app-url/messenger/webhook`

### With Phoenix
If you use phoenix framework in your project, then you need the phoenix version of `facebook_messenger` this can be found at `phoenix_facebook_messenger` [found here](https://github.com/atinder/phoenix_facebook_messenger).

## Sample

- A sample facebook echo bot with plug can be found here. https://github.com/oarrabi/plug_facebook_echo_bot
- For the phoenix echo bot, https://github.com/oarrabi/phoenix_facebook_echo_bot

## Future Improvements

- [ ] Handle other types of facebook messages
- [ ] Support sending facebook structure messages
- [ ] Handle facebook postback messages
