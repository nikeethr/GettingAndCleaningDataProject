Code Book
=========

#Brief Description
TidyData.txt contains the following columns:
*   SubjectID: The unique integer ID of the subject from whom various measurements is taken.
*   Activity: The type of activity the subject was undertaking.
*   FeatureName: The name of the feature that was measured.
*   FeatureStatistic: The type of statistical measure performed on the observations of each feature for each SubjectID and Activity.
*   FeatureAverage: The average value over all observations of each feature for a given SubjectID, Activity.

#Variables

##Subject ID
Unique ID of each subject

type: int
values: 1 to 30

##Activity
Activity that each subject perfomed. The activities performed are self explanatory

type: factor
values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

##Feature Statistic
The statistical measure performed on observations of each feature

type: factor
values: mean, std

mean - the mean value of each feature for a given activity and subject
std - the standard deviation of each feature for a given activity and subject

##Feature Average
The average value of observations of each feature for a given subject and activity

type: double
values: bound between [-1,1] (since the data is bound between -1 and 1)

##Feature Names
The name of the feature that is measured

type: string
values: see description below

The feature names follow a logical naming format, the names can be disected into a few parts.

1.  t/f: Measurement is in the Time domain (t) or Frequency domain (f)
2.  Body/Gravity: Measurement is of either Body or Gravity
3.  Acc/Gyro: Measurement is either from Accelerometer (Acc) or Gyroscope (Gyro)
4.  Jerk/(empty): Can be empty. If its not empty, 'Jerk' is change in the given feature over time, for example ..AccJerk.. is the change in acceleration over time.
5.  -X/-Y/-Z/Mag: Measurement is from the X axis (-X) or Y axis (-Y) or Z axis (-Z)

units:
* Accelerometer: m/s/s
* Accelerometer Jerk: m/s/s/s
* Gyroscope: rad/s
* Gyroscope Jerk: rad/s/s

Note: since the values are generally in [-1,1] I assume that at least the acceleration must have been normalized by gravity (9.8 m/s/s)
