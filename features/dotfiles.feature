Feature:
  As a developer
  I want to use the same dotfile repository on multiple hosts
  So that I have an easier time with setting up new machines and keeping them synced

  Scenario: Create Symlinks
    Given I have a folder containing files and folders
    When I run the link tool
    Then the files are being linked into my user home
     And the folders are being linked into my user home

  Scenario: Query for Replace
  Scenario: Add dots


