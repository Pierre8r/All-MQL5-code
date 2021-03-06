//+------------------------------------------------------------------+
//|                                         EventChartConsoleAdd.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
//+------------------------------------------------------------------+
//|                                        EventChartPBarChanged.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "Event.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CEventCharConsoleChange : public CEvent
  {
private:
   int               m_console_id;           // Console object identifier
   int               m_line;                 // The number of the line to replace
   string            m_message;              // The text that should be replaced
public:
                     CEventCharConsoleChange(int progress_bar_id,int line_number,string message);
   int               ConsoleID(void);
   int               LineNumber(void);
   string            Message(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventCharConsoleChange::CEventCharConsoleChange(int console_id,int line_number,string message) : CEvent(EVENT_CHART_CONSOLE_CHANGE)
  {
   m_console_id=console_id;
   m_message=message;
   m_line=line_number;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CEventCharConsoleChange::ConsoleID(void)
  {
   return m_console_id;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CEventCharConsoleChange::Message(void)
  {
   return m_message;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CEventCharConsoleChange::LineNumber(void)
  {
   return m_line;
  }
//+------------------------------------------------------------------+
