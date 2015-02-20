For the subject of my application, I took a wild stab by googling datasets first. Then came across [the ARDA](http://www.thearda.com/) (Association of Religious Data Archives). In particular, I found the following survey [Arab Barometer (2006-2007)](http://www.thearda.com/Archive/Files/Descriptions/ARABBARO.asp) interesting. So I stopped there and thought I'd do a little exploritory analysis to see what I could come up with.

After downloading the survey questions, I decided that a good question to ask would be whether or not I could predict which individual would be an internet user based on the country and groomed data, these are: Age, Education, Employment, Gender, Marital Status, Religion. The Explore tab above represents the bulk of this application.

However, the rate of internet use in this survey is low. The breakpoint chosen was levels (1-3) monthly to daily. The rpart method is used (classification tree).

The prediction appilication is under the 'Application tab'. You can create a decision tree based on the partitioning you select. Press the Test button to show the accuracy of the model.
