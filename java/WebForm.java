//
//  WebForm.java
//  xml2rfc
//
//  Created by Bill Fenner on Thu Feb 17 2005.
//  Copyright (c) 2005 Bill Fenner. All rights reserved.
//

package com.att.research.fenner.xmleditapp.xml2rfc;

import java.io.*;
import java.net.*;
import java.awt.Component;
import com.xmlmind.xmledit.gadget.*;
import com.xmlmind.xmledit.util.*;
import com.xmlmind.xmledit.doc.*;
import com.xmlmind.xmledit.view.DocumentView;
import com.xmlmind.xmledit.awtutil.AWTUtil;
import com.xmlmind.xmledit.dialog.CommonDialog;


public class WebForm implements Command {
	
    public boolean prepareCommand(Gadget gadget, 
                                  String parameter, int x, int y) {
								  
		// check the filename
		// check the format {txt,html,nr,xml}
		return true;
	}
	
    public Object executeCommand(Gadget gadget, String parameter, 
                                 int x, int y) {
		
        DocumentView documentView = (DocumentView)gadget;
        Document document = documentView.getDocument();
		Component component = AWTUtil.getFrame(documentView.getPanel());

		HttpURLConnection conn = null;
		
		String[] args = StringUtil.splitArguments(parameter);
		String infile = args[0];
		String format = args.length > 1 ? args[1] : "txt";
		String outfile = args.length > 2 ? args[2] : PlatformUtil.tmpFileName("." + format);
		
		String lineEnd = "\r\n";
		String twoHyphens = "--";
		String boundary =  "myMIMEboundaryFORthisWEBform";
		
		
		int bytesRead, bufferSize;
		
		byte[] buffer;
		
		int maxBufferSize = 1*1024*1024;
		
		String urlString = "http://xml.resource.org/cgi-bin/xml2rfc.cgi";
		
		if (infile.equals(outfile)) {
			CommonDialog.showError(component, "Refusing to overwrite input file, please pick a different output filename");
			return null;
		}
		
		CommonDialog.showStatus("Submitting document to " + urlString);

		try
		{
			URL url = new URL(urlString);
			
			conn = (HttpURLConnection) url.openConnection();
			conn.setDoInput(true);
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			
			conn.setRequestProperty("Content-Type", "multipart/form-data;boundary="+boundary);
			conn.setRequestProperty("User-Agent", "xml2rfc-xxe-WebForm/0.2");
			
			conn.connect();
			CommonDialog.showStatus("Uploading XML document");
			
			// Get the stream to post the document to the form
			PrintStream post = new PrintStream(conn.getOutputStream());
			
			// Create form answers - mode={txt,html,nr,xml} and type={ascii,binary}
			//
			post.print(twoHyphens + boundary + lineEnd);
			post.print("Content-Disposition: form-data; name=\"mode\"" + lineEnd);
			post.print(lineEnd);
			post.print(format + lineEnd);
			
			post.print(twoHyphens + boundary + lineEnd);
			post.print("Content-Disposition: form-data; name=\"type\"" + lineEnd);
			post.print(lineEnd);
			post.print("binary" + lineEnd);
			
			post.print(twoHyphens + boundary + lineEnd);
			post.print("Content-Disposition: form-data; name=\"input\";"
						   + " filename=\"" + infile +"\"" + lineEnd);
			post.print("Content-Type: text/xml" + lineEnd);
			post.print(lineEnd);
			
			// Write the document in the edit buffer to the web server.
			DocumentWriter writer = new DocumentWriter();
			writer.setEncoding("US-ASCII");	// xml2rfc only supports entities, not UTF-8.
			writer.setPreserveInclusions(0);	// if we've loaded included files already,
												// send them along instead of turning them back
												// into entities or XIncludes.
			// could setCdataSectionElements but CDATA is really for presentation
			//  and this isn't presentation.
			writer.writeDocument(document, post);
						
			// Finish the MIME part
			post.print(lineEnd);
			post.print(twoHyphens + boundary + twoHyphens + lineEnd);
			
			post.flush();
			post.close();
		}
		catch (MalformedURLException ex)
		{
			CommonDialog.showError(component, "Internal Error" + ex);
			return null;
		}
		
		catch (IOException ioe)
		{
			CommonDialog.showError(component, "Upload Error" + ioe);
			return null;
		}
		
		CommonDialog.showStatus("Waiting for conversion");

		
		
		//------------------ read the SERVER RESPONSE
		
		
		try
		{
			if (conn.getResponseCode() != 200) {
				CommonDialog.showError(component, "HTTP Error: " + conn.getResponseMessage());
				return null;
			}
			// Assumption: content-type text/html is an error return,
			// anything else is the result that we want to save.
			if ("text/html".equals(conn.getContentType())) {
				// XXX Get charset from conn instead of hardcoding
				String html = FileUtil.loadString(conn.getInputStream(), "iso8859-1");
				CommonDialog.showErrorHTML(component, "Conversion Failed", html, 600, 250);
				return null;
			}
			CommonDialog.showStatus("Downloading result");

			//
			// Line-based copying to convert to native line endings.
			PrintStream out = new PrintStream(new FileOutputStream(new File(outfile)));
			BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			
			while ((line = in.readLine()) != null) {
				out.println(line);
			}
			in.close();
			out.close();
		}
		catch (IOException ioe)
		{
			CommonDialog.showError(component, "Download Error" + ioe);
			return null;
		}
		CommonDialog.showStatus("Conversion using " + urlString + " complete.");
		CommonDialog.showInfo(component, "Conversion Completed, output in " + outfile);
		return outfile;
		
}

}
