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

import com.xmlmind.xml.name.Name;
import com.xmlmind.xml.doc.*;

import java.util.TreeSet;
import java.util.SortedSet;
import java.util.Iterator;
import java.util.HashMap;

import java.awt.Color;
import java.security.MessageDigest;

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
		return StyleValue.createString(formatCounter(format, 1 + index));
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
	
	private static HashMap listToSet = new HashMap();
	
	// XXX need a hashmap per document?
	// multiple documents with overlapping counter or formats make
	//  this reallllly confusing.
	private static TreeSet setForList(Element list) {
		// return the TreeSet for that counter, or null
		String format = list.getTokenAttribute(STYLE, "empty");
		if (format.length() > 7 && "format ".equals(format.substring(0, 7))) {
			format = format.substring(7);
		} else {
			format = null;
		}
		String counter = list.getNmtokenAttribute(COUNTER, format);
		if (counter == null)
			return null;

		TreeSet set = (TreeSet) listToSet.get(counter);
		if (set == null) {
			set = new TreeSet();
			listToSet.put(counter, set);
		}
		
		// ensure that the set includes this list
		set.add(list);
		
		return set;
	}
	
    private static int indexOfListItem(Element listItem) {
		Element list = listItem.getParentElement();
		if (list == null || list.getName() != LIST)
			return -1;
		
		int index = list.indexOfChildElement(listItem);
		int offset = 0;
		
		// to do: optimize when refreshing a set of lists, like
		//  cache the previous list and its offset?
		TreeSet set = setForList(list);
		if (set != null && set.size() > 1) {
			SortedSet head = set.headSet(list);
			
			Iterator i = head.iterator();
			while (i.hasNext()) {
				Element list2 = (Element) i.next();
				Element last = list2.getLastChildElement();
				if (last != null) {
					offset += list2.indexOfChildElement(last) + 1;
				}
			}
		}

		return (offset + index);
    }
	
	/*
	 * This one's complex, because of the relationship between
	 * style=format and counter.  Basically, we must figure
	 * out which set this element may have belonged to before
	 * it changed, and after, and see if anything has to
	 * change.  Inserting a t inside a list just means to
	 * re-render the list's tail set.
	 */
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

	public StyleValue pickcolor(StyleValue[] args, Node contextNode,
                                StyledViewFactory viewFactory) {
		
        float h,s,b;
        String cref = contextNode.attributeValue(Name.get("source"));
		
        if (cref==null || "".equals(cref)) {
			if (args.length > 0 && ("dark").equals(args[0].stringValue()))
				return StyleValue.createColor(StyleValue.parseColor("black"));
			else
				return StyleValue.createColor(StyleValue.parseColor("yellow"));
        }
		
        byte[] hash = MD5(cref);
		
        h= mapByteIntoRange(0.0f,1.0f, hash[0]);
		
        if (args.length > 0 && ("dark").equals(args[0].stringValue())) {
			s= mapByteIntoRange(0.45f,0.6f, hash[1]);
			b= mapByteIntoRange(0.3f,0.4f, hash[2]);
        } else {
			s= mapByteIntoRange(0.2f,0.4f, hash[1]);
			b= mapByteIntoRange(0.92f,0.99f, hash[2]);
        }
		
        return StyleValue.createColor(Color.getHSBColor(h, s, b));
    }   
    
	
    public byte[] MD5(String text) {
        MessageDigest md;
        try {
            md = MessageDigest.getInstance("MD5");
            md.update(text.getBytes("iso-8859-1"), 0, text.length());
        } catch(Exception e) {
            return new byte[]{0,0,0};
        }
        return md.digest(); // byte[32]
    }
	
    public static float mapByteIntoRange(float low, float high, byte value) {
        return (low+high)/2 + value*(high-low)/254f;
    }
}
