defmodule FacebookMessenger.Controller.Test do
  use ExUnit.Case

  test "it returns the passed challenge if token matches" do
    challenge = %{"hub.mode" => "subscribe",
                "hub.verify_token" => "VERIFY_TOKEN",
                "hub.challenge" => "1234567"}
    assert FacebookMessenger.check_challenge(challenge) == {:ok, "1234567"}
  end

  test "it returns error if webhook token does not match" do
    challenge = %{"hub.mode" => "subscribe",
                  "hub.verify_token" => "1",
                  "hub.challenge" => "1234567"}
    assert FacebookMessenger.check_challenge(challenge) == :error
  end

  test "it gets the callback successful event" do
    challenge = %{"hub.mode" => "subscribe",
                  "hub.verify_token" => "VERIFY_TOKEN",
                  "hub.challenge" => "1234567"}
    assert FacebookMessenger.check_challenge(challenge) == {:ok, "1234567"}
  end

  test "it returns error if webhook is not valid" do
    assert FacebookMessenger.check_challenge(1) == :error
  end

  test "it receives a message" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    {:ok, json} = file |> Poison.decode

    assert FacebookMessenger.parse_message(json) == {:ok, %FacebookMessenger.Response{object: "page", entry: [%FacebookMessenger.Entry{id: "PAGE_ID", time: 1460245674269, messaging: [%FacebookMessenger.Messaging{recipient: %FacebookMessenger.User{id: "PAGE_ID"}, sender: %FacebookMessenger.User{id: "USER_ID"}, timestamp: 1460245672080, account_linking: %FacebookMessenger.AccountLinking{authorization_code: nil, status: nil}, delivery: %FacebookMessenger.Delivery{mids: nil, seq: nil, watermark: nil}, message: %FacebookMessenger.Message{mid: "mid.1460245671959:dad2ec9421b03d6f78", seq: 216, text: "hello", attachments: [%FacebookMessenger.Attachment{payload: nil, title: nil, type: nil, url: nil}], quick_replies: [%FacebookMessenger.QuickReply{content_type: nil, payload: nil, title: nil}], quick_reply: %FacebookMessenger.QuickReply{content_type: nil, payload: nil, title: nil}}, optin: %FacebookMessenger.Optin{ref: nil}, postback: %FacebookMessenger.Postback{payload: nil}}]}]}}
  end

  test "it receives a message in string" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")

    assert FacebookMessenger.parse_message(file) == {:ok, %FacebookMessenger.Response{object: "page", entry: [%FacebookMessenger.Entry{id: "PAGE_ID", time: 1460245674269, messaging: [%FacebookMessenger.Messaging{recipient: %FacebookMessenger.User{id: "PAGE_ID"}, sender: %FacebookMessenger.User{id: "USER_ID"}, timestamp: 1460245672080, account_linking: %FacebookMessenger.AccountLinking{authorization_code: nil, status: nil}, delivery: %FacebookMessenger.Delivery{mids: nil, seq: nil, watermark: nil}, message: %FacebookMessenger.Message{mid: "mid.1460245671959:dad2ec9421b03d6f78", seq: 216, text: "hello", attachments: [%FacebookMessenger.Attachment{payload: nil, title: nil, type: nil, url: nil}], quick_replies: [%FacebookMessenger.QuickReply{content_type: nil, payload: nil, title: nil}], quick_reply: %FacebookMessenger.QuickReply{content_type: nil, payload: nil, title: nil}}, optin: %FacebookMessenger.Optin{ref: nil}, postback: %FacebookMessenger.Postback{payload: nil}}]}]}}
  end

  test "it handles bad messages" do
    assert FacebookMessenger.parse_message(1) == :error
  end
end
