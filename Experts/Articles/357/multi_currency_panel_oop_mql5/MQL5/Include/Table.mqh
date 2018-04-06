//+------------------------------------------------------------------+
//|                                                       CTable.mqh |
//|                                                 Marcin Konieczny |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Marcin Konieczny"

#include <Arrays\List.mqh>
#include <Row.mqh>

const string nameBase="Table_Coord#"; // prefix for all label objects used by table
//+------------------------------------------------------------------+
//| CTable class                                                     |
//+------------------------------------------------------------------+
class CTable
  {
private:
   int               xDistance;    // distance from right border of the chart
   int               yDistance;    // distance from top of the chart
   int               cellHeight;   // table cell height
   int               cellWidth;    // table cell width
   string            font;         // font name
   int               fontSize;
   color             fontColor;

   CList            *rowList;      // list of row objects
   bool              tfMode;       // is in multi-timeframe mode?

   ENUM_TIMEFRAMES   timeframes[]; // array of timeframes for multi-timeframe mode
   string            symbols[];    // array of currency pairs for multi-currency mode

   //--- private methods
   //--- sets default parameters of the table
   void              Init();
   //--- draws text label in the specified table cell
   void              DrawLabel(int x,int y,string text,string font,color col);
   //--- returns textual representation of given timeframe
   string            PeriodToString(ENUM_TIMEFRAMES period);

public:
   //--- multi-timeframe mode constructor
                     CTable(ENUM_TIMEFRAMES &tfs[]);
   //--- multi-currency mode constructor
                     CTable(string &symb[]);
   //--- destructor
                    ~CTable();
   //--- redraws table
   void              Update();
   //--- methods for setting table parameters
   void              SetDistance(int xDist,int yDist);
   void              SetCellSize(int cellW,int cellH);
   void              SetFont(string fnt,int size,color clr);
   //--- appends CRow object to the of the table
   void              AddRow(CRow *row);
  };
//+------------------------------------------------------------------+
//| Multi-timeframe mode constructor                                 |
//+------------------------------------------------------------------+
CTable::CTable(ENUM_TIMEFRAMES &tfs[])
  {
//--- copy all timeframes to own array
   ArrayResize(timeframes,ArraySize(tfs),0);
   ArrayCopy(timeframes,tfs);
   tfMode=true;
   
//--- fill symbols array with current chart symbol
   ArrayResize(symbols,ArraySize(tfs),0);
   for(int i=0; i<ArraySize(tfs); i++)
      symbols[i]=Symbol();

//--- set default parameters
   Init();
  }
//+------------------------------------------------------------------+
//| Multi-currency mode constructor                                  |
//+------------------------------------------------------------------+
CTable::CTable(string &symb[])
  {
//--- copy all symbols to own array
   ArrayResize(symbols,ArraySize(symb),0);
   ArrayCopy(symbols,symb);
   tfMode=false;
   
//--- fill timeframe array with current timeframe
   ArrayResize(timeframes,ArraySize(symb),0);
   ArrayInitialize(timeframes,Period());

//--- set default parameters
   Init();

//--- send SpyAgents to every requested symbol
   for(int x=0; x<ArraySize(symbols); x++)
      if(symbols[x]!=Symbol()) // don't send SpyAgent to own chart
         if(iCustom(symbols[x],0,"SpyAgent",ChartID(),0)==INVALID_HANDLE)
           {
            Print("Error in setting of SpyAgent on "+symbols[x]);
            return;
           }
  }
