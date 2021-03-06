//+------------------------------------------------------------------+
//|                                                   TimeSeries.mqh |
//|                                 Copyright 2017, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayDouble.mqh>
//+------------------------------------------------------------------+
//| Type of comparison between two CTimeValue variables              |
//+------------------------------------------------------------------+
enum ENUM_COMP_TYPE
{
   COMP_BY_TIME,      // Comparison by time
   COMP_BY_VALUE      // Comparison by value
};
//+------------------------------------------------------------------+
//| Time - set of values                                             |
//+------------------------------------------------------------------+
class CTimeValue : public CObject
{
private:
   datetime       m_time;
   CArrayDouble   m_values;
   int            m_curr_buff;
   int            CompByTime(const CTimeValue* tv)const;
   int            CompByValue(const CTimeValue* tv)const;
public:
   datetime       Time(void)const;
   double         Value(void)const;
   double         Value(int column_n)const;
   void           Value(int buff_ind, double value);
   int            BuffersTotal();
   bool           RemoveColumn(int col_num);
   bool           SetBuffer(int buff_index);
   int            GetBufferCurrent(void)const;
   string         ToString(int time_format=TIME_DATE|TIME_MINUTES, int digits=4, uchar del=';');
   virtual int    Compare(const CObject *node,const int mode=0) const;
                  CTimeValue(void);
                  CTimeValue(datetime time, double value);
                  CTimeValue(datetime time, double &values[]);
};
//+------------------------------------------------------------------+
//| Default initialization                                           |
//+------------------------------------------------------------------+
CTimeValue::CTimeValue(void) : m_curr_buff(0),
                               m_time(0)
{
   m_values.Add(EMPTY_VALUE);
}
//+------------------------------------------------------------------+
//| Initialization of time - value                                   |
//+------------------------------------------------------------------+
CTimeValue::CTimeValue(datetime time,double value)
{
   m_time = time;
   m_curr_buff = 0;
   m_values.Add(value);   
}
//+------------------------------------------------------------------+
//| Returns the number of buffers                                    |
//+------------------------------------------------------------------+
int CTimeValue::BuffersTotal(void)
{
   return m_values.Total();
}
//+------------------------------------------------------------------+
//| Initialization of time - set of values                           |
//+------------------------------------------------------------------+
CTimeValue::CTimeValue(datetime time,double &values[])
{
   m_time = time;
   m_curr_buff = 0;
   for(int i = 0; i < ArraySize(values); i++)
      m_values.Add(values[i]);
}
//+-------------------------------------------------------------------+
//| Compares two CTimeValue by time or by value                       |
//+-------------------------------------------------------------------+
int CTimeValue::Compare(const CObject *node,const int mode=0)const
{
   switch(mode)
   {
      case COMP_BY_TIME:
         return CompByTime(node);
      default:
         return CompByValue(node);
   }
   return 0;
}
//+-------------------------------------------------------------------+
//| Removes a column at index col_num                                 |
//+-------------------------------------------------------------------+
bool CTimeValue::RemoveColumn(int col_num)
{
   return m_values.Delete(col_num);
}
//+------------------------------------------------------------------+
//| Compares the current CTimeValue instance with passed one by time |
//+------------------------------------------------------------------+
int CTimeValue::CompByTime(const CTimeValue *tv)const
{
   if(tv.Time() > m_time)
      return -1;
   if(tv.Time() < m_time)
      return 1;
   return 0;
}
//+------------------------------------------------------------------+
//| Compares the current CTimeValue instance with passed one by time |
//+------------------------------------------------------------------+
int CTimeValue::CompByValue(const CTimeValue *tv)const
{
   if(tv.GetBufferCurrent() != m_curr_buff)
   {
      printf("Failed compared. Different current buffer");
      return 0;
   }
   if(tv.Value() > Value())
      return -1;
   if(tv.Value() < Value())
      return 1;
   return 0;
}
//+------------------------------------------------------------------+
//| Setting the buffer                                               |
//+------------------------------------------------------------------+
bool CTimeValue::SetBuffer(int buff_index)
{
   for(int i = m_values.Total(); i <= buff_index; i++)
      m_values.Add(EMPTY_VALUE);
   m_curr_buff = buff_index;
   return true;
}
//+------------------------------------------------------------------+
//| Returns the index of the current buffer                          |
//+------------------------------------------------------------------+
int CTimeValue::GetBufferCurrent(void)const
{
   return m_curr_buff;
}
//+------------------------------------------------------------------+
//| Returns the value of TimeValue                                   |
//+------------------------------------------------------------------+
double CTimeValue::Value(void)const
{
   return m_values.At(m_curr_buff);
}
//+------------------------------------------------------------------+
//| Returns the value at the specified index                         |
//+------------------------------------------------------------------+
double CTimeValue::Value(int column_n)const
{
   return m_values.At(column_n);
}
//+------------------------------------------------------------------+
//| Returns the time of TimeValue                                    |
//+------------------------------------------------------------------+
datetime CTimeValue::Time(void)const
{
   return m_time;
}
//+------------------------------------------------------------------+
//| Changes the value at the specified index                         |
//+------------------------------------------------------------------+
void CTimeValue::Value(int buff_ind, double value)
{
   for(int i = m_values.Total(); i <= buff_ind; i++)
      m_values.Add(EMPTY_VALUE);
   m_values.Update(buff_ind, value);
}
//+------------------------------------------------------------------+
//| Returns the string representation                                |
//+------------------------------------------------------------------+
string CTimeValue::ToString(int time_format=TIME_DATE|TIME_MINUTES, int digits=4, uchar del=';')
{
   string line = TimeToString(m_time, time_format);
   string s = CharToString(del);
   line += s + "00:00";
   for(int i = 0; i < m_values.Total(); i++)
      line += s + DoubleToString(m_values.At(i), digits);
   
   return line;
}