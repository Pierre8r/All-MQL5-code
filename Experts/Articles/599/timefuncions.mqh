//+------------------------------------------------------------------+
//|                                                 TimeFuncions.mqh |
//|                        Copyright 2011, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
//+------------------------------------------------------------------+
//| Function for determining the time of the first bar on a lower time frame|
//| in a bar on a higher time frame                                  |
//+------------------------------------------------------------------+
bool LowerTFFirstBarTime(string aSymbol,ENUM_TIMEFRAMES aLowerTF,datetime aUpperTFBarTime,datetime  &aLowerTFFirstBarTime)
  {
   datetime tm[];
//--- determine the bar time on a lower time frame corresponding to the bar time on a higher time frame 
   if(CopyTime(aSymbol,aLowerTF,aUpperTFBarTime,1,tm)==-1)
     {
      return(false);
     }
   if(tm[0]<aUpperTFBarTime)
     {
      //--- we got the time of the preceding bar
      datetime tm2[];
      //--- determine the time of the last bar on a lower time frame
      if(CopyTime(aSymbol,aLowerTF,0,1,tm2)==-1)
        {
         return(false);
        }
      if(tm[0]<tm2[0])
        {
         //--- there is a bar following the bar of a lower time frame 
         //--- that precedes the occurrence of the bar on a higher time frame
         int start=Bars(aSymbol,aLowerTF,tm[0],tm2[0])-2;
         //--- the Bars() function returns the number of bars, whereas we need to determine the index of the bar
         //--- following the bar with time tm[0], so 
         //--- 2 is subtracted. 1 for getting the index of the bar
         //--- with time tm[0] and 1 for getting the index
         //--- of the following bar
         if(CopyTime(aSymbol,aLowerTF,start,1,tm)==-1)
           {
            return(false);
           }
        }
      else
        {
         //---there is no bar of a lower time frame contained 
         //--- in the bar on a higher time frame
         aLowerTFFirstBarTime=0;
         return(true);
        }
     }
//--- assign the obtained value to the variable 
   aLowerTFFirstBarTime=tm[0];
   return(true);
  }
//+------------------------------------------------------------------+
//| Function for determining the time of the last bar on a lower time frame|
//| in a bar on a higher time frame                                  |
//+------------------------------------------------------------------+
bool LowerTFLastBarTime(string aSymbol,ENUM_TIMEFRAMES aUpperTF,ENUM_TIMEFRAMES aLowerTF,datetime aUpperTFBarTime,datetime  &aLowerTFFirstBarTime)
  {
//--- time of the next bar on a higher time frame
   datetime NextBarTime=aUpperTFBarTime+PeriodSeconds(aUpperTF);
   datetime tm[];
   if(CopyTime(aSymbol,aLowerTF,NextBarTime,1,tm)==-1)
     {
      return(false);
     }
   if(tm[0]==NextBarTime)
     {
      //--- There is a bar on a lower time frame corresponding to the time of the next bar on a higher time frame.
      //--- Determine the time of the last bar on a lower time frame
      datetime tm2[];
      if(CopyTime(aSymbol,aLowerTF,0,1,tm2)==-1)
        {
         return(false);
        }
      //--- determine the preceding bar index on a lower time frame
      int start=Bars(aSymbol,aLowerTF,tm[0],tm2[0]);
      //--- determine the time of this bar
      if(CopyTime(aSymbol,aLowerTF,start,1,tm)==-1)
        {
         return(false);
        }
     }
//--- assign the obtained value to the variable 
   aLowerTFFirstBarTime=tm[0];
   return(true);
  }
//+------------------------------------------------------------------+
//| Normalization of time by bar length                              |
//+------------------------------------------------------------------+
datetime BarTimeNormalize(datetime aTime,ENUM_TIMEFRAMES aTimeFrame)
  {
   int BarLength=PeriodSeconds(aTimeFrame);
   return(BarLength*(aTime/BarLength));
  }
//+------------------------------------------------------------------+
//| Function for determining time in seconds since the day start     |
//| aTime - time in seconds,                                         |
//| int  &aH, int  &aM, int  &aS - returns hours,                    |
//| minutes and seconds by reference                                 |
//+------------------------------------------------------------------+
int TimeFromDayStart(datetime aTime,int  &aH,int  &aM,int  &aS)
  {
//--- Number of seconds elapsed since the day start  (aTime%86400) 
//--- divided by the number of seconds in an hour is the number of hours
   aH=(int)((aTime%86400)/3600);
//--- Number of seconds elapsed since the last hour (aTime%3600) 
//--- divided by the number of seconds in a minute is the number of minutes 
   aM=(int)((aTime%3600)/60);
//--- Number of seconds elapsed since the last minute 
   aS=(int)(aTime%60);
//--- Number of seconds since the day start
   return(int(aTime%86400));
  }
