//+------------------------------------------------------------------+
//|                                                      XmlBase.mqh |
//|                                                   yu-sha@ukr.net |
//+------------------------------------------------------------------+
//             The library is designed for parsing XML documents.
// Example of use:
// CXmlDocument doc;
// doc.CreateFromFile (...);
// doc.DocumentElement.Elements[i].Text - get the contents of the i-th element

#include "XmlAttribute.mqh"
#include "XmlElement.mqh"
#include "XmlDocument.mqh"