//
//  ExpandRFCPI.java
//  xml2rfc
//
//  Created by Bill Fenner on 2/22/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

import com.xmlmind.xmledit.doc.*;
import com.xmlmind.xmleditapp.dochook.DocumentHookBase;
import com.xmlmind.xmledit.xmlutil.*;

// XXX also need to implement processingInstructionChanged() from DocumentListener?

public class ExpandRFCPI extends DocumentHookBase {
	private static final Name RFC = Name.get("rfc");
	
	public void documentOpened(Document doc) {
		// traverse the document, looking for <?rfc include='...'?>
		// If found, add a RFCInclude (which theoretically inherits from
		// XInclude and overrides the option for saving)
	}

}
