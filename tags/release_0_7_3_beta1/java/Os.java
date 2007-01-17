//
//  Os.java
//  xml2rfc
//
//  Created by Bill Fenner on 3/22/05.
//  Copyright 2005 Bill Fenner. All rights reserved.
//

package com.att.research.fenner.xmleditapp.xml2rfc;

import com.xmlmind.xmledit.gadget.Command;
import com.xmlmind.xmledit.gadget.Gadget;
import com.xmlmind.xmledit.util.*;

/**
 * Implements a Command parallel to a &ltprocess>'s &ltshell platform=""> -
 * is executable if running on the platform passed as the parameter, or
 * if no parameter; always returns the platform name.
 *
 * @param  platform Check if we're running on this platform
 * @return          The platform name
 */
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
