# Robinhood [![Build Status](https://travis-ci.org/codegram/robinhood.png?branch=master)](https://www.travis-ci.org/codegram/robinhood)

**Join a live discussion on Gitter**: [![Gitter chat](https://badges.gitter.im/codegram/robinhood.png)](https://gitter.im/codegram/robinhood)

Robinhood is a DSL for constructing iteration-based synchronous processes
(aka can't be run as jobs) in a distributed manner.

In other words: Robs responsibilities from richer processes and gives them to
the poor.

It leverages celluloid actors for each process and uses Redis as a locking
mechanism to ensure the process is run in a single server.

## Compatibility

Robinhood works on MRI 1.9.3 and upwards, and rubinius 2.1 and upwards. We
don't intend to support JRuby at the moment because it lacks support for
Process#fork which is needed in order to run robinhood as a daemon.

We could make daemonizing a separate module if there was enough interest,
though.

## Usage

Install the gem:

```
$ gem install robinhood
```

Create a `Robinhood` file in your root:

```ruby
require 'your-app'

Robinhood.define do
  redis{ Redis.new(:host => "10.0.1.1", :port => 6380) }

  process :assigner, throttle: 10 do
    UserAssigner.process!
  end

  process :sweeper, throttle: false, timeout: 20 do
    Sweeper.sweep!
  end
end
```

Launch robinhood on the foreground:

```
$ robinhood
```

Launch robinhood in a daemonized way:

```
$ robinhood start
```

Stop or restart a daemonized robinhood:

```
$ robinhood stop
$ robinhood restart
```

You can also append options to robinhood's executable:

```
$ robinhood -c config.rb --pids-path /var/run --log-path /var/log
```

## How does it work?

Each time a process finishes its execution, the lock is released so any other
server (or system process) can execute it again. This ensures it will be
executed in a synchronous manner (one after the other). It also garantees the
executions will be distributed across the processes (or servers) so if a server
goes down, the load will be distributed evenly across the rest of them.

You can also set a timeout (in case a process hangs for some reason) and a
throttling mechanism (so a process can't be re-scheduled before this time has
passed).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
