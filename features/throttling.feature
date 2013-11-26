Feature: Throttling
  In order to limit the execution rate of a process
  As a developer
  I want to be able to specify throttling rates

  Scenario: Throttle a process
    Given I have a Robinhood file with a throttling ratio set at 3 seconds
    When I run robinhood for 4 seconds
    Then It only has run 2 times
