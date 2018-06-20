//+------------------------------------------------------------------+
//| An associative array or a dictionary storing elements as         |
//| <key - value>, where a key may be represented by any base type,  |
//| and a value may be represented be a CObject type object.         |
//+------------------------------------------------------------------+

#include <Object.mqh>
#include <Arrays\List.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CDictionary
  {
private:
   CList            *m_array[];       // List array.
   template<typename T>
   bool              AddObject(T key,CObject *value);
  };
//+------------------------------------------------------------------+
//| Adds a CObject type element with a T key to the dictionary       |
//| INPUT PARAMETRS:                                                 |
//|   T key - any base type, for instance int, double or string.     |
//|   value - a class that derives from CObject.                     |
//| RETURNS:                                                         |
//|   true, if the element has been added, otherwise - false.        |
//+------------------------------------------------------------------+
template<typename T>
bool CDictionary::AddObject(T key,CObject *value)
  {
   if(ContainsKey(key))
      return false;
   if(m_total==m_array_size)
     {
      printf("Resize"+m_total);
      Resize();
     }
   if(CheckPointer(m_array[m_index])==POINTER_INVALID)
     {
      m_array[m_index]=new CList();
      m_array[m_index].FreeMode(m_free_mode);
     }
   KeyValuePair *kv=new KeyValuePair(key,m_hash,value);
   if(m_array[m_index].Add(kv)!=-1)
      m_total++;
   if(CheckPointer(m_current_kvp)==POINTER_INVALID)
     {
      m_first_kvp=kv;
      m_current_kvp=kv;
      m_last_kvp=kv;
     }
   else
     {
      m_current_kvp.next_kvp=kv;
      kv.prev_kvp=m_current_kvp;
      m_current_kvp=kv;
      m_last_kvp=kv;
     }
   return true;
  }

/*
//+------------------------------------------------------------------+
//|                                                   Dictionary.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CDictionary
  {
private:

public:
                     CDictionary();
                    ~CDictionary();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDictionary::CDictionary()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDictionary::~CDictionary()
  {
  }
//+------------------------------------------------------------------+
*/
//+------------------------------------------------------------------+
