//
//  StyleSheetExtension.java
//  xml2rfc
//
//  Created by Bill Fenner on 3/31/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

import com.xmlmind.xmledit.stylesheet.StyleSpecsBase;
import com.xmlmind.xmledit.styledview.StyledViewFactory;
import com.xmlmind.xmledit.stylesheet.StyleValue;
import com.xmlmind.xmledit.view.DocumentView;
import com.xmlmind.xmledit.styledview.CustomViewManager;

import com.xmlmind.xmledit.xmlutil.*;
import com.xmlmind.xmledit.doc.*;


/**
 * Based on xxe developer documentation
 */
public class StyleSheetExtension extends StyleSpecsBase {
    private static final Name LIST = Name.get("list");
    private static final Name COUNTER = Name.get("counter");
    private static final Name STYLE = Name.get("style");
    private static final Name T = Name.get("t");
	
    public StyleSheetExtension(String[] args, StyledViewFactory viewFactory) {
		// To do: add a custom view observer to renumber lists
	}
	
	/**
	 * Determine the format for the list.
	 * Determine the number.
	 * Format the number using the format.
	 */
    public StyleValue listItemCounter(StyleValue[] args, Node contextNode,
									  StyledViewFactory viewFactory) {
		String format = listFormat((Element) contextNode);
		int index = indexOfListItem((Element) contextNode);
		return new StyleValue(formatCounter(format, 1 + index));
    }
	
	private static String listFormat(Element listItem) {
		Element list = listItem.getParentElement();
		if (list == null || list.getName() != LIST)
			return "";
			
		String format = list.getTokenAttribute(STYLE, "empty");	// XXX NMTOKEN or TOKEN?
		if ("numbers".equals(format)) {
			return "%d.";
		}
		if ("letters".equals(format)) {
			return "%c.";
		}
		if (format.length() > 7 && "format ".equals(format.substring(0, 7))) {
			return format.substring(7);
		}
		return "?"+format+"?%c";
	}
	
	private static String formatCounter(String format, int index) {
		String ret;
		int i;
		
		if ((i = format.indexOf("%")) == -1 || i + 1 == format.length()) {
			// no formatting needed / possible
			return format;
		}
		ret = format.substring(0, i);
		switch (format.charAt(i+1)) {
			case 'd':
				ret += Integer.toString(index);
				break;
				
			case 'c':
				if (index > 26 && index <= 702) {
					ret += "abcdefghijklmnopqrstuvwxyz".charAt(((index - 1) / 26) - 1);
					index -= ((index - 1) / 26) * 26;
				}
				if (index <= 26) {
					ret += "abcdefghijklmnopqrstuvwxyz".charAt(index - 1);
					break;
				}
				// Fall Through to unsupported
				
			default:
				ret += "?%" + format.charAt(i+1) + Integer.toString(index) + "?";
				break;
		}
		ret += format.substring(i + 2);
		
		return ret;
	}
	
    private static int indexOfListItem(Element listItem) {
		Element list = listItem.getParentElement();
		if (list == null || list.getName() != LIST)
			return -1;
		
		int index = list.indexOfChildElement(listItem);
		int offset = 0;
		
		String format = list.getTokenAttribute(STYLE, "empty");	// XXX NMTOKEN or TOKEN?
		if (format.length() > 7 && "format ".equals(format.substring(0, 7))) {
			format = format.substring(7);
		} else {
			format = null;
		}
		String counter = list.getNmtokenAttribute(COUNTER, format);
		
		if (counter != null) {

		/*
		 * here begins the sample code that doesn't quite go.
		 * the plan is to implement <list counter=".."> as follows:
		 *  hashmap for counter name, returns an array
		 *  array contains a structure that's the <list> element and
		 *    a count so far
		 *  so when a <list> element gets updated, you just redraw
		 *    it and the ones after and you don't have to count
		 *    the ones before.
		 * Remember the implicit counter=format for <list style="format ___">
		 * That means that the format discovery should be combined here?
		String continuation = list.getNmtokenAttribute(CONTINUATION, 
															  "restarts");
		if ("continues".equals(continuation)) {
			Element prevlist = null;
			
			if (list.getParentElement() != null) {
				Node node = list.getPreviousSibling();
				while (node != null) {
					if ((node instanceof Element) &&
						((Element) node).getName() == list) {
						prevlist = (Element) node;
						break;
					}
					
					node = node.getPreviousSibling();
				}
			} // Otherwise, list is the root element.
			
			if (prevlist != null) {
				Element last = prevlist.getLastChildElement();
				if (last != null) {
					offset = indexOfListItem(last) + 1;
				} // Otherwise, prevlist is invalid.
			}
		}
		*/
		}

		return (offset + index);
    }
	
	/*
    private static class listObserver 
		implements CustomViewManager.BasicElementObserver {
			private DocumentView docView;
			private ArrayList lists = new ArrayList();
			
			public listObserver(StyledViewFactory viewFactory) {
				docView = viewFactory.getDocumentView();
			}
			
			public void customViewAdded() {}
			public void customViewRemoved() {}
			
			public void elementChanged(DocumentEvent[] events) {
				lists.clear();
				
				for (int i = 0; i < events.length; ++i) {
					DocumentEvent event = events[i];
					
					switch (event.getId()) {
						case ElementStructureEvent.CHILD_ADDED:
						case ElementStructureEvent.CHILD_REPLACED:
						case ElementStructureEvent.CHILD_REMOVED:
						{
							ElementStructureEvent e = (ElementStructureEvent)event;
							Element element = e.getElementSource();
							
							if (element.getName() == list) {
								add(lists, element);
							} else {
								if (islist(e.getOldChild()) ||
									islist(e.getNewChild())) {
									// Add first child list (if any).
									
									Node node = element.getFirstChild();
									while (node != null) {
										if ((node instanceof Element) &&
											((Element) node).getName() == 
											list) {
											add(lists, (Element) node);
											break;
										}
										
										node = node.getNextSibling();
									}
								}
							}
						}
							break;
							
						case ElementAttributeEvent.ATTRIBUTE_ADDED:
						case ElementAttributeEvent.ATTRIBUTE_CHANGED:
						case ElementAttributeEvent.ATTRIBUTE_REMOVED:
						{
							Element element = 
							((ElementAttributeEvent) event).getElementSource();
							if (element.getName() == list) {
								add(lists, element);
							}
						}
							break;
					}
				}
				
				int count = lists.size();
				if (count > 0) {
					for (int i = 0; i < count; ++i) {
						Element list = (Element) lists.get(i);
						
						if (list.getParentElement() != null) {
							// Add all following list siblings (if any).
							
							Node node = list.getNextSibling();
							while (node != null) {
								if ((node instanceof Element) &&
									((Element)node).getName() == list) {
									add(lists, (Element) node);
								}
								
								node = node.getNextSibling();
							}
						} // Otherwise, list is the root element.
					}
					
					count = lists.size();
					for (int i = 0; i < count; ++i) {
						docView.rebuildView((Element) lists.get(i));
					}
					
					lists.clear();
				}
			}
			
			private static final void add(ArrayList lists,
										  Element list) {
				if (!lists.contains(list))
					lists.add(list);
			}
			
			private static final boolean islist(Node node) {
				if (node == null || !(node instanceof Element))
					return false;
				else
					return (((Element) node).getName() == list);
			}
		}
		*/
}
