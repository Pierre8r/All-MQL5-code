//+------------------------------------------------------------------+
//|                                                      Hashing.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   printf("Hello world - "+(string)Adler32("Hello world"));
   printf("Hello world! - "+(string)Adler32("Hello world!"));
   printf("Peace - "+(string)Adler32("Peace"));
   printf("MetaTrader - "+(string)Adler32("MetaTrader"));
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Accepts a string and returns hashing 32-bit value,               |
//| which characterizes this string.                                 |
//+------------------------------------------------------------------+
uint Adler32(string line)
  {
   ulong s1 = 1;
   ulong s2 = 0;
   uint buflength=StringLen(line);
   uchar char_array[];
   ArrayResize(char_array,buflength,0);
   StringToCharArray(line,char_array,0,-1,CP_ACP);
   for(uint n=0; n<buflength; n++)
     {
      s1 = (s1 + char_array[n]) % 65521;
      s2 = (s2 + s1)     % 65521;
     }
   return ((s2 << 16) + s1);
  }
//+------------------------------------------------------------------+
