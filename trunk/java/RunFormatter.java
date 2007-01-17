//
//  RunFormatter.java
//  xml2rfc
//
//  Created by Bill Fenner on 1/16/07.
//  Copyright 2007 Bill Fenner. All rights reserved.
//
//  $Id$

package com.att.research.fenner.xmleditapp.xml2rfc;

import java.io.*;
import java.awt.Component;
import java.util.Properties;

import com.xmlmind.xmledit.gadget.*;
import com.xmlmind.xmledit.util.*;
import com.xmlmind.xmledit.doc.*;
import com.xmlmind.xmledit.view.DocumentView;
import com.xmlmind.xmledit.guiutil.AWTUtil;
import com.xmlmind.xmledit.guiutil.ShowStatus;
import com.xmlmind.xmledit.guiutil.Alert;

public class RunFormatter implements Command {

	public boolean prepareCommand(Gadget gadget, 
                                  String parameter, int x, int y) {
								  
		DocumentView documentView = (DocumentView)gadget;
        Document document = documentView.getDocument();

		if (document == null)
			return false;
		// check the filename
		// check the format {txt,html,nr,xml}
		return true;
	}

	// the beginning of this is a lot like WebForm.executeCommand().
    public Object executeCommand(Gadget gadget, String parameter, 
                                 int x, int y) {
		
        DocumentView documentView = (DocumentView)gadget;
        Document document = documentView.getDocument();
		Component component = AWTUtil.getFrame(documentView.getPanel());
		
		String[] args = StringUtil.splitArguments(parameter);
		String infile = args[0];
		String format = args.length > 1 ? args[1] : "txt";
		String outfile;
		if (args.length > 2) {
			outfile = args[2];
		} else {
			try {
				File tmpfile = File.createTempFile("xml2rfc-xxe-", "." + format);
				tmpfile.deleteOnExit();
				outfile = tmpfile.toString();
			} catch (java.io.IOException e) {
				Alert.showError(component, "Can't generate temp filename: " + e);
				return null;
			}
		}
		Properties systemProperties = System.getProperties();
		String formatter = systemProperties.getProperty("xml2rfc.formatter", "xml2rfc");
		String[] output = new String[2];

		// XXX think some about this.  Should we have infile at all, or just
		// XXX write out a temp file with the current buffer?
		// XXX (should WebForm do the same thing?)
		// XXX
		int ret;
		ShowStatus.showStatus("Formatting document with " + formatter);

		try {
			ret = PlatformUtil.shellExec(formatter + " '" + infile + "' '" + outfile + "'", output);
		} catch (java.io.IOException e) {
			return null;
		} catch (java.lang.InterruptedException e) {
			return null;
		}
		if (ret == 0) {
			return output[0];
		} else {
			String tmp = "";
			if (output[0].length() > 0) {
				tmp = output[0] + "\n";
			}
			return tmp + output[1];
		}
	}
}
