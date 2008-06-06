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
 * The Original Code is ActionScript 3 ISelectable version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.framework.controllers.interfaces
{
	/**
	 * This Interface enables any object to become selectable and can be used within the SelectionController
	 * class.
	 * 
	 * @author James Polanco
	 * 
	 */
	public interface ISelectable
	{
		/**
		 * A read/write method that is used to set the selected state of an ISelectable item.
		 * When a value of true is passed the item should be considered selected.  When a value
		 * if false is passed the item should be considered deselected.
		 *  
		 * @param value The selected state of the ISelectable item.
		 * 
		 */
		function set selected(value:Boolean):void
		
		function get selected():Boolean
	}
}