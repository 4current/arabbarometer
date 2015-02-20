# function to get the source data files and only get them once
getOnce <- function(url, destfile) {
    if (!file.exists(destfile)) {
        print("Datafile does not exist exist - downloading it")
        download.file(url, destfile)
    } else
        print("File already exists - not downloading")  
}

# if cleanData was already created, use it. 
if (file.exists("cleanData.RData")) {
    
    load("cleanData.RData")
    
} else {
    
    # A Fixed Width Text File
    dataFilename <- 'data/Arab Barometer, 2006-2007.DAT'
    getOnce(paste('http://www.thearda.com/download/download.aspx',
                  'file=Arab%20Barometer,%202006-2007.DAT', sep='?'),
            dataFilename)
    
    # Column Headings
    headingFilename <- 'data/Arab Barometer, 2006-2007.COL'
    getOnce(paste('http://www.thearda.com/download/download.aspx',
                  'file=Arab%20Barometer,%202006-2007.COL', sep='?'),
            headingFilename)
    
    # Read in and condition the Column Headings
    library(dplyr)
    library(stringr)
    
    fwidth <- function(rangeString) {
        ranges <- sapply(str_split(rangeString, '-'), as.numeric)
        sapply(ranges, function(x) {x[length(x)] - x[1] + 1}) 
    }
    
    headings <- read.table(headingFilename, skip=1) %>%
        transmute(variable=str_replace(V2, '(.*):', '\\1'), fwidth=fwidth(V3)) %>%
        mutate(variable=str_replace(variable, '-','.'))
    
    # Now let's read in the data
    library(data.table)
    dataTable <- read.fwf(dataFilename,
                          headings$fwidth,
                          col.names=headings$variable)
    
    # Clean data here
    dataTable[is.na(dataTable$I.RELIGION), 'I.RELIGION'] <- 4
    cleanData <- dataTable %>%
        mutate(education=factor(I.EDUC,
                                labels=c('Illiterate', 'Primary', 'Secondary',
                                         'Associate', 'Bachelor', 'Graduate'))) %>%
        mutate(married=factor(I.MARITAL,
                              labels=c('Single', 'Married', 'Other'))) %>%
        mutate(age=factor(I.AGE,
                          labels=c('18-24', '25-34', '35-44',
                                   '45-54', '55-64', '65+')))  %>%
        mutate(employed=factor(I.EMPLOY,
                               labels=c('Yes', 'No')))  %>%
        mutate(sex=factor(I.GENDER, labels=c('Male', 'Female'))) %>%
        mutate(religion=factor(I.RELIGION,
                               labels=c('Muslim', 'Christian', 'Druze', 'Unknown'))) %>%
        mutate(country=factor(COUNTRY,
                              labels=c('Jordan', 'Palestine', 'Algeria',
                                       'Morroco', 'Lebanon', 'Yemen'))) %>% 
        rename(internet=INTERNET) %>%
        select(country, internet, education, married, age, employed, sex, religion)
    
    cleanData$internet <- ifelse(cleanData$internet <= 3, 2, 1)
    cleanData$internet <- factor(cleanData$internet, labels=c("Non-User", "User"))
    cleanData <- cleanData[complete.cases(cleanData),]
    save(cleanData, file="cleanData.RData")
}