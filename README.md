# Robinhood [![Build Status](https://www.travis-ci.org/codegram/robinhood.png?branch=master)](https://www.travis-ci.org/codegram/robinhood)

Robinhood is a DSL for constructing iteration-based synchronous processes
(aka can't be run as jobs) in a distributed manner.

In other words: Robs responsibilities from richer processes and gives them to
the poor.

It leverages celluloid actors for each process and uses Redis as a locking
mechanism to ensure the process is run in a single server.

## Usage

```ruby
Robinhood.define do
  redis{ Redis.new(:host => "10.0.1.1", :port => 6380) }

  process :assigner, throttle: 10 do
    UserAssigner.process!
  end

  process :sweeper, throttle: false, timeout: 20 do
    Sweeper.sweep!
  end
end

Robinhood.run
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
