@fakefs 
Feature:
  As a user of the link tool 
  I want to be able to dynamically use different sets of dotfiles 
  So that I can use different configs for different environments 

  Scenario: Use host specific files for matching host name 
    Given I have a folder containing shared dotfiles
    And   the shared dotfiles contain a file "gemrc" 
    And   the shared dotfiles contain a file "gemrc.host-work"
    And   the hostname is "work" 
    When  I run the link tool
    Then  the file "~/.gemrc" should be equal to "gemrc.host-work"

  Scenario: Fallback to default for non-matching host names
    Given I have a folder containing shared dotfiles
    And   the shared dotfiles contain a file "gemrc" 
    And   the shared dotfiles contain a file "gemrc.host-work"
    And   the hostname is "home" 
    When  I run the link tool
    Then  the file "~/.gemrc" should be equal to "gemrc"
 
  Scenario: Fallback to default for non-matching host names
    Given I have a folder containing shared dotfiles
    And   the shared dotfiles contain a file "gemrc" 
    And   the shared dotfiles contain a file "gemrc.host-work"
    When  I run the link tool
    Then  the file "gemrc.host-work" should not be in my user home
    And   the file ".gemrc.host-work" should not be in my user home
