Feature:
  As thirsty bastard
  I want have a can of soda delivered
  So that i can fix my thirst
  
  Scenario: Deliver for free
    Given a machine with cola and sprite
    When I choose cola
    Then A can of cola is delivered