//+------------------------------------------------------------------+
//| Function for determining the number of the week since the beginning of the epoch|
//| datetime aTime - time,                                           |
//| bool aStartsOnMonday=false - the week starts on Monday           |
//+------------------------------------------------------------------+
long WeekNum(datetime aTime,bool aStartsOnMonday=false)
  {
//--- if the week starts on Sunday, add the duration of 4 days (Wednesday+Tuesday+Monday+Sunday),
//    if it starts on Monday, add 3 days (Wednesday, Tuesday, Monday)
   if(aStartsOnMonday)
     {
      aTime+=259200; // duration of three days (86400*3)
     }
   else
     {
      aTime+=345600; // duration of four days (86400*4)  
     }
   return(aTime/604800);
  }
//+------------------------------------------------------------------+
//| Function for determining the time of the week start              |
//| datetime aTime - time,                                           |
//| bool aStartsOnMonday=false - the week starts on Monday           |
//+------------------------------------------------------------------+
long WeekStartTime(datetime aTime,bool aStartsOnMonday=false)
  {
   long tmp=aTime;
   long Corrector;
   if(aStartsOnMonday)
     {
      Corrector=259200; // duration of three days (86400*3)
     }
   else
     {
      Corrector=345600; // duration of four days (86400*4)
     }
   tmp+=Corrector;
   tmp=(tmp/604800)*604800;
   tmp-=Corrector;
   return(tmp);
  } 
//+------------------------------------------------------------------+
//| Function for determining the time in seconds since the week start|
//| datetime aTime - time,                                           |
//| bool aStartsOnMonday=false - the week starts on Monday           |
//+------------------------------------------------------------------+
long SecondsFromWeekStart(datetime aTime,bool aStartsOnMonday=false)
  {
   return(aTime-WeekStartTime(aTime,aStartsOnMonday));
  }
//+------------------------------------------------------------------+
//| Function for determining the number of the week since a given date|
//| datetime aTime - time for which the number of the week is determined,|
//| datetime aStartTime - start time,                                |
//| bool aStartsOnMonday=false - the week starts on Monday           |
//+------------------------------------------------------------------+
long WeekNumFromDate(datetime aTime,datetime aStartTime,bool aStartsOnMonday=false)
  {
   long Time,StartTime,Corrector;
   MqlDateTime stm;
   Time=aTime;
   StartTime=aStartTime;
//--- determine the beginning of the reference epoch
   StartTime=(StartTime/86400)*86400;
//--- determine the time that elapsed
//--- since the beginning of the reference epoch
   Time-=StartTime;
//--- determine the day of the week of the beginning of the reference epoch
   TimeToStruct(StartTime,stm);
//--- if the week starts on Monday,
//--- numbers of days of the week are decreased by 1 and
//--- the day with number 0  becomes a day with number 6
   if(aStartsOnMonday)
     {
      if(stm.day_of_week==0)
        {
         stm.day_of_week=6;
        }
      else
        {
         stm.day_of_week--;
        }
     }
//--- calculate the value of the time corrector 
   Corrector=86400*stm.day_of_week;
//--- time correction
   Time+=Corrector;
//--- calculate and return the number of the week
   return(Time/604800);
  }
//+------------------------------------------------------------------+
//| Determining the time of the year start                           |
//| datetime aTime - time                                            |
//+------------------------------------------------------------------+
datetime YearStartTime(datetime aTime)
  {
   MqlDateTime stm;
   TimeToStruct(aTime,stm);
   stm.day=1;
   stm.mon=1;
   stm.hour=0;
   stm.min=0;
   stm.sec=0;
   return(StructToTime(stm));
  }
//+------------------------------------------------------------------+
//| Determining the time of the month start                          |
//| datetime aTime - time                                            |
//+------------------------------------------------------------------+
datetime MonthStartTime(datetime aTime)
  {
   MqlDateTime stm;
   TimeToStruct(aTime,stm);
   stm.day=1;
   stm.hour=0;
   stm.min=0;
   stm.sec=0;
   return(StructToTime(stm));
  }
