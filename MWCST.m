clc ;close all;clear;
%% set key, parameters and folder
output_folder='CS';
key_1='Z'; key_2='X'; key_3='C'; key_4='V'; 
%how many cards you are on a roll can go to next rules 
continueCondition = 6;
% In this modify card sorting, question cards have 24 cards and all the cards doesn't
%have two atributes as same as answer cards.    
% one cards can be used twice, so the most cards we can use only 48 cards.
numTrials = 48;
% make output folder
folderNumber=1;
while 1
    CardSortingfolder = [pwd '\' output_folder '_' num2str(folderNumber)];
    if ~exist(CardSortingfolder)
        mkdir(CardSortingfolder)
        break
    end
    folderNumber=folderNumber+1;
end
filename = CardSortingfolder;
%% start exp
try
  
    % Setup PTB with some default values
    Screen('Preference', 'SkipSyncTests', 1);
    PsychDefaultSetup(2);
    
    % Seed the random number generator. Here we use the an older way to be
    % compatible with older systems. Newer syntax would be rng('shuffle'). Look
    % at the help function of rand "help rand" for more information
    rand('seed', sum(100 * clock));
    
    % Set the screen number to the external secondary monitor if there is one
    % connected
    screenNumber = max(Screen('Screens'));
    
    % Define black, white and grey
    white = WhiteIndex(screenNumber);
    grey = white / 2;
    black = BlackIndex(screenNumber);
    
    % Open the screen
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, black, [], 32, 2);
    
    % Flip to clear
    Screen('Flip', window);
    
    % Query the frame duration
    ifi = Screen('GetFlipInterval', window);
    
    % Set the text size
    Screen('TextSize', window, 60);
    
    % Query the maximum priority level
    topPriorityLevel = MaxPriority(window);
    
    % Get the centre coordinate of the window
    [xCenter, yCenter] = RectCenter(windowRect);
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
      %Obtain some information of experiment
    %     [info]=infoFun;
    %     HideCursor
    %get four answer card
    temp1=imread('image/111.png');temp2=imread('image/222.png');temp3=imread('image/333.png');temp4=imread('image/444.png');
    para=struct(...
        'bt1',temp1,...
        'bt2',temp2,...
        'bt3',temp3,...
        'bt4',temp4...
        );
    % get all questions card atributes matrix (color shape number) and
    % background render
    load('image/cardArray','cardArray');
    background=zeros(screenYpixels,screenXpixels,3);