//+------------------------------------------------------------------+
//| Sets default parameters of the table                             |
//+------------------------------------------------------------------+
CTable::Init()
  {
//--- create list for storing row objects
   rowList=new CList;

//--- set defaults
   xDistance = 10;
   yDistance = 10;
   cellWidth = 60;
   cellHeight= 20;
   font="Arial";
   fontSize=10;
   fontColor=clrWhite;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTable::~CTable()
  {
   int total=ObjectsTotal(0);

//--- remove all text labels from the chart (all object names starting with nameBase prefix)
   for(int i=total-1; i>=0; i--)
      if(StringFind(ObjectName(0,i),nameBase)!=-1)
         ObjectDelete(0,ObjectName(0,i));

//--- delete list of rows and free memory
   delete(rowList);
  }
//+------------------------------------------------------------------+
//| Appends new row to the end of the table                          |
//+------------------------------------------------------------------+
CTable::AddRow(CRow *row)
  {
   rowList.Add(row);
   row.Init(symbols,timeframes);
  }
//+------------------------------------------------------------------+
//| Redraws the table                                                |
//+------------------------------------------------------------------+
CTable::Update()
  {
   CRow *row;
   string symbol;
   ENUM_TIMEFRAMES tf;

   int rows=rowList.Total(); // number of rows
   int columns;              // number of columns

   if(tfMode)
      columns=ArraySize(timeframes);
   else
      columns=ArraySize(symbols);

//--- draw first column (names of rows)
   for(int y=0; y<rows; y++)
     {
      row=(CRow*)rowList.GetNodeAtIndex(y);
      //--- note: we ask row object to return its name
      DrawLabel(columns,y+1,row.GetName(),font,fontColor);
     }

//--- draws first row (names of timeframes or currency pairs)
   for(int x=0; x<columns; x++)
     {
      if(tfMode)
         DrawLabel(columns-x-1,0,PeriodToString(timeframes[x]),font,fontColor);
      else
         DrawLabel(columns-x-1,0,symbols[x],font,fontColor);
     }

//--- draws inside table cells
   for(int y=0; y<rows; y++)
      for(int x=0; x<columns; x++)
        {
         row=(CRow*)rowList.GetNodeAtIndex(y);

         if(tfMode)
           {
            //--- in multi-timeframe mode use current symbol and different timeframes
            tf=timeframes[x];
            symbol=_Symbol;
           }
         else
           {
            //--- in multi-currency mode use current timeframe and different symbols
            tf=Period();
            symbol=symbols[x];
           }

         //--- note: we ask row object to return its font, 
         //--- color and current calculated value for given timeframe and symbol
         DrawLabel(columns-x-1,y+1,row.GetValue(symbol,tf),row.GetFont(symbol,tf),row.GetColor(symbol,tf));
        }

//--- forces chart to redraw
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Draws text label in the specified cell of the table              |
//+------------------------------------------------------------------+  
CTable::DrawLabel(int x,int y,string text,string font,color col)
  {
//--- create unique name for this cell
   string name=nameBase+IntegerToString(x)+":"+IntegerToString(y);

//--- create label
   if(ObjectFind(0,name)<0)
      ObjectCreate(0,name,OBJ_LABEL,0,0,0);

//--- set label properties
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,xDistance+x*cellWidth);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,yDistance+y*cellHeight);
   ObjectSetString(0,name,OBJPROP_FONT,font);
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontSize);

//--- set label text
   ObjectSetString(0,name,OBJPROP_TEXT,text);
  }
//+------------------------------------------------------------------+
//| Sets cell size                                                   |
//+------------------------------------------------------------------+
CTable::SetCellSize(int cellW,int cellH)
  {
   cellWidth=cellW;
   cellHeight=cellH;
  }
//+------------------------------------------------------------------+
//| Sets font                                                        |
//+------------------------------------------------------------------+
CTable::SetFont(string fnt,int size,color clr)
  {
   font=fnt;
   fontSize=size;
   fontColor=clr;
  }
//+------------------------------------------------------------------+
//| Sets distance                                                    |
//+------------------------------------------------------------------+
CTable::SetDistance(int xDist,int yDist)
  {
   xDistance = xDist;
   yDistance = yDist;
  }
//+------------------------------------------------------------------+
//| Converts ENUM_TIMEFRAMES to string                               |
//+------------------------------------------------------------------+
string CTable::PeriodToString(ENUM_TIMEFRAMES period)
  {
   return(StringSubstr(EnumToString(period),7));
  }
//+------------------------------------------------------------------+
