# Robinhood

Robinhood is a DSL for constructing iteration-based synchronous processes
(aka can't be run as jobs) in a distributed manner.

It leverages celluloid actors for each process and uses Redis as a locking
mechanism to ensure the process is run in a single server.

## Usage

```ruby
Robinhood.setup do
  process :assigner, timeout: 10.minutes do
    UserAssigner.process!
  end

  process :sweeper do
    Sweeper.sweep!
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
