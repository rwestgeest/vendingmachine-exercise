Feature:
  As thirsty bastard
  I want have a can of soda delivered
  So that i can fix my thirst
  
  Scenario: Drop a can (to show how you use the features remotely)
    Given a machine 
    When drawer 0 drops a can
    Then it is received by the bin
