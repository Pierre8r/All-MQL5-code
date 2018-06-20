//+------------------------------------------------------------------+
//|                                                     TestList.mq5 |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, Vasiliy Sokolov."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Object.mqh>
#include <Arrays\List.mqh>

class CCar : public CObject{};
class CExpert : public CObject{};
class CWealth : public CObject{};
class CShip : public CObject{};
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   CList list;
   list.Add(new CCar());
   list.Add(new CExpert());
   list.Add(new CWealth());
   list.Add(new CShip());
   printf(">>> enumerate from begin to end >>>");
   EnumerateAll(list);
   printf("<<< enumerate from end to begin <<<");
   ReverseEnumerateAll(list);
  }
//+------------------------------------------------------------------+
//| Enumerates the list from beginning to end displaying a sequence  |
//| number of each element in the terminal.                          |
//+------------------------------------------------------------------+
void EnumerateAll(CList &list)
  {
   CObject *node=list.GetFirstNode();
   for(int i=0; node!=NULL; i++,node=node.Next())
      printf("Element at "+(string)i);
  }
//+------------------------------------------------------------------+
//| Enumerates the list from end to beginning displaying a sequence  |
//| number of each element in the terminal                           |
//+------------------------------------------------------------------+
void ReverseEnumerateAll(CList &list)
  {
   CObject *node=list.GetLastNode();
   for(int i=list.Total()-1; node!=NULL; i--,node=node.Prev())
      printf("Element at "+(string)i);
  }
//+------------------------------------------------------------------+
