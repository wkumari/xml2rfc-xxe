//
//  ExpandRFCPI.java
//  xml2rfc
//
//  Created by Bill Fenner on 2/22/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

package com.att.research.fenner.xmleditapp.xml2rfc;

import java.io.IOException;
import java.net.URL;
import com.xmlmind.xmledit.doc.Document;
import com.xmlmind.xmleditapp.dochook.DocumentHookBase;
import com.xmlmind.xmledit.xmlutil.*;
import com.xmlmind.xmledit.util.MiscUtil;
import com.xmlmind.xmledit.edit.Loader;

// To Do:
// Seperate out the actual loading/replacement, since that has to
//  happen when an include PI is added using the editor

public class ExpandRFCPI extends DocumentHookBase {
	private static final Name RFC = Name.get("rfc");
    private InclusionStatus inclusionStatus;
	
	public void documentOpened(Document doc) {
	
		return;
		/*
		System.out.println("documentOpened");
		inclusionStatus = (InclusionStatus)
            doc.getProperty(StandardProperty.INCLUSION_STATUS);

		process((Tree)doc);
		*/
	}
	
	private void process(Tree tree) {
		Node node = tree.getFirstChild();
		while (node != null) {
            Node next = node.getNextSibling();

            switch (node.getNodeType()) {
			case Node.ELEMENT:
				process((Element)node);
				break;
			case Node.PROCESSING_INSTRUCTION:
				if (node.name() == RFC) {
					String piContents = node.data();
					if (piContents.startsWith("include=")) {
						// would like to do better quote handling
						String includedFile = piContents.substring(8).replaceAll("['\"]", "");
						System.out.println("Got an include: " + includedFile);
						
						// XXX to do: check cache, etc etc etc
						Document newdoc = null;
						Loader loader = new Loader();
						// XXX to do: learn catalogs
						try {
							newdoc = loader.load(new URL("http://xml.resource.org/public/rfc/bibxml/" + includedFile + ".xml"));
							if (newdoc == null) {
								newdoc = loader.load(new URL("http://xml.resource.org/public/rfc/bibxml3/" + includedFile + ".xml"));
							}
						} catch ( IOException e ) {
							System.out.println("IOexception: " + MiscUtil.detailedReason(e));
						}
						
						if (newdoc == null) {
							System.out.println("Not handling " + includedFile);
							break;
						}
						
						tree.removeChild(node);
						
						Element included = null;
						Node newnode = newdoc.getFirstChild();
						while (newnode != null) {
							Node newnext = newnode.getNextSibling();
							newdoc.removeChild(newnode);
							tree.insertChild(next, newnode);
							included = (Element)newnode;	// put the property on the last element only?
							newnode = newnext;
						}
						// XXX all that work and you get a runtime cast exception
						//  when you do (Element) on a processing instruction
						included.putProperty(
                                    StandardProperty.INCLUSION_INFO,
                                    new InclusionInfo(
                                        "file:///dev/null",
                                        "", 
                                        (Element)node,
                                        "file:///dev/null"));	
										
						if (inclusionStatus != null && inclusionStatus.managed == null)
							inclusionStatus.managed = "<?rfc " + piContents + "?>";
						
					}
				}
			}
			
			node = next;
		}
	}

}
