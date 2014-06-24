# Qualtrics R Package

The `qualtrics` R package provides functions to interact with the [Qualtrics](http://www.qualtrics.com) online survey tool. It requires that your account have API access. The latest development version can be installed from Github with the `devtools` package.

	> require(devtools)
	> install_github('qualtrics', 'ericpgreen')
	
I forked the core functions to access the Qualtrics from [Jason Bryer's `qualtrics` repo](https://github.com/jbryer/qualtrics) to use Version 2.3 of the Qualtrics API.

API Credentials
----------------
The first step is to run the `auth()` function which takes the arguments `useremail`, `brand`, and `token`. If you do not access Qualtrics through a `brand` (e.g., duke), then leave this blank. You'll need an API token. To get one, login to your account, go to account details, and generate a token. 

Downloading Survey Data
------------------------
After you create an `auth` object, pass it to `getSurveyResults()` along with your `surveyid`. You can get a list of survey IDs on your account page of Qualtrics.

Create and Import Surveys
-------------------------
My initial motivation for working on this package was to make it easier to program [Qualtrics](http://www.qualtrics.com/) surveys. The most common approach is to use the web interface to create each item. This becomes tedious, however, when you have more than 20 items. 

Fortunately, Qualtrics [allows bulk uploading](http://www.qualtrics.com/university/researchsuite/advanced-building/advanced-options-drop-down/import-and-export-surveys/) of items via a `.txt` file. Rather than typing this file directly, however, I wanted to specify survey items in a spreadsheet and export the spreadsheet to a format Qualtrics would accept.

Edit the provided template in the `doc` directory, save it somewhere, and then use the `importTemplate()` function to import the contents to R as a list. The `writeQtxt()` function then exports the contents as a `.txt` file that you can upload to Qualtrics. 

### Template

The template.xlsx file is not fool-proof. You should read the Qualtrics [Advanced Formatting page](http://www.qualtrics.com/university/researchsuite/advanced-building/advanced-options-drop-down/import-and-export-surveys/) to get a better understanding of what the template is trying to do.

Basically:

1. Blocks are optional. If you want to put items in a block, give the first item in the block (only) a `blockname`. To end a block, select `endblock` for the last item.
2. Pick a `questiontype`. Qualtrics does not provide codes for all possible question types. As more codes are released, I will add them to the `questiontype` menu in `!menu`.
3. `questionid` is optional.
4. `questiontext` is where you type your actual item.
5. `choicetype` can be "[[Choices]]" or "[[AdvancedChoices]]". "[[AdvancedChoices]]" is not currently implemented, however.
6. Adding response options is a multi-step process. First, go to the `!choices` sheet and create response items. Give items in a set the same `listname`. Add this `listname` to `choicelist` in `!menu`. Then select this `listname` from the drop-down menu in the `!survey` worksheet.
7. `pagebreak` is optional.

Future
------
Send to Qualtrics via API






