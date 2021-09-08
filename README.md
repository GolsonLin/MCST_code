# MCST_code
---
the modify card sorting refer to [this article](https://github.com/GolsonLin/MCST_code/blob/main/modified%20CS.pdf "The modified card sorting test sensitive to frontal lobe defects")
## Table of Contents

* [MCST\_code](#mcst_code)
  * [Table of Contents](#table-of-contents)
  * [Install](#install)
  * [Parameter](#parameter)
    * [image](#image)
  * [Execute the test](#execute-the-test)
  * [Output file](#output-file)
  * [Troubleshooting](#troubleshooting)
  * [Update History](#update-history)
    * [V1](#v1)
    * [V2](#v2)
  * [Reference](#reference)
## Install

please see [Psytoolbox-3](http://psychtoolbox.org/download.html)
* windows
	* Download the Psychtoolbox installer to your desktop.
	* install the 64-Bit GStreamer-1.18.0
	* install the Microsoft Runtime Libraries for MSVC 2015-2019
	* Open Matlab as administrative user (for Windows 7 and later, right-click the Matlab shortcut and “Run As Administrator”) and type the following in the command window, assuming you want Psychtoolbox to be installed inside the C:\toolbox folder:
	```
	>> cd('into the folder where you downloaded DownloadPsychtoolbox.m to').
	>> DownloadPsychtoolbox('C:\toolbox')
	 ```

## Parameter

* `output_folder` the output folder name (default `CS`)
* `key_<num>` the four answer keys (default `Z` `X` `C` `V`)
*  `continueCondition` how many question continue right will go to next rule (default `6`)
*  `numTrials`   the most trials in the test (default `48`)

### image

[`image`](https://github.com/GolsonLin/MCST_code/tree/main/image) all other components will be used
`question` select cards as question cards and name `<color><shape><number>.png`
24 select cards have only one atribute as same as the Answer cards
`cardArray` a matrix for record all select cards atributes
`111.png` `222.png` `333.png` `444.png` the Answer cards

## Execute the test
0. Run MWCST
1. Press any key to begin
2. Question cards at lower left and four Answer cards at the upper right
3. choose one Anwser cards if this card not have any Question card atributes, zero as the rule number means the rule not descide
4. the Question cards from the select cards have random order and all select card can arise twice
5. all test have 2 round and the first rule is descided by the subject and than random rule order for left two rule
6. if the rule order is `1→2→3` in the first round the second round will be `1→2→3`   
7. if the subject meet the continue condition on the roll it will go to next rule
8. If 2 round test is finished, it is finish and the screen pops out "press any key to end"

## Output file

---
* this test will output a `CSV file` in `<output_folder>_<number>`

* `CSV file` name is `exp_<date>`.
* `CSV header`

| Rule | Atribute_1 | Atribute_2 | Atribute_3 | Resp | RT | Correct |
| ---- | :----------: | :----------: | :----------: | :----: | :--: | :-------: |
|0 to 3|Color|Shap|Number|1 to 4|Second|0 or 1|

*  Atribute & Rule order

| Atribute & Rule order |      1      |       2        |      3     |     4      |
| :-------- | :-----------: | :--------------: | :----------: | :----------: |
|  1.Color |     Red     |     Green      |    Blue    |   Yellow   |
|  2.Shape | Circle `🔘` | triangle `🔺` | Cross `➕` | Stars `✴` |
| 3.Number |       1     |       2        |     3      |      4     |
|                        * 0 not decide rule  | 😊 |Smile mesns answer is right.|🙁 |Sad means answer is wrong.|

## Troubleshooting

---

<h2 id="todo">TODO</h2>

---
literature review about the statistical relationship between MIC and modify card sorting test 

## Update History
---

### V1

* update 2021/08/30 
* original

### V2
* update 2021/08/30 
* print trial in command window
* change header from Ans to Atribute

## Reference
---
* [`The modified card sorting test sensitive to frontal lobe defects`](https://github.com/GolsonLin/MCST_code/blob/main/modified%20CS.pdf "The modified card sorting test sensitive to frontal lobe defects")
*  [image source](http://pebl.sourceforge.net/download.html)
*  [Psytoolbox](http://psychtoolbox.org/)
