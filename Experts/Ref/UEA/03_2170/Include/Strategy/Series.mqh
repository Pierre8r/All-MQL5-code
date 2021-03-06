//+------------------------------------------------------------------+
//|                                                       Series.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
//+------------------------------------------------------------------+
//| Access to quotes of the required instrument and timeframe.       |
//+------------------------------------------------------------------+
class CSeries
  {
protected:
   string            m_symbol;
   ENUM_TIMEFRAMES   m_timeframe;
                     CSeries(void);
public:
   string            Symbol(void);
   ENUM_TIMEFRAMES   Timeframe(void);
   void              Symbol(string symbol);
   void              Timeframe(ENUM_TIMEFRAMES tf);
   int               Total(void);
  };
//+------------------------------------------------------------------+
//| Default constructor.                                             |
//+------------------------------------------------------------------+
CSeries::CSeries(void)
  {
  }
//+------------------------------------------------------------------+
//| Returns symbol of series                                         |
//+------------------------------------------------------------------+
string CSeries::Symbol(void)
  {
   return m_symbol;
  }
//+------------------------------------------------------------------+
//| Sets symbols of the series.                                      |
//+------------------------------------------------------------------+
void CSeries::Symbol(string symbol)
  {
   m_symbol=symbol;
  }
//+------------------------------------------------------------------+
//| Returns timeframe of the symbol.                                 |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES CSeries::Timeframe(void)
  {
   return m_timeframe;
  }
//+------------------------------------------------------------------+
//| Sets the timeframe of the symbol.                                |
//+------------------------------------------------------------------+
void CSeries::Timeframe(ENUM_TIMEFRAMES tf)
  {
   m_timeframe=tf;
  }
//+------------------------------------------------------------------+
//| Returns the available number of bars.                            |
//+------------------------------------------------------------------+
int CSeries::Total(void)
  {
   return Bars(m_symbol, m_timeframe);
  }
//+------------------------------------------------------------------+
//| Access to Open prices of the required instrument and timeframe.  |
//+------------------------------------------------------------------+
class COpen : public CSeries
  {
public:
   double operator[](int index)
     {
      double value[];
      if(CopyOpen(m_symbol, m_timeframe, index, 1, value) == 0)return 0.0;
      return value[0];
     }
  };
//+------------------------------------------------------------------+
//| Access to High prices of the instrument bar.                     |
//+------------------------------------------------------------------+
class CHigh : public CSeries
  {
public:
   double operator[](int index)
     {
      double value[];
      if(CopyHigh(m_symbol, m_timeframe, index, 1, value) == 0)return 0.0;
      return value[0];
     }
  };
//+------------------------------------------------------------------+
//| Access to Low prices of the instrument bar.                      |
//+------------------------------------------------------------------+
class CLow : public CSeries
  {
public:
   double operator[](int index)
     {
      double value[];
      if(CopyLow(m_symbol, m_timeframe, index, 1, value) == 0)return 0.0;
      return value[0];
     }
  };
//+------------------------------------------------------------------+
//| Access to Close prices of the symbol bar.                        |
//+------------------------------------------------------------------+
class CClose : public CSeries
  {
public:
   double operator[](int index)
     {
      double value[];
      if(CopyClose(m_symbol, m_timeframe, index, 1, value) == 0)return 0.0;
      return value[0];
     }
  };
//+------------------------------------------------------------------+
//| Access to real volumes of a symbol bar.                          |
//+------------------------------------------------------------------+
class CVolume : public CSeries
  {
public:
   long operator[](int index)
     {
      long value[];
      if(CopyRealVolume(m_symbol, m_timeframe, index, 1, value) == 0)return 0;
      return value[0];
     }
  };
//+------------------------------------------------------------------+
//| Access to tick volumes of a symbol bar.                          |
//+------------------------------------------------------------------+
class CTickVolume : public CSeries
  {
public:
   long operator[](int index)
     {
      long value[];
      if(CopyTickVolume(m_symbol, m_timeframe, index, 1, value) == 0)return 0;
      return value[0];
     }
  };
//+------------------------------------------------------------------+
//| Access to the bar opening time.                                  |
//+------------------------------------------------------------------+
class CTime : public CSeries
  {
public:
   datetime operator[](int index)
     {
      datetime value[];
      if(CopyTime(m_symbol, m_timeframe, index, 1, value) == 0)return 0;
      return value[0];
     }
  };
//+------------------------------------------------------------------+
