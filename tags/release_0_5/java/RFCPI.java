/*
 * Create a gadget to handle an RFC Processing Instruction 
 */
package com.att.research.fenner.xmleditapp.xml2rfc;

import com.xmlmind.xmledit.doc.TextNode;
import com.xmlmind.xmledit.doc.ProcessingInstruction;
import com.xmlmind.xmledit.view.TextNodeView;
import com.xmlmind.xmledit.stylesheet.StyleValue;
import com.xmlmind.xmledit.styledgadget.Style;
import com.xmlmind.xmledit.gadget.Gadget;
import com.xmlmind.xmledit.styledview.GadgetFactory2;
import com.xmlmind.xmledit.styledview.StyledViewFactory;

import com.att.research.fenner.xmleditapp.xml2rfc.Constants;

public class RFCPI implements GadgetFactory2, Constants {
    public Gadget createGadget(TextNodeView view,
                               Style style, StyleValue[] parameters,
                               StyledViewFactory viewFactory) {
        TextNode textNode = view.getTextNode();
        if (!(textNode instanceof ProcessingInstruction) ||
            !RFC_PI_TARGET.equals(
                ((ProcessingInstruction) textNode).getTarget()))
            return null;

	/* create gadget and return it */
    }
}
