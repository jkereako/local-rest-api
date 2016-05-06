# Local OAuth2 REST API
This is a simple implementation of an OAuth2 API that you can run on your local
machine.

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

[Sinatra]: http://www.sinatrarb.com/
[Bundler]: http://bundler.io/