//+------------------------------------------------------------------+
//| Function for determining the number of the week in a year        |
//| datetime aTime - time,                                           |
//| bool aStartsOnMonday=false - the week starts on Monday           |
//+------------------------------------------------------------------+
long WeekNumYear(datetime aTime,bool aStartsOnMonday=false)
  {
   return(WeekNumFromDate(aTime,YearStartTime(aTime),aStartsOnMonday));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long WeekNumMonth(datetime aTime,bool aStartsOnMonday=false)
  {
   return(WeekNumFromDate(aTime,MonthStartTime(aTime),aStartsOnMonday));
  }
//+------------------------------------------------------------------+
//| Function for determining the new calendar day                    |
//| datetime aTimeCur - current time,                                |
//| datetime aTimePre - previous time,                               |
//+------------------------------------------------------------------+
bool NewDay1(datetime aTimeCur,datetime aTimePre)
  {
   return((aTimeCur/86400)!=(aTimePre/86400));
  }
//+-------------------------------------------------------------------+
//| Function for determining the new day for quotes with a Sunday bar |                                                       
//| datetime aTimeCur - current time,                                 |
//| datetime aTimePre - previous time,                                |
//+-------------------------------------------------------------------+
bool NewDay2(datetime aTimeCur,datetime aTimePre)
  {
   MqlDateTime stm;
//--- new day
   if(NewDay1(aTimeCur,aTimePre))
     {
      TimeToStruct(aTimeCur,stm);
      switch(stm.day_of_week)
        {
         case 6: // Saturday
            return(false);
            break;
         case 0: // Sunday
            return(true);
            break;
         case 1: // Monday
            TimeToStruct(aTimePre,stm);
            if(stm.day_of_week!=0)
              { // preceded by any day of the week other than Sunday
               return(true);
              }
            else
              {
               return(false);
              }
            break;
         default: // any other day of the week
            return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Function for determining the new day                             |
//| datetime aTimeCur - current time,                                |
//| datetime aTimePre - previous time,                               |
//| int aVariant=1 - 1 - calendar day as is, 2 - Sunday              |
//| is treated as Monday                                             |
//+------------------------------------------------------------------+
bool NewDay(datetime aTimeCur,datetime aTimePre,int aVariant=1)
  {
   switch(aVariant)
     {
      case 1:
         return(NewDay1(aTimeCur,aTimePre));
         break;
      case 2:
         return(NewDay2(aTimeCur,aTimePre));
         break;
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Function for determining an intraday session                     |
//| int aStartHour - start hour,                                     |
//| int aStartMinute - start minutes,                                |
//| int aStopHour - end hour,                                        |
//| int aStopMinute - end minutes,                                   |
//| datetime aTimeCur - current time                                 |
//+------------------------------------------------------------------+
bool TimeSession(int aStartHour,int aStartMinute,int aStopHour,int aStopMinute,datetime aTimeCur)
  {
//--- session start time
   int StartTime=3600*aStartHour+60*aStartMinute;
//--- session end time
   int StopTime=3600*aStopHour+60*aStopMinute;
//--- current time in seconds since the day start
   aTimeCur=aTimeCur%86400;
   if(StopTime<StartTime)
     {
      //--- going past midnight
      if(aTimeCur>=StartTime || aTimeCur<StopTime)
        {
         return(true);
        }
     }
   else
     {
      //--- within one day
      if(aTimeCur>=StartTime && aTimeCur<StopTime)
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Function for determining the occurrence of a given point of time |
//| int aHour - day start hour,                                      |
//| int aMinute - day start minutes,                                 |
//| datetime aTimeCur - current time,                                |
//| datetime aTimePre - previous time                                |
//+------------------------------------------------------------------+
bool TimeCross(int aHour,int aMinute,datetime aTimeCur,datetime aTimePre)
  {
//--- specified time since the day start
   datetime PointTime=aHour*3600+aMinute*60;
//--- current time since the day start
   aTimeCur=aTimeCur%86400;
//--- previous time since the day start
   aTimePre=aTimePre%86400;
   if(aTimeCur<aTimePre)
     {
      //--- going past midnight
      if(aTimeCur>=PointTime || aTimePre<PointTime)
        {
         return(true);
        }
     }
   else
     {
      if(aTimeCur>=PointTime && aTimePre<PointTime)
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Function for determining the start of a new user-defined day     |
//| int aHour - day start hour,                                      |
//| int aMinute - day start minutes,                                 |
//| datetime aTimeCur - current time,                                |
//| datetime aTimePre - previous time                                |
//+------------------------------------------------------------------+
bool NewCustomDay(int aHour,int aMinute,datetime aTimeCur,datetime aTimePre)
  {
   MqlDateTime stm;
   if(TimeCross(aHour,aMinute,aTimeCur,aTimePre))
     {
      TimeToStruct(aTimeCur,stm);
      if(stm.day_of_week==0 || stm.day_of_week==6)
        {
         return(false);
        }
      else
        {
         return(true);
        }
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Variables for the WeekDays_Check() function                      |
//+------------------------------------------------------------------+
input bool Sunday    =  true; // Sunday
input bool Monday    =  true; // Monday
input bool Tuesday   =  true; // Tuesday 
input bool Wednesday =  true; // Wednesday
input bool Thursday  =  true; // Thursday
input bool Friday    =  true; // Friday
input bool Saturday  =  true; // Saturday

bool WeekDays[7];
//+------------------------------------------------------------------+
//| Function for the preparation of an array for the WeekDays_Check() function|
//+------------------------------------------------------------------+
void WeekDays_Init()
  {
   WeekDays[0]=Sunday;
   WeekDays[1]=Monday;
   WeekDays[2]=Tuesday;
   WeekDays[3]=Wednesday;
   WeekDays[4]=Thursday;
   WeekDays[5]=Friday;
   WeekDays[6]=Saturday;
  }
//+------------------------------------------------------------------+
//| Checking the day of the week                                     |
//| datetime aTime - time for which we check whether                 |
//| a certain day of the week is allowed                             |
//+------------------------------------------------------------------+
bool WeekDays_Check(datetime aTime)
  {
   MqlDateTime stm;
   TimeToStruct(aTime,stm);
   return(WeekDays[stm.day_of_week]);
  }
//+------------------------------------------------------------------+
//| Function for determining a trading session within a week         |
//| int aStartDay - day of the week of the session start,            |
//| int aStartHour - session start hour,                             |
//| int aStartMinute - session start minutes,                        |
//| int aStopDay - day of the week of the session end,               |
//| int aStopHour - session end hour,                                |
//| int aStopMinute - session end minutes,                           |
//| aTimeCur - time that we check for being or not being             |
//| within the session                                               |
//+------------------------------------------------------------------+
bool WeekSession(int aStartDay,int aStartHour,int aStartMinute,int aStopDay,int aStopHour,int aStopMinute,datetime aTimeCur)
  {
//--- session start time since the week start
   int StartTime=aStartDay*86400+3600*aStartHour+60*aStartMinute;
//--- session end time since the week start
   int StopTime=aStopDay*86400+3600*aStopHour+60*aStopMinute;
//--- current time in seconds since the week start
   long TimeCur=SecondsFromWeekStart(aTimeCur,false);
   if(StopTime<StartTime)
     {
      //--- passing the turn of the week
      if(TimeCur>=StartTime || TimeCur<StopTime)
        {
         return(true);
        }
     }
   else
     {
      //--- within one week
      if(TimeCur>=StartTime && TimeCur<StopTime)
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Function for determining the leap year by date                   |
//| aTime - date-time                                                |
//+------------------------------------------------------------------+
bool LeapYear(datetime aTime)
  {
   MqlDateTime stm;
   TimeToStruct(aTime,stm);
//--- a multiple of 4   
   if(stm.year%4==0)
     {
      //--- a multiple of 100
      if(stm.year%100==0)
        {
         //--- a multiple of 400
         if(stm.year%400==0)
           {
            return(true);
           }
        }
      //--- not a multiple of 100        
      else
        {
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Function for determining the number of days in a month by date   |
//| aTime - date-time                                                |
//+------------------------------------------------------------------+
int DaysInMonth(datetime aTime)
  {
   MqlDateTime stm;
   TimeToStruct(aTime,stm);
   if(stm.mon==2)
     {
      //--- February
      if(LeapYear(aTime))
        {
         //--- February in a leap year  
         return(29);
        }
      else
        {
         //--- February in a non-leap year  
         return(28);
        }
     }
   else
     {
      //--- other months
      return(31-((stm.mon-1)%7)%2);
     }
  }
//+------------------------------------------------------------------+
