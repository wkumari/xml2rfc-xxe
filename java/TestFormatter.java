//
//  TestFormatter.java
//  xml2rfc
//
//  Created by Bill Fenner on 1/16/07.
//  Copyright 2007 Bill Fenner. All rights reserved.
//  $Id$

package com.att.research.fenner.xmleditapp.xml2rfc;

import java.util.Properties;

import com.xmlmind.xmledit.gadget.*;
import com.xmlmind.util.*;
import com.xmlmind.xml.doc.Document;
import com.xmlmind.xmledit.view.DocumentView;
import com.xmlmind.guiutil.AWTUtil;
import com.xmlmind.guiutil.ShowStatus;
import com.xmlmind.guiutil.Alert;

public class TestFormatter implements Command {

    String result = null;
	
	public boolean prepareCommand(Gadget gadget, 
                                  String parameter, int x, int y) {
		// No prerequisites to run
		DocumentView documentView = (DocumentView)gadget;
        Document document = documentView.getDocument();

		return (document != null);
	}

    public Object executeCommand(Gadget gadget, String parameter, 
                                 int x, int y) {
		if (result != null) {
			return result;
		}
		String[] output = new String[2];
		int ret;
		Properties systemProperties = System.getProperties();
		String formatter = systemProperties.getProperty("xml2rfc.formatter", "xml2rfc");
		try {
			ret = SystemUtil.shellExec(formatter, output);
		} catch (java.io.IOException e) {
			return null;
		} catch (java.lang.InterruptedException e) {
			return null;
		}
		if (ret == 0 && output[0].startsWith("invoke as \"xml2rfc")) {
			result = "ok";
		} else if (output[1].length() > 0) {
		    result = output[1];
		} else {
			result = "bad";
		}
		return result;
    }
}
