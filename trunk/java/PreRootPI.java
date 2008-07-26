//
//  PreRootPI.java
//  xml2rfc
//
//  Created by Bill Fenner on 4/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//
package com.att.research.fenner.xmleditapp.xml2rfc;

import java.awt.Component;
import javax.swing.JPanel;
import javax.swing.BorderFactory;
import javax.swing.JTable;
import javax.swing.table.TableColumn;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableCellEditor;
import javax.swing.DefaultCellEditor;
import javax.swing.ListSelectionModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.SwingUtilities;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.JList;
import javax.swing.plaf.basic.BasicComboBoxRenderer;
import java.util.ArrayList;


import com.xmlmind.xml.doc.*;
import com.xmlmind.xml.name.Name;
import com.xmlmind.xmledit.styledgadget.Style;
import com.xmlmind.xmledit.stylesheet.StyleValue;
import com.xmlmind.xmledit.styledview.StyledViewFactory;
import com.xmlmind.xmledit.styledview.ComponentFactory;
import com.xmlmind.xmledit.view.DocumentView;

/* meta to do:
 * PIs can be split into two sets:
 * those that go before the document, and those
 * that go in.  The latter includes needLines, typeout and include.
 * Seperate them here.
 * Also this will probably need lots of refactoring when implementing
 * the in-document code as a widget or small component.
 */
 
/* more meta to do:
 * figure out why the list sometimes notifies the wrong
 *  row after deletions
 */
 
/*
 * Style the Processing Instructions that occur before
 * the root element.
 */
public class PreRootPI implements ComponentFactory, ActionListener, ListSelectionListener {
	private static final Name RFC = Name.get("rfc");

	String[] columnNames = {"Instruction", "Value"};
	private Element rootElement;
	private DocumentView documentView;
	private MyTableModel tablemodel;
	private JTable table;
	private JButton delbutton;
	private ArrayList pis;
	String[] knownPIs = {
			 "autobreaks",
			 "background",
			 "colonspace",
			 "comments",
			 "compact",
			 "editing",
			 "emoticonic",
			 "footer",
			 "header",
			 "include",
			 "inline",
			 "iprnotified",
			 "linkmailto",
			 "linefile",
			 "needLines",
			 "private",
			 "rfcedstyle",
			 "rfcprocack",
			 "slides",
			 "sortrefs",
			 "strict",
			 "subcompact",
			 "symrefs",
			 "toc",
			 "tocappendix",
			 "tocdepth",
			 "tocindent",
			 "tocompact",
			 "tocnarrow",
			 "topblock",
			 "typeout",
			 "useobject" };
	String[] tooltips = {
			 "automatically force page breaks to avoid widows and orphans (not perfect)",
			 "when producing a html file, use this image",
			 "put two spaces instead of one after each colon (“:”) in txt or nroff files",
			 "render <cref> information",
			 "when producing a txt/nroff file, try to conserve vertical whitespace",
			 "insert editing marks for ease of discussing draft versions",
			 "automatically replaces input sequences such as |*text| by, e.g., <strong>text</strong> in html output",
			 "override the center footer string",
			 "override the leftmost header string",
			 "include this file",
			 "if comments is “yes”, then render comments inline; otherwise render them in an “Editorial Comments” section",
			 "include boilerplate from Section 10.4(d) of RFC 2026 [obsolete]", // XXX
			 "generate mailto: URL, as appropriate",
			 "a string like “35:file.xml” or just “35” (file name then defaults to the containing file's real name or to the latest linefile specification that changed it) that will be used to override xml2rfc's reckoning of the current input position (right after this PI) for warning and error reporting purposes (line numbers are 1-based)",
			 "an integer hint indicating how many contiguous lines are needed at this point in the output",
			 "name of private memo rather than an RFC or Internet-Draft",
			 "output closer to RFC-Editor style",
			 "add a short sentence acknowledging that xml2rfc was used in the document's production to process an input XML source file in RFC-2629 format",
			 "when producing a html file, produce multiple files for a slide show",
			 "sort references",
			 "try to enforce the ID-nits conventions and DTD validity",
			 "if compact is “yes”, then you can make things a little less compact by setting this to “no” (the default value is the current value of the compact PI)",
			 "use anchors rather than numbers for references",
			 "generate a table-of-contents",
			 "control whether the word “Appendix” appears in the table-of-content",
			 "if toc is “yes”, then this determines the depth of the table-of-contents",
			 "if toc is “yes”, will indent subsections in the table-of-contents",
			 "if toc is “yes”, then setting this to “no” will make it a little less compact",
			 "if toc is “yes”, then setting this to “yes” will conserve horizontal space in toc",
			 "put the famous header block on the first page",
			 "during processing pass 2, print the value to standard output at that point in processing",
			 "when producing a html file, use the <object> html element with inner replacement content instead of the <img> html element, when a source xml element includes an src attribute" };
			 
