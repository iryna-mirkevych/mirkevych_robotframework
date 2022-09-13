*** Settings ***
Library   SeleniumLibrary
Documentation   Suite description #automated tests for scout website

*** Variables ***
#Login to the system
${LOGIN URL}        https://scouts.futbolkolektyw.pl/
#Test
#${LOGIN URL}    https://scouts-test.futbolkolektyw.pl/en
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
${PLAYER PREVIOUS CLUB FIELD}      xpath =//div[18]//input
${ADDPLAYER SUBMIT BUTTON}      xpath =//*[@type='submit']
${EDITPLAYER PAGE HEADER}        xpath =//form/div[1]/div/span
${EDITPLAYER PAGE TITLE}   xpath =//title
#Dashboard
${PLAYERS BUTTON}   xpath =//ul[1]/div[2]
${PLAYERS PAGE TITLE}   xpath =//title
${PLAYERS PAGE URL}     https://scouts.futbolkolektyw.pl/en/players
#Test
#${PLAYERS PAGE URL}     https://scouts-test.futbolkolektyw.pl/en/players
#Players page
${PLAYER DATA LINK}   xpath = //td[1]
${VIEW COLUMNS BUTTON}      xpath = //main//span[2]/button
${REPORTS INPUT}        xpath = //label[8]/span[1]
${REPORTS COLUMN HEADER}  xpath = //table//tr/th[8]
#Add match button
${MATCHES BUTTON}   xpath =//ul[2]/div[2]
${ADD MATCH BUTTON}         xpath =//a/button
${ADDING MATCH PAGE HEADER}     xpath=//form/div[1]/div/span
#Add report button
${REPORTS BUTTON}   xpath=//ul[2]/div[3]
${ADD REPORT BUTTON}    xpath=//main/a

#Remind password
${REMIND PASSWORD HYPERLINK}   xpath=//child::div/a
${REMIND PASSWORD SEND BUTTON}      xpath=//div[2]/button


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

#error expected - Text 'Add player' did not appear in 5 sec
test_add_player_non_valid_age
    Login
    Click add player link
    Assert add player page
    Fill in player data with non valid age
    Click add player submit button
    Sleep 7
    Assert add Player Page header
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

Test view columns
    Login
    Click players button
    Assert players page
    Click view columns button
    Click reports input
#    Sleep 3 #to visually check the action
    Check reports column not present
    [Teardown] Close Browser

#error expected (404 page)
Test add match button
    Open player
    Click Matches button
    Click Add Match button
    Assert Adding Match page
    [Teardown] Close Browser

#error expected (Matches page is opened, not Adding Report page)
Test add report button
    Open player
    Click Reports button
    Click Add Report button
    Assert Adding Report page
    [Teardown] Close Browser

#error expected (with empty email the page should change, e.g. validation about email is required)
Test remind password empty email
    Open login page
    Click remind password button
    Click send button
    Sleep 7
    Assert remind password page changed
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
    title should be     PANEL SKAUTINGOWY
    #title should be     Scouts panel
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
    Input Text      ${PLAYER AGE FIELD}         12.12.2002
    Input Text      ${PLAYER MAIN POSITION FIELD}   goalkeeper
    Input Text      ${PLAYER PREVIOUS CLUB FIELD}   Dynamo

Click add player submit button
    Click element     ${ADDPLAYER SUBMIT BUTTON}

Assert edit player page
    Wait Until Element Is Visible       ${EDITPLAYER PAGE HEADER}
    Wait Until Page Contains        Edit
    Capture Page Screenshot     alert.png


    #test_add_player_non_valid_age
Fill in player data with non valid age
    Input Text      ${PLAYER NAME FIELD}        Ivan
    Input Text      ${PLAYER SURNAME FIELD}     Ivanenko
    Input Text      ${PLAYER AGE FIELD}         12.12.2022
    Input Text      ${PLAYER MAIN POSITION FIELD}   goalkeeper
    Input Text      ${PLAYER PREVIOUS CLUB FIELD}   Dynamo

Assert add Player Page header
    Wait Until Element Is Visible       ${ADDPLAYER HEADER}
    Wait Until Page Contains        Add player
    Capture Page Screenshot     alert.png

#Dashboard
Click players button
    Wait until element is visible   ${PLAYERS BUTTON}
    Click element       ${PLAYERS BUTTON}
Assert players page
    Wait Until Location Is  ${PLAYERS PAGE URL}     10
    Capture Page Screenshot     alert.png

#Players page
Click player data link
    Click element       ${PLAYER DATA LINK}

Click view columns button
    Wait until element is visible   ${VIEW COLUMNS BUTTON}      5
    Click element       ${VIEW COLUMNS BUTTON}
Click reports input
    Wait until element is visible   ${REPORTS INPUT}    5
    Click element       ${REPORTS INPUT}
Check reports column not present
    Wait Until Element Is Not Visible       ${REPORTS COLUMN HEADER}
    Capture Page Screenshot     alert.png

Sleep 3
    Sleep       3

#Test add match button
Open player
    Login
    Click players button
    Assert players page
    Click player data link
    Assert Edit Player Page

Click Matches button
    Wait until element is visible   ${MATCHES BUTTON}
    Click element       ${MATCHES BUTTON}
Click Add Match button
    Wait until element is visible   ${ADD MATCH BUTTON}
    Click element       ${ADD MATCH BUTTON}
Assert Adding Match page
    Wait Until Element Is Visible       ${ADDING MATCH PAGE HEADER}
    Wait Until Page Contains        Adding match
    Capture Page Screenshot     alert.png

#Test add report button
Click Reports button
    Wait until element is visible   ${REPORTS BUTTON}
    Click element       ${REPORTS BUTTON}
Click Add Report button
    Wait until element is visible   ${ADD REPORT BUTTON}
    Click element       ${ADD REPORT BUTTON}
Assert Adding Report page
    Wait Until Page Contains        Adding match    10
    Capture Page Screenshot     alert.png


#Test remind password empty email
Click remind password button
    Wait until element is visible   ${REMIND PASSWORD HYPERLINK}
    Click element       ${REMIND PASSWORD HYPERLINK}
Click send button
    Wait until element is visible   ${REMIND PASSWORD SEND BUTTON}
    Click element       ${REMIND PASSWORD SEND BUTTON}
Assert remind password page changed
    Wait Until Page Contains        email    10
    Capture Page Screenshot     alert.png
    #let's presume the validation message should appear with the word "email"

Sleep 7
    Sleep       7

[Teardown] Close browser
    Close browser

