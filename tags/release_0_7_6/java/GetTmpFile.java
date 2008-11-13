//
//  GetTmpFile.java
//  xml2rfc
//
//  Created by Bill Fenner on 1/17/07.
//  Copyright 2007 Bill Fenner. All rights reserved.
//  $Id$

package com.att.research.fenner.xmleditapp.xml2rfc;

import java.io.File;
import java.awt.Component;

import com.xmlmind.xmledit.gadget.*;
import com.xmlmind.util.StringUtil;
import com.xmlmind.xml.doc.Document;
import com.xmlmind.xmledit.view.DocumentView;
import com.xmlmind.guiutil.AWTUtil;
import com.xmlmind.guiutil.Alert;

public class GetTmpFile implements Command {

	public boolean prepareCommand(Gadget gadget, 
                                  String parameter, int x, int y) {
		// No prerequisites to run
		DocumentView documentView = (DocumentView)gadget;
        Document document = documentView.getDocument();

		return (document != null);
	}

    public Object executeCommand(Gadget gadget, String parameter, 
                                 int x, int y) {
        DocumentView documentView = (DocumentView)gadget;
        Document document = documentView.getDocument();
		Component component = AWTUtil.getFrame(documentView.getPanel());
		
		String[] args = StringUtil.splitArguments(parameter);
		String format = args[0];
		File tmpfile;
		try {
			tmpfile = File.createTempFile("xml2rfc-xxe-", "." + format);
		} catch (java.io.IOException e) {
			Alert.showError(component, "Can't generate temp filename: " + e);
			return null;
		}
		tmpfile.deleteOnExit();
		return tmpfile.toString();
	}
}