	public Component createComponent(Element element,
							  Style style, StyleValue[] parameters,
							  StyledViewFactory viewFactory,
							  boolean[] stretch) {
		// we expect to be called with the root element.
		// Find the document from it.
		Tree document = (Tree)element.document();
		rootElement = element;
		documentView = viewFactory.getDocumentView();
		pis = new ArrayList();
		
		// XXX is "n.compareTo(element)" the best way to do this?
		for (Node n = document.getFirstChild();
			 n != null && n.compareTo(element) < 0;
			 n = n.getNextSibling()) {
			 
			if (n.getType() == Node.Type.PROCESSING_INSTRUCTION &&
				n.name() == RFC) {
				
				pis.add(new RFCPI((ProcessingInstruction)n));
			}
		}
		

		JPanel pane = new JPanel(new BorderLayout());
		pane.setBackground(style.backgroundColor);
		pane.setForeground(style.color);
		pane.setBorder(BorderFactory.createTitledBorder("<?rfc ...?> PIs"));
		
		tablemodel = new MyTableModel();
		table = new JTable(tablemodel);
		table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		table.getSelectionModel().addListSelectionListener(this);
		//
		// undocumented! property to stop editing when you lose focus.
		table.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE);
		pane.add(table.getTableHeader(), BorderLayout.PAGE_START);
		pane.add(table, BorderLayout.CENTER);
		
		TableColumn instructionColumn = table.getColumnModel().getColumn(0);
		JComboBox comboBox = new JComboBox(knownPIs);
		comboBox.setEditable(true);
		comboBox.setRenderer(new MyComboBoxRenderer());
		instructionColumn.setCellEditor(new DefaultCellEditor(comboBox));
		
		// to do: tooltip for current value of column 1 (implement TableCellRenderer?)
		//        column 2's editor depends on the value of column 1
		
		JPanel pane2 = new JPanel(new BorderLayout());
		pane2.setBackground(style.backgroundColor);
		pane2.setForeground(style.color);

		pane.add(pane2, BorderLayout.PAGE_END);
		JButton addbutton = new JButton("Add");
		addbutton.setBackground(style.backgroundColor);
		addbutton.setForeground(style.color);
		addbutton.addActionListener(this);
		addbutton.setActionCommand("add");
		addbutton.setToolTipText("Add a new <?rfc ...?> PI to the table");
		pane2.add(addbutton, BorderLayout.WEST);
		
		delbutton = new JButton("Delete");
		delbutton.setBackground(style.backgroundColor);
		delbutton.setForeground(style.color);
		delbutton.addActionListener(this);
		delbutton.setActionCommand("del");
		delbutton.setToolTipText("Delete the current table row");
		pane2.add(delbutton, BorderLayout.EAST);
		delbutton.setEnabled(false);	// It shouldn't be enabled until there's a selection.
		
		stretch[0] = true;
		
