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

  Scenario: Ignore blacklisted files
    Given I have a folder containing shared dotfiles
    And   the shared dotfiles contain a file "README.md" 
    And   I ignore the file "README.md" 
    When  I run the link tool
    Then  the file "README.md" should not be in my user home
    And   the file ".README.md" should not be in my user home

