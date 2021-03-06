//+------------------------------------------------------------------+
//|                                               NewBarDetecter.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Object.mqh>
//+------------------------------------------------------------------+
//| The class detects the emergence of a new bar of the specified    |
//| symbol and period.                                               |
//+------------------------------------------------------------------+
class CBarDetector : public CObject
  {
private:
   ENUM_TIMEFRAMES   m_timeframe;      // The timeframe to track the emergence of a new bar on
   string            m_symbol;         // The symbol to track the emergence of a new bar
   datetime          m_last_time;      // The time of the last known bar
public:
                     CBarDetector(void);
                     CBarDetector(string symbol,ENUM_TIMEFRAMES timeframe);
   void              Timeframe(ENUM_TIMEFRAMES tf);
   ENUM_TIMEFRAMES   Timeframe(void);
   void              Symbol(string symbol);
   string            Symbol(void);

   bool              IsNewBar(void);
  };
//+------------------------------------------------------------------+
//| By default the constructor sets the current timeframe            |
//| and symbol.                                                      |
//+------------------------------------------------------------------+
CBarDetector::CBarDetector(void)
  {
   m_symbol=_Symbol;
   m_timeframe=Period();
  }
//+------------------------------------------------------------------+
//| Creates an object with a predefined symbol and timeframe.        |
//+------------------------------------------------------------------+
CBarDetector::CBarDetector(string symbol,ENUM_TIMEFRAMES tf)
  {
   m_symbol=symbol;
   m_timeframe=tf;
  }
//+------------------------------------------------------------------+
//| Sets the timeframe on which you want to track emergence of       |
//| a new bar.                                                       |
//+------------------------------------------------------------------+
void CBarDetector::Timeframe(ENUM_TIMEFRAMES tf)
  {
   m_timeframe=tf;
  }
//+------------------------------------------------------------------+
//| Returns the timeframe on which you track the emergence of        |
//| a new bar.                                                       |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES CBarDetector::Timeframe(void)
  {
   return m_timeframe;
  }
//+------------------------------------------------------------------+
//| Sets the name of the symbol on which you want to track           |
//| the emergence of a new bar.                                      |
//+------------------------------------------------------------------+
void CBarDetector::Symbol(string symbol)
  {
   m_symbol=symbol;
  }
//+------------------------------------------------------------------+
//| Returns the name of the symbol on which you track the            |
//| emergence of a new bar.                                          |
//+------------------------------------------------------------------+
string CBarDetector::Symbol(void)
  {
   return m_symbol;
  }
//+------------------------------------------------------------------+
//| Returns true if for the given symbol and timeframe there is      |
//| a new bar.                                                       |
//+------------------------------------------------------------------+
bool CBarDetector::IsNewBar(void)
  {
   datetime time[];
   if(CopyTime(m_symbol, m_timeframe, 0, 1, time) < 1)return false;
   if(time[0] == m_last_time)return false;
   return m_last_time = time[0];
  }
//+------------------------------------------------------------------+
