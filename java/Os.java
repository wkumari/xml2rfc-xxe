//
//  Os.java
//  xml2rfc
//
// (these should be class javadoc comments)
//  Implement a command parallel to a process's <shell platform=> -
//    os <platform> is executable if we're running on that platform;
//    os with no arguments is always executable and returns the platform
//  Created by Bill Fenner on 3/22/05.
//  Copyright 2005 Bill Fenner. All rights reserved.
//

package com.att.research.fenner.xmleditapp.xml2rfc;

import com.xmlmind.xmledit.gadget.Command;
import com.xmlmind.xmledit.gadget.Gadget;
import com.xmlmind.xmledit.util.*;

public class Os implements Command {

    public boolean prepareCommand(Gadget gadget, 
                                  String parameter, int x, int y) {
		if ("".equals(parameter)) {
			return true;
		}
		switch (PlatformUtil.PLATFORM) {
		case PlatformUtil.WINDOWS:
			if ("windows".equals(parameter)) {
				return true;
			}
			return false;
		case PlatformUtil.MAC_OS:
			if ("mac".equals(parameter) || "unix".equals(parameter)) {
				return true;
			}
			return false;
		case PlatformUtil.GENERIC_UNIX:
			if ("genericunix".equals(parameter) || "unix".equals(parameter)) {
				return true;
			}
			return false;
		}
		return false;
	}

    public Object executeCommand(Gadget gadget, String parameter, 
                                 int x, int y) {
		switch (PlatformUtil.PLATFORM) {
		case PlatformUtil.WINDOWS:
			return "Windows";
		case PlatformUtil.MAC_OS:
			return "Mac";
		case PlatformUtil.GENERIC_UNIX:
			return "GenericUnix";
		default:
			return "Unknown";
		}
	}



}
