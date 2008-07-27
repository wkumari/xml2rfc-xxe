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
import java.util.Properties;
import java.awt.Component;
import com.xmlmind.xmledit.gadget.*;
import com.xmlmind.util.*;
import com.xmlmind.xml.doc.Document;
import com.xmlmind.xml.save.DocumentWriter;
import com.xmlmind.xmledit.view.DocumentView;
import com.xmlmind.guiutil.AWTUtil;
import com.xmlmind.guiutil.ShowStatus;
import com.xmlmind.guiutil.Alert;
import com.xmlmind.netutil.AuthenticationDialog;


public class WebForm implements Command {
	public class GuiAuthenticator extends Authenticator {						 
		Component component;	// xxe component for this dialog
		
		public GuiAuthenticator(Component c)
		{
			component = c;
		}
		
		protected PasswordAuthentication getPasswordAuthentication()
		{
			AuthenticationDialog.Info info;
			AuthenticationDialog ad;
			
			ad = new AuthenticationDialog(component);
			info = new AuthenticationDialog.Info();
			info.userName = null;
			info.password = null;
			info.prompt = getRequestingPrompt() + " (no saving)";
			info.save = false;
			info = ad.getPassword(info);
			if (info != null) {
				return new PasswordAuthentication(info.userName,info.password);
			} else {
				return null; // is this the right "cancel" action?
			}
		}
	}

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
	
    public Object executeCommand(Gadget gadget, String parameter, 
                                 int x, int y) {
		
        DocumentView documentView = (DocumentView)gadget;
        Document document = documentView.getDocument();
		Component component = AWTUtil.getFrame(documentView.getPanel());

		HttpURLConnection conn = null;
		
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
		
		String lineEnd = "\r\n";
		String twoHyphens = "--";
		String boundary =  "myMIMEboundaryFORthisWEBform";
		
		
		int bytesRead, bufferSize;
		
		byte[] buffer;
		
		int maxBufferSize = 1*1024*1024;
		
		Properties systemProperties = System.getProperties();

		String urlString = systemProperties.getProperty("xml2rfc.cgi", "http://xml.resource.org/cgi-bin/xml2rfc.cgi");

		// System.getenv is deprecated (well, it became undeprecated in 1.5,
		// because, surprise surprise, Properties failed to take over the
		// world).  Some (all?) JREs before 1.5 throw an Error if you dare to try to
		// use it, so we have to try this whole block.  Of course, Sun says
		// that reasonable applications don't catch Error, so we get to be
		// unreasonable about this, yay!
		try {
			//XXX
			//System.err.println("http.proxyHost property = " + systemProperties.getProperty("http.proxyHost"));
			//System.err.println("http_proxy env var = " + System.getenv("http_proxy"));
			if (systemProperties.getProperty("http.proxyHost") == null &&
				System.getenv("http_proxy") != null) {
				URL proxyurl = new URL(System.getenv("http_proxy"));
				if ("http".equals(proxyurl.getProtocol())) {
					int port = proxyurl.getPort();
					systemProperties.setProperty("http.proxyHost", proxyurl.getHost());
					if (port != -1) {
						systemProperties.setProperty("http.proxyPort", Integer.toString(port));
					}
				}
			}
		} catch (Error e) {
			// Assume it's java.lang.Error: getenv no longer supported.
			// Write it to stderr just in case.
			System.err.println("Not trying to use ${http_proxy} environment variable: " + e);
		} catch (MalformedURLException e) {
			// ${http_proxy} isn't a URL; can't do anything about it.
		}

		// Use GUI authenticator if the proxy asks for a password.
		// XXX This is already done by the main code?... Authenticator.setDefault(new GuiAuthenticator(component));
		
		if (infile.equals(outfile)) {
			Alert.showError(component, "Refusing to overwrite input file, please pick a different output filename");
			return null;
		}
		
		ShowStatus.showStatus("Submitting document to " + urlString);

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
			ShowStatus.showStatus("Uploading XML document");
			
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
			Writer out = new BufferedWriter(new OutputStreamWriter(post));

			DocumentWriter writer = new DocumentWriter(out);
			writer.setEncoding("US-ASCII");	// xml2rfc only supports entities, not UTF-8.
			writer.setPreserveInclusions(false);	// if we've loaded included files already,
													// send them along instead of turning them back
													// into entities or XIncludes.
			// could setCdataSectionElements but CDATA is really for presentation
			//  and this isn't presentation.
			writer.write(document);
						
			// Finish the MIME part
			post.print(lineEnd);
			post.print(twoHyphens + boundary + twoHyphens + lineEnd);
			
			post.flush();
			post.close();
		}
		catch (MalformedURLException ex)
		{
			ShowStatus.showStatus("Internal Error: " + ex);
			Alert.showError(component, "Internal Error\n\n" + ex);
			return null;
		}
		
		catch (IOException ioe)
		{
			ShowStatus.showStatus("Upload Error: " + ioe);
			Alert.showError(component, "Upload Error\n\n" + ioe);
			return null;
		}
		
		ShowStatus.showStatus("Waiting for conversion");

		
		
		//------------------ read the SERVER RESPONSE
		
		
		try
		{
			if (conn.getResponseCode() != 200) {
				Alert.showError(component, "HTTP Error: " + conn.getResponseMessage());
				return null;
			}
			// Assumption: content-type text/html is an error return,
			// anything else is the result that we want to save.
			if ("text/html".equals(conn.getContentType())) {
				// XXX Get charset from conn instead of hardcoding
				String html = FileUtil.loadString(conn.getInputStream(), "iso8859-1");
				ShowStatus.showStatus("Conversion Failed");
				Alert.showErrorHTML(component, "Conversion Failed", html, 600, 250);
				return null;
			}
			ShowStatus.showStatus("Downloading result");

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
			ShowStatus.showStatus("Download Error: " + ioe);
			Alert.showError(component, "Download Error\n\n" + ioe);
			return null;
		}
		ShowStatus.showStatus("Conversion using " + urlString + " completed, output in " + outfile);
		return outfile;
		
}

}