		return pane;
	}
	
	// "Add" or "Delete" button was clicked.
	public void actionPerformed(ActionEvent e) {
		Tree document = (Tree)rootElement.document();

		if ("add".equals(e.getActionCommand())) {
			ProcessingInstruction pi = new ProcessingInstruction("rfc", "???=\"???\"");
			
			document.insertChild(rootElement, pi);
			pis.add(new RFCPI(pi));
			tablemodel.fireTableRowsInserted(pis.size() - 1,pis.size() - 1);
		} else {
			int row = table.getSelectionModel().getMinSelectionIndex();
			if (row >= 0) {
				// If there's an actively edited cell, stop editing first.
				// Otherwise, the editor will remain after the row is deleted,
				// editing the cell that replaces the one being edited.
				TableCellEditor ce = table.getCellEditor();
				if (ce != null)
					ce.cancelCellEditing();

				RFCPI pi = (RFCPI)pis.get(row);
				document.removeChild(pi.pi);
				pis.remove(row);
				tablemodel.fireTableRowsDeleted(row, row);
			}
		}
		// schedule a refresh of the rootElement
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				documentView.refreshView(rootElement);
			}
		});
	}
	
	// Table selection was changed
	public void valueChanged(ListSelectionEvent e) {
		// Ignore extra messages.
		if (e.getValueIsAdjusting())
			return;
		
		ListSelectionModel m = (ListSelectionModel)e.getSource();
		if (m.isSelectionEmpty()) {
			delbutton.setEnabled(false);
		} else {
			delbutton.setEnabled(true);
		}
	}
	
	class MyTableModel extends AbstractTableModel {
		public int getColumnCount() {
			return 2;
		}
		
		public int getRowCount() {
			if (pis != null)
				return pis.size();
			else
				return 0;
		}
		
		public String getColumnName(int col) {
			return columnNames[col];
		}
		
		public Object getValueAt(int row, int col) {
			RFCPI pi = (RFCPI)pis.get(row);
			if (col == 0) {
				return pi.getAttr();
			} else {
				return pi.getValue();
			}
		}
		
		/* to do: public Component getTableCellEditorComponent(JTable table,
                                             Object value,
                                             boolean isSelected,
                                             int row,
                                             int column) */
		
		public boolean isCellEditable(int row, int col) {
			return true;
		}
		
		public void setValueAt(Object value, int row, int col) {
			RFCPI pi = (RFCPI)pis.get(row);
			if (col == 0) {
				pi.setAttr((String)value);
			} else {
				pi.setValue((String)value);
			}
			fireTableCellUpdated(row, col);
		}
	}
	
	// Custom ComboBox renderer to add tool tips.
	class MyComboBoxRenderer extends BasicComboBoxRenderer {
		public Component getListCellRendererComponent(JList list,
									Object value, int index,
									boolean isSelected, boolean cellHasFocus) {
			if (isSelected) {
				setBackground(list.getSelectionBackground());
				setForeground(list.getSelectionForeground());      
				if (-1 < index) {
					list.setToolTipText(tooltips[index]);
				}
			} else {
				setBackground(list.getBackground());
				setForeground(list.getForeground());
			}	
			setFont(list.getFont());
			setText((value == null) ? "" : value.toString());     
			return this;
		}  
	}
	
	class RFCPI {
		// this explicitly fails to handle PIs with multiple pseudo-attributes
		// (it won't damage the 2nd etc, just won't allow editing)
		private String[] attr;
		private ProcessingInstruction pi;
		public RFCPI(ProcessingInstruction node) {
			pi = node;
			attr = pi.getPseudoAttributes();
			if (attr == null || attr.length < 2) {
				// throw
				// what about: string[0] = text if the PI has any
				attr = new String[] { "???", "???" };
			}
		}
		private void update() {
			// per Hussein, the only safe thing to do is
			// to delete the current node and create a new
			// one, to not confuse document listeners.
			Tree document = (Tree)rootElement.document();

			ProcessingInstruction newpi = new ProcessingInstruction("rfc");
			newpi.setPseudoAttributes(attr);
			document.replaceChild(pi, newpi);
			pi = newpi;
		}			
		public void setAttr(String s) {
			if (!s.equals(attr[0])) {
				attr[0] = s;
				update();
			}
		}
		public String getAttr() {
			return attr[0];
		}
		public void setValue(String s) {
			if (!s.equals(attr[1])) {
				attr[1] = s;
				update();
			}
		}
		public String getValue() {
			return attr[1];
		}
	}
}
