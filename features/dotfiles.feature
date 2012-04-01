@fakefs 
Feature:
  As a developer
  I want to use the same dotfile repository on multiple hosts
  So that I have an easier time with setting up new machines and keeping them synced

  Scenario: Configure a new machine with shared dotfiles 
    Given I have a new machine
    And   I have a folder containing shared dotfiles
    When  I run the link tool
    Then  the dotfiles should be in my user home 

  Scenario: Prefix a dot to files without leading dot 
    Given I have a folder containing shared dotfiles
    And   there are files without leading dot 
    When  I run the link tool
    Then  the dotfiles should be in my user home
    And   all files are prefixed with a dot

  Scenario: Sync changes from user home
    Given I have run the link tool
    When  I change a dotfile in my user home
    Then  it should also change in the shared folder

  Scenario: Sync changes to user home 
    Given I have run the link tool
    When  I change a dotfile in the shared folder
    Then  it should also change in my user home 

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
    


  Scenario: Query for Replace
