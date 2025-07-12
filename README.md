# paper-client-rb

The Ruby [PaperCache](https://papercache.io) client. The client supports all commands described in the wire protocol on the homepage.

## Example
```ruby
require "paper_client"

client = PaperClient::Client.new("paper://127.0.0.1:3145");

client.set("hello", "world")
got = client.get("hello")
```
