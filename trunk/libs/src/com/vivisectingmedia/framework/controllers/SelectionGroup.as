/* ***** BEGIN MIT LICENSE BLOCK *****
 * 
 * Copyright (c) 2008 DevelopmentArc
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * ***** END MIT LICENSE BLOCK ***** */
package com.vivisectingmedia.framework.controllers
{
	import com.vivisectingmedia.framework.controllers.interfaces.ISelectable;
	
	public class SelectionGroup
	{
		
		// PUBLIC VARIABLES
		// PROTECTED VARIABLES
		
		// PRIVATE VARIABLES
		private var __groupId:int;
		
		// PRIVATE GET/SET VARIABLES
		
		public function SelectionGroup()
		{
			// Generate new Id for group
			this.__groupId = SelectionController.generateNewId();
		}
		
		// PUBLIC METHODS
		/**
		 * Method takes an ISelectable item and adds the item to the selection
		 * group.
		 * 
		 * @param item Item to be added to the selection group.
		 */
		public function addItem(item:ISelectable):void {
			SelectionController.addItem(item, this.__groupId);
		}
		
		public function removeItem(item:ISelectable):void {
			SelectionController.removeItem(item);
		}
		// PROTECTED METHODS
		
		// PRIVATE METHODS

		// GET/SET METHODS

		public function get groupId():int {
			return __groupId;
		}
		public function set groupId(groupId:int):void {
			throw Error("Read only property");
		}
		/**
		 * Variable holds all items currently in the group
		 * 
		 * @returns Array All items in the group
		 */
		public function get items():Array {
			return SelectionController.getAllItemsInGroup(this.__groupId);
		}
		/**
		 * Variable resets all items in the group with the new array provided
		 * 
		 * @param values Array containing all items to be included in the group
		 */
		public function set items(values:Array):void {
			// Deselect all items before clearing
			SelectionController.deselectAll(this.__groupId);
				
			// Clear all items
			SelectionController.removeAllItems(this.__groupId);

			// Add all new targets
			for(var i:uint;i<values.length;i++) {
				SelectionController.addItem(values[i], this.__groupId);
			}
		}

	}
}