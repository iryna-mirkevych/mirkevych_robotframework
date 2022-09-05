*** Settings ***
Library   SeleniumLibrary
Documentation   Suite description #automated tests for scout website

*** Variables ***
#Login to the system
${LOGIN URL}        https://scouts-test.futbolkolektyw.pl/en
${BROWSER}      Chrome
${SIGNINBUTTON}     xpath=//*[@type='submit']
${EMAILINPUT}       xpath=//*[@id='login']
${PASSWORDINPUT}        xpath=//*[@id='password']
${DASHBOARD PAGELOGO}     xpath=//header//h6
#Panel title (at login page)
${PANELTITLE}      xpath=//form/div/div[1]/h5
#Test password validation
${VALIDATIONSPAN}      xpath = //form//div[1]/div[3]/span
#Test sign out
${SIGNOUTBUTTON}    xpath = //ul[2]/div[2]
#test add player
${ADDPLAYERLINK}       xpath = //div[1]//div[3]/div[2]//a
${ADDPLAYER HEADER}     xpath = //form/div[1]/div/span
${PLAYER NAME FIELD}      xpath = //*[@name = 'name']
${PLAYER SURNAME FIELD}       xpath = //*[@name = 'surname']
${PLAYER AGE FIELD}       xpath = //*[@name = 'age']
${PLAYER MAIN POSITION FIELD}     xpath = //*[@name = 'mainPosition']
${ADDPLAYER SUBMIT BUTTON}      xpath =//*[@type='submit']
${EDITPLAYER PAGE HEADER}        xpath =//form/div[1]/div/span
${EDITPLAYER PAGE TITLE}   xpath =//title
#Dashboard
${PLAYERS BUTTON}   xpath =//ul[1]/div[2]
${PLAYERS PAGE TITLE}   xpath =//title
${PLAYERS PAGE URL}     https://scouts-test.futbolkolektyw.pl/en/players
#Players page
${PLAYER DATA LINK}   xpath = //td[1]
${SORT BUTTON}      xpath = //main//span[2]/button
${REPORTS INPUT}        xpath = //label[8]/span[1]
${REPORTS COLUMN HEADER}  xpath = //table//tr/th[8]

*** Test Cases ***
#Login page
Login to the system
    Open login page
    Type in email
    Type in password
    Click the sign in button
    Assert dashboard
    [Teardown] Close Browser

    #Panel title (at login page)
Test panel title
    Open Login Page
    Assert loginpage
    [Teardown] Close Browser

Test password validation
    Open login page
    Type in email
    Click the sign in button
    Assert password validation text
    [Teardown] Close Browser

Test sign out
    Login
    Click the sign out button
    Assert loginpage
    [Teardown] Close Browser

#add_player_page
test_add_player
    Login
    Click add player link
    Assert add player page
    Fill in player data
    Click add player submit button
    Assert Edit Player Page
    [Teardown] Close Browser

#Dashboard
test_players_button
    Login
    Click players button
    Assert players page
    [Teardown] Close Browser

#Players page
Test open player
    Login
    Click players button
    Assert players page
    Click player data link
    Assert Edit Player Page
    [Teardown] Close Browser

Test sort
    Login
    Click players button
    Assert players page
    Click sort button
    Click reports input
#    Sleep 3 #to visually check the action
    Check reports column not present
    [Teardown] Close Browser


*** Keywords ***
#Login to the system
Open login page
    Open browser        ${LOGIN URL}        ${BROWSER}
    Title Should be     Scouts panel - sign in
Type in email
    Input Text      ${EMAILINPUT}       user01@getnada.com
Type in password
    Input Text      ${PASSWORDINPUT}        Test-1234
Click the sign in button
    Click element       ${SIGNINBUTTON}
Assert dashboard
    Wait until element is visible       ${DASHBOARD PAGELOGO}
    title should be     Scouts panel
    Capture Page Screenshot     alert.png

#Test panel title (at login page)
Assert loginpage
    Wait until element is visible       ${PANELTITLE}
    title should be     Scouts panel - sign in
    Capture Page Screenshot     alert.png

Login
    Open login page
    Type in email
    Type in password
    Click the sign in button
    Assert dashboard

#Test password validation
Assert password validation text
    Wait until element is visible       ${VALIDATIONSPAN}
    Element Text Should Be      ${VALIDATIONSPAN}  Please provide your password.
    Capture Page Screenshot     alert.png

#Test sign out
Click the sign out button
     Click element       ${SIGNOUTBUTTON}

#Test add player
Click add player link
    Click element       ${ADDPLAYERLINK}
Assert add player page
    Wait until element is visible       ${ADDPLAYER HEADER}
    title should be     Add player
    Capture Page Screenshot     alert.png
Fill in player data
    Input Text      ${PLAYER NAME FIELD}        Ivan
    Input Text      ${PLAYER SURNAME FIELD}     Ivanenko
    Input Text      ${PLAYER AGE FIELD}         12.12.2022
    Input Text      ${PLAYER MAIN POSITION FIELD}   goalkeeper

Click add player submit button
    Click element     ${ADDPLAYER SUBMIT BUTTON}

Assert edit player page
    Wait Until Element Is Visible       ${EDITPLAYER PAGE HEADER}
    Wait Until Page Contains        Edit
    Capture Page Screenshot     alert.png

#Dashboard
Click players button
    Wait until element is visible   ${PLAYERS BUTTON}
    Click element       ${PLAYERS BUTTON}
Assert players page
    Wait Until Location Is  ${PLAYERS PAGE URL}     10

#Players page
Click player data link
    Click element       ${PLAYER DATA LINK}

Click sort button
    Wait until element is visible   ${SORT BUTTON}      5
    Click element       ${SORT BUTTON}
Click reports input
    Wait until element is visible   ${REPORTS INPUT}    5
    Click element       ${REPORTS INPUT}
Check reports column not present
    Wait Until Element Is Not Visible       ${REPORTS COLUMN HEADER}

Sleep 3
    Sleep       3

[Teardown] Close browser
    Close browser

