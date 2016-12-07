# Local OAuth2 REST API
This is a simple, local implementation of an OAuth2 API built on [Sinatra]
[Sinatra].

Inspired by [Dropbox's API][Dropbox].

# Requirements
The only hard requirement is Ruby 2.3.1, all other dependencies are declared in
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

Then run the API:

```sh
$ rackup
Puma starting in single mode...
* Version 3.4.0 (ruby 2.3.0-p0), codename: Owl Bowl Brawl
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://localhost:9292
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
  - **`token`**: This is the most commonly used response type. It redirects the user to
    the `redirect_uri` and passes, via the query string, the token.
  - **`code`**: The OAuth2 server returns an access code as text. This access code is
    then used to query the path `/token` to receive the access token. This 2 step process
    is often used with server based apps.

When you request a token from this OAuth2 service, all of the corresponding parameters
must match what exists in the database (i.e. the class `Authorization`). If there is
a mis-match or if required fields are missing, then the service will deny the request.

# Troubleshooting
You might see this error on start-up.

```sh
local-rest-api master % rackup
Unable to activate sinatra-1.4.7, because rack-2.0.1 conflicts with rack (~> 1.5) (Gem::ConflictError)
```

This means you have multiple versions of Rack installed. Remove all versions
*except* 1.6.5.

```sh
local-rest-api master % gem uninstall rack

Select gem to uninstall:
 1. rack-1.6.5
 2. rack-2.0.1
 3. All versions
> 2
```

Now start the app.

[Sinatra]: http://www.sinatrarb.com/
[Bundler]: http://bundler.io/
[Dropbox]: https://www.dropbox.com/developers-v1/core/docs
