/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is ActionScript 3 SelectionObject version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.libtests.elements.selectiongroup
{
	import com.vivisectingmedia.framework.controllers.interfaces.ISelectable;
	
	import flexunit.framework.Assert;

	/**
	 * This is a test element that is used to verify selection functionality.  The SelectionOjbect implements
	 * the ISelectableObject interface allowing it to be used in the SelectionController.
	 * 
	 * @author James Polanco
	 * 
	 */
	public class SelectionObject implements ISelectable
	{
		private var __selected:Boolean = false;
		
		/**
		 * Constructor 
		 * 
		 */
		public function SelectionObject()
		{
		}

		/**
		 * The selected value is true for selected and false for deselected.
		 *  
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void
		{
			__selected = value;
		}
		
		public function get selected():Boolean
		{
			return __selected;
		}
		
	}
}