package com.vivisectingmedia.framework.controllers.abstracts
{
	import com.vivisectingmedia.framework.controllers.SelectionGroup;
	import com.vivisectingmedia.framework.controllers.interfaces.ISelectableGroup;
	
	import mx.core.UIComponent;

	public class AbstractSelectableGroupItem extends UIComponent implements ISelectableGroup
	{
		
		// PUBLIC PROPERTIES
		
		// PROTECTED PROPERTIES
		
		// PRIVATE PROPERTIES
		
		// PRIVATE GET/SET PROPERTIES
		private var __selectionGroup:SelectionGroup;
		
		public function AbstractSelectableGroupItem() {
			super();
		}
		
		/**
		 * Property is can only be set one time.  Once set, the second attempt will throw a 
		 * general error
		 */
		public function set group(value:SelectionGroup):void {
			if(this.__selectionGroup) {
				throw new Error("SelectionGroup has already been set");
			}
			// Hold reference
			this.__selectionGroup = value;
			// Set this class as an item of the group
			this.__selectionGroup.addItem(this);
		}
		
		public function get group():SelectionGroup {
			return __selectionGroup;
		}
		
		public function set selected(value:Boolean):void {
			throw new Error("Child must define set selected()");
		}
		
		public function get selected():Boolean {
			throw new Error("Child must define get selected()");
			return false;
		}
		
	}
}