%      background=zeros(1080,1920,3);
%     background(241:440,621:745,:)=para.bt1;
    background(round(screenYpixels*1/5):round(screenYpixels*1/5)+199,round(screenXpixels*1/3):round(screenXpixels*1/3)+124,:)=para.bt1;
    background(round(screenYpixels*1/5):round(screenYpixels*1/5)+199,round(screenXpixels*1/3)+124+62:round(screenXpixels*1/3)+2*124+62,:)=para.bt2;
    background(round(screenYpixels*1/5):round(screenYpixels*1/5)+199,round(screenXpixels*1/3)+2*124+2*62:round(screenXpixels*1/3)+3*124+2*62,:)=para.bt3;
    background(round(screenYpixels*1/5):round(screenYpixels*1/5)+199,round(screenXpixels*1/3)+3*124+3*62:round(screenXpixels*1/3)+4*124+3*62,:)=para.bt4;
    background=uint8(background);
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    
    %----------------------------------------------------------------------
    %                       Timing Information
    %----------------------------------------------------------------------
    
    % Interstimulus interval time in seconds and frames
    isiTimeSecs = 1;
    isiTimeFrames = round(isiTimeSecs / ifi);
    
    % Numer of frames to wait before re-drawing
    waitframes = 1;
    
    
    %----------------------------------------------------------------------
    %                       Keyboard information
    %----------------------------------------------------------------------
    
    % Define the keyboard keys that are listened for. We will be using four
    % keys adjacent others as response keys for the task and the escape key as
    % a exit/reset key
    KbName('UnifyKeyNames')
    escapeKey = KbName('ESCAPE');
    button_1=KbName(key_1);
    button_2=KbName(key_2);
    button_3=KbName(key_3);
    button_4=KbName(key_4);
    %----------------------------------------------------------------------
    %                     Card and data
    %----------------------------------------------------------------------
    
    % We are going to use three atributes colors, shape and number for this test.
    colorList = {'Red','Green','Blue','Yellow'};
    shapeList = {'Circle','Triangle','Cross','Star'};
    numberList = {'1','2','3','4'};
    % True & False image render
    F=imread('image/sadred.png');
    T=imread('image/happygreen.png');
    RIMG=background;
    RIMG(round(screenYpixels*4/7):round(screenYpixels*4/7)+251,round(screenXpixels*3/5):round(screenXpixels*3/5)+274,:)=F;
    FTexture = Screen('MakeTexture', window, RIMG);
    RIMG=background;
    RIMG(round(screenYpixels*4/7):round(screenYpixels*4/7)+251,round(screenXpixels*3/5):round(screenXpixels*3/5)+274,:)=T;
    TTexture = Screen('MakeTexture', window, RIMG);
    %----------------------------------------------------------------------
    %                     Make a matrix for question order 
    %----------------------------------------------------------------------
    cardOrder = randperm(numTrials);  
    
    continue_right=0;
    %----------------------------------------------------------------------
    %                       Experimental loop
    %----------------------------------------------------------------------
    imagelist=[];
    temp=cell(3,1);
    % Animation loop: we loop for the total number of trials
    %the answer is decide after press button and if the first three rule is
    %1 2 3 after rule is 1 2 3
    rule_decide=0;
    for trial = 1:numTrials
      
        
        % Cue to determine whether a response has been made
        respToBeMade = true;
        
        % If this is the first trial we present a start screen and wait for a
        % key-press
        if trial == 1
            DrawFormattedText(window, 'Press Any Key To Begin',...
                'center', 'center', white);
            Screen('Flip', window);
            KbStrokeWait;%any key to begin
        end
        
        % Flip again to sync us to the vertical retrace at the same time as
        % drawing our fixation point
        Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
        vbl = Screen('Flip', window);
        
        % Now we present the isi interval with fixation point minus one frame
        % because we presented the fixation point once already when getting a
        % time stamp
        for frame = 1:isiTimeFrames - 1
            
            % Draw the fixation point
            Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
            
            % Flip to the screen
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        end
        
        % use GetSecs can start timing
  
        tStart = GetSecs;
        while respToBeMade == true
            theImage=imread(fullfile('image','question',[num2str(cardArray(1,cardOrder(trial)))...
                num2str(cardArray(2,cardOrder(trial))) num2str(cardArray(3,cardOrder(trial))) '.png']));
            cardAttributs=cardArray(:,cardOrder(trial));
            stiIMG=background;
            stiIMG(round(screenYpixels*5/7):round(screenYpixels*5/7)+199,round(screenXpixels*1/10):round(screenXpixels*1/10)+124,:)=theImage;
            % Draw the image
            % DrawFormattedText(window, char(theWord), 'center', 'center', theColor);
            imageTexture = Screen('MakeTexture', window, stiIMG);
            Screen('DrawTexture', window, imageTexture, [], [], 0);
            % Flip to the screen
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            
            % Check the keyboard. The person should press the
            
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                sca;
                return
                
            elseif keyCode(button_1)
                response = 1;
                respToBeMade = false;
                %descide
                if rule_decide==0
                    [rule_decide,ruleOrder]=rule(response,cardAttributs);
                    if rule_decide==1
                        ruleOrder=[ruleOrder ruleOrder];
                        rule_num=1;
                        
                    else
                        rule_num=0;
                    end
                    
                end
                if rule_num ~= 0
                    rule_now=ruleOrder(rule_num);
                else
                    rule_now=0;
                end
                
                [R,C]=checkAns(response,rule_now,cardAttributs);
                Screen('DrawTexture', window,eval([R 'Texture']), [], [], 0);
                Screen('Flip', window);
                WaitSecs(1);
            elseif keyCode(button_2)
                response = 2;
                respToBeMade = false;
                %descide
                if rule_decide==0
                    [rule_decide,ruleOrder]=rule(response,cardAttributs);
                    if rule_decide==1
                        ruleOrder=[ruleOrder ruleOrder];
                        rule_num=1;
                        
                    else
                        rule_num=0;
                    end
                    
                end
                if rule_num ~= 0
                    rule_now=ruleOrder(rule_num);
                else
                    rule_now=0;
                end
                
                [R,C]=checkAns(response,rule_now,cardAttributs);
                Screen('DrawTexture', window,eval([R 'Texture']), [], [], 0);
                Screen('Flip', window);
                WaitSecs(1);
            elseif keyCode(button_3)
                response = 3;
                respToBeMade = false;
                %descide
                if rule_decide==0
                    [rule_decide,ruleOrder]=rule(response,cardAttributs);
                    if rule_decide==1
                        ruleOrder=[ruleOrder ruleOrder];
                        rule_num=1;
                        
                    else
                        rule_num=0;
                    end
                    
                end
                if rule_num ~= 0
                    rule_now=ruleOrder(rule_num);
                else
                    rule_now=0;
                end
                
                [R,C]=checkAns(response,rule_now,cardAttributs);
                Screen('DrawTexture', window,eval([R 'Texture']), [], [], 0);
                Screen('Flip', window);
                WaitSecs(1);
            elseif keyCode(button_4)
                response = 4;
                respToBeMade = false;
                %descide
                if rule_decide==0
                    [rule_decide,ruleOrder]=rule(response,cardAttributs);
                    if rule_decide==1
                        ruleOrder=[ruleOrder ruleOrder];
                        rule_num=1;
                        
                    else
                        rule_num=0;
                    end
                    
                end
                if rule_num ~= 0
                   
                    rule_now=ruleOrder(rule_num);
                else
                    rule_now=0;
                end
                
                [R,C]=checkAns(response,rule_now,cardAttributs);
                Screen('DrawTexture', window,eval([R 'Texture']), [], [], 0);
                Screen('Flip', window);
                WaitSecs(1);
            end
            
        end
        tEnd = GetSecs;
        rt = tEnd - tStart;
        if R=='T'
            continue_right=continue_right+1;
        elseif R=='F'
            continue_right=0;
        end
        % Record the trial data into out data matrix
        data{trial,1} = rule_now ;
        data{trial,2} = cardAttributs;
        data{trial,3} = response;
        data{trial,4} = rt;
        data{trial,5} = C;
        if continue_right==continueCondition
            rule_num=rule_num+1;
            continue_right=0;
        end
        if rule_num==7
            break
        end
    end
   
    % End of experiment screen. We clear the screen once they have made their
    % response
    DrawFormattedText(window, 'Experiment Finished \n\n Press Any Key To Exit',...
        'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;
    sca;
    header = {'Rule','Ans', 'Resp', 'RT', 'Correct'};
    data_table = cell2table(data, 'VariableNames', header);
    % Create a csv file to save data
    exp_data = strcat([filename '\'], 'exp_', date, '.csv');
    writetable(data_table, exp_data);
    result.datatable=data_table;
    result.Imagelist=imagelist;
    
    disp('Succeed!');
catch
    %     ShowCursor
    
    psychrethrow(psychlasterror);
end

    function [rule_decide, answer_order]=rule(response,cardAttributes)
        if response==cardAttributes(1) % colorrule
            ruleNum=1;
            rule_decide=1;
        elseif response==cardAttributes(2)% shaperule
            ruleNum=2;
            rule_decide=1;
        elseif response==cardAttributes(3) % numrule
            ruleNum=3;
            rule_decide=1;
        else
            ruleNum=0;
            rule_decide=0;
        end
        switch ruleNum
            case 0
                answer_order=0;
            case 1
                order_rand=rand(1);
                if order_rand<0.5
                    answer_order=[1 2 3];
                else
                    answer_order=[1 3 2];
                end
            case 2
                order_rand=rand(1);
                if order_rand<0.5
                    answer_order=[2 1 3];
                else
                    answer_order=[2 3 1];
                end
            case 3
                order_rand=rand(1);
                if order_rand<0.5
                    answer_order=[3 2 1];
                else
                    answer_order=[3 1 2];
                end
        end
    end
    function [R,C]=checkAns(response,ruleAns,Attributes)
        if ruleAns~=0
            if response == Attributes(ruleAns,1)
                R='T';
                C=1;
            else
                R='F';
                C=0;
            end
        elseif ruleAns==0
            R='F';
            C=0;
        end
        
        
    end

