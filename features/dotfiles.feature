Feature:
  As a developer
  I want to use the same dotfile repository on multiple hosts
  So that I have an easier time with setting up new machines and keeping them synced

  @fakefs
  Scenario: Configure a new machine with shared dotfiles 
    Given I have a new machine
    And   I have a folder containing shared dotfiles
    When  I run the link tool
    Then  the dotfiles should be in my user home 

  @fakefs 
  Scenario: Prefix a dot to files without leading dot 
    Given I have a folder containing shared dotfiles
    And   there are files without leading dot 
    When  I run the link tool
    Then  the dotfiles should be in my user home
     And  all files are prefixed with a dot

  Scenario: Synchronize changes
  Scenario: Query for Replace
