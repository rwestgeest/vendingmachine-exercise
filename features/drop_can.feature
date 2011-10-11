Feature:
  As Tester
  I want to test dropping a can in integration
  So that i can verify my assumptions on dropping a can behaviour
  
  Scenario: Drop a can (to show how you use the features remotely)
    Given a machine 
    When drawer 0 drops a can
    Then it is received by the bin
