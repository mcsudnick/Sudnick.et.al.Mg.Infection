Data File: Three.Year.Repeat.InfectionA.csv
Bird.ID –  Identification number of the individual bird	
Year –  What year the samples were taken, 2020 for the first experiment, 2023 for the second experiment
Infection –  Denotes whether the sample was taken during a first or second infection	
Un.ID – A unique identification combining both the bird’s identification number and the infection number (first or second)	
day – day of the infection, Immediately before inoculation  = day zero
Mass – mass in grams of the bird
Fat.Score – On a scale of 1 to 3, the amount of visible fat present on the bird 
Eye.Score.Left	 – On a scale of 1 to 3, the severity of the eye lesions present in the left eye
Eye.Score.Right – On a scale of 1 to 3, the severity of the eye lesions present in the right eye	
Eye – The sum of Eye.Score.Left and Eye.Score.Right
hem – Percent of hematocrit in a blood sample taken from the bird
ant – Level of MG specific IgY antibody present in plasma taken from the bird
anta – Whether the sample is positive or negative for MG specific IgY antibodies
pathlog – the log of the pathogen load present in the conjunctiva of the bird

Data File: Transmission.ExperimentA.csv
Bird.ID – Identification number of the individual bird
Index – Denotes whether bird was an index bird, character
IndexA	– Denotes whether bird was an index bird, numeric
Status.A– Denotes whether bird was infected based on eye score, character	
Status.bac.A– Denotes whether bird was infected based on pathogen load, character	
Status	– Denotes whether bird was infected based on eye score, numeric	
Statusbac – Denotes whether bird was infected based on pathogen load, numeric	
Flock.ID – Identification for the flock, or group of four birds, the bird was placed in
Treat – Denotes the treatment, either first or second infection flock, character 
TreatA – Denotes the treatment, either first or second infection flock, numeric	
Trans –	 Denotes if there was transmission in the flock by eye score, character
Trans.bac – Denotes if there was transmission in the flock by pathogen load, character
TransA	 – Denotes if there was transmission in the flock by eye score, numeric
Trans.bac.A –	Denotes if there was transmission in the flock by pathogen load, numeric
Round – Which of three rounds the flock was a part of
Sex – M = Male, F = Female
Treat.num – Denotes the treatment, either first or second infection flock, numeric
day – day of the infection, Immediately before inoculation  = day zero
sample	– Description of the sample taken on that day, Eye = pathogen load eye swab, Blood = eye swab and blood sample
sample.ex –	Notation of the sample taken on that day, 1 = additional sample taken, 0 = only checked for eye lesions
Eye –	Sum of eye lesion severity ranked from 1 to 3 in both eyes
mass – mass in grams of the bird
fat – On a scale of 1 to 3, the amount of visible fat present on the bird
hem –	Percent of hematocrit in a blood sample taken from the bird
ant – Level of MG specific IgY antibody present in plasma taken from the bird	
logSQ	– the log of the pathogen load present in the conjunctiva of the bird
bac.y.n	 – Whether or not bacteria is present within the eye
visit – Number of seconds spent on the bird feeder over the course of the day by that individual

Data File: Flocks.uploadA.csv
Flock.ID – Identification for the flock, or group of four birds, the bird was placed in	
Treat –  Denotes the treatment, either first or second infection flock, character
Trans.bac – Denotes if there was transmission in the flock by pathogen load, numeric
treat – Denotes the treatment, either first or second infection flock, numeric
