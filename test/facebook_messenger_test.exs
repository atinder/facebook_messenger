
defmodule FacebookMessenger.Message.Test do
  use ExUnit.Case

  test "it gets initialized from a string" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")

    res = FacebookMessenger.Response.parse(file)
    assert is_list(res.entry) == true
    assert res.entry |> hd |> Map.get(:id) == "PAGE_ID"

    messaging = res.entry |> hd |> Map.get(:messaging)
    assert  messaging |> is_list == true
    assert  messaging |> hd |> Map.get(:sender) |> Map.get(:id) == "USER_ID"
    assert  messaging |> hd |> Map.get(:recipient) |> Map.get(:id) == "PAGE_ID"

    message = messaging |> hd |> Map.get(:message)
    assert message.text == "hello"
  end

  test "it gets initialized from a json" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    {:ok, json} = file |> Poison.decode

    res = FacebookMessenger.Response.parse(json)
    assert is_list(res.entry) == true
    assert res.entry |> hd |> Map.get(:id) == "PAGE_ID"

    messaging = res.entry |> hd |> Map.get(:messaging)
    assert  messaging |> is_list == true
    assert  messaging |> hd |> Map.get(:sender) |> Map.get(:id) == "USER_ID"
    assert  messaging |> hd |> Map.get(:recipient) |> Map.get(:id) == "PAGE_ID"

    message = messaging |> hd |> Map.get(:message)
    assert message.text == "hello"
  end

  test "it gets the message text from the response" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    res = FacebookMessenger.Response.parse(file)
    res = FacebookMessenger.Response.message_texts(res)
    assert res == ["hello"]
  end

  test "it gets the message sender id" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    res = FacebookMessenger.Response.parse(file)
    res = FacebookMessenger.Response.message_senders(res)
    assert Enum.at(res,0).id == "USER_ID"
  end

  test "parses location attachment" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_location.json")
    res = FacebookMessenger.Response.parse(file)
    attachments = FacebookMessenger.Response.message_attachments(res)
    assert [%FacebookMessenger.Attachment{payload: %{"coordinates" => %{"lat" => latitude, "long" => longitude}}} | _ ] = attachments
  end
end
