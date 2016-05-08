# Local OAuth2 REST API
This is a simple, local implementation of an OAuth2 API built on [Sinatra]
[Sinatra].

Inspired by [Dropbox's API][Dropbox].

# Requirements
The only hard requirement is Ruby 2.3.0, all other dependencies are declared in
[Bundler] fashion.

# Usage
First install the bundle:

```sh
$ bundle update
Fetching gem metadata from https://rubygems.org/.........
Fetching version metadata from https://rubygems.org/..
Resolving dependencies...
...
```

Then run the API

```sh
$ ruby app.rb
== Sinatra (v1.4.7) has taken the stage on 4567 for development with backup from Puma
Puma starting in single mode...
* Version 3.4.0 (ruby 2.3.0-p0), codename: Owl Bowl Brawl
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://localhost:4567
Use Ctrl-C to stop
```

# Quick rundown
The class `Authorization` represents a database with user defined data. To keep things
simple, I statically defined all these data as class constants. Change them as you wish.

- **`CLIENT_ID`**: This represents the "app key" you'll often see with OAuth2 services.
  This is usually accompanied by an "app secret", I don't know what the difference is.
- **`REDIRECT_URI`**: This is the URI that the OAuth2 service will redirect to after
  the user has been authorized. The redirect URI has got to be something your client
  application recognizes.
- **`ACCESS_TOKEN`**: This is the token the server recognizes as the authorized user.
  Below are "response types" which tell the OAuth2 service how the client application
  would like to receive the token:
- - **`token`**: This is the most commonly used response type. It redirects the user to
    the `redirect_uri` and passes, via the query string, the token.
- - **`code`**: The OAuth2 server simply returns the token as text. This server 
    displays the token in a text field for the user to copy, just like Dropbox.

When you request a token from this OAuth2 service, all of the corresponding parameters
must match what exists in the database (i.e. the class `Authorization`). If there is
a mis-match or if required fields are missing, then the service will deny the request.

[Sinatra]: http://www.sinatrarb.com/
[Bundler]: http://bundler.io/
[Dropbox]: https://www.dropbox.com/developers-v1/core/docs
