*** Settings ***
Documentation     A test suite with a single test for Beanie
...               Created by Robot Extension
Library           Selenium2Library    timeout=10
Library           OperatingSystem

*** Variables ***
${IE_EXISTS}        True
${CHROME_EXISTS}    True
${FF_EXISTS}        True
${SAFARI_EXISTS}    False
${EDGE_EXISTS}      True

*** Test Cases ***
Beanie test using Internet Explorer
  Log    ${CURDIR}
  Run Keyword If    ${IE_EXISTS}    Beanie test  ie
  ...         ELSE     Log  IE is not installed

Beanie test using Chrome
  Log    ${CURDIR}
  Run Keyword If    ${CHROME_EXISTS}    Beanie test   chrome
  ...         ELSE     Log  Chrome is not installed

Beanie test using Firefox
  Log    ${CURDIR}
  Run Keyword If    ${FF_EXISTS}    Beanie test  ff
  ...         ELSE     Log  Firefox is not installed

Beanie test using Safari
  Log    ${CURDIR}
  Run Keyword If    ${SAFARI_EXISTS}    Beanie test  safari
  ...         ELSE     Log  Safari is not installed

Beanie test using Edge
  Log    ${CURDIR}
  Run Keyword If    ${EDGE_EXISTS}    Beanie test  edge
  ...         ELSE     Log  Edge is not installed

*** Keywords ***
Beanie test
  [Arguments]    ${browser}
  Open Browser  file://${CURDIR}/Beanie.html  ${browser}
  Wait Until Page Contains Element  //i[@id="link-edit-1-i"]
  Click Element  //i[@id="link-edit-1-i"]
  Wait Until Page Contains Element  //input[@name="device[name]"]
  Input Text  //input[@name="device[name]"]  iPhone 7 - hello
  Wait Until Page Contains Element  //button[@name="button"]
  Click Element  //button[@name="button"]
  Close Browser
