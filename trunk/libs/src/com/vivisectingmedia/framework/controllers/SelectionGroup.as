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
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	public class SelectionGroup
	{
		
		// PUBLIC VARIABLES
		// PROTECTED VARIABLES
		
		// PRIVATE VARIABLES
		private var __groupId:int;
		private var _eventString:String;
		private var _events:Array;
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
		 * Returns the comma seperated list of events used by this
		 * group.
		 * 
		 * @return Comma seperated list of events.
		 */
		public function get events():String {
			return _eventString;
		}
		
		/**
		 * Property sets the events that the group will listen to in
		 * order to make it's selection of an item. This property
		 * can only be set once. An error will be thrown
		 * if it is set multiple times.
		 * Also the property must be set before items are set. Items
		 * require events to be defined and can not be adjusted after the 
		 * fact.
		 *  
		 * @param value Comma seperated list of events.
		 */
		public function set events(value:String):void {
			if(_eventString) {
				throw new Error("Events can only be set once");
			}
			else if(this.items.length > 0) {
				throw new Error("Events must be set before items are set");
			}
			
			_eventString = value;
			// Remove spaces in between the commas and then split by commas
			_events = value.replace(/(\s)+,/, ",").replace(/,(\s)+/,",").split(",");
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
			// Set events
			var events:Array = (_events && events.length > 0) ? _events : [MouseEvent.CLICK];
			var eventLen:uint = events.length;
			
			// Remove event listeners
			
			var itemLen:uint = items.length;
			// Loop through all items currently in the group
			for(var x:uint; x<itemLen;x++) {
				// Loop through all events available
				for(var i:uint; i < eventLen;i++) {
					IEventDispatcher(items[x]).removeEventListener(events[i], handleSelection);
				}
			}	
			
			// Deselect all items before clearing
			SelectionController.deselectAll(this.__groupId);
			
			// Clear all items
			SelectionController.removeAllItems(this.__groupId);

			// Add all new targets
			
			var valueLen:uint = values.length;
			// Loop through all items currently in the group
			for(x = 0; x < valueLen;x++) {
				if(values[x] != null) {
					// Loop through all events available
					for(i = 0; i < eventLen;i++) {
						IEventDispatcher(values[x]).addEventListener(events[i], handleSelection);
					}
					SelectionController.addItem(values[x], this.__groupId);
				}
			}	
		}
		
		public function handleSelection(event:Event):void {
			SelectionController.selectItem(ISelectable(event.currentTarget));
		}

	}
}